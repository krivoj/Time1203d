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
  Templates[5].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[5].Skills.add ( GetOriginalSkill ( SKILL_PASS_HIGH, 5 ));
  Templates[5].Skills.add ( GetOriginalSkill ( SKILL_SHOT_BLOCK, 5 ));
  Templates[5].Skills.add ( GetOriginalSkill ( SKILL_TACKLE, 5 ));
  Templates[5].Skills.add ( GetOriginalSkill ( SKILL_HEADER, 5 ));
  Templates[5].Skills.add ( GetOriginalSkill ( SKILL_REACTION, 5 ));


  Templates[6].Surname := 'libero';
  Templates[6].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[6].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[6].Skills.add ( GetOriginalSkill ( SKILL_SHOT_BLOCK, 5 ));
  Templates[6].Skills.add ( GetOriginalSkill ( SKILL_TACKLE, 5 ));
  Templates[6].Skills.add ( GetOriginalSkill ( SKILL_HEADER, 5 ));
  Templates[6].Skills.add ( GetOriginalSkill ( SKILL_REACTION, 5 ));

  Templates[7].Surname := 'terzino difesa';
  Templates[7].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[7].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[7].Skills.add ( GetOriginalSkill ( SKILL_SHOT_BLOCK, 5 ));
  Templates[7].Skills.add ( GetOriginalSkill ( SKILL_TACKLE, 5 ));
  Templates[7].Skills.add ( GetOriginalSkill ( SKILL_CROSS_LOFTED, 5 ));
  Templates[7].Skills.add ( GetOriginalSkill ( SKILL_REACTION, 5 ));

  Templates[8].Surname := 'terzino attacco';
  Templates[8].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[8].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[8].Skills.add ( GetOriginalSkill ( SKILL_BALL_CONTROL, 5 ));
  Templates[8].Skills.add ( GetOriginalSkill ( SKILL_TACKLE, 5 ));
  Templates[8].Skills.add ( GetOriginalSkill ( SKILL_CROSS_LOFTED, 5 ));
  Templates[8].Skills.add ( GetOriginalSkill ( SKILL_SHOT_ACCURACY, 5 ));

  Templates[9].Surname := 'incontrista';
  Templates[9].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[9].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[9].Skills.add ( GetOriginalSkill ( SKILL_BALL_CONTROL, 5 ));
  Templates[9].Skills.add ( GetOriginalSkill ( SKILL_TACKLE, 5 ));
  Templates[9].Skills.add ( GetOriginalSkill ( SKILL_INTERCEPTION, 5 ));
  Templates[9].Skills.add ( GetOriginalSkill ( SKILL_REACTION, 5 ));

  Templates[10].Surname := 'regista';
  Templates[10].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[10].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[10].Skills.add ( GetOriginalSkill ( SKILL_BALL_CONTROL, 5 ));
  Templates[10].Skills.add ( GetOriginalSkill ( SKILL_PASS_HIGH, 5 ));
  Templates[10].Skills.add ( GetOriginalSkill ( SKILL_INTERCEPTION, 5 ));
  Templates[10].Skills.add ( GetOriginalSkill ( SKILL_SHOT_ACCURACY, 5 ));


  Templates[11].Surname := 'ccq';
  Templates[11].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[11].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[11].Skills.add ( GetOriginalSkill ( SKILL_BALL_CONTROL, 5 ));
  Templates[11].Skills.add ( GetOriginalSkill ( SKILL_INTERCEPTION, 5 ));
  Templates[11].Skills.add ( GetOriginalSkill ( SKILL_REACTION, 5 ));
  Templates[11].Skills.add ( GetOriginalSkill ( SKILL_SHOT_ACCURACY, 5 ));

  Templates[12].Surname := 'mezzala';
  Templates[12].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[12].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[12].Skills.add ( GetOriginalSkill ( SKILL_BALL_CONTROL, 5 ));
  Templates[12].Skills.add ( GetOriginalSkill ( SKILL_TACKLE, 5 ));
  Templates[12].Skills.add ( GetOriginalSkill ( SKILL_REACTION, 5 ));
  Templates[12].Skills.add ( GetOriginalSkill ( SKILL_SHOT_POWER, 5 ));

  Templates[13].Surname := 'ala invertita';
  Templates[13].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[13].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[13].Skills.add ( GetOriginalSkill ( SKILL_BALL_CONTROL, 5 ));
  Templates[13].Skills.add ( GetOriginalSkill ( SKILL_DRIBBLE, 5 ));
  Templates[13].Skills.add ( GetOriginalSkill ( SKILL_REACTION, 5 ));
  Templates[13].Skills.add ( GetOriginalSkill ( SKILL_SHOT_ACCURACY, 5 ));

  Templates[14].Surname := 'ala';
  Templates[14].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[14].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[14].Skills.add ( GetOriginalSkill ( SKILL_BALL_CONTROL, 5 ));
  Templates[14].Skills.add ( GetOriginalSkill ( SKILL_DRIBBLE, 5 ));
  Templates[14].Skills.add ( GetOriginalSkill ( SKILL_CROSS_DRIVEN, 5 ));
  Templates[14].Skills.add ( GetOriginalSkill ( SKILL_CROSS_LOFTED, 5 ));

  Templates[15].Surname := 'celced';
  Templates[15].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[15].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[15].Skills.add ( GetOriginalSkill ( SKILL_BALL_CONTROL, 5 ));
  Templates[15].Skills.add ( GetOriginalSkill ( SKILL_DRIBBLE, 5 ));
  Templates[15].Skills.add ( GetOriginalSkill ( SKILL_REACTION, 5 ));
  Templates[15].Skills.add ( GetOriginalSkill ( SKILL_TACKLE, 5 ));

  Templates[16].Surname := 'uomoarea';
  Templates[16].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[16].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[16].Skills.add ( GetOriginalSkill ( SKILL_BALL_CONTROL, 5 ));
  Templates[16].Skills.add ( GetOriginalSkill ( SKILL_DRIBBLE, 5 ));
  Templates[16].Skills.add ( GetOriginalSkill ( SKILL_REACTION, 5 ));
  Templates[16].Skills.add ( GetOriginalSkill ( SKILL_SHOT_ACCURACY, 5 ));

  Templates[17].Surname := 'centravanti';
  Templates[17].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[17].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[17].Skills.add ( GetOriginalSkill ( SKILL_BALL_CONTROL, 5 ));
  Templates[17].Skills.add ( GetOriginalSkill ( SKILL_HEADER, 5 ));
  Templates[17].Skills.add ( GetOriginalSkill ( SKILL_REACTION, 5 ));
  Templates[17].Skills.add ( GetOriginalSkill ( SKILL_SHOT_POWER, 5 ));

  Templates[18].Surname := 'seconda punta';
  Templates[18].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[18].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[18].Skills.add ( GetOriginalSkill ( SKILL_BALL_CONTROL, 5 ));
  Templates[18].Skills.add ( GetOriginalSkill ( SKILL_CROSS_DRIVEN, 5 ));
  Templates[18].Skills.add ( GetOriginalSkill ( SKILL_REACTION, 5 ));
  Templates[18].Skills.add ( GetOriginalSkill ( SKILL_SHOT_ACCURACY, 5 ));

  Templates[19].Surname := 'attacante esterno';
  Templates[19].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[19].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[19].Skills.add ( GetOriginalSkill ( SKILL_BALL_CONTROL, 5 ));
  Templates[19].Skills.add ( GetOriginalSkill ( SKILL_DRIBBLE, 5 ));
  Templates[19].Skills.add ( GetOriginalSkill ( SKILL_SHOT_POWER, 5 ));
  Templates[19].Skills.add ( GetOriginalSkill ( SKILL_SHOT_ACCURACY, 5 ));

  Templates[20].Surname := 'torre attacco';
  Templates[20].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[20].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[20].Skills.add ( GetOriginalSkill ( SKILL_HEADER, 5 ));
  Templates[20].Skills.add ( GetOriginalSkill ( SKILL_BALL_CONTROL, 5 ));
  Templates[20].Skills.add ( GetOriginalSkill ( SKILL_DRIBBLE, 5 ));
  Templates[20].Skills.add ( GetOriginalSkill ( SKILL_SHOT_POWER, 5 ));

  Templates[21].Surname := 'regista avanzato ';
  Templates[21].Skills.add ( GetOriginalSkill ( SKILL_RUN, 5 ));
  Templates[21].Skills.add ( GetOriginalSkill ( SKILL_PASS_LOW, 5 ));
  Templates[21].Skills.add ( GetOriginalSkill ( SKILL_REACTION, 5 ));
  Templates[21].Skills.add ( GetOriginalSkill ( SKILL_BALL_CONTROL, 5 ));
  Templates[21].Skills.add ( GetOriginalSkill ( SKILL_DRIBBLE, 5 ));
  Templates[21].Skills.add ( GetOriginalSkill ( SKILL_SHOT_ACCURACY, 5 ));


end.
