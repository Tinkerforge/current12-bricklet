function matlab_example_simple()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletCurrent12;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'XYZ'; % Change XYZ to the UID of your Current12 Bricklet

    ipcon = IPConnection(); % Create IP connection
    c = handle(BrickletCurrent12(UID, ipcon), 'CallbackProperties'); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current current (unit is mA)
    current = c.getCurrent();
    fprintf('Current: %g A\n', current/1000.0);

    input('Press key to exit\n', 's');
    ipcon.disconnect();
end
