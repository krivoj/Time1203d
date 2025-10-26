unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,uTileGrid,uFieldLines,
  FMX.Viewport3D, System.Math.Vectors, FMX.Controls3D , FMX.Objects3D,FMX.Types3D,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.objects, FMX.materialSources ,FMX.OBJ.importer, u_SqlcreateSave,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client ;

type
  TForm1 = class(TForm)
    Viewport3D1: TViewport3D;
    Camera1: TCamera;
    Layout1: TLayout;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDConnection1: TFDConnection;
    procedure FormCreate(Sender: TObject);
    procedure Viewport3D1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure Viewport3D1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure Viewport3D1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    { Private declarations }
  MenuLayout: TLayout;
    BtnNewGame, BtnLoadGame, BtnExit: TSpeedButton;
    procedure InitMenu;
    procedure InitGame;
    procedure BtnNewGameClick(Sender: TObject);
    procedure BtnLoadGameClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);  public
    { Public declarations }
    procedure SetupCameraTopView;
    procedure TileMouseDown(Sender:Tobject ; CellX,CellY: integer);
    procedure CreatePlayers;
    procedure CreateGround;
end;
type
  TPlayerModel = class
  private
    FModel: TModel3D;
  public
    constructor Create(AOwner: TComponent; AViewport: TViewport3D;
                       const ObjPath: string; const AColor: TAlphaColor;
                       InitX, InitY: Single);
    procedure SetPosition(X, Y, Z: Single);
    procedure Free;
  end;

var

  Form1: TForm1;
  BtnExit,BtnNewGame,BtnLoadGame: TButton;
  Grid: TTileGrid;
  Reserve : Array[0..1] of TTileGrid;
  DraggingTile: TModelTile;
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
  if (DraggingTile <> nil) and (ssLeft in Shift) then
  begin
    Delta := Screen.MousePos - StartMouse;

    // movimento semplice in X-Y (piano vista dall'alto)
    DraggingTile.FPlane.Position.X := StartTilePos.X + Delta.X * 0.02;
    DraggingTile.FPlane.Position.Y := StartTilePos.Y + Delta.Y * 0.02;
  end;
end;
procedure TForm1.Viewport3D1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
DraggingTile := nil;
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
  Camera1.Position.Y := CenterY;
  Camera1.Position.Z := 16.7;

  Camera1.RotationAngle.X := 180;  // Vista dall'alto
 // Camera1.RotationAngle.Z := -90;  // Campo ruotato orizzontalmenteend;
end;
procedure TForm1.TileMouseDown(Sender: TObject; CellX,CellY: integer);
begin

  //DraggingTile := Grid.FTiles[CellX, CellY]; // memorizzo la tile
  //StartMouse := Screen.MousePos;        // posizione iniziale mouse
  //StartTilePos := DraggingTile.FPlane.Position.Point; // posizione iniziale tile
  ShowMessage(Format('Hai cliccato la cella Col=%d Row=%d', [CellX, CellY]));
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
begin
  // Nascondi menu

  MenuLayout.Visible := False;
  // Qui puoi inizializzare la griglia o altri oggetti 3D
  Viewport3D1.Visible := True;
  Grid := TTileGrid.Create(Self, Viewport3D1,  18,11,  'terrain.bmp');
  Reserve[0]:= TTileGrid.Create(Self, Viewport3D1, 1,11, 'panchina.bmp');
  Reserve[1]:= TTileGrid.Create(Self, Viewport3D1, 1,11, 'panchina.bmp');
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
  SQLiteCreateSave ('d:\prova.db');
end;
procedure TForm1.BtnNewGameClick(Sender: TObject);
begin
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
begin

// ROSSI
  for I := 0 to 10 do
    Players[I] := TPlayerModel.Create(Self, Viewport3D1,
                                      'untitled.obj', TAlphaColorRec.Red,
                                      Grid.FTiles[0, I].FPlane.Position.X,
                                      Grid.FTiles[0, I].FPlane.Position.Y);

  // BLU
  for I := 0 to 10 do
    Players[I+11] := TPlayerModel.Create(Self, Viewport3D1,
                                         'untitled.obj', TAlphaColorRec.Blue,
                                         Grid.FTiles[17, I].FPlane.Position.X,
                                         Grid.FTiles[17, I].FPlane.Position.Y);

end;
constructor TPlayerModel.Create(AOwner: TComponent; AViewport: TViewport3D;
                                const ObjPath: string; const AColor: TAlphaColor;
                                InitX, InitY: Single);
var
  Mat: TColorMaterialSource;
  Mesh: TMesh;
  FTexture : TTextureMaterialSource;
begin
  // Crea il contenitore del modello
  FModel := TModel3D.Create(AOwner);
  FModel.Parent := AViewport;

  // Carica il file OBJ
  FModel.LoadFromFile(ObjPath);

  // Crea un materiale colore
 { Mat := TColorMaterialSource.Create(AOwner);
  Mat.Parent := FModel; //AViewport;
  Mat.Color := AColor;

  // Applica il materiale a tutte le mesh
  for Mesh in FModel.MeshCollection do
    Mesh.MaterialSource := Mat;  }


// Crea materiale testurizzato
  FTexture := TTextureMaterialSource.Create(AOwner);
  FTexture.Parent := AViewport;
  FTexture.Texture.LoadFromFile('texture_diffuse.bmp');
  for Mesh in FModel.MeshCollection do
    Mesh.MaterialSource := FTexture;

  // Scala il modello (puoi regolare)
  FModel.Scale.X := 1;
  FModel.Scale.Y := 1;
  FModel.Scale.Z := 1;

  // Posiziona inizialmente sopra la tile
  SetPosition(InitX, InitY, 0.5);
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

end.
