// calculate aggression
#include "./common.hpp"
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

// decide on actions
{
	_x params ["_pos", "_name", "_worth"];

	private _infCapacity = spawners getVariable format["capacity_%1", _name];
	private _garrison = spawners getVariable format["garrison_%1", _name];

	private _percentage = ((count  _garrison) / _infCapacity) * 100;
	private _isReinforcing = aiCommander getVariable [format["reinforcing_%1", _name], false];
	if(!_isReinforcing && _percentage <= 40) then // if 40% or less of garrison is remaining send convoy to reinforce it
	{
		// TODO: don't send convoy if the garrison is currently fighting. if it's not fighting
		// but has seen player activity in the base or around it send recon to check if the base
		// is safe to send reinforcements to
		[_name, _pos, _worth, SE_CONVOY_INF] call SE_fnc_sendConvoy;
	};
} foreach SE_baseData;