var Tinkerforge = require('tinkerforge');

var HOST = 'localhost';
var PORT = 4223;
var UID = 'XYZ'; // Change to your UID

var ipcon = new Tinkerforge.IPConnection(); // Create IP connection
var c = new Tinkerforge.BrickletCurrent12(UID, ipcon); // Create device object

ipcon.connect(HOST, PORT,
    function (error) {
        console.log('Error: ' + error);
    }
); // Connect to brickd
// Don't use device before ipcon is connected

ipcon.on(Tinkerforge.IPConnection.CALLBACK_CONNECTED,
    function (connectReason) {
        // Get threshold callbacks with a debounce time of 10 seconds (10000ms)
        c.setDebouncePeriod(10000);

        // Configure threshold for current "greater than 5 A" (unit is mA)
        c.setCurrentCallbackThreshold('>', 5*1000, 0);
    }
);

// Register current reached callback
c.on(Tinkerforge.BrickletCurrent12.CALLBACK_CURRENT_REACHED,
    // Callback function for current reached callback (parameter has unit mA)
    function (current) {
        console.log('Current: ' + current/1000.0 + ' A');
    }
);

console.log('Press key to exit');
process.stdin.on('data',
    function (data) {
        ipcon.disconnect();
        process.exit(0);
    }
);
