unit u_Lang;

interface

uses
  System.SysUtils, System.Classes;

// ⚠️ BASELINE INTOCCABILE
// Tutto ciò che segue è SOLO AGGIUNTA, nulla viene rimosso o modificato

// -----------------------------------------------------------------------------
// Lingue supportate
// -----------------------------------------------------------------------------
type
  TLang = (
    lgIT, // Italiano
    lgEN, // Inglese
    lgFR, // Francese
    lgDE, // Tedesco
    lgES, // Spagnolo
    lgRU  // Russo
  );

const
  LANG_COUNT = 6;

// -----------------------------------------------------------------------------
// Struttura base per le stringhe traducibili
// -----------------------------------------------------------------------------
type
  TLangArray = array[TLang] of string;

// -----------------------------------------------------------------------------
// Variabili stringhe - SKILL CALCIO
// -----------------------------------------------------------------------------
var
  STR_STAT_STRENGTH: TLangArray;    // Forza
  STR_STAT_TECHNIQUE: TLangArray;   // Tecnica
  STR_STAT_SPEED: TLangArray;       // Velocità
  STR_STAT_AGILITY: TLangArray;     // Agilità
  STR_STAT_INTUITION: TLangArray;   // Intuito

  STR_SKILL_RUN: TLangArray;
  STR_SKILL_PASS_LOW: TLangArray;
  STR_SKILL_PASS_HIGH: TLangArray;
  STR_SKILL_HEADER: TLangArray;
  STR_SKILL_SHOT_POWER: TLangArray;
  STR_SKILL_SHOT_ACCURACY: TLangArray;
  STR_SKILL_DRIBBLE: TLangArray;
  STR_SKILL_CROSS_DRIVEN: TLangArray;
  STR_SKILL_CROSS_LOFTED: TLangArray;
  STR_SKILL_TACKLE: TLangArray;
  STR_SKILL_BALL_CONTROL: TLangArray;
  STR_SKILL_INTERCEPTION: TLangArray;
  STR_SKILL_FREE_KICK: TLangArray;
  STR_SKILL_PENALTY: TLangArray;
  STR_SKILL_SAVE_LOW: TLangArray;
  STR_SKILL_SAVE_HIGH: TLangArray;
  STR_SKILL_GOALKEEPER_RUSH: TLangArray;
  STR_SKILL_ONE_ON_ONE: TLangArray; // Portiere
  STR_SKILL_SHOT_BLOCK: TLangArray;
  CurrentLang: TLang = lgIT;

// -----------------------------------------------------------------------------
// Helper
// -----------------------------------------------------------------------------
function L(const A: TLangArray): string;

implementation

function L(const A: TLangArray): string;
begin
  Result := A[CurrentLang];
end;

