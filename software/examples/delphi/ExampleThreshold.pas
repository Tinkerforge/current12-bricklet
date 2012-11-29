program ExampleThreshold;

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
    procedure ReachedCB(const current: smallint);
    procedure Execute;
  end;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = '9yW'; { Change to your UID }

var
  e: TExample;

{ Callback for current greater than 5A }
procedure TExample.ReachedCB(const current: smallint);
begin
  WriteLn(Format('Current is greater than 5A: %f', [current/1000.0]));
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

  { Get threshold callbacks with a debounce time of 10 seconds (10000ms) }
  c.SetDebouncePeriod(10000);

  { Register threshold reached callback to procedure ReachedCB }
  c.OnCurrentReached := {$ifdef FPC}@{$endif}ReachedCB;

  { Configure threshold for "greater than 5A" (unit is mA) }
  c.SetCurrentCallbackThreshold('>', 5*1000, 0);

  WriteLn('Press key to exit');
  ReadLn;
  ipcon.Destroy;
end;

begin
  e := TExample.Create;
  e.Execute;
  e.Destroy;
end.