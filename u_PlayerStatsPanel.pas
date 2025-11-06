unit u_PlayerStatsPanel;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Types, Math, u_Systemutils, u_Localization,
  u_PlayerTemplates, u_Types, u_core, u_traits,
  FMX.Types, FMX.Controls, FMX.Objects, FMX.Graphics, FMX.Layouts, FMX.StdCtrls;

type
  TPlayerStatsPanel = class(TLayout)
  private
    FRows: array of TLayout; // riferimenti ai row, utile per aggiornare
    FHeaderName: TLabel;
    FHeaderFlag: TImage;
    FInnerLayout: TLayout;
    FBackground: TRectangle;
    FAttr1Val, FAttr2Val: TLabel;
    procedure AddStatRow(const StatName: string; Index: Integer);
    procedure ValueRectClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; const Names: ArrayStatNames);
    procedure BuildFromPlayer(const Names: ArrayStatNames; const APlayer: TPlayer);
    destructor Destroy; override;
  end;

implementation

{---------------------------------------------}

constructor TPlayerStatsPanel.Create(AOwner: TComponent; const Names: ArrayStatNames);
var
  i: Integer;
  HeaderBg: TRectangle;
  AStat: string;
  ExtraLayout: TLayout;
  Attr1Row, Attr2Row: TLayout;
  Attr1Label, Attr2Label: TLabel;
  Attr1Rect, Attr2Rect: TRectangle;
