params ["_name", "_townPos", "_count"];

private _spawner = townData getVariable [format["spawner_%1", _name], []];
private _vics = [];
private _loops = 0;
while {((count _vics) < _count) && (_loops < 50)} do
{
	_loops = _loops + 1;

	private _pos = [[[_townPos, 300]]] call BIS_fnc_randomPos;
	private _roadArray = _pos nearRoads 70;

	if (count _roadArray > 0) then
	{
		private _road = _roadArray select floor (random (count _roadArray));
		private _selectedVic = SE_Civ_Vics select floor (random (count SE_Civ_Vics));

		private _connectingRoads = roadsConnectedTo  _road;
		private _dir = 0;
		if (count _connectingRoads == 2) then
		{
			_dir = [_road, _connectingRoads select 0] call BIS_fnc_dirTo;
			if (_dir == nil) then
			{
				_dir = 359;
			};
		};

		_vicPos = [position _road, 6, _dir + 90] call BIS_fnc_relPos;
		_emptyPos = _viCpos findEmptyPosition [4, 15, _selectedVic];

		if !(_vicPos distance _emptyPos > 4) then
		{
			private _vic = _selectedVic createVehicle _emptyPos;
			_vic setDir _dir;

			_vics pushBack _vic;
		};
	};
};

townData setVariable [format["spawner_%1", _name], (_spawner + _vics)];