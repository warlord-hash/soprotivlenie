if (!isServer) exitwith {};

/*
*
* ---------- UNITS ----------
*
*/

SE_NATO_Rifleman = "B_Soldier_F";
SE_NATO_Grenadier = "B_Soldier_GL_F";
SE_NATO_MachineGunner = "B_soldier_AR_F";
SE_NATO_LightAT = "B_soldier_LAT_F";
SE_NATO_SquadLead = "B_Soldier_SL_F";
SE_NATO_JetPilot = "O_Pilot_F";

/*
*
* ---------- VEHICLES ----------
*
*/

SE_NATO_InfantryTruck = "B_Truck_01_transport_F";
SE_NATO_FuelTruck = "B_Truck_01_fuel_F";
SE_NATO_MRAPUnarmed = "B_MRAP_01_F";
SE_NATO_MRAPhmg = "B_MRAP_01_hmg_F";

/*
*
* ---------- STATICs -----------
*
*/

SE_NATO_StaticHMG = "B_HMG_01_high_F";
SE_NATO_StaticGMG = "B_GMG_01_high_F";

/*
*
* ---------- PLANES ----------
*
*/

SE_NATO_FighterJet = "B_Plane_Fighter_01_F";


/*
*
* ---------- GARRISONS ----------
*
*/

SE_NATO_GarrLevelOne = [SE_NATO_SquadLead, SE_NATO_Rifleman, SE_NATO_Rifleman, SE_NATO_Grenadier, SE_NATO_MachineGunner, SE_NATO_LightAT];
SE_NATO_GarrLevelTwo = [];

SE_NATO_HarmlessVics = [SE_NATO_InfantryTruck, SE_NATO_FuelTruck, SE_NATO_MRAPUnarmed];
SE_NATO_GunVics = [SE_NATO_MRAPhmg];
SE_NATO_Statics = [SE_NATO_StaticHMG, SE_NATO_StaticGMG];