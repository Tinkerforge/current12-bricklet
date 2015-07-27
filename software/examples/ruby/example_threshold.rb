#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_current12'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
UID = 'XYZ' # Change to your UID

ipcon = IPConnection.new # Create IP connection
c12 = BrickletCurrent12.new UID, ipcon # Create device object

ipcon.connect HOST, PORT # Connect to brickd
# Don't use device before ipcon is connected

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
c12.set_debounce_period 10000

# Register threshold reached callback for current greater than 5 A (parameter has unit mA)
c12.register_callback(BrickletCurrent12::CALLBACK_CURRENT_REACHED) do |current|
  puts "Current: #{current/1000.0} A"
end

# Configure threshold for "greater than 5 A" (unit is mA)
c12.set_current_callback_threshold '>', 5*1000, 0

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
