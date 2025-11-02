unit u_Types;

interface
type ArrayStats =  Array[0..16] of Integer;
type ArrayStatNames =  Array[0..16] of string;
type ArrayTraits = Array[0..5] of Byte;
type ArrayAllTraits =  Array[1..58] of Integer; // BASE 1! importante mantenere base 1 goalkeeper
const SEASON_MATCHES = 38;

var
  DirAssets, DirSaves:string;

implementation

end.
