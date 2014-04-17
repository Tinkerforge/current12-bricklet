function matlab_example_callback()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletCurrent12;

    HOST = 'localhost';
    PORT = 4223;
    UID = '555'; % Change to your UID
    
    ipcon = IPConnection(); % Create IP connection
    vc = BrickletCurrent12(UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current current (unit is mA)
    current = vc.getCurrent();
    fprintf('Current: %g A\n', current/1000.0);

    input('Press any key to exit...\n', 's');
    ipcon.disconnect();
end