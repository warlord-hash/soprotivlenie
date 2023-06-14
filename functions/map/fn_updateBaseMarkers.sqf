private _knownBases = server getVariable ["SE_knownBases", []];

{
	_x params["_name"];
	deleteMarker _name;
} foreach(SE_baseMarkers);

{
	_x params["_pos", "_name", "_worth"];
	private _baseOwner = baseData getVariable ["owner_%1", west];

	_marker = createMarker [_name, _pos];
	_marker setMarkerType "flag_NATO";

	if (_baseOwner == west) then
	{
		_marker setMarkerColor "colorBLUFOR";
	} else
	{
		_marker setMarkerColor "colorIndependent";
	};

	SE_baseMarkers pushBack _marker;
} foreach(_knownBases);