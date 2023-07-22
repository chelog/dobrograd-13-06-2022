--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.CLIENT);
plugin:IncludeFile("sh_commands.lua", SERVERGUARD.STATE.CLIENT);
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);

plugin:Hook("PlayerBindPress", "votes.PlayerBindPress", function(player, bind, pressed)
	if (plugin.vote) then
		local option = tonumber(bind:match("slot(%d)"));

		if (option and plugin.vote.options[option]) then
			serverguard.netstream.Start("CastVote", option);

			plugin.vote = nil;

			if (IsValid(plugin.panel)) then
				plugin.panel.checkboxes[option]:SetChecked(true);
				plugin.panel:FadeOut();
			end;

			return true;
		end;
	end;
end);

serverguard.netstream.Hook("CreateVote", function(data)
	plugin.vote = data;
	plugin.panel = vgui.Create("tiger.panel.vote");

	timer.Simple(15, function()
		if (IsValid(plugin.panel)) then
			plugin.panel:FadeOut();
		end;
	end);
end);