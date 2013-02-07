using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "ABC"; // Change to your UID

	// Callback for current greater than 5A
	static void ReachedCB(BrickletCurrent12 sender, short current)
	{
		System.Console.WriteLine("Current is greater than 5A: " + current/1000.0 + "A");
	}

	static void Main() 
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletCurrent12 c12 = new BrickletCurrent12(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get threshold callbacks with a debounce time of 1 seconds (1000ms)
		c12.SetDebouncePeriod(1000);

		// Register threshold reached callback to function ReachedCB
		c12.CurrentReached += ReachedCB;

		// Configure threshold for "greater than 5A" (unit is mA)
		c12.SetCurrentCallbackThreshold('>', 5*1000, 0);

		System.Console.WriteLine("Press key to exit");
		System.Console.ReadKey();
		ipcon.Disconnect();
	}
}
