#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change to your UID

# Get current current (unit is mA)
tinkerforge call current12-bricklet $uid get-current
