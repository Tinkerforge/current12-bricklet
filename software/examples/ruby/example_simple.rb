#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_current12'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
UID = 'XYZ' # Change XYZ to the UID of your Current12 Bricklet

ipcon = IPConnection.new # Create IP connection
c = BrickletCurrent12.new UID, ipcon # Create device object

ipcon.connect HOST, PORT # Connect to brickd
# Don't use device before ipcon is connected

# Get current current
current = c.get_current
puts "Current: #{current/1000.0} A"

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
