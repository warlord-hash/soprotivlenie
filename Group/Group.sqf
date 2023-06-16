// A group consists of multiple units joined together
#include "..\OOP_Light\OOP_Light.h"
CLASS("Group", "")
	VARIABLE("units");
	VARIABLE("spawned");
	
	METHOD("new") {
		params [THISOBJECT];

		SETV(_thisObject, "units", []);
		SETV(_thisObject, "spawned", false);
	} ENDMETHOD;
ENDCLASS;