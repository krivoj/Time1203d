unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,uTileGrid,uFieldLines,
  FMX.Viewport3D, System.Math.Vectors, FMX.Controls3D , FMX.Objects3D,FMX.Types3D,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.objects, FMX.materialSources ,FMX.OBJ.importer, u_SqlcreateSave, math,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,u_SystemUtils,System.IOUtils;

type
  TForm1 = class(TForm)
    Viewport3D1: TViewport3D;
    Camera1: TCamera;
    Layout1: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure Viewport3D1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure Viewport3D1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
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
    procedure SetupFieldLights;
    procedure TileMouseDown(Sender:Tobject ; CellX,CellY: integer);
    procedure TileMouseUp(Sender:Tobject ; CellX,CellY: integer);
    function GetPlayerModelFromBoard ( CellX, CellY: integer): TModel3D;

    procedure CreatePlayers;
    procedure CreateGround;
  public
    procedure InitCameraMoveControls;
    end;
type
  TPlayerModel = class
  private
    FModel: TModel3D;
    FCellX: Integer;
    FCellY: Integer;
  public
    constructor Create(AOwner: TComponent; AViewport: TViewport3D;
                       const ObjPath: string; const ATexture: TTextureMaterialSource;
                       InitX, InitY: Single);
    constructor CreateFromClone(AOwner: TComponent; AViewport: TViewport3D;
                                         BaseModel: TModel3D;
                                         const ATexture: TTextureMaterialSource;
                                         InitX, InitY: Single);
    procedure SetPosition(X, Y, Z: Single);
    procedure Free;
    property CellX: integer read FCellX write FCellX;
    property CellY: integer read FCellY write FCellY;
  end;

var

  Form1: TForm1;
  BtnExit,BtnNewGame,BtnLoadGame: TButton;
  Grid: TTileGrid;
  Reserve : Array[0..1] of TTileGrid;
  DraggingPlayer: TModel3D;
  StartMouse: TPointF;
  StartTilePos: TPoint3D;
  Players: array[0..21] of TPlayerModel;
  i, row, col: Integer;
  tile: TModelTile;
  Mat: TTextureMaterialSource ;
  Ground: TPlane;
implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
var
  i,j: integer;
begin

// Viewport3D a coprire tutta la form
  Viewport3D1.Align := TAlignLayout.Client;
  Viewport3D1.Visible := False;
  // Inizializza menu overlay
  InitMenu;

end;

procedure TForm1.Viewport3D1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
var
  Delta: TPointF;
begin
  if (DraggingPlayer <> nil ) and ( ssLeft in Shift) then
  begin
    Delta := Screen.MousePos - StartMouse;

    // movimento semplice in X-Y (piano vista dall'alto)
    DraggingPlayer.Position.X := StartTilePos.X + Delta.X * 0.02;
    DraggingPlayer.Position.Y := StartTilePos.Y + Delta.Y * 0.02;
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
  GridWidth := Grid.FCols * Grid.FTileSizeX;
  GridHeight := Grid.FRows * Grid.FTileSizeY;

  // rapporto viewport
  AspectRatio := Viewport3D1.Width / Viewport3D1.Height;

  // calcola la dimensione maggiore tra width e height per Z
  if GridWidth/AspectRatio > GridHeight then
    MaxDim := GridWidth/AspectRatio
  else
    MaxDim := GridHeight;

  Camera1.Position.Z := MaxDim;  // alza o abbassa la camera per adattare tutta la griglia
end;
procedure TForm1.SetupFieldLights;
var
  SunLight: TLight;
  i, X, Y, XMax, YMax: Integer;
  Positions: array[0..3] of TPoint3D;
  SpotPlane: TPlane;
  LightMat, TileMat: TLightMaterialSource;
  Tile: TModelTile;
  Obj: TFmxObject;
  Mesh: TMesh;
  Plane: TPlane;
  OffsetY: Single;
