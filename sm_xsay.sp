#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

Handle g_hSynchronizer = null;

public Plugin myinfo = {
	name = "sm_xsay",
	author = "Switchback",
	description = "Admin messages using game_text entity",
	version = "1.2.7",
	url = "http://steamcommunity.com/id/switchwwe/"
};

public void OnPluginStart() {
	LoadTranslations("common.phrases");

	g_hSynchronizer = CreateHudSynchronizer();

	RegAdminCmd("sm_xsay", Command_XSay, ADMFLAG_CHAT, "sm_xsay <message> - sends game text message at the top of mid to all players");
}

public Action Command_XSay(int client, int args) {
	if (args < 1) {
		ReplyToCommand(client, "[SM] Usage: sm_xsay <message>");
		return Plugin_Handled;
	}

	char text[100];
	GetCmdArgString(text, sizeof(text));

	char sBuffer[256];
	Format(sBuffer, sizeof(sBuffer), "%N: %s", client, text);

	SetHudTextParams(-1.0, 0.2, 5.0, 128, 255, 0, 255, 2, 0.5, 0.02, 0.3);
	for (int i = 1; i < MaxClients; i++) {
		if (!IsClientInGame(i)) {
			continue;
		}

		ShowSyncHudText(i, g_hSynchronizer, sBuffer);
	}

	LogAction(client, -1, "\"%L\" triggered sm_xsay (text %s)", client, text);

	return Plugin_Handled;
}
