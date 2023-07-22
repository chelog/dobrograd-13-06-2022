--[[
	� 2017 Thriving Ventures Limited do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

serverguard = serverguard or {};
SERVERGUARD = SERVERGUARD or {};

serverguard.headerImage = "serverguard/icon_footer.png"

local folders = {}

function serverguard.AddFolder(path)
	table.insert(folders, path)
end

include("sg_shared.lua")

surface.CreateFont("verdana_13_bold", {font = "Verdana", size = 13, weight = 700})

surface.CreateFont("serverGuard_ownerFont", {font = "Calibri",size = 16})

surface.CreateFont("Default", {font = "Tahoma", size = 13, weight = 500, antialias = false})
surface.CreateFont("DefaultBold", {font = "Tahoma", size = 13, weight = 1000, antialias = false})
surface.CreateFont("DefaultSmall", {font = "Tahoma", size = 11, weight = 0, antialias = false})

surface.CreateFont("corbel_16", {font = "Corbel", size = 16})
surface.CreateFont("corbel_28", {font = "Corbel", size = 28})
surface.CreateFont("corbel_36", {font = "Corbel", size = 36})

surface.CreateFont("segoe.18", {font = "Segoe UI", size = 18, weight = 400})
surface.CreateFont("roboto_12", {font = "Roboto", size = 12, weight = 400})
surface.CreateFont("roboto.18", {font = "Roboto", size = 18, weight = 400})

surface.CreateFont("roboto.15.bold", {font = "Roboto", size = 15, weight = 700})
surface.CreateFont("roboto.18.bold", {font = "Roboto", size = 18, weight = 700})

serverguard.netstream.Hook("sgUpdateNotification", function(data)
	serverguard.latestVersion = data;
end);

hook.Add("Think", "serverguard.PlayerLoad", function()
	if (IsValid(LocalPlayer())) then
		file.CreateDir("serverguard");

		for i = 1, #folders do
			file.CreateDir("serverguard/"..folders[i]);
		end;

		g_serverGuard = {};

		hook.Call("serverguard.LoadPlayerData", nil, LocalPlayer());
		hook.Remove("Think", "serverguard.PlayerLoad");
	end;
end);

hook.Add("GUIMousePressed", "serverguard.MenuClose", function(mouseCode, aimVector)
	if (mouseCode == MOUSE_LEFT and IsValid(serverguard.GetMenuPanel())) then
		serverguard.menu.Close();
	end;
end);

hook.Add("VGUIMousePressed", "serverguard.MenuSearchReset", function(panel, mouseCode)
	local panelObject = serverguard.GetMenuPanel();

	if (IsValid(panelObject)) then
		panelObject:ResetSearch();
	end;
end);
