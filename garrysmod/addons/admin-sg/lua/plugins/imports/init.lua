--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("imports/ulx.lua", SERVERGUARD.STATE.SERVER);

function plugin:Load(addon, import)
	addon, import = string.lower(addon), string.lower(import);
	
	local addonTable = self[addon];

	if (addonTable) then
		if (addonTable[import]) then
			local bSuccess, message = addonTable[import]();

			if (bSuccess) then
				serverguard.PrintConsole(string.format("%s %s imported successfully.\n", addon, import));
			elseif (message) then
				serverguard.PrintConsole(string.format("%s %s failed to import (%s).\n", addon, import, message));
			else
				serverguard.PrintConsole(string.format("%s %s failed to import.\n", addon, import));
			end;
		else
			serverguard.PrintConsole(string.format("%s has no import for %q.\n", addon, import));
		end;
	else
		serverguard.PrintConsole(string.format("No imports found for %s.\n", addon));
	end;
end;

concommand.Add("serverguard_import", function(player, command, arguments)
	if (util.IsConsole(player)) then
		local addon = arguments[1];
		local import = arguments[2];

		if (!addon or !import) then
			serverguard.PrintConsole("You must specify an addon and what to import from it.\n");
			return;
		end;

		plugin:Load(addon, import);
	end;
end);