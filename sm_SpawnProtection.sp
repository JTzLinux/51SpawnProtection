#include <sdkhooks>
#include <sdktools>
#include <sourcemod>
#include <tf2>
#pragma semicolon 1

public Plugin myinfo =
{
	name = "sm_SpawnProtection",
	author = "Alexander Tara",
	description = "",
	version = "1.0.0",
	url = "https://github.com/JTzLinux/"
};

new bool:g_bEnabled;

public void OnPluginStart()
{
	// Register the console command for managing the plugin
	RegAdminCmd("sm_spawnprotection", Command_51SpawnProtection, ADMFLAG_GENERIC, "Manage SpawnProtection plugin");
	
	// Initialize the plugin status
	g_bEnabled = true;
	PrintToServer("sm_SpawnProtection loaded");
}

public void OnPluginEnd()
{
	PrintToServer("sm_SpawnProtection unloaded");
}

public void OnMapStart()
{
	int spawns = 0;
	int spawn = -1; // Change `new` to `int`
	// Add hook to check if player is inside a func_respawnroom
	while ((spawn = FindEntityByClassname(spawn, "func_respawnroom")) != INVALID_ENT_REFERENCE)
	{
		spawns++;
		if (IsValidEdict(spawn))
		{
			SDKHook(spawn, SDKHook_StartTouch, OnStartTouch);
			SDKHook(spawn, SDKHook_EndTouch, OnEndTouch);
		}
	}
	if (spawns == 0)
	{
		PrintToServer("sm_SpawnProtection: No func_respawnroom entities found");
	}
	else
	{
		PrintToServer("sm_SpawnProtection: %d func_respawnroom entities found", spawns);
	}
}

public Action OnStartTouch(int spawn, int entity)
{
	if (g_bEnabled)
	{
		TF2_AddCondition(entity, TFCond_UberchargedHidden, TFCondDuration_Infinite, 0);
	}
	return Plugin_Handled;
}

public Action OnEndTouch(int spawn, int entity)
{
	if (g_bEnabled)
	{
		TF2_RemoveCondition(entity, TFCond_UberchargedHidden);
	}
	return Plugin_Handled;
}

public Action Command_51SpawnProtection(int client, int args)
{
	if (args > 0)
	{
		ReplyToCommand(client, "[SM] Usage: sm_spawnprotection");
		return Plugin_Handled;
	}
	
	g_bEnabled = !g_bEnabled;
	if (g_bEnabled)
	{
		PrintToServer("SpawnProtection enabled");
	}
	else
	{
		PrintToServer("SpawnProtection disabled");
	}
	return Plugin_Handled;
}
