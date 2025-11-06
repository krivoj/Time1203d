unit u_SystemUtils;

interface
uses
  Winapi.Windows, Winapi.ShLwApi, System.SysUtils, SHlObj, FMX.Graphics, System.UITypes, u_Types, u_Random, u_RandomHelper, StrUtils;

function GetLocalAppDataPath: string;
Function Capitalize ( aString : string  ): String;
procedure ModifyPixels(const Bitmap: TBitmap; Color1From, Color1To,Color2From, Color2To,Color3From, Color3To: TAlphaColor );
procedure FillRandomXp ( var xpArray: ArrayStats );
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
procedure FillRandomXp ( var xpArray: ArrayStats );
var
  i: integer;
begin
  for I := Low(xpArray) to High(xpArray) do
    xpArray[i] := RndGenerate(120);
end;
end.
