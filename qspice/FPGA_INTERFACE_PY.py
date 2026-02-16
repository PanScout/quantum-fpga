#!/usr/bin/env python3
"""
spi_retransmit_pigpio.py

This script uses pigpio to emulate the behavior of the VHDL QPU testbench:
- Sends a 2×2 matrix and 2-element vector via SPI receive interfaces simultaneously
- Uses continuous SCLK while SS is asserted LOW
- Waits for thsue psi_matrix_done signal
- Switches to transmit mode and captures the psi_matrix output
"""

import pigpio
import time
import numpy as np
import matplotlib.pyplot as plt

def send_data(H, V, S):
 
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
    SPEED_FACTOR       = S
    PRE_SPI_DELAY      = SPEED_FACTOR * 0.02
    POST_SPI_DELAY     = SPEED_FACTOR * 0.20
    SPI_CLK_PERIOD     = SPEED_FACTOR * 0.01   # corresponds to 100 ps in simulation scaled
    HALF_PERIOD        = SPI_CLK_PERIOD       / 2
    QUARTER_PERIOD     = SPI_CLK_PERIOD       / 4
    TX_EXTRA_DELAY1    = SPEED_FACTOR * 0.42
    TX_EXTRA_DELAY2    = SPEED_FACTOR * 0.064
    FINAL_DELAY        = SPEED_FACTOR * 0.10


    # Data definitions
    WORD_LENGTH        = 108
    INT_BITS = 15
    FRAC_BITS = 39

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
        if len(word) != WORD_LENGTH:
            raise ValueError(f"Input word must be 72 bits long (got {len(word)})")

        # Each sfixed(14, -21) is 36 bits: integer bits = 14 - 0 + 1 = 15, frac bits = 0 - (-21) = 21
        # FRAC_BITS = 21
        HALF_LEN = WORD_LENGTH//2

        high_bits = word[:HALF_LEN]
        low_bits  = word[HALF_LEN:]

        # Convert each half to float
        first_value  = sfixed_to_float(high_bits, INT_BITS, FRAC_BITS)
        second_value = sfixed_to_float(low_bits,  INT_BITS, FRAC_BITS)

        return first_value, second_value


    # ---------------------------------------------------
    # Generate fixed64 bit patterns (36-bit real + 36-bit imag)
    # ---------------------------------------------------
    

    # Helper delays
    def sleep(d):
        time.sleep(d * SPEED_FACTOR)

    # Reset pulse
    def pulse_reset():
        pi.write(RESET_PIN, 1)
        sleep(POST_SPI_DELAY)
        pi.write(RESET_PIN, 0)
        sleep(POST_SPI_DELAY)

    # Continuous SPI bit banging

    def send_matrix_vector():
        pi.write(ENABLE_PIN, 1)
        pi.write(RX_MATRIX_SS_PIN, 0)
        pi.write(RX_VECTOR_SS_PIN, 0)
        sleep(PRE_SPI_DELAY)
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

    # Receive psi_matrix back
    def receive_psi_matrix():
        while not pi.read(PSI_DONE_PIN):
            sleep(0.01)
        pi.write(ENABLE_PIN, 0)
        pi.write(TX_SS_PIN, 0)
        sleep(PRE_SPI_DELAY)
        received = []
        for i in range(num_vector * 30):
            bits = ''
            ignore = (i != 0)
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
        pi.write(TX_SS_PIN, 1)
        sleep(TX_EXTRA_DELAY1)
        sleep(TX_EXTRA_DELAY2)
        return received

    # Cleanup
    def cleanup():
        for p in all_pins:
            pi.set_mode(p, pigpio.INPUT)
        pi.stop()

    # Main

    import pandas as pd

    def to_fixed64_bits(value):
        # Ensure we only process the real part for encoding
        real_value = value.real if isinstance(value, complex) else value
        scaled = int(round(real_value * (1 << FRAC_BITS)))
        
        # Handle negative numbers using two's complement representation
        # for the 54-bit half-word (WORD_LENGTH//2)
        half_word_bits = WORD_LENGTH // 2
        mask = (1 << half_word_bits) - 1 
        
        if scaled < 0:
            # Calculate two's complement for negative numbers
            # The range is -(1 << (half_word_bits - 1)) to (1 << (half_word_bits - 1)) - 1
            # Ensure the value fits within the representable range if needed, although
            # fixed-point scaling should handle this implicitly if FRAC_BITS is chosen well.
            # Python's integers handle arbitrary size, so we just need to get the
            # correct bit pattern for the lower `half_word_bits` bits.
            scaled = (1 << half_word_bits) + scaled # This performs two's complement effectively for bitwise ops

        # Get the lower bits corresponding to the fixed-point representation
        bit_str = format(scaled & mask, f'0{half_word_bits}b')

        return bit_str

    # Matrix and vector values
    matrix_vals = H.flatten().tolist()
    vector_vals = V.flatten().tolist()

    matrix_words = [to_fixed64_bits(v) + '0'*(WORD_LENGTH//2) for v in matrix_vals]
    vector_words = [to_fixed64_bits(v) + '0'*(WORD_LENGTH//2) for v in vector_vals]

    # Determine number of words and total bits
    num_matrix = len(matrix_words)
    num_vector = len(vector_words)
    num_words = max(num_matrix, num_vector)
    total_bits = num_words * WORD_LENGTH

    # Initialize pigpio
    pi = pigpio.pi()
    all_pins = [RX_MATRIX_MOSI_PIN, RX_MATRIX_SCLK_PIN, RX_MATRIX_SS_PIN,
                RX_VECTOR_MOSI_PIN, RX_VECTOR_SCLK_PIN, RX_VECTOR_SS_PIN,
                TX_SCLK_PIN, TX_SS_PIN,
                ENABLE_PIN, RESET_PIN, PSI_DONE_PIN, TX_MISO_PIN]
    for p in all_pins:
        mode = pigpio.INPUT if p in (TX_MISO_PIN, PSI_DONE_PIN) else pigpio.OUTPUT
        pi.set_mode(p, mode)

    try:
        pulse_reset()
        send_matrix_vector()
        psi_matrix = receive_psi_matrix()   # list of 72‑bit strings
        sleep(FINAL_DELAY)
        # build your complex matrix as before
        float_pairs = [word_to_floats(w) for w in psi_matrix]
        complex_vals = np.array([r + 1j*i for r, i in float_pairs])
        if complex_vals.size % 2 != 0:
            raise ValueError("Odd number of complex values!")
        

        num_rows = num_vector
        num_cols = complex_vals.size // num_rows


        cm = complex_vals.reshape((num_rows, num_cols), order='F')

        mask = np.all(
            (np.abs(cm.real) <= 1) &
            (np.abs(cm.imag) <= 1),
            axis=0
        )
        cm = cm[:, mask]

        print(f"Filtered out {(~mask).sum()} vectors; remaining shape = {cm.shape}")
        
        return cm
    except KeyboardInterrupt:
        print("KeyboardInterrupt detected: aborting...")
    finally:
        cleanup()




plt.style.use('Solarize_Light2')
    

       

