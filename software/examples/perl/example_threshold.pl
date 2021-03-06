#!/usr/bin/perl

use strict;
use Tinkerforge::IPConnection;
use Tinkerforge::BrickletCurrent12;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change XYZ to the UID of your Current12 Bricklet

# Callback subroutine for current reached callback
sub cb_current_reached
{
    my ($current) = @_;

    print "Current: " . $current/1000.0 . " A\n";
}

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $c = Tinkerforge::BrickletCurrent12->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
$c->set_debounce_period(10000);

# Register current reached callback to subroutine cb_current_reached
$c->register_callback($c->CALLBACK_CURRENT_REACHED, 'cb_current_reached');

# Configure threshold for current "greater than 5 A"
$c->set_current_callback_threshold('>', 5*1000, 0);

print "Press key to exit\n";
<STDIN>;
$ipcon->disconnect();
