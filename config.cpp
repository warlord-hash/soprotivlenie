class CfgPatches
{
    class SE_Soprot
    {
        author = "studzy";
        requiredAddons[]=
        {
            "cba_ui",
            "cba_xeh",
            "cba_jr"
        };
        requiredVersion=1;
        units[]={};
        weapons[] = {"SE_Steel","SE_Wood"};
    };
};

#include "CfgWeapons.cpp"
#include "CfgFunctions.cpp"
#include "CfgMarkers.cpp"