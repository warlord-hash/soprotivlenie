params ["_baseName", "_basePos", "_name", "_pos"];
private _result = false;

if (_pos distance _basePos < 3000) then
{
	private _garrison = spawners getVariable [format["garrison_%1", _baseName], []];
	private _vicGarrison = spawners getVariable [format["veh_%1", _baseName], []];

	if (count _garrison > 0) then
	{
		private _force = [];
		private _toSelect = floor ((count _garrison) / 2);
		private _hasTransport = false;
		private _transport = [];

		for [{ _i = 0 }, { _i <= count _vicGarrison }, { _i = _i + 1 }] do
		{
			if (((_vicGarrison select _i) select 1) == SE_NATO_InfantryTruck) then
			{
				_hasTransport = true;
				_transport = _vicGarrison select _i;

				_vicGarrison deleteAt _i;
				break;
			};
		};

		for [{ _i = 0 }, { _i <= count _garrison }, { _i = _i + 1 }] do
		{
			_force pushBack (_garrison select _i);
			_garrison deleteAt _i;
		};

		_group = createGroup west;
		if (!_hasTransport) then
		{
			// whoops, have to go on foot now
			{
				private _unitSP = _group createUnit [_x, _basePos, [], 50, "NONE"];
				[_unitSP, format["losses_%1", _name], true] call SE_fnc_addUnitEventHandlers;
			} foreach(_force);

			[_group, _pos, 600] call CBA_fnc_taskAttack;
			[_group, _pos, 300, 5, "SAD", "SAFE", "RED", "FULL", "STAG COLUMN"] call CBA_fnc_taskPatrol;
			_result = true;
		} else
		{
			_vic = SE_NATO_InfantryTruck createVehicle ((_transport select 0) select 0);
			_vic setDir ((_transport select 0) select 1);

			{
				private _unitSP = _group createUnit [_x, _basePos, [], 50, "NONE"];
				[_unitSP, format["losses_%1", _name], true] call SE_fnc_addUnitEventHandlers;
				_unitSP moveInAny _vic;
			} foreach(_force);

			[_group, _pos, 300, 5, "SAD", "SAFE", "RED", "FULL", "STAG COLUMN"] call CBA_fnc_taskPatrol;

			_dismountWp = _group addWaypoint [_pos, 100, 0];
			_dismountWp setWaypointType "GETOUT";
			_dismountWp setWaypointBehaviour "SAFE";
			_dismountWp setWaypointCombatMode "RED";

			deleteWaypoint [_group, 1];

			_result = true;
		};

		spawners setVariable [format["veh_%1", _baseName], _vicGarrison, true];
		spawners setVariable [format["garrison_%1", _baseName], _garrison, true];
		aiCommander setVariable [format["reinforced_%1", _name], true, true];
		aiCommander setVariable [format["reinforcements_%1", _name], _force, true];
	} else
	{
		hint str "Empty garrison";
	};
};

_result;