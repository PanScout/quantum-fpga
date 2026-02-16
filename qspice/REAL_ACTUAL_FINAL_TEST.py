#!/usr/bin/env python3
"""
spi_retransmit_pigpio.py

This script uses pigpio to emulate the behavior of the VHDL QPU testbench:
- Sends a 2×2 matrix and 2-element vector via SPI receive interfaces simultaneously
- Uses continuous SCLK while SS is asserted LOW
- Waits for the psi_matrix_done signal
- Switches to transmit mode and captures the psi_matrix output
"""

import pigpio
import time
import numpy as np

# Pin assignments (BCM)
RX_MATRIX_MOSI_PIN = 25  # Matrix MOSI
RX_MATRIX_SCLK_PIN = 4   # Matrix SCLK
RX_MATRIX_SS_PIN   = 12  # Matrix SS

RX_VECTOR_MOSI_PIN = 17  # Vector MOSI
RX_VECTOR_SCLK_PIN = 22  # Vector SCLK
RX_VECTOR_SS_PIN   = 27  # Vector SS

TX_MISO_PIN        = 5   # Psi Matrix MISO
TX_SCLK_PIN        = 4  # Psi Matrix SCLK
TX_SS_PIN          = 6   # Psi Matrix SS

# Control Signals
ENABLE_PIN         = 23  # 1=Receive, 0=Transmit
RESET_PIN          = 24  # Active high reset
PSI_DONE_PIN       = 26  # psi_matrix_assemble_done

# Timing Parameters (s)
SPEED_FACTOR       = 0
PRE_SPI_DELAY      = SPEED_FACTOR * 0.02
POST_SPI_DELAY     = SPEED_FACTOR * 0.20
SPI_CLK_PERIOD     = SPEED_FACTOR * 0.01   # corresponds to 100 ps in simulation scaled
HALF_PERIOD        = SPI_CLK_PERIOD       / 2
QUARTER_PERIOD     = SPI_CLK_PERIOD       / 4
TX_EXTRA_DELAY1    = SPEED_FACTOR * 0.42
TX_EXTRA_DELAY2    = SPEED_FACTOR * 0.064
FINAL_DELAY        = SPEED_FACTOR * 0.10


# Data definitions
WORD_LENGTH        = 72

def sfixed_to_float(bitstr: str, int_bits: int, frac_bits: int) -> float:
    """
    Convert a VHDL sfixed bit-string to a Python float.

    Args:
        bitstr:     String of '0' and '1', length must be int_bits + frac_bits.
        int_bits:   Number of integer bits (including the sign bit).
        frac_bits:  Number of fractional bits.

    Returns:
        The signed fixed‑point value as a float.

    Example:
        >>> sfixed_to_float('0101', 2, 2)
        1.25
        >>> sfixed_to_float('1101', 2, 2)
        -0.75
    """
    total_bits = int_bits + frac_bits
    if len(bitstr) != total_bits:
        raise ValueError(f"bitstr length ({len(bitstr)}) must equal int_bits+frac_bits ({total_bits})")

    unsigned = int(bitstr, 2)

    # Two’s‑complement adjustment:
    if bitstr[0] == '1':
        signed = unsigned - (1 << total_bits)
    else:
        signed = unsigned

    return signed / (1 << frac_bits)

from typing import Tuple

def word_to_floats(word: str) -> Tuple[float, float]:
    """
    Split a 72-character bit-string into two 36-bit sfixed(14,-21) numbers
    and convert each to a Python float using sfixed_to_float.

    Args:
        word: 72-character string of '0' and '1'.

    Returns:
        A tuple of two floats corresponding to the first and second 36-bit halves.

    Raises:
        ValueError: if `word` is not exactly 72 characters long.
    """
    if len(word) != 72:
        raise ValueError(f"Input word must be 72 bits long (got {len(word)})")

    # Each sfixed(14, -21) is 36 bits: integer bits = 14 - 0 + 1 = 15, frac bits = 0 - (-21) = 21
    INT_BITS = 15
    FRAC_BITS = 21
    HALF_LEN = 36

    high_bits = word[:HALF_LEN]
    low_bits  = word[HALF_LEN:]

    # Convert each half to float
    first_value  = sfixed_to_float(high_bits, INT_BITS, FRAC_BITS)
    second_value = sfixed_to_float(low_bits,  INT_BITS, FRAC_BITS)

    return first_value, second_value


