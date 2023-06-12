params["_unitEH"];

_unitEH addMPEventHandler ["MPHit", {
	params ["_unit", "_causedBy", "_damage", "_instigator"];
	[_instigator] joinSilent createGroup independent;
}];

_unitEH addMPEventHandler ["MPKilled", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	[_unit] joinSilent createGroup civilian;
}];