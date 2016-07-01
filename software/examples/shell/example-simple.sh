#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change XYZ to the UID of your Current12 Bricklet

# Get current current (unit is mA)
tinkerforge call current12-bricklet $uid get-current