# ---------------------------------------------------
# Generate fixed64 bit patterns (36-bit real + 36-bit imag)
# ---------------------------------------------------
print("Initializing fixed-point encoding functions...")
def to_fixed64_bits(value):
    scaled = int(round(value * (1 << 21)))
    if scaled < 0:
        scaled = (1 << 36) + scaled
    bit_str = format(scaled & ((1 << 36) - 1), '036b')
    print(f"Converted {value} to fixed64 bits: {bit_str}")
    return bit_str

# Matrix and vector values
matrix_vals = [-0.5, 0.5, 0.5, -0.5]
vector_vals = [1, 0]

print(f"Matrix values: {matrix_vals}")
print(f"Vector values: {vector_vals}")

matrix_words = [to_fixed64_bits(v) + '0'*36 for v in matrix_vals]
vector_words = [to_fixed64_bits(v) + '0'*36 for v in vector_vals]
print(f"Matrix SPI words (72-bit each): {matrix_words}")
print(f"Vector SPI words (72-bit each): {vector_words}")

# Determine number of words and total bits
num_matrix = len(matrix_words)
num_vector = len(vector_words)
num_words = max(num_matrix, num_vector)
total_bits = num_words * WORD_LENGTH
print(f"Total SPI words to send: {num_words}, total bits: {total_bits}")

# Initialize pigpio
print("Initializing pigpio and configuring GPIO modes...")
pi = pigpio.pi()
all_pins = [RX_MATRIX_MOSI_PIN, RX_MATRIX_SCLK_PIN, RX_MATRIX_SS_PIN,
            RX_VECTOR_MOSI_PIN, RX_VECTOR_SCLK_PIN, RX_VECTOR_SS_PIN,
            TX_SCLK_PIN, TX_SS_PIN,
            ENABLE_PIN, RESET_PIN, PSI_DONE_PIN, TX_MISO_PIN]
for p in all_pins:
    mode = pigpio.INPUT if p in (TX_MISO_PIN, PSI_DONE_PIN) else pigpio.OUTPUT
    pi.set_mode(p, mode)
    print(f"Set pin {p} to {'INPUT' if mode==pigpio.INPUT else 'OUTPUT'}")

# Helper delays
def sleep(d):
    time.sleep(d * SPEED_FACTOR)

# Reset pulse
def pulse_reset():
    print("Pulsing reset before start...")
    pi.write(RESET_PIN, 1)
    sleep(POST_SPI_DELAY)
    pi.write(RESET_PIN, 0)
    sleep(POST_SPI_DELAY)
    print("Reset complete.")

# Continuous SPI bit banging

def send_matrix_vector():
    print("-- SPI RECEIVE PHASE: Continuous SCLK, SS asserted LOW --")
    pi.write(ENABLE_PIN, 1)
    pi.write(RX_MATRIX_SS_PIN, 0)
    pi.write(RX_VECTOR_SS_PIN, 0)
    print("Receive mode enabled, SS lines low.")
    sleep(PRE_SPI_DELAY)
    print(f"Starting bit loop: total_bits = {total_bits}")
    for bit_idx in range(total_bits):
        word_idx = bit_idx // WORD_LENGTH
        bit_pos  = bit_idx % WORD_LENGTH
        # Matrix MOSI bit
        if word_idx < num_matrix:
            mbit = matrix_words[word_idx][bit_pos]
            pi.write(RX_MATRIX_MOSI_PIN, int(mbit))
        else:
            pi.write(RX_MATRIX_MOSI_PIN, 1)
        # Vector MOSI bit
        if word_idx < num_vector:
            vbit = vector_words[word_idx][bit_pos]
            pi.write(RX_VECTOR_MOSI_PIN, int(vbit))
        else:
            pi.write(RX_VECTOR_MOSI_PIN, 1)
        if bit_idx % WORD_LENGTH == 0:
            print(f"  Starting word {word_idx+1}")
        # MOSI setup margin
        sleep(QUARTER_PERIOD)
        # Clock high
        pi.write(RX_MATRIX_SCLK_PIN, 1)
        pi.write(RX_VECTOR_SCLK_PIN, 1)
        sleep(HALF_PERIOD)
        # Clock low
        pi.write(RX_MATRIX_SCLK_PIN, 0)
        pi.write(RX_VECTOR_SCLK_PIN, 0)
        sleep(QUARTER_PERIOD)
    # Deassert SS
    pi.write(RX_MATRIX_SS_PIN, 1)
    pi.write(RX_VECTOR_SS_PIN, 1)
    print("SPI RECEIVE phase complete, SS lines deasserted.")

