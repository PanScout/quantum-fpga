import numpy as np
import pigpio
import time
import atexit
import signal
import sys

def matrix_to_string(arr):
    """
    Convert a NumPy array (matrix) of real or complex numbers into a single string representation
    in sfixed(14 downto -21) format for each element. For complex numbers, both real and imaginary parts
    are represented (72 bits total per element), and for real numbers, the imaginary part is set to zero.
    
    The format for each real (or imaginary) part is:
      - 1 sign bit
      - 14 bits for the integer part (positions 14 downto 1)
      - 21 bits for the fractional part (positions -1 downto -21)
    Thus, each number is represented by 36 bits, and a complex number by 72 bits.
    
    Args:
        arr (numpy.ndarray): Input array of numbers (real or complex).
        
    Returns:
        str: A single string containing the concatenated sfixed representations of all elements.
    """
    # Create an empty array to store the string representations
    result = np.empty(arr.shape, dtype=object)
    
    # Iterate over every element in the array
    for idx, val in np.ndenumerate(arr):
        if np.iscomplex(val):
            # Process the real part of a complex number
            real_val = val.real
            real_sign_bit = '1' if real_val < 0 else '0'
            real_abs_val = abs(real_val)
            real_int_part = int(real_abs_val)
            real_int_bits = format(real_int_part, '014b')[-14:]  # last 14 bits if needed
            
            real_frac_part = real_abs_val - real_int_part
            real_frac_bits = ''
            for _ in range(21):
                real_frac_part *= 2
                bit = '1' if real_frac_part >= 1 else '0'
                real_frac_bits += bit
                if real_frac_part >= 1:
                    real_frac_part -= 1
            
            # Process the imaginary part
            imag_val = val.imag
            imag_sign_bit = '1' if imag_val < 0 else '0'
            imag_abs_val = abs(imag_val)
            imag_int_part = int(imag_abs_val)
            imag_int_bits = format(imag_int_part, '014b')[-14:]
            
            imag_frac_part = imag_abs_val - imag_int_part
            imag_frac_bits = ''
            for _ in range(21):
                imag_frac_part *= 2
                bit = '1' if imag_frac_part >= 1 else '0'
                imag_frac_bits += bit
                if imag_frac_part >= 1:
                    imag_frac_part -= 1
            
            # Combine both parts into a 72-bit string (36 bits each)
            result[idx] = f"{real_sign_bit}{real_int_bits}{real_frac_bits}" \
                          f"{imag_sign_bit}{imag_int_bits}{imag_frac_bits}"
        else:
            # Process a real number
            sign_bit = '1' if val < 0 else '0'
            abs_val = abs(val)
            int_part = int(abs_val)
            int_bits = format(int_part, '014b')[-14:]
            
            frac_part = abs_val - int_part
            frac_bits = ''
            for _ in range(21):
                frac_part *= 2
                bit = '1' if frac_part >= 1 else '0'
                frac_bits += bit
                if frac_part >= 1:
                    frac_part -= 1
            
            # For real numbers, use a 36-bit zero for the imaginary part
            imag_sign_bit = '0'
            imag_int_bits = '0' * 14
            imag_frac_bits = '0' * 21
            
            result[idx] = f"{sign_bit}{int_bits}{frac_bits}" \
                          f"{imag_sign_bit}{imag_int_bits}{imag_frac_bits}"
    
    # Concatenate all string representations into one single string
    flattened = result.flatten()
    return ''.join(flattened)


def convert_72bit_to_sfixed(bitstr: str):
    """
    Convert a 72-bit string to two sfixed(14,-21) values.

    The input string should be exactly 72 characters long, consisting of '0' or '1'.
    It is split into two 36-bit parts:
      - Upper 36 bits (bits 71 downto 36)
      - Lower 36 bits (bits 35 downto 0)
    
    Each 36-bit part is interpreted as a two's complement signed integer and then
    scaled by 2^-21 to represent the VHDL fixed point format sfixed(14,-21).

    Parameters:
        bitstr (str): A 72-bit string.

    Returns:
        tuple: (upper_value, lower_value) as the converted fixed-point numbers (floats).
    """
    if len(bitstr) != 72:
        raise ValueError("Input must be a 72-bit string.")

    # Split the string into two 36-bit halves
    upper_bits = bitstr[:36]
    lower_bits = bitstr[36:]

    def bits_to_sfixed(bits: str) -> float:
        # Convert the 36-bit string (in two's complement) to an integer.
        if bits[0] == '1':  # Negative number in two's complement
            value = int(bits, 2) - (1 << 36)
        else:
            value = int(bits, 2)
        # Scale the integer by 2^-21 (to get the fixed point value)
        return value * (2 ** -21)

    upper_value = bits_to_sfixed(upper_bits)
    lower_value = bits_to_sfixed(lower_bits)

    return upper_value, lower_value




