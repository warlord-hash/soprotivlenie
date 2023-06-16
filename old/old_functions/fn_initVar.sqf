/*
*
* ---------- DATA ----------
*
*/
if(!isServer) exitWith {};

call compile preprocessFileLineNumbers "data\towns.sqf";
call compile preprocessFileLineNumbers "data\airbases.sqf";
call compile preprocessFileLineNumbers "data\military.sqf";

SE_baseData = SE_baseData + SE_airbaseData;

server = [true] call CBA_fnc_createNamespace;
publicVariable "server";
spawners = [true] call CBA_fnc_createNamespace;
publicVariable "spawners";
townData = [true] call CBA_fnc_createNamespace;
publicVariable "townData";
baseData = [true] call CBA_fnc_createNamespace;
publicVariable "baseData";
aiCommander = [true] call CBA_fnc_createNamespace;
publicVariable "aiCommander";

SE_NATO_ConfigEntry = "BLU_F";
SE_NATO_FlagTexture = "\A3\Data_F\Flags\flag_NATO_CO.paa";
SE_Player_FlagTexture = "\A3\Data_F\Flags\flag_FIA_CO.paa";
SE_SpawnDistance = 1250;


/*
*
* ---------- BASE SETUP ----------
*
*/

server setVariable ["SE_knownBases", [], true];

aiCommander setVariable ["aggression", 0, true];

SE_baseMarkers = [];

MISSION_ROOT = call {
    private "_arr";
    _arr = toArray __FILE__;
    _arr resize (count _arr - 8);
    toString _arr
};

[] call SE_fnc_initNato;
[] call SE_fnc_initGendarm;
[] call SE_fnc_initCiv;


{
	_x params["_pos", "_name"];


	_owner = townData getVariable ["owner_%1", west];
	_marker = createMarker [_name, _pos];
	_marker setMarkerType "loc_LetterT";

	if (_owner == west) then
	{
		_marker setMarkerColor "colorBLUFOR";
	} else
	{
		_marker setMarkerColor "colorIndependent";
	};

	private _flag = "Flag_NATO_F" createVehicle _pos;
	_flag addAction ["Take Town", "events\takeTownControl.sqf", nil, 1, true, false];
	_flag setVariable ["name", _name, true];

	private _pop = townData getVariable [format["pop_%1", _name], 0];

	if (_name in SE_highPopulationTowns) then
	{
		_pop = floor (random [1000, 2500, 5000]);
	};

	if (_name in SE_midPopulationTowns) then
	{
		_pop = floor (random [250, 500, 1000]);
	};

	if (_pop == 0) then
	{
		_pop = floor (random [25, 125, 250]);
	};

	townData setVariable [format["flag_%1", _name], _flag];
	townData setVariable [format["marker_%1", _name], _marker, true];
	townData setVariable [format["pop_%1", _name], _pop, true];
	townData setVariable [format["garrison_%1", _name], SE_Gendarm_PatrolGroup, true];
} foreach(SE_townData);

{
	_x params["_pos", "_name", "_worth"];

	// setup spawn spots
	private _vicSpawnSpots = [];
	private _staticSpawnSpots = [];

	private _nearest = nearestObjects [_pos, [SE_NATO_InfantryTruck, SE_NATO_StaticGMG, SE_NATO_StaticHMG], 500];
	{
		if ((typeOf _x) == SE_NATO_InfantryTruck) then
		{
			_vicSpawnSpots pushBack [getPos _x, getDir _x];
			deleteVehicle _x;
		};

		if ((typeOf _x) == SE_NATO_StaticGMG || (typeOf _x) == SE_NATO_StaticHMG) then
		{
			_staticSpawnSpots pushBack [getPos _x, _x];
		};
	} foreach(_nearest);

	spawners setVariable [format["vicspots_%1", _name], _vicSpawnSpots, true];
	spawners setVariable [format["staticspots_%1", _name], _staticSpawnSpots, true];

	// setup unit garrison
	private _garrison = [];
	private _random = 0;
	if (_worth > 1000) then
	{
		_random = random [40,50,60];
	};

	if (_worth < 1000) then
	{
		_random = random [20,30,40];
	};

	if (_worth <= 500) then
	{
		_random = random [10,15,20];
	};

	if(_worth <= 300) then
	{
		_random = random [3,5,10];
	};

	for [{_i = 0}, {_i < _random}, {_i = _i + 1}] do
	{
		_garrison pushBack (selectRandom SE_NATO_PossibleUnits);
	};

	private _totalInf = aiCommander getVariable ["total_inf", 0];
	_totalInf = _totalInf + (count _garrison);

	spawners setVariable [format["garrison_%1", _name], _garrison, true];
	aiCommander setVariable ["total_inf", _totalInf, true];

	// setup vic garrison
	private _vicCount = 0;
	private _vicGarrison = spawners getVariable [format["veh_%1", _name], []];
	private _vicInit = spawners getVariable [format["veh_init_%1", _name], false];
	

	if (_worth > 1000) then
	{
		_vicCount = 5;
	};

	if (_worth <= 1000) then
	{
		_vicCount = 3;
	};

	if (_worth <= 800) then
	{
		_vicCount = 2;
	};

	if (_worth <= 600) then
	{
		_vicCount = 1;
	};

	if !(_vicInit) then
	{
		if (_vicCount > (count _vicSpawnSpots)) then
		{
			_vicCount = count _vicSpawnSpots;
		};

		for [{ _i = 0 }, { _i < _vicCount }, { _i = _i + 1 }] do
		{
			private _spawnSpot = _vicSpawnSpots select _i-1;
			private _pool = [false] call SE_fnc_getAvailableVehiclePool;

			private _vic = [_spawnSpot, _pool select (floor (random count _pool))];
			_vicGarrison pushBack _vic;
		};

		spawners setVariable [format["veh_%1", _name], _vicGarrison, true];
		spawners setVariable [format["veh_init_%1", _name], true, true];
	};


} foreach(SE_baseData);