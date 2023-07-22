--[[
	� 2017 Thriving Ventures Limited do not share, re-distribute or modify

	without permission of its author (gustaf@thrivingventures.com).
]]

--- ## Shared
--- Library for managing plugins.
-- @module serverguard.plugin

serverguard.plugin = serverguard.plugin or {};

local stored = {};
local object = {};

object.__index = object;

--- Creates a new plugin table.
-- @treturn table Plugin table.
function serverguard.plugin.New()
	local plugin = {};

	plugin.hooks = {};
	plugin.commands = {};
	plugin.categories = {};
	plugin.toggled = true;

	setmetatable(plugin, object);

	return plugin;
end;

--- Registers a plugin.
-- @table plugin Plugin table to register.
function serverguard.plugin.Register(plugin)
	stored[plugin.unique] = plugin;

	if (plugin.permissions) then
		serverguard.permission:Add(plugin.permissions);
	end;
end;

--- Returns a plugin table with the specified name.
-- @string unique Unique ID of the plugin.
-- @treturn table Plugin table.
function serverguard.plugin.FindByID(unique)
	return stored[unique];
end;

serverguard.plugin.Get = serverguard.plugin.FindByID;

--- Returns all registered plugins.
-- @treturn table Table of plugin tables.
function serverguard.plugin.GetList()
	return stored;
end;

--- Enables or disables a plugin. This toggles any registered hooks, chat commands, or UI categories.
-- @string uniqueID Unique ID of the plugin.
-- @bool bToggled Whether or not to turn the plugin on.
function serverguard.plugin:Toggle(uniqueID, bToggled)
	if (!stored[uniqueID]) then
		return;
	end;

	stored[uniqueID].toggled = bToggled;

	local hooks = stored[uniqueID].hooks;
	local commands = stored[uniqueID].commands;

	for name, data in pairs(hooks) do
		for hookUnique, callback in pairs(data) do
			if (bToggled) then
				hook.Add(name, hookUnique, callback);
			else
				hook.Remove(name, hookUnique);
			end;
		end;
	end;

	for k, v in pairs(commands) do
		if (bToggled) then
			serverguard.command:Add(v);
		else
			serverguard.command:Remove(k);
		end;
	end;

	if (CLIENT) then
		local categories = stored[uniqueID].categories;

		for k, v in pairs(categories) do
			if (bToggled) then
				serverguard.menu.AddCategory(v);
				serverguard.menu:Rebuild();
			else
				serverguard.menu:RemoveCategory(k);
			end;
		end;
	end;

	hook.Call("serverguard.PluginToggled", nil, uniqueID, bToggled);
end;

--
-- Add a hook.
--

function object:Hook(name, unique, callback)
	self.hooks[name] = self.hooks[name] or {};
	self.hooks[name][unique] = callback;

	hook.Add(name, unique, callback);
end;

--
-- Add a command.
--

function object:AddCommand(commandTable)
	self.commands[commandTable.command] = self.commands[commandTable.command] or commandTable;
	serverguard.command:Add(commandTable);
end;

--
-- Parse a file.
--

function object:IncludeFile(fileName, state)
	serverguard.ParseFile(self.path .. fileName, state)
end

if (CLIENT) then
	--
	-- Add a category.
	--

	function object:AddCategory(category)
		self.categories[category.name] = self.categories[category.name] or category;
		serverguard.menu.AddCategory(category);
	end;

	--
	-- Add a subcategory.
	--

	function object:AddSubCategory(parent_name, data)
		serverguard.menu.AddSubCategory(parent_name, data);
	end;
end;

--- Load plugin files. This should **not** be called manually as it's done automatically when ServerGuard starts.
function serverguard.plugin.LoadFiles()
	if (SG_DEBUG or SG_FILE_DEBUG) then
		serverguard.PrintConsole("Loading plugins...\n\n");
	end;

	local _, folders = file.Find("plugins/*", "LUA");

	for k, folder in pairs(folders) do
		plugin = serverguard.plugin.FindByID(folder) or serverguard.plugin.New();
		plugin.unique = folder;
		plugin.path = "plugins/" .. folder.. "/";

		if (SERVER) then
			if (file.Exists("plugins/" .. folder.. "/init.lua", "LUA")) then
				include("plugins/" .. folder.. "/init.lua");
			end;

			if (file.Exists("plugins/" .. folder.. "/cl_init.lua", "LUA")) then
				AddCSLuaFile("plugins/" .. folder.. "/cl_init.lua");
			end;
		elseif (CLIENT) then
			if (file.Exists("plugins/" .. folder.. "/cl_init.lua", "LUA")) then
				include("plugins/" .. folder.. "/cl_init.lua");
			end;
		end;

		if (plugin.name) then
			serverguard.plugin.Register(plugin);

			if (SG_DEBUG or SG_FILE_DEBUG) then
				serverguard.PrintConsole("Registered plugin '" .. plugin.name .. "'\n\n");
			end;
		else
			if (SG_DEBUG or SG_FILE_DEBUG) then
				serverguard.PrintConsole("Failed to load plugin '" .. folder .. "'!\n\n");
			end;
		end;

		plugin = nil;
	end;

	if (SG_DEBUG or SG_FILE_DEBUG) then
		serverguard.PrintConsole("Loaded plugins.\n");
	end;
end;

serverguard.plugin.LoadFiles();

