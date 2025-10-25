unit uFieldLines;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Math, System.Classes, System.Math.Vectors,
  FMX.Types3D, FMX.Objects3D, FMX.MaterialSources,
  FMX.Controls3D, FMX.Viewport3D,
  uTileGrid; // qui c'è TTileGrid e TModelTile

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
    procedure CreateFieldRectOutline(centerX, centerY, width, height, thickness, z: Single);
    procedure CreateFieldArc(centerX, centerY, radius, startAngleDeg, endAngleDeg: Single;
      segments: Integer; thickness, z: Single);
    procedure CreateFilledCircle(centerX, centerY, radius, z: Single);
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
  if FWhiteMat <> nil then
    Exit;

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
  if len = 0 then
    len := 0.001;

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

procedure TFieldDrawer.CreateFieldRectOutline(centerX, centerY, width, height, thickness, z: Single);
var
  leftX, rightX, topY, bottomY: Single;
begin
  leftX := centerX - width / 2;
  rightX := centerX + width / 2;
  topY := centerY - height / 2;
  bottomY := centerY + height / 2;

  CreateFieldLine(leftX, topY, rightX, topY, thickness, z);
  CreateFieldLine(leftX, bottomY, rightX, bottomY, thickness, z);
  CreateFieldLine(leftX, topY, leftX, bottomY, thickness, z);
  CreateFieldLine(rightX, topY, rightX, bottomY, thickness, z);
end;

procedure TFieldDrawer.CreateFieldArc(centerX, centerY, radius, startAngleDeg, endAngleDeg: Single;
  segments: Integer; thickness, z: Single);
var
  i: Integer;
  a1, a2: Single;
  x1, y1, x2, y2: Single;
  segAngle: Single;
begin
  if segments < 6 then
    segments := 6;

  segAngle := (endAngleDeg - startAngleDeg) / segments;

  for i := 0 to segments - 1 do
  begin
    a1 := (startAngleDeg + segAngle * i) * Pi / 180;
    a2 := (startAngleDeg + segAngle * (i + 1)) * Pi / 180;
    x1 := centerX + Cos(a1) * radius;
    y1 := centerY + Sin(a1) * radius;
    x2 := centerX + Cos(a2) * radius;
    y2 := centerY + Sin(a2) * radius;
    CreateFieldLine(x1, y1, x2, y2, thickness, z);
  end;
end;

procedure TFieldDrawer.CreateFilledCircle(centerX, centerY, radius, z: Single);
var
  cyl: TCylinder;
begin
  cyl := TCylinder.Create(FOwner);
  cyl.Parent := FViewport;
  cyl.Position.Point := Point3D(centerX, centerY, z);
  cyl.Width := radius * 2;
  cyl.Depth := radius * 2;
  cyl.Height := 0.02;
  cyl.RotationAngle.X := 90;
  cyl.MaterialSource := FWhiteMat;
  cyl.SubdivisionsAxes := 32;
  cyl.SubdivisionsCap := 1;
  cyl.SubdivisionsHeight := 1;
  cyl.HitTest := False;
end;

procedure TFieldDrawer.DrawField;
var
  tileW, tileH: Single;
  goalLeftTile, goalRightTile: TModelTile;
  goalLeftX, goalLeftY, goalRightX, goalRightY: Single;
  penaltyLeftX, penaltyLeftY, penaltyRightX, penaltyRightY: Single;
  areaWidth, areaHeight: Single;
  radiusLeft, radiusRight: Single;
  leftX, rightX, topY, bottomY, centerX, centerY: Single;
  centerCircleRadius: Single;
  GoalLeftModel, GoalRightModel: TModel3D;
  cornerRadius: Single;
  arcCenterX, arcCenterY: Single;
