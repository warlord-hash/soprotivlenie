#include "defineCommon.inc"
/*
	Author: Jeroen Notenbomer

	Description:
	Adds arsenal to a given object if run on client.
	Initilizes server
	
	Parameter(s):
	Object

	Returns:
	
	Usage: object call jn_fnc_arsenal_init;
	
*/
params [["_object",objNull,[objNull]]];


///////////////////////////////////////////////////////////////////////////////////////////////////////////////
diag_log ("Init JNA: Start " + str _object);
if(isNull _object)exitWith{["Error: wrong input given '%1'",_object] call BIS_fnc_error;};

//check if it was already initialised
if(_object getVariable ["jna_init",false])exitWith{diag_log ("Init JNA: Already initialised " + str _object) };
_object setVariable ["jna_init", true];



/* Indexes in the array correspond to these tabs:	DO NOT UNCOMMENT THIS BIT. THESE ARE ALREADY DEFINED
	IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON		0
	IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON	1
	IDC_RSCDISPLAYARSENAL_TAB_HANDGUN			2
	IDC_RSCDISPLAYARSENAL_TAB_UNIFORM			3
	IDC_RSCDISPLAYARSENAL_TAB_VEST				4
	IDC_RSCDISPLAYARSENAL_TAB_BACKPACK			5
	IDC_RSCDISPLAYARSENAL_TAB_HEADGEAR			6
	IDC_RSCDISPLAYARSENAL_TAB_GOGGLES			7
	IDC_RSCDISPLAYARSENAL_TAB_NVGS				8
	IDC_RSCDISPLAYARSENAL_TAB_BINOCULARS		9
	IDC_RSCDISPLAYARSENAL_TAB_MAP				10
	IDC_RSCDISPLAYARSENAL_TAB_GPS				11
	IDC_RSCDISPLAYARSENAL_TAB_RADIO				12
	IDC_RSCDISPLAYARSENAL_TAB_COMPASS			13
	IDC_RSCDISPLAYARSENAL_TAB_WATCH				14
	IDC_RSCDISPLAYARSENAL_TAB_FACE				15
	IDC_RSCDISPLAYARSENAL_TAB_VOICE				16
	IDC_RSCDISPLAYARSENAL_TAB_INSIGNIA			17
	IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC			18
	IDC_RSCDISPLAYARSENAL_TAB_ITEMACC			19
	IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE		20
	IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD			25
	IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG			21
	IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW		22
	IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT			23
	IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC			24
	IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL		26
*/

//change this for items that members can only take
jna_minItemMember = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
//jna_minItemMember = [10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,20,20,20,10,10];

//preload the ammobox so you dont need to wait the first time
["Preload"] call jn_fnc_arsenal;

//server
if(isServer)then{
	diag_log ("Init JNA: server " + str _object);

    //load default if it was not loaded from savegame
    pr _datalist = _object getVariable "jna_dataList";
    if(isnil "_datalist")then{
        _object setVariable ["jna_dataList" ,EMPTY_ARRAY];
    };
};

