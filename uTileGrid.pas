unit uTileGrid;

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Objects3D,
  FMX.MaterialSources, FMX.Controls3D, FMX.Viewport3D, FMX.Types3D, System.Math.Vectors;

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
    FDummyRoot: TDummy;
    procedure LocalMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single;
      RayPos, RayDir: TVector3D);
  public
    FTileSizeX: Single;
    FTileSizeY: Single;
    FTileDepth: Single;
    FCols: Integer; // lunghezza, 18
    FRows: Integer; // larghezza, 11
    FTiles: array of array of TModelTile;
    constructor Create(AOwner: TComponent; AViewport: TViewport3D; Cols, Rows: Integer; const TextureFile: string);
    procedure DrawGrid;
    procedure Free;

    procedure SetBasePosition(BaseX, BaseY: Single);
    procedure SetRotationZ(Angle: Single);
  end;

implementation

uses Unit1;

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

constructor TTileGrid.Create(AOwner: TComponent; AViewport: TViewport3D; Cols, Rows: Integer; const TextureFile: string);
var
  X, Y: Integer;
  PosX, PosY: Single;
begin
  inherited Create;
  FViewport := AViewport;
  FTileSizeX := 1.0;
  FTileSizeY := 1.0;
  FTileDepth := 0.08;

  FDummyRoot := TDummy.Create(FViewport);
  FDummyRoot.Parent := FViewport;
  FDummyRoot.Position.Point := Point3D(0, 0, 0);
  FDummyRoot.RotationAngle.X := 0;
  FDummyRoot.RotationAngle.Y := 0;
  FDummyRoot.RotationAngle.Z := 0;

  FCols := Cols; // lunghezza (18)
  FRows := Rows; // larghezza (11)
  SetLength(FTiles, FCols, FRows);

  // cicli top-down, left-right
  for Y := 0 to FRows - 1 do     // righe (0 in alto, Rows-1 in basso)
    for X := 0 to FCols - 1 do   // colonne (0 a sinistra, Cols-1 a destra)
    begin
      PosX := X * FTileSizeX + FTileSizeX / 2;
      PosY := (FRows - 1 - Y) * FTileSizeY + FTileSizeY / 2; // inversione Y

      FTiles[X, Y] := TModelTile.Create(AOwner, FDummyRoot, TextureFile, PosX, PosY, FTileSizeX, FTileSizeY, FTileDepth);
      FTiles[X, Y].FPlane.OnMouseDown := LocalMouseDown;
      FTiles[X, Y].FPlane.HitTest := True;

      FTiles[X, Y].CellX := X;
      FTiles[X, Y].CellY := Y;
      FTiles[X, Y].FPlane.TagString := IntToStr(X) + '/' + IntToStr(Y);
    end;
end;

procedure TTileGrid.DrawGrid;
var
  X, Y: Integer;
begin
  for Y := 0 to FRows - 1 do
    for X := 0 to FCols - 1 do
      FTiles[X, Y].SetPosition(X * FTileSizeX + FTileSizeX / 2,
                               (FRows - 1 - Y) * FTileSizeY + FTileSizeY / 2,
                               FTileDepth / 2);
end;

procedure TTileGrid.Free;
var
  X, Y: Integer;
begin
  for Y := 0 to FRows - 1 do
    for X := 0 to FCols - 1 do
      FTiles[X, Y].Free;

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
  Col := StrToInt(Cells[0]);
  Row := StrToInt(Cells[1]);

  Form1.TileMouseDown(Sender, Col, Row);
end;

procedure TTileGrid.SetBasePosition(BaseX, BaseY: Single);
var
  X, Y: Integer;
begin
  for Y := 0 to FRows - 1 do
    for X := 0 to FCols - 1 do
      FTiles[X, Y].SetPosition(
        BaseX + X * FTileSizeX + FTileSizeX / 2,
        BaseY + (FRows - 1 - Y) * FTileSizeY + FTileSizeY / 2,
        FTileDepth / 2
      );
end;

procedure TTileGrid.SetRotationZ(Angle: Single);
begin
  if FDummyRoot <> nil then
    FDummyRoot.RotationAngle.Z := Angle;
end;

end.

