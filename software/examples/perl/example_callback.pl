#!/usr/bin/perl

use strict;
use Tinkerforge::IPConnection;
use Tinkerforge::BrickletCurrent12;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change XYZ to the UID of your Current12 Bricklet

# Callback subroutine for current callback
sub cb_current
{
    my ($current) = @_;

    print "Current: " . $current/1000.0 . " A\n";
}

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $c = Tinkerforge::BrickletCurrent12->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Register current callback to subroutine cb_current
$c->register_callback($c->CALLBACK_CURRENT, 'cb_current');

# Set period for current callback to 1s (1000ms)
# Note: The current callback is only called every second
#       if the current has changed since the last call!
$c->set_current_callback_period(1000);

print "Press key to exit\n";
<STDIN>;
$ipcon->disconnect();
