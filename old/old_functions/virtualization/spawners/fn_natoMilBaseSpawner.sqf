params ["_pos", "_name", "_worth"];

private _spawnerName = format["nato_%1", _name];
private _garrison = spawners getVariable [format["garrison_%1", _name], []];
private _staticGarrison = spawners getVariable [format["staticgarrison_%1", _name], []];
private _vicGarrison = spawners getVariable [format["veh_%1", _name], []];
private _vicInit = spawners getVariable [format["veh_init_%1", _name], false];
private _staticInit = spawners getVariable [format["static_init_%1", _name], false];
private _spawner = spawners getVariable [_spawnerName, []];
private _staticSpawnSpots = spawners getVariable [format["staticspots_%1", _name], []];
private _vicSpawnSpots = spawners getVariable [format["vicspots_%1", _name], []];
private _group = createGroup west;
private _groups = [];

{
	if((count units _group) == floor((count _garrison) / 2)) then
	{
		_groups pushBack _group;
		_group = createGroup west;
	};

	private _unitSP = _group createUnit [_x, _pos, [], 50, "NONE"];
	[_unitSP, "mil_losses", false] call SE_fnc_addUnitEventHandlers;

	_spawner pushBack _unitSP;
} foreach(_garrison);

[_group, _pos, 300, 5, "SAD", "SAFE", "RED", "LIMITED", "STAG COLUMN"] call CBA_fnc_taskPatrol;

{
	_x params ["_pos", "_static"];
	if (alive _static) then
	{
		private _unitSP = _group createUnit [SE_NATO_Rifleman, _pos, [], 50, "NONE"];
		[_unitSP, "mil_losses", false] call SE_fnc_addUnitEventHandlers;

		_unitSP moveInAny _static;
		_spawner pushBack _unitSP;
	} else
	{
	};
} foreach(_staticSpawnSpots);

{
	_x params["_pos", "_vic"];

	private _vicSP = createVehicle [_vic, _pos select 0, [], 0, "NONE"];
	_vicSP setDir (_pos select 1);
	_vicSP setVariable ["_name", _name, true];
	_vicSP addEventHandler ["GetIn", {
		params ["_vehicle", "_role", "_unit", "_turret"];
		if (isPlayer _unit) then
		{
			[_unit] joinSilent createGroup independent;
			
			// _vicGarrison = spawners getVariable [format["veh_%1", _name], []];
			// _vicGarrison = _vicGarrison - _this;
			// spawners setVariable [format["veh_%1", _name], _vicGarrison, true];
		};
	}];

	_spawner pushBack _vicSP;
} foreach(_vicGarrison);


spawners setVariable [_spawnerName, _spawner, true];
spawners setVariable [format["group_%1", _name], _groups, true];