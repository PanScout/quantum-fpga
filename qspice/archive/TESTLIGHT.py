#!/usr/bin/env python3
"""
toggle_pin.py

Each time you run this script, it reads the last output state of GPIO pin (BCM) 
from a hidden file, inverts it, drives the pin to the new state, and saves it.
Because we don’t call pi.stop(), the pin remains driven after exit.
"""

import pigpio
import os
import sys

# ---- Configuration ----
# Use BCM numbering: PIN = the Broadcom GPIO number you want to toggle.
PIN23 = 24
#PIN24 = 25


# ---- Connect to pigpio daemon ----
pi = pigpio.pi()

# ---- Set pin as output ----
pi.set_mode(PIN23, pigpio.OUTPUT)
#pi.set_mode(PIN24, pigpio.OUTPUT)

pi.write(PIN23, 1)
#pi.write(PIN24, 1)

# Note: we do NOT call pi.stop() here, so the pin remains driven
