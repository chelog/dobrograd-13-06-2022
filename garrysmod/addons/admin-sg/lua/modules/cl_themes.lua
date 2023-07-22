--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

--- ## Client
-- Theming system that handles the creation, saving, loading, and applying of themes to panels.
-- @module serverguard.themes

serverguard.theme = serverguard.theme or CreateClientConVar("serverguard_theme", "Default", true, false);
serverguard.themes = serverguard.themes or {};

local stored = {};
local panels = {};
local controls = {};
local defaults = {"Default"};

stored["Default"] = {};

cvars.AddChangeCallback("serverguard_theme", function()	
	serverguard.themes.ApplyChanges()
	
	local current = serverguard.themes.GetCurrent()
	
	hook.Call("serverguard.themes.ThemeChanged", nil, current)
end)

--- Creates a new theme.
-- @string name The name of the theme.
-- @string[opt] theme The name of the theme to base off of.
-- @treturn table Theme data.
function serverguard.themes.New(name, theme)
	local baseTheme;
	local themetype = type(theme)

	if (themetype == "string") then
		baseTheme = serverguard.themes.Get(theme);
	elseif (themetype == "table") then
		baseTheme = theme;
	end;

	local baseCopy = table.Copy(baseTheme and istable(baseTheme) and baseTheme or stored["Default"]);

	for name, color in pairs(stored["Default"]) do
		for unique, data in pairs(baseCopy) do
			if (!serverguard.themes.IsDefaultTheme(unique)) then
				if (!data[name]) then
					baseCopy[unique][name] = color
				end
			end
		end
	end
	
	stored[name] = baseCopy;
end;

--- Sets a colour entry in the current theme.
-- @string name The name of the colour.
-- @color color The colour value.
function serverguard.themes.Set(name, color)
	local current = serverguard.themes.GetCurrent()
	
	current[name] = color
	
	serverguard.themes.ApplyChanges()
end

--- Retrieves a table of all available themes.
-- @treturn table Table of all themes' data.
function serverguard.themes.GetStored()
	return stored
end

--- Returns a theme's data.
-- @string unique The name of the theme.
-- @treturn table Theme data.
function serverguard.themes.Get(unique)
	return stored[unique]
end

--- Gets the name of hooked panel colours.
-- @panel panel The panel to get the names from.
-- @treturn table List of names.
function serverguard.themes.GetColorNames(panel)
	return controls[panel]
end

--- Returns the current theme.
-- @treturn table Theme data.
function serverguard.themes.GetCurrent()
	local theme = serverguard.theme:GetString()
	
	if (!stored[theme]) then
		RunConsoleCommand("serverguard_theme", "Default")
		
		return stored["Default"], theme
	else
		return stored[theme], theme
	end
end

--- Creates a colour entry for the default theme.
-- @string name The name of the colour entry.
-- @color default The default colour to be set.
-- @panel panel The name of the panel it applies to.
function serverguard.themes.CreateDefault(name, default, panel)
	stored["Default"][name] = default
	
	controls[panel] = controls[panel] or {}
	
	table.insert(controls[panel], name)
end

-- Creates a default theme.
function serverguard.themes.CreateDefaultTheme(name, data)
	table.insert(defaults, name);
	stored[name] = data;
end;

--- Checks whether or not a theme is a default theme.
-- @string name The name of the theme.
-- @treturn bool Whether or not the theme is a default theme.
function serverguard.themes.IsDefaultTheme(name)
	return table.HasValue(defaults, name);
end;

--- Hooks a panel to be changed when the theme is modified. This is currently only used for labels.
-- @panel panel The panel to hook.
-- @string name The name of the theme's colour entry to apply.
function serverguard.themes.AddPanel(panel, name)
	local current = serverguard.themes.GetCurrent()

	panel[name] = current[name]
	
	table.insert(panels, panel)
	
	if (IsValid(panel)) then
		for name, color in pairs(current) do
			if (panel[name]) then
				if (panel:GetClassName() == "Label") then
					panel:SetColor(color)
				end
				
				panel[name] = color
			end
		end
	end
end

--- Applies theme colours to hooked panels.
function serverguard.themes.ApplyChanges()
	local current = serverguard.themes.GetCurrent()
	
	for i = 1, #panels do
		local panel = panels[i]

		if (IsValid(panel)) then
			for name, color in pairs(current) do
				if (panel[name]) then
					if (panel.OnTigerThemeChanged and type(panel.OnTigerThemeChanged) == "function") then
						panel:OnTigerThemeChanged();
					end

					if (panel:GetClassName() == "Label") then
						panel:SetColor(color)
					end
					
					panel[name] = color
				end
			end
		end
	end
end

--- Saves all themes stored in memory.
function serverguard.themes.Save()
	local data = ""
	
	for k, v in pairs(stored) do
		if (serverguard.themes.IsDefaultTheme(k)) then
			continue;
		end;

		data = data .. "[" .. k .. "]\r\n"

		for t, color in pairs(v) do
			data = data .. t .. "=" .. color.r .. "," .. color.g .. "," .. color.b .. "," .. color.a .. "\r\n"
		end
		
		data = data .. "\r\n"
	end
	
	file.Write("serverguard/themes.txt", data, "DATA")
