unit u_PlayerStatsPanel;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Types,
  FMX.Types, FMX.Controls, FMX.Objects, FMX.Graphics, FMX.Layouts, FMX.StdCtrls;

type
  TPlayerStatsPanel = class(TLayout)
  private
    FArrowImgs: array[0..4] of TBitmap;
    FBarRects: array of TRectangle;
    FValueRects: array of TRectangle;
    FValueLabels: array of TLabel;
    procedure AddStatRow(const StatName: string; Value: Integer; Index: Integer);
    procedure ArrowClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; const DirBmp: string); reintroduce;
    procedure LoadArrowBitmaps(const Folder: string);
    procedure BuildFromArray(const Names: array of string; const Values: array of Integer);
    procedure BuildFromPlayer(const Player: TObject);
    procedure ClearStats;
    destructor Destroy; override;
  end;

implementation

{---------------------------------------------}
constructor TPlayerStatsPanel.Create(AOwner: TComponent; const DirBmp: string);
begin
  inherited Create(AOwner);
  Align := TAlignLayout.Client; // o quello che ti serve
  LoadArrowBitmaps(DirBmp);
end;
procedure TPlayerStatsPanel.LoadArrowBitmaps(const Folder: string);
var
  i: Integer;
begin
  for i := 0 to 4 do
  begin
    FArrowImgs[i] := TBitmap.Create;
    FArrowImgs[i].LoadFromFile(Format('%s\Arrow%d.bmp', [Folder, i + 1]));
  end;
end;

{---------------------------------------------}
procedure TPlayerStatsPanel.BuildFromArray(const Names: array of string; const Values: array of Integer);
var
  i: Integer;
begin
  ClearStats;
  SetLength(FBarRects, Length(Names));
  SetLength(FValueRects, Length(Names));
  SetLength(FValueLabels, Length(Names));

  for i := 0 to High(Names) do
    AddStatRow(Names[i], Values[i], i);
end;

{---------------------------------------------}
procedure TPlayerStatsPanel.AddStatRow(const StatName: string; Value: Integer; Index: Integer);
var
  Row: TLayout;
  BarBg, BarFill, ValueRect: TRectangle;
  Lbl, ValLbl: TLabel;
  Img: TImage;
begin
  Row := TLayout.Create(Self);
  Row.Parent := Self;
  Row.Align := TAlignLayout.Top;
  Row.Height := 36;
  Row.Padding.Rect := TRectF.Create(5, 2, 5, 2);
  Row.Margins.Bottom := 2;

  // nome proprietà
  Lbl := TLabel.Create(Row);
  Lbl.Parent := Row;
  Lbl.Text := StatName;
  Lbl.Align := TAlignLayout.Left;
  Lbl.Width := 100;
  Lbl.TextSettings.Font.Size := 14;

  // immagine freccette
  Img := TImage.Create(Row);
  Img.Parent := Row;
  Img.Align := TAlignLayout.Left;
  Img.Width := 80;
  Img.HitTest := True;
  Img.Tag := 0; // stato corrente (0..4)
  Img.Bitmap.Assign(FArrowImgs[0]);
  Img.OnClick := ArrowClick;

  // barra incrementale
  BarBg := TRectangle.Create(Row);
  BarBg.Parent := Row;
  BarBg.Align := TAlignLayout.Client;
  BarBg.Margins.Right := 50;
  BarBg.Fill.Color := TAlphaColorRec.Lightgray;
  BarBg.Stroke.Kind := TBrushKind.None;
  BarBg.XRadius := 6;
  BarBg.YRadius := 6;

  BarFill := TRectangle.Create(BarBg);
  BarFill.Parent := BarBg;
  BarFill.Align := TAlignLayout.Left;
  BarFill.Width := BarBg.Width * Value / 100;
  BarFill.Fill.Color := TAlphaColorRec.Skyblue;
  BarFill.XRadius := 6;
  BarFill.YRadius := 6;
  BarFill.Margins.Rect := TRectF.Create(1, 1, 1, 1);
  FBarRects[Index] := BarFill;

  // rettangolo valore
  ValueRect := TRectangle.Create(Row);
  ValueRect.Parent := Row;
  ValueRect.Align := TAlignLayout.Right;
  ValueRect.Width := 45;
  ValueRect.XRadius := 6;
  ValueRect.YRadius := 6;
  ValueRect.Stroke.Kind := TBrushKind.None;

  if Value > 70 then
    ValueRect.Fill.Color := TAlphaColorRec.Lightgreen
  else if Value > 40 then
    ValueRect.Fill.Color := TAlphaColorRec.Khaki
  else
    ValueRect.Fill.Color := TAlphaColorRec.Indianred;

  ValLbl := TLabel.Create(ValueRect);
  ValLbl.Parent := ValueRect;
  ValLbl.Align := TAlignLayout.Center;
  ValLbl.Text := Value.ToString;
  ValLbl.TextSettings.Font.Size := 14;

  FValueRects[Index] := ValueRect;
  FValueLabels[Index] := ValLbl;
end;

{---------------------------------------------}
procedure TPlayerStatsPanel.ArrowClick(Sender: TObject);
var
  Img: TImage;
  Level: Integer;
begin
  Img := TImage(Sender);
  Level := Img.Tag + 1;
  if Level > 4 then
    Level := 0; // torna a zero
  Img.Tag := Level;
  Img.Bitmap.Assign(FArrowImgs[Level]);
end;

{---------------------------------------------}
procedure TPlayerStatsPanel.ClearStats;
begin
  Self.DeleteChildren;
  SetLength(FBarRects, 0);
  SetLength(FValueRects, 0);
  SetLength(FValueLabels, 0);
end;

{---------------------------------------------}
procedure TPlayerStatsPanel.BuildFromPlayer(const Player: TObject);
begin
  // placeholder:
  // qui puoi leggere le proprietà da TPlayer (es. Player.ShotPower, Player.Speed, ecc.)
  // e poi chiamare BuildFromArray
end;

{---------------------------------------------}
destructor TPlayerStatsPanel.Destroy;
var
  i: Integer;
begin
  for i := 0 to 4 do
    FArrowImgs[i].Free;
  inherited;
end;

end.

