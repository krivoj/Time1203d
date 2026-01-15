unit u_PlayerSkillLayout;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.Types,
  System.UITypes,
  FMX.Graphics,
  FMX.Types,
  FMX.Controls,
  FMX.Layouts,
  FMX.Objects,
  FMX.StdCtrls,
  u_Core,
  u_Skills;

type
  TOnSkillSelected = procedure(ASkill: TSkill) of object;

type
  TSkillTile = class
  public
    LabelCtrl: TLabel;
    Skill: TSkill;
  end;

  TPlayerSkillLayout = class(TLayout)
  private
    FBackground: TRectangle;
    FTiles: TObjectList<TSkillTile>;
    FPlayer: TPlayer;
    FOnSkillSelected: TOnSkillSelected;

    procedure SkillLabelClick(Sender: TObject);
    procedure ClearTiles;

  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;

    procedure ShowForPlayer(APlayer: TPlayer);
    procedure Hide;

    property OnSkillSelected: TOnSkillSelected
      read FOnSkillSelected write FOnSkillSelected;
  end;

implementation

{ TPlayerSkillLayout }

constructor TPlayerSkillLayout.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Align := TAlignLayout.Center;
  Width := 260;
  HitTest := True;
  Visible := False;

  FTiles := TObjectList<TSkillTile>.Create(True);

  // Background
  FBackground := TRectangle.Create(Self);
  FBackground.Parent := Self;
  FBackground.Align := TAlignLayout.Client;
  FBackground.Fill.Color := $FF1E1E1E;
  FBackground.Stroke.Kind := TBrushKind.None;
  FBackground.XRadius := 12;
  FBackground.YRadius := 12;
end;

destructor TPlayerSkillLayout.Destroy;
begin
  ClearTiles;
  FTiles.Free;
  inherited;
end;

procedure TPlayerSkillLayout.ShowForPlayer(APlayer: TPlayer);
var
  i: Integer;
  Tile: TSkillTile;
  Lbl: TLabel;
begin
  if (APlayer = nil) or (APlayer.Skills.Count = 0) then
    Exit;

  ClearTiles;
  FPlayer := APlayer;

  for i := 0 to APlayer.Skills.Count - 1 do
  begin
    Tile := TSkillTile.Create;
    Tile.Skill := APlayer.Skills[i];

    Lbl := TLabel.Create(Self);
    Lbl.Parent := Self;
    Lbl.Align := TAlignLayout.Top;
    Lbl.Height := 36;
//    Lbl.Margins.SetBounds(12, 8, 12, 0);
    Lbl.Text :=
      Tile.Skill.GetName + '  Lv ' + Tile.Skill.Level.ToString;
    Lbl.TextSettings.Font.Size := 14;
    Lbl.TextSettings.FontColor := TAlphaColors.White;
    Lbl.HitTest := True;
    Lbl.Cursor := crHandPoint;
    Lbl.TagObject := Tile;
    Lbl.OnClick := SkillLabelClick;

    Tile.LabelCtrl := Lbl;
    FTiles.Add(Tile);
  end;

  Height := APlayer.Skills.Count * 44 + 20;
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
    if Assigned(Tile.LabelCtrl) then
      Tile.LabelCtrl.DisposeOf;

  FTiles.Clear;
end;

procedure TPlayerSkillLayout.SkillLabelClick(Sender: TObject);
var
  Tile: TSkillTile;
begin
  Tile := (Sender as TLabel).TagObject as TSkillTile;

  if Assigned(FOnSkillSelected) then
    FOnSkillSelected(Tile.Skill);

  Hide;
end;

end.