begin
  XMax := Grid.FCols - 1;
  YMax := Grid.FRows - 1;
  OffsetY := Grid.FTileDepth / 2 + 0.5; // rialzo leggero per i fari

  // ==== MATERIALI CELLE ====
  TileMat := TLightMaterialSource.Create(Self);
  TileMat.Parent := Self;
  TileMat.Diffuse := TAlphaColorRec.Green;
  TileMat.Specular := TAlphaColorRec.White;
  TileMat.Shininess := 150;

  for Y := 0 to YMax do
    for X := 0 to XMax do
    begin
      Tile := Grid.FTiles[X, Y];
      Tile.FPlane.MaterialSource := TileMat;
    end;

  // ==== ASSEGNA IL MATERIALE A TUTTI I MESH E PIANI DELLA VIEWPORT ====
  for i := 0 to Viewport3D1.ChildrenCount - 1 do
  begin
    Obj := Viewport3D1.Children[i];
    if Obj is TMesh then
    begin
      Mesh := TMesh(Obj);
      Mesh.MaterialSource := TileMat;
    end
    else if Obj is TPlane then
    begin
      Plane := TPlane(Obj);
      Plane.MaterialSource := TileMat;
    end;
  end;

  // ==== LUCE SOLARE DIREZIONALE ====
  SunLight := TLight.Create(Viewport3D1);
  SunLight.Parent := Viewport3D1;
  SunLight.LightType := TLightType.Directional;
  SunLight.Position.Point := Camera1.Position.Point;
  SunLight.RotationAngle := Camera1.RotationAngle;
  SunLight.RotationCenter.Point := Point3D(0,0,0);
  SunLight.Color := TAlphaColorF.Create(1.0,0.98,0.9,1).ToAlphaColor;
  SunLight.Name := 'SunLight';

  // ==== POSIZIONI FARI (angoli griglia) ====
  Positions[0] := Point3D(Grid.FTiles[0,0].FPlane.Position.X, OffsetY, Grid.FTiles[0,0].FPlane.Position.Y);
  Positions[1] := Point3D(Grid.FTiles[XMax,0].FPlane.Position.X, OffsetY, Grid.FTiles[XMax,0].FPlane.Position.Y);
  Positions[2] := Point3D(Grid.FTiles[0,YMax].FPlane.Position.X, OffsetY, Grid.FTiles[0,YMax].FPlane.Position.Y);
  Positions[3] := Point3D(Grid.FTiles[XMax,YMax].FPlane.Position.X, OffsetY, Grid.FTiles[XMax,YMax].FPlane.Position.Y);

  // ==== CREAZIONE PIANI SEMITRASPARENTI PER FARI ====
  for i := 0 to 3 do
  begin
    SpotPlane := TPlane.Create(Viewport3D1);
    SpotPlane.Parent := Viewport3D1;
    SpotPlane.Width := 20;
    SpotPlane.Height := 20;
    SpotPlane.Position.Point := Positions[i];
    SpotPlane.RotationAngle.X := -90;

    LightMat := TLightMaterialSource.Create(Self);
    LightMat.Parent := Self;
    LightMat.Diffuse := TAlphaColorF.Create(1,1,0.8,0.3).ToAlphaColor;
    LightMat.Specular := TAlphaColorRec.White;
    LightMat.Shininess := 150;

    SpotPlane.MaterialSource := LightMat;
  end;
end;

procedure TForm1.SetupCameraTopView;
var
  TileLeft, TileRight: TModelTile;
  CenterX, CenterY: Single;
begin
  Camera1.Parent := Viewport3D1;

// Celle centrali
  TileLeft  := Grid.FTiles[8, 5];
  TileRight := Grid.FTiles[9, 5];

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
procedure TForm1.TileMouseDown(Sender: TObject; CellX,CellY: integer);
begin
  //DraggingPLayer := Grid.FTiles[CellX, CellY]; // memorizzo la tile
  DraggingPLayer := GetPlayerModelFromBoard (CellX, CellY);
  StartMouse := Screen.MousePos;        // posizione iniziale mouse
  StartTilePos := DraggingPLayer.Position.Point; // posizione iniziale tile
//  ShowMessage(Format('Hai cliccato DOWN la cella Col=%d Row=%d', [CellX, CellY]));
end;
procedure TForm1.TileMouseUp(Sender: TObject; CellX,CellY: integer);
var
  TargetTile: TModelTile;
begin

  //ShowMessage(Format('Hai cliccato UP la cella Col=%d Row=%d', [CellX, CellY]));

  if DraggingPLayer <> nil then
  begin
    // Trova la cella su cui abbiamo rilasciato

      // Allinea la posizione alla cella di destinazione
      DraggingPLayer.Position.X := TPlane(Sender).Position.X;
      DraggingPLayer.Position.Y := TPlane(Sender).Position.Y;
      // se non hai rilasciato sopra nessuna cella, torna alla posizione iniziale
