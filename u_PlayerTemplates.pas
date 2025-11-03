unit u_PlayerTemplates;

interface
uses U_Types, U_Traits;

  Type PlayerTemplate = record
    Surname : string;
    Traits: ArrayTraits;
    DefaultStat : ArrayStats;
    SeasonPlayed: Integer;
  end;
var
  Templates : Array [0..21] of PlayerTemplate;
  StatNames : ArrayStatNames;
function CreateRandomPlayer(ATemplate: PlayerTemplate; Weakening: integer): PlayerTemplate;
implementation



function CreateRandomPlayer(ATemplate: PlayerTemplate; Weakening: integer): PlayerTemplate;
begin
  // Qui lavoriamo su una COPIA del record originale
  Result := ATemplate;

  // Modifica la copia


end;
// Ricorda:  Templates[0].Age := Trunc(Templates[0].MatchesPlayed div SEASON_MATCHES) + 18;
// Ricorda MatchesLeft := (SEASON_MATCHES * 15) - MatchesPlayed;
initialization;
  Templates[0].Surname := 'gk difesa';      // importante elemento 0
  Templates[0].Traits[0] := TRAIT_GOALKEEPER;
  Templates[0].Traits[1] := 0;
  Templates[0].Traits[2] := 0;
  Templates[0].Traits[3] := 0;
  Templates[0].Traits[4] := 0;
  Templates[0].Traits[5] := 0;
  Templates[0].DefaultStat[Speed] := 1;
  Templates[0].DefaultStat[Marking] := 1;
  Templates[0].DefaultStat[Tackling] := 1;
  Templates[0].DefaultStat[BallControl] := 1;
  Templates[0].DefaultStat[Passing] := 11;
  Templates[0].DefaultStat[Shot] := 1;
  Templates[0].DefaultStat[Crossing] := 1;
  Templates[0].DefaultStat[Heading] := 1;
  Templates[0].DefaultStat[Workrate]:= 20;
  Templates[0].DefaultStat[Determination]:= 20;
  Templates[0].DefaultStat[Bravery]:= 13;
  Templates[0].DefaultStat[Intuition]:= 20;
  Templates[0].DefaultStat[Strenght]:= 13;
  Templates[0].DefaultStat[Agility]:= 20;
  Templates[0].DefaultStat[Technique]:= 16;
  Templates[0].DefaultStat[RushingOut]:= 16;
  Templates[0].DefaultStat[ShotStopping]:= 20;
  Templates[0].SeasonPlayed:= 8;

  Templates[1].Surname := 'gk passaggi e rushing out';
  Templates[1].Traits[0] := TRAIT_GOALKEEPER;
  Templates[1].Traits[1] := 0;
  Templates[1].Traits[2] := 0;
  Templates[1].Traits[3] := 0;
  Templates[1].Traits[4] := 0;
  Templates[1].Traits[5] := 0;
  Templates[1].DefaultStat[Marking] := 1;
  Templates[1].DefaultStat[Tackling] := 1;
  Templates[1].DefaultStat[BallControl] := 1;
  Templates[1].DefaultStat[Passing] := 20;
  Templates[1].DefaultStat[Shot] := 1;
  Templates[1].DefaultStat[Crossing] := 1;
  Templates[1].DefaultStat[Heading] := 1;
  Templates[1].DefaultStat[Workrate]:= 20;
  Templates[1].DefaultStat[Determination]:= 20;
  Templates[1].DefaultStat[Bravery]:= 20;
  Templates[1].DefaultStat[Intuition]:= 20;
  Templates[1].DefaultStat[Strenght]:= 16;
  Templates[1].DefaultStat[Agility]:= 16;
  Templates[1].DefaultStat[Technique]:= 20;
  Templates[1].DefaultStat[RushingOut]:= 20;
  Templates[1].DefaultStat[ShotStopping]:= 16;
  Templates[1].SeasonPlayed:= 8;

  // 2 difensore che imposta -bravery -tackling -marking +passing +technique -heading -intuition +agility  +ballcontrol -strenght
  // 3 difensore senza fronzoli +bravery +tackling +marking -passing -technique +heading -intuition -agility  -ballcontrol +strenght
  // 4 difensore marcatura  +tackling +marking -passing -technique +intuiton
  // 5 difensore pressing   +bravery +strenght +tackling -passing -technique -heading
  // 6 libero               +intuition +passing -strenght +technique  +ballcontrol  -marking
  // 7 terzino difesa       -cross -passing +bravery +tackling +marking -heading -ballcontrol
  // 8 terzino fluidificante +cross +passing -bravery -tackling -marking -heading +ballcontrol
  //   centrocampisti bravery tackling passing ballcontrol strenght intuition ballcontrol heading ----------------------------------------------
  // 9 incontrista +bravery +tackling +strenght -passing -ballcontrol -technique
  // 10 regista     -bravery -tackling +passing ballcontrol +technique -strenght -heading
  // 11 ccq         + determination +strenght +heading -shot -intuition +ballcontrol -technque
  // 12  mezzala    +intuition +shot +technique -bravery -tackling -marking -ballcontrol
  // 13  ala invertita  -cross +ballcontrol +passing
  // 14  ala     +cross -passing
  // 15  cel,ced +tackling +intuition -cross -shot
  // attaccanti
  // 16  uomo area          -cross -heading +shot +technique +agility -bravery -strenght +ballcontrol
  // 17  centravanti        -cross +heading +bravery +strengh
  // 18  seconda punta      -cross +shot +ballcontrol +intuition  +passing
  // 19  attacante esterno  -cross +ballcontrol +shot  -passing  -heading
  // 20  fulcro del gioco  -cross +passing -shot +ballcontrol +heading
  // 21  regista avanzato  -cross +passing +shot +ballcontrol +technique +agility -bravery -heading

  // 2 difensore che imposta -bravery -tackling -marking +passing +technique -heading -intuition +agility  +ballcontrol -strenght
  Templates[2].Surname := 'difensore che imposta';
  Templates[2].Traits[0] := TRAIT_LOWPASS_TECHNIQUE;
  Templates[2].Traits[1] := TRAIT_LOWPASS_TECHNIQUE2;
  Templates[2].Traits[2] := TRAIT_AUTOTACKLE_TECHNIQUE;
  Templates[2].Traits[3] := TRAIT_AUTOTACKLE_TECHNIQUE2;
  Templates[2].Traits[4] := TRAIT_AUTOTACKLE_AGILITY;
  Templates[2].Traits[5] := TRAIT_AUTOTACKLE_AGILITY2;
  Templates[2].DefaultStat[Speed] := 4;
  Templates[2].DefaultStat[Marking]:= 16;
  Templates[2].DefaultStat[Tackling]:= 16;
  Templates[2].DefaultStat[BallControl]:= 16;
  Templates[2].DefaultStat[Passing] := 20;
  Templates[2].DefaultStat[Shot]:= 11;
  Templates[2].DefaultStat[Crossing]:= 11;
  Templates[2].DefaultStat[Heading]:= 16;

  Templates[2].DefaultStat[Workrate]:= 20;
  Templates[2].DefaultStat[Determination]:= 20;
  Templates[2].DefaultStat[Bravery] := 16;
  Templates[2].DefaultStat[Intuition] := 16;

  Templates[2].DefaultStat[Strenght] := 16;
  Templates[2].DefaultStat[Agility] := 16;
  Templates[2].DefaultStat[Technique]:= 20;

  Templates[2].DefaultStat[RushingOut] := 1;
  Templates[2].DefaultStat[ShotStopping] := 1;
  Templates[2].SeasonPlayed:= 8;



  // 3 difensore senza fronzoli +bravery +tackling +marking -passing -technique +heading -intuition -agility  -ballcontrol +strenght
  Templates[3].Surname := 'difensore senza fronzoli';
  Templates[3].Traits[0] := TRAIT_DRIBBLING_MARKING;
  Templates[3].Traits[1] := TRAIT_DRIBBLING_MARKING2;
  Templates[3].Traits[2] := TRAIT_DRIBBLING_TACKLING;
  Templates[3].Traits[3] := TRAIT_DRIBBLING_TACKLING2;
  Templates[3].Traits[4] := TRAIT_BUFF_DEFENSE;
  Templates[3].Traits[5] := TRAIT_PRESSING;
  Templates[3].DefaultStat[Speed] := 4;
  Templates[3].DefaultStat[Marking] := 20;
  Templates[3].DefaultStat[Tackling] := 20;
  Templates[3].DefaultStat[BallControl]:= 16;
  Templates[3].DefaultStat[Passing]:= 16;
  Templates[3].DefaultStat[Shot]:= 11;
  Templates[3].DefaultStat[Crossing]:= 11;
  Templates[3].DefaultStat[Heading] := 20;

  Templates[3].DefaultStat[Workrate]:= 20;
  Templates[3].DefaultStat[Determination]:= 20;
  Templates[3].DefaultStat[Bravery]:= 20;
  Templates[3].DefaultStat[Intuition] := 16;

  Templates[3].DefaultStat[Strenght]:= 20;
  Templates[3].DefaultStat[Agility] := 16;
  Templates[3].DefaultStat[Technique] := 16;

  Templates[3].DefaultStat[RushingOut] := 1;
  Templates[3].DefaultStat[ShotStopping] := 1;
  Templates[3].SeasonPlayed:= 8;

  // 4 difensore marcatura  +tackling +marking -passing -technique +intuiton -ballcontrol
  Templates[4].Surname := 'difensore marcatura';
  Templates[4].Traits[0] := TRAIT_DRIBBLING_MARKING;
  Templates[4].Traits[1] := TRAIT_DRIBBLING_MARKING2;
  Templates[4].Traits[2] := TRAIT_DRIBBLING_TACKLING;
  Templates[4].Traits[3]:= TRAIT_DRIBBLING_TACKLING2;
  Templates[4].Traits[4] := TRAIT_BUFF_DEFENSE;
  Templates[4].Traits[5] := TRAIT_PRESSING;
  Templates[4].DefaultStat[Speed] := 4;
  Templates[4].DefaultStat[Marking] := 20;
  Templates[4].DefaultStat[Tackling] := 20;
  Templates[4].DefaultStat[BallControl]:= 16;
  Templates[4].DefaultStat[Passing]:= 16;
  Templates[4].DefaultStat[Shot]:= 11;
  Templates[4].DefaultStat[Crossing]:= 11;
  Templates[4].DefaultStat[Heading] := 20;

  Templates[4].DefaultStat[Workrate]:= 20;
  Templates[4].DefaultStat[Determination]:= 20;
  Templates[4].DefaultStat[Bravery]:= 20;
  Templates[4].DefaultStat[Intuition]:= 20;

  Templates[4].DefaultStat[Strenght]:= 20;
  Templates[4].DefaultStat[Agility] := 16;
  Templates[4].DefaultStat[Technique] := 16;

  Templates[4].DefaultStat[RushingOut] := 1;
  Templates[4].DefaultStat[ShotStopping] := 1;
  Templates[4].SeasonPlayed:= 8;

  // 5 difensore pressing   +bravery +strenght +tackling -passing -technique -heading
  Templates[5].Surname := 'difensore pressing alto';
  Templates[5].Traits[0] := TRAIT_DRIBBLING_MARKING;
  Templates[5].Traits[1] := TRAIT_DRIBBLING_MARKING2;
  Templates[5].Traits[2] := TRAIT_DRIBBLING_TACKLING;
  Templates[5].Traits[3]:= TRAIT_DRIBBLING_TACKLING2;
  Templates[5].Traits[4] := TRAIT_PRESSING;
  Templates[5].Traits[5] := TRAIT_PRESSING2;
  Templates[5].DefaultStat[Speed] := 4;
  Templates[5].DefaultStat[Marking] := 20;
  Templates[5].DefaultStat[Tackling] := 20;
  Templates[5].DefaultStat[BallControl]:= 16;
  Templates[5].DefaultStat[Passing]:= 16;
  Templates[5].DefaultStat[Shot]:= 11;
  Templates[5].DefaultStat[Crossing]:= 11;
  Templates[5].DefaultStat[Heading]:= 16;

  Templates[5].DefaultStat[Workrate]:= 20;
  Templates[5].DefaultStat[Determination]:= 20;
  Templates[5].DefaultStat[Bravery]:= 20;
  Templates[5].DefaultStat[Intuition]:= 20;

  Templates[5].DefaultStat[Strenght]:= 20;
  Templates[5].DefaultStat[Agility] := 16;
  Templates[5].DefaultStat[Technique] := 16;

  Templates[5].DefaultStat[RushingOut] := 1;
  Templates[5].DefaultStat[ShotStopping] := 1;
  Templates[5].SeasonPlayed:= 8;

  // 6 libero               +intuition +passing -strenght +technique  +ballcontrol  -marking
  Templates[6].Surname := 'libero';
  Templates[6].Traits[0] := TRAIT_LOFTEDPASS_MARKING;
  Templates[6].Traits[1] := TRAIT_LOFTEDPASS_MARKING2;
  Templates[6].Traits[2] := TRAIT_CROSS_INTUITION;
  Templates[6].Traits[3] := TRAIT_CROSS_INTUITION2;
  Templates[6].Traits[4] := TRAIT_BUFF_DEFENSE;
  Templates[6].Traits[5] := TRAIT_PRESSING;
  Templates[6].DefaultStat[Speed] := 4;
  Templates[6].DefaultStat[Marking]:= 16;
  Templates[6].DefaultStat[Tackling] := 20;
  Templates[6].DefaultStat[BallControl] := 20;
  Templates[6].DefaultStat[Passing] := 20;
  Templates[6].DefaultStat[Shot]:= 11;
  Templates[6].DefaultStat[Crossing]:= 11;
  Templates[6].DefaultStat[Heading]:= 16;

  Templates[6].DefaultStat[Workrate]:= 20;
  Templates[6].DefaultStat[Determination]:= 20;
  Templates[6].DefaultStat[Bravery]:= 20;
  Templates[6].DefaultStat[Intuition]:= 20;

  Templates[6].DefaultStat[Strenght] := 16;
  Templates[6].DefaultStat[Agility] := 16;
  Templates[6].DefaultStat[Technique]:= 20;

  Templates[6].DefaultStat[RushingOut] := 1;
  Templates[6].DefaultStat[ShotStopping] := 1;
  Templates[6].SeasonPlayed:= 8;

  // 7 terzino difesa       -cross -passing +bravery +tackling +marking -heading -ballcontrol
  Templates[7].Surname := 'terzino difesa';
  Templates[7].Traits[0] := TRAIT_LOFTEDPASS_MARKING;
  Templates[7].Traits[1] := TRAIT_LOFTEDPASS_MARKING2;
  Templates[7].Traits[2] := TRAIT_CROSS_INTUITION;
  Templates[7].Traits[3] := TRAIT_CROSS_INTUITION2;
  Templates[7].Traits[4] := TRAIT_POSITIONING;
  Templates[7].Traits[5] := TRAIT_RAPIDPASSING;
  Templates[7].DefaultStat[Speed] := 4;
  Templates[7].DefaultStat[Marking] := 20;
  Templates[7].DefaultStat[Tackling] := 20;
  Templates[7].DefaultStat[BallControl]:= 16;
  Templates[7].DefaultStat[Passing]:= 16;
  Templates[7].DefaultStat[Shot]:= 11;
  Templates[7].DefaultStat[Crossing]:= 16;
  Templates[7].DefaultStat[Heading]:= 16;

  Templates[7].DefaultStat[Workrate]:= 20;
  Templates[7].DefaultStat[Determination]:= 20;
  Templates[7].DefaultStat[Bravery]:= 20;
  Templates[7].DefaultStat[Intuition]:= 20;

  Templates[7].DefaultStat[Strenght] := 16;
  Templates[7].DefaultStat[Agility] := 16;
  Templates[7].DefaultStat[Technique]:= 20;

  Templates[7].DefaultStat[RushingOut] := 1;
  Templates[7].DefaultStat[ShotStopping] := 1;
  Templates[7].SeasonPlayed:= 8;

  // 8 terzino fluidificante +cross +passing -bravery -tackling -marking -heading +ballcontrol
  Templates[8].Surname := 'terzino attacco';
  Templates[8].Traits[0] := TRAIT_CROSS_TECHNIQUE;
  Templates[8].Traits[1] := TRAIT_CROSS_TECHNIQUE2;
  Templates[8].Traits[2] := TRAIT_LOFTEDPASS_INTUITION;
  Templates[8].Traits[3] := TRAIT_LOFTEDPASS_INTUITION2;
  Templates[8].Traits[4] := TRAIT_POSITIONING;
  Templates[8].Traits[5] := TRAIT_RAPIDPASSING;
  Templates[8].DefaultStat[Speed] := 4;
  Templates[8].DefaultStat[Marking]:= 16;
  Templates[8].DefaultStat[Tackling]:= 16;
  Templates[8].DefaultStat[BallControl] := 20;
  Templates[8].DefaultStat[Passing] := 20;
  Templates[8].DefaultStat[Shot]:= 11;
  Templates[8].DefaultStat[Crossing] := 20;
  Templates[8].DefaultStat[Heading]:= 16;

  Templates[8].DefaultStat[Workrate]:= 20;
  Templates[8].DefaultStat[Determination]:= 20;
  Templates[8].DefaultStat[Bravery] := 16;
  Templates[8].DefaultStat[Intuition]:= 20;

  Templates[8].DefaultStat[Strenght] := 16;
  Templates[8].DefaultStat[Agility] := 16;
  Templates[8].DefaultStat[Technique]:= 20;

  Templates[8].DefaultStat[RushingOut] := 1;
  Templates[8].DefaultStat[ShotStopping] := 1;
  Templates[8].SeasonPlayed:= 8;


  // 9 incontrista +bravery +tackling +strenght -passing -ballcontrol -technique
  Templates[9].Surname := 'incontrista';
  Templates[9].Traits[0] := TRAIT_AUTOTACKLE_STRENGHT;
  Templates[9].Traits[1] := TRAIT_AUTOTACKLE_STRENGHT2;
  Templates[9].Traits[2] := TRAIT_AUTOTACKLE_TACKLING;
  Templates[9].Traits[3] := TRAIT_AUTOTACKLE_TACKLING2;
  Templates[9].Traits[4] := TRAIT_AGGRESSION;
  Templates[9].Traits[5] := TRAIT_AGGRESSION2;
  Templates[9].DefaultStat[Speed] := 4;
  Templates[9].DefaultStat[Marking]  := 16;
  Templates[9].DefaultStat[Tackling]  := 16;
  Templates[9].DefaultStat[BallControl]  := 16;
  Templates[9].DefaultStat[Passing]  := 11;
  Templates[9].DefaultStat[Shot]  := 11;
  Templates[9].DefaultStat[Crossing]  := 11;
  Templates[9].DefaultStat[Heading]  := 16;

  Templates[9].DefaultStat[Workrate]:= 20;
  Templates[9].DefaultStat[Determination]:= 20;
  Templates[9].DefaultStat[Bravery]:= 20;
  Templates[9].DefaultStat[Intuition]:= 20;

  Templates[9].DefaultStat[Strenght]:= 20;
  Templates[9].DefaultStat[Agility] := 16;
  Templates[9].DefaultStat[Technique] := 16;

  Templates[9].DefaultStat[RushingOut] := 1;
  Templates[9].DefaultStat[ShotStopping] := 1;
  Templates[9].SeasonPlayed:= 8;


  // 10 regista     -bravery -tackling +passing ballcontrol +technique -strenght -heading
  Templates[10].Surname := 'regista';
  Templates[10].Traits[0] := TRAIT_LOFTEDPASS_TECHNIQUE;
  Templates[10].Traits[1] := TRAIT_LOFTEDPASS_TECHNIQUE;
  Templates[10].Traits[2] := TRAIT_LOWPASS_TECHNIQUE;
  Templates[10].Traits[3] := TRAIT_LOWPASS_TECHNIQUE2;
  Templates[10].Traits[4] := TRAIT_BUFF_MIDDLE;
  Templates[10].Traits[5] := TRAIT_PLAYMAKER;
  Templates[10].DefaultStat[Speed] := 4;
  Templates[10].DefaultStat[Marking]  := 11;
  Templates[10].DefaultStat[Tackling]  := 11;
  Templates[10].DefaultStat[BallControl] := 20;
  Templates[10].DefaultStat[Passing] := 20;
  Templates[10].DefaultStat[Shot]  := 11;
  Templates[10].DefaultStat[Crossing] := 11;
  Templates[10].DefaultStat[Heading]  := 11;

  Templates[10].DefaultStat[Workrate]:= 20;
  Templates[10].DefaultStat[Determination]:= 20;
  Templates[10].DefaultStat[Bravery] := 16;
  Templates[10].DefaultStat[Intuition]:= 20;

  Templates[10].DefaultStat[Strenght] := 16;
  Templates[10].DefaultStat[Agility] := 16;
  Templates[10].DefaultStat[Technique]:= 20;

  Templates[10].DefaultStat[RushingOut] := 1;
  Templates[10].DefaultStat[ShotStopping] := 1;
  Templates[10].SeasonPlayed:= 8;


  // 11 ccq         + determination +strenght +heading -shot -intuition +ballcontrol -technque
  Templates[11].Surname := 'ccq';
  Templates[11].Traits[0] := TRAIT_LOFTEDPASS_BALLCONTROL;
  Templates[11].Traits[1] := TRAIT_LOFTEDPASS_INTUITION;
  Templates[11].Traits[2] := TRAIT_AUTOTACKLE_TECHNIQUE;
  Templates[11].Traits[3] := TRAIT_AUTOTACKLE_STRENGHT;
  Templates[11].Traits[4] := TRAIT_AUTOTACKLE_AGILITY;
  Templates[11].Traits[5] := TRAIT_BOMB;
  Templates[11].DefaultStat[Speed] := 4;
  Templates[11].DefaultStat[Marking]  := 16;
  Templates[11].DefaultStat[Tackling]  := 16;
  Templates[11].DefaultStat[BallControl] := 16;
  Templates[11].DefaultStat[Passing]  := 16;
  Templates[11].DefaultStat[Shot]  := 16;
  Templates[11].DefaultStat[Crossing]  := 11;
  Templates[11].DefaultStat[Heading] := 20;

  Templates[11].DefaultStat[Workrate]:= 20;
  Templates[11].DefaultStat[Determination]:= 20;
  Templates[11].DefaultStat[Bravery]:= 20;
  Templates[11].DefaultStat[Intuition] := 16;

  Templates[11].DefaultStat[Strenght]:= 20;
  Templates[11].DefaultStat[Agility]:= 20;
  Templates[11].DefaultStat[Technique] := 16;

  Templates[11].DefaultStat[RushingOut] := 1;
  Templates[11].DefaultStat[ShotStopping] := 1;
  Templates[11].SeasonPlayed:= 8;

  // 12  mezzala    +intuition +shot +technique -bravery -tackling -marking -ballcontrol
  Templates[12].Surname := 'mezzala';
  Templates[12].Traits[0] := TRAIT_EXPERIENCE;
  Templates[12].Traits[1] := TRAIT_LOWPASS_TECHNIQUE;
  Templates[12].Traits[2] := TRAIT_AUTOTACKLE_TECHNIQUE;
  Templates[12].Traits[3] := TRAIT_AUTOTACKLE_AGILITY;
  Templates[12].Traits[4] := TRAIT_BOMB;
  Templates[12].Traits[5] := TRAIT_BOMB2;
  Templates[12].DefaultStat[Speed] := 4;
  Templates[12].DefaultStat[Marking] := 16;
  Templates[12].DefaultStat[Tackling] := 16;
  Templates[12].DefaultStat[BallControl] := 16;
  Templates[12].DefaultStat[Passing] := 16;
  Templates[12].DefaultStat[Shot] := 16;
  Templates[12].DefaultStat[Crossing] := 11;
  Templates[12].DefaultStat[Heading] := 20;

  Templates[12].DefaultStat[Workrate]:= 20;
  Templates[12].DefaultStat[Determination]:= 20;
  Templates[12].DefaultStat[Bravery] := 16;
  Templates[12].DefaultStat[Intuition]:= 20;

  Templates[12].DefaultStat[Strenght] := 16;
  Templates[12].DefaultStat[Agility] := 16;
  Templates[12].DefaultStat[Technique] := 16;

  Templates[12].DefaultStat[RushingOut] := 1;
  Templates[12].DefaultStat[ShotStopping] := 1;
  Templates[12].SeasonPlayed:= 8;

  // 13  ala invertita  -cross +ballcontrol +passing
  Templates[13].Surname := 'invertita';
  Templates[13].Traits[0] := TRAIT_LOWPASS_TECHNIQUE;
  Templates[13].Traits[1] := TRAIT_LOWPASS_TECHNIQUE2;
  Templates[13].Traits[2] := TRAIT_LOWPASS_INTUITION;
  Templates[13].Traits[3] := TRAIT_LOWPASS_INTUITION2;
  Templates[13].Traits[4] := TRAIT_LOFTEDPASS_TECHNIQUE;
  Templates[13].Traits[5] := TRAIT_LOFTEDPASS_TECHNIQUE2;
  Templates[13].DefaultStat[Speed] := 4;
  Templates[13].DefaultStat[Marking] := 16;
  Templates[13].DefaultStat[Tackling] := 16;
  Templates[13].DefaultStat[BallControl] := 16;
  Templates[13].DefaultStat[Passing] := 20;
  Templates[13].DefaultStat[Shot] := 16;
  Templates[13].DefaultStat[Crossing] := 16;
  Templates[13].DefaultStat[Heading] := 20;

  Templates[13].DefaultStat[Workrate]:= 20;
  Templates[13].DefaultStat[Determination]:= 20;
  Templates[13].DefaultStat[Bravery] := 16;
  Templates[13].DefaultStat[Intuition]:= 16;

  Templates[13].DefaultStat[Strenght] := 16;
  Templates[13].DefaultStat[Agility] := 16;
  Templates[13].DefaultStat[Technique] := 16;

  Templates[13].DefaultStat[RushingOut] := 1;
  Templates[13].DefaultStat[ShotStopping] := 1;
  Templates[13].SeasonPlayed:= 8;

  // 14  ala     +cross -passing
  Templates[14].Surname := 'ala';
  Templates[14].Traits[0] := TRAIT_CROSS_TECHNIQUE;
  Templates[14].Traits[1] := TRAIT_CROSS_TECHNIQUE2;
  Templates[14].Traits[2] := TRAIT_POSITIONING;
  Templates[14].Traits[3] := TRAIT_RUNNER;
  Templates[14].Traits[4] := TRAIT_FREEKICKS;
  Templates[14].Traits[5] := TRAIT_DIVING;
  Templates[14].DefaultStat[Speed] := 4;
  Templates[14].DefaultStat[Marking] := 16;
  Templates[14].DefaultStat[Tackling] := 16;
  Templates[14].DefaultStat[BallControl] := 16;
  Templates[14].DefaultStat[Passing] := 16;
  Templates[14].DefaultStat[Shot] := 16;
  Templates[14].DefaultStat[Crossing] := 20;
  Templates[14].DefaultStat[Heading] := 20;

  Templates[14].DefaultStat[Workrate]:= 20;
  Templates[14].DefaultStat[Determination]:= 20;
  Templates[14].DefaultStat[Bravery] := 16;
  Templates[14].DefaultStat[Intuition]:= 16;

  Templates[14].DefaultStat[Strenght] := 16;
  Templates[14].DefaultStat[Agility] := 20;
  Templates[14].DefaultStat[Technique] := 20;

  Templates[14].DefaultStat[RushingOut] := 1;
  Templates[14].DefaultStat[ShotStopping] := 1;
  Templates[14].SeasonPlayed:= 8;

  // 15  cel,ced +tackling +intuition -cross -shot
  Templates[15].Surname := 'celced';
  Templates[15].Traits[0] := TRAIT_CROSS_TECHNIQUE;
  Templates[15].Traits[1] := TRAIT_CROSS_TECHNIQUE2;
  Templates[15].Traits[2] := TRAIT_POSITIONING;
  Templates[15].Traits[3] := TRAIT_RUNNER;
  Templates[15].Traits[4] := TRAIT_FREEKICKS;
  Templates[15].Traits[5] := TRAIT_DIVING;
  Templates[15].DefaultStat[Speed] := 4;
  Templates[15].DefaultStat[Marking] := 20;
  Templates[15].DefaultStat[Tackling] := 20;
  Templates[15].DefaultStat[BallControl] := 16;
  Templates[15].DefaultStat[Passing] := 16;
  Templates[15].DefaultStat[Shot] := 16;
  Templates[15].DefaultStat[Crossing] := 16;
  Templates[15].DefaultStat[Heading] := 20;

  Templates[15].DefaultStat[Workrate]:= 20;
  Templates[15].DefaultStat[Determination]:= 20;
  Templates[15].DefaultStat[Bravery] := 16;
  Templates[15].DefaultStat[Intuition]:= 20;

  Templates[15].DefaultStat[Strenght] := 20;
  Templates[15].DefaultStat[Agility] := 16;
  Templates[15].DefaultStat[Technique] := 16;

  Templates[15].DefaultStat[RushingOut] := 1;
  Templates[15].DefaultStat[ShotStopping] := 1;
  Templates[15].SeasonPlayed:= 8;

  // attaccanti
  // 16  uomo area          -cross -heading +shot +technique +agility -bravery -strenght +ballcontrol
  Templates[16].Surname := 'uomoarea';
  Templates[16].Traits[0] := TRAIT_VOLLEY;
  Templates[16].Traits[1] := TRAIT_VOLLEY2;
  Templates[16].Traits[2] := TRAIT_POSITIONING;
  Templates[16].Traits[3] := TRAIT_RUNNER;
  Templates[16].Traits[4] := TRAIT_FINISHING;
  Templates[16].Traits[5] := TRAIT_FINISHING2;
  Templates[16].DefaultStat[Speed] := 4;
  Templates[16].DefaultStat[Marking] := 11;
  Templates[16].DefaultStat[Tackling] := 11;
  Templates[16].DefaultStat[BallControl] := 20;
  Templates[16].DefaultStat[Passing] := 16;
  Templates[16].DefaultStat[Shot] := 20;
  Templates[16].DefaultStat[Crossing] := 11;
  Templates[16].DefaultStat[Heading] := 16;

  Templates[16].DefaultStat[Workrate]:= 20;
  Templates[16].DefaultStat[Determination]:= 20;
  Templates[16].DefaultStat[Bravery] := 16;
  Templates[16].DefaultStat[Intuition]:= 20;

  Templates[16].DefaultStat[Strenght] := 16;
  Templates[16].DefaultStat[Agility] := 20;
  Templates[16].DefaultStat[Technique] := 20;

  Templates[16].DefaultStat[RushingOut] := 1;
  Templates[16].DefaultStat[ShotStopping] := 1;
  Templates[16].SeasonPlayed:= 8;

  // 17  centravanti        -cross +heading +bravery +strengh
  Templates[17].Surname := 'centravanti';
  Templates[17].Traits[0] := TRAIT_BOMB;
  Templates[17].Traits[1] := TRAIT_BOMB2;
  Templates[17].Traits[2] := TRAIT_POSITIONING;
  Templates[17].Traits[3] := TRAIT_RUNNER;
  Templates[17].Traits[4] := TRAIT_FREEKICKS;
  Templates[17].Traits[5] := TRAIT_BUFF_FORWARD;
  Templates[17].DefaultStat[Speed] := 4;
  Templates[17].DefaultStat[Marking] := 11;
  Templates[17].DefaultStat[Tackling] := 11;
  Templates[17].DefaultStat[BallControl] := 16;
  Templates[17].DefaultStat[Passing] := 16;
  Templates[17].DefaultStat[Shot] := 20;
  Templates[17].DefaultStat[Crossing] := 11;
  Templates[17].DefaultStat[Heading] := 20;

  Templates[17].DefaultStat[Workrate]:= 20;
  Templates[17].DefaultStat[Determination]:= 20;
  Templates[17].DefaultStat[Bravery] := 20;
  Templates[17].DefaultStat[Intuition]:= 16;

  Templates[17].DefaultStat[Strenght] := 20;
  Templates[17].DefaultStat[Agility] := 20;
  Templates[17].DefaultStat[Technique] := 20;

  Templates[17].DefaultStat[RushingOut] := 1;
  Templates[17].DefaultStat[ShotStopping] := 1;
  Templates[17].SeasonPlayed:= 8;

  // 18  seconda punta      -cross +shot +ballcontrol +intuition  +passing
  Templates[18].Surname := 'seconda punta';
  Templates[18].Traits[0] := TRAIT_BOMB;
  Templates[18].Traits[1] := TRAIT_BOMB2;
  Templates[18].Traits[2] := TRAIT_POSITIONING;
  Templates[18].Traits[3] := TRAIT_RUNNER;
  Templates[18].Traits[4] := TRAIT_FREEKICKS;
  Templates[18].Traits[5] := TRAIT_BUFF_FORWARD;
  Templates[18].DefaultStat[Speed] := 4;
  Templates[18].DefaultStat[Marking] := 11;
  Templates[18].DefaultStat[Tackling] := 11;
  Templates[18].DefaultStat[BallControl] := 20;
  Templates[18].DefaultStat[Passing] := 20;
  Templates[18].DefaultStat[Shot] := 20;
  Templates[18].DefaultStat[Crossing] := 11;
  Templates[18].DefaultStat[Heading] := 20;

  Templates[18].DefaultStat[Workrate]:= 20;
  Templates[18].DefaultStat[Determination]:= 20;
  Templates[18].DefaultStat[Bravery] := 16;
  Templates[18].DefaultStat[Intuition]:= 20;

  Templates[18].DefaultStat[Strenght] := 16;
  Templates[18].DefaultStat[Agility] := 20;
  Templates[18].DefaultStat[Technique] := 20;

  Templates[18].DefaultStat[RushingOut] := 1;
  Templates[18].DefaultStat[ShotStopping] := 1;
  Templates[18].SeasonPlayed:= 8;

  // 19  attacante esterno  -cross +ballcontrol +shot  -passing  -heading
  Templates[19].Surname := 'attacante esterno';
  Templates[19].Traits[0] := TRAIT_BOMB;
  Templates[19].Traits[1] := TRAIT_BOMB2;
  Templates[19].Traits[2] := TRAIT_POSITIONING;
  Templates[19].Traits[3] := TRAIT_RUNNER;
  Templates[19].Traits[4] := TRAIT_FREEKICKS;
  Templates[19].Traits[5] := TRAIT_BUFF_FORWARD;
  Templates[19].DefaultStat[Speed] := 4;
  Templates[19].DefaultStat[Marking] := 11;
  Templates[19].DefaultStat[Tackling] := 11;
  Templates[19].DefaultStat[BallControl] := 20;
  Templates[19].DefaultStat[Passing] := 20;
  Templates[19].DefaultStat[Shot] := 20;
  Templates[19].DefaultStat[Crossing] := 11;
  Templates[19].DefaultStat[Heading] := 20;

  Templates[19].DefaultStat[Workrate]:= 20;
  Templates[19].DefaultStat[Determination]:= 20;
  Templates[19].DefaultStat[Bravery] := 16;
  Templates[19].DefaultStat[Intuition]:= 20;

  Templates[19].DefaultStat[Strenght] := 16;
  Templates[19].DefaultStat[Agility] := 20;
  Templates[19].DefaultStat[Technique] := 20;

  Templates[19].DefaultStat[RushingOut] := 1;
  Templates[19].DefaultStat[ShotStopping] := 1;
  Templates[19].SeasonPlayed:= 8;

  // 20  fulcro del gioco  -cross +passing -shot +ballcontrol +heading
  Templates[20].Surname := 'attacante esterno';
  Templates[20].Traits[0] := TRAIT_BOMB;
  Templates[20].Traits[1] := TRAIT_BOMB2;
  Templates[20].Traits[2] := TRAIT_POSITIONING;
  Templates[20].Traits[3] := TRAIT_RUNNER;
  Templates[20].Traits[4] := TRAIT_FREEKICKS;
  Templates[20].Traits[5] := TRAIT_BUFF_FORWARD;
  Templates[20].DefaultStat[Speed] := 4;
  Templates[20].DefaultStat[Marking] := 11;
  Templates[20].DefaultStat[Tackling] := 11;
  Templates[20].DefaultStat[BallControl] := 20;
  Templates[20].DefaultStat[Passing] := 20;
  Templates[20].DefaultStat[Shot] := 20;
  Templates[20].DefaultStat[Crossing] := 11;
  Templates[20].DefaultStat[Heading] := 20;

  Templates[20].DefaultStat[Workrate]:= 20;
  Templates[20].DefaultStat[Determination]:= 20;
  Templates[20].DefaultStat[Bravery] := 16;
  Templates[20].DefaultStat[Intuition]:= 20;

  Templates[20].DefaultStat[Strenght] := 16;
  Templates[20].DefaultStat[Agility] := 20;
  Templates[20].DefaultStat[Technique] := 20;

  Templates[20].DefaultStat[RushingOut] := 1;
  Templates[20].DefaultStat[ShotStopping] := 1;
  Templates[20].SeasonPlayed:= 8;

  // 21  regista avanzato  -cross +passing +shot +ballcontrol +technique +agility -bravery -heading
  Templates[21].Surname := 'regista avanzato ';
  Templates[21].Traits[0] := TRAIT_BOMB;
  Templates[21].Traits[1] := TRAIT_BOMB2;
  Templates[21].Traits[2] := TRAIT_POSITIONING;
  Templates[21].Traits[3] := TRAIT_RUNNER;
  Templates[21].Traits[4] := TRAIT_FREEKICKS;
  Templates[21].Traits[5] := TRAIT_BUFF_FORWARD;
  Templates[21].DefaultStat[Speed] := 4;
  Templates[21].DefaultStat[Marking] := 11;
  Templates[21].DefaultStat[Tackling] := 11;
  Templates[21].DefaultStat[BallControl] := 20;
  Templates[21].DefaultStat[Passing] := 20;
  Templates[21].DefaultStat[Shot] := 20;
  Templates[21].DefaultStat[Crossing] := 11;
  Templates[21].DefaultStat[Heading] := 20;

  Templates[21].DefaultStat[Workrate]:= 20;
  Templates[21].DefaultStat[Determination]:= 20;
  Templates[21].DefaultStat[Bravery] := 16;
  Templates[21].DefaultStat[Intuition]:= 20;

  Templates[21].DefaultStat[Strenght] := 16;
  Templates[21].DefaultStat[Agility] := 20;
  Templates[21].DefaultStat[Technique] := 20;

  Templates[21].DefaultStat[RushingOut] := 1;
  Templates[21].DefaultStat[ShotStopping] := 1;
  Templates[21].SeasonPlayed:= 8;

  StatNames[0] :='stat_speed';
  StatNames[1] :='stat_tackling';
  StatNames[2] :='stat_marking';
  StatNames[3] :='stat_ballControl';
  StatNames[4] :='stat_passing';
  StatNames[5] :='stat_shot';
  StatNames[6] :='stat_crossing';
  StatNames[7] :='stat_heading';

  StatNames[8] :='stat_workrate';
  StatNames[9] :='stat_determination';
  StatNames[10] :='stat_bravery';
  StatNames[11] :='stat_intuition';

  StatNames[12] :='stat_strenght';
  StatNames[13] :='stat_agility';
  StatNames[14] :='stat_technique';

  StatNames[15] :='stat_rushingout';
  StatNames[16] :='stat_shotstopping';

end.
