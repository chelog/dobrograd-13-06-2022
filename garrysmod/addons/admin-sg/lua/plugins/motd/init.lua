--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

serverguard.AddFolder("motd");

local plugin = plugin;
local storedConfig = nil;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("sh_commands.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);

local function LOAD_CONFIG()
	if (!storedConfig) then
		storedConfig = {};

		for k, v in pairs(plugin.config) do
			storedConfig[v.uniqueID] = v.default;
		end;

		local savedConfig = file.Read("serverguard/motd/settings.txt");

		if (savedConfig) then
			local deserializedConfig = serverguard.von.deserialize(savedConfig);

			if (deserializedConfig and table.Count(deserializedConfig) > 0) then
				table.Merge(storedConfig, deserializedConfig);
			end;
		end;
	end;
end;

serverguard.netstream.Hook("sgRequestMOTDConfig", function(player, data)
	LOAD_CONFIG(); -- called here because it might be the first time the plugin is enabled

	serverguard.netstream.Start(player, "sgReceiveMOTDConfig", {storedConfig, false});
end);

serverguard.netstream.Hook("sgUpdateMOTDConfig", function(player, data)
	if (!serverguard.player:HasPermission(player, "Manage MOTD") or !plugin.toggled) then
		return;
	end;

	if (storedConfig[data.uniqueID]) then
		storedConfig[data.uniqueID] = data.value;
	end;

	file.Write("serverguard/motd/settings.txt", serverguard.von.serialize(storedConfig), "DATA");

	serverguard.netstream.Start(nil, "sgReceiveMOTDConfig", {storedConfig, false});
end);

plugin:Hook("InitPostEntity", "serverguard.motd.InitPostEntity", function()
	LOAD_CONFIG();
end);

plugin:Hook("PlayerInitialSpawn", "serverguard.motd.PlayerInitialSpawn", function(player, steamID, uniqueID)
	serverguard.netstream.Start(player, "sgReceiveMOTDConfig", {storedConfig, true});
end);