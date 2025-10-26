unit uFieldLines;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Math, System.Math.Vectors,
  FMX.Types3D, FMX.Objects3D, FMX.MaterialSources, FMX.Controls3D, FMX.Viewport3D,
  uTileGrid;

type
  TFieldDrawer = class
  private
    FOwner: TComponent;
    FViewport: TViewport3D;
    FGrid: TTileGrid;
    FWhiteMat: TColorMaterialSource;
    FLineThickness: Single;
    FZOffset: Single;

    procedure CreateWhiteMaterial;
    function CreateFieldLine(x1, y1, x2, y2, thickness, z: Single): TPlane;
    procedure CreateFieldRectOutline(leftX, topY, rightX, bottomY, thickness, z: Single);
    procedure DrawLargeAreaAt(TopLeftX, TopLeftY: Integer; LengthCells, WidthCells: Integer);
    procedure DrawHalfMoons;
    procedure DrawSmallPenalties;
    procedure DrawCenterCircle;
    procedure DrawHalfwayLine;
    procedure DrawCorners;
    procedure DrawGoals;
  public
    constructor Create(AOwner: TComponent; AViewport: TViewport3D; AGrid: TTileGrid);
    procedure DrawField;
  end;

implementation

{ TFieldDrawer }

constructor TFieldDrawer.Create(AOwner: TComponent; AViewport: TViewport3D; AGrid: TTileGrid);
begin
  FOwner := AOwner;
  FViewport := AViewport;
  FGrid := AGrid;
  CreateWhiteMaterial;

  FLineThickness := Min(FGrid.FTileSizeX, FGrid.FTileSizeY) * 0.08;
  FZOffset := FGrid.FTileDepth + 0.002;
end;

procedure TFieldDrawer.CreateWhiteMaterial;
begin
  if FWhiteMat <> nil then Exit;

  FWhiteMat := TColorMaterialSource.Create(FOwner);
  FWhiteMat.Parent := FViewport;
  FWhiteMat.Color := TAlphaColorRec.White;
end;

function TFieldDrawer.CreateFieldLine(x1, y1, x2, y2, thickness, z: Single): TPlane;
var
  p: TPlane;
  dx, dy, len, angleDeg, mx, my: Single;
begin
  dx := x2 - x1;
  dy := y2 - y1;
  len := Sqrt(dx * dx + dy * dy);
  if len = 0 then len := 0.001;

  mx := (x1 + x2) / 2;
  my := (y1 + y2) / 2;

  p := TPlane.Create(FOwner);
  p.Parent := FViewport;
  p.Width := len;
  p.Height := thickness;
  p.Position.Point := Point3D(mx, my, z);
  angleDeg := ArcTan2(dy, dx) * 180 / Pi;
  p.RotationAngle.Z := angleDeg;
  p.MaterialSource := FWhiteMat;
  p.HitTest := False;

  Result := p;
end;

procedure TFieldDrawer.CreateFieldRectOutline(leftX, topY, rightX, bottomY, thickness, z: Single);
begin
  // Linee orizzontali principali attaccate ai bordi esterni delle celle
  CreateFieldLine(leftX, topY, rightX, topY, thickness, z);
  CreateFieldLine(leftX, bottomY, rightX, bottomY, thickness, z);

  // Linee verticali principali restano centrali sulle celle
  CreateFieldLine(leftX, topY, leftX, bottomY, thickness, z);
  CreateFieldLine(rightX, topY, rightX, bottomY, thickness, z);
end;

procedure TFieldDrawer.DrawField;
var
  leftX, rightX, topY, bottomY: Single;
  tileW, tileH: Single;
