// A garrison consists  of multiple groups joined together
#include "..\OOP_Light\OOP_Light.h"
CLASS("Garrison", "")
	VARIABLE("groups");
	VARIABLE("belongsTo");
	VARIABLE("spawned");
	METHOD("new") {
		params [THISOBJECT, "_loc"];

		SETV(_thisObject, "groups", []);
		SETV(_thisObject, "belongsTo", _loc);
		SETV(_thisObject, "spawned", false);
	} ENDMETHOD;
ENDCLASS;