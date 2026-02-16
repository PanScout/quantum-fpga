import RPi.GPIO as GPIO
import time
import math
import sys # Import sys to exit cleanly if needed

# ---------------------------
# User-configurable parameters
# ---------------------------
# GPIO Pins (BCM)
MOSI_PIN = 24
MISO_PIN = 23
SS_PIN   = 22
SCLK_PIN = 13
ENABLE_PIN = 18
RESET_PIN = 17

# SPI Speed (Half Clock Period in seconds)
spi_speed = 0.0001

# --- Data Sent by Python (FPGA Receives) ---
BITS_PER_WORD = 72
WORDS_TO_SEND = [
    "101010101010101010101010101010101010101010101010101010101010101010101010", # AA...
    "010101010101010101010101010101010101010101010101010101010101010101010101", # 55...
    "111100001111000011110000111100001111000011110000111100001111000011110000", # F0...
    "000011110000111100001111000011110000111100001111000011110000111100001111"  # 0F...
]
NUM_WORDS_SENT = len(WORDS_TO_SEND)

# --- Expected Data Received by Python (FPGA Transmits) ---
# Assuming FPGA retransmits the same data
NUM_WORDS_TO_RECEIVE = NUM_WORDS_SENT
EXPECTED_RX_BITS = NUM_WORDS_TO_RECEIVE * BITS_PER_WORD # 4 * 72 = 288

# --- Timing Calculations (based on .do script) ---
INIT_RESET_HIGH_NS = 100
INIT_RESET_LOW_NS = 50
RX_PRE_SS_LOW_NS = 20
RX_POST_WORD_NS = 200
SWITCH_PRE_SS_LOW_NS = 20
TX_CLOCKING_MAIN_NS = 58000
TX_CLOCKING_EXTRA1_NS = 8400
TX_CLOCKING_EXTRA2_NS = 6400
FINAL_WAIT_NS = 1000

SCLK_PERIOD_NS = 200
HALF_SCLK_PERIOD_NS = SCLK_PERIOD_NS / 2.0

# Calculate clock cycles needed for FPGA transmit phase
# Use the .do script timing to ensure enough clocks are provided
total_tx_clocking_ns = TX_CLOCKING_MAIN_NS + TX_CLOCKING_EXTRA1_NS + TX_CLOCKING_EXTRA2_NS
num_tx_sclk_cycles = math.ceil(total_tx_clocking_ns / SCLK_PERIOD_NS) # Should be 364
print(f"INFO: Providing {num_tx_sclk_cycles} SCLK cycles during FPGA transmit phase.")
print(f"      Expecting {EXPECTED_RX_BITS} bits back from FPGA.")
# Note: We provide more cycles than strictly needed for 288 bits, matching simulation.

# Sanity Check
for i, s in enumerate(WORDS_TO_SEND):
    if len(s) != BITS_PER_WORD:
        print(f"ERROR: Sent Word {i+1} length {len(s)}, expected {BITS_PER_WORD}. Exiting.")
        sys.exit(1) # Exit script