//player
if(hasInterface)then{
    diag_log ("Init JNA: player "+ str _object);

    //add arsenal button
    _id = _object addaction [
		(format ["<img image='%1' size='1' color='#ffffff'/>", STR_ACTION_ICON_ARSENAL] + format["<t size='1'>   %1</t>", STR_ACTION_TEXT_ARSENAL]),
        {
            pr _object = _this select 0;

            //start loading screen
			["jn_fnc_arsenal", "Loading Nutz™ Arsenal"] call bis_fnc_startloadingscreen;
			[] spawn {
				uisleep 5;
				pr _ids = missionnamespace getvariable ["BIS_fnc_startLoadingScreen_ids",[]];
				if("jn_fnc_arsenal" in _ids)then{
					pr _display =  uiNamespace getVariable ["arsanalDisplay","No display"];
					titleText["ERROR DURING LOADING ARSENAL", "PLAIN"];
					_display closedisplay 2;
					["jn_fnc_arsenal"] call BIS_fnc_endLoadingScreen;
				};
				
				//TODO this is a temp fix for rhs because it freezes the loading screen if no primaryWeapon was equiped. This will be fix in rhs 0.4.9
				if("bis_fnc_arsenal" in _ids)then{
					pr _display =  uiNamespace getVariable ["arsanalDisplay","No display"];
					diag_log "JNA: Non Fatal Error, RHS?";
					titleText["Non Fatal Error, RHS?", "PLAIN"];
					["bis_fnc_arsenal"] call BIS_fnc_endLoadingScreen;
				};

			};
            //save proper ammo because BIS arsenal rearms it, and I will over write it back again
            missionNamespace setVariable ["jna_magazines_init",  [
                magazinesAmmoCargo (uniformContainer player),
                magazinesAmmoCargo (vestContainer player),
                magazinesAmmoCargo (backpackContainer player)
            ]];

            //Save attachments in containers, because BIS arsenal removes them
            pr _attachmentsContainers = [[],[],[]];
            {
                pr _container = _x;
                pr _weaponAtt = weaponsItemsCargo _x;
                pr _attachments = [];

                if!(isNil "_weaponAtt")then{

                    {
                        pr _atts = [_x select 1,_x select 2,_x select 3,_x select 5];
                        _atts = _atts - [""];
                        _attachments = _attachments + _atts;
                    } forEach _weaponAtt;
                    _attachmentsContainers set [_foreachindex,_attachments];
                };
            } forEach [uniformContainer player,vestContainer player,backpackContainer player];
            
			UINamespace setVariable ["jna_containerCargo_init", _attachmentsContainers];
			UINamespace setVariable ["jn_type","arsenal"];
			UINamespace setVariable ["jn_object",_object];


            //request server to open arsenal
            [clientOwner,_object] remoteExecCall ["jn_fnc_arsenal_requestOpen",2];
        },
        [],
        6,
        true,
        false,
        "",
        "alive _target && {_target distance _this < 5} && {vehicle player == player}"
    ];
	//ACTION_SET_ICON_AND_TEXT(_object, _id, STR_ACTION_TEXT_ARSENAL, STR_ACTION_ICON_ARSENAL);

    //add vehicle/box filling button
    _id = _object addaction [
		(format ["<img image='%1' size='1' color='#ffffff'/>", STR_ACTION_ICON_ARSENAL_CONTAINER] + format["<t size='1'>   %1</t>", STR_ACTION_TEXT_ARSENAL_CONTAINER]),
        {
			pr _object = _this select 0;
			
			pr _script =  {
				params ["_object"];
				
				//check if player is looking at some object
				_object_selected = cursorObject;
				if(isnull _object_selected)exitWith{hint localize "STR_JNA_ACT_CONTAINER_SELECTERROR1"; };

				//check if object is in range
				if(_object distance cursorObject > 10)exitWith{hint localize "STR_JNA_ACT_CONTAINER_SELECTERROR2";};

				//check if object has inventory
				pr _className = typeOf _object_selected;
				pr _tb = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxbackpacks");
				pr _tm = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxmagazines");
				pr _tw = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxweapons");
				if !(_tb > 0  || _tm > 0 || _tw > 0) exitWith{hint localize "STR_JNA_ACT_CONTAINER_SELECTERROR3";};


				//set type and object to use later
				UINamespace setVariable ["jn_type","container"];
				UINamespace setVariable ["jn_object",_object];
				UINamespace setVariable ["jn_object_selected",_object_selected];

				
				//start loading screen and timer to close it if something breaks
				["jn_fnc_arsenal", "Loading Nutz™ Arsenal"] call bis_fnc_startloadingscreen;
				[] spawn {
					uisleep 5;
					pr _ids = missionnamespace getvariable ["BIS_fnc_startLoadingScreen_ids",[]];
					if("jn_fnc_arsenal" in _ids)then{
						pr _display =  uiNamespace getVariable ["arsanalDisplay","No display"];
						titleText["ERROR DURING LOADING ARSENAL", "PLAIN"];
						_display closedisplay 2;
						["jn_fnc_arsenal"] call BIS_fnc_endLoadingScreen;
					};
					
					//TODO this is a temp fix for rhs because it freezes the loading screen if no primaryWeapon was equiped. This will be fix in rhs 0.4.9
					if("bis_fnc_arsenal" in _ids)then{
						pr _display =  uiNamespace getVariable ["arsanalDisplay","No display"];
						diag_log "JNA: Non Fatal Error, RHS?";
						titleText["Non Fatal Error, RHS?", "PLAIN"];
						["bis_fnc_arsenal"] call BIS_fnc_endLoadingScreen;
					};

				};

				//request server to open arsenal
				[clientOwner,_object] remoteExecCall ["jn_fnc_arsenal_requestOpen",2];
			};
			pr _conditionActive = {
				params ["_object"];
				alive player;
			};
			pr _conditionColor = {
				params ["_object"];
				
				!isnull cursorObject
				&&{
					_object distance cursorObject < 10;
				}&&{
					//check if object has inventory
					pr _className = typeOf cursorObject;
					pr _tb = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxbackpacks");
					pr _tm = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxmagazines");
					pr _tw = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxweapons");
					if (_tb > 0  || _tm > 0 || _tw > 0) then {true;} else {false;};
				
				}//return
			};
						
			[_script,_conditionActive,_conditionColor,_object] call jn_fnc_common_addActionSelect;
		},
        [],
        6,
        true,
        false,
        "",
        "alive _target && {_target distance _this < 5} && {vehicle player == player}"
			
    ];
	//ACTION_SET_ICON_AND_TEXT(_object, _id, STR_ACTION_TEXT_ARSENAL_CONTAINER, STR_ACTION_ICON_ARSENAL_CONTAINER);
	
	//add Action to unload object
    _id = _object addaction [
		(format ["<img image='%1' size='1' color='#ffffff'/>", STR_ACTION_ICON_ARSENAL_UNLOAD] + format["<t size='1'>   %1</t>", STR_ACTION_TEXT_ARSENAL_UNLOAD]),
        {
			pr _object = _this select 0;
			
			pr _script =  {
				params ["_object"];//object action was attached to
				
				//check if player is looking at some object
				_object_selected = cursorObject;//selected object
				
				if(isnull _object_selected)exitWith{hint localize "STR_JNA_ACT_CONTAINER_SELECTERROR1"; };

				//check if object is in range
				if(_object distance cursorObject > 10)exitWith{hint localize "STR_JNA_ACT_CONTAINER_SELECTERROR2";};

				//check if object has inventory
				pr _className = typeOf _object_selected;
				pr _tb = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxbackpacks");
				pr _tm = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxmagazines");
				pr _tw = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxweapons");
				if !(_tb > 0  || _tm > 0 || _tw > 0) exitWith{hint localize "STR_JNA_ACT_CONTAINER_SELECTERROR3";};


				[_object_selected,_object] call jn_fnc_arsenal_cargoToArsenal;
			};
			pr _conditionActive = {
				params ["_object"];
				alive player;
			};
			pr _conditionColor = {
				params ["_object"];
				
				!isnull cursorObject
				&&{
					_object distance cursorObject < 10;
				}&&{
					//check if object has inventory
					pr _className = typeOf cursorObject;
					pr _tb = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxbackpacks");
					pr _tm = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxmagazines");
					pr _tw = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxweapons");
					if (_tb > 0  || _tm > 0 || _tw > 0) then {true;} else {false;};
				
				}//return
			};
						
			[_script,_conditionActive,_conditionColor,_object] call jn_fnc_common_addActionSelect;
		},
        [],
        6,
        true,
        false,
        "",
        "alive _target && {_target distance _this < 5} && {vehicle player == player}"
			
    ];
	//ACTION_SET_ICON_AND_TEXT(_object, _id, STR_ACTION_TEXT_ARSENAL_UNLOAD, STR_ACTION_ICON_ARSENAL_UNLOAD);
		

    if(missionNamespace getVariable ["jna_first_init",true])then{

        //add open event
        [missionNamespace, "arsenalOpened", {
            disableSerialization;
            UINamespace setVariable ["arsanalDisplay",(_this select 0)];

            //spawn this to make sure it doesnt freeze the game
            [] spawn {
                disableSerialization;
                _type = UINamespace getVariable ["jn_type",""];
                if(_type isEqualTo "arsenal")then{
                    ["CustomInit", [uiNamespace getVariable "arsanalDisplay"]] call jn_fnc_arsenal;
                };
				
				if(_type isEqualTo "container")then{
                    ["CustomInit", [uiNamespace getVariable "arsanalDisplay"]] call jn_fnc_arsenal_container;
                };

            };
        }] call BIS_fnc_addScriptedEventHandler;

    	//add close event
        [missionNamespace, "arsenalClosed", {

            _type = UINamespace getVariable ["jn_type",""];

            if(_type isEqualTo "arsenal")then{
                [clientOwner, UINamespace getVariable "jn_object"] remoteExecCall ["jn_fnc_arsenal_requestClose",2];
				UINamespace setVariable ["jn_type",""];
            };

            if(_type isEqualTo "container")then{
                ["Close"] call jn_fnc_arsenal_container;
                [clientOwner, UINamespace getVariable "jn_object"] remoteExecCall ["jn_fnc_arsenal_requestClose",2];
				UINamespace setVariable ["jn_type",""];
            };
        }] call BIS_fnc_addScriptedEventHandler;
    };
};

missionNamespace setVariable ["jna_first_init",false];

if(isServer)then{ 
	diag_log ("Init Server JNA: done" + str _object);
}else{
	diag_log ("Init pLayer JNA: done" + str _object);
};
