unit TileGrid;

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Objects3D,
  FMX.MaterialSources, FMX.Controls3D, FMX.Viewport3D, FMX.Types3D,System.Math.Vectors;

type
  TModelTile = class
  private
    FMaterial: TTextureMaterialSource;
  public
    FPlane: TPlane;
    CellX, CellY: Integer;
    constructor Create(AOwner: TComponent; AParent: TControl3D; const TextureFile: string; X, Y, SizeX, SizeY, Depth: Single);
    procedure SetPosition(X, Y, Z: Single);
    procedure Free;
  end;

  TTileGrid = class
  private
    FViewport: TViewport3D;
    FDummyRoot: TDummy;    // contenitore root della griglia
    procedure LocalMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single;
      RayPos, RayDir: TVector3D);
  public
    FTileSizeX: Single;
    FTileSizeY: Single;
    FTileDepth: Single;
    FCols: Integer;
    FRows: Integer;
    FTiles: array of array of TModelTile;
    constructor Create(AOwner: TComponent; AViewport: TViewport3D; Rows, Cols:Integer;  const TextureFile: string);
    procedure DrawGrid;
    procedure Free;

    // Nuovi metodi
    procedure SetBasePosition(BaseX, BaseY: Single);
    procedure SetRotationZ(Angle: Single);
  end;

implementation

uses unit1;

{ TModelTile }

constructor TModelTile.Create(AOwner: TComponent; AParent: TControl3D; const TextureFile: string; X, Y, SizeX, SizeY, Depth: Single);
begin
  inherited Create;
  FMaterial := TTextureMaterialSource.Create(AOwner);
  FMaterial.Texture.LoadFromFile(TextureFile);

  FPlane := TPlane.Create(AParent);
  FPlane.Parent := AParent;
  FPlane.Width := SizeX;
  FPlane.Height := SizeY;
  FPlane.Position.Z := Depth / 2;
  FPlane.MaterialSource := FMaterial;
  SetPosition(X, Y, 0);
end;

procedure TModelTile.SetPosition(X, Y, Z: Single);
begin
  FPlane.Position.X := X;
  FPlane.Position.Y := Y;
  FPlane.Position.Z := Z;
end;

procedure TModelTile.Free;
begin
  if FPlane <> nil then
  begin
    FPlane.DisposeOf;
    FPlane := nil;
  end;
  if FMaterial <> nil then
  begin
    FMaterial.DisposeOf;
    FMaterial := nil;
  end;
end;

{ TTileGrid }

constructor TTileGrid.Create(AOwner: TComponent; AViewport: TViewport3D; Rows, Cols: integer; const TextureFile: string);
var
  i, j: Integer;
  PosX, PosY: Single;
begin
  inherited Create;
  FViewport := AViewport;
  FTileSizeX := 1.0;
  FTileSizeY := 1.0;
  FTileDepth := 0.08;

  // crea dummy root
  FDummyRoot := TDummy.Create(FViewport);
  FDummyRoot.Parent := FViewport;
  FDummyRoot.Position.Point := Point3D(0,0,0);

  FRows := Rows;
  FCols := Cols;
  SetLength(FTiles, FRows, FCols);
  for i := 0 to FRows - 1 do
    for j := 0 to FCols - 1 do
    begin
      PosX := j * FTileSizeX + FTileSizeX / 2;
      PosY := i * FTileSizeY + FTileSizeY / 2;

      FTiles[i,j] := TModelTile.Create(AOwner, FDummyRoot, TextureFile, PosX, PosY, FTileSizeX, FTileSizeY, FTileDepth);
      FTiles[i,j].FPlane.OnMouseDown := LocalMouseDown;
      FTiles[i,j].FPlane.HitTest := True;

      FTiles[i,j].CellX := j;
      FTiles[i,j].CellY := i;

      FTiles[i,j].FPlane.TagString := IntToStr(j)+'/'+IntToStr(i);
    end;
end;

procedure TTileGrid.DrawGrid;
var
  i, j: Integer;
begin
  for i := 0 to FRows - 1 do
    for j := 0 to FCols - 1 do
      FTiles[i,j].SetPosition(j * FTileSizeX + FTileSizeX/2, i * FTileSizeY + FTileSizeY/2, FTileDepth / 2);
end;

procedure TTileGrid.Free;
var
  i, j: Integer;
begin
  for i := 0 to FRows - 1 do
    for j := 0 to FCols - 1 do
      FTiles[i,j].Free;
  if FDummyRoot <> nil then
  begin
    FDummyRoot.DisposeOf;
    FDummyRoot := nil;
  end;
end;

procedure TTileGrid.LocalMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single;
  RayPos, RayDir: TVector3D);
var
  Cells: TArray<string>;
  Col, Row: Integer;
  Plane: TPlane;
begin
  Plane := TPlane(Sender);
  Cells := Plane.TagString.Split(['/'], TStringSplitOptions.ExcludeEmpty);
  Row := StrToInt(Cells[1]); // Row
  Col := StrToInt(Cells[0]); // Col

  Form1.TileMouseDown(Sender, Row, Col);  // chiama la procedura del form
end;

procedure TTileGrid.SetBasePosition(BaseX, BaseY: Single);
var
  i, j: Integer;
begin
  for i := 0 to FRows - 1 do
    for j := 0 to FCols - 1 do
      FTiles[i,j].SetPosition(
        BaseX + j * FTileSizeX + FTileSizeX / 2,
        BaseY + i * FTileSizeY + FTileSizeY / 2,
        FTileDepth / 2
      );
end;

procedure TTileGrid.SetRotationZ(Angle: Single);
begin
  if FDummyRoot <> nil then
    FDummyRoot.RotationAngle.Z := Angle;
end;

end.

