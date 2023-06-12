params ["_pos", "_name", "_worth"];

private _spawnerName = format["nato_%1", _name];
private _garrison = spawners getVariable [format["garrison_%1", _name], SE_NATO_GarrLevelOne];
private _staticGarrison = spawners getVariable [format["staticgarrison_%1", _name], []];
private _vicGarrison = spawners getVariable [format["veh_%1", _name], []];
private _vicInit = spawners getVariable [format["veh_init_%1", _name], false];
private _staticInit = spawners getVariable [format["static_init_%1", _name], false];
private _spawner = spawners getVariable [_spawnerName, []];
private _staticSpawnSpots = spawners getVariable [format["staticspots_%1", _name], []];
private _vicSpawnSpots = spawners getVariable [format["vicspots_%1", _name], []];
private _vicCount = 0;

private _group = createGroup west;

if (_worth <= 600) then
{
	_vicCount = 1;
};

if (_worth <= 1000) then
{
	_vicCount = random [1,2,4];
};

if (_worth >= 1100) then
{
	_vicCount = random [2,3,6];
};

{
	private _unitSP = _group createUnit [_x, _pos, [], 50, "NONE"];
	[_unitSP] call SE_fnc_addUnitEventHandlers;

	_spawner pushBack _unitSP;
} foreach(_garrison);

if !(_vicInit) then
{
	if (_vicCount > (count _vicSpawnSpots)) then
	{
		_vicCount = count _vicSpawnSpots;
	};

	for [{ _i = 1 }, { _i < _vicCount }, { _i = _i + 1 }] do
	{
		private _spawnSpot = _vicSpawnSpots select _i-1;
		if (_worth < 1000) then
		{
			// only harmless vics
			private _vic = [_spawnSpot, SE_NATO_HarmlessVics select (floor (random count SE_NATO_HarmlessVics))];
			_vicGarrison pushBack _vic;
		} else
		{
			private _combined = (SE_NATO_HarmlessVics + SE_NATO_GunVics);
			private _vic = [_spawnSpot, _combined select (floor (random count _combined))];
			_vicGarrison pushBack _vic;
		};
	};

	spawners setVariable [format["veh_%1", _name], _vicGarrison, true];
	spawners setVariable [format["veh_init_%1", _name], true, true];
};

{
	_x params ["_pos", "_static"];
	if (alive _static) then
	{
		private _unitSP = _group createUnit [SE_NATO_Rifleman, _pos, [], 50, "NONE"];
		[_unitSP] call SE_fnc_addUnitEventHandlers;

		_unitSP moveInAny _static;
		_spawner pushBack _unitSP;
	} else
	{
		hint str "dead";
	};
} foreach(_staticSpawnSpots);

{
	_x params["_pos", "_vic"];

	private _vicSP = createVehicle [_vic, _pos, [], 0, "NONE"];
	_vicSP setVariable ["_name", _name, true];
	_vicSP addEventHandler ["GetIn", {
		params ["_vehicle", "_role", "_unit", "_turret"];
		if (isPlayer _unit) then
		{
			[_unit] joinSilent createGroup independent;
			
			_vicGarrison = spawners getVariable [format["veh_%1", _name], []];
			_vicGarrison = _vicGarrison - _this;
			spawners setVariable [format["veh_%1", _name], _vicGarrison, true];
		};
	}];

	_spawner pushBack _vicSP;
} foreach(_vicGarrison);


spawners setVariable [_spawnerName, _spawner, true];
spawners setVariable [format["group_%1", _name], _group, true];