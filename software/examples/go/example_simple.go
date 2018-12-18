package main

import (
	"fmt"
	"github.com/tinkerforge/go-api-bindings/current12_bricklet"
	"github.com/tinkerforge/go-api-bindings/ipconnection"
)

const ADDR string = "localhost:4223"
const UID string = "XYZ" // Change XYZ to the UID of your Current12 Bricklet.

func main() {
	ipcon := ipconnection.New()
	defer ipcon.Close()
	c, _ := current12_bricklet.New(UID, &ipcon) // Create device object.

	ipcon.Connect(ADDR) // Connect to brickd.
	defer ipcon.Disconnect()
	// Don't use device before ipcon is connected.

	// Get current current.
	current, _ := c.GetCurrent()
	fmt.Printf("Current: %f A\n", float64(current)/1000.0)

	fmt.Print("Press enter to exit.")
	fmt.Scanln()

}
