unit Unit1;
interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Types, System.Variants,
  FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,u_TileGrid,u_FieldLines, u_RandomHelper,u_Localization,u_Systemutils,
  FMX.Viewport3D, System.Math.Vectors, FMX.Controls3D , FMX.Objects3D, FMX.SpinBox,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.objects, FMX.materialSources ,FMX.OBJ.importer, u_SqlcreateSave, math,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FMX.Types3D,FireDAC.Phys.SQLite, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,System.IOUtils,
  FMX.Types, u_playerModel, u_core, u_Types, u_PlayerTemplates, u_Skills, u_PlayerStatsPanel;

Type TMouseStatus = (Ms_None, Ms_Waiting_For_Destination_Cell );
Type TGameScreen = (gsFormation, gsMatch, gsSubs, gsTactics, gsMarket, gsStandings );

type
  TForm1 = class(TForm)
    Viewport3D1: TViewport3D;
    Camera1: TCamera;
    LayoutCam: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure Viewport3D1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure Viewport3D1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    MenuLayout: TLayout;
    BtnNewGame, BtnLoadGame, BtnExit: TSpeedButton;
    procedure InitMenu;
    procedure InitGame;
    procedure SetupLayout;
    procedure SpinChange(Sender: TObject);
    procedure SyncSpinsWithCamera;
    procedure BtnNewGameClick(Sender: TObject);
    procedure BtnLoadGameClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);  public
    { Public declarations }
    procedure SetupCameraTopView;
    procedure TileMouseDown(Sender:Tobject; Button: TMouseButton; CellX,CellY: integer);
    procedure TileMouseMove(Sender: TObject; CellX,CellY: integer);
    function GetPlayerFromGrid ( GridIndex, CellX, CellY: integer): TPlayer;

    procedure CreateTestPlayers;
    procedure CreateGround;
  public
    end;

var

  Form1: TForm1;
  PlayerStatsPanel: TPlayerStatsPanel;
  BtnExit,BtnNewGame,BtnLoadGame: TButton;
  Board, Reserve0, Reserve1: TTileGrid;
  SelectedPlayer: TPlayer;
  StartTilePos: TPoint;
  StartPoint3DPos: TPoint3D;
  Players: array[0..21] of TPlayer;
  tile: TModelTile;
  Mat: TTextureMaterialSource ;
  Ground: TPlane;
  Grid: array [0..2] of TTileGrid;
  MouseStatus : TMouseStatus;
  GameScreen : TGameScreen;
  FormReady: boolean;
    CamNames: array[0..5] of string = ('Pos X', 'Pos Y', 'Pos Z', 'Rot X', 'Rot Y', 'Rot Z');
implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FormReady := false;
  DirAssets := ExtractFilePath(ParamStr(0)) + 'Assets\';
  DirSaves := GetLocalAppDataPath;
  ForceDirectories(DirSaves + '\Time120\');
  language:='IT';
  FileLocalization := ExtractFilePath(ParamStr(0)) + '\localization\'+ language + '\messages.txt';
  LoadTranslations(FileLocalization);
  // Viewport3D a coprire tutta la form
  Viewport3D1.Align := TAlignLayout.Client;
  Viewport3D1.Visible := False;
  // Inizializza menu overlay
  InitMenu;
  SetupLayout;
end;

procedure TForm1.Viewport3D1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  // se non hai rilasciato sopra nessuna cella, torna alla posizione iniziale
  if (Button = TMouseButton.mbLeft) and ( MouseStatus = Ms_Waiting_For_Destination_Cell) then begin
//SelectedPlayer.SetPosition ( StartPoint3DPos.X, StartPoint3DPos.Y, StartPoint3DPos.Z  );
    SelectedPlayer:= nil;
    MouseStatus := Ms_None;
    Grid[2].ClearHighLights;
  end;


end;

procedure TForm1.Viewport3D1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
begin
 Camera1.Position.Z := Camera1.Position.Z - WheelDelta * 0.01;
  if Camera1.Position.Z < 1 then
    Camera1.Position.Z := 1; // limiti min/max
  if Camera1.Position.Z > 100 then
    Camera1.Position.Z := 100;
end;
procedure TForm1.FormResize(Sender: TObject);
begin
  if not FormReady then exit;
  if not viewport3d1.Visible then exit;
  SetupCameraTopView;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  FormReady := True;
  FormResize(Self); // centra il layout
end;

procedure TForm1.SetupCameraTopView;
begin
  Camera1.Parent := Viewport3D1;

  // Posizionamento camera
  Camera1.Target := nil;  // Target NIL se usiamo RotationAngle
  Camera1.Position.X := 9;
  Camera1.Position.Y := 0;
  Camera1.Position.Z := 15;//16.7;

//  Camera1.RotationAngle.X := -170;  // Vista dall'alto  180 per centrare dall'alto , 170 inclinato
  Camera1.RotationAngle.X := 201;
  Camera1.RotationAngle.Y := 0;
  Camera1.RotationAngle.Z := 0;
  SyncSpinsWithCamera;
end;
procedure TForm1.TileMouseDown(Sender: TObject; Button: TMouseButton; CellX,CellY: integer);
var
  aPlayer: TPlayer;
  label f1;
begin
  if (GameScreen = gsFormation) then begin

    if (Button = TMouseButton.mbLeft) and ( MouseStatus= Ms_None) then begin
      SelectedPlayer := GetPlayerFromGrid ( TPlane(Sender).Tag, CellX, CellY);
      if SelectedPlayer = nil then exit;

      StartTilePos := Point ( CellX, CellY );
      StartPoint3DPos :=  SelectedPlayer.FPlayerModel.FModel.Position.Point;
      MouseStatus := Ms_Waiting_For_Destination_Cell;
      Grid[2].HighlightCell(0,5);
      Grid[2].HighlightFormationsCols;

    end
    else if (Button = TMouseButton.mbLeft) and ( MouseStatus= Ms_Waiting_For_Destination_Cell) then begin
      if SelectedPlayer <> nil then begin
      // FIndex indica su quale grid abbiamo cliccato. CellX e CellY  la cella su cui abbiamo cliccato.
        if (not CheckFormationPosition ( SelectedPlayer, CellX, CellY )) and (TPlane(Sender).Tag =2 ) then goto f1;
          // Cerca un TPlayerModel sopra al Tile
          // se lo trova lo mette al posto di selectedPlayer
          aPlayer := GetPlayerFromGrid ( TPlane(Sender).Tag, CellX, CellY );
          if aPlayer <> nil then begin // se c'è un player lo metto al posto di SelectedPlayer
            aPlayer.SetGridPosition( SelectedPlayer.FGridIndex , SelectedPlayer.CellX, SelectedPlayer.CellY );
            aPlayer.FPlayerModel.SetPosition( SelectedPlayer.FPlayerModel.FModel.Position.X, SelectedPlayer.FPlayerModel.FModel.Position.Y, SelectedPlayer.FPlayerModel.FModel.Position.Z );
          end;


          // Allinea la posizione di SelectedPlayer alla grid e alla cella di destinazione
          SelectedPlayer.SetGridPosition( TPlane(Sender).Tag, CellX, CellY );
          SelectedPlayer.FPlayerModel.SetPosition ( TPlane(Sender).Position.X, TPlane(Sender).Position.Y, SelectedPlayer.FPlayerModel.FModel.Position.Z);
  f1:
          //PlayerStatsPanel.Visible := false;
          SelectedPlayer := nil;
          MouseStatus := ms_None;
          Grid[2].ClearHighLights;

      end;
    end
    else if (Button = TMouseButton.mbRight)  then begin //and ( MouseStatus= Ms_None)
      goto f1;
    end;

  end;
  Caption :=Format('Hai cliccato DOWN la cella Col=%d Row=%d', [CellX, CellY]);
end;
procedure TForm1.TileMouseMove(Sender: TObject; CellX,CellY: integer);
var
  APlayer: TPlayer;
begin
  APlayer := GetPlayerFromGrid ( TPlane(Sender).Tag, CellX, CellY);
  if APlayer = Nil then exit;

  PlayerStatsPanel.Tag := APlayer.FGuid;
  PlayerStatsPanel.BuildFromPlayer(APlayer);
  PlayerStatsPanel.Visible := True;
  PlayerStatsPanel.BringToFront ;

end;

procedure TForm1.InitMenu;
var
  Img: TImage;
begin
  MenuLayout := TLayout.Create(Self);
  MenuLayout.Parent := Form1;       // Importante: parent = Form1
  MenuLayout.Align := TAlignLayout.Client;
  MenuLayout.Visible := True;

  // New Game button
  BtnNewGame := TSpeedButton.Create(MenuLayout);
  BtnNewGame.Parent := MenuLayout;
  BtnNewGame.Position.X := 100;
  BtnNewGame.Position.Y := 100;
  BtnNewGame.Width := 150;
  BtnNewGame.Height := 50;
  BtnNewGame.Text := 'newgame';
  BtnNewGame.OnClick := BtnNewGameClick;

  Img := TImage.Create(BtnNewGame);
  Img.Parent := BtnNewGame;
  Img.Align := TAlignLayout.Client;
  if fileexists('newgame.png') then
  Img.Bitmap.LoadFromFile('newgame.png'); // Immagine del pulsante
  Img.HitTest := False;

  // Load Game button
  BtnLoadGame := TSpeedButton.Create(MenuLayout);
  BtnLoadGame.Parent := MenuLayout;
  BtnLoadGame.Position.X := 100;
  BtnLoadGame.Position.Y := 170;
  BtnLoadGame.Width := 150;
  BtnLoadGame.Height := 50;
  BtnLoadGame.Text := 'LoadGame';
  BtnLoadGame.OnClick := BtnLoadGameClick;

  Img := TImage.Create(BtnLoadGame);
  Img.Parent := BtnLoadGame;
  Img.Align := TAlignLayout.Client;
  if fileexists('loadgame.png') then
  Img.Bitmap.LoadFromFile('loadgame.png');
  Img.HitTest := False;

  // Exit button
  BtnExit := TSpeedButton.Create(MenuLayout);
  BtnExit.Parent := MenuLayout;
  BtnExit.Position.X := 100;
  BtnExit.Position.Y := 240;
  BtnExit.Width := 150;
  BtnExit.Height := 50;
  BtnExit.Text := 'Exit';
  BtnExit.OnClick := BtnExitClick;

  Img := TImage.Create(BtnExit);
  Img.Parent := BtnExit;
  Img.Align := TAlignLayout.Client;
  if fileexists('exit.png') then
  Img.Bitmap.LoadFromFile('exit.png');
  Img.HitTest := False;
end;
procedure TForm1.InitGame;
var
  FieldDrawer: TFieldDrawer;
  FieldBitmap: TBitmap;
begin
  // Nascondi menu
  PlayerStatsPanel := TPlayerStatsPanel.Create(Viewport3d1);
  PlayerStatsPanel.Parent := Form1;
  PlayerStatsPanel.Visible := False;

// creo bitmap dinamica
// 1️⃣ Creo bitmap dinamica del campo
  FieldBitmap := CreateSoccerFieldBitmap(
    512, 512,
    TAlphaColorRec.Green,
    TAlphaColorRec.Darkgreen,
    10, 10, 10, 10);

  // 2️⃣ Creo la griglia direttamente passando la bitmap
  Board := TTileGrid.Create(Self, Viewport3D1, 2, 18, 11, FieldBitmap);
  // 3️⃣ Posiziono la griglia (opzionale)
  Board.SetBasePosition(-9, -5.5);

  // 4️⃣ Libero bitmap manualmente (materiale già l’ha copiata)
  FieldBitmap.Free;

  Board.SetBasePosition(-9, -5.5); // esempio per centrare 18x11 celle di 1 unit

  //Grid := TTileGrid.Create(Self, Viewport3D1,  18,11,  'terrain.bmp');
  Reserve0:= TTileGrid.Create(Self, Viewport3D1, 0, 11,1, DirAssets + 'terrain.bmp');
  Reserve1:= TTileGrid.Create(Self, Viewport3D1, 1, 11,1, DirAssets + 'terrain.bmp');
  Grid[0]:= Reserve0;
  Grid[1]:= Reserve1;
  Grid[2]:= Board;


  Board.SetBasePosition(0,0);
  //Board.SetRotationZ(0);         // verticale

  //CreateGround;

  FieldDrawer := TFieldDrawer.Create(Self, Viewport3D1, Board);
  FieldDrawer.DrawField;

  Reserve0.SetBasePosition(0, 12);  // centrata in verticale
  Reserve1.SetBasePosition(0, 11);

  CreateTestPlayers;

  Form1.WindowState := TWindowState.wsMaximized;
  GameScreen := gsFormation;
  MenuLayout.Visible := False;
  // Qui puoi inizializzare la griglia o altri oggetti 3D
  Viewport3D1.Visible := True;

  // Camera
  SetupCameraTopView;


  PlayerStatsPanel.Visible := True;
  PlayerStatsPanel.BuildFromPlayer(Players[0]);
end;
procedure TForm1.BtnNewGameClick(Sender: TObject);
var
  DBFile: string;
begin
  DBFile := DirSaves + 'Save0.sqlite';
 // SQLiteCreateSave(DBFile);
//  GenerateCalendar ( Conn1, Conn2, nomefile );
  InitGame;
end;

procedure TForm1.BtnLoadGameClick(Sender: TObject);
begin
  ShowMessage('Load Game clicked');
end;

procedure TForm1.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.CreateTestPlayers;
var
  i, row, col, Count: Integer;
  tile: TModelTile;
  Color: TAlphaColor;
  FTexture0, FTexture1, FTextureGK, FinalTexture: TTextureMaterialSource;
  BaseModel: TModel3D;
  AGridCell: TGridCell;
  S: ArrayStats;
  ABasePlayer: PlayerTemplate;
  TmpPlayer: TPlayer;
begin
// Carica il modello base UNA SOLA VOLTA
  BaseModel := TModel3D.Create(Self);
  BaseModel.LoadFromFile(DirAssets + 'player3.obj');
  BaseModel.Visible := False; // non mostrarlo nella scena
  BaseModel.Parent := Viewport3D1;


  // Crea materiale testurizzato
  FTextureGK := TTextureMaterialSource.Create(Self);
  FTextureGK.Parent := Viewport3D1;
  FTextureGK.Texture.LoadFromFile(DirAssets + 'mix2.bmp'); // nel caso di ca_deer

  FTexture0 := TTextureMaterialSource.Create(Self);
  FTexture0.Parent := Viewport3D1;
  FTexture0.Texture.LoadFromFile(DirAssets + 'mix2.bmp'); // nel caso di ca_deer

  FTexture1 := TTextureMaterialSource.Create(Self);
  FTexture1.Parent := Viewport3D1;
  FTexture1.Texture.LoadFromFile(DirAssets + 'MIX2.bmp'); // nel caso di ca_deer


  ModifyPixels(FTextureGK.Texture.Canvas.Bitmap, TAlphaColorRec.Red , TAlphaColorRec.Gray  , TAlphaColorRec.Blue, TAlphaColorRec.Gray ,TAlphaColorRec.Lime, TAlphaColorRec.Black );
  ModifyPixels(FTexture0.Texture.Canvas.Bitmap, TAlphaColorRec.Red , TAlphaColorRec.Red  , TAlphaColorRec.Blue, TAlphaColorRec.Blue ,TAlphaColorRec.Lime, TAlphaColorRec.White );

  for I := 0 to 21 do begin
    ABasePlayer := CreateRandomPlayer (Templates[I] ,0);

    //Genero un player temporaneo (senza ModelPlayer) per riempire la classe e passare gli array.
    TmpPlayer := TPlayer.Create ( Self, nil,
                                    nil, nil,
                                    0,
                                    0,
                                    I+1{Guid}, 0{Team}, 0{GuidTeam}, Templates[I].SeasonPlayed{Matchesplayed}, '', Templates[I].Surname ,ABasePlayer.Stat , ABasePlayer.Skills );

    if I < 10 then begin
      TmpPlayer.CellX := 0;
      TmpPlayer.CellY := I;
    end
    else if I > 10 then begin
      TmpPlayer.CellX := 17;
      TmpPlayer.CellY := I-11;
    end;

    If ( TmpPlayer.CellX = 0 ) and ( TmpPlayer.CellY = 5 ) then
      FinalTexture := FTextureGK
      else FinalTexture:= FTexture0;

    Players[I] :=  TPlayer.Create ( Self, Viewport3D1,
                                    BaseModel, FinalTexture,
                                    Board.FTiles[TmpPlayer.CellX, TmpPlayer.CellY].FPlane.Position.X,
                                    Board.FTiles[TmpPlayer.CellX, TmpPlayer.CellY].FPlane.Position.Y,
                                    TmpPlayer.FGuid , 0, 0{GuiTeam}, Templates[I].SeasonPlayed, '', ABasePlayer.Surname , ABasePlayer.Stat , ABasePlayer.Skills );

    Players[i].Country := RndGenerate(6);
    Players[I].FGridIndex := Grid[2].FGridIndex;
    Players[I].CellX := TmpPlayer.CellX;
    Players[I].CellY := TmpPlayer.CellY;


    TmpPlayer.Free; // libero il player temporaneo (quello senza FModel)

  end;


end;


procedure TForm1.CreateGround;
begin
  Ground := TPlane.Create(Self);
  Ground.Parent := Viewport3D1;
  Ground.Width := Board.FCols * Board.FTileSizeX + 10;
  Ground.Height := Board.FRows * Board.FTileSizeY + 10;
  Ground.Position.Point := Point3D((Board.FCols-1)*Board.FTileSizeX/2,
                                   (Board.FRows-1)*Board.FTileSizeY/2,
                                   -0.01); // leggermente sotto le celle
  Ground.MaterialSource := TTextureMaterialSource.Create(Self);
  TTextureMaterialSource(Ground.MaterialSource).Texture.LoadFromFile(DirAssets + 'panchina.bmp');
  Ground.HitTest := False;
end;


function TForm1.GetPlayerFromGrid ( GridIndex, CellX, CellY: integer): TPlayer;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to High(Players) do begin
    if ( Players[i].FGridIndex = GridIndex ) and (Players[i].CellX = CellX) and (Players[i].CellY = CellY) then begin
      Result := Players[i];
      Exit;
    end;
  end;

end;
procedure TForm1.SetupLayout;
var
  Lbl: TLabel;
  Spin: TSpinBox;

  I: Integer;
begin
  // Layout
  LayoutCam.Align := TAlignLayout.None;
  LayoutCam.Width := 200;
  LayoutCam.Height := 220;
  LayoutCam.Anchors := [];

  // Pulisce tutto
  LayoutCam.DeleteChildren;

  for I := 0 to 5 do
  begin
    Lbl := TLabel.Create(LayoutCam);
    Lbl.Parent := LayoutCam;
    Lbl.Text := CamNames[I];
    Lbl.Position.X := 10;
    Lbl.Position.Y := I * 35 + 10;

    Spin := TSpinBox.Create(LayoutCam);
    Spin.Parent := LayoutCam;
    Spin.Min := -1000;
    Spin.Max := 1000;
    Spin.Value := 0;
    Spin.Tag := I;
    Spin.Position.X := 70;
    Spin.Position.Y := I * 35 + 5;
    Spin.Width := 100;
    Spin.OnChange := SpinChange;
  end;

  LayoutCam.Visible := True;
end;
procedure TForm1.SpinChange(Sender: TObject);
var
  Spin: TSpinBox;
begin
  if not FormReady then Exit;

  Spin := Sender as TSpinBox;
  case Spin.Tag of
    0: Camera1.Position.X := Spin.Value;
    1: Camera1.Position.Y := Spin.Value;
    2: Camera1.Position.Z := Spin.Value;
    3: Camera1.RotationAngle.X := Spin.Value;
    4: Camera1.RotationAngle.Y := Spin.Value;
    5: Camera1.RotationAngle.Z := Spin.Value;
  end;
end;
procedure TForm1.SyncSpinsWithCamera;
var
  i: Integer;
begin
  for i := 0 to LayoutCam.ChildrenCount - 1 do
  begin
    if LayoutCam.Children[i] is TSpinBox then
      case TSpinBox(LayoutCam.Children[i]).Tag of
        0: TSpinBox(LayoutCam.Children[i]).Value := Camera1.Position.X;
        1: TSpinBox(LayoutCam.Children[i]).Value := Camera1.Position.Y;
        2: TSpinBox(LayoutCam.Children[i]).Value := Camera1.Position.Z;
        3: TSpinBox(LayoutCam.Children[i]).Value := Camera1.RotationAngle.X;
        4: TSpinBox(LayoutCam.Children[i]).Value := Camera1.RotationAngle.Y;
        5: TSpinBox(LayoutCam.Children[i]).Value := Camera1.RotationAngle.Z;
      end;
  end;
end;
end.


