using System;
using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change XYZ to the UID of your Current12 Bricklet

	// Callback function for current callback (parameter has unit mA)
	static void CurrentCB(BrickletCurrent12 sender, short current)
	{
		Console.WriteLine("Current: " + current/1000.0 + " A");
	}

	static void Main()
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletCurrent12 c = new BrickletCurrent12(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Register current callback to function CurrentCB
		c.CurrentCallback += CurrentCB;

		// Set period for current callback to 1s (1000ms)
		// Note: The current callback is only called every second
		//       if the current has changed since the last call!
		c.SetCurrentCallbackPeriod(1000);

		Console.WriteLine("Press enter to exit");
		Console.ReadLine();
		ipcon.Disconnect();
	}
}