begin
  inherited Create(AOwner);

  Align := TAlignLayout.Left;
  Width := 320;

  // SFONDO marrone scuro per bloccare click al viewport
  FBackground := TRectangle.Create(Self);
  FBackground.Parent := Self;
  FBackground.Align := TAlignLayout.Client;
  FBackground.Fill.Color := $FF270808; // marrone scuro
  FBackground.Stroke.Kind := TBrushKind.None;
  FBackground.Opacity := 0.95;
  FBackground.HitTest := True;

  // HEADER nome giocatore
  FHeaderName := TLabel.Create(Self);
  FHeaderName.Parent := Self;
  FHeaderName.Align := TAlignLayout.Top;
  FHeaderName.Height := 70;
  FHeaderName.Margins.Rect := TRectF.Create(1, 1, 1, 1);
  FHeaderName.TextSettings.Font.Size := 20;
  FHeaderName.TextSettings.FontColor := TAlphaColorRec.White;
  FHeaderName.TextSettings.Font.Style := [TFontStyle.fsBold];
  FHeaderName.TextSettings.HorzAlign := TTextAlign.Center;
  FHeaderName.TextSettings.VertAlign := TTextAlign.Center;
  FHeaderName.StyledSettings := [];

  // IMMAGINE bandiera nell'header
  FHeaderFlag := TImage.Create(Self);
  FHeaderFlag.Parent := FHeaderName;
  FHeaderFlag.Width := 28;
  FHeaderFlag.Height := 28;
  FHeaderFlag.Align := TAlignLayout.None;
  FHeaderFlag.Position.X := FHeaderName.Width - FHeaderFlag.Width - 10;
  FHeaderFlag.Position.Y := FHeaderName.Height - FHeaderFlag.Height - 8;
  FHeaderFlag.WrapMode := TImageWrapMode.Stretch;
  FHeaderFlag.HitTest := False;

  // RETTANGOLO SFONDO per header
  HeaderBg := TRectangle.Create(Self);
  HeaderBg.Parent := Self;
  HeaderBg.Margins.Left := FHeaderName.Margins.Left;
  HeaderBg.Margins.Right := FHeaderName.Margins.Right;
  HeaderBg.Width := FHeaderName.Width;
  HeaderBg.Height := FHeaderName.Height;
  HeaderBg.Fill.Color := $FF270808;
  HeaderBg.Stroke.Kind := TBrushKind.None;
  HeaderBg.Position.Point := FHeaderName.Position.Point;
  FHeaderName.BringToFront;

  // layout interno per le statistiche
  FInnerLayout := TLayout.Create(Self);
  FInnerLayout.Parent := Self;
  FInnerLayout.Align := TAlignLayout.Client;
  FInnerLayout.Padding.Rect := TRectF.Create(8, 8, 8, 8);
  FInnerLayout.Margins.Rect := TRectF.Create(0, 0, 0, 10);
  FInnerLayout.HitTest := True;

  // CREO TUTTE LE RIGHE con nomi fissi
  SetLength(FRows, Length(Names));
  for i := High(Names) downto Low(Names) do
  begin
    AStat := Capitalize(u_localization.Translate(Names[i]));
    AddStatRow(AStat, i);
  end;

  // ---- ATTRIBUTI EXTRA NON STAT ----
  ExtraLayout := TLayout.Create(FInnerLayout);
  ExtraLayout.Parent := FInnerLayout;
  ExtraLayout.Align := TAlignLayout.Bottom; // <-- CAMBIATO (era Top)
  ExtraLayout.Height := 70;
  ExtraLayout.Padding.Rect := TRectF.Create(5, 10, 5, 10);
  ExtraLayout.Margins.Top := 10;

  // Primo attributo (Fitness)
  Attr1Row := TLayout.Create(ExtraLayout);
  Attr1Row.Parent := ExtraLayout;
  Attr1Row.Align := TAlignLayout.Top;
  Attr1Row.Height := 26;
  Attr1Row.Padding.Rect := TRectF.Create(5, 2, 5, 2);

  Attr1Label := TLabel.Create(Attr1Row);
  Attr1Label.Parent := Attr1Row;
  Attr1Label.Align := TAlignLayout.Left;
  Attr1Label.Width := 140;
  Attr1Label.Text := Capitalize(u_localization.Translate('stat_conditioning'));
  Attr1Label.TextSettings.Font.Size := 16;
  Attr1Label.TextSettings.Font.Style := [TFontStyle.fsBold];
  Attr1Label.TextSettings.FontColor := TAlphaColorRec.White;
  Attr1Label.StyledSettings := [];

  Attr1Rect := TRectangle.Create(Attr1Row);
  Attr1Rect.Parent := Attr1Row;
  Attr1Rect.Align := TAlignLayout.Right;
  Attr1Rect.Width := 45;
  Attr1Rect.Height := Attr1Row.Height;
  Attr1Rect.Fill.Color := $FF270808;
  Attr1Rect.Stroke.Kind := TBrushKind.None;
  Attr1Rect.HitTest := False;
  Attr1Rect.XRadius := 6;
  Attr1Rect.YRadius := 6;

  FAttr1Val := TLabel.Create(Attr1Rect);
  FAttr1Val.Parent := Attr1Rect;
  FAttr1Val.Align := TAlignLayout.Client;
  FAttr1Val.Text := '0';
  FAttr1Val.TextSettings.Font.Size := 14;
  FAttr1Val.TextSettings.Font.Style := [TFontStyle.fsBold];
  FAttr1Val.TextSettings.FontColor := TAlphaColorRec.Black;
  FAttr1Val.TextSettings.HorzAlign := TTextAlign.Center;
  FAttr1Val.TextSettings.VertAlign := TTextAlign.Center;
  FAttr1Val.StyledSettings := [];

  // Secondo attributo (Injury)
  Attr2Row := TLayout.Create(ExtraLayout);
  Attr2Row.Parent := ExtraLayout;
  Attr2Row.Align := TAlignLayout.Top;
  Attr2Row.Height := 26;
  Attr2Row.Padding.Rect := TRectF.Create(5, 2, 5, 2);

  Attr2Label := TLabel.Create(Attr2Row);
  Attr2Label.Parent := Attr2Row;
  Attr2Label.Align := TAlignLayout.Left;
  Attr2Label.Width := 140;
  Attr2Label.Text := Capitalize(u_localization.Translate('stat_injuryresistance'));
  Attr2Label.TextSettings.Font.Size := 16;
  Attr2Label.TextSettings.Font.Style := [TFontStyle.fsBold];
  Attr2Label.TextSettings.FontColor := TAlphaColorRec.White;
  Attr2Label.StyledSettings := [];

  Attr2Rect := TRectangle.Create(Attr2Row);
  Attr2Rect.Parent := Attr2Row;
  Attr2Rect.Align := TAlignLayout.Right;
  Attr2Rect.Width := 45;
  Attr2Rect.Height := Attr2Row.Height;
  Attr2Rect.Fill.Color := $FF270808;
  Attr2Rect.Stroke.Kind := TBrushKind.None;
  Attr2Rect.HitTest := False;
  Attr2Rect.XRadius := 6;
  Attr2Rect.YRadius := 6;

  FAttr2Val := TLabel.Create(Attr2Rect);
  FAttr2Val.Parent := Attr2Rect;
  FAttr2Val.Align := TAlignLayout.Client;
  FAttr2Val.Text := '0';
  FAttr2Val.TextSettings.Font.Size := 14;
  FAttr2Val.TextSettings.Font.Style := [TFontStyle.fsBold];
  FAttr2Val.TextSettings.FontColor := TAlphaColorRec.Black;
  FAttr2Val.TextSettings.HorzAlign := TTextAlign.Center;
  FAttr2Val.TextSettings.VertAlign := TTextAlign.Center;
  FAttr2Val.StyledSettings := [];
