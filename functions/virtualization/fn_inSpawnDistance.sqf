params ["_pos"];

private _playerAtPos = false;

{
	if (_pos distance position _x <= SE_SpawnDistance) then
	{
		_playerAtPos = true;
	};
} forEach(allPlayers);

_playerAtPos;