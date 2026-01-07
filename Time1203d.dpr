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
  u_TileGrid in 'u_TileGrid.pas',
  u_FieldLines in 'u_FieldLines.pas',
  u_sqlCreateSave in 'u_sqlCreateSave.pas',
  u_GenerateCalendar in 'u_GenerateCalendar.pas',
  u_Random in 'u_Random.pas',
  u_SystemUtils in 'u_SystemUtils.pas',
  u_PlayerStatsPanel in 'u_PlayerStatsPanel.pas',
  u_core in 'u_core.pas',
  u_PlayerModel in 'u_PlayerModel.pas',
  u_Types in 'u_Types.pas',
  u_PlayerTemplates in 'u_PlayerTemplates.pas',
  u_RandomHelper in 'u_RandomHelper.pas',
  u_Localization in 'u_Localization.pas',
  u_skills in 'u_skills.pas',
  u_Lang in 'u_Lang.pas',
  u_PlayerSkillLayout in 'u_PlayerSkillLayout.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
