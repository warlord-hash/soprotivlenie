params ["_pos", "_name"];

private _garrison = townData getVariable [format["garrison_%1", _name], []];
private _spawner = townData getVariable [format["spawner_%1", _name], []];
private _policeGroup = createGroup west;
private _milGroup = createGroup west;

{
	private _unitSp = "";
	if (_x in [SE_Gendarm_Unit, SE_Gendarm_Commander]) then
	{
		_unitSP = _policeGroup createUnit [_x, _pos, [], 50, "NONE"];
		[_unitSP, "police_losses", false] call SE_fnc_addUnitEventHandlers;
	} else
	{
		_unitSP = _milGroup createUnit [_x, _pos, [], 50, "NONE"];
		[_unitSP, "mil_losses", false] call SE_fnc_addUnitEventHandlers;
	};

	if (_x == SE_Gendarm_Commander) then
	{
		_policeGroup selectLeader _unitSP; 
	};

	_spawner pushBack _unitSP;
} foreach(_garrison);

[_policeGroup, _pos, 300, 5, "SAD", "SAFE", "RED", "LIMITED", "STAG COLUMN"] call CBA_fnc_taskPatrol;
[_milGroup, _pos, 300, 5, "SAD", "SAFE", "RED", "LIMITED", "STAG COLUMN"] call CBA_fnc_taskPatrol;

townData setVariable [format["spawner_%1", _name], _spawner, true];
townData setVariable [format["group_%1", _name], [_policeGroup, _milGroup], true];