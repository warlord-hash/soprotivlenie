if(!isServer) exitWith {};

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

				if !(_x in (server getVariable ["SE_knownBases", []])) then
				{
					[_x] call SE_fnc_findBase;
				};
			} else
			{
				private _groups = (spawners getVariable [format["group_%1", _name], []]);
				private _spawned = (spawners getVariable [format["nato_%1", _name], []]);

				if (count _groups > 0) then
				{
					private _garr = [];
					private _vicGarrison = [];
					
					{
						if (count units _x != 0) then
						{

							{
								_garr pushBack (typeOf _x);
								deleteVehicle _x;
							} foreach(units _x);
						};
					} foreach _groups;

					{
						if (alive _x && !(_x isKindOf "Man")) then
						{
							_vicGarrison pushBack [[getPos _x, getDir _x], (typeOf _x)];
						};

						deleteVehicle _x;
					} foreach(_spawned);
					

					spawners setVariable [format["group_%1", _name], [], false];
					spawners setVariable [format["garrison_%1", _name], _garr, true];
					spawners setVariable [format["veh_%1", _name], _vicGarrison, true];
					spawners setVariable [format["nato_%1", _name], [], true];
				}
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

			_nearestShells = nearestObjects [_pos, ["ShellBase","MissileBase"], 2500, true];
			if(count _nearestShells > 0) then
			{
				// create marker
				_happening = townData getVariable [format["air_raid_%1", _name], false];
				if !(_happening) then
				{
					private _warningMarker = createMarker [format["siren_%1", _name], _pos];
					_warningMarker setMarkerType "mil_warning";
					_warningMarker setMarkerText "Air Raid Siren";
					_warningMarker setMarkerColor "ColorRed";
					hint str getMarkerPos format["siren_%1", _name];

					townData setVariable [format["air_raid_%1", _name], true, true];
					townData setVariable [format["air_raid_marker_%1", _name], _warningMarker, true];
				};
				
				private _timePlaying = townData getVariable [format["air_raid_time_playing_%1", _name], 35];
				if (_timePlaying == 35) then
				{
					(townData getVariable format["flag_%1", _name]) say3D ["AirRaidSiren", 1500, 1, true];
					townData setVariable [format["air_raid_time_playing_%1", _name], 0, true];
				} else
				{
					townData setVariable [format["air_raid_time_playing_%1", _name], _timePlaying + 5, true];
				};
			} else
			{
				// delete marker
				_warningMarker = townData getVariable [format["air_raid_marker_%1", _name], []];
				if (typeName _warningMarker != "ARRAY") then
				{
					deleteMarker _warningMarker;
					hint format["deleted marker for %1", _name];

					townData setVariable [format["air_raid_%1", _name], false, true];
					townData setVariable [format["air_raid_marker_%1", _name], nil, true];

					townData setVariable [format["air_raid_time_playing_%1", _name], 35, true];
				};
			};

			[] call SE_fnc_commanderLoop;


			// private _owner = townData getVariable [format["owner_%1", _name], west];
			// private _reinforced = aiCommander getVariable [format["reinforced_%1", _name], false];
			// if (_owner != west) then
			// {
			// 	if !(_reinforced) then
			// 	{
			// 		// send reinforcements from closest garrison
			// 		{
			// 			_x params ["_basePos", "_baseName", "_worth"];

			// 			_result = [_baseName, _basePos, _name, _pos] call SE_fnc_reinforceTown;
			// 			if (_result) then
			// 			{
			// 				break;
			// 			};
			// 		} foreach(SE_baseData);
			// 	} else
			// 	{
			// 		if !([_pos] call SE_fnc_inSpawnDistance) then
			// 		{
			// 			private _reinforcements = aiCommander getVariable format["reinforcements_%1", _name];
			// 			if (count units _reinforcements != 0) then
			// 			{
			// 				private _flag = townData getVariable format["flag_%1", _name];
			// 				townData setVariable [format["owner_%1", _name], west, true];

			// 				_flag removeAction 0;
			// 				_flag addAction ["Take Town", "events\takeTownControl.sqf", nil, 1, true, false];
			// 			}
			// 		};
			// 	};
			// };

		} foreach(SE_townData);
	};
};
