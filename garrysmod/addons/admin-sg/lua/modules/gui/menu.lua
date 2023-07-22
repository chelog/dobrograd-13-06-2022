--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

serverguard.menu = serverguard.menu or {};

local stored = {};

local panelObject = nil;
local panelObjectStay = false;
local panelQuickMenu = nil;
local hints = {
	"Try binding '+serverguard_menu' to open the menu, or '+serverguard_quickmenu' for quick access to commands.",
	"You can search for categories on the left simply by typing the name of the category.",
	"When using commands, you can specify *, ^, or #admin as the name to target everyone, yourself, or only admins.",
	"You can run any command from the console by typing 'sg <command> <arguments>'.",
	"You can return to your last position after using a teleport command by using the !return command.",
	"Clicking anywhere outside of the menu will also close it."
};

--
-- Add a category.
--

function serverguard.menu.AddCategory(data)
	data.material = data.material or "icon16/exclamation.png";
	data.Update = data.Update or function() end;
	data.Think = data.Think or function() end;
	data.submenus = data.submenus or {};

	if data.permissions then
		serverguard.permission:Add(data.permissions);
	end;

	stored[data.name] = stored[data.name] or data;
end;

--
-- Add a subcategory.
--

function serverguard.menu.AddSubCategory(parent_name, data)
	if (stored[parent_name]) then
		data.material = data.material or "icon16/exclamation.png"
		data.Update = data.Update or function() end
		data.Think = data.Think or function() end

		if data.permissions then
			serverguard.permission:Add(data.permissions)
		end

		stored[parent_name].submenus[data.name] = stored[parent_name].submenus[data.name] or data
	end
end


--
-- Remove a subcategory.
--

function serverguard.menu:RemoveSubCategory(parent_name, uniqueID)
	if (stored[parent_name].submenus[uniqueID]) then
		stored[parent_name].submenus[uniqueID] = nil

		self:Rebuild()
	end
end

--
-- Remove a category.
--

function serverguard.menu:RemoveCategory(uniqueID)
	if (stored[uniqueID]) then
		stored[uniqueID] = nil;

		self:Rebuild();
	end;
end;

--
-- Get all categories.
--

function serverguard.menu:GetStored()
	return stored;
end;

--
-- Get category by name.
--

function serverguard.menu:GetByName(name)
	local stored = serverguard.menu:GetStored();
	return stored[name] or false;
end;

--
-- Rebuild the menu.
--

function serverguard.menu:Rebuild()
	if (IsValid(panelObject)) then
		panelObject:Rebuild();
	end;
end;

--
-- Close the menu.
--

function serverguard.menu.Close(bForce)
	if (IsValid(panelObject) and !panelObjectStay or bForce) then
		panelObject:SetVisible(false);
		hook.Call("serverguard.menu.Close", nil, panelObject);
	end;
end;

--
-- Returns the menu panel.
--

function serverguard.GetMenuPanel()
	return panelObject;
end;

--
-- Set whether or not to make the menu stay open.
--

function serverguard.SetMenuStay(bool)
	panelObjectStay = bool;
end;

--
-- Returns the quick menu panel.
--

function serverguard.GetQuickMenuPanel()
	return panelQuickMenu;
end;

--
-- Open the menu.
--

