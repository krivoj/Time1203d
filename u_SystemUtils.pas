unit u_SystemUtils;

interface
uses
  Winapi.Windows, Winapi.ShLwApi, System.SysUtils, SHlObj, FMX.Graphics, System.UITypes, u_Types, u_Random, u_RandomHelper, StrUtils;

function GetLocalAppDataPath: string;
Function Capitalize ( aString : string  ): String;
procedure ModifyPixels(const Bitmap: TBitmap; Color1From, Color1To,Color2From, Color2To,Color3From, Color3To: TAlphaColor );
function MirrorCell(const P: TPoint): TPoint;
procedure FillTeamCells ( var TeamCells: ArrayCells );
implementation
var
  Path: array[0..MAX_PATH] of Char;

function GetLocalAppDataPath: string;
begin
  if SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, 0, @Path[0]) = S_OK then
    Result := Path
  else
    Result := '';
end;

Function Capitalize ( aString : string  ): String;
begin
   if Length ( astring ) > 0 then
    Result :=  UPPERCASE (aString[1]) + RightStr ( aString , Length ( aString ) -1 )
    else
      result := '';

end;

procedure ModifyPixels(const Bitmap: TBitmap; Color1From, Color1To,Color2From, Color2To,Color3From, Color3To: tAlphaColor );
var
  Data: TBitmapData;
  Pixel: TAlphaColor;
  x,y: integer;
begin
  if Bitmap.Map(TMapAccess.ReadWrite, Data) then
  try
    for y := 0 to Bitmap.Height - 1 do
      for x := 0 to Bitmap.Width - 1 do
      begin
        Pixel := Data.GetPixel(x, y);
        if Pixel = Color1From then
          Pixel := Color1To;
        if Pixel = Color2From then
          Pixel := Color2To;
        if Pixel = Color3From then
          Pixel := Color3To;
        Data.SetPixel(x, y, Pixel);
      end;
  finally
    Bitmap.Unmap(Data);
  end;
end;
function MirrorCell(const P: TPoint): TPoint;
const
  MaxX = 17; // campo 18 celle: 0..17
begin
  Result.X := MaxX - P.X;
  Result.Y := P.Y;
end;
procedure FillTeamCells ( var TeamCells: ArrayCells );
begin
  TeamCells[0].X := 0;
  TeamCells[0].Y := 5;
  TeamCells[1].X := 0;
  TeamCells[1].Y := 5;

  TeamCells[2].X := 3;
  TeamCells[2].Y := 1;
  TeamCells[3].X := 3;
  TeamCells[3].Y := 2;
  TeamCells[4].X := 3;
  TeamCells[4].Y := 4;
  TeamCells[5].X := 3;
  TeamCells[5].Y := 5;
  TeamCells[6].X := 3;
  TeamCells[6].Y := 6;
  TeamCells[7].X := 3;
  TeamCells[7].Y := 7;
  TeamCells[8].X := 3;
  TeamCells[8].Y := 9;

  TeamCells[9].X := 5;
  TeamCells[9].Y := 6;
  TeamCells[10].X := 5;
  TeamCells[10].Y := 4;


  TeamCells[11].X := 8;
  TeamCells[11].Y := 2;
  TeamCells[12].X := 8;
  TeamCells[12].Y := 5;
  TeamCells[13].X := 8;
  TeamCells[13].Y := 8;
  TeamCells[14].X := 8;
  TeamCells[14].Y := 3;
  TeamCells[15].X := 8;
  TeamCells[15].Y := 7;

  TeamCells[16].X := 13;
  TeamCells[16].Y := 2;
  TeamCells[17].X := 13;
  TeamCells[17].Y := 5;
  TeamCells[18].X := 13;
  TeamCells[18].Y := 8;
  TeamCells[19].X := 13;
  TeamCells[19].Y := 3;
  TeamCells[20].X := 13;
  TeamCells[20].Y := 7;

  TeamCells[21].X := 11; // regista
  TeamCells[21].Y := 5;
end;

end.
