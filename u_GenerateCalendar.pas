unit u_GenerateCalendar;

interface

uses
  System.SysUtils, System.Classes,
  FireDAC.Comp.Client;

procedure GenerateCalendar(MainConn, SaveDbConn: TFDConnection; SaveFile: string);

implementation

uses
  System.Generics.Collections, System.Math, Data.DB, FireDAC.Comp.DataSet, u_Random;

type
  TInt64List = TList<Int64>;
  TPairInt64 = TPair<Int64, Int64>;
  TRound = TList<TPairInt64>;
  TRounds = TList<TRound>;

var
  RandGen: TtdCombinedPRNG;

  function RndGenerate(Upper: Integer): Integer;
  begin
    Result := Trunc(RandGen.AsLimitedDouble(1, Upper + 1));
  end;

  function RndGenerate0(Upper: Integer): Integer;
  begin
    Result := Trunc(RandGen.AsLimitedDouble(0, Upper + 1));
  end;

  function RndGenerateRange(Lower, Upper: Integer): Integer;
  begin
    Result := Trunc(RandGen.AsLimitedDouble(Lower, Upper + 1));
  end;

// ----------------------------- helpers -------------------------------------

procedure ShuffleList(List: TInt64List);
var
  i, j: Integer;
  tmp: Int64;
begin
  // Fisher-Yates shuffle usando TtdCombinedPRNG
  for i := List.Count - 1 downto 1 do
  begin
    j := RndGenerate0(i); // genera un numero casuale tra 0 e i
    tmp := List[i];
    List[i] := List[j];
    List[j] := tmp;
  end;
end;

// Generate round-robin rounds using circle method. Expects even number of teams.
function GenerateRoundRobin(const Teams: TInt64List): TRounds;
var
  temp: TInt64List;
  n, roundCount, i, j: Integer;
  r: TRound;
  a, b: Int64;
begin
  Result := TRounds.Create;
  if Teams = nil then Exit;
  n := Teams.Count;
  if (n = 0) or (n mod 2 <> 0) then
    raise Exception.Create('GenerateRoundRobin: number of teams must be even and > 0');

  temp := TInt64List.Create;
  try
    for i := 0 to Teams.Count - 1 do
      temp.Add(Teams[i]);

    roundCount := n - 1;
    for i := 0 to roundCount - 1 do
    begin
      r := TRound.Create;
      for j := 0 to (n div 2) - 1 do
      begin
        a := temp[j];
        b := temp[n - 1 - j];
        r.Add(TPairInt64.Create(a, b));
      end;
      Result.Add(r);

      // rotate (keep first element fixed)
      if n > 2 then
      begin
        b := temp[temp.Count - 1];
        temp.Delete(temp.Count - 1);
        temp.Insert(1, b);
      end;
    end;
  finally
    temp.Free;
  end;
end;

procedure FreeRounds(var Rounds: TRounds);
var
  i: Integer;
begin
  if Rounds = nil then Exit;
  for i := 0 to Rounds.Count - 1 do
    Rounds[i].Free;
  Rounds.Free;
  Rounds := nil;
end;

// Create calendar table in SaveDb if it doesn't exist
procedure EnsureCalendarTable(Conn: TFDConnection);
const
  SQLCreate: string =
    'CREATE TABLE IF NOT EXISTS calendar(' +
    ' guid INTEGER PRIMARY KEY AUTOINCREMENT,' +
    ' country INTEGER NOT NULL,' +
    ' division INTEGER NOT NULL,' +
    ' round INTEGER NOT NULL,' +
    ' team0 INTEGER NOT NULL,' +
    ' team1 INTEGER NOT NULL' +
    ');';
begin
  Conn.ExecSQL(SQLCreate);
end;

// Insert all matches of a round into calendar using parameterized insert
procedure InsertRoundMatches(SaveConn: TFDConnection; CountryGuid: Int64;
  Division: Integer; RoundNumber: Integer; RoundMatches: TRound; InvertTeams: Boolean);
var
  Q: TFDQuery;
  i: Integer;
  t0, t1: Int64;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := SaveConn;
    Q.SQL.Text := 'INSERT INTO calendar(country, division, round, team0, team1) ' +
                  'VALUES (:country, :division, :round, :team0, :team1)';
    for i := 0 to RoundMatches.Count - 1 do
    begin
      if InvertTeams then
      begin
        t0 := RoundMatches[i].Value;
        t1 := RoundMatches[i].Key;
      end
      else
      begin
        t0 := RoundMatches[i].Key;
        t1 := RoundMatches[i].Value;
      end;

      Q.Params.ParamByName('country').AsLargeInt := CountryGuid;
      Q.Params.ParamByName('division').AsInteger := Division;
      Q.Params.ParamByName('round').AsInteger := RoundNumber;
      Q.Params.ParamByName('team0').AsLargeInt := t0;
      Q.Params.ParamByName('team1').AsLargeInt := t1;
      Q.ExecSQL;
    end;
  finally
    Q.Free;
  end;
end;

