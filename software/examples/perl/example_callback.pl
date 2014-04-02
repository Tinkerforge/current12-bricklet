#!/usr/bin/perl

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletCurrent12;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'abd2'; # Change to your UID

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $c12 = Tinkerforge::BrickletCurrent12->new(&UID, $ipcon); # Create device object

# Callback function for current callback (parameter has unit mA)
sub cb_current
{
    my ($current) = @_;

    print "Current: ".$current/1000.0." A\n";
}

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Set Period for current callback to 1s (1000ms)
# Note: The callback is only called every second if the
#       current has changed since the last call!
$c12->set_current_callback_period(1000);

# Register current callback to function cb_current
$c12->register_callback($c12->CALLBACK_CURRENT, 'cb_current');

print "Press any key to exit...\n";
<STDIN>;
$ipcon->disconnect();
