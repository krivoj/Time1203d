unit Unit1;
 { TODO :
Al posto di MatchesPlayed e matchesLeft usare SeasonPlayed e SeasonLeft o Remain
e vengono aggiornate alla fine di ogni stagione  in quanto season_match è 38 ma anche 30. }
interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Types, System.Variants,
  FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,u_TileGrid,u_FieldLines,
  FMX.Viewport3D, System.Math.Vectors, FMX.Controls3D , FMX.Objects3D,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.objects, FMX.materialSources ,FMX.OBJ.importer, u_SqlcreateSave, math,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FMX.Types3D,FireDAC.Phys.SQLite, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,u_SystemUtils,System.IOUtils,
  FMX.Types, u_playerModel, u_core, u_Types, u_PlayerTemplates, u_Traits;

Type TMouseStatus = (Ms_None, Ms_Waiting_For_Destination_Cell );

type
  TForm1 = class(TForm)
    Viewport3D1: TViewport3D;
    Camera1: TCamera;
    Layout1: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure Viewport3D1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure Viewport3D1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    { Private declarations }
    MenuLayout: TLayout;
    BtnNewGame, BtnLoadGame, BtnExit: TSpeedButton;
    procedure InitMenu;
    procedure InitGame;
    procedure RotateCameraLeft(Sender: TObject);
    procedure RotateCameraRight(Sender: TObject);
    procedure RotateCameraUp(Sender: TObject);
    procedure RotateCameraDown(Sender: TObject);
    procedure MoveCameraForward(Sender: TObject);
    procedure MoveCameraBackward(Sender: TObject);
    procedure BtnNewGameClick(Sender: TObject);
    procedure BtnLoadGameClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);  public
    { Public declarations }
    procedure SetupCameraTopView;
    procedure TileMouseDown(Sender:Tobject; Button: TMouseButton; CellX,CellY: integer);
    function GetPlayerFromGrid ( GridIndex, CellX, CellY: integer): TPlayer;

    procedure CreatePlayers;
    procedure CreateGround;
  public
    procedure InitCameraMoveControls;
    end;

var

  Form1: TForm1;
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
implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin

// Viewport3D a coprire tutta la form
  Viewport3D1.Align := TAlignLayout.Client;
  Viewport3D1.Visible := False;
  // Inizializza menu overlay
  InitMenu;

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
var
  AspectRatio: Single;
  GridWidth, GridHeight: Single;
  MaxDim: Single;
begin
  if not viewport3d1.Visible then exit;

  // dimensioni della griglia
  GridWidth := Board.FCols * Board.FTileSizeX;
  GridHeight := Board.FRows * Board.FTileSizeY;

  // rapporto viewport
  AspectRatio := Viewport3D1.Width / Viewport3D1.Height;

  // calcola la dimensione maggiore tra width e height per Z
  if GridWidth/AspectRatio > GridHeight then
    MaxDim := GridWidth/AspectRatio
  else
    MaxDim := GridHeight;

  Camera1.Position.Z := MaxDim;  // alza o abbassa la camera per adattare tutta la griglia
end;

procedure TForm1.SetupCameraTopView;
var
  TileLeft, TileRight: TModelTile;
  CenterX, CenterY: Single;
begin
  Camera1.Parent := Viewport3D1;

// Celle centrali
  TileLeft  := Board.FTiles[8, 5];
  TileRight := Board.FTiles[9, 5];

  // Calcolo posizione centrale tra le due celle
  //CenterY := (TileLeft.FPlane.Position.Y + TileRight.FPlane.Position.Y) / 2;
  //CenterX := TileLeft.FPlane.Position.X; // riga 5 è già quella giusta
  CenterX := (TileLeft.FPlane.Position.X + TileRight.FPlane.Position.X) / 2;
  CenterY := TileLeft.FPlane.Position.Y; // riga 5 è già quella giusta

  // Posizionamento camera
  Camera1.Target := nil;  // Target NIL se usiamo RotationAngle
  Camera1.Position.X := CenterX;
  Camera1.Position.Y := CenterY-3;
  Camera1.Position.Z := 16.7;

  Camera1.RotationAngle.X := -170;  // Vista dall'alto  180 per centrare dall'alto
 // Camera1.RotationAngle.Z := -90;  // Campo ruotato orizzontalmenteend;
