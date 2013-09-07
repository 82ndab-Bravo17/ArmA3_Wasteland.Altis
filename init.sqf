																																																												asaerw3rw3r4 = 1; Menu_Init_Lol = 1;
//	@file Version: 1.2
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap
//	@file Description: The main init.

#define DEBUG false

StartProgress = false;
enableSaving [false, false];

X_Server = false;
X_Client = false;
X_JIP = false;
hitStateVar = false;
versionName = "v0.9b";

if (isServer) then { X_Server = true };
if (!isDedicated) then { X_Client = true };
if (isNull player) then { X_JIP = true };

[DEBUG] call compile preprocessFileLineNumbers "globalCompile.sqf";

[] spawn
{
	if (!isDedicated) then
	{
		titleText ["Welcome to A3Wasteland, please wait for your client to initialize", "BLACK", 0];
		waitUntil {!isNull player};
		client_initEH = player addEventHandler ["Respawn", {removeAllWeapons (_this select 0)}];
	};
};

//init Wasteland Core
if (X_Server) then {
	custom_config = compileFinal preProcessFileLineNumbers "A3W_Config.sqf";
	//publicVariable "custom_config";
};

if (X_Client) then {
	_timeout = 5;
	_requested = false;
	while {isNil "custom_config"} do {
		if (_timeout <= 0) then {
			if (_requested) then {
				EndMission "FAILED";	
			} else {
				_requested = true;
				// Code here
			};
		};
		_timeout = _timeout - 1;
		sleep 1;
	};
};
call custom_config;
call compile preProcessFileLineNumbers "config.sqf";
[] execVM "briefing.sqf";

if (!isDedicated) then
{
	waitUntil {!isNull player};

	//Wipe Group.
	if (count units player > 1) then
	{  
		diag_log "Player Group Wiped";
		[player] join grpNull;
	};

	[] execVM "client\init.sqf";
};

if (isServer) then
{
	diag_log format ["############################# %1 #############################", missionName];
	diag_log "WASTELAND SERVER - Initializing Server";
	[] execVM "server\init.sqf";
};

//init 3rd Party Scripts
[] execVM "addons\R3F_ARTY_AND_LOG\init.sqf";
[] execVM "addons\proving_Ground\init.sqf";
[] execVM "addons\scripts\DynamicWeatherEffects.sqf";
