// calculate aggression
private _casualties = aiCommander getVariable ["mil_losses", 0];
private _totalInf = aiCommander getVariable ["total_inf", 0];
private _casualtyRate = _casualties / _totalInf;

private _territory = count SE_townData;
private _uncontrolledTerritory = aiCommander getVariable ["uncontrolled_terr", 0];
private _territoryRate = _uncontrolledTerritory / _territory;

private _boost = 0;
private _aggression = ((0.7 * _territoryRate) + (0.3 * _casualtyRate)) + _boost;
_aggression = _aggression max 1;
_aggression = _aggression min 0;

aiCommander setVariable ["aggression", _aggression, true];