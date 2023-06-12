params ["_hasAA"];

private _aggression = aiCommander getVariable ["aggression", 0];
if (_aggression <= 0.25) then
{
	SE_NATO_HarmlessVics;
};

if (_aggression > 0.25 && _agression <= .4) then
{
	(SE_NATO_HarmlessVics + [SE_NATO_MRAP_HMG, SE_NATO_MRAP_GMG]);
};

if (_aggression > .4 && _aggressioin <= .6) then
{
	if !(hasAA) then
	{
		(SE_NATO_HarmlessVics + [SE_NATO_MRAP_HMG, SE_NATO_MRAP_GMG, SE_NATO_NamerAPC]);
	} else
	{
		(SE_NATO_HarmlessVics + [SE_NATO_MRAP_HMG, SE_NATO_MRAP_GMG, SE_NATO_NamerAPC, SE_NATO_TrackedAA]);
	};
};