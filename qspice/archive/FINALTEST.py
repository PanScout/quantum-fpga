#!/usr/bin/env python3
"""
spi_retransmit.py

This script emulates the behavior of a TCL simulation do‑script that uses SPI to first receive and then transmit data.
It manually controls six GPIO signals on a Raspberry Pi:
  - MOSI: Data output for SPI transmission.
  - MISO: Data input for SPI reception.
  - SS: Slave Select (active low).
  - SCLK: Serial Clock.
  - ENABLE: Mode control (1=Receive, 0=Transmit).
  - RESET: Reset (active high pulse).

Timing in the original simulation is in the nanosecond range. Here the delays (in seconds) are scaled up for demonstration.
Adjust SPEED_FACTOR to change the speed of the simulation.
Make sure your wiring matches the pin assignments below and install the RPi.GPIO library.
"""

import RPi.GPIO as GPIO
import time
import random  # For generating random SPI words

# ----- Global Speed Factor -----
# Adjust this value to control the overall simulation speed.
# For example, 1.0 = default speed, 2.0 = twice the delay (slower), 0.5 = half the delay (faster).
SPEED_FACTOR = 0

# ---- Pin Definitions ----
MOSI_PIN   = 24  # MOSI output (Master Out, Slave In)
MISO_PIN   = 23  # MISO input (Master In, Slave Out)
SS_PIN     = 22  # Slave Select, active low
SCLK_PIN   = 13  # Serial Clock
ENABLE_PIN = 18  # Mode Control (1=Receive, 0=Transmit)
RESET_PIN  = 17  # Reset pin (active high pulse)

# ---- Timing Parameters (in seconds) ----
INITIAL_DELAY      = 0.1   # Simulating "run 100 ns"
POST_RESET_DELAY   = 0.05  # Delay after reset pulse
SPI_BIT_DELAY      = 0.01  # Delay per bit clock period (simulate 200 ns period, scaled up)
PRE_SPI_DELAY      = 0.02  # Delay before starting SPI stimulation
POST_SPI_DELAY     = 0.2   # Delay after finishing SPI receive before switching mode
TX_EXTRA_DELAY1    = 0.42  # Additional simulation delay after transmission begins
TX_EXTRA_DELAY2    = 0.064 # Additional simulation delay before final forces
FINAL_DELAY        = 0.1   # Final simulation delay after stopping clock/SS

# ---- Random SPI Word Generation for RECEIVE phase ----
# For the RECEIVE phase, each word is 72 bits.
NUM_RANDOM_WORDS = 4  # Change this to any desired number n to generate n random 72-bit words.

def generate_random_word(nbits=72):
    """
    Generate a random binary string of length `nbits`.
    """
    return format(random.getrandbits(nbits), f'0{nbits}b')

# Generate the list of random 72-bit words.
random_words = [generate_random_word(72) for _ in range(NUM_RANDOM_WORDS)]

# ---- TX Phase Global Definitions ----
# For the TX (transmit) phase, assume the FPGA sends back 4 words of 72 bits.
WORD_LENGTH = 72
NUM_WORDS = 256

def setup_gpio():
    """Set up the GPIO pins."""
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(MOSI_PIN, GPIO.OUT)
    GPIO.setup(SS_PIN, GPIO.OUT)
    GPIO.setup(SCLK_PIN, GPIO.OUT)
    GPIO.setup(ENABLE_PIN, GPIO.OUT)
    GPIO.setup(RESET_PIN, GPIO.OUT)
    GPIO.setup(MISO_PIN, GPIO.IN)

    # Initialize outputs: mimic initial simulation conditions.
    GPIO.output(RESET_PIN, GPIO.HIGH)    # Assert reset at start.
    GPIO.output(ENABLE_PIN, GPIO.HIGH)     # Start in RECEIVE mode.
    GPIO.output(SS_PIN, GPIO.HIGH)         # SPI inactive (SS high).
    GPIO.output(MOSI_PIN, GPIO.LOW)
    GPIO.output(SCLK_PIN, GPIO.LOW)

def cleanup_gpio():
    """Clean up the GPIO pins."""
    GPIO.cleanup()

def pulse_reset(pulse_duration=0.05):
    """
    Pulse the RESET pin.
    
    Drives RESET high for pulse_duration seconds (scaled by SPEED_FACTOR), then drives it low.
    """
    print("Pulsing RESET...")
    GPIO.output(RESET_PIN, GPIO.HIGH)
    time.sleep(SPEED_FACTOR * pulse_duration)
    GPIO.output(RESET_PIN, GPIO.LOW)
    time.sleep(SPEED_FACTOR * POST_RESET_DELAY)
    print("RESET pulse complete.")

def pulse_clock(period=SPI_BIT_DELAY):
    """Generate one clock pulse on the SCLK line.
    
    The clock is high for half the period and low for half the period.
    """
    half_period = period / 2
    GPIO.output(SCLK_PIN, GPIO.HIGH)
    time.sleep(SPEED_FACTOR * half_period)
    GPIO.output(SCLK_PIN, GPIO.LOW)
    time.sleep(SPEED_FACTOR * half_period)

def send_spi_word(word):
    """
    Send an SPI word bit by bit via the MOSI line.
    
    :param word: A string of bits (e.g., "101010...") to transmit.
    """
    for bit in word:
        GPIO.output(MOSI_PIN, GPIO.HIGH if bit == '1' else GPIO.LOW)
        pulse_clock()