if (SERVER) then
	function serverguard.plugin:SaveData(bForced, uniqueIfForced)
		local pluginData = {};

		for unique, v in pairs(stored) do
			if (bForced and unique == uniqueIfForced) then
				pluginData[unique] = {toggled = v.toggled, forced = bForced};
			else
				pluginData[unique] = {toggled = v.toggled, forced = v.forced};
			end;
		end;

		serverguard.config.Save("plugins", pluginData);
	end;

	--
	-- Send the status of all plugins.
	--

	hook.Add("serverguard.LoadPlayerData", "plugin.LoadPlayerData", function(player)
		local plugins = serverguard.plugin.GetList()

		for uniqueID, data in pairs(plugins) do
			serverguard.netstream.Start(player, "sgGetPluginStatus", {
				uniqueID, data.toggled
			});
		end
	end)

	--
	-- Load the state of all plugins.
	--

	serverguard.config.New("plugins", function(data)
		for unique, v in pairs(data) do
			if (stored[unique]) then
				local toggle = v.toggled;
				local forced = v.forced;

				stored[unique].toggled = toggle;
				stored[unique].forced = forced;
				serverguard.plugin:Toggle(unique, toggle);
			end;
		end;
	end);

	hook.Add("serverguard.PostLoadConfig", "serverguard.plugin.PostLoadConfig", function()
		for unique, v in pairs(stored) do
			if (stored[unique]) then
				local bToggled = v.toggled;

				if (stored[unique].gamemodes and #stored[unique].gamemodes > 0 and !v.forced) then
					if (!table.HasValue(stored[unique].gamemodes, engine.ActiveGamemode())) then
						bToggled = false;

						if (SG_DEBUG or SG_FILE_DEBUG) then
							serverguard.PrintConsole("Force-disabled plugin '"..unique.."' - gamemode not compatible!\n");
						end;
					end;
				end;

				serverguard.plugin.Get(unique).toggled = bToggled;
				serverguard.plugin:Toggle(unique, bToggled);
			end;
		end;
	end);
elseif (CLIENT) then
	serverguard.netstream.Hook("sgGetPluginStatus", function(data)
		local uniqueID = data[1];
		local state = tobool(data[2]);
		local pluginTable = serverguard.plugin.Get(uniqueID);

		if (pluginTable) then
			pluginTable.toggled = state;

			serverguard.plugin:Toggle(uniqueID, pluginTable.toggled);
		end;
	end);

	--
	-- Create the menu category.
	--

	local category = {}

	category.name = "Plugins";
	category.material = "serverguard/menuicons/icon_toggle.png";
	category.permissions = "Manage Plugins";

	function category:Create(base)
		base.quality = 50

		base.panel = base:Add("tiger.panel")
		base.panel:SetTitle("Enabled or disabled plugins")
		base.panel:Dock(FILL)

		base.panel.list = base.panel:Add("tiger.list")
		base.panel.list:Dock(FILL)
		base.panel.list:AddColumn("PLUGIN", 400)

		function base.panel:PerformLayout()
			category.list = base.panel.list
		end

		hook.Call("serverguard.panel.PluginList", nil, base.panel.list);

		local column = base.panel.list:AddColumn("ENABLED")
		column:SetDisabled(true)

		local plugins = serverguard.plugin.GetList()

		for unique, data in pairs(plugins) do
			local panel = base.panel.list:AddItem(data.name)
			panel:SetToolTipSG("Version: " .. data.version .. "\n\n" .. data.description)

			local toggleButton = vgui.Create("DImageButton")
			toggleButton:SetSize(16, 16)
			toggleButton:SetImage(octolib.icons.silk16('accept_button'))
			toggleButton.unique = unique
			toggleButton.whitelist = true

			if (data.gamemodes and #data.gamemodes > 0) then
				if (!table.HasValue(data.gamemodes, engine.ActiveGamemode())) then
					toggleButton.whitelist = false
				end
			end

			if (!toggleButton.whitelist) then
				toggleButton:SetToolTipSG("This plugin is not compatible with the current running gamemode!");
			end;

			function toggleButton:DoClick()
				if (serverguard.player:HasPermission(LocalPlayer(), "Manage Plugins")) then
					if (!self.whitelist and !serverguard.plugin.Get(self.unique).toggled) then
						local q = util.CreateDialog("Incompatible gamemode",
									"This gamemode is incompatible with this plugin. Load it anyways?",
									function() serverguard.command.Run("plugintoggle", false, self.unique); end,
									"Yes",
									function() end,
									"No");
						return;
					end;

					serverguard.command.Run("plugintoggle", false, self.unique);
				end;
			end;

			function toggleButton:Think()
				local pluginTable = serverguard.plugin.Get(self.unique)

				if (pluginTable.toggled) then
					if (self:GetImage() == octolib.icons.silk16('cancel')) then
						self:SetImage(octolib.icons.silk16('accept_button'))
					end
				else
					if (self:GetImage() == octolib.icons.silk16('accept_button')) then
						self:SetImage(octolib.icons.silk16('cancel'))
					end
				end
			end

			function toggleButton:PerformLayout()
				DImageButton.PerformLayout(self)

				local w, h = self:GetSize()
				local column = panel:GetThing(2).column
				local x = column:GetPos()

				self:SetPos(x +column:GetWide() /2 -w /2, column:GetTall() /2 -h /2)
			end

			panel:AddItem(toggleButton)
		end
	end

	function category:Update(base)
	end

	serverguard.menu.AddSubCategory("Server settings", category)

	hook.Add("serverguard.menu.Close", "serverguard.PluginList", function()
		if (IsValid(category.list)) then
			for k, v in ipairs(category.list:GetCanvas():GetChildren()) do
				if (IsValid(v.tooltip_sg)) then
					v:OnCursorExited();
				end;
			end;
		end;
	end);
end
