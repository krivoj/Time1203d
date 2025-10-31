unit u_Traits;

interface


  type TTraitTree = record
    Name: string;
    level : integer;
    preReqStat1 :integer;  // es. playmaker almeno passaggi=12
    preReqStat1value: integer;
    preReqTrait1 :integer;//  es. volley2 almeno volley1. a sua volta volley almeno 12  oppure prereq0 skip
  end;

  const NUM_STATS                = 17; // totale attributi player // max127
  const Speed = 0;
  const Marking = 1;
  const Tackling = 2;
  const BallControl = 3;
  const Passing = 4;
  const Shot = 5;
  const Crossing = 6;
  const Heading = 7;

  const Workrate= 8;
  const Determination= 9;
  const Bravery= 10;
  const Intuition= 11;

  const Strenght= 12;
  const Agility= 13;
  const Technique= 14;

  const RushingOut= 15;
  const ShotStopping= 16;

  //num_trait --> soccertypes.pas max 127
  const NUM_TRAITS               = 58; // totale traits           // max 127

  const TRAIT_GOALKEEPER     = 1;  // può giocare in porta
  const TRAIT_AUTOTACKLE_STRENGHT = 2; //  anOpponent
  const TRAIT_AUTOTACKLE_STRENGHT2 = 3; //
  const TRAIT_AUTOTACKLE_AGILITY = 4; //   aPlayer
  const TRAIT_AUTOTACKLE_AGILITY2 = 5; //
  const TRAIT_AUTOTACKLE_TACKLING = 6; //  anOpponent
  const TRAIT_AUTOTACKLE_TACKLING2 = 7; //
  const TRAIT_AUTOTACKLE_TECHNIQUE = 8; // aPlayer
  const TRAIT_AUTOTACKLE_TECHNIQUE2 = 9; //

  //lowpass strenght---> intercept passing-intuition, technique-agility, self determination
  const TRAIT_LOWPASS_TECHNIQUE = 10;   // aPlayer
  const TRAIT_LOWPASS_TECHNIQUE2 = 11;
  const TRAIT_LOWPASS_INTUITION = 12;     // anOpponent
  const TRAIT_LOWPASS_INTUITION2 = 13;

  //dribbling BallControl-Intuition, Agility-.Stat[Marking], TechniqueTackling
  const TRAIT_DRIBBLING_BALLCONTROL  = 14; // aPlayer
  const TRAIT_DRIBBLING_BALLCONTROL2 = 15; //
  const TRAIT_DRIBBLING_AGILITY      = 16; // aPlayer
  const TRAIT_DRIBBLING_AGILITY2     = 17; //
  const TRAIT_DRIBBLING_TECHNIQUE    = 18; // aPlayer
  const TRAIT_DRIBBLING_TECHNIQUE2   = 19; //
  const TRAIT_DRIBBLING_INTUITION    = 20; // anOpponent
  const TRAIT_DRIBBLING_INTUITION2   = 21; //
  const TRAIT_DRIBBLING_MARKING      = 22; // anOpponent
  const TRAIT_DRIBBLING_MARKING2     = 23; //
  const TRAIT_DRIBBLING_TACKLING     = 24; // anOpponent
  const TRAIT_DRIBBLING_TACKLING2    = 25; //

  //loftedPass strenght --> passing-intuition, ballcontrol-.Stat[Marking], technique,agility     bounce---> intuition-intuition, workrate-workrate,agility,agility
  const TRAIT_LOFTEDPASS_TECHNIQUE    = 26; // aPlayer
  const TRAIT_LOFTEDPASS_TECHNIQUE2   = 27; //
  const TRAIT_LOFTEDPASS_MARKING      = 28; // anOpponent
  const TRAIT_LOFTEDPASS_MARKING2     = 29; //
  const TRAIT_LOFTEDPASS_BALLCONTROL  = 30; // aFriend
  const TRAIT_LOFTEDPASS_BALLCONTROL2 = 31; //
  const TRAIT_LOFTEDPASS_INTUITION = 32;   // anOpponent
  const TRAIT_LOFTEDPASS_INTUITION2 = 33;

 { TODO : da qui in poi metterli in telentup o traitup adesso}

//cross strenght --> crossing-intuition, heading-heading, bravery,strenght  gol-->intuition,shotStopping,agility
  // bounce---> intuition-intuition   talento opportunista