def receive_spi_word(word_length, ignore_first_edge_initial=True):
    """
    Receive one word from the FPGA in TX mode.
    
    Controls whether the first rising edge is ignored via the parameter.
    For each rising edge:
      - If ignore_first_edge is True, clear it and do not sample.
      - Otherwise, capture the bit on MISO.
      
    :param word_length: Number of valid bits to capture per word.
    :param ignore_first_edge_initial: Boolean flag.
           Set to False for the first word (capture the first rising edge);
           set to True for subsequent words (ignore the first rising edge).
    :return: The received bit string.
    """
    bits = ""
    ignore_first_edge = ignore_first_edge_initial

    # Continue pulsing SCLK until we've captured the desired number of bits.
    while len(bits) < word_length:
        # Generate rising edge.
        GPIO.output(SCLK_PIN, GPIO.HIGH)
        time.sleep(SPEED_FACTOR * (SPI_BIT_DELAY / 2))
        if ignore_first_edge:
            # For this word, ignore the first rising edge.
            ignore_first_edge = False
        else:
            # Capture the bit on this rising edge.
            bit = GPIO.input(MISO_PIN)
            bits += '1' if bit else '0'
        # Lower SCLK.
        GPIO.output(SCLK_PIN, GPIO.LOW)
        time.sleep(SPEED_FACTOR * (SPI_BIT_DELAY / 2))
    
    return bits

def receive_spi_transmission(num_words, word_length):
    """
    Receive multiple words from the FPGA by calling receive_spi_word for each word.
    
    For the very first word, capture the first rising edge.
    For all subsequent words, ignore the first rising edge.
    
    :param num_words: Number of words to read.
    :param word_length: Bit length of each word.
    :return: Combined string of received bits.
    """
    received_data = ""
    for word_index in range(1, num_words + 1):
        if word_index == 1:
            print(f"Capturing word {word_index} (capturing first rising edge)...")
            word = receive_spi_word(word_length, ignore_first_edge_initial=False)
        else:
            print(f"Capturing word {word_index} (ignoring first rising edge)...")
            word = receive_spi_word(word_length, ignore_first_edge_initial=True)
        received_data += word
    return received_data

def main():
    try:
        setup_gpio()

        print("Initializing simulation...")
        time.sleep(SPEED_FACTOR * INITIAL_DELAY)

        # Pulse RESET before beginning anything.
        pulse_reset(pulse_duration=0.05)

        # ----------------------
        # SPI Receive Stimulus Phase
        # ----------------------
        print("Starting SPI RECEIVE stimulus...")
        GPIO.output(ENABLE_PIN, GPIO.HIGH)  # Set to RECEIVE mode.
        GPIO.output(SS_PIN, GPIO.LOW)         # Assert SS (active low).
        time.sleep(SPEED_FACTOR * PRE_SPI_DELAY)

        # Send each of the random 72-bit words on MOSI.
        for idx, word in enumerate(random_words, start=1):
            print(f"Sending receive word {idx}: {word[:16]}... (length: {len(word)} bits)")
            send_spi_word(word)
        
        # Deassert SS after the receive phase.
        GPIO.output(SS_PIN, GPIO.HIGH)
        print("SPI RECEIVE complete. SS deasserted.")
        time.sleep(SPEED_FACTOR * POST_SPI_DELAY)

        # ----------------------
        # SPI Transmit Phase: Capture data transmitted by the FPGA.
        # ----------------------
        print("Switching to TRANSMIT mode...")
        GPIO.output(ENABLE_PIN, GPIO.LOW)   # Set to TRANSMIT mode.
        GPIO.output(SS_PIN, GPIO.LOW)         # Assert SS for transmission.
        time.sleep(SPEED_FACTOR * PRE_SPI_DELAY)

        print("Starting SPI TRANSMIT capture phase...")
        transmitted_data = receive_spi_transmission(NUM_WORDS, WORD_LENGTH)
        print("Captured transmitted data:")
        print(transmitted_data)
        
        # Print out each consecutive 72-bit chunk.
        print("Individual 72-bit words:")
        received_words = []
        for i in range(0, len(transmitted_data), WORD_LENGTH):
            chunk = transmitted_data[i:i+WORD_LENGTH]
            received_words.append(chunk)
            word_number = (i // WORD_LENGTH) + 1
            print(f"Word {word_number}: {chunk}")
        
        # Compare each sent word to each received word.
        print("Comparison of sent vs. received words:")
        if len(random_words) != len(received_words):
            print("Warning: The number of sent words does not match the number of received words!")
        for i in range(min(len(random_words), len(received_words))):
            if random_words[i] == received_words[i]:
                print(f"Word {i+1}: MATCH")
            else:
                print(f"Word {i+1}: MISMATCH")
                print(f"  Sent:     {random_words[i]}")
                print(f"  Received: {received_words[i]}")

        # Additional simulation time.
        time.sleep(SPEED_FACTOR * TX_EXTRA_DELAY1)
        time.sleep(SPEED_FACTOR * TX_EXTRA_DELAY2)

        # Stop clock and deassert SS.
        GPIO.output(SCLK_PIN, GPIO.LOW)
        GPIO.output(SS_PIN, GPIO.HIGH)
        print("Stopped SCLK and deasserted SS.")
        time.sleep(SPEED_FACTOR * FINAL_DELAY)

        print("Simulation finished.")

    except KeyboardInterrupt:
        print("\nSimulation interrupted by user.")
    finally:
        cleanup_gpio()

if __name__ == '__main__':
    main()
