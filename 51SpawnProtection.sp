#include <sdkhooks>
#include <sdktools>
#include <sourcemod>
#include <tf2>
#pragma semicolon 1

public Plugin myinfo =
{
	name = "51SpawnProtection",
	author = "Alexander Tara",
	description = "",
	version = "1.0.0",
	url = "https://github.com/JTzLinux/"
};

new bool:g_bEnabled = true;

public void OnPluginStart()
{
	// Register the console command for managing the plugin
	RegAdminCmd("51spawnprotection", Command_51SpawnProtection, ADMFLAG_GENERIC, "Manage 51SpawnProtection plugin");
	
	// Initialize the plugin status
	g_bEnabled = true;
	PrintToServer("51SpawnProtection loaded");
}

public void OnPluginEnd()
{
	PrintToServer("51SpawnProtection unloaded");
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
		PrintToServer("51SpawnProtection: No func_respawnroom entities found");
	}
	else
	{
		PrintToServer("51SpawnProtection: %d func_respawnroom entities found", spawns);
	}
}

public Action OnStartTouch(int spawn, int entity)
{
	if (g_bEnabled){TF2_AddCondition(entity, TFCond_UberchargedHidden, TFCondDuration_Infinite, 0);}
	return Plugin_Handled;
}

public Action OnEndTouch(int spawn, int entity)
{
	if (g_bEnabled){TF2_RemoveCondition(entity, TFCond_UberchargedHidden);}
	return Plugin_Handled;
}

public Action Command_51SpawnProtection(int client, int args)
{
	if (args > 0)
	{
		ReplyToCommand(client, "[SM] Usage: 51spawnprotection");
		return Plugin_Handled;
	}
	
	g_bEnabled = !g_bEnabled;
	if (g_bEnabled)
	{
		PrintToServer("51SpawnProtection disabled");
		b_gEnabled = false;
	}
	else
	{
		PrintToServer("51SpawnProtection enabled");
		b_gEnabled = true;
	}
	return Plugin_Handled;
}