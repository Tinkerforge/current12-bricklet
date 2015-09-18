#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change to your UID

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
tinkerforge call current12-bricklet $uid set-debounce-period 10000

# Handle incoming current reached callbacks (parameter has unit mA)
tinkerforge dispatch current12-bricklet $uid current-reached &

# Configure threshold for current "greater than 5 A" (unit is mA)
tinkerforge call current12-bricklet $uid set-current-callback-threshold greater 5000 0

echo "Press key to exit"; read dummy

kill -- -$$ # Stop callback dispatch in background
