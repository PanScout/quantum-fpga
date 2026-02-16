import pigpio
import time

# Global speed factor (higher = slower) - Keep it slow initially
SPEED_FACTOR = 1e-300000000 # 10kHz clock frequency (100us period)
# Number of bits to read
NUM_BITS_TO_READ = 72
# Expected pattern for verification
EXPECTED_PATTERN = "111100001111000011110000111100001111000011110000111100001111000011110000"

# Initialize pigpio
pi = pigpio.pi()
if not pi.connected:
    exit("Failed to connect to pigpio daemon")

# Define pins
MISO = 24
SCLK = 13
SS = 22
EN = 18

# Set up pins
pi.set_mode(MISO, pigpio.INPUT)
pi.set_pull_up_down(MISO, pigpio.PUD_OFF) # Or PUD_UP if MISO idles high
pi.set_mode(SCLK, pigpio.OUTPUT)
pi.set_mode(SS, pigpio.OUTPUT)
pi.set_mode(EN, pigpio.OUTPUT)

RECEIVED_BITS = []

try:
    # STEP 1: Initialize transmission
    print("STEP 1: Initializing transmission")
    pi.write(SCLK, 0) # Clock idle low (CPOL=0)
    pi.write(SS, 1)   # Slave deselected
    pi.write(EN, 0)   # Device disabled
    time.sleep(10 * SPEED_FACTOR) # Pause

    # STEP 2: Begin transmission
    print("STEP 2: Beginning transmission")
    pi.write(EN, 1)   # Enable device
    time.sleep(5 * SPEED_FACTOR) # Allow enable to settle
    pi.write(SCLK, 0) # Ensure clock is low before SS
    time.sleep(1 * SPEED_FACTOR)
    pi.write(SS, 0)   # Select slave
    # Allow time for slave to react to SS and prepare first bit based on first edge
    time.sleep(1 * SPEED_FACTOR)

    # --- CPHA=1 Read Loop ---
    print(f"STEP 3: Reading {NUM_BITS_TO_READ} bits (CPOL=0, CPHA=1)...")
    for i in range(NUM_BITS_TO_READ):
        # First clock edge (Leading edge: Rising for CPOL=0)
        # FPGA changes MISO around this time
        pi.write(SCLK, 1)

        time.sleep(0.1 * SPEED_FACTOR) # <<< Optional small delay after SCLK low
        bit_value = pi.read(MISO) # <<< SAMPLE AFTER TRAILING EDGE
        RECEIVED_BITS.append(bit_value)
        # print(f" Read bit {i}: {bit_value}
        # Wait for the high phase (half period)
        time.sleep(0.5 * SPEED_FACTOR) # Ensure clock is high long enough

        # Second clock edge (Trailing edge: Falling for CPOL=0)
        # Set clock low THEN sample
        pi.write(SCLK, 0)
        # Sample MISO *after* the falling edge settles.
        # A small delay might be needed if signal propagation is slow,
        # but often reading immediately after setting low works.

        # Wait for the rest of the low phase (remaining half period, adjusted for sample delay)
        time.sleep(0.4 * SPEED_FACTOR)
        # --- End Clock Cycle ---

    # STEP 4: End transmission
    print("STEP 4: Ending transmission")
    pi.write(SCLK, 0) # Ensure clock is low
    pi.write(SS, 1)   # Deselect slave
    time.sleep(1 * SPEED_FACTOR)
    pi.write(EN, 0)   # Disable device
    time.sleep(5 * SPEED_FACTOR)

    # --- Verification ---
    result = "".join(map(str, RECEIVED_BITS))
    print("-" * 20)
    print(f"Expected ({len(EXPECTED_PATTERN)} bits): {EXPECTED_PATTERN}")
    print(f"Received ({len(result)} bits): {result}")
    print("-" * 20)

    if result == EXPECTED_PATTERN:
        print("SUCCESS - Sequence matches!")
    else:
        print("FAILURE - Sequence doesn't match")
        # (Error reporting logic remains the same)
        if len(result) != len(EXPECTED_PATTERN):
             print(f"Length Mismatch: Expected {len(EXPECTED_PATTERN)}, Got {len(result)}")
             min_len = min(len(result), len(EXPECTED_PATTERN))
        else:
             min_len = len(EXPECTED_PATTERN)

        diff_pos = -1
        for i in range(min_len):
            if result[i] != EXPECTED_PATTERN[i]:
                diff_pos = i
                break

        if diff_pos != -1:
            print(f"First difference at index {diff_pos}")
            marker = " " * diff_pos + "^"
            print(f"Expected: {EXPECTED_PATTERN}")
            print(f"          {marker}")
            print(f"Received: {result}")
            print(f"          {marker}")
        elif len(result) != len(EXPECTED_PATTERN):
             print("Sequences match up to the length of the shorter one.")


finally:
    # Cleanup
    print("Cleaning up GPIO")
    try:
        pi.write(SCLK, 0)
        pi.write(SS, 1)
        pi.write(EN, 0)
    except Exception as e:
        print(f"Error during cleanup: {e}")
    pi.stop()
    print("Done")