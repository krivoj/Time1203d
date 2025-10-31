unit u_Core;

interface
uses
u_PlayerModel;

const
  FormationCols: array[0..4] of Integer = (3, 5, 8, 11, 13);

function CheckFormationPosition ( SelectedPlayer: TPlayerModel; CellX, CellY: integer ): boolean;

implementation

function CheckFormationPosition ( SelectedPlayer: TPlayerModel; CellX, CellY: integer ): boolean;
var
  i: integer;
begin
  Result := false;
  for I := Low(FormationCols) to High(FormationCols) do begin
    if FormationCols[i] = CellX then begin
      Result := True;
      exit;
    end;
  end;

end;

end.
