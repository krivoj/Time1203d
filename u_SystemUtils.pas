unit u_SystemUtils;

interface
uses
  Winapi.Windows, Winapi.ShLwApi, System.SysUtils, SHlObj;

function GetLocalAppDataPath: string;
implementation
function GetLocalAppDataPath: string;
var
  Path: array[0..MAX_PATH] of Char;
begin
  if SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, 0, @Path[0]) = S_OK then
    Result := Path
  else
    Result := '';
end;
end.
