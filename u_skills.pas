unit u_skills;

interface

uses
  System.Generics.Collections,
  u_lang;

  const

    STAT_STRENGTH         = 0;
    STAT_TECHNIQUE        = 1;
    STAT_SPEED            = 2;
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
  SKILL_FREE_KICK        = 12;
  SKILL_PENALTY          = 13;
  SKILL_SAVE_LOW         = 14;
  SKILL_SAVE_HIGH        = 15;
  SKILL_GOALKEEPER_RUSH  = 16;
  SKILL_ONE_ON_ONE       = 17;
  SKILL_SHOT_BLOCK       = 18;

  SKILL_COUNT = 19;


// -----------------------------------------------------------------------------
// Mappa SkillId → stringhe localizzate (u_lang)
// -----------------------------------------------------------------------------
const
  STAT_NAMES: array[0..STAT_COUNT - 1] of ^TLangArray = (
    @STR_STAT_STRENGTH,
    @STR_STAT_TECHNIQUE,
    @STR_STAT_SPEED,
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
    @STR_SKILL_FREE_KICK,
    @STR_SKILL_PENALTY,
    @STR_SKILL_SAVE_LOW,
    @STR_SKILL_SAVE_HIGH,
    @STR_SKILL_GOALKEEPER_RUSH,
    @STR_SKILL_ONE_ON_ONE,
    @STR_SKILL_SHOT_BLOCK
  );

type
  TSkill = class
  public
    Id: Integer;
    Level: Integer;
    PreReqStat1: Integer;
    PreReqStat1Value: Integer;

    constructor Create(_Id, _Level, _PreReqStat1, _PreReqStat1Value: Integer); overload;
    constructor CreateFromTemplate(_Id: Integer); overload;

    function GetName: string;
  end;

implementation



// -----------------------------------------------------------------------------
// Storage template
// -----------------------------------------------------------------------------
var
  OriginalSkills: TObjectList<TSkill>;
  SkillId: Integer;
  Lvl: Integer;

{ TSkill }

constructor TSkill.Create(_Id, _Level, _PreReqStat1, _PreReqStat1Value: Integer);
begin
  Id := _Id;
  Level := _Level;
  PreReqStat1 := _PreReqStat1;
  PreReqStat1Value := _PreReqStat1Value;
end;

constructor TSkill.CreateFromTemplate(_Id: Integer);
var
  i: Integer;
  S: TSkill;
begin
  for i := 0 to OriginalSkills.Count - 1 do
  begin
    S := OriginalSkills[i];
    if S.Id = _Id then
    begin
      Id := S.Id;
      Level := S.Level;
      PreReqStat1 := S.PreReqStat1;
      PreReqStat1Value := S.PreReqStat1Value;
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
        TSkill.Create(SkillId, Lvl, 0, 0)
      );

finalization
  OriginalSkills.Free;

end.

