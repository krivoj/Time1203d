unit u_TileGrid;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Generics.Collections,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Objects3D,
  FMX.MaterialSources, FMX.Controls3D, FMX.Viewport3D, FMX.Types3D, System.Math.Vectors;

type
  TStringArray2D = array of array of string; // tipo 2D per array di file

  TModelTile = class
  private
    FMaterial: TTextureMaterialSource;
  public
    FPlane: TPlane;
    GridIndex, CellX, CellY: Integer;
    constructor Create(AOwner: TComponent; AParent: TControl3D;
      const TextureFile: string; SharedMaterial: TTextureMaterialSource;
      X, Y, SizeX, SizeY, Depth: Single);
    procedure SetPosition(X, Y, Z: Single);
    procedure SetTexture(AOwner: TComponent; const TextureFile: string);
    procedure Free;
  end;

  TTileGrid = class
  private
    FViewport: TViewport3D;
    FDummyRoot: TDummy;
    FDefaultMaterial: TTextureMaterialSource;
    FHighlightMaterial: TColorMaterialSource; // <--- materiale unlit
    procedure CommonCreate(AOwner: TComponent; AViewport: TViewport3D; Index, Cols, Rows: Integer);
    procedure LocalMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Single; RayPos, RayDir: TVector3D);
    procedure LocalMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Single; RayPos, RayDir: TVector3D);
    procedure InitializeGrid(AOwner: TComponent; Cols, Rows: Integer;
      const TextureFiles: TStringArray2D; SharedMaterial: TTextureMaterialSource);
  public
    FTileSizeX: Single;
    FTileSizeY: Single;
    FTileDepth: Single;
    FCols: Integer;
    FRows: Integer;
    FTiles: array of array of TModelTile;
    FGridIndex: Integer;
    HighlightPlanes: TObjectList<TRectangle3D>;

    destructor Destroy; override;
    constructor Create(AOwner: TComponent; AViewport: TViewport3D; Index, Cols, Rows: Integer;
      const DefaultTextureFile: string); overload;
    constructor Create(AOwner: TComponent; AViewport: TViewport3D; Index, Cols, Rows: Integer;
      const TextureFiles: TStringArray2D); overload;
    constructor Create(AOwner: TComponent; AViewport: TViewport3D; Index, Cols, Rows: Integer;
      FieldBitmap: TBitmap); overload;

    procedure DrawGrid;
    procedure Free;

    procedure SetBasePosition(BaseX, BaseY: Single);
    procedure SetRotationZ(Angle: Single);
    procedure SetTileTexture(AOwner: TComponent; Col, Row: Integer; const TextureFile: string);

    procedure CreateDefaultMaterialFromBitmap(AOwner: TComponent; Bitmap: TBitmap);
    procedure HighlightCell(X, Y: Integer);
    procedure ClearHighlights;
    procedure HighlightFormationsCols;
  end;

function CreateSoccerFieldBitmap(TileWidth, TileHeight: Integer;
  BaseColor, BorderColor: TAlphaColor;
  BorderLeft, BorderTop, BorderRight, BorderBottom: Integer): TBitmap;

implementation

uses Unit1, System.Math, u_core;

{ ===== TModelTile ===== }

constructor TModelTile.Create(AOwner: TComponent; AParent: TControl3D;
  const TextureFile: string; SharedMaterial: TTextureMaterialSource;
  X, Y, SizeX, SizeY, Depth: Single);
begin
  inherited Create;

  if Assigned(SharedMaterial) then
    FMaterial := SharedMaterial
  else
  begin
    FMaterial := TTextureMaterialSource.Create(AOwner);
    if TextureFile <> '' then
      FMaterial.Texture.LoadFromFile(TextureFile);
  end;

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

procedure TModelTile.SetTexture(AOwner: TComponent; const TextureFile: string);
begin
  if (FMaterial <> nil) and (FMaterial.Owner <> AOwner) then
    FMaterial := TTextureMaterialSource.Create(AOwner);
  FMaterial.Texture.LoadFromFile(TextureFile);
  FPlane.MaterialSource := FMaterial;
end;

procedure TModelTile.Free;
begin
  if FPlane <> nil then
  begin
    FPlane.DisposeOf;
    FPlane := nil;
  end;

  if (FMaterial <> nil) and (FMaterial.Owner = FPlane.Owner) then
  begin
    FMaterial.DisposeOf;
    FMaterial := nil;
  end;
end;

{ ===== TTileGrid ===== }