//      DraggingTile.FPlane.Position.Point := StartTilePos;

    // riporta a Z = 0
    DraggingPLayer.Position.Z := 0.42;
    DraggingPLayer := nil;
  end;

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
  Grid := TTileGrid.Create(Self, Viewport3D1, 18, 11, FieldBitmap);

  // 3️⃣ Posiziono la griglia (opzionale)
  Grid.SetBasePosition(-9, -5.5);

  // 4️⃣ Libero bitmap manualmente (materiale già l’ha copiata)
  FieldBitmap.Free;
  InitCameraMoveControls;

  Grid.SetBasePosition(-9, -5.5); // esempio per centrare 18x11 celle di 1 unit
  
  //Grid := TTileGrid.Create(Self, Viewport3D1,  18,11,  'terrain.bmp');
  Reserve[0]:= TTileGrid.Create(Self, Viewport3D1, 1,11, 'terrain.bmp');
  Reserve[1]:= TTileGrid.Create(Self, Viewport3D1, 1,11, 'terrain.bmp');
  Grid.SetBasePosition(0,0);
  Grid.SetRotationZ(0);         // verticale
  CreateGround;

  FieldDrawer := TFieldDrawer.Create(Self, Viewport3D1, Grid);
  FieldDrawer.DrawField;

  // Griglia di riserva sinistra (11x1)

  Reserve[0].SetBasePosition(-1, 0);  // centrata in verticale
  Reserve[0].SetRotationZ(0);         // verticale

  // Griglia di riserva destra (11x1)
  Reserve[1].SetBasePosition(18, 0);
  Reserve[1].SetRotationZ(0);        // verticale speculare
  CreatePlayers;

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
  FTexture0, FTexture1: TTextureMaterialSource;
  BaseModel: TModel3D;
begin
// Carica il modello base UNA SOLA VOLTA
  BaseModel := TModel3D.Create(Self);
  BaseModel.LoadFromFile('player3.obj');
  BaseModel.Visible := False; // non mostrarlo nella scena
  BaseModel.Parent := Viewport3D1;

// ROSSI
// Crea materiale testurizzato
  FTexture0 := TTextureMaterialSource.Create(Self);
  FTexture0.Parent := Viewport3D1;
  //FTexture.Texture.LoadFromFile('texture_diffuse.bmp'); // nel caso di ca_deer
  //FTexture0.Texture.LoadFromFile('mix.bmp'); // nel caso di ca_deer
  FTexture0.Texture.LoadFromFile('mix2.bmp'); // nel caso di ca_deer


  ModifyPixels(FTexture0.Texture.Canvas.Bitmap, TAlphaColorRec.Blue , TAlphaColorRec.Yellow  , TAlphaColorRec.Blue, TAlphaColorRec.Yellow ,TAlphaColorRec.red, TAlphaColorRec.Aqua );

  for I := 0 to 10 do begin
    Players[I] := TPlayerModel.CreateFromClone(Self, Viewport3D1,
                                      BaseModel, FTexture0,
                                      Grid.FTiles[0, I].FPlane.Position.X,
                                      Grid.FTiles[0, I].FPlane.Position.Y );
    Players[I].CellX := 0;
    Players[I].CellY := I;
  end;

  // BLU
// Crea materiale testurizzato
  FTexture1 := TTextureMaterialSource.Create(Self);
  FTexture1.Parent := Viewport3D1;
  FTexture1.Texture.LoadFromFile('MIX2.bmp'); // nel caso di ca_deer
  ModifyPixels(FTexture1.Texture.Canvas.Bitmap, TAlphaColorRec.Blue , TAlphaColorRec.Yellow  , TAlphaColorRec.Blue, TAlphaColorRec.Yellow ,TAlphaColorRec.red, TAlphaColorRec.Aqua );
  for I := 0 to 10 do begin
    Players[I+11] := TPlayerModel.CreateFromClone(Self, Viewport3D1,
                                         BaseModel, FTexture1,
                                         Grid.FTiles[17, I].FPlane.Position.X,
                                         Grid.FTiles[17, I].FPlane.Position.Y);

    Players[I].CellX := 0;
    Players[I].CellY := I;
  end;


  Players[3].SetPosition(Grid.FTiles[15, 4].FPlane.Position.Point.X, Grid.FTiles[15, 4].FPlane.Position.Point.Y, 0.42);


end;
constructor TPlayerModel.Create(AOwner: TComponent; AViewport: TViewport3D;
                                const ObjPath: string; const ATexture: TTextureMaterialSource;
                                InitX, InitY: Single);
var
  Mat: TColorMaterialSource;
  Mesh: TMesh;
