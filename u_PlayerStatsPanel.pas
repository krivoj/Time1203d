unit u_PlayerStatsPanel;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Types, u_PlayerTemplates,u_Types,u_core,
  FMX.Types, FMX.Controls, FMX.Objects, FMX.Graphics, FMX.Layouts, FMX.StdCtrls;

type
  TPlayerStatsPanel = class(TLayout)
  private
    FBarRects: array of TRectangle;
    FValueRects: array of TRectangle;
    FValueLabels: array of TLabel;
    procedure AddStatRow(const StatName: string; Value: Integer; Index: Integer);
    procedure ValueRectClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; const Names: ArrayStatNames );
    procedure BuildFromPlayer(const Names: ArrayStatNames; const APlayer: TPlayer);
    procedure ClearStats;
    destructor Destroy; override;
  end;

implementation

{---------------------------------------------}

constructor TPlayerStatsPanel.Create(AOwner: TComponent; const Names: ArrayStatNames);
begin
  inherited Create(AOwner);
  Align := TAlignLayout.Client;
  ClearStats;
  SetLength(FBarRects, Length(Names));
  SetLength(FValueRects, Length(Names));
  SetLength(FValueLabels, Length(Names));
end;

{---------------------------------------------}
procedure TPlayerStatsPanel.AddStatRow(const StatName: string; Value: Integer; Index: Integer);
var
  Row: TLayout;
  BarBg, BarFill, ValueRect: TRectangle;
  Lbl, ValLbl: TLabel;
begin
  Row := TLayout.Create(Self);
  Row.Parent := Self;
  Row.Align := TAlignLayout.Top;
  Row.Height := 36;
  Row.Padding.Rect := TRectF.Create(5, 2, 5, 2);
  Row.Margins.Bottom := 2;

  // nome statistica
  Lbl := TLabel.Create(Row);
  Lbl.Parent := Row;
  Lbl.Text := StatName;
  Lbl.Align := TAlignLayout.Left;
  Lbl.Width := 100;
  Lbl.TextSettings.Font.Size := 14;

  // barra sfondo
  BarBg := TRectangle.Create(Row);
  BarBg.Parent := Row;
  BarBg.Align := TAlignLayout.Client;
  BarBg.Margins.Right := 50;
  BarBg.Fill.Color := TAlphaColorRec.Lightgray;
  BarBg.Stroke.Kind := TBrushKind.None;
  BarBg.XRadius := 6;
  BarBg.YRadius := 6;

  // barra valore
  BarFill := TRectangle.Create(BarBg);
  BarFill.Parent := BarBg;
  BarFill.Align := TAlignLayout.Left;
  BarFill.Width := BarBg.Width * Value / 100;
  BarFill.Fill.Color := TAlphaColorRec.Skyblue;
  BarFill.XRadius := 6;
  BarFill.YRadius := 6;
  BarFill.Margins.Rect := TRectF.Create(1, 1, 1, 1);
  FBarRects[Index] := BarFill;

  // rettangolo valore cliccabile
  ValueRect := TRectangle.Create(Row);
  ValueRect.Parent := Row;
  ValueRect.Align := TAlignLayout.Right;
  ValueRect.Width := 45;
  ValueRect.XRadius := 6;
  ValueRect.YRadius := 6;
  ValueRect.Stroke.Kind := TBrushKind.None;
  ValueRect.Tag := Index;
  ValueRect.HitTest := True;
  ValueRect.OnClick := ValueRectClick;

  if Value > 17 then
    ValueRect.Fill.Color := TAlphaColorRec.Lightgreen
  else if Value > 10 then
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
procedure TPlayerStatsPanel.ValueRectClick(Sender: TObject);
var
  R: TRectangle;
begin
  R := TRectangle(Sender);
  //ShowMessage(Format('Hai cliccato il valore della stat #%d', [R.Tag]));
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
procedure TPlayerStatsPanel.BuildFromPlayer(const Names: ArrayStatNames; const APlayer: TPlayer);
var
  i:integer;
begin
  // da implementare: leggere valori dal Player
    for i := Low(Names) to High(Names) do
      AddStatRow(Names[i], APlayer.FStats[i], i);

end;

{---------------------------------------------}
destructor TPlayerStatsPanel.Destroy;
begin
  inherited;
end;

end.

