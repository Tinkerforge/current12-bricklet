using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "ABC"; // Change to your UID

	static void Main() 
	{
		IPConnection ipcon = new IPConnection(HOST, PORT); // Create connection to brickd
		BrickletCurrent12 c12 = new BrickletCurrent12(UID); // Create device object
		ipcon.AddDevice(c12); // Add device to IP connection
		// Don't use device before it is added to a connection

		// Get current current (unit is mA)
		short current = c12.GetCurrent();

		System.Console.WriteLine("Current: " + current/1000.0 + " A");

		System.Console.WriteLine("Press key to exit");
		System.Console.ReadKey();
		ipcon.Destroy();
	}
}