procedure TTileGrid.CommonCreate(AOwner: TComponent; AViewport: TViewport3D; Index, Cols, Rows: Integer);
begin
  FViewport := AViewport;
  FTileSizeX := 1.0;
  FTileSizeY := 1.0;
  FTileDepth := 0.08;
  FGridIndex := Index;
  HighlightPlanes := TObjectList<TRectangle3D>.Create(True);

  FDummyRoot := TDummy.Create(FViewport);
  FDummyRoot.Parent := FViewport;
  FDummyRoot.Position.Point := Point3D(0, 0, 0);

  FCols := Cols;
  FRows := Rows;
  SetLength(FTiles, FCols, FRows);

  // crea il materiale di highlight una volta sola (unlit)
  FHighlightMaterial := TColorMaterialSource.Create(AOwner);
  FHighlightMaterial.Color := TAlphaColorRec.Lime;
end;

destructor TTileGrid.Destroy;
begin
  ClearHighlights;
  HighlightPlanes.Free;
  FHighlightMaterial.Free;
  inherited;
end;

constructor TTileGrid.Create(AOwner: TComponent; AViewport: TViewport3D; Index, Cols, Rows: Integer;
  const DefaultTextureFile: string);
begin
  inherited Create;
  CommonCreate(AOwner, AViewport, Index, Cols, Rows);

  FDefaultMaterial := TTextureMaterialSource.Create(AOwner);
  if DefaultTextureFile <> '' then
    FDefaultMaterial.Texture.LoadFromFile(DefaultTextureFile);

  InitializeGrid(AOwner, Cols, Rows, nil, FDefaultMaterial);
end;

constructor TTileGrid.Create(AOwner: TComponent; AViewport: TViewport3D; Index, Cols, Rows: Integer;
  const TextureFiles: TStringArray2D);
begin
  inherited Create;
  CommonCreate(AOwner, AViewport, Index, Cols, Rows);
  InitializeGrid(AOwner, Cols, Rows, TextureFiles, nil);
end;

constructor TTileGrid.Create(AOwner: TComponent; AViewport: TViewport3D; Index, Cols, Rows: Integer;
  FieldBitmap: TBitmap);
begin
  inherited Create;
  CommonCreate(AOwner, AViewport, Index, Cols, Rows);

  if FieldBitmap <> nil then
  begin
    FDefaultMaterial := TTextureMaterialSource.Create(AOwner);
    FDefaultMaterial.Texture.Assign(FieldBitmap);
  end
  else
    FDefaultMaterial := nil;

  InitializeGrid(AOwner, Cols, Rows, nil, FDefaultMaterial);
end;

procedure TTileGrid.InitializeGrid(AOwner: TComponent; Cols, Rows: Integer;
  const TextureFiles: TStringArray2D; SharedMaterial: TTextureMaterialSource);
var
  X, Y: Integer;
  PosX, PosY: Single;
  TexFile: string;
begin
  for Y := 0 to Rows - 1 do
    for X := 0 to Cols - 1 do
    begin
      PosX := X * FTileSizeX + FTileSizeX / 2;
      PosY := (Rows - 1 - Y) * FTileSizeY + FTileSizeY / 2;

      if (Length(TextureFiles) > 0) and (Length(TextureFiles) > X) and (Length(TextureFiles[X]) > Y) then
        TexFile := TextureFiles[X, Y]
      else
        TexFile := '';

      FTiles[X, Y] := TModelTile.Create(AOwner, FDummyRoot, TexFile, SharedMaterial,
        PosX, PosY, FTileSizeX, FTileSizeY, FTileDepth);

      FTiles[X, Y].FPlane.OnMouseDown := LocalMouseDown;
      FTiles[X, Y].FPlane.OnMouseUp := LocalMouseUp;
      FTiles[X, Y].FPlane.HitTest := True;
      FTiles[X, Y].GridIndex := FGridIndex;
      FTiles[X, Y].FPlane.Tag := FGridIndex;
      FTiles[X, Y].CellX := X;
      FTiles[X, Y].CellY := Y;
      FTiles[X, Y].FPlane.TagString := IntToStr(X) + '/' + IntToStr(Y);
    end;
end;

procedure TTileGrid.SetTileTexture(AOwner: TComponent; Col, Row: Integer; const TextureFile: string);
begin
  if (Col >= 0) and (Col < FCols) and (Row >= 0) and (Row < FRows) then
    FTiles[Col, Row].SetTexture(AOwner, TextureFile);
end;

procedure TTileGrid.DrawGrid;
var
  X, Y: Integer;
begin
  for Y := 0 to FRows - 1 do
    for X := 0 to FCols - 1 do
      FTiles[X, Y].SetPosition(
        X * FTileSizeX + FTileSizeX / 2,
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

  if FDefaultMaterial <> nil then
  begin
    FDefaultMaterial.DisposeOf;
    FDefaultMaterial := nil;
  end;
end;

procedure TTileGrid.LocalMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Single; RayPos, RayDir: TVector3D);
var
  Cells: TArray<string>;
  Col, Row: Integer;
  Plane: TPlane;