local function CreateMenu(player)
	if (!IsValid(panelObject)) then
		panelObject = vgui.Create("tiger.base");
		panelObject:SetSize(
			(ScrW() >= 950 and 950) or ScrW(),
			(ScrH() >= 650 and 650) or ScrH()
		);

		panelObject:Rebuild();
		panelObject:Center();
		panelObject:MakePopup();

		local closeLabel = panelObject:Add("DLabel");
		closeLabel:SetPos(panelObject:GetWide() - 18, 0);
		closeLabel:SetText("x");
		closeLabel:SetFont("roboto.18.bold");
		closeLabel:SetColor(Color(180, 180, 180));
		closeLabel:SetCursor("hand");
		closeLabel:SetSize(40, 30);
		closeLabel:SetMouseInputEnabled(true);

		function closeLabel:DoClick()
			panelObjectStay = false;
			panelObject:SetVisible(false);
		end;

		function closeLabel:OnCursorEntered()
			self:SetColor(Color(130, 130, 130));
		end;

		function closeLabel:OnCursorExited()
			self:SetColor(Color(180, 180, 180));
		end;

		if (serverguard.GetCurrentVersion() != serverguard.GetLatestVersion()) then
			panelObject:SetUpdateNotification(true);
		end;

		local hintNumber = math.random(#hints);
		local hintText = hints[hintNumber];

		local hintLabel = panelObject:Add("DLabel");
		hintLabel:SetMouseInputEnabled(true);
		hintLabel:SetText(hintText);
		hintLabel:SetFont("tiger.base.footer");
		hintLabel:SizeToContents();
		hintLabel:SetColor(serverguard.themes.GetCurrent().tiger_base_footer_hint);
		hintLabel:SetPos((panelObject:GetWide() - hintLabel:GetWide()) - 5, (panelObject:GetTall() - hintLabel:GetTall()) - 7);

		function hintLabel:DoClick()
			timer.Remove("serverguard.MenuHint");
			self:AlphaTo(0, 0.5);
		end;

		serverguard.themes.AddPanel(hintLabel, "tiger_base_footer_hint");

		timer.Create("serverguard.MenuHint", 10, 0, function()
			hintNumber = hintNumber + 1;

			if (hintNumber > #hints) then
				hintNumber = 1;
			end;

			hintLabel:AlphaTo(0, 0.5, 0, function()
				hintLabel:SetText(hints[hintNumber]);
				hintLabel:SizeToContents();
				hintLabel:SetColor(serverguard.themes.GetCurrent().tiger_base_footer_hint);
				hintLabel:SetPos((panelObject:GetWide() - hintLabel:GetWide()) - 5, (panelObject:GetTall() - hintLabel:GetTall()) - 7);
				hintLabel:AlphaTo(255, 0.5, 0, function() end);
			end);
		end);

		panelObject:SetSectionSelected("News");
	end;

	panelObject:SetVisible(true);
end;

concommand.Add("+serverguard_menu", CreateMenu)

concommand.Add("serverguard_menu_toggle", function(player)

	if (IsValid(panelObject) and panelObject:IsVisible()) then
		serverguard.menu.Close()
	else
		CreateMenu()
	end

end)

--
-- Close the menu.
--

concommand.Add("-serverguard_menu", function(player)
	if (IsValid(panelObject)) then
		serverguard.menu.Close();
	end
end);

--
-- Open the quick menu.
--

concommand.Add("+serverguard_quickmenu", function(pPlayer)
	if (serverguard.player:HasPermission(pPlayer, "Quick Menu")) then
		gui.EnableScreenClicker(true);
		gui.SetMousePos(99, 99);

		local commandsTable = serverguard.command:GetTable();
		local rankData = serverguard.ranks:GetRank(
			serverguard.player:GetRank(pPlayer)
		);

		local bNoAccess = true;

		local menu = DermaMenu();
			menu:SetSkin("serverguard");

			for k, v in ipairs(player.GetSortedPlayers()) do
				menu:AddOption(serverguard.player:GetName(v), function()
					timer.Simple(0, function()
						gui.EnableScreenClicker(true);
						gui.SetMousePos(99, 99);
						local playerMenu = DermaMenu();
						playerMenu:SetSkin("serverguard");

						playerMenu:AddOption("Copy Steam ID", function()
							if (IsValid(menuOption) and IsValid(v)) then
								SetClipboardText(v:SteamID());
							end
						end):SetIcon("icon16/page_copy.png");

						playerMenu:SetSkin("serverguard");

						for k2, v2 in util.SortedPairsByMemberValue(commandsTable, "help") do
							if (v2.ContextMenu and (!v2.permissions or serverguard.player:HasPermission(pPlayer, v2.permissions))) then
								v2:ContextMenu(v, playerMenu, rankData); bNoAccess = false;
							end;
						end;

						playerMenu:Open(100,100);
						playerMenu.OnRemove = function(panel)
							gui.EnableScreenClicker(false);
						end;

						panelQuickMenu = playerMenu;
					end)
				end):SetImage(serverguard.ranks:GetRank(serverguard.player:GetRank(v)).texture);
			end;
		menu:Open(100, 100);

		menu.OnRemove = function(panel)
			gui.EnableScreenClicker(false);
		end;

		-- if (bNoAccess) then
		-- 	menu:Remove();
		-- end;

		panelQuickMenu = menu;
	end;
end);

--
-- Close the quick menu.
--

concommand.Add("-serverguard_quickmenu", function()
	if (IsValid(panelQuickMenu)) then
		panelQuickMenu:Remove();
	end;
end);

--
--
--

timer.Simple(2, function()
	local oldGetFocus = DTextEntry.OnGetFocus;
	local oldLoseFocus = DTextEntry.OnLoseFocus;

	function DTextEntry:OnGetFocus()
		oldGetFocus(self);

		serverguard.SetMenuStay(true);
	end;

	function DTextEntry:OnLoseFocus()
		oldLoseFocus(self);

		serverguard.SetMenuStay(false);
	end;
end);
