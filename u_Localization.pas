unit u_Localization;

interface
uses
  inifiles, strutils, system.classes;


procedure LoadTranslations ( Filename: string ) ;
Function Translate ( aString : string  ): String;
var
  Language: string;
  TranslateMessages: TStringList;
  FileLocalization: string;

implementation
procedure LoadTranslations ( Filename: string ) ;
var
  ini: TIniFile;
  i: Integer;
begin
  ini:= TIniFile.Create( FileName );
  ini.ReadSectionValues ('Messages',TranslateMessages ) ;
  ini.Free;

end;
Function Translate ( aString : string  ): String;
begin
   Result :=  TranslateMessages.Values [aString];
end;
initialization
  TranslateMessages:= TStringList.Create;
  TranslateMessages.StrictDelimiter := True;
Finalization
  TranslateMessages.Free;
end.
