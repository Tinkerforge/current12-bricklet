import com.tinkerforge.BrickletCurrent12;
import com.tinkerforge.IPConnection;

public class ExampleCallback {
	private static final String host = "localhost";
	private static final int port = 4223;
	private static final String UID = "ABC"; // Change to your UID
	
	// Note: To make the example code cleaner we do not handle exceptions. Exceptions you
	//       might normally want to catch are described in the commnents below
	public static void main(String args[]) throws Exception {
		// Create connection to brickd
		IPConnection ipcon = new IPConnection(host, port); // Can throw IOException
		BrickletCurrent12 c12 = new BrickletCurrent12(UID); // Create device object

		// Add device to IP connection
		ipcon.addDevice(c12); // Can throw IPConnection.TimeoutException
		// Don't use device before it is added to a connection

		// Set Period for current callback to 1s (1000ms)
		// Note: The current callback is only called every second if the 
		//       current has changed since the last call!
		c12.setCurrentCallbackPeriod(1000);

		// Add and implement current listener (called if current changes)
		c12.addListener(new BrickletCurrent12.CurrentListener() {
			public void current(short current) {
				System.out.println("Current: " + current/1000.0 + " A");
			}
		});

		System.out.println("Press ctrl+c to exit");
		ipcon.joinThread();
	}
}
