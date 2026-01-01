unit u_Core;

interface
uses
u_PlayerModel, FMX.Viewport3D, system.Classes,FMX.MaterialSources, System.Generics.Collections, u_Types,FMX.Objects3D, u_Skills;

type
  TPlayer = class
  private
    function GetGridCells : TGridCell;
    procedure SetGridCells ( AGridCell: TGridCell );
    function GetDefaultCells : TGridCell ;
    procedure SetDefaultCells ( AGridCell: TGridCell );
    function GetAge : Integer;
    procedure SetSurname(const Value: string);
  public
    FGuid: Integer;
    FAge: Integer;
    Country: integer;
    FTeam: Integer;
    FGuidTeam: Integer;
    FSeasonPlayed: Integer;
    Skills: TObjectList<Tskill>;

    FPlayerModel: TPlayerModel;
    FGridIndex: Integer;
    FDefaultCellX: Integer;
    FDefaultCellY: Integer;
    FCellX: Integer;
    FCellY: Integer;
    FName, FSurname: string;
    FStamina: SmallInt;
    FDefaultStats: ArrayStats;
    Stats: ArrayStats;
    xp: integer;
    FConditioning: Integer;
    FInjuryResistance: Integer;
    constructor Create(AOwner: TComponent; AViewport: TViewport3D; const BaseModel : TModel3D; const ATexture: TTextureMaterialSource;
                       InitX, InitY: Single;
                       const AGuid, ATeam, AGuidTeam, ASeasonPlayed : integer; const aName, aSurname: string; Const rStats:ArrayStats; Const rSkills : TObjectList<TSkill>
                       );

    destructor Destroy; override;
    procedure SetGridPosition ( AGridIndex, ACellX, ACellY: integer);
    function HasSkill ( SkillId, Lvl: Integer ): boolean;

    property CellX: integer read FCellX write FCellX;
    property CellY: integer read FCellY write FCellY;
    property Cells: TGridCell read GetGridCells write SetGridCells;
    property Surname: string read FSurname write SetSurname;
    property Age: Integer read GetAge;
  end;

const
  FormationCols: array[0..4] of Integer = (3, 5, 8, 11, 13);

function CheckFormationPosition ( SelectedPlayer: TPlayer; CellX, CellY: integer ): boolean;

implementation

function CheckFormationPosition ( SelectedPlayer: TPlayer; CellX, CellY: integer ): boolean;
var
  i: integer;
begin
  Result := false;
  if (CellX = 0)  and (CellY = 5) then begin
    Result:= True;
  end
  else begin
    for I := Low(FormationCols) to High(FormationCols) do begin
      if FormationCols[i] = CellX then begin
        Result := True;
        exit;
      end;
    end;
  end;

end;
destructor TPlayer.Destroy;
begin
  if FPlayerModel <> nil then
    FPlayerModel.Free;

  inherited;
end;
constructor TPlayer.Create(AOwner: TComponent; AViewport: TViewport3D; const BaseModel: TModel3D; const ATexture: TTextureMaterialSource;
                       InitX, InitY: Single;
                       const AGuid, ATeam, AGuidTeam, AseasonPlayed : integer; const aName, aSurname: string; Const rStats:ArrayStats; Const rSkills : TObjectList<TSkill>
                       );
begin
  if BaseModel <> nil then
    FPlayerModel := TPlayerModel.Create(AOwner,AViewPort,BaseModel,ATexture,InitX,InitY);

    Skills:= rSkills;
    FGuid:= AGuid;
    FTeam := ATeam;
    FGuidTeam:= AGuidTeam;
    FSeasonPlayed := ASeasonPlayed;
    FSurname:= ASurname;
    FDefaultStats := rStats;
    Stats := rStats;

end;

procedure TPlayer.SetSurname(const Value: string);
begin
  FSurname := Value;
  if FPlayerModel.FModel <> nil then
    FPlayerModel.FLabel3D.Text := Value;
end;
function TPlayer.GetAge: integer;
begin
  Result := FSeasonPlayed + 18;
end;
procedure TPlayer.SetGridPosition ( AGridIndex, ACellX, ACellY: integer);
begin
  FGridIndex := AGridIndex;
  FCellX := ACellX;
  FCellY := ACellY;
end;
function TPlayer.GetGridCells: TGridCell;
begin
  Result.GridIndex := FGridIndex;
  Result.CellX := FCellX;
  Result.CellY := FCellY;
end;
function TPlayer.GetDefaultCells: TGridCell;
begin
  Result.GridIndex := FGridIndex;
  Result.CellX := FDefaultCellX;
  Result.CellY := FDefaultCellY;
end;
procedure TPlayer.SetGridCells ( AGridCell: TGridCell );
begin
  FGridIndex := AGridCell.GridIndex;
  FCellX := AGridCell.CellX;
  FCellY := AGridCell.CellY;
end;
procedure TPlayer.SetDefaultCells ( AGridCell: TGridCell );
begin
  FGridIndex := AGridCell.GridIndex;
  FDefaultCellX := AGridCell.CellX;
  FDefaultCellY := AGridCell.CellY;
end;
function TPlayer.HasSkill ( SkillId, Lvl: Integer ): boolean;
var
  i: Integer;
begin
  result := false;
  for I := 0 to Skills.Count -1 do begin
    if (Skills[i].Id = SkillId) and (Skills[i].Level >= Lvl) then begin
      result := True;
      Exit;
    end;
  end;
end;

end.
