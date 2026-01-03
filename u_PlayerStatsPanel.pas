unit u_PlayerStatsPanel;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Types, Math,
  u_Systemutils, u_Localization, u_PlayerTemplates, u_Types, u_core,
  u_Skills, u_Lang,
  FMX.Types, FMX.Controls, FMX.Objects, FMX.Graphics,
  FMX.Layouts, FMX.StdCtrls;

type
  TPlayerStatsPanel = class(TLayout)
  private
    // HEADER
    FHeaderName: TLabel;
    FHeaderFlag: TImage;
    FBackground: TRectangle;

    // CONTENT
    FInnerLayout: TLayout;

    // ATTRIBUTES
    FStatRows: array of TLayout;

    // SKILLS (6 fisse)
    FSkillRows: array[0..5] of TLayout;

    // XP
    FXPLabel, FStaminaLabel: TLabel;

    procedure AddSectionLabel(const AText: string);
    function  AddValueRow(const ACaption: string): TLayout;
    procedure ValueRectClick(Sender: TObject);

  public
    constructor Create(AOwner: TComponent); override;
    procedure BuildFromPlayer(const APlayer: TPlayer);
  end;

implementation

{==============================================================================}
constructor TPlayerStatsPanel.Create(AOwner: TComponent);
var
  i: Integer;
  HeaderLayout: TLayout;
begin
  inherited;

  Align := TAlignLayout.Left;
  Height := 400; // metà dello schermo
  ClipChildren := True;         // taglia tutto quello che va oltre
  Width := 320;

  // BACKGROUND
  FBackground := TRectangle.Create(Self);
  FBackground.Parent := Self;
  FBackground.Align := TAlignLayout.Client;
  FBackground.Fill.Color := $FF270808;
  FBackground.Stroke.Kind := TBrushKind.None;
  FBackground.Opacity := 0.95;
  FBackground.HitTest := True;

  // HEADER LAYOUT (aggiunto)
  HeaderLayout := TLayout.Create(Self);
  HeaderLayout.Parent := Self;
  HeaderLayout.Align := TAlignLayout.Top;
  HeaderLayout.Height := 70;

  // HEADER BACKGROUND (aggiunto)
  with TRectangle.Create(HeaderLayout) do
  begin
    Parent := HeaderLayout;
    Align := TAlignLayout.Client;
    Fill.Color := $FF270808;
    Stroke.Kind := TBrushKind.None;
  end;

  // HEADER NAME (spostato dentro HeaderLayout)
  FHeaderName := TLabel.Create(HeaderLayout);
  FHeaderName.Parent := HeaderLayout;
  FHeaderName.Align := TAlignLayout.Client;
  FHeaderName.TextSettings.Font.Size := 20;
  FHeaderName.TextSettings.Font.Style := [TFontStyle.fsBold];
  FHeaderName.TextSettings.FontColor := TAlphaColorRec.White;
  FHeaderName.TextSettings.HorzAlign := TTextAlign.Center;
  FHeaderName.TextSettings.VertAlign := TTextAlign.Center;
  FHeaderName.StyledSettings := [];

  // HEADER FLAG (immutato, solo parent corretto)
  FHeaderFlag := TImage.Create(FHeaderName);
  FHeaderFlag.Parent := FHeaderName;
  FHeaderFlag.SetBounds(280, 36, 28, 28);
  FHeaderFlag.WrapMode := TImageWrapMode.Stretch;
  FHeaderFlag.HitTest := False;

  // INNER LAYOUT
  FInnerLayout := TLayout.Create(Self);
  FInnerLayout.Parent := Self;
  FInnerLayout.Align := TAlignLayout.Client;
  FInnerLayout.Padding.Rect := TRectF.Create(8, 8, 8, 8);

  {================ STAMINA =================}
  FStaminaLabel := TLabel.Create(FInnerLayout);
  FStaminaLabel.Parent := FInnerLayout;
  FStaminaLabel.Align := TAlignLayout.Top;
  FStaminaLabel.Height := 26;
  FStaminaLabel.Margins.Top := 6;
  FStaminaLabel.TextAlign := TTextAlign.Center;
  FStaminaLabel.TextSettings.Font.Size := 16;
  FStaminaLabel.TextSettings.Font.Style := [TFontStyle.fsBold];
  FStaminaLabel.TextSettings.FontColor := TAlphaColorRec.Silver;
  FStaminaLabel.StyledSettings := [];

  {================ SKILLS =================}
  for i := 5 downto 0 do
    FSkillRows[i] := AddValueRow('');

  AddSectionLabel(L(STR_SKILLS));


  {================ ATTRIBUTES =================}
  SetLength(FStatRows, Length(STAT_NAMES));

  for i := High(STAT_NAMES) downto Low(STAT_NAMES) do
    FStatRows[i] := AddValueRow(L(STAT_NAMES[i]^));

  AddSectionLabel(L(STR_ATTRIBUTES));

  {================ XP =================}
  FXPLabel := TLabel.Create(FInnerLayout);
  FXPLabel.Parent := FInnerLayout;
  FXPLabel.Align := TAlignLayout.Top;
  FXPLabel.Height := 26;
  FXPLabel.Margins.Top := 6;
  FXPLabel.TextAlign := TTextAlign.Center;
  FXPLabel.TextSettings.Font.Size := 16;
  FXPLabel.TextSettings.Font.Style := [TFontStyle.fsBold];
  FXPLabel.TextSettings.FontColor := TAlphaColorRec.Silver;
  FXPLabel.StyledSettings := [];