begin
  tileW := FGrid.FTileSizeX;
  tileH := FGrid.FTileSizeY;

  // Rettangolo principale: linee orizzontali esterne e verticali centrali
  leftX := FGrid.FTiles[1,0].FPlane.Position.X - tileW/2;
  rightX := FGrid.FTiles[16,0].FPlane.Position.X + tileW/2;
  topY := FGrid.FTiles[0,0].FPlane.Position.Y + tileH/2;      // bordo superiore esterno
  bottomY := FGrid.FTiles[0,10].FPlane.Position.Y - tileH/2;  // bordo inferiore esterno

  CreateFieldRectOutline(leftX, topY, rightX, bottomY, FLineThickness, FZOffset);
  DrawLargeAreaAt ( 1,3,3,5 )  ;
  DrawLargeAreaAt ( 14,3,3,5 )  ;
  DrawHalfMoons;
  DrawSmallPenalties;
  DrawCenterCircle;
  DrawHalfwayLine;
  DrawCorners;
  DrawGoals;
end;
procedure TFieldDrawer.DrawLargeAreaAt(TopLeftX, TopLeftY: Integer; LengthCells, WidthCells: Integer);
var
  tileW, tileH: Single;
  X1, Y1, X2, Y2: Single;
begin
  tileW := FGrid.FTileSizeX;
  tileH := FGrid.FTileSizeY;

  // --- Linea orizzontale superiore (Up) ---
  X1 := FGrid.FTiles[TopLeftX, TopLeftY].FPlane.Position.X - tileW/2;
  Y1 := FGrid.FTiles[TopLeftX, TopLeftY].FPlane.Position.Y + tileH/2;
  X2 := FGrid.FTiles[TopLeftX + LengthCells - 1, TopLeftY].FPlane.Position.X + tileW/2;
  Y2 := Y1;
  CreateFieldLine(X1, Y1, X2, Y2, FLineThickness, FZOffset); // DrawLineHu

  // --- Linea orizzontale inferiore (Bottom) ---
  X1 := FGrid.FTiles[TopLeftX, TopLeftY + WidthCells - 1].FPlane.Position.X - tileW/2;
  Y1 := FGrid.FTiles[TopLeftX, TopLeftY + WidthCells - 1].FPlane.Position.Y - tileH/2;
  X2 := FGrid.FTiles[TopLeftX + LengthCells - 1, TopLeftY + WidthCells - 1].FPlane.Position.X + tileW/2;
  Y2 := Y1;
  CreateFieldLine(X1, Y1, X2, Y2, FLineThickness, FZOffset); // DrawLineHb

  // --- Linea verticale sinistra (Left) ---
  X1 := FGrid.FTiles[TopLeftX, TopLeftY].FPlane.Position.X - tileW/2;
  Y1 := FGrid.FTiles[TopLeftX, TopLeftY].FPlane.Position.Y + tileH/2;
  X2 := X1;
  Y2 := FGrid.FTiles[TopLeftX, TopLeftY + WidthCells - 1].FPlane.Position.Y - tileH/2;
  CreateFieldLine(X1, Y1, X2, Y2, FLineThickness, FZOffset); // DrawLineVl

  // --- Linea verticale destra (Right) ---
  X1 := FGrid.FTiles[TopLeftX + LengthCells - 1, TopLeftY].FPlane.Position.X + tileW/2;
  Y1 := FGrid.FTiles[TopLeftX + LengthCells - 1, TopLeftY].FPlane.Position.Y + tileH/2;
  X2 := X1;
  Y2 := FGrid.FTiles[TopLeftX + LengthCells - 1, TopLeftY + WidthCells - 1].FPlane.Position.Y - tileH/2;
  CreateFieldLine(X1, Y1, X2, Y2, FLineThickness, FZOffset); // DrawLineVr
end;
procedure TFieldDrawer.DrawHalfMoons;
const
  NumSegments = 36;
  RaggioCells = 1.0;      // raggio più piccolo
  OffsetXLeft = -0.5;     // X: sinistra verso fuori
  OffsetXRight = +0.5;    // X: destra verso fuori
  OffsetYLeft = -0.5;     // già regolata in alto
  OffsetYRight = -1.5;    // già regolata in alto
  MoveDownLeft = 0.5;     // spostamento verso basso aggiuntivo
  MoveDownRight = 1.5;
var
  i: Integer;
  AngStart, AngEnd, Step, Ang: Single;
  CX, CY, X1, Y1, X2, Y2: Single;
  tileW, tileH, RaggioX, RaggioY, OffsetX: Single;
