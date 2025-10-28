program Time1203d;

uses
  EMemLeaks,
  EResLeaks,
  EDialogWinAPIMSClassic,
  EDialogWinAPIEurekaLogDetailed,
  EDialogWinAPIStepsToReproduce,
  EDebugExports,
  EFixSafeCallException,
  EMapWin32,
  EAppVCL,
  ExceptionLog7,
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uTileGrid in 'uTileGrid.pas',
  uFieldLines in 'uFieldLines.pas',
  u_sqlCreateSave in 'u_sqlCreateSave.pas',
  u_GenerateCalendar in 'u_GenerateCalendar.pas',
  uRandom in 'uRandom.pas',
  u_SystemUtils in 'u_SystemUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
