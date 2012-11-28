#!/usr/bin/env python
# -*- coding: utf-8 -*-  

HOST = "localhost"
PORT = 4223
UID = "ABCD" # Change to your UID

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_current12 import Current12

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    c = Current12(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected

    # Get current current (unit is mA)
    current = c.get_current()

    print('Current: ' + str(current/1000.0) + ' A')

    raw_input('Press key to exit\n') # Use input() in Python 3
    ipcon.destroy()