begin
  tileW := FGrid.FTileSizeX;
  tileH := FGrid.FTileSizeY;
  RaggioX := tileW * RaggioCells;
  RaggioY := tileH * RaggioCells;
  OffsetX := RaggioX * 0.5; // piccolo offset orizzontale

  // --- Mezza luna sinistra ---
  CX := FGrid.FTiles[4, 0].FPlane.Position.X + (OffsetXLeft * tileW);
  CY := ((FGrid.FTiles[0, 3].FPlane.Position.Y + FGrid.FTiles[0, 7].FPlane.Position.Y) / 2)
        + (OffsetYLeft * tileH) + (MoveDownLeft * tileH); // spostamento verticale verso il basso

  AngStart := -Pi / 2;
  AngEnd := Pi / 2;
  Step := (AngEnd - AngStart) / NumSegments;

  for i := 0 to NumSegments - 1 do
  begin
    Ang := AngStart + i * Step;
    X1 := CX + RaggioX * Cos(Ang);
    Y1 := CY + RaggioY * Sin(Ang);
    X2 := CX + RaggioX * Cos(Ang + Step);
    Y2 := CY + RaggioY * Sin(Ang + Step);
    CreateFieldLine(X1, Y1, X2, Y2, FLineThickness, FZOffset);
  end;

  // --- Mezza luna destra ---
  CX := FGrid.FTiles[13, 0].FPlane.Position.X + (OffsetXRight * tileW);
  CY := ((FGrid.FTiles[0, 3].FPlane.Position.Y + FGrid.FTiles[0, 7].FPlane.Position.Y) / 2)
        + (OffsetYRight * tileH) + (MoveDownRight * tileH); // spostamento verticale verso il basso

  AngStart := Pi / 2;
  AngEnd := -Pi / 2;
  Step := (AngEnd - AngStart) / NumSegments;

  for i := 0 to NumSegments - 1 do
  begin
    Ang := AngStart + i * Step;
    X1 := CX - RaggioX * Cos(Ang);
    Y1 := CY + RaggioY * Sin(Ang);
    X2 := CX - RaggioX * Cos(Ang + Step);
    Y2 := CY + RaggioY * Sin(Ang + Step);
    CreateFieldLine(X1, Y1, X2, Y2, FLineThickness, FZOffset);
  end;
end;
procedure TFieldDrawer.DrawSmallPenalties;
var
  PenaltyDiameter, PenaltyHeight: Single;
  Sphere: TSphere;
  Tile: uTileGrid.TModelTile;
begin
  PenaltyDiameter := 0.1;
  PenaltyHeight := 0.05;

  // --- PENALTY 1: cella (2,5) ---
  Tile := FGrid.FTiles[2, 5];
  Sphere := TSphere.Create(FOwner);
  Sphere.Parent := FViewPort;
  Sphere.Position.X := Tile.FPlane.Position.X;
  Sphere.Position.Y := Tile.FPlane.Position.Y;
  Sphere.Position.Z := PenaltyHeight / 2;
  Sphere.Width := PenaltyDiameter;
  Sphere.Depth := PenaltyDiameter;
  Sphere.Height := PenaltyHeight;
  Sphere.MaterialSource := FWhiteMat;
  Sphere.RotationAngle.X := 90; // ruota di 90° attorno all’asse X
  // --- PENALTY 2: cella (15,5) ---
  Tile := FGrid.FTiles[15, 5];
  Sphere := TSphere.Create(FOwner);
  Sphere.Parent := FViewPort;
  Sphere.Position.X := Tile.FPlane.Position.X;
  Sphere.Position.Y := Tile.FPlane.Position.Y;
  Sphere.Position.Z := PenaltyHeight / 2;
  Sphere.Width := PenaltyDiameter;
  Sphere.Depth := PenaltyDiameter;
  Sphere.Height := PenaltyHeight;
  Sphere.MaterialSource := FWhiteMat;
  Sphere.RotationAngle.X := 90; // ruota di 90° attorno all’asse X

end;
procedure TFieldDrawer.DrawCenterCircle;
const
  NumSegments = 36;
