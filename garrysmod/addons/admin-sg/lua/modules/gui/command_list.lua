--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local category = {};

category.name = "Command list";
category.material = "serverguard/menuicons/icon_commands.png";

function category:Create(base)
	base.panel = base:Add("tiger.panel")
	base.panel:SetTitle("Command list")
	base.panel:Dock(FILL)
  
	base.panel.list = base.panel:Add("tiger.list")
	base.panel.list:Dock(FILL)
	
	base.panel.list:AddColumn("COMMAND", 190)
	base.panel.list:AddColumn("DESCRIPTION", 250)
	base.panel.list:AddColumn("ARGUMENTS", 150)

	hook.Call("serverguard.panel.CommandList", nil, base.panel.list);

	local commands = serverguard.command:GetTable()
	
	for k, data in pairs(commands) do
		if (!data.permissions or serverguard.player:HasPermission(LocalPlayer(), data.permissions)) then
			base.panel.list:AddItem(data.command, data.help, serverguard.command:GetArgumentsString(data));
		end;
	end;
end;

function category:Update(base)
end

serverguard.menu.AddSubCategory("Information", category)