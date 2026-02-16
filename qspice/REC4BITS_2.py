import pigpio
import time
import argparse

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

# Pin definitions
MISO = 24  # Input from SPI transmitter
SCLK = 13
SS = 22
EN = 18

# Number of bits to receive
NUM_BITS = 72

def receive_pattern(pi, speed_ms=100, debug=False):
    """Receive a pattern with adjustable speed and debugging"""
    delay = speed_ms / 1000.0  # Convert to seconds
    
    # Setup sequence with debugging
    if debug:
        print(f"Setting up with delay of {delay}s")
    
    # Start fresh - reset everything
    pi.write(SCLK, 0)
    pi.write(SS, 1)
    pi.write(EN, 0)
    time.sleep(delay * 10)
    
    # Enable device
    if debug:
        print("Enabling device")
    pi.write(EN, 1)
    time.sleep(delay * 10)
    
    # Start transmission
    if debug:
        print("Starting transmission")
    pi.write(SCLK, 0)  # Ensure SCLK is low before SS goes low
    time.sleep(delay)
    pi.write(SS, 0)
    time.sleep(delay * 5)
    
    # Receive bits
    received_bits = []
    for i in range(NUM_BITS):
        # Full clock cycle with debug output
        if debug and i % 8 == 0:
            print(f"Receiving bit {i}")
            
        # Clock low
        pi.write(SCLK, 0)
        time.sleep(delay)
        
        # Clock high - read data
        pi.write(SCLK, 1)
        time.sleep(delay)
        bit = pi.read(MISO)
        received_bits.append(bit)
        
        # Hold clock high for stability
        time.sleep(delay)
    
    # End transmission cleanly
    if debug:
        print("Ending transmission")
    pi.write(SCLK, 0)
    time.sleep(delay * 2)
    pi.write(SS, 1)
    time.sleep(delay)
    pi.write(EN, 0)
    
    return received_bits

def main():
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='SPI Pattern Receiver')
    parser.add_argument('--speed', type=float, default=1.0, 
                        help='Clock speed in ms (higher = slower)')
    parser.add_argument('--pattern', type=str, 
                        default="001101111001110110000101110101010011101000111111110010010010111110100011",
                        help='Expected pattern to verify against')
    parser.add_argument('--debug', action='store_true', help='Enable debug output')
    parser.add_argument('--repeat', type=int, default=1, help='Number of times to repeat')
    args = parser.parse_args()
    
    pi = pigpio.pi()
    if not pi.connected:
        print("Failed to connect to pigpio daemon")
        return
    
    try:
        success = 0
        for attempt in range(args.repeat):
            print(f"\nAttempt {attempt+1}/{args.repeat}:")
            
            # Receive pattern from hardware
            received_bits = receive_pattern(pi, args.speed, args.debug)
            bit_string = ''.join(map(str, received_bits))
            
            # Convert both expected and received bit strings to sfixed(14,-21)
            try:
                expected_sfixed = convert_72bit_to_sfixed(args.pattern)
                received_sfixed = convert_72bit_to_sfixed(bit_string)
            except ValueError as e:
                print("Error in conversion:", e)
                continue
            
            # Print the sfixed values for both expected and received patterns
            print("Expected sfixed (upper, lower):", expected_sfixed)
            print("Received sfixed (upper, lower):", received_sfixed)
            
            # Compare with expected pattern
            if bit_string == args.pattern:
                print("SUCCESS! Pattern matches.")
                success += 1
            else:
                print("MISMATCH!")
                print(f"Expected: {args.pattern}")
                print(f"Received: {bit_string}")
                
                # Show where mismatches occur
                mismatches = [(i, e, r) for i, (e, r) in 
                              enumerate(zip(args.pattern, bit_string)) if e != r]
                print(f"Mismatches at {len(mismatches)} positions")
                if args.debug:
                    for pos, exp, rec in mismatches:
                        print(f"  Bit {pos}: expected {exp}, got {rec}")
            
            # Give FPGA time to reset between attempts
            time.sleep(args.speed/1000.0 * 20)
        
        print(f"\nResults: {success}/{args.repeat} successful transfers")
        
    finally:
        pi.stop()

if __name__ == "__main__":
    main()