begin
  // Crea il contenitore del modello
  FModel := TModel3D.Create(AOwner);
  FModel.Parent := AViewport;

  // Carica il file OBJ
  FModel.LoadFromFile(ObjPath);

  for Mesh in FModel.MeshCollection do
    Mesh.MaterialSource := ATexture;

  FModel.RotationAngle.X := 180;

  // Scala il modello (puoi regolare)
  FModel.Scale.X := 1;
  FModel.Scale.Y := 1;
  FModel.Scale.Z := 1;

  // Posiziona inizialmente sopra la tile
  SetPosition(InitX, InitY, 0);
end;
constructor TPlayerModel.CreateFromClone(AOwner: TComponent; AViewport: TViewport3D;
                                         BaseModel: TModel3D;
                                         const ATexture: TTextureMaterialSource;
                                         InitX, InitY: Single);
var
  Mesh: TMesh;
begin
  // Duplica il modello già caricato
  FModel := TModel3D(BaseModel.Clone(AOwner));
  FModel.Parent := AViewport;
  FModel.Visible := True;

  // Applica la texture a tutte le mesh
  for Mesh in FModel.MeshCollection do
    Mesh.MaterialSource := ATexture;

  // Impostazioni di base
  FModel.RotationAngle.X := 180;
  FModel.Scale.X := 1;
  FModel.Scale.Y := 1;
  FModel.Scale.Z := 1;

  SetPosition(InitX, InitY, 0.42);
end;


procedure TPlayerModel.Free;
begin
  if FModel <> nil then
    FModel.free;
end;

procedure TPlayerModel.SetPosition(X, Y, Z: Single);
begin
  FModel.Position.Point := Point3D(X, Y, Z);
end;
procedure TForm1.CreateGround;
begin
  Ground := TPlane.Create(Self);
  Ground.Parent := Viewport3D1;
  Ground.Width := Grid.FCols * Grid.FTileSizeX + 10;
  Ground.Height := Grid.FRows * Grid.FTileSizeY + 10;
  Ground.Position.Point := Point3D((Grid.FCols-1)*Grid.FTileSizeX/2,
                                   (Grid.FRows-1)*Grid.FTileSizeY/2,
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
  Camera1.Position.X := Camera1.Position.X + Grid.FTileSizeX;
  // sposta di 1 cella in avanti
end;

procedure TForm1.MoveCameraBackward(Sender: TObject);
begin
  Camera1.Position.X := Camera1.Position.X - Grid.FTileSizeX;
  // sposta di 1 cella indietro
end;

function TForm1.GetPlayerModelFromBoard ( CellX, CellY: integer): TModel3D;
var
  i: integer;
begin
  for i := 0 to High(Players) do begin
    if (Players[i].CellX = CellX) and (Players[i].CellY = CellY)  then begin
      Result := Players[i].FModel;
      Exit;
    end;
  end;

end;


end.

{Hai detto:
vvar
  FieldPlane: TRectangle3D; // o TPlane3D se hai FMX 3D avanzato
begin
  FieldPlane := TRectangle3D.Create(Self);
  FieldPlane.Width := FieldWidth;
  FieldPlane.Height := FieldHeight;
  FieldPlane.MaterialSource := FieldMaterial; // bitmap del campo
  FieldPlane.Position.Z := -0.1; // leggermente sotto la griglia
  Viewport3D1.AddObject(FieldPlane);
end;



TileWidth := FieldWidth / 18;
TileHeight := FieldHeight / 11;
procedure HighlightCell(X, Y: Integer; Color: TAlphaColor);
var
  HighlightPlane: TRectangle3D;
begin
  HighlightPlane := TRectangle3D.Create(Self);
  HighlightPlane.Width := TileWidth;
  HighlightPlane.Height := TileHeight;
  HighlightPlane.Position.X := X * TileWidth + TileWidth/2;
  HighlightPlane.Position.Y := Y * TileHeight + TileHeight/2;
  HighlightPlane.Position.Z := 0.1; // leggermente sopra il piano del campo
  HighlightPlane.MaterialSource := TColorMaterialSource.Create(Self);
  TColorMaterialSource(HighlightPlane.MaterialSource).Color := Color;
  HighlightPlane.Opacity := 0.5; // trasparente
  Viewport3D1.AddObject(HighlightPlane);
end;

procedure ClearHighlights;
var
  i: Integer;
begin
  for i := 0 to HighlightPlanes.Count-1 do
    HighlightPlanes[i].Free;
  HighlightPlanes.Clear;
end;