// ---------------------------------------------------------------------------
// Core: Generate for a single country
// ---------------------------------------------------------------------------
procedure GenerateForCountry(MainConn, SaveConn: TFDConnection; CountryGuid: Int64);
var
  UsedTeams: TDictionary<Int64, Boolean>;
  TeamsList: TInt64List;
  PoolList: TInt64List;
  GroupList: TInt64List;
  Rounds: TRounds;
  i, r, division, baseRoundCount: Integer;

  procedure SelectTeamsByDivision(Division: Integer; CountNeeded: Integer; OutList: TInt64List);
  var
    qSel: TFDQuery;
  begin
    OutList := TInt64List.Create;
    qSel := TFDQuery.Create(nil);
    try
      qSel.Connection := MainConn;
      qSel.SQL.Text := 'SELECT guid FROM teams WHERE country = :c AND avgdivision = :a';
      qSel.Params.ParamByName('c').AsLargeInt := CountryGuid;
      qSel.Params.ParamByName('a').AsInteger := Division;
      qSel.Open;
      while not qSel.Eof do
      begin
        if not UsedTeams.ContainsKey(qSel.Fields[0].AsLargeInt) then
          OutList.Add(qSel.Fields[0].AsLargeInt);
        qSel.Next;
      end;
      // shuffle and trim to needed count
      ShuffleList(OutList);
      while OutList.Count > CountNeeded do
        OutList.Delete(RndGenerate0(OutList.Count - 1));
    finally
      qSel.Free;
    end;
  end;

  function SelectZeroPool: TInt64List;
  var
    qSel: TFDQuery;
  begin
    Result := TInt64List.Create;
    qSel := TFDQuery.Create(nil);
    try
      qSel.Connection := MainConn;
      qSel.SQL.Text := 'SELECT guid FROM teams WHERE country = :c AND avgdivision = 0';
      qSel.Params.ParamByName('c').AsLargeInt := CountryGuid;
      qSel.Open;
      while not qSel.Eof do
      begin
        if not UsedTeams.ContainsKey(qSel.Fields[0].AsLargeInt) then
          Result.Add(qSel.Fields[0].AsLargeInt);
        qSel.Next;
      end;
      ShuffleList(Result);
      while Result.Count > 48 do
        Result.Delete(RndGenerate0(Result.Count - 1));
    finally
      qSel.Free;
    end;
  end;

  procedure MarkUsed(L: TInt64List);
  var
    k: Integer;
  begin
    for k := 0 to L.Count - 1 do
      UsedTeams.AddOrSetValue(L[k], True);
  end;

begin
  UsedTeams := TDictionary<Int64, Boolean>.Create;
  TeamsList := nil;
  PoolList := nil;
  GroupList := nil;
  Rounds := nil;
  try
    // DIVISION 1 and 2
    for division := 1 to 2 do
    begin
      SelectTeamsByDivision(division, 20, TeamsList);
      try
        Rounds := GenerateRoundRobin(TeamsList);
        try
          baseRoundCount := TeamsList.Count - 1;
          for r := 0 to Rounds.Count - 1 do
            InsertRoundMatches(SaveConn, CountryGuid, division, r + 1, Rounds[r], False);
          for r := 0 to Rounds.Count - 1 do
            InsertRoundMatches(SaveConn, CountryGuid, division, baseRoundCount + 1 + r, Rounds[r], True);
        finally
          FreeRounds(Rounds);
          Rounds := nil;
        end;
        MarkUsed(TeamsList);
      finally
        TeamsList.Free;
        TeamsList := nil;
      end;
    end;

    // DIVISIONS 3,4,5
    PoolList := SelectZeroPool;
    try
      for division := 3 to 5 do
      begin
        GroupList := TInt64List.Create;
        try
          for i := 0 to 15 do
          begin
            GroupList.Add(PoolList[0]);
            PoolList.Delete(0);
          end;

          Rounds := GenerateRoundRobin(GroupList);
          try
            baseRoundCount := GroupList.Count - 1;
            for r := 0 to Rounds.Count - 1 do
              InsertRoundMatches(SaveConn, CountryGuid, division, r + 1, Rounds[r], False);
            for r := 0 to Rounds.Count - 1 do
              InsertRoundMatches(SaveConn, CountryGuid, division, baseRoundCount + 1 + r, Rounds[r], True);
          finally
            FreeRounds(Rounds);
            Rounds := nil;
          end;

          MarkUsed(GroupList);
        finally
          GroupList.Free;
        end;
      end;
    finally
      PoolList.Free;
    end;

  finally
    UsedTeams.Free;
  end;
end;

// ---------------------------------------------------------------------------
// Public procedure
// ---------------------------------------------------------------------------
procedure GenerateCalendar(MainConn, SaveDbConn: TFDConnection; SaveFile: string);
var
  QCountries: TFDQuery;
  CountryGuid: Int64;
begin
  if (MainConn = nil) or (SaveDbConn = nil) then
    raise Exception.Create('GenerateCalendar: both connections must be provided');

  RandGen := TtdCombinedPRNG.Create(0, 0);

  EnsureCalendarTable(SaveDbConn);
  SaveDbConn.StartTransaction;
  try
    SaveDbConn.ExecSQL('DELETE FROM calendar');

    QCountries := TFDQuery.Create(nil);
    try
      QCountries.Connection := MainConn;
      QCountries.SQL.Text := 'SELECT guid FROM countries';
      QCountries.Open;
      while not QCountries.Eof do
      begin
        CountryGuid := QCountries.FieldByName('guid').AsLargeInt;
        GenerateForCountry(MainConn, SaveDbConn, CountryGuid);
        QCountries.Next;
      end;
    finally
      QCountries.Free;
    end;

    SaveDbConn.Commit;
  except
    on E: Exception do
    begin
      try
        if SaveDbConn.InTransaction then
          SaveDbConn.Rollback;
      except
        // ignore rollback errors
      end;
      raise;
    end;
  end;

  RandGen.Free;
end;

end.