# Receive psi_matrix back
def receive_psi_matrix():
    print("-- SPI TRANSMIT PHASE: Waiting for psi_matrix_done...")
    while not pi.read(PSI_DONE_PIN):
        sleep(0.01)
    print("psi_matrix_done detected!")
    pi.write(ENABLE_PIN, 0)
    pi.write(TX_SS_PIN, 0)
    print("Transmit mode enabled, SS low.")
    sleep(PRE_SPI_DELAY)
    received = []
    print(f"Starting loop to recieve: {num_vector * 30}")
    for i in range(num_vector * 30):
        bits = ''
        ignore = (i != 0)
        print(f"Receiving psi word {i+1} (ignore_first={ignore})")
        while len(bits) < WORD_LENGTH:
            pi.write(TX_SCLK_PIN, 1)
            sleep(HALF_PERIOD)
            if not ignore:
                bits += '1' if pi.read(TX_MISO_PIN) else '0'
            else:
                ignore = False
            pi.write(TX_SCLK_PIN, 0)
            sleep(HALF_PERIOD)
        received.append(bits)
        print(f"  Received word {i+1}: {bits}")
    pi.write(TX_SS_PIN, 1)
    print("SPI TRANSMIT phase complete, SS deasserted.")
    sleep(TX_EXTRA_DELAY1)
    sleep(TX_EXTRA_DELAY2)
    return received

# Cleanup
def cleanup():
    print("Cleaning up: resetting all pins to inputs...")
    for p in all_pins:
        pi.set_mode(p, pigpio.INPUT)
    pi.stop()
    print("Cleanup done.")

# Main

import numpy as np
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

def main():
    print("### Starting SPI retrain script ###")
    try:
        pulse_reset()
        send_matrix_vector()
        psi_matrix = receive_psi_matrix()   # list of 72‑bit strings
        sleep(FINAL_DELAY)
        print("### SPI retransmit complete ###")

        # build your complex matrix as before
        float_pairs = [word_to_floats(w) for w in psi_matrix]
        complex_vals = np.array([r + 1j*i for r, i in float_pairs])
        if complex_vals.size % 2 != 0:
            raise ValueError("Odd number of complex values!")
        cm = complex_vals.reshape(2, -1)   # shape -> (2, N)

        mask = np.all(
            (np.abs(cm.real) <= 1.5) &
            (np.abs(cm.imag) <= 1.5),
            axis=0
        )
        cm = cm[:, mask]
        print(f"Filtered out {(~mask).sum()} vectors; remaining shape = {cm.shape}")

        # full‑precision CSV
        df_full = pd.DataFrame(cm)
        df_full.to_csv('complex_matrix_full.csv', index=False, header=False)

        # 3‑decimal CSV
        df_rounded = df_full.applymap(lambda z: f"{z.real:.3f}{z.imag:+.3f}j")
        df_rounded.to_csv('complex_matrix_3dp.csv', index=False, header=False)

        print("Wrote:")
        print(" • complex_matrix_full.csv   (full precision)")
        print(" • complex_matrix_3dp.csv    (rounded to 3 decimals)")

        # --- compute and plot quantum probabilities ---
        # probability for each basis state = |amplitude|^2
        prob_matrix = np.abs(cm)**2    # shape: (2, N)

        # x-axis: vector indices
        x = np.linspace(0,np.pi,30)

        plt.figure()
        plt.plot(x, prob_matrix[0], linestyle='-',   label='State 0')
        plt.plot(x, prob_matrix[1], linestyle='--', label='State 1')
        plt.xlabel('Time Index')
        plt.ylabel('Probability')
        plt.title('Quantum State Probabilities')
        plt.legend()
        plt.grid(True)

        # save and (optionally) display
        plt.savefig('state_probabilities.png')
        print("Saved plot to state_probabilities.png")
        # plt.show()

    except KeyboardInterrupt:
        print("KeyboardInterrupt detected: aborting...")
    finally:
        cleanup()

if __name__ == '__main__':
    main()