end;
procedure TForm1.TileMouseDown(Sender: TObject; Button: TMouseButton; CellX,CellY: integer);
var
  aPlayer: TPlayer;
  label f1;
begin
  if (Button = TMouseButton.mbLeft) and ( MouseStatus= Ms_None) then begin
    SelectedPlayer := GetPlayerFromGrid ( TPlane(Sender).Tag, CellX, CellY);
    if SelectedPlayer = nil then exit;

    StartTilePos := Point ( CellX, CellY );
    StartPoint3DPos :=  SelectedPlayer.FPlayerModel.FModel.Position.Point;
    MouseStatus := Ms_Waiting_For_Destination_Cell;
    //if not SelectedPlayer.HasTrait[TRAIT_GOALKEEPER) then
      Grid[2].HighlightFormationsCols;
    //else Grid[2].HighlightCell(0,5);
  end
  else if (Button = TMouseButton.mbLeft) and ( MouseStatus= Ms_Waiting_For_Destination_Cell) then begin
    if SelectedPlayer <> nil then begin
    // FIndex indica su quale grid abbiamo cliccato. CellX e CellY  la cella su cui abbiamo cliccato.
      if not CheckFormationPosition ( SelectedPlayer, CellX, CellY ) then goto f1;
        // Cerca un TPlayerModel sopra
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
        SelectedPlayer := nil;
        MouseStatus := ms_None;
        Grid[2].ClearHighLights;

    end;
  end;
  //  ShowMessage(Format('Hai cliccato DOWN la cella Col=%d Row=%d', [CellX, CellY]));
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

  MenuLayout.Visible := False;
  // Qui puoi inizializzare la griglia o altri oggetti 3D
  Viewport3D1.Visible := True;

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
  InitCameraMoveControls;

  Board.SetBasePosition(-9, -5.5); // esempio per centrare 18x11 celle di 1 unit

  //Grid := TTileGrid.Create(Self, Viewport3D1,  18,11,  'terrain.bmp');
  Reserve0:= TTileGrid.Create(Self, Viewport3D1, 0, 1,11, 'terrain.bmp');
  Reserve1:= TTileGrid.Create(Self, Viewport3D1, 1, 1,11, 'terrain.bmp');
  Grid[0]:= Reserve0;
  Grid[0].FGridIndex := 0;
  Grid[1]:= Reserve1;
  Grid[1].FGridIndex := 1;
  Grid[2]:= Board;
  Grid[2].FGridIndex := 2;



  Board.SetBasePosition(0,0);
  Board.SetRotationZ(0);         // verticale

  CreateGround;

  FieldDrawer := TFieldDrawer.Create(Self, Viewport3D1, Board);
  FieldDrawer.DrawField;

  // Griglia di riserva sinistra (11x1)

  Reserve0.SetBasePosition(-1, 0);  // centrata in verticale
  Reserve0.SetRotationZ(0);         // verticale

  // Griglia di riserva destra (11x1)
  Reserve1.SetBasePosition(18, 0);
  Reserve1.SetRotationZ(0);        // verticale speculare
  CreatePlayers;

  Form1.WindowState := TWindowState.wsMaximized;
  // Camera
  SetupCameraTopView;
  //SetupFieldLights;

end;
procedure TForm1.BtnNewGameClick(Sender: TObject);
var
  DBFile: string;
