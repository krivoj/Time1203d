unit u_skills;

interface

uses
  System.Generics.Collections,
  u_lang;

  const

    STAT_SPEED            = 0;
    STAT_STRENGTH         = 1;
    STAT_TECHNIQUE        = 2;
    STAT_AGILITY          = 3;
    STAT_INTUITION        = 4;

    STAT_COUNT = 5;

// -----------------------------------------------------------------------------
// Skill ID (ordine IDENTICO a u_lang)
// -----------------------------------------------------------------------------

const
  SKILL_RUN              = 0;
  SKILL_PASS_LOW         = 1;
  SKILL_PASS_HIGH        = 2;
  SKILL_HEADER           = 3;
  SKILL_SHOT_POWER       = 4;
  SKILL_SHOT_ACCURACY    = 5;
  SKILL_DRIBBLE          = 6;
  SKILL_CROSS_DRIVEN     = 7;
  SKILL_CROSS_LOFTED     = 8;
  SKILL_TACKLE           = 9;
  SKILL_BALL_CONTROL     = 10;
  SKILL_INTERCEPTION     = 11;
  SKILL_SAVE_LOW         = 12;
  SKILL_SAVE_HIGH        = 13;
  SKILL_GOALKEEPER_RUSH  = 14;
  SKILL_ONE_ON_ONE       = 15;
  SKILL_SHOT_BLOCK       = 16;
  SKILL_REACTION         = 17;

  SKILL_COUNT = 18;


// -----------------------------------------------------------------------------
// Mappa SkillId → stringhe localizzate (u_lang)
// -----------------------------------------------------------------------------
const
  STAT_NAMES: array[0..STAT_COUNT - 1] of ^TLangArray = (
    @STR_STAT_SPEED,
    @STR_STAT_STRENGTH,
    @STR_STAT_TECHNIQUE,
    @STR_STAT_AGILITY,
    @STR_STAT_INTUITION
  );
//     ShowMessage(L(STAT_NAMES[STRENGTH]^));
const
  SKILL_NAMES: array[0..SKILL_COUNT - 1] of ^TLangArray = (
    @STR_SKILL_RUN,
    @STR_SKILL_PASS_LOW,
    @STR_SKILL_PASS_HIGH,
    @STR_SKILL_HEADER,
    @STR_SKILL_SHOT_POWER,
    @STR_SKILL_SHOT_ACCURACY,
    @STR_SKILL_DRIBBLE,
    @STR_SKILL_CROSS_DRIVEN,
    @STR_SKILL_CROSS_LOFTED,
    @STR_SKILL_TACKLE,
    @STR_SKILL_BALL_CONTROL,
    @STR_SKILL_INTERCEPTION,
    @STR_SKILL_SAVE_LOW,
    @STR_SKILL_SAVE_HIGH,
    @STR_SKILL_GOALKEEPER_RUSH,
    @STR_SKILL_ONE_ON_ONE,
    @STR_SKILL_SHOT_BLOCK,
    @STR_SKILL_REACTION
  );

type
  TSkill = class
  public
    Id: Integer;
    Level: Integer;
    PreReqStat: Integer;

    constructor Create(_Id, _Level : Integer);
    constructor CopyFromTemplate(_Id, Lvl: Integer);

    function GetName: string;
  end;

  function GetOriginalSkill ( _id, _Level: integer ): TSkill;
implementation

// -----------------------------------------------------------------------------
// Storage template
// -----------------------------------------------------------------------------
var
  OriginalSkills: TObjectList<TSkill>;
  SkillId: Integer;
  Lvl: Integer;
  I: integer;

function GetOriginalSkill ( _id, _Level: integer ): TSkill;
var
  I: integer;
begin
  for I := 0 to OriginalSkills.Count -1 do
  begin
    if (OriginalSkills[I].Id = _Id) and (OriginalSkills[I].Level= Lvl) then begin
      Result := OriginalSkills[I];
      Exit;
    end;
  end;
end;

{ TSkill }

constructor TSkill.Create(_Id, _Level : Integer);
begin
  Id := _Id;
  Level := _Level;
end;

constructor TSkill.CopyFromTemplate(_Id, Lvl: Integer);
var
  i: Integer;
  S: TSkill;
begin
  for i := 0 to OriginalSkills.Count - 1 do
  begin
    S := OriginalSkills[i];
    if (S.Id = _Id) and (S.Level= Lvl) then
    begin
      Id := S.Id;
      Level := S.Level;
      PreReqStat := S.PreReqStat;
      Exit;
    end;
  end;
end;

// Nome localizzato (collegato a u_lang)
function TSkill.GetName: string;
begin
  Result := L(SKILL_NAMES[Id]^);
end;

// -----------------------------------------------------------------------------
// Initialization
// -----------------------------------------------------------------------------
initialization
  OriginalSkills := TObjectList<TSkill>.Create(True);

  // Per ogni skill → livelli 1..5
  for SkillId := 0 to SKILL_COUNT - 1 do
    for Lvl := 1 to 5 do
      OriginalSkills.Add(
        TSkill.Create(SkillId, Lvl, 0 )
      );

  // Setto la prereqStat
  for I := 0 to OriginalSkills.Count -1 do
  begin
    case OriginalSkills[I].Id of
      SKILL_RUN: OriginalSkills[I].PreReqStat             := STAT_SPEED;
      SKILL_PASS_LOW: OriginalSkills[I].PreReqStat        := STAT_TECHNIQUE;
      SKILL_PASS_HIGH: OriginalSkills[I].PreReqStat       := STAT_TECHNIQUE;
      SKILL_HEADER: OriginalSkills[I].PreReqStat          := STAT_STRENGTH;
      SKILL_SHOT_POWER: OriginalSkills[I].PreReqStat      := STAT_STRENGTH;
      SKILL_SHOT_ACCURACY: OriginalSkills[I].PreReqStat   := STAT_TECHNIQUE;
      SKILL_DRIBBLE: OriginalSkills[I].PreReqStat         := STAT_AGILITY;
      SKILL_CROSS_DRIVEN: OriginalSkills[I].PreReqStat    := STAT_TECHNIQUE;
      SKILL_CROSS_LOFTED: OriginalSkills[I].PreReqStat    := STAT_TECHNIQUE;
      SKILL_TACKLE: OriginalSkills[I].PreReqStat          := STAT_STRENGTH;
      SKILL_BALL_CONTROL: OriginalSkills[I].PreReqStat    := STAT_AGILITY;
      SKILL_INTERCEPTION: OriginalSkills[I].PreReqStat    := STAT_INTUITION;
      SKILL_SAVE_LOW: OriginalSkills[I].PreReqStat        := STAT_INTUITION;
      SKILL_SAVE_HIGH: OriginalSkills[I].PreReqStat       := STAT_AGILITY;
      SKILL_GOALKEEPER_RUSH: OriginalSkills[I].PreReqStat := STAT_SPEED;
      SKILL_ONE_ON_ONE: OriginalSkills[I].PreReqStat      := STAT_TECHNIQUE;
      SKILL_SHOT_BLOCK: OriginalSkills[I].PreReqStat      := STAT_INTUITION;
      SKILL_REACTION: OriginalSkills[I].PreReqStat        := STAT_AGILITY;
    end;
  end;

{    STAT_SPEED            = 0;
    STAT_STRENGTH         = 1;
    STAT_TECHNIQUE        = 2;
    STAT_AGILITY          = 3;
    STAT_INTUITION        = 4; }


finalization
  OriginalSkills.Free;

end.