end;

{---------------------------------------------}
procedure TPlayerStatsPanel.AddStatRow(const StatName: string; Index: Integer);
var
  Row: TLayout;
  BarBg, BarFill, ValueRect: TRectangle;
  Lbl, ValLbl: TLabel;
  BarHeight: Single;
begin
  Row := TLayout.Create(FInnerLayout);
  Row.Parent := FInnerLayout;
  Row.Align := TAlignLayout.Top;
  Row.Height := 28;
  Row.Padding.Rect := TRectF.Create(5, 2, 5, 2);
  Row.Margins.Bottom := 2;

  FRows[Index] := Row;

  BarHeight := 7; // barre sottili

  // NOME statistica a sinistra
  Lbl := TLabel.Create(Row);
  Lbl.Parent := Row;
  Lbl.Text := StatName;
  Lbl.Align := TAlignLayout.Left;
  Lbl.Width := 140;
  Lbl.TextSettings.Font.Size := 16;
  Lbl.TextSettings.Font.Style := [TFontStyle.fsBold];
  Lbl.TextSettings.FontColor := TAlphaColorRec.White;
  Lbl.StyledSettings := [];

  // RETTANGOLO valore (cliccabile) a destra
  ValueRect := TRectangle.Create(Row);
  ValueRect.Parent := Row;
  ValueRect.Width := 45;
  ValueRect.Height := Row.Height;
  ValueRect.Align := TAlignLayout.Right;
  ValueRect.Fill.Color := $FF270808;
  ValueRect.Stroke.Kind := TBrushKind.None;
  ValueRect.Tag := Index;
  ValueRect.HitTest := True;
  ValueRect.OnClick := ValueRectClick;

  ValueRect.XRadius := 6;
  ValueRect.YRadius := 6;

  ValLbl := TLabel.Create(ValueRect);
  ValLbl.Parent := ValueRect;
  ValLbl.Align := TAlignLayout.Client;
  ValLbl.Text := '0';
  ValLbl.TextSettings.Font.Size := 14;
  ValLbl.TextSettings.FontColor := TAlphaColorRec.Black;
  ValLbl.TextSettings.HorzAlign := TTextAlign.Center;
  ValLbl.TextSettings.VertAlign := TTextAlign.Center;
  ValLbl.TextSettings.Font.Style := [TFontStyle.fsBold];
  ValLbl.StyledSettings := [];

  BarBg := TRectangle.Create(Row);
  BarBg.Parent := Row;
  BarBg.Width := Row.Width - Lbl.Width - ValueRect.Width - 65;
  BarBg.Height := BarHeight;
  BarBg.Position.X := Lbl.Width + 50;
  BarBg.Position.Y := (Row.Height - BarBg.Height) / 2;
  BarBg.Fill.Color := $FF060101;
  BarBg.Stroke.Kind := TBrushKind.None;
  BarBg.XRadius := BarBg.Height / 2;
  BarBg.YRadius := BarBg.Height / 2;

  BarFill := TRectangle.Create(BarBg);
  BarFill.Parent := BarBg;
  BarFill.Align := TAlignLayout.Left;
  BarFill.Width := 0;
  BarFill.Fill.Color := TAlphaColorRec.Skyblue;
  BarFill.XRadius := BarHeight / 2;
  BarFill.YRadius := BarHeight / 2;
  BarFill.Margins.Rect := TRectF.Create(0, 0, 0, 0);
