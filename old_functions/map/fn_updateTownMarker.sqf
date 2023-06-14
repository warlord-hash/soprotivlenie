params ["_name"];

_marker = townData getVariable format["marker_%1", _name];
_owner = townData getVariable [format["owner_%1", _name], west];

if(_owner == west) then
{
	_marker setMarkerColor "colorBLUFOR";
} else
{
	_marker setMarkerColor "colorIndependent";
};