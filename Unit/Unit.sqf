#include "..\OOP_Light\OOP_Light.h"
CLASS("Unit", "")
	VARIABLE("type");
	VARIABLE("pos");
	VARIABLE("dir");
	VARIABLE("spawned");

	METHOD("new") {
		params [THISOBJECT, "_type", "_pos", "_dir"];

		SETV(_thisObject, "type", _type);
		SETV(_thisObject, "pos", _pos);
		SETV(_thisObject, "dir", _dir);
		SETV(_thisObject, "spawned", false);
	} ENDMETHOD;
ENDCLASS;