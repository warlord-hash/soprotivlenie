#include "..\OOP_Light\OOP_Light.h"
CLASS("Location", "")
	VARIABLE("type");
	VARIABLE("name");
	VARIABLE("pos");
	VARIABLE("garrison");
	VARIABLE("children");
	VARIABLE("bounds");
	VARIABLE("border");
	VARIABLE("capacityInf");
	
	METHOD("new") {
		params[THISOBJECT, "_pos"];
		SETV(_thisObject, "type", SE_LOC_TYPE_UNKNOWN);
		SETV(_thisObject, "name", "unknown");
		SETV(_thisObject, "garrison", []);
		SETV(_thisObject, "pos", _pos);
		SETV(_thisObject, "children", []);
		SETV(_thisObject, "capacityInf", 0);

		CALLM(_thisObject, "initBuildings", []);
	} ENDMETHOD;
	
	METHOD("setName") {
		params[THISOBJECT, "_name"];
		SETV(_thisObject, "name", _name);
	} ENDMETHOD;

	METHOD("setType") {
		params[THISOBJECT, "_type"];
		SETV(_thisObject, "type", _type);
	} ENDMETHOD;

	METHOD("setBounds") {
		// taken from vindicta!!
		params[THISOBJECT, "_data"];

		_data params ["_a", "_b", "_dir", "_isRectangle"];
		private _boundingRadius = if(_isRectangle) then {
			sqrt(_a*_a + _b*_b);
		} else {
			_a max _b
		};

		SETV(_thisObject, "bounds", _boundingRadius);
		
		private _border = [GETV(_thisObject, "pos"), _a, _b, _dir, _isRectangle, -1];
		SETV(_thisObject, "border", _border);
	} ENDMETHOD;

	METHOD("isInBorder") {
		params [THISOBJECT, "_pos"];
		_pos inArea GETV(_thisObject, "border");
	} ENDMETHOD;

	METHOD("initBuildings") {
		params[THISOBJECT];

		SE_Loc_BuildingTypes = [
			["Land_i_Barracks_V1_F", 16],
			["Land_i_Barracks_V2_F", 16],
			["Land_u_Barracks_V2_F", 16],
			["Land_Cargo_House_V1_F", 4],
			["Land_Cargo_House_V3_F", 4],
			["Land_Cargo_House_V2_F", 4],
			["Land_Cargo_Tower_V3_F", 8],
			["Land_Cargo_Tower_V1_F", 8],
			["Land_Cargo_Tower_V2_F", 8],
			["Land_Cargo_HQ_V3_F", 8],
			["Land_Cargo_HQ_V1_F", 8],
			["Land_Cargo_HQ_V2_F", 8]
		];
	} ENDMETHOD;

	METHOD("calculateInfCapacity") {
		params [THISOBJECT];
		
		private _nearestHouses = (GETV(_thisObject, "pos")) nearObjects (GETV(_thisObject, "bounds"));
		private _capacity = 0;
		{
			if(_x isKindOf "House") then
			{
				if(CALLM(_thisObject, "isInBorder", [getPos _x])) then
				{
					private _class = (typeOf _x);
					private _buildingClass = SE_Loc_BuildingTypes select { _class in (_x select 0) };
					if(count _buildingClass > 0) then
					{
						hint str ((_buildingClass select 0) select 1);
						_capacity = _capacity +  ((_buildingClass select 0) select 1);
					};
				};
			};
		} foreach _nearestHouses;

		diag_log(format["inf capacity: %1", _capacity]);
		SETV(_thisObject, "capacityInf", _capacity);
	} ENDMETHOD;
ENDCLASS;