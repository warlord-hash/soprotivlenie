params["_pos", "_length"];

private _group = createGroup west;

private _pilot = _group createUnit [SE_NATO_JetPilot, [0,0], [], 0, "NONE"];
private _jet = createVehicle [SE_NATO_InterceptorJet, [0,0], [], 0, "FLY"];
_pilot moveInDriver _jet;

[_group, _pos, 1000, 2, "MOVE", "SAFE", "RED", "NORMAL", "STAG COLUMN"] call CBA_fnc_taskPatrol;