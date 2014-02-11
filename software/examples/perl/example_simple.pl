#!/usr/bin/perl

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletCurrent12;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'abd2'; # Change to your UID

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $c12 = Tinkerforge::BrickletCurrent12->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Get current current (unit is mA)
my $current = $c12->get_current();

print "\nCurrent: ".$current/1000.0." A\n";

print "\nPress any key to exit...\n";
<STDIN>;
$ipcon->disconnect();
