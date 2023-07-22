	--[[
	� 2017 Thriving Ventures Limited do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local newRankRestrictions = {};
local restrictionTypes = {
	{name = "Props", 	type = "Number"},
	{name = "Vehicles", type = "Number"},
	{name = "Sents", 	type = "Number"},
	{name = "Effects", 	type = "Number"},
	{name = "NPCs", 	type = "Number"},
	{name = "Ragdolls", type = "Number"},
	{name = "Balloons", type = "Number"},
	{name = "Buttons", 	type = "Number"},
	{name = "Dynamite", type = "Number"},
	{name = "Effects", 	type = "Number"},
	{name = "Emitters", type = "Number"},
	{name = "Hoverballs", type = "Number"},
	{name = "Lamps", 	type = "Number"},
	{name = "Lights", 	type = "Number"},
	{name = "Thrusters", type = "Number"},
	{name = "Wheels", 	type = "Number"},

	{name = "Wire_Lights", 	type = "Number"},
	{name = "Wire_Lamps", 	type = "Number"},
	{name = "Keypad_Wires", 	type = "Number"},
	{name = "Octo_Triggers", 	type = "Number"},
	{name = "Textscreens", 	type = "Number"},
	{name = "Imgscreens", 	type = "Number"},

	{name = "Tools", 	type = "Tools"}
};

local function Spacer(parent)
	local base = vgui.Create("Panel");
	base:SetTall(15);
	base:Dock(TOP);
	base:DockMargin(2, 0, 2, 14);

	parent:AddPanel(base);

	return base;
end;

local function PopulateRestrictionList(restrictionsPanel, toolsPanel, rankTable, restrictionData)
	local userRestrictions = serverguard.ranks:GetData("user", "Restrictions", {});

	for i, data in ipairs(restrictionTypes) do
		rankTable[i] = {name = data.name, value = "", type = data.type};

		if (restrictionData[data.name]) then
			rankTable[i].value = restrictionData[data.name];
		end;

		if (GAMEMODE.IsSandboxDerived and toolsPanel and data.type == "Tools") then
			local toolsTable = {};

			for key, weapon in pairs(weapons.GetList()) do
				if (weapon.ClassName == "gmod_tool") then
					for key2, tool in pairs(weapon.Tool) do
						local cat = tool.Category or "Other";
						local name = tool.Name;

						if (!name) then
							name = tool.Mode;
						else
							if (string.find(name, "#")) then
								name = language.GetPhrase(string.gsub(name, "#", ""));
							end;
						end;

						table.insert(toolsTable, {
							Category = cat,
							Name = cat.." - "..name,
							Command = tool.Mode,
							Value = true
						});
					end;
				end;
			end;

			table.sort(toolsTable, function(a, b)
				if a.Category == "Other" then return false; end;
				if b.Category == "Other" then return true; end;
				return a.Name < b.Name;
			end);

			rankTable[i].value = toolsTable;

			local lastCat = nil;
			for k, v in pairs(toolsTable) do
				if (lastCat and v.Category != lastCat) then
					Spacer(toolsPanel);
				end;

				local checkbox = vgui.Create("tiger.checkbox");
				toolsPanel:AddPanel(checkbox);

				checkbox:Dock(TOP);
				checkbox:SetText(v.Name);

				if (restrictionData[data.name] and restrictionData[data.name][v.Command] ~= nil) then
					checkbox:SetChecked(restrictionData[data.name][v.Command]);
					rankTable[i].value[k].Value = restrictionData[data.name][v.Command];
				else
					checkbox:SetChecked(true);
				end;

				function checkbox:OnChange(bValue)
					rankTable[i].value[k].Value = tobool(bValue);
				end;

				lastCat = v.Category;
			end;
		elseif (data.type == "Number") then
			local slider = vgui.Create("tiger.numslider");
			restrictionsPanel:AddPanel(slider);

			slider:Dock(TOP);
			slider:SetText(data.name);
			slider:SetMinMax(-1, 2048);

			if (restrictionData[data.name]) then
				slider:SetValue(restrictionData[data.name]);
			else
				if (userRestrictions[data.name]) then
					slider:SetValue(userRestrictions[data.name]);
					rankTable[i].value = userRestrictions[data.name];
				else
					slider:SetValue(1);
					rankTable[i].value = 1;
				end;
			end;

			function slider:ValueChanged(value)
				rankTable[i].value = math.Round(value);
			end;
		end;
	end;
end;

plugin:Hook("serverguard.panel.RankEditorCreationMenu", "restrictions.RankEditorCreationMenu", function(list, copyFrom)
	local label = vgui.Create("DLabel");
		label:SetText("Rank restrictions:");
		label:SizeToContents();
		label:Dock(TOP);
		label:DockMargin(0, 8, 0, 0);
		label:SetSkin("serverguard");
	list:AddPanel(label);

	local restrictionList = vgui.Create("tiger.list");
		restrictionList:Dock(TOP);
		restrictionList:DockMargin(0, 14, 0, 14);
		restrictionList:SetTall(16 * 13);
	list:AddPanel(restrictionList);

	local toolsList;

	if (GAMEMODE.IsSandboxDerived) then
		local label = vgui.Create("DLabel");
			label:SetText("Rank tool restrictions:");
			label:SizeToContents();
			label:Dock(TOP);
			label:DockMargin(0, 8, 0, 0);
			label:SetSkin("serverguard");
		list:AddPanel(label);

		toolsList = vgui.Create("tiger.list");
			toolsList:Dock(TOP);
			toolsList:DockMargin(0, 14, 0, 14);
			toolsList:SetTall(16 * 16);
		list:AddPanel(toolsList);
	end;

	local data = copyFrom and copyFrom.data and copyFrom.data.Restrictions
	PopulateRestrictionList(restrictionList, toolsList, {}, data or {});
end);

plugin:Hook("serverguard.panel.RankEditorCreationPopulate", "restrictions.RankEditorCreationPopulate", function(dataTable)
	local appliedRestrictions = dataTable["Restrictions"] or {};

	for k, v in pairs(newRankRestrictions) do
		appliedRestrictions[v.name] = v.value;
	end;

	local Tools = {}
	for _, tool in ipairs(appliedRestrictions.Tools or {}) do
		Tools[tool.Command] = tool.Value
	end
	appliedRestrictions.Tools = Tools

	dataTable["Restrictions"] = appliedRestrictions;
end);

plugin:Hook("serverguard.panel.RankEditorContext", "restrictions.RankEditorContext", function(menu, uniqueID, rankData, categoryPanel, categoryBase)
	local option = menu:AddOption("Change restrictions", function()
		if (uniqueID == "founder") then
			serverguard.Notify(nil, SERVERGUARD.NOTIFY.RED, "You cannot change the restrictions of the founder rank - it's already allowed for unlimited spawning!");
			return;
		end;

		local base = vgui.Create("tiger.panel");
		base:SetTitle("Change rank restrictions");
		base:SetSize(580, 620);
		base:Center();
		base:MakePopup();
		base:DockPadding(24, 24, 24, 48);

		local label = base:Add("DLabel");
		label:SetText("Restrictions:");
		label:SizeToContents();
		label:Dock(TOP);
		label:SetSkin("serverguard");

		local restrictionList = base:Add("tiger.list");
		restrictionList:SetTall(16 * 13);
		restrictionList:Dock(TOP);

		local label = base:Add("DLabel");
		label:SetText("Tool restrictions:");
		label:SizeToContents();
		label:Dock(TOP);
		label:DockMargin(0, 8, 0, 0);
		label:SetSkin("serverguard");

		local toolsList = base:Add("tiger.list");
		toolsList:Dock(TOP);
		toolsList:SetTall(16 * 16);

		local appliedRestrictions = {}
		local restrictionData = serverguard.ranks:GetData(uniqueID, "Restrictions", {});

		PopulateRestrictionList(restrictionList, toolsList, appliedRestrictions, restrictionData);

		local complete = base:Add("tiger.button");
		complete:SetPos(4, 4);
		complete:SetText("Complete");
		complete:SizeToContents();

		function complete:DoClick()
			local restrictionData = {};

			for k, v in pairs(appliedRestrictions) do
				restrictionData[v.name] = v.value;
			end;

			local Tools = {}
			for _, tool in ipairs(restrictionData.Tools) do
				Tools[tool.Command] = tool.Value
			end
			restrictionData.Tools = Tools

			serverguard.netstream.Start("sgChangeRankData", {
				uniqueID, "Restrictions", restrictionData
			});

			timer.Simple(FrameTime() * 8, function()
				categoryPanel:Update(categoryBase);
			end);

			base:Remove();
		end;

		local cancel = base:Add("tiger.button");
		cancel:SetPos(4, 4);
		cancel:SetText("Cancel");
		cancel:SizeToContents();

		function cancel:DoClick()
			base:Remove();
		end;

		function base:PerformLayout()
			local w, h = self:GetSize();

			complete:SetPos(w - (complete:GetWide() + 24), h - (complete:GetTall() + 14));
			cancel:SetPos(0, h - (cancel:GetTall() + 14));
			cancel:MoveLeftOf(complete, 14);
		end;
	end);

	option:SetImage("icon16/script_gear.png");
end);