// solo se celle 0 e 16: gk=intuition, rushingout (presa,respinta,fuori porta)
  const TRAIT_CROSS_TECHNIQUE  = 34;
  const TRAIT_CROSS_TECHNIQUE2  = 35;
  const TRAIT_CROSS_INTUITION  = 36; // più intuito per intercettare i cross
  const TRAIT_CROSS_INTUITION2 = 37; //

  const TRAIT_AGGRESSION     = 38; // cerca il portatore di palla
  const TRAIT_AGGRESSION2    = 39; // fa pressing automatico sul portatore di palla se lo raggiunge. 25% chance.
  const TRAIT_PRESSING         = 40; // pressing non costa mosse.
  const TRAIT_PRESSING2        = 41; //  --> pressing costa in stamina cpst_pre - 1

  const TRAIT_FINISHING      = 42; // Quando ottiene la palla dopo un rimbalzo da lop,cross,pos e prs failed ha +3 Tiro. Opportunista.
  const TRAIT_FINISHING2     = 43; //
  const TRAIT_VOLLEY            = 44; // +3 strenght a volley
  const TRAIT_VOLLEY2           = 45; // +3 strenght a volley

  const TRAIT_BOMB               = 46; // +3 Strength quando si buffa con corsa o riceve lowpass o vince tackle o vince dribbling
  const TRAIT_BOMB2              = 47; // +3 Strength quando si buffa con corsa o riceve lowpass o vince tackle o vince dribbling
  const TRAIT_PLAYMAKER      = 48; // Cerca di avvicinarsi al proprio portatore di palla.
  const TRAIT_POSITIONING    = 49; // Cerca di tornare verso la propria zona di campo. TRAIT2 offensive=ala o centravanti TRAIT2 defensive=chiude le fascie o il centro
  const TRAIT_FREEKICKS      = 50; // +3 Tiro sui Calci di punizione e rigori.
  const TRAIT_EXPERIENCE     = 51; // Quando riceve un passaggio basso distante almeno 2 celle, non costa mosse.
  const TRAIT_RAPIDPASSING   = 52; // il 33% chance di effettuare un passaggio verso un compagno dopo un passaggio basso. non può essere intercettato
  const TRAIT_ACE            = 53; // Ha il 33% chance di effettuare un dribbling vincente quando subisce pressing
  const TRAIT_DIVING         = 54; // +10% chance di subire un fallo durante i tackle.
  const TRAIT_RUNNER         = 55; // se sulla fascia non si applica il malus al movimento con la palla.

  const TRAIT_BUFF_DEFENSE = 56; // prereq  workrate bravery --> skill 2x buff reparto (5% chance) dif 20 turni + defense ballcontrol passing  +1
  const TRAIT_BUFF_MIDDLE = 57; // prereq   workrate passing --> skill 2x buff reparto (5% chance) cen  20 turni + speed max 4,ballcontrol,passing ,shot +1
  const TRAIT_BUFF_FORWARD = 58; // prereq  workrate shot  --> skill 2x buff reparto (5% chance) att 20 turni + ballcontrol, passing,shot +1

var
  TraitTree : Array [1..NUM_TRAITS] of TTraitTree;

implementation