print("INFO: Initializing GPIO pins...")
# ---------------------------
# GPIO Setup
# ---------------------------
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(MOSI_PIN, GPIO.OUT)
GPIO.setup(MISO_PIN, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(SS_PIN, GPIO.OUT)
GPIO.setup(SCLK_PIN, GPIO.OUT)
GPIO.setup(ENABLE_PIN, GPIO.OUT)
GPIO.setup(RESET_PIN, GPIO.OUT)

# ---------------------------
# Helper Function: Transmit a single SPI word (Python Sends)
# ---------------------------
def transmit_spi_word(bit_string, speed):
    """ Transmits bit_string via SPI. Assumes SS low, ENABLE high. """
    # print(f"   Transmitting {len(bit_string)} bits: {bit_string[:8]}...") # Optional print
    GPIO.output(SCLK_PIN, GPIO.LOW)
    time.sleep(speed * 0.1)
    for bit in bit_string:
        GPIO.output(MOSI_PIN, GPIO.HIGH if bit == '1' else GPIO.LOW)
        GPIO.output(SCLK_PIN, GPIO.HIGH)
        time.sleep(speed)
        GPIO.output(SCLK_PIN, GPIO.LOW)
        time.sleep(speed)
    # print(f"   Transmission of {len(bit_string)} bits complete.") # Optional print

# ---------------------------
# Helper Function: Provide SCLK pulses & Read MISO (Python Receives)
# ---------------------------
def provide_sclk_cycles_and_read_miso(num_cycles, speed):
    """
    Provides SCLK pulses. Reads MISO data on falling edge, ignoring cycle 0 read.
    Returns the concatenated string of valid bits read from MISO.
    """
    print(f"   Providing {num_cycles} SCLK cycles for FPGA transmit...")
    GPIO.output(SCLK_PIN, GPIO.LOW)
    time.sleep(speed * 0.1)
    received_bits = []

    for cycle in range(num_cycles):
        GPIO.output(SCLK_PIN, GPIO.HIGH)
        time.sleep(speed)
        GPIO.output(SCLK_PIN, GPIO.LOW)

        if cycle > 0: # Skip read on first cycle (cycle 0)
            miso_val = GPIO.input(MISO_PIN)
            received_bits.append('1' if miso_val == GPIO.HIGH else '0')

        time.sleep(speed)

    num_bits_read = len(received_bits)
    print(f"   Provided {num_cycles} SCLK cycles. Read {num_bits_read} valid bits from MISO (starting from 2nd SCLK cycle).")
    if num_bits_read > 0:
         print(f"         First few bits read: {''.join(received_bits[:16])}...")
    return "".join(received_bits)

# ---------------------------
# Main Execution Flow
# ---------------------------
fpga_received_data_str = "" # Initialize variable to store MISO data string
received_words_list = []    # Initialize list to store formatted received words

try:
    print("\n##########################################################")
    print("INFO: === Starting FPGA Interaction Sequence ===")
    print(f"      Will send {NUM_WORDS_SENT} words ({BITS_PER_WORD} bits each).")
    print(f"      Will attempt to receive {NUM_WORDS_TO_RECEIVE} words back.")
    print(f"      SPI Speed (Half SCLK Period): {spi_speed:.6f} seconds")
    print("##########################################################\n")

    # --- 1. Initialization ---
    print("STEP 1: Initialization...")
    GPIO.output(SCLK_PIN, GPIO.LOW)
    GPIO.output(SS_PIN, GPIO.HIGH)
    GPIO.output(MOSI_PIN, GPIO.LOW)
    GPIO.output(ENABLE_PIN, GPIO.HIGH) # Start FPGA in RECEIVE mode
    GPIO.output(RESET_PIN, GPIO.HIGH)
    print("       RESET=HIGH, ENABLE=HIGH (FPGA Receive Mode), SS=HIGH, SCLK=LOW")
    time.sleep(spi_speed * (INIT_RESET_HIGH_NS / HALF_SCLK_PERIOD_NS))
    GPIO.output(RESET_PIN, GPIO.LOW)
    print("       RESET=LOW")
    time.sleep(spi_speed * (INIT_RESET_LOW_NS / HALF_SCLK_PERIOD_NS))
    print("STEP 1: Initialization Complete.\n")

    # --- 2. FPGA Receive Phase (Python Sends Data) ---
    print(f"STEP 2: Python Sending Data ({NUM_WORDS_SENT} words) -> FPGA Receiving...")
    GPIO.output(ENABLE_PIN, GPIO.HIGH) # Ensure FPGA in Receive mode
    GPIO.output(SS_PIN, GPIO.LOW)      # Assert Slave Select
    print("       ENABLE=HIGH, SS=LOW")
    time.sleep(spi_speed * (RX_PRE_SS_LOW_NS / HALF_SCLK_PERIOD_NS)) # Wait 20ns equiv

    # Transmit the 4 words
    for i, word in enumerate(WORDS_TO_SEND):
        print(f"   Sending Word {i+1}/{NUM_WORDS_SENT} via MOSI...")
        transmit_spi_word(word, spi_speed)

    print("   All words sent.")
    time.sleep(spi_speed * (RX_POST_WORD_NS / HALF_SCLK_PERIOD_NS)) # Wait 200ns equiv
    GPIO.output(SS_PIN, GPIO.HIGH)     # Deassert Slave Select
    print("       SS=HIGH")
    print("STEP 2: Python Sending Data Complete.\n")


    # --- 3. Switch FPGA to Transmit Mode ---
    print("STEP 3: Switching FPGA to Transmit Mode...")
    GPIO.output(ENABLE_PIN, GPIO.LOW)  # Switch FPGA to TRANSMIT mode
    GPIO.output(SS_PIN, GPIO.LOW)      # Assert Slave Select for FPGA transmit
    print("       ENABLE=LOW (FPGA Transmit Mode), SS=LOW")
    time.sleep(spi_speed * (SWITCH_PRE_SS_LOW_NS / HALF_SCLK_PERIOD_NS)) # Wait 20ns equiv
    print("STEP 3: Switched to Transmit Mode Complete.\n")


    # --- 4. FPGA Transmit Phase (Python Receives Data) ---
    print(f"STEP 4: Python Receiving Data ({NUM_WORDS_TO_RECEIVE} words expected) <- FPGA Transmitting...")
    fpga_received_data_str = provide_sclk_cycles_and_read_miso(num_tx_sclk_cycles, spi_speed)
    print("STEP 4: Python Receiving Data Complete.\n")


    # --- 5. Process Received Data ---
    print("STEP 5: Processing Received MISO Data...")
    if len(fpga_received_data_str) >= EXPECTED_RX_BITS:
        print(f"   Received sufficient bits ({len(fpga_received_data_str)} >= {EXPECTED_RX_BITS} expected).")
        # Extract the relevant number of bits
        relevant_received_data = fpga_received_data_str[:EXPECTED_RX_BITS]
        # Split into words
        received_words_list = [relevant_received_data[i:i+BITS_PER_WORD] for i in range(0, EXPECTED_RX_BITS, BITS_PER_WORD)]
        print(f"   Formatted into {len(received_words_list)} words of {BITS_PER_WORD} bits.")
    else:
        print(f"   WARNING: Received fewer bits ({len(fpga_received_data_str)}) than expected ({EXPECTED_RX_BITS}). Padding or formatting might be incomplete.")
        # Attempt to format what was received anyway
        received_words_list = [fpga_received_data_str[i:i+BITS_PER_WORD] for i in range(0, len(fpga_received_data_str), BITS_PER_WORD)]
        # Optional: Pad the last word if incomplete? For now, just show what was received.
    print("STEP 5: Processing Complete.\n")


    # --- 6. Stop Clock / Deassert SS ---
    print("STEP 6: Stopping Clock and Deasserting SS...")
    GPIO.output(SCLK_PIN, GPIO.LOW)
    GPIO.output(SS_PIN, GPIO.HIGH)
    print("       SCLK=LOW, SS=HIGH")
    print("STEP 6: Clock Stopped, SS Deasserted Complete.\n")


    # --- 7. Final Wait ---
    print("STEP 7: Final Wait...")
    time.sleep(spi_speed * (FINAL_WAIT_NS / HALF_SCLK_PERIOD_NS)) # Wait 1000ns equiv
    print("STEP 7: Final Wait Complete.\n")

    # --- 8. Print Sent vs Received Data ---
    print("\n=================== SENT vs RECEIVED DATA ===================")
    print("--- Data Sent by Python (via MOSI): ---")
    if not WORDS_TO_SEND:
        print("  (None)")
    else:
        for i, word in enumerate(WORDS_TO_SEND):
            print(f"  Sent Word {i+1}: {word}")

    print("\n--- Data Received by Python (via MISO): ---")
    if not received_words_list:
         print("  (None or insufficient data received)")
    else:
        for i, word in enumerate(received_words_list):
            print(f"  Rcvd Word {i+1}: {word}")
            # Optional: Compare with sent data
            if i < len(WORDS_TO_SEND):
                if word == WORDS_TO_SEND[i]:
                    print("                (Matches Sent Word)")
                else:
                    print("                (*** MISMATCH with Sent Word ***)")
            else:
                print("                (No corresponding sent word index)")
    print("=============================================================\n")


    # --- 9. Hold Idle State ---
    print("STEP 9: Entering and Holding Idle State...")
    GPIO.output(SCLK_PIN, GPIO.LOW)
    GPIO.output(SS_PIN, GPIO.HIGH)
    GPIO.output(ENABLE_PIN, GPIO.LOW) # FPGA remains in Transmit/Idle mode
    GPIO.output(RESET_PIN, GPIO.LOW)
    GPIO.output(MOSI_PIN, GPIO.LOW)
    print("       Idle State Set: SCLK=L, SS=H, ENABLE=L, RESET=L, MOSI=L")
    print("       FPGA interaction sequence complete.")
    print("\n==========================================================")
    print("INFO: Script is now holding the FPGA in an idle state.")
    print("      Review the Sent vs Received data above.")
    print("      Press Ctrl+C to exit and perform GPIO cleanup.")
    print("==========================================================")

    while True:
        time.sleep(1)

except KeyboardInterrupt:
    print("\n\nCtrl+C detected. Exiting script...")
except Exception as e:
    print(f"\nAn error occurred: {e}")
    print("Attempting cleanup...")
finally:
    print("\nCleaning up GPIO pins...")
    try:
        GPIO.output(MOSI_PIN, GPIO.LOW)
        GPIO.output(SCLK_PIN, GPIO.LOW)
        GPIO.output(SS_PIN, GPIO.HIGH)
        GPIO.output(ENABLE_PIN, GPIO.LOW)
        GPIO.output(RESET_PIN, GPIO.LOW)
        GPIO.cleanup()
        print("GPIO cleanup complete.")
    except RuntimeWarning as rw:
        print(f"GPIO cleanup warning: {rw}")
    except Exception as cleanup_e:
        print(f"Error during GPIO cleanup: {cleanup_e}")
        try:
            GPIO.cleanup()
            print("Secondary GPIO cleanup attempt finished.")
        except Exception as final_cleanup_e:
            print(f"Secondary GPIO cleanup attempt failed: {final_cleanup_e}")

print("\nScript finished.")