end

--- Removes a theme from memory and disk.
-- @string name The name of the theme to remove.
function serverguard.themes.Remove(name)
	if (!stored[name]) then
		return;
	end

	stored[name] = nil
	serverguard.themes.Save()
end

--- Loads the themes into memory.
function serverguard.themes.Load()
	local data = file.Read("serverguard/themes.txt", "DATA")
	
	if (data) then
		local unique
		
		data = string.Explode("\n", data)
		
		for k, str in pairs(data) do
			if (str != "") then
				local new = string.match(str, "%[%S.+]")
				
				if (new) then
					unique = string.gsub(new, "%[", "")
					unique = string.gsub(unique, "%]", "")
					
					stored[unique] = {}
				end
				
				local col = string.match(str, "%S+=%S+")
				
				if (col) then
					local s, e = string.find(col, "%S-=")
					local color = string.Explode(",", string.sub(col, e +1))
					
					stored[unique][string.sub(col, s, e -1)] = Color(color[1], color[2], color[3], color[4])
				end
			end
		end
		
		-- Load any additions.
		for name, color in pairs(stored["Default"]) do
			for unique, data in pairs(stored) do
				if (!serverguard.themes.IsDefaultTheme(unique)) then
					if (!data[name]) then
						stored[unique][name] = color
					end
				end
			end
		end

		serverguard.themes.Save()
		
		timer.Simple(2, function() local current = serverguard.themes.GetCurrent() hook.Call("serverguard.themes.ThemeChanged", nil, current) end)
	else
		RunConsoleCommand("serverguard_theme", "Default")
		
		timer.Simple(2, function() serverguard.themes.Save() end)
	end
end

-- Default themes.
serverguard.themes.CreateDefaultTheme("Dark", {
	["tiger_divider_right_label_hovered"] = Color(240, 240, 240),
	["tiger_divider_right_label"] = Color(20, 120, 170),
	["tiger_button_bg"] = Color(80, 80, 80),
	["tiger_button_stripe"] = Color(80, 80, 80),
	["tiger_base_section_outline"] = Color(80, 80, 80),
	["tiger_panel_outline"] = Color(80, 80, 80),
	["tiger_news_bg"] = Color(60, 60, 60),
	["tiger_list_bg"] = Color(40, 40, 40),
	["tiger_list_panel_list_bg_dark"] = Color(40, 40, 40),
	["tiger_list_panel_label"] = Color(140, 140, 140),
	["tiger_divider_panel_hover"] = Color(20, 120, 170),
	["tiger_panel_label"] = Color(140, 140, 140),
	["tiger_divider_left_label"] = Color(140, 140, 140),
	["tiger_panel_bg"] = Color(60, 60, 60),
	["tiger_tooltip_label"] = Color(140, 140, 140),
	["tiger_base_outline"] = Color(80, 80, 80),
	["tiger_list_column_label"] = Color(140, 140, 140),
	["tiger_list_scrollbar"] = Color(120, 120, 120, 200),
	["tiger_base_section_icon"] = Color(133, 134, 125),
	["tiger_base_section_label"] = Color(140, 140, 140),
	["tiger_divider_bg"] = Color(60, 60, 60),
	["tiger_button_hovered_stripe"] = Color(120, 120, 120),
	["tiger_list_panel_label_hover"] = Color(240, 240, 240),
	["tiger_news_content"] = Color(140, 140, 140),
	["tiger_list_panel_list_bg"] = Color(45, 45, 45),
	["tiger_button_text"] = Color(200, 200, 200),
	["tiger_tooltip_outline"] = Color(80, 80, 80),
	["tiger_list_outline"] = Color(80, 80, 80),
	["tiger_button_text_hovered"] = Color(30, 30, 30),
	["tiger_list_column_outline"] = Color(80, 80, 80),
	["tiger_button_hovered"] = Color(120, 120, 120),
	["tiger_divider_left_bg"] = Color(50, 50, 50),
	["tiger_base_bg"] = Color(50, 50, 50),
	["tiger_list_panel_list_outline"] = Color(80, 80, 80),
	["tiger_divider_left_label_hovered"] = Color(240, 240, 240),
	["tiger_divider_outline"] = Color(80, 80, 80),
	["tiger_base_footer_label"] = Color(20, 120, 170),
	["tiger_base_section_selected"] = Color(50, 50, 50),
	["tiger_base_section_icon_selected"] = Color(20, 120, 170),
	["tiger_button_outline"] = Color(100, 100, 100),
	["tiger_news_title"] = Color(20, 120, 170),
	["tiger_tooltip_bg"] = Color(60, 60, 60),
	["tiger_list_panel_list_hover"] = Color(20, 120, 170),
	["tiger_base_section_label_selected"] = Color(20, 120, 170),
	["tiger_base_footer_bg"] = Color(40, 40, 40),
	["tiger_divider_panel_outline"] = Color(80, 80, 80)
});

serverguard.themes.Load();