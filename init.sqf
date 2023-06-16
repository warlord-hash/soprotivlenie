#include "common.h"
CALL_COMPILE_COMMON("OOP_Light\OOP_Light_init.sqf");
CALL_COMPILE_COMMON("Location\Location.sqf");
CALL_COMPILE_COMMON("World\World.sqf");

world = NEW("World", []);
publicVariable("world");

CALLM(world, "initWorld", [world]);