class CfgFunctions
{
    class SE
    {
        class Base
        {
            file="\soprot\functions";
            class initVar {};
        };

        class Military
        {
            file="\soprot\functions\military";
            class findBase {};
        };

        class Map
        {
            file="\soprot\functions\map";
            class updateBaseMarkers {};
        };

        class NATO
        {
            file="\soprot\functions\factions\nato";
            class initNato {};
        };

        class Gendarm
        {
            file="\soprot\functions\factions\gendarm";
            class initGendarm {};
        };

        class Civ
        {
            file="\soprot\functions\factions\civ";
            class initCiv {};
        };

        class Virtualization
        {
            file="\soprot\functions\virtualization";
            class inSpawnDistance {};
        };

        class Spawners
        {
            file="\soprot\functions\virtualization\spawners";
            class natoMilBaseSpawner {};
            class gendarmPatrolSpawner {};
            class jetPatrolSpawn {};
            class ambientVicSpawner {};
        };

        class EventHandlers
        {
            file="\soprot\functions\eh";
            class addUnitEventHandlers {};
        };

        class AICommander
        {
            file="\soprot\functions\ai\commander";
            class getAvailableVehiclePool {};
        };
    };
};