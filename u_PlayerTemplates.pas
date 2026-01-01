unit u_PlayerTemplates;

interface
uses U_Types, U_Traits, U_Skills, System.Generics.Collections;

  Type PlayerTemplate = record
    Surname : string;
    Skills: TObjectList<TSkill>;
    Stat : ArrayStats;
    SeasonPlayed: Integer;
  end;
var
  Templates : Array [0..21] of PlayerTemplate;
  ASkill: TSkill;
function CreateRandomPlayer(ATemplate: PlayerTemplate; Weakening: integer): PlayerTemplate;
implementation
var
  I: integer;


function CreateRandomPlayer(ATemplate: PlayerTemplate; Weakening: integer): PlayerTemplate;
begin

  // Qui lavoriamo su una COPIA del record originale
  Result := ATemplate;

  // Modifica la copia


end;
// Ricorda:  Templates[0].Age := Trunc(Templates[0].MatchesPlayed div SEASON_MATCHES) + 18;
// Ricorda MatchesLeft := (SEASON_MATCHES * 15) - MatchesPlayed;
initialization;
  for I := 0 to 21 do begin
    Templates[I].Skills := TObjectList<TSkill>.Create(False);
    Templates[I].SeasonPlayed:= 8;
    Templates[I].Stat[STAT_SPEED] := 5;
    Templates[I].Stat[STAT_STRENGTH]:= 5;
    Templates[I].Stat[STAT_TECHNIQUE]:= 5;
    Templates[I].Stat[STAT_AGILITY]:= 5;
    Templates[I].Stat[STAT_INTUITION] := 5;
  end;

  Templates[0].Surname := 'gk difesa';      // importante elemento 0

  Templates[1].Surname := 'gk passaggi e rushing out';

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

  Templates[2].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[2].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[2].Skills.add ( GetOriginalSkill ( SKILL_SHOT_BLOCK, 5 ));
  Templates[2].Skills.add ( GetOriginalSkill ( SKILL_HEADER, 5 ));
  Templates[2].Skills.add ( GetOriginalSkill ( SKILL_TACKLE, 5 ));
  Templates[2].Skills.add ( GetOriginalSkill ( SKILL_INTERCEPTION, 5 ));

  Templates[3].Surname := 'difensore senza fronzoli';
  Templates[3].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[3].Skills.add ( GetOriginalSkill ( SKILL_PASS_HIGH, 5 ));
  Templates[3].Skills.add ( GetOriginalSkill ( SKILL_SHOT_BLOCK, 5 ));
  Templates[3].Skills.add ( GetOriginalSkill ( SKILL_HEADER, 5 ));
  Templates[3].Skills.add ( GetOriginalSkill ( SKILL_TACKLE, 5 ));
  Templates[3].Skills.add ( GetOriginalSkill ( SKILL_REACTION, 5 ));

  Templates[4].Surname := 'difensore marcatura';
  Templates[4].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[4].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[4].Skills.add ( GetOriginalSkill ( SKILL_TACKLE, 5 ));
  Templates[4].Skills.add ( GetOriginalSkill ( SKILL_SHOT_BLOCK, 5 ));
  Templates[4].Skills.add ( GetOriginalSkill ( SKILL_HEADER, 5 ));
  Templates[4].Skills.add ( GetOriginalSkill ( SKILL_INTERCEPTION, 5 ));

  Templates[5].Surname := 'difensore lanci lunghi';
  Templates[5].Skills := TObjectList<TSkill>.Create;

  ASkill := TSkill.Create ( SKILL_RUN, 5, 0);
  Templates[5].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_PASS_HIGH, 5, 0);
  Templates[5].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_SHOT_BLOCK, 5, 0);
  Templates[5].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_TACKLE, 5, 0);
  Templates[5].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_HEADER, 5, 0);
  Templates[5].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_REACTION, 5, 0);
  Templates[5].Skills.add ( ASkill );

  Templates[5].Stat[STAT_STRENGTH]:= 5;
  Templates[5].Stat[STAT_TECHNIQUE]:= 5;
  Templates[5].Stat[STAT_SPEED] := 5;
  Templates[5].Stat[STAT_AGILITY]:= 5;
  Templates[5].Stat[STAT_INTUITION] := 5;
  Templates[5].SeasonPlayed:= 8;

  // 6 libero               +intuition +passing -strenght +technique  +ballcontrol  -marking
  Templates[6].Surname := 'libero';
  Templates[6].Skills := TObjectList<TSkill>.Create;

  ASkill := TSkill.Create ( SKILL_RUN, 5, 0);
  Templates[6].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_PASS_LOW, 5, 0);
  Templates[6].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_SHOT_BLOCK, 5, 0);
  Templates[6].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_TACKLE, 5, 0);
  Templates[6].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_HEADER, 5, 0);
  Templates[6].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_REACTION, 5, 0);
  Templates[6].Skills.add ( ASkill );

  Templates[6].Stat[STAT_STRENGTH]:= 5;
  Templates[6].Stat[STAT_TECHNIQUE]:= 5;
  Templates[6].Stat[STAT_SPEED] := 5;
  Templates[6].Stat[STAT_AGILITY]:= 5;
  Templates[6].Stat[STAT_INTUITION] := 5;
  Templates[6].SeasonPlayed:= 8;

  // 7 terzino difesa       -cross -passing +bravery +tackling +marking -heading -ballcontrol
  Templates[7].Surname := 'terzino difesa';
  Templates[7].Skills := TObjectList<TSkill>.Create;
  ASkill := TSkill.Create ( SKILL_RUN, 5, 0);
  Templates[7].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_PASS_LOW, 5, 0);
  Templates[7].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_SHOT_BLOCK, 5, 0);
  Templates[7].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_TACKLE, 5, 0);
  Templates[7].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_CROSS_LOFTED, 5, 0);
  Templates[7].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_REACTION, 5, 0);
  Templates[7].Skills.add ( ASkill );

  Templates[7].Stat[STAT_STRENGTH]:= 5;
  Templates[7].Stat[STAT_TECHNIQUE]:= 5;
  Templates[7].Stat[STAT_SPEED] := 5;
  Templates[7].Stat[STAT_AGILITY]:= 5;
  Templates[7].Stat[STAT_INTUITION] := 5;
  Templates[7].SeasonPlayed:= 8;

  // 8 terzino fluidificante +cross +passing -bravery -tackling -marking -heading +ballcontrol
  Templates[8].Surname := 'terzino attacco';
  Templates[8].Skills := TObjectList<TSkill>.Create;
  ASkill := TSkill.Create ( SKILL_RUN, 5, 0);
  Templates[8].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_PASS_LOW, 5, 0);
  Templates[8].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_SHOT_BLOCK, 5, 0);
  Templates[8].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_TACKLE, 5, 0);
  Templates[8].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_CROSS_LOFTED, 5, 0);
  Templates[8].Skills.add ( ASkill );
  ASkill := TSkill.Create ( SKILL_SHOT_ACCURACY, 5, 0);
  Templates[8].Skills.add ( ASkill );

  Templates[8].Stat[STAT_STRENGTH]:= 5;
  Templates[8].Stat[STAT_TECHNIQUE]:= 5;
  Templates[8].Stat[STAT_SPEED] := 5;
  Templates[8].Stat[STAT_AGILITY]:= 5;
  Templates[8].Stat[STAT_INTUITION] := 5;
  Templates[8].SeasonPlayed:= 8;


  Templates[9].Surname := 'incontrista';
  Templates[9].SeasonPlayed:= 8;


  // 10 regista     -bravery -tackling +passing ballcontrol +technique -strenght -heading
  Templates[10].Surname := 'regista';
  Templates[10].SeasonPlayed:= 8;


  // 11 ccq         + determination +strenght +heading -shot -intuition +ballcontrol -technque
  Templates[11].Surname := 'ccq';
  Templates[11].SeasonPlayed:= 8;

  // 12  mezzala    +intuition +shot +technique -bravery -tackling -marking -ballcontrol
  Templates[12].Surname := 'mezzala';
  Templates[12].SeasonPlayed:= 8;

  // 13  ala invertita  -cross +ballcontrol +passing
  Templates[13].Surname := 'invertita';
  Templates[13].SeasonPlayed:= 8;

  // 14  ala     +cross -passing
  Templates[14].Surname := 'ala';
  Templates[14].SeasonPlayed:= 8;

  // 15  cel,ced +tackling +intuition -cross -shot
  Templates[15].Surname := 'celced';
  Templates[15].SeasonPlayed:= 8;

  // attaccanti
  // 16  uomo area          -cross -heading +shot +technique +agility -bravery -strenght +ballcontrol
  Templates[16].Surname := 'uomoarea';
  Templates[16].SeasonPlayed:= 8;

  // 17  centravanti        -cross +heading +bravery +strengh
  Templates[17].Surname := 'centravanti';
  Templates[17].SeasonPlayed:= 8;

  // 18  seconda punta      -cross +shot +ballcontrol +intuition  +passing
  Templates[18].Surname := 'seconda punta';
  Templates[18].SeasonPlayed:= 8;

  // 19  attacante esterno  -cross +ballcontrol +shot  -passing  -heading
  Templates[19].Surname := 'attacante esterno';
  Templates[19].SeasonPlayed:= 8;

  // 20  fulcro del gioco  -cross +passing -shot +ballcontrol +heading
  Templates[20].Surname := 'attacante esterno';
  Templates[20].SeasonPlayed:= 8;

  // 21  regista avanzato  -cross +passing +shot +ballcontrol +technique +agility -bravery -heading
  Templates[21].Surname := 'regista avanzato ';
  Templates[21].SeasonPlayed:= 8;


end.
