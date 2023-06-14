params ["_target", "_caller", "_actionId", "_arguments"];

private _name = _target getVariable "name";
private _owner = townData getVariable [format["owner_%1", _name], west];
if (_owner == west) then
{
	townData setVariable [format["owner_%1", _name], independent, true];

	removeAllActions _target;
	_target addAction ["Surrender Town", "events\takeTownControl.sqf", nil, 1, true, false];
	_target forceFlagTexture SE_Player_FlagTexture;

	private _controlledTerr = aiCommander getVariable ["uncontrolled_terr", 0];
	aiCommander setVariable ["uncontrolled_terr", (_controlledTerr + 1), true];
	
	[_name] call SE_fnc_updateTownMarker;
} else
{
	townData setVariable [format["owner_%1", _name], west, true];

	removeAllActions _target;
	_target addAction ["Take Town", "events\takeTownControl.sqf", nil, 1, true, false];
	_target forceFlagTexture SE_NATO_FlagTexture;

	private _controlledTerr = aiCommander getVariable ["uncontrolled_terr", 0];
	aiCommander setVariable ["uncontrolled_terr", (_controlledTerr - 1), true];

	[_name] call SE_fnc_updateTownMarker;
};