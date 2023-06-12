params ["_pos", "_name"];

private _garrison = townData getVariable [format["garrison_%1", _name], SE_Gendarm_PatrolGroup];
private _spawner = townData getVariable [format["spawner_%1", _name], []];
private _group = createGroup west;

{
	private _unitSP = _group createUnit [_x, _pos, [], 50, "NONE"];
	[_unitSP] call SE_fnc_addUnitEventHandlers;

	if (_x == SE_Gendarm_Commander) then
	{
		_group selectLeader _unitSP; 
	};
	_spawner pushBack _x;
} foreach(_garrison);

[_group, _pos, 300, 5, "MOVE", "SAFE", "RED", "NORMAL", "STAG COLUMN"] call CBA_fnc_taskPatrol;

townData setVariable [format["spawner_%1", _name], _spawner, true];
townData setVariable [format["group_%1", _name], _group, true];