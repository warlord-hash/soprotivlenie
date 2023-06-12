params ["_hasAA"];

// when proper AI commander shit gets done, we'll bring in vics from the pool to an airbase which will then
// disperse it throughout outposts and bases, and possibly begin offensive on player (depending on what the
// player captured)

private _aggression = aiCommander getVariable ["aggression", 0];
private _pool = [];
if (_aggression <= 0.25) then
{
	_pool = SE_NATO_HarmlessVics;
};

if (_aggression > 0.25 && _aggression <= .4) then
{
	_pool = (SE_NATO_HarmlessVics + [SE_NATO_MRAP_HMG, SE_NATO_MRAP_GMG]);
};

if (_aggression > .4 && _aggression <= .6) then
{
	if !(hasAA) then
	{
		_pool = (SE_NATO_HarmlessVics + [SE_NATO_MRAP_HMG, SE_NATO_MRAP_GMG, SE_NATO_NamerAPC]);
	} else
	{
		_pool = (SE_NATO_HarmlessVics + [SE_NATO_MRAP_HMG, SE_NATO_MRAP_GMG, SE_NATO_NamerAPC, SE_NATO_TrackedAA]);
	};
};

if (_aggression > 0.6) then
{
	if !(hasAA) then
	{
		_pool = (SE_NATO_HarmlessVics + [SE_NATO_MRAP_HMG, SE_NATO_MRAP_GMG, SE_NATO_NamerAPC, SE_NATO_MerkavaTankNoHMG]);
	} else
	{
		_pool = (SE_NATO_HarmlessVics + [SE_NATO_MRAP_HMG, SE_NATO_MRAP_GMG, SE_NATO_NamerAPC, SE_NATO_TrackedAA, SE_NATO_MerkavaTankNoHMG]);
	};
};

_pool;