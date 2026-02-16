import pigpio
import time
import random

# Global speed factor (higher = slower)
SPEED_FACTOR = 1e-30000

# BIT_VALUES as a string - each character represents a bit ('0' or '1')
# BIT_VALUES = "11101001111100010101100100101100"  # Example: a 32-bit number


# Generate a random 32-bit number and convert it to a binary string with leading zeros if needed.
BIT_VALUES = f"{random.getrandbits(32):032b}"

# Initialize pigpio
pi = pigpio.pi()
if not pi.connected:
    exit("Failed to connect to pigpio daemon")

# Define pins
MISO = 23
MOSI = 24
SCLK = 13
SS = 22
EN = 18

# Set up pins as outputs
pi.set_mode(MOSI, pigpio.OUTPUT)
pi.set_mode(SCLK, pigpio.OUTPUT)
pi.set_mode(SS, pigpio.OUTPUT)
pi.set_mode(EN, pigpio.OUTPUT)

try:
    # STEP 1: Initialize transmission
    print("STEP 1: Initializing transmission")
    pi.write(MOSI, 1)
    pi.write(SCLK, 0)
    pi.write(SS, 1)
    pi.write(EN, 0)
    time.sleep(1 * SPEED_FACTOR)
   
    # STEP 2: Begin transmission
    print("STEP 2: Beginning transmission")
    pi.write(EN, 1)
    pi.write(SS, 0)
    # Set first bit (converted from character to integer)
    pi.write(MOSI, int(BIT_VALUES[0]))
    time.sleep(1 * SPEED_FACTOR)
   
    # Send all bits using a loop
    for i, bit_char in enumerate(BIT_VALUES):
        bit_value = int(bit_char)  # Convert the character ('0' or '1') to integer
        print(f"Sending bit {i+1} (value: {bit_value})")
        
        # Set MOSI for all bits except the first one (which was set in STEP 2)
        if i > 0:
            pi.write(MOSI, bit_value)
            time.sleep(0.5 * SPEED_FACTOR)
        
        # Clock cycle
        print("  Clock rising edge")
        pi.write(SCLK, 1)
        time.sleep(0.5 * SPEED_FACTOR)
        print("  Clock falling edge")
        pi.write(SCLK, 0)
        
        # Add delay after the last bit only (matching original behavior)
        if i == len(BIT_VALUES) - 1:
            time.sleep(0.5 * SPEED_FACTOR)
   
    # Signal end of transmission
    print("Signaling end of transmission")
    pi.write(EN, 0)
    time.sleep(0.5 * SPEED_FACTOR)
    pi.write(EN, 1)
    time.sleep(0.5 * SPEED_FACTOR)
    
finally:
    # Cleanup
    print("Cleaning up")
    pi.write(MOSI, 0)
    pi.write(SCLK, 0)
    pi.write(SS, 0)
    pi.write(EN, 0)
    pi.stop()
    
    # Convert BIT_VALUES to HEX and print the result.
    # '08X' ensures an 8-character wide hex string with leading zeros if needed.
    hex_value = format(int(BIT_VALUES, 2), '08X')
    print("Sent binary value in HEX:", hex_value)
    
    print("Done")


def transmit_bits(speed):
    import pigpio
    import time
    import random
    
    # Generate a random 32-bit number and convert to binary string
    BIT_VALUES = f"{random.getrandbits(32):032b}"
    
    # Initialize pigpio
    pi = pigpio.pi()
    if not pi.connected:
        exit("Failed to connect to pigpio daemon")
        
    # Define pins
    MOSI, SCLK, SS, EN = 24, 13, 22, 18
    
    # Set up pins as outputs
    for pin in [MOSI, SCLK, SS, EN]:
        pi.set_mode(pin, pigpio.OUTPUT)
    
    try:
        # STEP 1: Initialize transmission
        pi.write(MOSI, 1)
        pi.write(SCLK, 0)
        pi.write(SS, 1)
        pi.write(EN, 0)
        time.sleep(1 * speed)
       
        # STEP 2: Begin transmission
        pi.write(EN, 1)
        pi.write(SS, 0)
        pi.write(MOSI, int(BIT_VALUES[0]))
        time.sleep(1 * speed)
       
        # Send all bits using a loop
        for i, bit_char in enumerate(BIT_VALUES):
            bit_value = int(bit_char)
           
            # Set MOSI for all bits except the first one
            if i > 0:
                pi.write(MOSI, bit_value)
                time.sleep(0.5 * speed)
           
            # Clock cycle
            pi.write(SCLK, 1)
            time.sleep(0.5 * speed)
            pi.write(SCLK, 0)
           
            # Add delay after the last bit only
            if i == len(BIT_VALUES) - 1:
                time.sleep(0.5 * speed)
       
        time.sleep(10000000000000000000000000000000000000000)
        # Signal end of transmission
        pi.write(EN, 0)
        time.sleep(0.5 * speed)
        pi.write(EN, 1)
        time.sleep(0.5 * speed)
       
    finally:
        # Cleanup
        for pin in [MOSI, SCLK, SS, EN]:
            pi.write(pin, 0)
        pi.stop()


for i in range(1000):
    print(f"Num: {i}")
    transmit_bits(0)
