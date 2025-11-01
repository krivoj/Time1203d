unit u_PlayerModel;

interface
uses
  System.SysUtils, System.Classes, System.UITypes, System.Types, System.Variants,
  FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Viewport3D, System.Math.Vectors, FMX.Controls3D , FMX.Objects3D,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.objects, FMX.materialSources ,FMX.OBJ.importer, u_SqlcreateSave, math,
  FMX.Types,u_tileGrid;

Type TGridCell = record
  GridIndex, CellX, CellY : Integer;
end;

type
  TPlayerModel = class
  private
  public
    FModel: TModel3D;
    FGridIndex: Integer;
    FLabel3D: TText3D;
    constructor Create(AOwner: TComponent; AViewport: TViewport3D;
                                         BaseModel: TModel3D;
                                         const ATexture: TTextureMaterialSource;
                                         InitX, InitY: Single);
    destructor Destroy; override;
    procedure SetPosition(X, Y, Z: Single);
  end;
implementation

constructor TPlayerModel.Create(AOwner: TComponent; AViewport: TViewport3D;
                                BaseModel: TModel3D;
                                const ATexture: TTextureMaterialSource;
                                InitX, InitY: Single);
var
  Mat: TColorMaterialSource;
  Mesh: TMesh;
begin
  // Duplica il modello già caricato
  FModel := TModel3D(BaseModel.Clone(AOwner));
  FModel.Parent := AViewport;
  FModel.Visible := True;
  FModel.HitTest := False;

  // Applica la texture a tutte le mesh
  for Mesh in FModel.MeshCollection do
    Mesh.MaterialSource := ATexture;

  // Impostazioni di base
  FModel.RotationAngle.X := 180;
  FModel.Scale.X := 1;
  FModel.Scale.Y := 1;
  FModel.Scale.Z := 1;

  SetPosition(InitX, InitY, 0.42);

  // 🔹 Etichetta 3D con il cognome
  FLabel3D := TText3D.Create(FModel);
  FLabel3D.Parent := FModel;  // figlia del modello → si muove con lui
  FLabel3D.HitTest := false;
  FLabel3D.Depth := 0.3;
  FLabel3D.Width := 3;
  FLabel3D.Height := 2;
  FLabel3D.Font.Size :=1;
  FLabel3D.Scale.Point := Point3D(0.27, 0.27, 0.27);
  FLabel3D.Position.Point := Point3D(0, 0, 0.42 );
  FLabel3D.MaterialSource := TColorMaterialSource.Create(AOwner);
  (FLabel3D.MaterialSource as TColorMaterialSource).Color := TAlphaColorRec.Silver;

end;

destructor TPlayerModel.Destroy;
begin
  if FModel <> nil then
    FModel.Free;  // liberando il modello, anche la label 3D viene liberata
  inherited;
end;

procedure TPlayerModel.SetPosition(X, Y, Z: Single);
begin
  FModel.Position.Point := Point3D(X, Y, Z);
end;


end.