begin
  DBFile := GetLocalAppDataPath;
  ForceDirectories(DBFile + '\Time120\');
  DBFile := GetLocalAppDataPath + '\Time120\Save0.sqlite';
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

procedure TForm1.CreatePlayers;
var
  i, row, col, Count: Integer;
  tile: TModelTile;
  Color: TAlphaColor;
  FTexture0, FTexture1, FTextureGK, FinalTexture: TTextureMaterialSource;
  BaseModel: TModel3D;
  AGridCell: TGridCell;
  S: ArrayStats;
  T: ArrayTraits;
  ABasePlayer: PlayerTemplate;
  TmpPlayer: TPlayer;
begin
// Carica il modello base UNA SOLA VOLTA
  BaseModel := TModel3D.Create(Self);
  BaseModel.LoadFromFile('player3.obj');
  BaseModel.Visible := False; // non mostrarlo nella scena
  BaseModel.Parent := Viewport3D1;


  // Crea materiale testurizzato
  FTextureGK := TTextureMaterialSource.Create(Self);
  FTextureGK.Parent := Viewport3D1;
  FTextureGK.Texture.LoadFromFile('mix2.bmp'); // nel caso di ca_deer

  FTexture0 := TTextureMaterialSource.Create(Self);
  FTexture0.Parent := Viewport3D1;
  FTexture0.Texture.LoadFromFile('mix2.bmp'); // nel caso di ca_deer

  FTexture1 := TTextureMaterialSource.Create(Self);
  FTexture1.Parent := Viewport3D1;
  FTexture1.Texture.LoadFromFile('MIX2.bmp'); // nel caso di ca_deer


  ModifyPixels(FTextureGK.Texture.Canvas.Bitmap, TAlphaColorRec.Red , TAlphaColorRec.Gray  , TAlphaColorRec.Blue, TAlphaColorRec.Gray ,TAlphaColorRec.Lime, TAlphaColorRec.Black );
  ModifyPixels(FTexture0.Texture.Canvas.Bitmap, TAlphaColorRec.Red , TAlphaColorRec.Red  , TAlphaColorRec.Blue, TAlphaColorRec.Blue ,TAlphaColorRec.Lime, TAlphaColorRec.White );

  for I := 0 to 21 do begin
    ABasePlayer := CreateRandomPlayer (Templates[I] ,0);

    //Genero un player temporaneo (senza ModelPlayer) per riempire la classe e passare gli array.
    TmpPlayer := TPlayer.Create ( Self, nil,
                                    nil, nil,
                                    0,
                                    0,
                                    I+1{Guid}, 0{Team}, 0{GuidTeam}, Templates[I].MatchesPlayed{Matchesplayed}, '', Templates[I].Surname ,ABasePlayer.DefaultStat , ABasePlayer.Traits );

    if I < 10 then begin
      TmpPlayer.CellX := 0;
      TmpPlayer.CellY := I;
    end
    else if I > 10 then begin
      TmpPlayer.CellX := 17;
      TmpPlayer.CellY := I-11;
    end;

    if TmpPlayer.HasTrait (TRAIT_GOALKEEPER) then
      FinalTexture := FTextureGK
      else FinalTexture:= FTexture0;

    Players[I] :=  TPlayer.Create ( Self, Viewport3D1,
                                    BaseModel, FinalTexture,
                                    Board.FTiles[TmpPlayer.CellX, TmpPlayer.CellY].FPlane.Position.X,
                                    Board.FTiles[TmpPlayer.CellX, TmpPlayer.CellY].FPlane.Position.Y,
                                    TmpPlayer.FGuid , 0, 0{GuiTeam}, Templates[I].MatchesPlayed, '', ABasePlayer.Surname , ABasePlayer.DefaultStat , ABasePlayer.Traits );

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
  TTextureMaterialSource(Ground.MaterialSource).Texture.LoadFromFile('panchina.bmp');
  Ground.HitTest := False;
end;
procedure TForm1.InitCameraMoveControls;
var
  LayoutCam: TLayout;
  BtnLeft, BtnRight, BtnUp, BtnDown, BtnForward, BtnBackward: TSpeedButton;
begin
  // Layout per i pulsanti della camera
  LayoutCam := TLayout.Create(Self);
  LayoutCam.Parent := Self;
  LayoutCam.Align := TAlignLayout.Bottom;
  LayoutCam.Height := 80;

  // --- Ruota a sinistra (Z -5°)
  BtnLeft := TSpeedButton.Create(LayoutCam);
  BtnLeft.Parent := LayoutCam;
  BtnLeft.Text := '<';
  BtnLeft.Position.X := 10;
  BtnLeft.Position.Y := 10;
  BtnLeft.Width := 60;
  BtnLeft.Height := 40;
  BtnLeft.OnClick := RotateCameraLeft;

  // --- Ruota a destra (Z +5°)
  BtnRight := TSpeedButton.Create(LayoutCam);
  BtnRight.Parent := LayoutCam;
  BtnRight.Text := '>';
  BtnRight.Position.X := 80;
  BtnRight.Position.Y := 10;
  BtnRight.Width := 60;
  BtnRight.Height := 40;
  BtnRight.OnClick := RotateCameraRight;

  // --- Ruota su (X -5°)
  BtnUp := TSpeedButton.Create(LayoutCam);
  BtnUp.Parent := LayoutCam;
  BtnUp.Text := '↑';
  BtnUp.Position.X := 150;
  BtnUp.Position.Y := 10;
  BtnUp.Width := 60;
  BtnUp.Height := 40;
  BtnUp.OnClick := RotateCameraUp;

  // --- Ruota giù (X +5°)
  BtnDown := TSpeedButton.Create(LayoutCam);
  BtnDown.Parent := LayoutCam;
  BtnDown.Text := '↓';
  BtnDown.Position.X := 220;
  BtnDown.Position.Y := 10;
  BtnDown.Width := 60;
  BtnDown.Height := 40;
  BtnDown.OnClick := RotateCameraDown;

  // --- Sposta in avanti (X positivo)
  BtnForward := TSpeedButton.Create(LayoutCam);
  BtnForward.Parent := LayoutCam;
  BtnForward.Text := '>>';
  BtnForward.Position.X := 290;
  BtnForward.Position.Y := 10;
  BtnForward.Width := 60;
  BtnForward.Height := 40;
  BtnForward.OnClick := MoveCameraForward;

  // --- Sposta indietro (X negativo)
  BtnBackward := TSpeedButton.Create(LayoutCam);
  BtnBackward.Parent := LayoutCam;
  BtnBackward.Text := '<<';
  BtnBackward.Position.X := 360;
  BtnBackward.Position.Y := 10;
  BtnBackward.Width := 60;
  BtnBackward.Height := 40;
  BtnBackward.OnClick := MoveCameraBackward;
end;

procedure TForm1.RotateCameraLeft(Sender: TObject);
begin
  Camera1.RotationAngle.Z := Camera1.RotationAngle.Z - 5;
end;

procedure TForm1.RotateCameraRight(Sender: TObject);
begin
  Camera1.RotationAngle.Z := Camera1.RotationAngle.Z + 5;
end;

procedure TForm1.RotateCameraUp(Sender: TObject);
begin
  Camera1.RotationAngle.X := Camera1.RotationAngle.X - 5;
end;

procedure TForm1.RotateCameraDown(Sender: TObject);
begin
  Camera1.RotationAngle.X := Camera1.RotationAngle.X + 5;
end;
procedure TForm1.MoveCameraForward(Sender: TObject);
begin
  Camera1.Position.X := Camera1.Position.X + Board.FTileSizeX;
  // sposta di 1 cella in avanti
end;

procedure TForm1.MoveCameraBackward(Sender: TObject);
begin
  Camera1.Position.X := Camera1.Position.X - Board.FTileSizeX;
  // sposta di 1 cella indietro
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


end.

{Hai detto:


procedure TForm1.FormCreate(Sender: TObject);
begin

PlayerStatsPanel := TPlayerStatsPanel.Create(Self, DirBmp);
PlayerStatsPanel.Parent := LayoutMain;  // o dove lo vuoi mettere
PlayerStatsPanel.Visible := False;
end;

procedure TForm1.ShowPlayerStats(Player: TPlayer);
begin
  PlayerStats.BuildFromPlayer(Player);
  PlayerStats.Visible := True;
end;

procedure TForm1.HidePlayerStats;
begin
  PlayerStats.Visible := False;
end;}