end;

{---------------------------------------------}
procedure TPlayerStatsPanel.ValueRectClick(Sender: TObject);
begin
  // Gestione click
end;

{---------------------------------------------}
procedure TPlayerStatsPanel.BuildFromPlayer(const Names: ArrayStatNames; const APlayer: TPlayer);
var
  i: Integer;
  Row: TLayout;
  BarBg, BarFill, ValueRect: TRectangle;
  ValLbl: TLabel;
begin
  FHeaderName.Text := APlayer.FName + APlayer.FSurname + sLineBreak + IntToStr(APlayer.Age);
  if FileExists(DirAssets + 'c' + IntToStr(APlayer.FCountry) + '.png') then
    FHeaderFlag.Bitmap.LoadFromFile(DirAssets + 'c' + IntToStr(APlayer.FCountry) + '.png')
  else
    FHeaderFlag.Bitmap.Clear(TAlphaColorRec.Null);

  for i := Low(Names) to High(Names) do
  begin
    Row := FRows[i];
    BarBg := Row.Controls[2] as TRectangle;
    BarFill := BarBg.Controls[0] as TRectangle;
    BarFill.Width := BarBg.Width * APlayer.FxpStats[i] / 120;

    ValueRect := Row.Controls[1] as TRectangle;
    ValLbl := ValueRect.Controls[0] as TLabel;
    ValLbl.Text := APlayer.FStats[i].ToString;

    if i <> Speed then
    begin
      if APlayer.FStats[i] > 18 then
        ValueRect.Fill.Color := TAlphaColorRec.Aqua
      else if APlayer.FStats[i] > 12 then
        ValueRect.Fill.Color := TAlphaColorRec.Lightgreen
      else if APlayer.FStats[i] > 9 then
        ValueRect.Fill.Color := TAlphaColorRec.Khaki
      else
        ValueRect.Fill.Color := TAlphaColorRec.Indianred;
    end
    else
    begin
      if APlayer.FStats[i] > 3 then
        ValueRect.Fill.Color := TAlphaColorRec.Aqua
      else if APlayer.FStats[i] > 2 then
        ValueRect.Fill.Color := TAlphaColorRec.Lightgreen
      else if APlayer.FStats[i] > 1 then
        ValueRect.Fill.Color := TAlphaColorRec.Khaki
      else
        ValueRect.Fill.Color := TAlphaColorRec.Indianred;
    end;

    BarBg.Position.Y := (Row.Height - BarBg.Height) / 2;
  end;

  // Attributi extra
  FAttr1Val.Text := APlayer.FConditioning.ToString;
  FAttr2Val.Text := APlayer.FInjuryResistance.ToString;

  if APlayer.FConditioning > 2 then
    FAttr1Val.TextSettings.FontColor := TAlphaColorRec.Aqua
  else if APlayer.FConditioning > 1 then
    FAttr1Val.TextSettings.FontColor := TAlphaColorRec.Lightgreen
  else if APlayer.FConditioning > 0 then
    FAttr1Val.TextSettings.FontColor := TAlphaColorRec.Khaki
  else
    FAttr1Val.TextSettings.FontColor := TAlphaColorRec.Indianred;

  if APlayer.FInjuryResistance > 2 then
    FAttr2Val.TextSettings.FontColor := TAlphaColorRec.Aqua
  else if APlayer.FInjuryResistance > 1 then
    FAttr2Val.TextSettings.FontColor := TAlphaColorRec.Lightgreen
  else if APlayer.FInjuryResistance > 0 then
    FAttr2Val.TextSettings.FontColor := TAlphaColorRec.Khaki
  else
    FAttr2Val.TextSettings.FontColor := TAlphaColorRec.Indianred;
end;

{---------------------------------------------}
destructor TPlayerStatsPanel.Destroy;
begin
  inherited;
end;

end.

