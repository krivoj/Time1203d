unit u_PlayerSkillLayout;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.Generics.collections,System.UITypes,System.Math.Vectors,
  FMX.Types, FMX.Controls, FMX.Layouts, FMX.Objects, FMX.Viewport3D,
  FMX.Objects3D, FMX.Controls3D, FMX.MaterialSources, FMX.Graphics,
  u_Core, u_Skills;

type
  TOnSkillSelected = procedure(ASkill: TSkill) of object;

  TSkillTile = class
  public
    Plane: TPlane;
    Skill: TSkill;
  end;

  TPlayerSkillLayout = class(TLayout)
  private
    FViewport: TViewport3D;
    FBackground: TRectangle;
    FRoot3D: TDummy;
    FTiles: TObjectList<TSkillTile>;
    FPlayer: TPlayer;
    FOnSkillSelected: TOnSkillSelected;

    procedure TileMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single; RayPos, RayDir: TVector3D);
    procedure ClearTiles;
    procedure UpdateSize(Rows: Integer);

  public
    constructor Create(AOwner: TComponent; AViewport: TViewport3D); reintroduce;
    destructor Destroy; override;

    procedure ShowForPlayer(APlayer: TPlayer);
    procedure Hide;

    property OnSkillSelected: TOnSkillSelected
      read FOnSkillSelected write FOnSkillSelected;
  end;

implementation

{ TPlayerSkillLayout }

constructor TPlayerSkillLayout.Create(AOwner: TComponent; AViewport: TViewport3D);
begin
  inherited Create(AOwner);

  FViewport := AViewport;
  Parent := AViewport;
  Align := TAlignLayout.Contents;
  HitTest := True;
  Visible := False;

  FTiles := TObjectList<TSkillTile>.Create(True);

  // overlay background (blocca input)
  FBackground := TRectangle.Create(Self);
  FBackground.Parent := Self;
  FBackground.Align := TAlignLayout.Center;
  FBackground.Fill.Color := $FF1E1E1E;
  FBackground.Stroke.Kind := TBrushKind.None;
  FBackground.XRadius := 12;
  FBackground.YRadius := 12;
  FBackground.HitTest := True;

  // root 3D delle skill
  FRoot3D := TDummy.Create(FViewport);
  FRoot3D.Parent := FViewport;
end;

destructor TPlayerSkillLayout.Destroy;
begin
  ClearTiles;
  FTiles.Free;

  if FRoot3D <> nil then
    FRoot3D.DisposeOf;

  inherited;
end;

procedure TPlayerSkillLayout.ShowForPlayer(APlayer: TPlayer);
var
  i, Rows: Integer;
  Tile: TSkillTile;
  Plane: TPlane;
  Mat: TTextureMaterialSource;
  Bmp: TBitmap;
begin
  if (APlayer = nil) or (APlayer.Skills.Count = 0) then Exit;

  ClearTiles;

  FPlayer := APlayer;
  Rows := APlayer.Skills.Count;

  for i := 0 to Rows - 1 do
  begin
    Tile := TSkillTile.Create;
    Tile.Skill := APlayer.Skills[i];

    // bitmap skill
    Bmp := TBitmap.Create(256, 64);
    Bmp.Clear(TAlphaColors.Null);
    Bmp.Canvas.BeginScene;
    Bmp.Canvas.Fill.Color := TAlphaColors.White;
    Bmp.Canvas.FillText(
      RectF(0, 0, 256, 64),
      Tile.Skill.GetName + '  Lv ' + Tile.Skill.Level.ToString,
      False, 1, [], TTextAlign.Center, TTextAlign.Center
    );
    Bmp.Canvas.EndScene;

    Mat := TTextureMaterialSource.Create(Self);
    Mat.Texture.Assign(Bmp);
    Bmp.Free;

    Plane := TPlane.Create(FRoot3D);
    Plane.Parent := FRoot3D;
    Plane.Width := 1.8;
    Plane.Height := 0.4;
    Plane.Position.Point := Point3D(0, -i * 0.45, 0);
    Plane.MaterialSource := Mat;
    Plane.HitTest := True;
    Plane.TagObject := Tile;
    Plane.OnMouseDown := TileMouseDown;

    Tile.Plane := Plane;
    FTiles.Add(Tile);
  end;

  UpdateSize(Rows);
  Visible := True;
end;

procedure TPlayerSkillLayout.Hide;
begin
  Visible := False;
end;

procedure TPlayerSkillLayout.ClearTiles;
var
  Tile: TSkillTile;
begin
  for Tile in FTiles do
    if Tile.Plane <> nil then
      Tile.Plane.DisposeOf;

  FTiles.Clear;
end;

procedure TPlayerSkillLayout.TileMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single; RayPos, RayDir: TVector3D);
var
  Tile: TSkillTile;
begin
  Tile := (Sender as TPlane).TagObject as TSkillTile;

  if Assigned(FOnSkillSelected) then
    FOnSkillSelected(Tile.Skill);

  Hide;
end;

procedure TPlayerSkillLayout.UpdateSize(Rows: Integer);
begin
  FBackground.Width  := 220;
  FBackground.Height := Rows * 80;
end;

end.

