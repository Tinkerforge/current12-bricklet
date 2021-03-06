program ExampleSimple;

{$ifdef MSWINDOWS}{$apptype CONSOLE}{$endif}
{$ifdef FPC}{$mode OBJFPC}{$H+}{$endif}

uses
  SysUtils, IPConnection, BrickletCurrent12;

type
  TExample = class
  private
    ipcon: TIPConnection;
    c: TBrickletCurrent12;
  public
    procedure Execute;
  end;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = 'XYZ'; { Change XYZ to the UID of your Current12 Bricklet }

var
  e: TExample;

procedure TExample.Execute;
var current: smallint;
begin
  { Create IP connection }
  ipcon := TIPConnection.Create;

  { Create device object }
  c := TBrickletCurrent12.Create(UID, ipcon);

  { Connect to brickd }
  ipcon.Connect(HOST, PORT);
  { Don't use device before ipcon is connected }

  { Get current current }
  current := c.GetCurrent;
  WriteLn(Format('Current: %f A', [current/1000.0]));

  WriteLn('Press key to exit');
  ReadLn;
  ipcon.Destroy; { Calls ipcon.Disconnect internally }
end;

begin
  e := TExample.Create;
  e.Execute;
  e.Destroy;
end.
