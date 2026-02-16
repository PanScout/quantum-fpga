import pigpio
import time

# Connect to the pigpio daemon
pi = pigpio.pi()

# If connection was successful (returns True)
if pi.connected:
    # Set GPIO pin 23 as an output and activate it (set to HIGH)
    pi.set_mode(23, pigpio.OUTPUT)
    pi.write(23, 1)  # 1 = HIGH (3.3V), 0 = LOW (0V)
    
    print("GPIO pin 23 is now active (HIGH)")
    
    # Keep the pin active for 5 seconds
    time.sleep(5)
    
    # Set the pin back to LOW and clean up
    pi.write(23, 0)
    pi.stop()  # Release resources
    
    print("GPIO pin 23 deactivated and resources released")
else:
    print("Failed to connect to pigpio daemon")
    print("Try running 'sudo pigpiod' in the terminal first")