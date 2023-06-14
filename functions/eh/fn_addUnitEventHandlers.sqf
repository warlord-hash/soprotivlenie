params["_unitEH", "_lossesVarName", "_addToGlobal"];

_unitEH setVariable ["losses_name", _lossesVarName, true];
_unitEH setVariable ["_add_global", _addToGlobal, true];

_unitEH addMPEventHandler ["MPHit", {
	params ["_unit", "_causedBy", "_damage", "_instigator"];
	[_instigator] joinSilent createGroup independent;
}];

_unitEH addMPEventHandler ["MPKilled", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	[_unit] joinSilent createGroup civilian;

	private _losses = aiCommander getVariable [(_unit getVariable "losses_name"), 0];
	_losses = _losses + 1;

	aiCommander setVariable [(_unit getVariable "losses_name"), _losses, true];

	if(_unit getVariable "_add_global") then
	{
		private _losses = aiCommander getVariable ["mil_losses", 0];
		_losses = _losses + 1;

		aiCommander setVariable ["mil_losses", _losses, true];
	};
}];