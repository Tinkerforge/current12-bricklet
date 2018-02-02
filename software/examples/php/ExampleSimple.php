<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletCurrent12.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletCurrent12;

const HOST = 'localhost';
const PORT = 4223;
const UID = 'XYZ'; // Change XYZ to the UID of your Current12 Bricklet

$ipcon = new IPConnection(); // Create IP connection
$c = new BrickletCurrent12(UID, $ipcon); // Create device object

$ipcon->connect(HOST, PORT); // Connect to brickd
// Don't use device before ipcon is connected

// Get current current
$current = $c->getCurrent();
echo "Current: " . $current/1000.0 . " A\n";

echo "Press key to exit\n";
fgetc(fopen('php://stdin', 'r'));
$ipcon->disconnect();

?>
