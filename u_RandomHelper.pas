unit u_RandomHelper;

interface
uses u_Random;
var
  RandGen: TtdCombinedPRNG;

  function RndGenerate(Upper: Integer): Integer;
  function RndGenerate0(Upper: Integer): Integer;
  function RndGenerateRange(Lower, Upper: Integer): Integer;

implementation

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

initialization
  RandGen:= TtdCombinedPRNG.Create (0,0);
Finalization
  RandGen.Free;
end.
