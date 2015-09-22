/*
       This file is part of SourceIRC.

    SourceIRC is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SourceIRC is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with SourceIRC.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <regex>
#undef REQUIRE_PLUGIN
#include <sourceirc>

public Plugin:myinfo = {
	name = "SourceIRC -> Relay Chat",
	author = "Knackrack615",
	description = "Relays Chat",
	version = IRC_VERSION,
	url = "http://hgcommunity.net"
};

public OnPluginStart() {	
	PrintToServer("Plugin RelayChat Loaded!");
	LoadTranslations("sourceirc.phrases");
}

public OnAllPluginsLoaded() {
	if (LibraryExists("sourceirc"))
	IRC_Loaded();
}

public OnLibraryAdded(const String:name[]) {
	if (StrEqual(name, "sourceirc"))
	IRC_Loaded();
}

public OnLibraryRemoved(const String:name[]) {
	if (StrEqual(name, "sourceirc")) {
	RemoveCommandListener(Command_Say, "say");
	RemoveCommandListener(Command_Say, "say2");
	RemoveCommandListener(Command_Say, "say_team");
	}
}

IRC_Loaded() {
	IRC_CleanUp(); // Call IRC_CleanUp as this function can be called more than once.
	AddCommandListener(Command_Say, "say");
	AddCommandListener(Command_Say, "say2");
	AddCommandListener(Command_Say, "say_team");
}

public Action:Command_Say(client, const String:command[], argc) {
	decl String:text[192];
	decl String:name[64];
	decl String:finalmsg[64];
        GetCmdArg(1, text, sizeof(text));
	if(strlen(text) < 1) { return Plugin_Handled; }
	GetClientName(client, name, sizeof(name));
	Format(finalmsg, sizeof(finalmsg), "[Server] %s > %s", name, text);
	IRC_MsgFlaggedChannels("relay", finalmsg)
        return Plugin_Continue;
}

public OnPluginEnd() {
	IRC_CleanUp();
}