var
  i: Integer;
  Ang, Step: Single;
  CX, CY, X1, Y1, X2, Y2: Single;
  tileW, tileH, RaggioX, RaggioY: Single;
  CenterTile: uTileGrid.TModelTile;
  TileLeft, TileRight: TModelTile;
  CenterX, CenterY: Single;
begin
  tileW := FGrid.FTileSizeX;
  tileH := FGrid.FTileSizeY;

// Celle centrali
  TileLeft  := FGrid.FTiles[8, 5];
  TileRight := FGrid.FTiles[9, 5];

  // Calcolo posizione centrale tra le due celle
  //CenterY := (TileLeft.FPlane.Position.Y + TileRight.FPlane.Position.Y) / 2;
  //CenterX := TileLeft.FPlane.Position.X; // riga 5 è già quella giusta
  CX := (TileLeft.FPlane.Position.X + TileRight.FPlane.Position.X) / 2;
  CY := TileLeft.FPlane.Position.Y; // riga 5 è già quella giusta


  RaggioX := tileW * 1.5;
  RaggioY := tileH * 1.5;

  Step := 2 * Pi / NumSegments;

  for i := 0 to NumSegments-1 do
  begin
    Ang := i * Step;
    X1 := CX + RaggioX * Cos(Ang);
    Y1 := CY + RaggioY * Sin(Ang);
    X2 := CX + RaggioX * Cos(Ang + Step);
    Y2 := CY + RaggioY * Sin(Ang + Step);
    CreateFieldLine(X1, Y1, X2, Y2, FLineThickness, FZOffset);
  end;
end;
procedure TFieldDrawer.DrawHalfwayLine;
var
  MidX, TopY, BottomY: Single;
  tileW, tileH: Single;
begin
  tileW := FGrid.FTileSizeX;
  tileH := FGrid.FTileSizeY;

  // Calcola la X centrale (metà campo)
  MidX := (FGrid.FTiles[1,0].FPlane.Position.X + FGrid.FTiles[16,0].FPlane.Position.X) / 2;

  // Calcola coordinate dei bordi superiore e inferiore
  TopY := FGrid.FTiles[0,0].FPlane.Position.Y + tileH/2;
  BottomY := FGrid.FTiles[0,10].FPlane.Position.Y - tileH/2;

  // Disegna la linea verticale di centrocampo
  CreateFieldLine(MidX, TopY, MidX, BottomY, FLineThickness, FZOffset);
end;
procedure TFieldDrawer.DrawCorners;
const
  NumSegments = 5; // corner piccolo
  RotationOffset = Pi/2; // 90° in radianti
var
  i: Integer;
  AngStart, AngEnd, Step, Ang: Single;
  CX, CY, X1, Y1, X2, Y2: Single;
  LeftX, RightX, TopY, BottomY: Single;
  Raggio: Single;
