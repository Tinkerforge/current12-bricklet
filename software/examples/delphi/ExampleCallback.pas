program ExampleCallback;

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
    procedure CurrentCB(const current: smallint);
    procedure Execute;
  end;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = '9yW'; { Change to your UID }

var
  e: TExample;

{ Callback function for current callback (parameter has unit mA) }
procedure TExample.CurrentCB(const current: smallint);
begin
  WriteLn(Format('Current: %f A', [current/1000.0]));
end;

procedure TExample.Execute;
begin
  { Create IP connection to brickd }
  ipcon := TIPConnection.Create(HOST, PORT);

  { Create device object }
  c := TBrickletCurrent12.Create(UID);

  { Add device to IP connection }
  ipcon.AddDevice(c);
  { Don't use device before it is added to a connection }

  { Set Period for current callback to 1s (1000ms)
    Note: The current callback is only called every second if the
          current has changed since the last call! }
  c.SetCurrentCallbackPeriod(1000);

  { Register current callback to procedure CurrentCB }
  c.OnCurrent := {$ifdef FPC}@{$endif}CurrentCB;

  WriteLn('Press key to exit');
  ReadLn;
  ipcon.Destroy;
end;

begin
  e := TExample.Create;
  e.Execute;
  e.Destroy;
end.
