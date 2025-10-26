program Time1203d;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uTileGrid in 'uTileGrid.pas',
  uFieldLines in 'uFieldLines.pas',
  u_sqlCreateSave in 'u_sqlCreateSave.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
