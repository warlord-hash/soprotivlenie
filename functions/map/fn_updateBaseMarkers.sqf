private _knownBases = server getVariable ["SE_knownBases", []];

{
	_x params["_name"];
	deleteMarker _name;
} foreach(SE_baseMarkers);

{
	_x params["_pos", "_name", "_worth"];
	_marker = createMarker [_name, _pos];
	_marker setMarkerType "SE_Base";

	SE_baseMarkers pushBack _marker;
} foreach(_knownBases);