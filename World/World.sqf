#include "..\OOP_Light\OOP_Light.h"
CLASS("World", "")
	VARIABLE("locations");
	
	METHOD("new") {
		params [THISOBJECT];

		SETV(_thisObject, "locations", []);
	} ENDMETHOD;

	METHOD("initWorld") {
		params[THISOBJECT];
		
		diag_log "init world...";

		CALLM(_thisObject, "initLocations", []);
		CALLM(_thisObject, "initMarkers", []);
	} ENDMETHOD;

	METHOD("initLocations") { 
		params [THISOBJECT];

		{
			private _locPos = getPos _x;
			_locPos set [2, 0];

			private _locName = _x getVariable ["Name", ""];
			private _locType = _x getVariable ["Type", ""];
			private _locArea = _x getVariable ["objectArea", [50, 50, 0, true]];

			diag_log format["init loc %1", _locName];

			private _loc = NEW("Location", [_locPos]);
			CALLM(_loc, "setName", [_locName]);
			CALLM(_loc, "setType", [_locType]);
			CALLM(_loc, "setBounds", [_locArea]);

			private _locs = GETV(_thisObject, "locations");
			_locs pushBack _loc;

			SETV(_thisObject, "locations", _locs);
			CALLM(_loc, "calculateInfCapacity", []);
		} foreach entities "SE_Module_Location";
	} ENDMETHOD;

	METHOD("initMarkers") {
		params [THISOBJECT];
		{
			private _loc = _x;
			if((GETV(_loc, "type")) == SE_LOC_TYPE_TOWN) then
			{
				_locName = GETV(_loc, "name");
				_locPos = GETV(_loc, "pos");

				_locMarker = createMarker [_locName, _locPos];
				_locMarker setMarkerType "loc_LetterT";
			};
		} foreach GETV(_thisObject, "locations");
	} ENDMETHOD;
ENDCLASS;