begin
  Plane := TPlane(Sender);
  Cells := Plane.TagString.Split(['/'], TStringSplitOptions.ExcludeEmpty);
  Col := StrToInt(Cells[0]);
  Row := StrToInt(Cells[1]);
  Form1.TileMouseDown(Sender, Button, Col, Row);
end;

procedure TTileGrid.LocalMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Single; RayPos, RayDir: TVector3D);
var
  Cells: TArray<string>;
  Col, Row: Integer;
  Plane: TPlane;
begin
  Plane := TPlane(Sender);
  Cells := Plane.TagString.Split(['/'], TStringSplitOptions.ExcludeEmpty);
  Col := StrToInt(Cells[0]);
  Row := StrToInt(Cells[1]);
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
        FTileDepth / 2);
end;

procedure TTileGrid.SetRotationZ(Angle: Single);
begin
  if FDummyRoot <> nil then
    FDummyRoot.RotationAngle.Z := Angle;
end;

{ ===== Funzione per bitmap campo da calcio ===== }

function CreateSoccerFieldBitmap(TileWidth, TileHeight: Integer;
  BaseColor, BorderColor: TAlphaColor;
  BorderLeft, BorderTop, BorderRight, BorderBottom: Integer): TBitmap;
var
  x, y: Integer;
  fx, fy, fade: Single;
  c: TAlphaColorRec;
  bmpData: TBitmapData;
begin
  Result := TBitmap.Create(TileWidth, TileHeight);
  Result.Clear(BaseColor);

  if Result.Map(TMapAccess.Write, bmpData) then
  try
    for y := 0 to TileHeight - 1 do
      for x := 0 to TileWidth - 1 do
      begin
        fx := 1.0;
        if BorderLeft > 0 then fx := Min(fx, x / BorderLeft);
        if BorderRight > 0 then fx := Min(fx, (TileWidth - 1 - x) / BorderRight);
        fy := 1.0;
        if BorderTop > 0 then fy := Min(fy, y / BorderTop);
        if BorderBottom > 0 then fy := Min(fy, (TileHeight - 1 - y) / BorderBottom);

        fade := Min(fx, fy);
        fade := Max(0, Min(fade, 1));

        c := TAlphaColorRec(BaseColor);
        c.R := Round(c.R * fade + TAlphaColorRec(BorderColor).R * (1 - fade));
        c.G := Round(c.G * fade + TAlphaColorRec(BorderColor).G * (1 - fade));
        c.B := Round(c.B * fade + TAlphaColorRec(BorderColor).B * (1 - fade));
        bmpData.SetPixel(x, y, c.Color);
      end;
  finally
    Result.Unmap(bmpData);
  end;
end;

procedure TTileGrid.CreateDefaultMaterialFromBitmap(AOwner: TComponent; Bitmap: TBitmap);
begin
  if FDefaultMaterial <> nil then
    FDefaultMaterial.DisposeOf;
  FDefaultMaterial := TTextureMaterialSource.Create(AOwner);
  FDefaultMaterial.Texture.Assign(Bitmap);
end;

procedure TTileGrid.HighlightCell(X, Y: Integer);
var
  HighlightPlane: TRectangle3D;
  CellPosX, CellPosY, CellPosZ: Single;
begin
  if (X < 0) or (X >= FCols) or (Y < 0) or (Y >= FRows) then
    Exit;

  CellPosX := X * FTileSizeX + FTileSizeX / 2;
  CellPosY := Y * FTileSizeY + FTileSizeY / 2;
  CellPosZ := FTileDepth / 2 + 0.02;

  HighlightPlane := TRectangle3D.Create(FDummyRoot);
  HighlightPlane.Parent := FDummyRoot;
  HighlightPlane.Width := FTileSizeX;
  HighlightPlane.Height := FTileSizeY;
  HighlightPlane.Depth := 0.01;
  HighlightPlane.Position.Point := Point3D(CellPosX, CellPosY, CellPosZ);
  HighlightPlane.MaterialSource := FHighlightMaterial;
  HighlightPlane.Opacity := 1;
  HighlightPlane.TwoSide := True;
  HighlightPlane.HitTest := False;

  HighlightPlanes.Add(HighlightPlane);

  if Assigned(FViewport) then
    FViewport.Repaint;
end;

procedure TTileGrid.ClearHighlights;
begin
  HighlightPlanes.Clear;
  if Assigned(FViewport) then
    FViewport.Repaint;
end;

procedure TTileGrid.HighlightFormationsCols;
var
  y, i: Integer;
begin
  for i := Low(FormationCols) to High(FormationCols) do
    for y := 0 to FRows - 1 do
      HighlightCell(FormationCols[i], y);
end;

end.

