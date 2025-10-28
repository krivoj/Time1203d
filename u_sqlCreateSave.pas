unit u_sqlCreateSave;

interface

uses
  System.SysUtils, System.Classes,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def, FireDAC.Stan.Param, FireDAC.Stan.Async,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef;

procedure SQLiteCreateSave(const DBFile: string);

implementation

const
  SQLScriptCreateSave: string =
    'BEGIN TRANSACTION;' + sLineBreak +
    'DROP TABLE IF EXISTS "market";' + sLineBreak +
    'CREATE TABLE "market" (' + sLineBreak +
    '  "guid" INTEGER PRIMARY KEY AUTOINCREMENT,' + sLineBreak +
    '  "guidplayer" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "name" TEXT,' + sLineBreak +
    '  "sellprice" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "guidteam" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "speed" INTEGER NOT NULL DEFAULT 1,' + sLineBreak +
    '  "defense" INTEGER NOT NULL DEFAULT 1,' + sLineBreak +
    '  "passing" INTEGER NOT NULL DEFAULT 1,' + sLineBreak +
    '  "ballcontrol" INTEGER NOT NULL DEFAULT 1,' + sLineBreak +
    '  "shot" INTEGER NOT NULL DEFAULT 1,' + sLineBreak +
    '  "heading" INTEGER NOT NULL DEFAULT 1,' + sLineBreak +
    '  "talentid1" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "talentid2" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "talentid3" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "talentid4" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "history" TEXT NOT NULL DEFAULT ''0,0,0,0,0,0'',' + sLineBreak +
    '  "xp" TEXT NOT NULL DEFAULT ''0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0'',' + sLineBreak +
    '  "matches_played" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "matches_left" INTEGER NOT NULL DEFAULT 570,' + sLineBreak +
    '  "face" INTEGER NOT NULL DEFAULT 1,' + sLineBreak +
    '  "country" INTEGER NOT NULL DEFAULT 1,' + sLineBreak +
    '  "fitness" INTEGER NOT NULL DEFAULT 1,' + sLineBreak +
    '  "morale" INTEGER NOT NULL DEFAULT 1' + sLineBreak +
    ');' + sLineBreak +

    'DROP TABLE IF EXISTS "players";' + sLineBreak +
    'CREATE TABLE "players" (' + sLineBreak +
    '  "guid" INTEGER PRIMARY KEY AUTOINCREMENT,' + sLineBreak +
    '  "team" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "name" TEXT,' + sLineBreak +
    '  "matchesplayed" INTEGER NOT NULL DEFAULT 0' + sLineBreak +
    ');' + sLineBreak +

    'DROP TABLE IF EXISTS "results";' + sLineBreak +
    'CREATE TABLE "results" (' + sLineBreak +
    '  "guid" INTEGER PRIMARY KEY AUTOINCREMENT,' + sLineBreak +
    '  "country" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "division" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "season" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "round" INTEGER NOT NULL DEFAULT 0' + sLineBreak +
    ');' + sLineBreak +

    'DROP TABLE IF EXISTS "save";' + sLineBreak +
    'CREATE TABLE "save" (' + sLineBreak +
    '  "guidteam" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "teamname" TEXT,' + sLineBreak +
    '  "country" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "season" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "round" INTEGER NOT NULL DEFAULT 0' + sLineBreak +
    ');' + sLineBreak +

    'DROP TABLE IF EXISTS "teams";' + sLineBreak +
    'CREATE TABLE "teams" (' + sLineBreak +
    '  "guid" INTEGER PRIMARY KEY AUTOINCREMENT,' + sLineBreak +
    '  "worldteam" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "country" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "teamname" TEXT NOT NULL,' + sLineBreak +
    '  "money" INTEGER NOT NULL DEFAULT 500' + sLineBreak +
    ');' + sLineBreak +

    'DROP TABLE IF EXISTS "transfers";' + sLineBreak +
    'CREATE TABLE "transfers" (' + sLineBreak +
    '  "guid" INTEGER PRIMARY KEY AUTOINCREMENT,' + sLineBreak +
    '  "action" TEXT,' + sLineBreak +
    '  "seller" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "buyer" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "playerguid" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "price" INTEGER NOT NULL DEFAULT 0,' + sLineBreak +
    '  "actiondate" TEXT DEFAULT CURRENT_TIMESTAMP' + sLineBreak +
    ');' + sLineBreak +

    'COMMIT;';

procedure SQLiteCreateSave(const DBFile: string);
var
  Conn: TFDConnection;
  DriverLink: TFDPhysSQLiteDriverLink;
  SQLScript: TStringList;
  SQLCommands: TArray<string>;
  i: Integer;
  Cmd: string;
  FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
begin
  // Se il file esiste e vuoi ricrearlo
    if FileExists(DBFile) then
      DeleteFile(DBFile);

  FDPhysSQLiteDriverLink1:= TFDPhysSQLiteDriverLink.Create(nil);


  Conn := TFDConnection.Create(nil);
  Conn.DriverName := 'SQLite';
  SQLScript := TStringList.Create;
  try
    Conn.DriverName := 'SQLite';
    Conn.Params.Database := DBFile;
    Conn.LoginPrompt := False;
    Conn.Connected := True;

    SQLScript.Text := SQLScriptCreateSave;

    SQLScript.Text := SQLScript.Text.Replace('--', '').Replace('/*', '').Replace('*/', '');

    SQLCommands := SQLScript.Text.Split([';']);

    for i := 0 to Length(SQLCommands) - 1 do
    begin
      Cmd := Trim(SQLCommands[i]);
      if Cmd <> '' then
      begin
        try
          Conn.ExecSQL(Cmd);
        except
          on E: Exception do
            Writeln('Errore eseguendo comando: ' + E.Message + sLineBreak + Cmd);
        end;
      end;
    end;

  finally
    SQLScript.Free;
    Conn.Free;
    DriverLink.Free;
  end;
end;

end.

