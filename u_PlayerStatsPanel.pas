unit u_PlayerStatsPanel;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Types, Math,
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
  HeaderBg : TRectangle;
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

  // CREO RETTANGOLO DI SFONDO PER LA LABEL
  HeaderBg := TRectangle.Create(Self);
  HeaderBg.Parent := Self;
  //HeaderBg.Align := TAlignLayout.Top;
  HeaderBg.Margins.Left := FHeaderName.Margins.Left;
  HeaderBg.Margins.right := FHeaderName.Margins.Right;
  HeaderBg.Width := FHeaderName.Width;
  HeaderBg.Height := FHeaderName.Height;
  HeaderBg.Fill.Color := $FF270808; // stesso marrone
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
  for i := high(Names) Downto Low(Names) do
    AddStatRow(Names[i], i);
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
  Lbl.Width := 140; // più lungo
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
  ValueRect.Fill.Color := $FF270808; // marrone scuro
  ValueRect.Stroke.Kind := TBrushKind.None;
  ValueRect.Tag := Index;
  ValueRect.HitTest := True;
  ValueRect.OnClick := ValueRectClick;

  // ARROTONDA IL RETTANGOLO
  ValueRect.XRadius := 6;
  ValueRect.YRadius := 6;
  // LABEL valore centrato dentro il rettangolo
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

  // BARRA sfondo (sotto la barra del valore)
  BarBg := TRectangle.Create(Row);
  BarBg.Parent := Row;
  BarBg.Width := Row.Width - Lbl.Width - ValueRect.Width - 65; // 10 px di padding
  BarBg.Height := BarHeight; // sottilissima
  BarBg.Position.X := Lbl.Width + 50; // subito dopo il nome
  BarBg.Position.Y := (Row.Height - BarBg.Height) / 2;
  BarBg.Fill.Color := $FF060101;
  BarBg.Stroke.Kind := TBrushKind.None;
  BarBg.XRadius := BarBg.Height/2;
  BarBg.YRadius := BarBg.Height/2;

  // BARRA valore (riempita dinamicamente)
  BarFill := TRectangle.Create(BarBg);
  BarFill.Parent := BarBg;
  BarFill.Align := TAlignLayout.Left;
  BarFill.Width := 0;
  BarFill.Fill.Color := TAlphaColorRec.Skyblue;
  BarFill.XRadius := BarHeight/2;
  BarFill.YRadius := BarHeight/2;
  BarFill.Margins.Rect := TRectF.Create(0, 0, 0, 0);
end;

{---------------------------------------------}
procedure TPlayerStatsPanel.ValueRectClick(Sender: TObject);
var
  R: TRectangle;
begin
  R := TRectangle(Sender);
  // Qui gestisci il click sul valore: R.Tag restituisce l'indice
end;

{---------------------------------------------}
procedure TPlayerStatsPanel.BuildFromPlayer(const Names: ArrayStatNames; const APlayer: TPlayer);
var
  i: Integer;
  Row: TLayout;
  BarBg, BarFill, ValueRect: TRectangle;
  ValLbl: TLabel;
begin
  // header nome giocatore
  FHeaderName.Text := APlayer.FName + APlayer.FSurname +  sLineBreak +  IntTostr(APlayer.Age) ;
  if FileExists(DirAssets + 'c' + IntToStr(APlayer.FCountry) + '.png') then
    FHeaderFlag.Bitmap.LoadFromFile(DirAssets + 'c' + IntToStr(APlayer.FCountry) + '.png')
  else
  FHeaderFlag.Bitmap.Clear(TAlphaColorRec.Null);

  for i := Low(Names) to High(Names) do
  begin
    Row := FRows[i];

    // barre
    BarBg := Row.Controls[2] as TRectangle; // seconda barra creata sopra
    BarFill := BarBg.Controls[0] as TRectangle;
    BarFill.Width := BarBg.Width * APlayer.FxpStats[i] / 120;

    // valore
    ValueRect := Row.Controls[1] as TRectangle;
    ValLbl := ValueRect.Controls[0] as TLabel;
    ValLbl.Text := APlayer.FStats[i].ToString;

    // colore rettangolo valore
    if i <> Speed Then begin
      if APlayer.FStats[i] > 18 then
        ValueRect.Fill.Color := TAlphaColorRec.Aqua
      else if APlayer.FStats[i] > 12 then
        ValueRect.Fill.Color := TAlphaColorRec.Lightgreen
      else if APlayer.FStats[i] > 9 then
        ValueRect.Fill.Color := TAlphaColorRec.Khaki
      else
        ValueRect.Fill.Color := TAlphaColorRec.Indianred;
    end
    else begin
      if APlayer.FStats[i] > 3 then
        ValueRect.Fill.Color := TAlphaColorRec.Aqua
      else if APlayer.FStats[i] > 2 then
        ValueRect.Fill.Color := TAlphaColorRec.Lightgreen
      else if APlayer.FStats[i] > 1 then
        ValueRect.Fill.Color := TAlphaColorRec.Khaki
      else
        ValueRect.Fill.Color := TAlphaColorRec.Indianred;

    end;

    // centrare verticalmente la barra rispetto al rettangolo del valore
    BarBg.Position.Y := (Row.Height - BarBg.Height)/2;
  end;
end;

{---------------------------------------------}
destructor TPlayerStatsPanel.Destroy;
begin
  inherited;
end;

end.