initialization
  STR_STAT_STRENGTH[lgIT] := 'Forza';
  STR_STAT_STRENGTH[lgEN] := 'Strength';
  STR_STAT_STRENGTH[lgFR] := 'Force';
  STR_STAT_STRENGTH[lgDE] := 'Stärke';
  STR_STAT_STRENGTH[lgES] := 'Fuerza';
  STR_STAT_STRENGTH[lgRU] := 'Сила';

  STR_STAT_TECHNIQUE[lgIT] := 'Tecnica';
  STR_STAT_TECHNIQUE[lgEN] := 'Technique';
  STR_STAT_TECHNIQUE[lgFR] := 'Technique';
  STR_STAT_TECHNIQUE[lgDE] := 'Technik';
  STR_STAT_TECHNIQUE[lgES] := 'Técnica';
  STR_STAT_TECHNIQUE[lgRU] := 'Техника';

  STR_STAT_SPEED[lgIT] := 'Velocità';
  STR_STAT_SPEED[lgEN] := 'Speed';
  STR_STAT_SPEED[lgFR] := 'Vitesse';
  STR_STAT_SPEED[lgDE] := 'Geschwindigkeit';
  STR_STAT_SPEED[lgES] := 'Velocidad';
  STR_STAT_SPEED[lgRU] := 'Скорость';

  STR_STAT_AGILITY[lgIT] := 'Agilità';
  STR_STAT_AGILITY[lgEN] := 'Agility';
  STR_STAT_AGILITY[lgFR] := 'Agilité';
  STR_STAT_AGILITY[lgDE] := 'Beweglichkeit';
  STR_STAT_AGILITY[lgES] := 'Agilidad';
  STR_STAT_AGILITY[lgRU] := 'Ловкость';

  STR_STAT_INTUITION[lgIT] := 'Intuito';
  STR_STAT_INTUITION[lgEN] := 'Intuition';
  STR_STAT_INTUITION[lgFR] := 'Intuition';
  STR_STAT_INTUITION[lgDE] := 'Intuition';
  STR_STAT_INTUITION[lgES] := 'Intuición';
  STR_STAT_INTUITION[lgRU] := 'Интуиция';
  // ---------------------------------------------------------------------------
  // SKILLS - CALCIO

  STR_SKILL_RUN[lgIT] := 'Corri';
  STR_SKILL_RUN[lgEN] := 'Sprint';
  STR_SKILL_RUN[lgFR] := 'Course';
  STR_SKILL_RUN[lgDE] := 'Lauf';
  STR_SKILL_RUN[lgES] := 'Correr';
  STR_SKILL_RUN[lgRU] := 'Бег';

  STR_SKILL_PASS_LOW[lgIT] := 'Passaggio basso';
  STR_SKILL_PASS_LOW[lgEN] := 'Short Pass';
  STR_SKILL_PASS_LOW[lgFR] := 'Passe basse';
  STR_SKILL_PASS_LOW[lgDE] := 'Flacher Pass';
  STR_SKILL_PASS_LOW[lgES] := 'Pase raso';
  STR_SKILL_PASS_LOW[lgRU] := 'Низкий пас';

  STR_SKILL_PASS_HIGH[lgIT] := 'Passaggio alto';
  STR_SKILL_PASS_HIGH[lgEN] := 'Long Pass';
  STR_SKILL_PASS_HIGH[lgFR] := 'Passe haute';
  STR_SKILL_PASS_HIGH[lgDE] := 'Hoher Pass';
  STR_SKILL_PASS_HIGH[lgES] := 'Pase alto';
  STR_SKILL_PASS_HIGH[lgRU] := 'Высокий пас';

  STR_SKILL_HEADER[lgIT] := 'Colpo di testa';
  STR_SKILL_HEADER[lgEN] := 'Heading';
  STR_SKILL_HEADER[lgFR] := 'Coup de tête';
  STR_SKILL_HEADER[lgDE] := 'Kopfball';
  STR_SKILL_HEADER[lgES] := 'Cabeceo';
  STR_SKILL_HEADER[lgRU] := 'Удар головой';

  STR_SKILL_SHOT_POWER[lgIT] := 'Tiro potente';
  STR_SKILL_SHOT_POWER[lgEN] := 'Power Shot';
  STR_SKILL_SHOT_POWER[lgFR] := 'Tir puissant';
  STR_SKILL_SHOT_POWER[lgDE] := 'Kraftschuss';
  STR_SKILL_SHOT_POWER[lgES] := 'Tiro potente';
  STR_SKILL_SHOT_POWER[lgRU] := 'Сильный удар';

  STR_SKILL_SHOT_ACCURACY[lgIT] := 'Tiro preciso';
  STR_SKILL_SHOT_ACCURACY[lgEN] := 'Finesse Shot';
  STR_SKILL_SHOT_ACCURACY[lgFR] := 'Tir précis';
  STR_SKILL_SHOT_ACCURACY[lgDE] := 'Präzisionsschuss';
  STR_SKILL_SHOT_ACCURACY[lgES] := 'Tiro preciso';
  STR_SKILL_SHOT_ACCURACY[lgRU] := 'Точный удар';

  STR_SKILL_DRIBBLE[lgIT] := 'Dribbling';
  STR_SKILL_DRIBBLE[lgEN] := 'Dribbling';
  STR_SKILL_DRIBBLE[lgFR] := 'Dribble';
  STR_SKILL_DRIBBLE[lgDE] := 'Dribbling';
  STR_SKILL_DRIBBLE[lgES] := 'Regate';
  STR_SKILL_DRIBBLE[lgRU] := 'Дриблинг';

  STR_SKILL_CROSS_DRIVEN[lgIT] := 'Cross teso';
  STR_SKILL_CROSS_DRIVEN[lgEN] := 'Driven Cross';
  STR_SKILL_CROSS_DRIVEN[lgFR] := 'Centre tendu';
  STR_SKILL_CROSS_DRIVEN[lgDE] := 'Scharfe Flanke';
  STR_SKILL_CROSS_DRIVEN[lgES] := 'Centro tenso';
  STR_SKILL_CROSS_DRIVEN[lgRU] := 'Низкий навес';

  STR_SKILL_CROSS_LOFTED[lgIT] := 'Cross spiovente';
  STR_SKILL_CROSS_LOFTED[lgEN] := 'Lofted Cross';
  STR_SKILL_CROSS_LOFTED[lgFR] := 'Centre lobé';
  STR_SKILL_CROSS_LOFTED[lgDE] := 'Hohe Flanke';
  STR_SKILL_CROSS_LOFTED[lgES] := 'Centro bombeado';
  STR_SKILL_CROSS_LOFTED[lgRU] := 'Высокий навес';

  STR_SKILL_TACKLE[lgIT] := 'Contrasto';
  STR_SKILL_TACKLE[lgEN] := 'Tackle';
  STR_SKILL_TACKLE[lgFR] := 'Tacle';
  STR_SKILL_TACKLE[lgDE] := 'Zweikampf';
  STR_SKILL_TACKLE[lgES] := 'Entrada';
  STR_SKILL_TACKLE[lgRU] := 'Отбор';

  STR_SKILL_BALL_CONTROL[lgIT] := 'Controllo di palla';
  STR_SKILL_BALL_CONTROL[lgEN] := 'Ball Control';
  STR_SKILL_BALL_CONTROL[lgFR] := 'Contrôle de balle';
  STR_SKILL_BALL_CONTROL[lgDE] := 'Ballkontrolle';
  STR_SKILL_BALL_CONTROL[lgES] := 'Control del balón';
  STR_SKILL_BALL_CONTROL[lgRU] := 'Контроль мяча';

  STR_SKILL_INTERCEPTION[lgIT] := 'Intercettazione';
  STR_SKILL_INTERCEPTION[lgEN] := 'Interception';
  STR_SKILL_INTERCEPTION[lgFR] := 'Interception';
  STR_SKILL_INTERCEPTION[lgDE] := 'Abfangen';
  STR_SKILL_INTERCEPTION[lgES] := 'Intercepción';
  STR_SKILL_INTERCEPTION[lgRU] := 'Перехват';

  STR_SKILL_FREE_KICK[lgIT] := 'Punizioni';
  STR_SKILL_FREE_KICK[lgEN] := 'Free Kicks';
  STR_SKILL_FREE_KICK[lgFR] := 'Coups francs';
  STR_SKILL_FREE_KICK[lgDE] := 'Freistöße';
  STR_SKILL_FREE_KICK[lgES] := 'Tiros libres';
  STR_SKILL_FREE_KICK[lgRU] := 'Штрафные';

  STR_SKILL_PENALTY[lgIT] := 'Rigori';
  STR_SKILL_PENALTY[lgEN] := 'Penalties';
  STR_SKILL_PENALTY[lgFR] := 'Penalty';
  STR_SKILL_PENALTY[lgDE] := 'Elfmeter';
  STR_SKILL_PENALTY[lgES] := 'Penaltis';
  STR_SKILL_PENALTY[lgRU] := 'Пенальти';

  STR_SKILL_SAVE_LOW[lgIT] := 'Parata bassa';
  STR_SKILL_SAVE_LOW[lgEN] := 'Low Save';
  STR_SKILL_SAVE_LOW[lgFR] := 'Arrêt bas';
  STR_SKILL_SAVE_LOW[lgDE] := 'Flache Parade';
  STR_SKILL_SAVE_LOW[lgES] := 'Parada baja';
  STR_SKILL_SAVE_LOW[lgRU] := 'Низкий сейв';

  STR_SKILL_SAVE_HIGH[lgIT] := 'Parata alta';
  STR_SKILL_SAVE_HIGH[lgEN] := 'High Save';
  STR_SKILL_SAVE_HIGH[lgFR] := 'Arrêt haut';
  STR_SKILL_SAVE_HIGH[lgDE] := 'Hohe Parade';
  STR_SKILL_SAVE_HIGH[lgES] := 'Parada alta';
  STR_SKILL_SAVE_HIGH[lgRU] := 'Высокий сейв';

  STR_SKILL_GOALKEEPER_RUSH[lgIT] := 'Uscita dai pali';
  STR_SKILL_GOALKEEPER_RUSH[lgEN] := 'GK Rush';
  STR_SKILL_GOALKEEPER_RUSH[lgFR] := 'Sortie du gardien';
  STR_SKILL_GOALKEEPER_RUSH[lgDE] := 'Torwart kommt raus';
  STR_SKILL_GOALKEEPER_RUSH[lgES] := 'Salida del portero';
  STR_SKILL_GOALKEEPER_RUSH[lgRU] := 'Выход вратаря';

  STR_SKILL_ONE_ON_ONE[lgIT] := 'Uno contro uno';
  STR_SKILL_ONE_ON_ONE[lgEN] := 'One-on-One';
  STR_SKILL_ONE_ON_ONE[lgFR] := 'Un contre un';
  STR_SKILL_ONE_ON_ONE[lgDE] := 'Eins gegen eins';
  STR_SKILL_ONE_ON_ONE[lgES] := 'Uno contra uno';
  STR_SKILL_ONE_ON_ONE[lgRU] := 'Один на один';

  STR_SKILL_SHOT_BLOCK[lgIT] := 'Blocco del tiro';
  STR_SKILL_SHOT_BLOCK[lgEN] := 'Shot Block';
  STR_SKILL_SHOT_BLOCK[lgFR] := 'Contre';
  STR_SKILL_SHOT_BLOCK[lgDE] := 'Schussblock';
  STR_SKILL_SHOT_BLOCK[lgES] := 'Bloqueo de tiro';
  STR_SKILL_SHOT_BLOCK[lgRU] := 'Блок удара';

end.