class Communications:
    # Class constants for GPIO pins
    SlaveSelect = 22 
    MasterInSlaveOut = 23
    MasterOutSlaveIn = 24
    SerialClock = 25
    
    # Add clock frequency class attribute (in Hz)
    ClockFrequency = 1  # Default to 0.33 Hz (3 seconds per cycle)
    
    def __init__(self, DimensionOfMatrix=4):
        """
        Initialize the Communications object.
        
        Args:
            DimensionOfMatrix (int): Dimension of the matrix to be processed. Default is 4.
        """
        self.DimensionOfMatrix = DimensionOfMatrix
        
        # Initialize cleanup flag to prevent double cleanup
        self._cleaned_up = False
        
        # Initialize pigpio connection
        self.pi = pigpio.pi()
        if not self.pi.connected:
            print("Failed to connect to pigpio daemon")
            exit()
        
        # Initialize GPIO pins
        self.pi.set_mode(self.SlaveSelect, pigpio.OUTPUT)
        self.pi.set_mode(self.MasterInSlaveOut, pigpio.OUTPUT)
        self.pi.set_mode(self.MasterOutSlaveIn, pigpio.INPUT)
        self.pi.set_mode(self.SerialClock, pigpio.OUTPUT)
        
        # Set default states
        self.pi.write(self.SlaveSelect, 1)      # Inactive (HIGH)
        self.pi.write(self.MasterInSlaveOut, 0) # Default LOW
        self.pi.write(self.SerialClock, 0)      # Default LOW
        
        # Register cleanup methods
        atexit.register(self.cleanup)
        
        # Register signal handlers for various termination signals
        signal.signal(signal.SIGINT, self._signal_handler)   # Ctrl+C
        signal.signal(signal.SIGTERM, self._signal_handler)  # kill command
        
        # For SIGTSTP (Ctrl+Z), override default suspension behavior
        signal.signal(signal.SIGTSTP, self._signal_handler)
        
        # Handle terminal close if available
        try:
            signal.signal(signal.SIGHUP, self._signal_handler)  # Terminal closed
        except AttributeError:
            # SIGHUP might not be available on all platforms (like Windows)
            pass
            
        print("Communications initialized - press Ctrl+C to safely exit")
    
    def _signal_handler(self, sig, frame):
        """
        Handle termination signals by cleaning up and exiting.
        
        Args:
            sig: Signal number
            frame: Current stack frame
        """
        signal_names = {
            signal.SIGINT: "SIGINT (Ctrl+C)",
            signal.SIGTERM: "SIGTERM",
            signal.SIGTSTP: "SIGTSTP (Ctrl+Z)",
        }
        
        if hasattr(signal, "SIGHUP"):
            signal_names[signal.SIGHUP] = "SIGHUP (Terminal closed)"
            
        sig_name = signal_names.get(sig, f"Signal {sig}")
        print(f"\nReceived {sig_name}, performing cleanup...")
        
        # Call cleanup and exit
        self.cleanup()
        sys.exit(0)
    
    def cleanup(self, verbose=True, custom_pins=None):
        """
        Clean up GPIO resources safely. 
        Ensures all pins are reset to safe states and all resources are released.

        Args:
            verbose (bool): If True, print detailed logs. Default is True.
            custom_pins (list): Optional list of additional pins to clean up.

        Returns:
            bool: True if cleanup was successful, False if errors occurred
        """
        # Prevent double cleanup
        if hasattr(self, '_cleaned_up') and self._cleaned_up:
            if verbose:
                print("Cleanup already performed, skipping.")
            return True

        if verbose:
            print("Starting comprehensive GPIO cleanup...")

        # Import required modules if not already available
        import time

        # Track whether any errors occurred during cleanup
        cleanup_error = False

        # Define pins used by this class
        pins_used = [self.SlaveSelect, self.MasterInSlaveOut, self.MasterOutSlaveIn, self.SerialClock]

        # Add custom pins if provided
        if custom_pins:
            pins_used.extend(custom_pins)
            pins_used = list(set(pins_used))  # Remove duplicates

        # Define pins to skip - these may have special functions or be reserved
        special_pins = [0, 1]  # GPIO 0 and 1 are often used for ID EEPROM

        # Define all possible GPIO pins (covers all Raspberry Pi models)
        all_gpio_pins = [pin for pin in range(2, 28) if pin not in special_pins]

        # Add more pins for newer Raspberry Pi models
        if hasattr(self, 'pi') and self.pi.connected:
            try:
                # Try to get hardware revision to determine pin range
                hardware_revision = self.pi.get_hardware_revision()
                if hardware_revision >= 0xa02082:  # Raspberry Pi 3B and newer
                    all_gpio_pins.extend([pin for pin in range(28, 46) if pin not in special_pins])
                if verbose:
                    print(f"Detected hardware revision: {hex(hardware_revision)}")
            except Exception:
                # If we can't get the hardware revision, use a conservative approach
                if verbose:
                    print("Could not determine hardware revision, using default pin range")

        # Phase 1: Reset pins to safe states
        if hasattr(self, 'pi'):
            try:
                if self.pi.connected:
                    if verbose:
                        print("Phase 1: Resetting pins to safe states...")

                    # Short delay to ensure operations can complete
                    time.sleep(0.05)

                    # Reset specific pins used by this class to their appropriate safe states
                    pin_safe_states = {
                        self.SlaveSelect: 1,       # Inactive (HIGH)
                        self.MasterInSlaveOut: 0,  # Default LOW
                        self.SerialClock: 0        # Default LOW
                    }

                    for pin, state in pin_safe_states.items():
                        try:
                            # Set pin to output mode if it isn't already
                            current_mode = self.pi.get_mode(pin)
                            if current_mode != pigpio.OUTPUT:
                                self.pi.set_mode(pin, pigpio.OUTPUT)
                                time.sleep(0.01)

                            # Set to safe state
                            self.pi.write(pin, state)
                            time.sleep(0.01)

                            # Verify the pin state changed
                            if self.pi.read(pin) != state:
                                if verbose:
                                    print(f"Warning: Pin {pin} didn't change to expected state {state}")
                                cleanup_error = True
                        except Exception as e:
                            if verbose:
                                print(f"Error setting pin {pin} to safe state: {e}")
                            cleanup_error = True

                    if verbose:
                        print("Specific pins reset to safe states.")
                else:
                    if verbose:
                        print("Cannot reset pins: pigpio daemon not connected")
                    cleanup_error = True
            except Exception as e:
                if verbose:
                    print(f"Error resetting pins to safe states: {e}")
                cleanup_error = True

        # Phase 2: Release all pins by setting them to input mode with pull-down
        if hasattr(self, 'pi'):
            try:
                if self.pi.connected:
                    if verbose:
                        print("Phase 2: Releasing pins...")

                    # First release the specific pins used by this class
                    for pin in pins_used:
                        try:
                            # Set to input mode (safest mode)
                            self.pi.set_mode(pin, pigpio.INPUT)
                            time.sleep(0.01)  # Small delay

                            # Verify mode changed
                            if self.pi.get_mode(pin) != pigpio.INPUT:
                                if verbose:
                                    print(f"Warning: Pin {pin} didn't change to INPUT mode")
                                cleanup_error = True

                            # Set internal pull-down to ensure pin is not floating
                            self.pi.set_pull_up_down(pin, pigpio.PUD_DOWN)
                            time.sleep(0.01)  # Small delay

                            if verbose:
                                print(f"Pin {pin} released")
                        except Exception as e:
                            if verbose:
                                print(f"Error releasing pin {pin}: {e}")
                            cleanup_error = True

                    # Then check for any other pins that might have been set to OUTPUT
                    for pin in all_gpio_pins:
                        if pin not in pins_used:  # Skip pins we've already handled
                            try:
                                mode = self.pi.get_mode(pin)
                                if mode == pigpio.OUTPUT:
                                    # If the pin is set to OUTPUT, reset it
                                    self.pi.write(pin, 0)  # Set to LOW
                                    time.sleep(0.01)  # Small delay

                                    self.pi.set_mode(pin, pigpio.INPUT)  # Change to INPUT
                                    time.sleep(0.01)  # Small delay

                                    # Verify mode changed
                                    if self.pi.get_mode(pin) != pigpio.INPUT:
                                        if verbose:
                                            print(f"Warning: Pin {pin} didn't change to INPUT mode")

                                    self.pi.set_pull_up_down(pin, pigpio.PUD_DOWN)  # Set pull-down
                                    time.sleep(0.01)  # Small delay

                                    if verbose:
                                        print(f"Additional pin {pin} found in OUTPUT mode and released")
                            except Exception as e:
                                if verbose:
                                    print(f"Info: Pin {pin} state could not be checked or changed: {e}")

                    if verbose:
                        print("All pins released.")
                else:
                    if verbose:
                        print("Cannot release pins: pigpio daemon not connected")
                    cleanup_error = True
            except Exception as e:
                if verbose:
                    print(f"Error during pin release phase: {e}")
                cleanup_error = True

        # Phase 3: Disconnect from pigpio daemon
        if hasattr(self, 'pi'):
            try:
                if self.pi.connected:
                    if verbose:
                        print("Phase 3: Disconnecting from pigpio daemon...")
                    self.pi.stop()
                    if verbose:
                        print("Disconnected from pigpio daemon.")
                else:
                    if verbose:
                        print("Already disconnected from pigpio daemon.")
            except Exception as e:
                if verbose:
                    print(f"Error disconnecting from pigpio daemon: {e}")
                cleanup_error = True

        # Set cleanup flag regardless of errors
        self._cleaned_up = True

        # Final cleanup status
        if cleanup_error:
            if verbose:
                print("Cleanup completed with some errors. Some resources may not have been properly released.")
            return False
        else:
            if verbose:
                print("Comprehensive cleanup completed successfully. All GPIO resources released.")
            return True
    
    def __del__(self):
        """Destructor - ensure cleanup happens during garbage collection."""
        self.cleanup()
    
    def sendSignal(self, bitStream):
        """
        Send a bitstream over GPIO pins using SPI-like protocol with midpoint clock signaling.
        This function offloads the work to a thread for asynchronous operation.
        Args:
            bitStream (str): A string of '0' and '1' characters representing bits to send.
        """
        # Import threading
        import threading
        import time
        # Define the thread function
        def _send_signal_thread():
            # Calculate period from class frequency attribute (seconds per cycle)
            period = 1.0 / self.ClockFrequency
            # Calculate half period for timing
            half_period = period / 2.0
            try:
                # Ensure clock starts LOW before transmission
                self.pi.write(self.SerialClock, 0)
                # Activate slave select (pull LOW to begin transmission)
                self.pi.write(self.SlaveSelect, 0)
                time.sleep(half_period / 2)  # Short delay to allow SS to settle
                for bit in bitStream:
                    # Convert bit character to integer (0 or 1)
                    bit_value = int(bit)
                    print(f"Sending Bit: {bit_value} ")
                    # Set data pin with the bit value
                    self.pi.write(self.MasterOutSlaveIn, bit_value)
                    # Wait until midpoint of the bit period
                    time.sleep(half_period)
                    # Toggle clock HIGH at midpoint - this is when the slave samples the data
                    self.pi.write(self.SerialClock, 1)
                    # Wait until end of bit period
                    time.sleep(half_period)
                    # Toggle clock LOW for next bit
                    self.pi.write(self.SerialClock, 0)
                # Deactivate slave select (pull HIGH to end transmission)
                self.pi.write(self.SlaveSelect, 1)
                # Reset data line to default state
                self.pi.write(self.MasterOutSlaveIn, 0)
                print(f"Thread completed sending {len(bitStream)} bits")
            except Exception as e:
                # Error handling - reset pins to safe state
                print(f"Error in sendSignal thread: {e}")
                self.pi.write(self.SerialClock, 0)
                self.pi.write(self.MasterOutSlaveIn, 0)
                self.pi.write(self.SlaveSelect, 1)  # Deactivate slave
        # Create and start the thread
        signal_thread = threading.Thread(target=_send_signal_thread)
        signal_thread.daemon = True  # Thread will automatically terminate when main program exits
        signal_thread.start()
        print(f"Started thread to send {len(bitStream)} bits")

        # Wait for the thread to complete before returning
        signal_thread.join()
        print(f"Thread finished, returning from sendSignal")

        # Return after thread completes
        return
    
    def sendMatrix(self, matrix):
        """
        Convert a numpy matrix to a bitstream and send it.
        
        Args:
            matrix (numpy.ndarray): Matrix to send.
        """
        # Convert the matrix to a bitstream
        bitStream = matrix_to_string(matrix)
        
        # Send the bitstream
        self.sendSignal(bitStream)
        
        return len(bitStream)  # Return number of bits sent
    
    def generate_clock(self, pin, period, duration=None, cycles=None, duty_cycle=0.5):
        """
        Generate a clock signal with specified period on a GPIO pin in a separate thread.
        
        Args:
            pin (int): GPIO pin to use for clock signal generation.
            period (float): Clock period in seconds (time for one complete cycle).
            duration (float, optional): Duration to run the clock in seconds. 
                                       If None, runs until stopped or cycles completed.
            cycles (int, optional): Number of clock cycles to generate. 
                                   If None, runs until duration or stopped.
            duty_cycle (float, optional): Duty cycle of the clock (0.0 to 1.0). Default is 0.5 (50%).
            
        Returns:
            str: Clock ID that can be used to stop this specific clock.
        """
        # Import threading
        import threading
        import uuid
        import time
        
        # Validate parameters
        if period <= 0:
            print("Error: Period must be greater than 0")
            return None
            
        if duty_cycle <= 0 or duty_cycle >= 1:
            print("Error: Duty cycle must be between 0 and 1")
            return None
        
        # Validate pin
        if pin is None:
            print("Error: Pin must be specified")
            return None
        
        # Generate a unique ID for this clock
        clock_id = str(uuid.uuid4())
        
        # Initialize clock tracking dictionary if it doesn't exist
        if not hasattr(self, '_active_clocks'):
            self._active_clocks = {}
        
        # Calculate high and low times based on period and duty cycle
        high_time = period * duty_cycle
        low_time = period - high_time
        
        # Define the clock generation function
        def _generate_clock_internal():
            try:
                # Ensure pin is in OUTPUT mode
                current_mode = self.pi.get_mode(pin)
                if current_mode != pigpio.OUTPUT:
                    self.pi.set_mode(pin, pigpio.OUTPUT)
                    
                # Start with the pin in LOW state
                self.pi.write(pin, 0)
                
                cycle_count = 0
                start_time = time.time()
                
                print(f"Clock {clock_id}: Starting on pin {pin} with period {period}s ({1/period:.2f}Hz)")
                
                # Run until stopped, duration elapsed, or cycle count reached
                while clock_id in self._active_clocks:
                    # Check if we've reached the specified duration
                    if duration is not None and (time.time() - start_time) >= duration:
                        break
                    
                    # Set pin HIGH
                    self.pi.write(pin, 1)
                    time.sleep(high_time)
                    
                    # Check if we've been stopped during the high time
                    if clock_id not in self._active_clocks:
                        break
                    
                    # Set pin LOW
                    self.pi.write(pin, 0)
                    time.sleep(low_time)
                    
                    # Increment cycle count
                    cycle_count += 1
                    
                    # Check if we've reached the specified number of cycles
                    if cycles is not None and cycle_count >= cycles:
                        break
                    
                # Ensure pin is left in a safe state (LOW)
                self.pi.write(pin, 0)
                
                # Remove this clock from the active clocks dictionary
                if clock_id in self._active_clocks:
                    del self._active_clocks[clock_id]
                    
                print(f"Clock {clock_id}: Stopped after {cycle_count} cycles")
                
            except Exception as e:
                print(f"Clock {clock_id}: Error - {e}")
                # Ensure pin is left in a safe state on error
                try:
                    self.pi.write(pin, 0)
                except:
                    pass
                # Remove this clock from active clocks on error
                if clock_id in self._active_clocks:
                    del self._active_clocks[clock_id]
        
        # Create and start a daemon thread
        clock_thread = threading.Thread(target=_generate_clock_internal)
        clock_thread.daemon = True
        
        # Store reference to this clock
        self._active_clocks[clock_id] = {
            'thread': clock_thread,
            'pin': pin,
            'period': period,
            'start_time': time.time()
        }
        
        # Start the thread
        clock_thread.start()
        
        print(f"Clock {clock_id}: Started in background thread on pin {pin}")
        return clock_id
    
    def stop_clock(self, clock_id=None):
        """
        Stop a running clock signal generation.
        
        Args:
            clock_id (str, optional): ID of the specific clock to stop.
                                     If None, stops all clocks.
        
        Returns:
            bool: True if successful, False otherwise.
        """
        if not hasattr(self, '_active_clocks'):
            print("No active clocks to stop")
            return False
        
        if clock_id is None:
            # Stop all clocks
            clock_ids = list(self._active_clocks.keys())
            for cid in clock_ids:
                del self._active_clocks[cid]
            print(f"Stopped all clocks ({len(clock_ids)} total)")
            return True
        elif clock_id in self._active_clocks:
            # Stop specific clock
            del self._active_clocks[clock_id]
            print(f"Clock {clock_id}: Stopped")
            return True
        else:
            print(f"Clock {clock_id}: Not found")
            return False
    
    def list_active_clocks(self):
        """
        List all active clock generators.
        
        Returns:
            dict: Information about all active clocks.
        """
        if not hasattr(self, '_active_clocks') or not self._active_clocks:
            print("No active clocks")
            return {}
        
        current_time = time.time()
        
        # Create a copy with runtime information
        result = {}
        for clock_id, info in self._active_clocks.items():
            runtime = current_time - info['start_time']
            result[clock_id] = {
                'pin': info['pin'],
                'frequency': 1.0 / info['period'],
                'runtime': f"{runtime:.2f} seconds"
            }
        
        # Print summary
        print(f"Active clocks: {len(result)}")
        for clock_id, info in result.items():
            print(f"  Clock {clock_id}: Pin {info['pin']}, {info['frequency']:.2f}Hz, Running for {info['runtime']}")
        
        return result
        
    def __str__(self):
        """String representation of the Communications object."""
        return (f"Communications(SS={self.SlaveSelect}, MISO={self.MasterInSlaveOut}, "
                f"MOSI={self.MasterOutSlaveIn}, SCLK={self.SerialClock}, "
                f"DIM={self.DimensionOfMatrix})")


