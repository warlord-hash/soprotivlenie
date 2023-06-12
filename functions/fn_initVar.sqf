/*
*
* ---------- DATA ----------
*
*/
if(!isServer) exitWith {};

call compile preprocessFileLineNumbers "data\towns.sqf";
call compile preprocessFileLineNumbers "data\airbases.sqf";
call compile preprocessFileLineNumbers "data\military.sqf";

server = [true] call CBA_fnc_createNamespace;
publicVariable "server";
spawners = [true] call CBA_fnc_createNamespace;
publicVariable "spawners";
townData = [true] call CBA_fnc_createNamespace;
publicVariable "townData";
aiCommander = [true] call CBA_fnc_createNamespace;
publicVariable "aiCommander";

SE_NATO_ConfigEntry = "BLU_F";
SE_SpawnDistance = 1250;


/*
*
* ---------- BASE SETUP ----------
*
*/

server setVariable ["SE_knownBases", [], true];
server setVariable ["SE_knownAirbases", [], true];

aiCommander setVariable ["SE_commanderAggression", 0, true];

SE_baseMarkers = [];

[] call SE_fnc_initNato;
[] call SE_fnc_initGendarm;
[] call SE_fnc_initCiv;


{
	_x params["_pos", "_name"];
	_marker = createMarker [_name, _pos];
	_marker setMarkerType "SE_Town";
} foreach(SE_townData);

{
	_x params["_pos", "_name", "_worth"];
	private _vicSpawnSpots = [];
	private _staticSpawnSpots = [];

	private _nearest = nearestObjects [_pos, [SE_NATO_InfantryTruck, SE_NATO_StaticGMG, SE_NATO_StaticHMG], 500];
	{
		if ((typeOf _x) == SE_NATO_InfantryTruck) then
		{
			_vicSpawnSpots pushBack (getPos _x);
			deleteVehicle _x;
		};

		if ((typeOf _x) == SE_NATO_StaticGMG || (typeOf _x) == SE_NATO_StaticHMG) then
		{
			_staticSpawnSpots pushBack [getPos _x, _x];
		};
	} foreach(_nearest);

	spawners setVariable [format["vicspots_%1", _name], _vicSpawnSpots, true];
	spawners setVariable [format["staticspots_%1", _name], _staticSpawnSpots, true];
} foreach(SE_baseData);

[] spawn {
	while {true} do
	{
		sleep 5;

		{
			_x params["_pos", "_name", "_worth"];

			// vic spawn works like this:
			// find markup with nearObjects/nearestTerrainObjects, process that with switch
			// delete and replace placeholder vics with actual vics for this base 
			// vics for each garrison will depend on the worth, which influences the random range of vics in the base
			// randomly select vics (also based on worth, higher worth = better vics) and place them in the garrison
			if ([_pos] call SE_fnc_inSpawnDistance) then
			{
				if (count (spawners getVariable [format["nato_%1", _name], []]) == 0) then
				{
					[_pos, _name, _worth] call SE_fnc_natoMilBaseSpawner;
				};
			} else
			{
				private _groupEntry = (spawners getVariable [format["group_%1", _name], []]);
				private _spawned = (spawners getVariable [format["nato_%1", _name], []]);

				if (typeName _groupEntry == "GROUP") then
				{
					if (count units _groupEntry != 0) then
					{
						private _garr = [];
						private _vicGarrison = [];

						{
							_garr pushBack (typeOf _x);
							deleteVehicle _x;
						} foreach(units _groupEntry);

						{
							if (alive _x && !(_x isKindOf "Man")) then
							{
								_vicGarrison pushBack (typeOf _x);
							};

							deleteVehicle _x;
						} foreach(_spawned);

						spawners setVariable [format["group_%1", _name], nil, false];
						spawners setVariable [format["garrison_%1", _name], _garr, true];
						spawners setVariable [format["veh_%1", _name], _vicGarrison, true];
						spawners setVariable [format["nato_%1", _name], [], true];
					} else
					{
						spawners setVariable [format["group_%1", _name], nil, false];
						spawners setVariable [format["garrison_%1", _name], [], true];
					};
				}
			};

			if !(_x in (server getVariable ["SE_knownBases", []])) then
			{
				if (_pos distance position player <= 1000) then
				{
					[_x] call SE_fnc_findBase;
				};
			};
		} foreach(SE_baseData);

		{
			_x params["_pos", "_name"];
			if ([_pos] call SE_fnc_inSpawnDistance) then
			{
				if (count (townData getVariable [format["spawner_%1", _name], []]) == 0) then
				{
					[_pos, _name] call SE_fnc_gendarmPatrolSpawner;
					[_name, _pos, 6] call SE_fnc_ambientVicSpawner;
				};
			} else
			{
				private _groupEntry = (townData getVariable [format["group_%1", _name], []]);

				if (typeName _groupEntry == "GROUP") then
				{
					if (count units _groupEntry != 0) then
					{
						private _garr = [];
						private _spawner = townData getVariable [format["spawner_%1", _name], []];

						{
							_garr pushBack (typeOf _x);
						} foreach(units _groupEntry);

						{
							deleteVehicle _x;
						} foreach(_spawner);

						townData setVariable [format["group_%1", _name], nil, false];
						townData setVariable [format["garrison_%1", _name], _garr, true];
						townData setVariable [format["spawner_%1", _name], [], true];
					} else
					{
						townData setVariable [format["group_%1", _name], nil, false];
						townData setVariable [format["garrison_%1", _name], [], true];
					};
				}
			};
		} foreach(SE_townData);
	};
};
