#include "./common.hpp"
params ["_to", "_toPos", "_toWorth", "_type"];

// find closest base
private _closestBase = [];
{
	_x params ["_pos", "_name", "_worth"];
	if(_name == _to) then {
		continue;
	};

	if((count _closestBase) == 0) then
	{
		_closestBase = _x;
	} else
	{
		if !([_pos] call SE_fnc_inSpawnDistance) then
		{
			if((_pos distance _toPos) < ((_closestBase select 0) distance _toPos)) then
			{
				_closestBase = _x;
			};
		};
	};
} foreach (SE_baseData);

if(_type == SE_CONVOY_INF) then
{
	// we want to reinforce it to at least 50%, depending on it's worth
	_closestBase params["_fromPos", "_from", "_fromWorth"];
   
    private _percentage = 0;
	if(_toWorth > 1000) then
	{
		_percentage = 60;
	};

	if (_toWorth < 1000) then
	{
		_percentage = 50;
	};

	private _toGarrison = spawners getVariable format["garrison_%1", _to];
	private _fromGarrison = spawners getVariable format["garrison_%1", _from];
	private _infAmount = (count _toGarrison) * _percentage;
	private _toSend = (count _fromGarrison) / 2;

	if(_toSend > _infAmount) then
	{
		_toSend = _infAmount;
	};
	
	// check if has transport
	private _hasTransport = false;
	private _transport = [];
	private _vicGarrison = spawners getVariable format["veh_%1", _from];
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

	// spawn units
	private _group = createGroup west;
	private _vic = [];
	if (_hasTransport) then
	{
		_vic = createVehicle [SE_NATO_InfantryTruck, ((_transport select 0) select 0), [], 200, "NONE"];

		for [{_i = 0}, {_i <= _toSend}, {_i = _i + 1}] do
		{
			_unitSP = _group createUnit [_fromGarrison select (floor(random _toSend)), _fromPos, [], 50, "NONE"];
			[_unitSP, "mil_losses", false] call SE_fnc_addUnitEventHandlers;

			_unitSP moveInAny _vic;
		};

		// TODO: calculate path with A3GPS
		// for now just put a move waypoint to there
		_moveWP = _group addWaypoint [_toPos, 100];
		_moveWP setWaypointType "MOVE";

		// TODO: add escort vehicles
		hint str _toPos;
	} else
	{
		for [{_i = 0}, {_i <= _toSend}, {_i = _i + 1}] do
		{
			_unitSP = _group createUnit [_fromGarrison select (floor(random _toSend)), _fromPos, [], 50, "NONE"];
			[_unitSP, "mil_losses", false] call SE_fnc_addUnitEventHandlers;
		};

		_moveWP = _group addWaypoint [_toPos, 100];
		_moveWP setWaypointType "MOVE";
		hint str _toPos;
	};

	aiCommander setVariable [format["reinforcing_%1", _to], true, true];
};