initialization
  TraitTree[TRAIT_GOALKEEPER].Name := 'TRAIT_GOALKEEPER';
  TraitTree[TRAIT_GOALKEEPER].level := 1;
  TraitTree[TRAIT_GOALKEEPER].preReqStat1 := 0;
  TraitTree[TRAIT_GOALKEEPER].preReqTrait1 := 0;

  TraitTree[TRAIT_AUTOTACKLE_STRENGHT].Name := 'TRAIT_AUTOTACKLE_STRENGHT';
  TraitTree[TRAIT_AUTOTACKLE_STRENGHT].level := 1;
  TraitTree[TRAIT_AUTOTACKLE_STRENGHT].preReqStat1 := strenght;
  TraitTree[TRAIT_AUTOTACKLE_STRENGHT].preReqStat1value := 11;
  TraitTree[TRAIT_AUTOTACKLE_STRENGHT].preReqTrait1 := 0;

  TraitTree[TRAIT_AUTOTACKLE_STRENGHT2].Name := 'TRAIT_AUTOTACKLE_STRENGHT2';
  TraitTree[TRAIT_AUTOTACKLE_STRENGHT2].level := 2;
  TraitTree[TRAIT_AUTOTACKLE_STRENGHT2].preReqStat1 := strenght;
  TraitTree[TRAIT_AUTOTACKLE_STRENGHT2].preReqStat1value := 11;
  TraitTree[TRAIT_AUTOTACKLE_STRENGHT2].preReqTrait1 := TRAIT_AUTOTACKLE_STRENGHT;

  TraitTree[TRAIT_AUTOTACKLE_AGILITY].Name := 'TRAIT_AUTOTACKLE_AGILITY';
  TraitTree[TRAIT_AUTOTACKLE_AGILITY].level := 1;
  TraitTree[TRAIT_AUTOTACKLE_AGILITY].preReqStat1 := agility;
  TraitTree[TRAIT_AUTOTACKLE_AGILITY].preReqStat1value := 11;
  TraitTree[TRAIT_AUTOTACKLE_AGILITY].preReqTrait1 := 0;

  TraitTree[TRAIT_AUTOTACKLE_AGILITY2].Name := 'TRAIT_AUTOTACKLE_AGILITY2';
  TraitTree[TRAIT_AUTOTACKLE_AGILITY2].level := 2;
  TraitTree[TRAIT_AUTOTACKLE_AGILITY2].preReqStat1 := agility;
  TraitTree[TRAIT_AUTOTACKLE_AGILITY2].preReqStat1value := 11;
  TraitTree[TRAIT_AUTOTACKLE_AGILITY2].preReqTrait1 := TRAIT_AUTOTACKLE_AGILITY;

  TraitTree[TRAIT_AUTOTACKLE_TACKLING].Name := 'TRAIT_AUTOTACKLE_TACKLING';
  TraitTree[TRAIT_AUTOTACKLE_TACKLING].level := 1;
  TraitTree[TRAIT_AUTOTACKLE_TACKLING].preReqStat1 := tackling;
  TraitTree[TRAIT_AUTOTACKLE_TACKLING].preReqStat1value := 11;
  TraitTree[TRAIT_AUTOTACKLE_TACKLING].preReqTrait1 := 0;

  TraitTree[TRAIT_AUTOTACKLE_TACKLING2].Name := 'TRAIT_AUTOTACKLE_TACKLING2';
  TraitTree[TRAIT_AUTOTACKLE_TACKLING2].level := 2;
  TraitTree[TRAIT_AUTOTACKLE_TACKLING2].preReqStat1 := tackling;
  TraitTree[TRAIT_AUTOTACKLE_TACKLING2].preReqStat1value := 11;
  TraitTree[TRAIT_AUTOTACKLE_TACKLING2].preReqTrait1 := TRAIT_AUTOTACKLE_TACKLING;

  TraitTree[TRAIT_AUTOTACKLE_TECHNIQUE].Name := 'TRAIT_AUTOTACKLE_TECHNIQUE';
  TraitTree[TRAIT_AUTOTACKLE_TECHNIQUE].level := 1;
  TraitTree[TRAIT_AUTOTACKLE_TECHNIQUE].preReqStat1 := TECHNIQUE;
  TraitTree[TRAIT_AUTOTACKLE_TECHNIQUE].preReqStat1value := 11;
  TraitTree[TRAIT_AUTOTACKLE_TECHNIQUE].preReqTrait1 := 0;

  TraitTree[TRAIT_AUTOTACKLE_TECHNIQUE2].Name := 'TRAIT_AUTOTACKLE_TECHNIQUE2';
  TraitTree[TRAIT_AUTOTACKLE_TECHNIQUE2].level := 2;
  TraitTree[TRAIT_AUTOTACKLE_TECHNIQUE2].preReqStat1 := TECHNIQUE;
  TraitTree[TRAIT_AUTOTACKLE_TECHNIQUE2].preReqStat1value := 11;
  TraitTree[TRAIT_AUTOTACKLE_TECHNIQUE2].preReqTrait1 := TRAIT_AUTOTACKLE_TECHNIQUE;


  TraitTree[TRAIT_LOWPASS_TECHNIQUE].Name := 'TRAIT_LOWPASS_TECHNIQUE';
  TraitTree[TRAIT_LOWPASS_TECHNIQUE].level := 1;
  TraitTree[TRAIT_LOWPASS_TECHNIQUE].preReqStat1 := TECHNIQUE;
  TraitTree[TRAIT_LOWPASS_TECHNIQUE].preReqStat1value := 11;
  TraitTree[TRAIT_LOWPASS_TECHNIQUE].preReqTrait1 := 0;

  TraitTree[TRAIT_LOWPASS_TECHNIQUE2].Name := 'TRAIT_LOWPASS_TECHNIQUE2';
  TraitTree[TRAIT_LOWPASS_TECHNIQUE2].level := 2;
  TraitTree[TRAIT_LOWPASS_TECHNIQUE2].preReqStat1 := TECHNIQUE;
  TraitTree[TRAIT_LOWPASS_TECHNIQUE2].preReqStat1value := 11;
  TraitTree[TRAIT_LOWPASS_TECHNIQUE2].preReqTrait1 := TRAIT_LOWPASS_TECHNIQUE;


  TraitTree[TRAIT_LOWPASS_INTUITION].Name := 'TRAIT_LOWPASS_INTUITION';
  TraitTree[TRAIT_LOWPASS_INTUITION].level := 1;
  TraitTree[TRAIT_LOWPASS_INTUITION].preReqStat1 := intuition;
  TraitTree[TRAIT_LOWPASS_INTUITION].preReqStat1value := 11;
  TraitTree[TRAIT_LOWPASS_INTUITION].preReqTrait1 := 0;

  TraitTree[TRAIT_LOWPASS_INTUITION2].Name := 'TRAIT_LOWPASS_INTUITION2';
  TraitTree[TRAIT_LOWPASS_INTUITION2].level := 2;
  TraitTree[TRAIT_LOWPASS_INTUITION2].preReqStat1 := intuition;
  TraitTree[TRAIT_LOWPASS_INTUITION2].preReqStat1value := 11;
  TraitTree[TRAIT_LOWPASS_INTUITION2].preReqTrait1 := TRAIT_LOWPASS_INTUITION;



  TraitTree[TRAIT_DRIBBLING_BALLCONTROL].Name := 'TRAIT_DRIBBLING_BALLCONTROL';
  TraitTree[TRAIT_DRIBBLING_BALLCONTROL].level := 1;
  TraitTree[TRAIT_DRIBBLING_BALLCONTROL].preReqStat1 := ballcontrol;
  TraitTree[TRAIT_DRIBBLING_BALLCONTROL].preReqStat1value := 11;
  TraitTree[TRAIT_DRIBBLING_BALLCONTROL].preReqTrait1 := 0;

  TraitTree[TRAIT_DRIBBLING_BALLCONTROL2].Name := 'TRAIT_DRIBBLING_BALLCONTROL2';
  TraitTree[TRAIT_DRIBBLING_BALLCONTROL2].level := 2;
  TraitTree[TRAIT_DRIBBLING_BALLCONTROL2].preReqStat1 := ballcontrol;
  TraitTree[TRAIT_DRIBBLING_BALLCONTROL2].preReqStat1value := 11;
  TraitTree[TRAIT_DRIBBLING_BALLCONTROL2].preReqTrait1 := TRAIT_DRIBBLING_BALLCONTROL;

  TraitTree[TRAIT_DRIBBLING_AGILITY].Name := 'TRAIT_DRIBBLING_AGILITY';
  TraitTree[TRAIT_DRIBBLING_AGILITY].level := 1;
  TraitTree[TRAIT_DRIBBLING_AGILITY].preReqStat1 := AGILITY;
  TraitTree[TRAIT_DRIBBLING_AGILITY].preReqStat1value := 11;
  TraitTree[TRAIT_DRIBBLING_AGILITY].preReqTrait1 := 0;

  TraitTree[TRAIT_DRIBBLING_AGILITY2].Name := 'TRAIT_DRIBBLING_AGILITY2';
  TraitTree[TRAIT_DRIBBLING_AGILITY2].level := 2;
  TraitTree[TRAIT_DRIBBLING_AGILITY2].preReqStat1 := AGILITY;
  TraitTree[TRAIT_DRIBBLING_AGILITY2].preReqStat1value := 11;
  TraitTree[TRAIT_DRIBBLING_AGILITY2].preReqTrait1 := TRAIT_DRIBBLING_AGILITY;


  TraitTree[TRAIT_DRIBBLING_TECHNIQUE].Name := 'TRAIT_DRIBBLING_TECHNIQUE';
  TraitTree[TRAIT_DRIBBLING_TECHNIQUE].level := 1;
  TraitTree[TRAIT_DRIBBLING_TECHNIQUE].preReqStat1 := TECHNIQUE;
  TraitTree[TRAIT_DRIBBLING_TECHNIQUE].preReqStat1value := 11;
  TraitTree[TRAIT_DRIBBLING_TECHNIQUE].preReqTrait1 := 0;

  TraitTree[TRAIT_DRIBBLING_TECHNIQUE2].Name := 'TRAIT_DRIBBLING_TECHNIQUE2';
  TraitTree[TRAIT_DRIBBLING_TECHNIQUE2].level := 2;
  TraitTree[TRAIT_DRIBBLING_TECHNIQUE2].preReqStat1 := TECHNIQUE;
  TraitTree[TRAIT_DRIBBLING_TECHNIQUE2].preReqStat1value := 11;
  TraitTree[TRAIT_DRIBBLING_TECHNIQUE2].preReqTrait1 := TRAIT_DRIBBLING_TECHNIQUE;


  TraitTree[TRAIT_DRIBBLING_INTUITION].Name := 'TRAIT_DRIBBLING_INTUITION';
  TraitTree[TRAIT_DRIBBLING_INTUITION].level := 1;
  TraitTree[TRAIT_DRIBBLING_INTUITION].preReqStat1 := INTUITION;
  TraitTree[TRAIT_DRIBBLING_INTUITION].preReqStat1value := 11;
  TraitTree[TRAIT_DRIBBLING_INTUITION].preReqTrait1 := 0;

  TraitTree[TRAIT_DRIBBLING_INTUITION2].Name := 'TRAIT_DRIBBLING_INTUITION2';
  TraitTree[TRAIT_DRIBBLING_INTUITION2].level := 2;
  TraitTree[TRAIT_DRIBBLING_INTUITION2].preReqStat1 := INTUITION;
  TraitTree[TRAIT_DRIBBLING_INTUITION2].preReqStat1value := 11;
  TraitTree[TRAIT_DRIBBLING_INTUITION2].preReqTrait1 := TRAIT_DRIBBLING_INTUITION;

  TraitTree[TRAIT_DRIBBLING_MARKING].Name := 'TRAIT_DRIBBLING_MARKING';
  TraitTree[TRAIT_DRIBBLING_MARKING].level := 1;
  TraitTree[TRAIT_DRIBBLING_MARKING].preReqStat1 := MARKING;
  TraitTree[TRAIT_DRIBBLING_MARKING].preReqStat1value := 11;
  TraitTree[TRAIT_DRIBBLING_MARKING].preReqTrait1 := 0;

  TraitTree[TRAIT_DRIBBLING_MARKING2].Name := 'TRAIT_DRIBBLING_MARKING2';
  TraitTree[TRAIT_DRIBBLING_MARKING2].level := 2;
  TraitTree[TRAIT_DRIBBLING_MARKING2].preReqStat1 := MARKING;
  TraitTree[TRAIT_DRIBBLING_MARKING2].preReqStat1value := 11;
  TraitTree[TRAIT_DRIBBLING_MARKING2].preReqTrait1 := TRAIT_DRIBBLING_MARKING;


  TraitTree[TRAIT_DRIBBLING_TACKLING].Name := 'TRAIT_DRIBBLING_TACKLING';
  TraitTree[TRAIT_DRIBBLING_TACKLING].level := 1;
  TraitTree[TRAIT_DRIBBLING_TACKLING].preReqStat1 := TACKLING;
  TraitTree[TRAIT_DRIBBLING_TACKLING].preReqStat1value := 11;
  TraitTree[TRAIT_DRIBBLING_TACKLING].preReqTrait1 := 0;

  TraitTree[TRAIT_DRIBBLING_TACKLING2].Name := 'TRAIT_DRIBBLING_TACKLING2';
  TraitTree[TRAIT_DRIBBLING_TACKLING2].level := 2;
  TraitTree[TRAIT_DRIBBLING_TACKLING2].preReqStat1 := TACKLING;
  TraitTree[TRAIT_DRIBBLING_TACKLING2].preReqStat1value := 11;
  TraitTree[TRAIT_DRIBBLING_TACKLING2].preReqTrait1 := TRAIT_DRIBBLING_TACKLING;

  TraitTree[TRAIT_LOFTEDPASS_TECHNIQUE].Name := 'TRAIT_LOFTEDPASS_TECHNIQUE';
  TraitTree[TRAIT_LOFTEDPASS_TECHNIQUE].level := 1;
  TraitTree[TRAIT_LOFTEDPASS_TECHNIQUE].preReqStat1 := TECHNIQUE;
  TraitTree[TRAIT_LOFTEDPASS_TECHNIQUE].preReqStat1value := 11;
  TraitTree[TRAIT_LOFTEDPASS_TECHNIQUE].preReqTrait1 := 0;

  TraitTree[TRAIT_LOFTEDPASS_TECHNIQUE2].Name := 'TRAIT_LOFTEDPASS_TECHNIQUE2';
  TraitTree[TRAIT_LOFTEDPASS_TECHNIQUE2].level := 2;
  TraitTree[TRAIT_LOFTEDPASS_TECHNIQUE2].preReqStat1 := TECHNIQUE;
  TraitTree[TRAIT_LOFTEDPASS_TECHNIQUE2].preReqStat1value := 11;
  TraitTree[TRAIT_LOFTEDPASS_TECHNIQUE2].preReqTrait1 := TRAIT_LOFTEDPASS_TECHNIQUE;


  TraitTree[TRAIT_LOFTEDPASS_MARKING].Name := 'TRAIT_LOFTEDPASS_MARKING';
  TraitTree[TRAIT_LOFTEDPASS_MARKING].level := 1;
  TraitTree[TRAIT_LOFTEDPASS_MARKING].preReqStat1 := MARKING;
  TraitTree[TRAIT_LOFTEDPASS_MARKING].preReqStat1value := 11;
  TraitTree[TRAIT_LOFTEDPASS_MARKING].preReqTrait1 := 0;

  TraitTree[TRAIT_LOFTEDPASS_MARKING2].Name := 'TRAIT_LOFTEDPASS_MARKING2';
  TraitTree[TRAIT_LOFTEDPASS_MARKING2].level := 2;
  TraitTree[TRAIT_LOFTEDPASS_MARKING2].preReqStat1 := MARKING;
  TraitTree[TRAIT_LOFTEDPASS_MARKING2].preReqStat1value := 11;
  TraitTree[TRAIT_LOFTEDPASS_MARKING2].preReqTrait1 := TRAIT_LOFTEDPASS_MARKING;

  TraitTree[TRAIT_LOFTEDPASS_BALLCONTROL].Name := 'TRAIT_LOFTEDPASS_BALLCONTROL';
  TraitTree[TRAIT_LOFTEDPASS_BALLCONTROL].level := 1;
  TraitTree[TRAIT_LOFTEDPASS_BALLCONTROL].preReqStat1 := BALLCONTROL;
  TraitTree[TRAIT_LOFTEDPASS_BALLCONTROL].preReqStat1value := 11;
  TraitTree[TRAIT_LOFTEDPASS_BALLCONTROL].preReqTrait1 := 0;

  TraitTree[TRAIT_LOFTEDPASS_BALLCONTROL2].Name := 'TRAIT_LOFTEDPASS_BALLCONTROL2';
  TraitTree[TRAIT_LOFTEDPASS_BALLCONTROL2].level := 2;
  TraitTree[TRAIT_LOFTEDPASS_BALLCONTROL2].preReqStat1 := BALLCONTROL;
  TraitTree[TRAIT_LOFTEDPASS_BALLCONTROL2].preReqStat1value := 11;
  TraitTree[TRAIT_LOFTEDPASS_BALLCONTROL2].preReqTrait1 := TRAIT_LOFTEDPASS_BALLCONTROL;

  TraitTree[TRAIT_LOFTEDPASS_INTUITION].Name := 'TRAIT_LOFTEDPASS_INTUITION';
  TraitTree[TRAIT_LOFTEDPASS_INTUITION].level := 1;
  TraitTree[TRAIT_LOFTEDPASS_INTUITION].preReqStat1 := INTUITION;
  TraitTree[TRAIT_LOFTEDPASS_INTUITION].preReqStat1value := 11;
  TraitTree[TRAIT_LOFTEDPASS_INTUITION].preReqTrait1 := 0;

  TraitTree[TRAIT_LOFTEDPASS_INTUITION2].Name := 'TRAIT_LOFTEDPASS_INTUITION2';
  TraitTree[TRAIT_LOFTEDPASS_INTUITION2].level := 2;
  TraitTree[TRAIT_LOFTEDPASS_INTUITION2].preReqStat1 := INTUITION;
  TraitTree[TRAIT_LOFTEDPASS_INTUITION2].preReqStat1value := 11;
  TraitTree[TRAIT_LOFTEDPASS_INTUITION2].preReqTrait1 := TRAIT_LOFTEDPASS_INTUITION;



  TraitTree[TRAIT_FINISHING].Name := 'TRAIT_FINISHING';
  TraitTree[TRAIT_FINISHING].level := 1;
  TraitTree[TRAIT_FINISHING].preReqStat1 := INTUITION;
  TraitTree[TRAIT_FINISHING].preReqStat1value := 11;
  TraitTree[TRAIT_FINISHING].preReqTrait1 := 0;

  TraitTree[TRAIT_FINISHING2].Name := 'TRAIT_FINISHING2';
  TraitTree[TRAIT_FINISHING2].level := 2;
  TraitTree[TRAIT_FINISHING2].preReqStat1 := INTUITION;
  TraitTree[TRAIT_FINISHING2].preReqStat1value := 11;
  TraitTree[TRAIT_FINISHING2].preReqTrait1 := TRAIT_FINISHING;

  TraitTree[TRAIT_VOLLEY].Name := 'TRAIT_VOLLEY';
  TraitTree[TRAIT_VOLLEY].level := 1;
  TraitTree[TRAIT_VOLLEY].preReqStat1 := SHOT;
  TraitTree[TRAIT_VOLLEY].preReqStat1value := 11;
  TraitTree[TRAIT_VOLLEY].preReqTrait1 := 0;

  TraitTree[TRAIT_VOLLEY2].Name := 'TRAIT_VOLLEY2';
  TraitTree[TRAIT_VOLLEY2].level := 2;
  TraitTree[TRAIT_VOLLEY2].preReqStat1 := SHOT;
  TraitTree[TRAIT_VOLLEY2].preReqStat1value := 11;
  TraitTree[TRAIT_VOLLEY2].preReqTrait1 := TRAIT_VOLLEY;

  TraitTree[TRAIT_CROSS_TECHNIQUE].Name := 'TRAIT_CROSS_TECHNIQUE';
  TraitTree[TRAIT_CROSS_TECHNIQUE].level := 1;
  TraitTree[TRAIT_CROSS_TECHNIQUE].preReqStat1 := Crossing;
  TraitTree[TRAIT_CROSS_TECHNIQUE].preReqStat1value := 11;
  TraitTree[TRAIT_CROSS_TECHNIQUE].preReqTrait1 := 0;

  TraitTree[TRAIT_CROSS_TECHNIQUE2].Name := 'TRAIT_CROSS_TECHNIQUE2';
  TraitTree[TRAIT_CROSS_TECHNIQUE2].level := 2;
  TraitTree[TRAIT_CROSS_TECHNIQUE2].preReqStat1 := Crossing;
  TraitTree[TRAIT_CROSS_TECHNIQUE2].preReqStat1value := 11;
  TraitTree[TRAIT_CROSS_TECHNIQUE2].preReqTrait1 := TRAIT_CROSS_TECHNIQUE;

  TraitTree[TRAIT_CROSS_INTUITION].Name := 'TRAIT_CROSS_INTUITION';
  TraitTree[TRAIT_CROSS_INTUITION].level := 1;
  TraitTree[TRAIT_CROSS_INTUITION].preReqStat1 := Intuition;
  TraitTree[TRAIT_CROSS_INTUITION].preReqStat1value := 11;
  TraitTree[TRAIT_CROSS_INTUITION].preReqTrait1 := 0;

  TraitTree[TRAIT_CROSS_INTUITION2].Name := 'TRAIT_CROSS_INTUITION2';
  TraitTree[TRAIT_CROSS_INTUITION2].level := 2;
  TraitTree[TRAIT_CROSS_INTUITION2].preReqStat1 := Intuition;
  TraitTree[TRAIT_CROSS_INTUITION2].preReqStat1value := 11;
  TraitTree[TRAIT_CROSS_INTUITION2].preReqTrait1 := TRAIT_CROSS_INTUITION;

  TraitTree[TRAIT_BOMB].Name := 'TRAIT_BOMB';
  TraitTree[TRAIT_BOMB].level := 1;
  TraitTree[TRAIT_BOMB].preReqStat1 := SHOT;
  TraitTree[TRAIT_BOMB].preReqStat1value := 11;
  TraitTree[TRAIT_BOMB].preReqTrait1 := 0;

  TraitTree[TRAIT_BOMB2].Name := 'TRAIT_BOMB2';
  TraitTree[TRAIT_BOMB2].level := 2;
  TraitTree[TRAIT_BOMB2].preReqStat1 := SHOT;
  TraitTree[TRAIT_BOMB2].preReqStat1value := 11;
  TraitTree[TRAIT_BOMB2].preReqTrait1 := TRAIT_BOMB;


  TraitTree[TRAIT_AGGRESSION].Name := 'TRAIT_AGGRESSION';
  TraitTree[TRAIT_AGGRESSION].level := 1;
  TraitTree[TRAIT_AGGRESSION].preReqStat1 := workrate;
  TraitTree[TRAIT_AGGRESSION].preReqStat1value := 11;
  TraitTree[TRAIT_AGGRESSION].preReqTrait1 := 0;

  TraitTree[TRAIT_AGGRESSION2].Name := 'TRAIT_AGGRESSION2';
  TraitTree[TRAIT_AGGRESSION2].level := 2;
  TraitTree[TRAIT_AGGRESSION2].preReqStat1 := workrate;
  TraitTree[TRAIT_AGGRESSION2].preReqStat1value := 11;
  TraitTree[TRAIT_AGGRESSION2].preReqTrait1 := TRAIT_AGGRESSION;

  TraitTree[TRAIT_PRESSING].Name := 'TRAIT_PRESSING';
  TraitTree[TRAIT_PRESSING].level := 1;
  TraitTree[TRAIT_PRESSING].preReqStat1 := workrate;
  TraitTree[TRAIT_PRESSING].preReqStat1value := 11;
  TraitTree[TRAIT_PRESSING].preReqTrait1 := 0;

  TraitTree[TRAIT_PRESSING2].Name := 'TRAIT_PRESSING2';
  TraitTree[TRAIT_PRESSING2].level := 2;
  TraitTree[TRAIT_PRESSING2].preReqStat1 := workrate;
  TraitTree[TRAIT_PRESSING2].preReqStat1value := 11;
  TraitTree[TRAIT_PRESSING2].preReqTrait1 := TRAIT_PRESSING;



  TraitTree[TRAIT_PLAYMAKER].Name := 'TRAIT_PLAYMAKER';
  TraitTree[TRAIT_PLAYMAKER].level := 1;
  TraitTree[TRAIT_PLAYMAKER].preReqStat1 := workrate;
  TraitTree[TRAIT_PLAYMAKER].preReqStat1value := 11;
  TraitTree[TRAIT_PLAYMAKER].preReqTrait1 := 0;

  TraitTree[TRAIT_POSITIONING].Name := 'TRAIT_POSITIONING';
  TraitTree[TRAIT_POSITIONING].level := 1;
  TraitTree[TRAIT_POSITIONING].preReqStat1 := workrate;
  TraitTree[TRAIT_POSITIONING].preReqStat1value := 11;
  TraitTree[TRAIT_POSITIONING].preReqTrait1 := 0;


  TraitTree[TRAIT_FREEKICKS].Name := 'TRAIT_FREEKICKS';
  TraitTree[TRAIT_FREEKICKS].level := 1;
  TraitTree[TRAIT_FREEKICKS].preReqStat1 := workrate;
  TraitTree[TRAIT_FREEKICKS].preReqStat1value := 11;
  TraitTree[TRAIT_FREEKICKS].preReqTrait1 := 0;


  TraitTree[TRAIT_EXPERIENCE].Name := 'TRAIT_EXPERIENCE';
  TraitTree[TRAIT_EXPERIENCE].level := 1;
  TraitTree[TRAIT_EXPERIENCE].preReqStat1 := workrate;
  TraitTree[TRAIT_EXPERIENCE].preReqStat1value := 11;
  TraitTree[TRAIT_EXPERIENCE].preReqTrait1 := 0;


  TraitTree[TRAIT_RAPIDPASSING].Name := 'TRAIT_RAPIDPASSING';
  TraitTree[TRAIT_RAPIDPASSING].level := 1;
  TraitTree[TRAIT_RAPIDPASSING].preReqStat1 := Passing;
  TraitTree[TRAIT_RAPIDPASSING].preReqStat1value := 11;
  TraitTree[TRAIT_RAPIDPASSING].preReqTrait1 := 0;


  TraitTree[TRAIT_ACE].Name := 'TRAIT_ACE';
  TraitTree[TRAIT_ACE].level := 1;
  TraitTree[TRAIT_ACE].preReqStat1 := technique;
  TraitTree[TRAIT_ACE].preReqStat1value := 11;
  TraitTree[TRAIT_ACE].preReqTrait1 := 0;

  TraitTree[TRAIT_DIVING].Name := 'TRAIT_DIVING';
  TraitTree[TRAIT_DIVING].level := 1;
  TraitTree[TRAIT_DIVING].preReqStat1 := workrate;
  TraitTree[TRAIT_DIVING].preReqStat1value := 11;
  TraitTree[TRAIT_DIVING].preReqTrait1 := 0;

  TraitTree[TRAIT_RUNNER].Name := 'TRAIT_RUNNER';
  TraitTree[TRAIT_RUNNER].level := 1;
  TraitTree[TRAIT_RUNNER].preReqStat1 := speed;
  TraitTree[TRAIT_RUNNER].preReqStat1value := 2;
  TraitTree[TRAIT_RUNNER].preReqTrait1 := 0;

  TraitTree[TRAIT_BUFF_DEFENSE].Name := 'TRAIT_BUFF_DEFENSE';
  TraitTree[TRAIT_BUFF_DEFENSE].level := 1;
  TraitTree[TRAIT_BUFF_DEFENSE].preReqStat1 := bravery;
  TraitTree[TRAIT_BUFF_DEFENSE].preReqStat1value := 11;
  TraitTree[TRAIT_BUFF_DEFENSE].preReqTrait1 := 0;

  TraitTree[TRAIT_BUFF_MIDDLE].Name := 'TRAIT_BUFF_MIDDLE';
  TraitTree[TRAIT_BUFF_MIDDLE].level := 1;
  TraitTree[TRAIT_BUFF_MIDDLE].preReqStat1 := workrate;
  TraitTree[TRAIT_BUFF_MIDDLE].preReqStat1value := 11;
  TraitTree[TRAIT_BUFF_MIDDLE].preReqTrait1 := 0;

  TraitTree[TRAIT_BUFF_FORWARD].Name := 'TRAIT_BUFF_FORWARD';
  TraitTree[TRAIT_BUFF_FORWARD].level := 1;
  TraitTree[TRAIT_BUFF_FORWARD].preReqStat1 := workrate;
  TraitTree[TRAIT_BUFF_FORWARD].preReqStat1value := 11;
  TraitTree[TRAIT_BUFF_FORWARD].preReqTrait1 := 0;

end.