# Example usage:
if __name__ == "__main__":
    
    print("Starting communications...")
    comm = Communications(4)
    comm.pi.write(18, 1)
    
    try:
        print("Running main program...")
        # Example: Create a test matrix and send it
        test_matrix = np.array([-3-3j])
        print(test_matrix)
        print(matrix_to_string(test_matrix))
        bits_sent = comm.sendMatrix(test_matrix)
        print(f"Sent {bits_sent} bits")
        
        # Add additional clock cycles after sending bits
        print("Running additional clock cycles...")
        clock_freq = comm.ClockFrequency  # Get the clock frequency
        half_period = 0.5 / clock_freq    # Calculate half period duration
        extra_cycles = 20                 # Number of extra clock cycles
        
        # Run the extra clock cycles
        for i in range(extra_cycles):
            # Toggle clock HIGH
            comm.pi.write(comm.SerialClock, 1)
            time.sleep(half_period)
            # Toggle clock LOW
            comm.pi.write(comm.SerialClock, 0)
            time.sleep(half_period)
            
        print(f"Completed {extra_cycles} additional clock cycles")
        
        # Keep the program alive to demonstrate signal handling
        print("Press Ctrl+C to exit...")
        while True:
            time.sleep(1)
            
    except Exception as e:
        print(f"Error in main program: {e}")
    finally:
        print("Exiting program normally")
        # No need to call cleanup explicitly - atexit will handle it