end;

{==============================================================================}
procedure TPlayerStatsPanel.AddSectionLabel(const AText: string);
var
  Lbl: TLabel;
begin
  Lbl := TLabel.Create(FInnerLayout);
  Lbl.Parent := FInnerLayout;
  Lbl.Align := TAlignLayout.Top;
  Lbl.Height := 32;
  Lbl.Margins.Top := 10;
  Lbl.Margins.Bottom := 4;
  Lbl.Text := AText;
  Lbl.TextAlign := TTextAlign.Center;
  Lbl.TextSettings.Font.Size := 18;
  Lbl.TextSettings.Font.Style := [TFontStyle.fsBold];
  Lbl.TextSettings.FontColor := TAlphaColorRec.Gold;
  Lbl.StyledSettings := [];

end;

{==============================================================================}
function TPlayerStatsPanel.AddValueRow(const ACaption: string): TLayout;
var
  Row: TLayout;
  NameLbl: TLabel;
  ValueRect: TRectangle;
  ValLbl: TLabel;
begin
  Row := TLayout.Create(FInnerLayout);
  Row.Parent := FInnerLayout;
  Row.Align := TAlignLayout.Top;
  Row.Height := 28;
  Row.Margins.Bottom := 2;

  NameLbl := TLabel.Create(Row);
  NameLbl.Parent := Row;
  NameLbl.Align := TAlignLayout.Left;
  NameLbl.Width := 150;
  NameLbl.Text := ACaption;
  NameLbl.TextSettings.Font.Size := 16;
  NameLbl.TextSettings.Font.Style := [TFontStyle.fsBold];
  NameLbl.TextSettings.FontColor := TAlphaColorRec.White;
  NameLbl.StyledSettings := [];

  ValueRect := TRectangle.Create(Row);
  ValueRect.Parent := Row;
  ValueRect.Align := TAlignLayout.Right;
  ValueRect.Width := 45;
  ValueRect.Fill.Color := $FF270808;
  ValueRect.Stroke.Kind := TBrushKind.None;
  ValueRect.XRadius := 6;
  ValueRect.YRadius := 6;
  ValueRect.HitTest := True;
  ValueRect.OnClick := ValueRectClick;

  ValLbl := TLabel.Create(ValueRect);
  ValLbl.Parent := ValueRect;
  ValLbl.Align := TAlignLayout.Client;
  ValLbl.Text := '0';
  ValLbl.TextSettings.Font.Size := 14;
  ValLbl.TextSettings.Font.Style := [TFontStyle.fsBold];
  ValLbl.TextSettings.FontColor := TAlphaColorRec.White;
  ValLbl.TextSettings.HorzAlign := TTextAlign.Center;
  ValLbl.TextSettings.VertAlign := TTextAlign.Center;
  ValLbl.StyledSettings := [];

  Result := Row;
end;

{==============================================================================}
procedure TPlayerStatsPanel.BuildFromPlayer(const APlayer: TPlayer);
var
  i: Integer;
  Row: TLayout;
  NameLbl: TLabel;
  ValLbl: TLabel;
  Skill: TSkill;
begin
  // HEADER
  FHeaderName.Text :=
    APlayer.FName + ' ' + APlayer.Surname + sLineBreak +
    IntToStr(APlayer.Age);

  if FileExists(DirAssets + 'c' + IntToStr(APlayer.Country) + '.png') then
    FHeaderFlag.Bitmap.LoadFromFile(
      DirAssets + 'c' + IntToStr(APlayer.Country) + '.png')
  else
    FHeaderFlag.Bitmap.Clear(TAlphaColorRec.Null);

  // ATTRIBUTES
  for i := High(FStatRows) Downto Low(FStatRows) do
  begin
    Row := FStatRows[i];
    ValLbl := (Row.Controls[1] as TRectangle).Controls[0] as TLabel;
    ValLbl.Text := APlayer.Stats[i].ToString;
  end;

  // XP
  FXPLabel.Text := L(STR_XP) + ': ' + APlayer.XP.ToString;

  // RESET SKILLS
  for i := 0 to 5 do
  begin
    Row := FSkillRows[i];
    NameLbl := Row.Controls[0] as TLabel;
    ValLbl := (Row.Controls[1] as TRectangle).Controls[0] as TLabel;
    NameLbl.Text := '';
    ValLbl.Text := '0';
  end;

  // FILL SKILLS
  if APlayer.Skills.Count = 0 then
    exit;

  for i := 0 to Min(5, APlayer.Skills.Count - 1) do
  begin
    Skill := APlayer.Skills[i];
    Row := FSkillRows[i];

    NameLbl := Row.Controls[0] as TLabel;
    ValLbl := (Row.Controls[1] as TRectangle).Controls[0] as TLabel;

    NameLbl.Text := L(SKILL_NAMES[Skill.Id]^);
    ValLbl.Text := Skill.Level.ToString;
  end;

  // STAMINA
  FStaminaLabel.Text := L(STR_STAMINA) + ': ' + APlayer.FStamina.ToString;

end;

{==============================================================================}
procedure TPlayerStatsPanel.ValueRectClick(Sender: TObject);
begin
  // hook per upgrade / dettaglio stat o skill
end;

end.

