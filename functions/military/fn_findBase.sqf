params ["_base"];

// if for whatever fucking reason its not declared
if !(_base in (server getVariable ["SE_knownBases", []])) then
{
	private _knownBases = server getVariable ["SE_knownBases", []];
	_knownBases pushBack _base;

	server setVariable ["SE_knownBases", _knownBases, true];
	[] call SE_fnc_updateBaseMarkers;
};