begin
  LeftX := FGrid.FTiles[1,0].FPlane.Position.X - FGrid.FTileSizeX/2;
  RightX := FGrid.FTiles[16,0].FPlane.Position.X + FGrid.FTileSizeX/2;
  TopY := FGrid.FTiles[0,0].FPlane.Position.Y + FGrid.FTileSizeY/2;
  BottomY := FGrid.FTiles[0,10].FPlane.Position.Y - FGrid.FTileSizeY/2;

  Raggio := FLineThickness * 2;

  // --- Angolo in alto a sinistra ---
  CX := LeftX;
  CY := TopY;
  AngStart := -Pi + RotationOffset;
  AngEnd := -Pi/2 + RotationOffset;
  Step := (AngEnd - AngStart)/NumSegments;
  for i := 0 to NumSegments-1 do
  begin
    Ang := AngStart + i*Step;
    X1 := CX + Raggio*Cos(Ang);
    Y1 := CY + Raggio*Sin(Ang);
    X2 := CX + Raggio*Cos(Ang+Step);
    Y2 := CY + Raggio*Sin(Ang+Step);
    CreateFieldLine(X1,Y1,X2,Y2,FLineThickness,FZOffset);
  end;

  // --- Angolo in alto a destra ---
  CX := RightX;
  CY := TopY;
  AngStart := -Pi/2 - RotationOffset;
  AngEnd := 0 - RotationOffset;
  Step := (AngEnd - AngStart)/NumSegments;
  for i := 0 to NumSegments-1 do
  begin
    Ang := AngStart + i*Step;
    X1 := CX + Raggio*Cos(Ang);
    Y1 := CY + Raggio*Sin(Ang);
    X2 := CX + Raggio*Cos(Ang+Step);
    Y2 := CY + Raggio*Sin(Ang+Step);
    CreateFieldLine(X1,Y1,X2,Y2,FLineThickness,FZOffset);
  end;

  // --- Angolo in basso a sinistra ---
  CX := LeftX;
  CY := BottomY;
  AngStart := Pi - RotationOffset;
  AngEnd := Pi/2 - RotationOffset;
  Step := (AngEnd - AngStart)/NumSegments;
  for i := 0 to NumSegments-1 do
  begin
    Ang := AngStart + i*Step;
    X1 := CX + Raggio*Cos(Ang);
    Y1 := CY + Raggio*Sin(Ang);
    X2 := CX + Raggio*Cos(Ang+Step);
    Y2 := CY + Raggio*Sin(Ang+Step);
    CreateFieldLine(X1,Y1,X2,Y2,FLineThickness,FZOffset);
  end;

  // --- Angolo in basso a destra ---
  CX := RightX;
  CY := BottomY;
  AngStart := 0 + RotationOffset;
  AngEnd := Pi/2 + RotationOffset;
  Step := (AngEnd - AngStart)/NumSegments;
  for i := 0 to NumSegments-1 do
  begin
    Ang := AngStart + i*Step;
    X1 := CX + Raggio*Cos(Ang);
    Y1 := CY + Raggio*Sin(Ang);
    X2 := CX + Raggio*Cos(Ang+Step);
    Y2 := CY + Raggio*Sin(Ang+Step);
    CreateFieldLine(X1,Y1,X2,Y2,FLineThickness,FZOffset);
  end;
end;
procedure TFieldDrawer.DrawGoals;
var
  GoalWidth, GoalHeight: Single;
  GoalTileLeft, GoalTileRight: uTileGrid.TModelTile;
  TopY, BottomY, CXLeft, CXRight: Single;
  GoalPlane: TPlane;
begin
  // Dimensioni della porta
  GoalWidth := FGrid.FTileSizeX * 0.5;  // spessore del rettangolo
  GoalHeight := FGrid.FTileSizeY * 1;   // altezza di 3 celle

  // Porta sinistra
  GoalTileLeft := FGrid.FTiles[1,5]; // cella centrale verticale
  CXLeft := GoalTileLeft.FPlane.Position.X - FGrid.FTileSizeX/2 - GoalWidth/2;
  TopY := FGrid.FTiles[0,3].FPlane.Position.Y + FGrid.FTileSizeY/2;    // bordo superiore porta
  BottomY := FGrid.FTiles[0,7].FPlane.Position.Y - FGrid.FTileSizeY/2; // bordo inferiore porta

  GoalPlane := TPlane.Create(FOwner);
  GoalPlane.Parent := FViewport;
  GoalPlane.Width := GoalWidth;
  GoalPlane.Height := GoalHeight;
  GoalPlane.Position.X := CXLeft;
  GoalPlane.Position.Y := (TopY + BottomY)/2;
  GoalPlane.Position.Z := FZOffset;
  GoalPlane.MaterialSource := FWhiteMat;

  // Porta destra
  GoalTileRight := FGrid.FTiles[16,5];
  CXRight := GoalTileRight.FPlane.Position.X + FGrid.FTileSizeX/2 + GoalWidth/2;

  GoalPlane := TPlane.Create(FOwner);
  GoalPlane.Parent := FViewport;
  GoalPlane.Width := GoalWidth;
  GoalPlane.Height := GoalHeight;
  GoalPlane.Position.X := CXRight;
  GoalPlane.Position.Y := (TopY + BottomY)/2;
  GoalPlane.Position.Z := FZOffset;
  GoalPlane.MaterialSource := FWhiteMat;
end;

end.