begin
  tileW := FGrid.FTileSizeX;
  tileH := FGrid.FTileSizeY;

  // -------------------
  // PORTE (solo celle 0,5 e 17,5)
  // -------------------
  goalLeftTile := FGrid.FTiles[0,5];
  goalRightTile := FGrid.FTiles[17,5];

  goalLeftX := goalLeftTile.FPlane.Position.X;
  goalLeftY := goalLeftTile.FPlane.Position.Y;
  goalRightX := goalRightTile.FPlane.Position.X;
  goalRightY := goalRightTile.FPlane.Position.Y;

  if FileExists('door.obj') then
  begin
    GoalLeftModel := TModel3D.Create(FOwner);
    GoalLeftModel.Parent := FViewport;
    GoalLeftModel.LoadFromFile('door.obj');
    GoalLeftModel.Position.Point := Point3D(goalLeftX, goalLeftY, 0.3);
    GoalLeftModel.Scale.Point := Point3D(1.0, 1.0, 1.0);
    GoalLeftModel.RotationAngle.Z := 0;

    GoalRightModel := TModel3D.Create(FOwner);
    GoalRightModel.Parent := FViewport;
    GoalRightModel.LoadFromFile('door.obj');
    GoalRightModel.Position.Point := Point3D(goalRightX, goalRightY, 0.3);
    GoalRightModel.Scale.Point := Point3D(1.0, 1.0, 1.0);
    GoalRightModel.RotationAngle.Z := 180;
  end
  else
  begin
    CreateFieldRectOutline(goalLeftX, goalLeftY, tileW*1.0, tileH*0.6, FLineThickness, FZOffset);
    CreateFieldRectOutline(goalRightX, goalRightY, tileW*1.0, tileH*0.6, FLineThickness, FZOffset);
  end;

  // -------------------
  // DISCHETTI RIGORI (molto piccoli e pieni)
  // -------------------
  penaltyLeftX := FGrid.FTiles[2,5].FPlane.Position.X;
  penaltyLeftY := FGrid.FTiles[2,5].FPlane.Position.Y;
  penaltyRightX := FGrid.FTiles[15,5].FPlane.Position.X;
  penaltyRightY := FGrid.FTiles[15,5].FPlane.Position.Y;

  CreateFieldArc(penaltyLeftX, penaltyLeftY, tileW*0.1, 0, 360, 12, FLineThickness, FZOffset);
  CreateFieldArc(penaltyRightX, penaltyRightY, tileW*0.1, 0, 360, 12, FLineThickness, FZOffset);

  // -------------------
  // AREE GRANDI CENTRATE SULLE PORTE
  // -------------------
  areaWidth := tileW * 5;  // profondità
  areaHeight := tileH * 3; // larghezza

  // sinistra
  CreateFieldRectOutline(FGrid.FTiles[2,5].FPlane.Position.X,
                         FGrid.FTiles[2,5].FPlane.Position.Y,
                         areaWidth, areaHeight, FLineThickness, FZOffset);
  // destra
  CreateFieldRectOutline(FGrid.FTiles[15,5].FPlane.Position.X,
                         FGrid.FTiles[15,5].FPlane.Position.Y,
                         areaWidth, areaHeight, FLineThickness, FZOffset);

  // -------------------
  // MEZZALUNE AREE GRANDI (piccole e centrali)
  // -------------------
  // sinistra
  arcCenterX := FGrid.FTiles[2,5].FPlane.Position.X + areaWidth/2; // bordo esterno verso centrocampo
  arcCenterY := FGrid.FTiles[2,5].FPlane.Position.Y;               // centro verticale area
  radiusLeft := areaHeight/2;                                       // raggio = metà larghezza area
  CreateFieldArc(arcCenterX, arcCenterY, radiusLeft, -90, 90, 12, FLineThickness, FZOffset);

  // destra
  arcCenterX := FGrid.FTiles[15,5].FPlane.Position.X - areaWidth/2; // bordo esterno verso centrocampo
  arcCenterY := FGrid.FTiles[15,5].FPlane.Position.Y;
  radiusRight := areaHeight/2;
  CreateFieldArc(arcCenterX, arcCenterY, radiusRight, 90, 270, 12, FLineThickness, FZOffset);

  // -------------------
  // RETTANGOLO ESTERNO CAMPO UTILE (col 1..16, righe 0..10)
  // -------------------
  leftX := FGrid.FTiles[1,0].FPlane.Position.X - tileW/2;
  rightX := FGrid.FTiles[16,0].FPlane.Position.X + tileW/2;
  topY := FGrid.FTiles[1,0].FPlane.Position.Y - tileH/2;
  bottomY := FGrid.FTiles[1,10].FPlane.Position.Y + tileH/2;

  CreateFieldRectOutline((leftX+rightX)/2, (topY+bottomY)/2,
                         rightX-leftX, bottomY-topY,
                         FLineThickness, FZOffset);

  // -------------------
  // LINEA CENTROCAMPO
  // -------------------
  centerY := (topY + bottomY)/2;
  CreateFieldLine(FGrid.FTiles[8,0].FPlane.Position.X, centerY,
                  FGrid.FTiles[9,0].FPlane.Position.X, centerY,
                  FLineThickness, FZOffset);

  // -------------------
  // CERCHIO CENTRALE
  // -------------------
  centerX := (FGrid.FTiles[8,5].FPlane.Position.X + FGrid.FTiles[9,5].FPlane.Position.X)/2;
  centerY := (FGrid.FTiles[8,5].FPlane.Position.Y + FGrid.FTiles[9,5].FPlane.Position.Y)/2;

  centerCircleRadius := tileW*2.0;
  CreateFieldArc(centerX, centerY, centerCircleRadius, 0, 360, 48, FLineThickness, FZOffset);
  CreateFieldArc(centerX, centerY, Min(tileW,tileH)*0.15, 0, 360, 12, FLineThickness, FZOffset);

  // -------------------
  // CORNER ARCS
  // -------------------
  cornerRadius := Min(tileW, tileH)*0.5;
  // Top-left
  CreateFieldArc(FGrid.FTiles[1,0].FPlane.Position.X, FGrid.FTiles[1,0].FPlane.Position.Y,
                 cornerRadius, 0, 90, 6, FLineThickness, FZOffset);
  // Top-right
  CreateFieldArc(FGrid.FTiles[1,10].FPlane.Position.X, FGrid.FTiles[1,10].FPlane.Position.Y,
                 cornerRadius, 90, 180, 6, FLineThickness, FZOffset);
  // Bottom-left
  CreateFieldArc(FGrid.FTiles[16,0].FPlane.Position.X, FGrid.FTiles[16,0].FPlane.Position.Y,
                 cornerRadius, 270, 360, 6, FLineThickness, FZOffset);
  // Bottom-right
  CreateFieldArc(FGrid.FTiles[16,10].FPlane.Position.X, FGrid.FTiles[16,10].FPlane.Position.Y,
                 cornerRadius, 180, 270, 6, FLineThickness, FZOffset);
end;

end.

