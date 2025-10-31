unit u_PlayerModel;

interface
uses
  System.SysUtils, System.Classes, System.UITypes, System.Types, System.Variants,
  FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Viewport3D, System.Math.Vectors, FMX.Controls3D , FMX.Objects3D,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.objects, FMX.materialSources ,FMX.OBJ.importer, u_SqlcreateSave, math,
  FMX.Types,u_tileGrid;

Type TGridCell = record
  GridIndex, CellX, CellY : Integer;
end;

type
  TPlayerModel = class
  private
    FCellX: Integer;
    FCellY: Integer;
    FLabel3D: TText3D;
    FFSurname: string;
    function GetGridCells : TGridCell;
    procedure SetSurname(const Value: string);
  public
    FModel: TModel3D;
    FGridIndex: Integer;
    constructor Create(AOwner: TComponent; AViewport: TViewport3D;
                       const ObjPath: string; const ATexture: TTextureMaterialSource;
                       InitX, InitY: Single);
    constructor CreateFromClone(AOwner: TComponent; AViewport: TViewport3D;
                                         BaseModel: TModel3D;
                                         const ATexture: TTextureMaterialSource;
                                         InitX, InitY: Single);
    destructor Destroy; override;
    procedure SetPosition(X, Y, Z: Single);
    procedure SetGridPosition ( AGridIndex, ACellX, ACellY: integer);
    procedure Free;
    property CellX: integer read FCellX write FCellX;
    property CellY: integer read FCellY write FCellY;
    property Cells: TGridCell read GetGridCells;
    property GridIndex: Integer read FGridIndex write FGridIndex;
    property FSurname: string read FFSurname write SetSurname;
  end;
implementation
constructor TPlayerModel.Create(AOwner: TComponent; AViewport: TViewport3D;
                                const ObjPath: string; const ATexture: TTextureMaterialSource;
                                InitX, InitY: Single);
var
  Mat: TColorMaterialSource;
  Mesh: TMesh;
begin
  // Crea il contenitore del modello
  FModel := TModel3D.Create(AOwner);
  FModel.Parent := AViewport;

  // Carica il file OBJ
  FModel.LoadFromFile(ObjPath);

  for Mesh in FModel.MeshCollection do
    Mesh.MaterialSource := ATexture;

  FModel.RotationAngle.X := 180;

  // Scala il modello (puoi regolare)
  FModel.Scale.X := 1;
  FModel.Scale.Y := 1;
  FModel.Scale.Z := 1;

  // Posiziona inizialmente sopra la tile
  SetPosition(InitX, InitY, 0);
end;

constructor TPlayerModel.CreateFromClone(AOwner: TComponent; AViewport: TViewport3D;
                                         BaseModel: TModel3D;
                                         const ATexture: TTextureMaterialSource;
                                         InitX, InitY: Single);
var
  Mesh: TMesh;
begin
  // Duplica il modello già caricato
  FModel := TModel3D(BaseModel.Clone(AOwner));
  FModel.Parent := AViewport;
  FModel.Visible := True;
  FModel.HitTest := False;
  // Applica la texture a tutte le mesh
  for Mesh in FModel.MeshCollection do
    Mesh.MaterialSource := ATexture;

  // Impostazioni di base
  FModel.RotationAngle.X := 180;
  FModel.Scale.X := 1;
  FModel.Scale.Y := 1;
  FModel.Scale.Z := 1;

  SetPosition(InitX, InitY, 0.42);

  // 🔹 Etichetta 3D con il cognome
  FLabel3D := TText3D.Create(FModel);
  FLabel3D.Parent := FModel;  // figlia del modello → si muove con lui
  FLabel3D.HitTest := false;
  FLabel3D.Depth := 0.3;
  FLabel3D.Width := 3;
  FLabel3D.Height := 2;
  FLabel3D.Font.Size :=1;
  FLabel3D.Scale.Point := Point3D(0.27, 0.27, 0.27);
  FLabel3D.Position.Point := Point3D(0, 0, 0.42 );
  FLabel3D.MaterialSource := TColorMaterialSource.Create(AOwner);
  (FLabel3D.MaterialSource as TColorMaterialSource).Color := TAlphaColorRec.Silver;

end;

destructor TPlayerModel.Destroy;
begin
  FModel.Free;  // liberando il modello, anche la label 3D viene liberata
  inherited;
end;

procedure TPlayerModel.SetSurname(const Value: string);
begin
  FFSurname := Value;
  //if Assigned(FLabel3D) then
    FLabel3D.Text := Value;
end;

procedure TPlayerModel.Free;
begin
  if FModel <> nil then
    FModel.free;
end;
procedure TPlayerModel.SetGridPosition ( AGridIndex, ACellX, ACellY: integer);
begin
  FGridIndex := AGridIndex;
  FCellX := ACellX;
  FCellY := ACellY;
end;
procedure TPlayerModel.SetPosition(X, Y, Z: Single);
begin
  FModel.Position.Point := Point3D(X, Y, Z);
end;
function TPlayerModel.GetGridCells: TGridCell;
begin
  Result.GridIndex := FGridIndex;
  Result.CellX := FCellX;
  Result.CellY := FCellY;
end;

end.
