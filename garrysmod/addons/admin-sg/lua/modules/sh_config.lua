--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

--- ## Shared
-- Simplifies the saving/loading/networking of configuration options. Files will be saved in `data/serverguard/config/<name>.txt`.

-- @module serverguard.config

serverguard.AddFolder("config");

serverguard.config = serverguard.config or {};

local stored = {}

--- Configuration class object that's used to save, load, and network settings to clients.
-- @type CONFIG_CLASS
local CONFIG_CLASS = {};
CONFIG_CLASS.__index = CONFIG_CLASS;
CONFIG_CLASS.__tostring = function(self)
	local result = "Config class \"" .. self.name .. "\":\n";

	for k, v in pairs(self.entries) do
		result = result .. "\t" .. k .. "\t(" .. v.type .. ")\t-> " .. tostring(v.value) .. "\n";
	end;

	return result;
end;

local CONFIG_TYPES = {
	--- Adds a configuration option whose key is a boolean.
	-- @string key The key it's referenced by.
	-- @string value The default value that'll be set if none exists.
	-- @string description[opt] The description of the option.
	-- @usage config:AddBoolean("testbool", true, "Just a test boolean.");
	Boolean = function(value)
		return tobool(value);
	end,

	--- Adds a configuration option whose key is a number.
	-- @string key The key it's referenced by.
	-- @string value The default value that'll be set if none exists.
	-- @string description[opt] The description of the option.
	-- @usage config:AddNumber("testnumber", 1234, "Numbers are great!");
	Number = function(value)
		return util.ToNumber(value);
	end;

	--- Adds a configuration option whose key is a string.
	-- @string key The key it's referenced by.
	-- @string value The default value that'll be set if none exists.
	-- @string description[opt] The description of the option.
	-- @usage config:AddString("teststring", "hello hello hello!", "Strings are pretty cool too.");
	String = function(value)
		return tostring(value);
	end;
};

--- **This is called internally, use the create method.**
-- Creates a new configuration object with the specified name.
-- This name is used as both a reference and the name of the file it's saved to. As such, ensure that the name is something the OS will like.
-- @see serverguard.config.Create
-- @string name The name of the config object.
-- @return New config object.
function CONFIG_CLASS:New(name)
	local object = setmetatable({}, CONFIG_CLASS);
		object.name = name;
		object.entries = {};
		object.autoSave = true;
		object.saveQueued = false;
		object.loaded = false;
		object.permissions = {};
	return object;
end;

for k, v in pairs(CONFIG_TYPES) do
	CONFIG_CLASS["Add" .. k] = function(self, key, default, description)
		self.entries[key] = {
			type = k,
			value = v(default),
			description = tostring(description or ""),
			boundPanels = {},
			callbacks = {}
		};
	end;
end;

--- Sets a configuration value and networks it to clients.
-- @string key The key of the config option.
-- @string value The value to set it to.
-- @bool bDontNetwork[opt] Whether or not to network it to clients.
function CONFIG_CLASS:SetValue(key, value, bDontNetwork)
	if (!self.entries[key]) then
		ErrorNoHalt("[config] Tried to set non-existent key \"" .. key .. "\"!");
		return;
	end;

	local newValue = CONFIG_TYPES[self.entries[key].type](value);
	self.entries[key].value = newValue;
	self.loaded = true;

	for k, v in pairs(self.entries[key].callbacks) do
		v(newValue);
	end;

	if (SERVER) then
		if (self.autoSave) then
			self.saveQueued = true;
		end;
	else
		for k, v in pairs(self.entries[key].boundPanels) do
			v:OnBoundConfigChanged(newValue);
		end;
	end;

	if (bDontNetwork) then
		return;
	end;

	if (SERVER) then
		serverguard.netstream.Start(nil, "sgConfigUpdate", {
			name = self.name,
			key = key,
			type = self.entries[key].type,
			value = newValue
		});
	else
		serverguard.netstream.Start("sgConfigUpdate", {
			name = self.name,
			key = key,
			type = self.entries[key].type,
			value = newValue
		});
	end;
end;

--- Sets a required permission to set values from the client.
-- @string permission The required permission. Can be a table of permissions.
function CONFIG_CLASS:SetPermission(permission)
	if (type(permission) != "table") then
		self.permissions = {tostring(permission)};
	else
		self.permissions = permission;
	end;
end;

--- Checks whether or not a player has permission to set the value.
-- @player player The player to check permissions for.
-- @return bool Whether or not they have permission.
function CONFIG_CLASS:CheckPermission(player)
	if (#self.permissions < 1) then
		return true;
	end;

	return serverguard.player:HasPermission(player, self.permissions);
end;

--- Sets whether or not the configuration object auto-saves.
-- When set, it will be automatically saved when you set a value.
-- @bool value Whether or not to auto-save.
function CONFIG_CLASS:SetAutoSave(value)
	self.autoSave = tobool(value);
end;

--- Adds a callback function to run when the specified key has been changed.
-- @string key The key to monitor for changes.
-- @func callback The function to call when the value changes.
function CONFIG_CLASS:AddCallback(key, callback)
	if (!self.entries[key]) then
		return;
	end;

	table.insert(self.entries[key].callbacks, callback);
end;

--- Gets the description of the configuration option.
-- @string key The key of the configuration option.
-- @treturn string The description.
function CONFIG_CLASS:GetDescription(key)
	if (!self.entries[key] or !self.entries[key].description) then
		return;
	end;

	return self.entries[key].description;
end;

--- Gets the serialized representation of the configuration object.
-- @treturn string The serialized object.
function CONFIG_CLASS:GetSerialized()
	local data = {};

	for k, v in pairs(self.entries) do
		data[k] = {
			type = v.type,
			value = v.value	
		};
	end;

	return serverguard.von.serialize(data);
end;

--- Gets the value assigned to the given key. Returns nil if the key doesn't exist.
-- @string key The key to get the value from.
-- @return The value of the key.
function CONFIG_CLASS:GetValue(key)
	if (!self.entries[key]) then
		return nil;
	end;

	return self.entries[key].value;
end;

--- Gets a key -> value table of all the configuration options.
-- @treturn table Table of options.
function CONFIG_CLASS:GetKeyValues()
	local data = {};

	for k, v in pairs(self.entries) do
		data[k] = v.value;
	end;

	return data;
end;

--- Returns the raw entry table for the configuration object.
-- @treturn table Configuration table.
function CONFIG_CLASS:GetTable()
	return self.entries;
end;

--- Loads the saved configuration options from disk.
-- Requests a full update from the server if ran on the client.
-- @treturn CONFIG_CLASS The configuration object.
function CONFIG_CLASS:Load()
	if (SERVER) then
		if (file.Exists("serverguard/config/" .. self.name .. ".txt", "DATA")) then
			local data = serverguard.von.deserialize(file.Read("serverguard/config/" .. self.name .. ".txt", "DATA"));
			
			for k, v in pairs(data) do
				if (!self.entries[k]) then
					continue;
				end;

				self:SetValue(k, v.value, true);
			end;

			self.loaded = true;
		else
			self:Save(true);
		end;
	end;

	if (CLIENT) then
		timer.Simple(1, function()
			self:RequestFullUpdate();
		end);
	end;

	return self;
end;

if (SERVER) then
	local lastSaveTime = CurTime();
	local fullRequestQueue = {};

	local function SaveConfigClass(object)
		file.Write("serverguard/config/" .. object.name .. ".txt", object:GetSerialized());
		object.saveQueued = false;
	end;

	--- **(SERVERSIDE)** Queues the configuration object to be saved to disk.
	-- @bool bForce[opt] Whether or not to bypass the queue and save immediately to disk. Not recommended.
	function CONFIG_CLASS:Save(bForce)
		if (bForce) then
			SaveConfigClass(self);
			return;
		end;

		self.saveQueued = true;
	end;

	-- **(SERVERSIDE)** Sends a full update of all configuration options to the specified player(s).
	-- @player player The player to send the update to. Can also be a table of players.
	function CONFIG_CLASS:SendFullUpdate(player)
		local data = {
			name = self.name,
			entries = {}
		};

		for k, v in pairs(self.entries) do
			data.entries[k] = v.value;
		end;

		serverguard.netstream.Start(player, "sgReceiveFullUpdate", data);
	end;

	hook.Add("Think", "serverguard.config.Think", function()
		local bSaved = false;

		for k, v in pairs(stored) do
			if (v.loaded and fullRequestQueue[k] and #fullRequestQueue > 0) then
				v:SendFullUpdate(fullRequestQueue[k]);

				fullRequestQueue[k] = nil;
			end;

			if (v.loaded and CurTime() >= lastSaveTime + 25) then
				if (!v.entries or !v.saveQueued) then
					continue;
				end;

				SaveConfigClass(v);
				bSaved = true;
			end;
		end;

		if (bSaved) then
			lastSaveTime = CurTime();
		end;
	end);

	serverguard.netstream.Hook("sgConfigUpdate", function(player, data)
		if (!stored[data.name] or !stored[data.name]:CheckPermission(player)) then
			return;
		end;

		stored[data.name]:SetValue(data.key, data.value, true);
		stored[data.name]:Save();
	end);

	serverguard.netstream.Hook("sgRequestFullUpdate", function(player, data)
		if (!stored[data.name]) then
			return;
		end;

		if (!stored[data.name].loaded) then
			if (!fullRequestQueue[data.name]) then
				fullRequestQueue[data.name] = {};
			end;

			table.insert(fullRequestQueue[data.name], player);
			return;
		end;

		stored[data.name]:SendFullUpdate(player);
	end);
else
	local panelSetup = false;

	--- **(CLIENTSIDE)** Requests a full update of all configuration values from the server.
	-- @see CONFIG_CLASS:Load
	function CONFIG_CLASS:RequestFullUpdate()
		serverguard.netstream.Start("sgRequestFullUpdate", {
			name = self.name
		});
	end;

	serverguard.netstream.Hook("sgConfigUpdate", function(data)
		if (!stored[data.name]) then
			return;
		end;

		stored[data.name]:SetValue(data.key, data.value, true);
	end);

	serverguard.netstream.Hook("sgReceiveFullUpdate", function(data)
		if (!stored[data.name]) then
			return;
		end;

		for k, v in pairs(data.entries) do
			stored[data.name]:SetValue(k, v, true);
			stored[data.name].loaded = true; -- client doesn't really care
		end;
	end);

	hook.Add("PostGamemodeLoaded", "serverguard.config.PostGamemodeLoaded", function()
		if (panelSetup) then
			return;
		end;

		local DCheckBox = vgui.GetControlTable("DCheckBox");
		local DNumSlider = vgui.GetControlTable("DNumSlider");

		local tiger_checkbox = vgui.GetControlTable("tiger.checkbox");
		local tiger_numslider = vgui.GetControlTable("tiger.numslider");

		local checkboxFunction = function(self, config, key)
			if (!stored[config] or
				!stored[config].entries[key] or
				!stored[config].entries[key].type == "Boolean") then
				return;
			end;

			local configEntry = stored[config].entries[key];

			self:SetChecked(configEntry.value);
			self.sgOldOnChange = self.OnChange;

			self.OnChange = function(_self, value)
				stored[config]:SetValue(key, value);

				self.sgOldOnChange(self, value);
			end;

			self.OnBoundConfigChanged = function(_self, value)
				self:SetChecked(value);
			end;

			table.insert(configEntry.boundPanels, self);
		end;

		local sliderFunction = function(self, config, key)
			if (!stored[config] or
				!stored[config].entries[key] or
				!stored[config].entries[key].type == "Number") then
				return;
			end;

			local configEntry = stored[config].entries[key];

			self:SetValue(configEntry.value);
			self.sgOldValueChanged = self.ValueChanged;

			self.ValueChanged = function(_self, value)
				stored[config]:SetValue(key, (bRound and math.Round(value)) or value);

				self.sgOldValueChanged(self, value);
			end;

			self.OnBoundConfigChanged = function(_self, value)
				self:SetValue(value);
			end;

			table.insert(configEntry.boundPanels, self);
		end;

		if (DCheckBox) then
			--- Binds a panel to a configuration option.
			-- It will update the panel when the configuration option is updated, and vice versa.
			-- This overrides OnChange/ValueChanged/etc for panels, so make sure you call this last! It will retain previous callbacks when overriding.
			-- Applicable panels include: DCheckBox, DNumSlider, tiger.checkbox, tiger.numslider.
			-- @string config The name of the configuration object.
			-- @string key The configuration option to bind the panel to.
			-- @bool bRound[opt] **DNumSlider only:** Whether or not to round the value before updating.
			DCheckBox.BindToConfig = checkboxFunction;
		end;

		if (tiger_checkbox) then
			tiger_checkbox.BindToConfig = checkboxFunction;
		end;

		if (DNumSlider) then
			DNumSlider.BindToConfig = sliderFunction;
		end;

		if (tiger_numslider) then
			tiger_numslider.BindToConfig = sliderFunction;
		end;

		panelSetup = true;
	end);
end;

--- Creates a new configuration object with the specified name.
-- @string unique The name of the config object.
-- @return New config object.
function serverguard.config.Create(unique)
	local object = CONFIG_CLASS:New(unique);
		stored[unique] = object;
	return object;
end;

local oldStored = {}

--- **(DEPRECATED)** Add a new configuration entry. The callback function is passed a table argument of the saved data.
-- @string unique The unique ID of the entry.
-- @func callback Function to execute when the data is loaded.
function serverguard.config.New(unique, callback)
	oldStored[unique] = callback
end

--- **(DEPRECATED)** Saves the configuration entry.
-- @string unique The unique ID of the entry.
-- @table data The data to save.
function serverguard.config.Save(unique, data)
	file.Write("serverguard/config/" .. unique .. ".txt", serverguard.von.serialize(data))
end

if (SERVER) then
	hook.Add("serverguard.Initialize", "serverguard.config.Initialize", function()
		for unique, callback in pairs(oldStored) do
			local data = file.Read("serverguard/config/" .. unique .. ".txt")
			
			if (data) then
				callback(serverguard.von.deserialize(data))
			end
		end

		hook.Call("serverguard.PostLoadConfig", nil);
	end)
else
	hook.Add("serverguard.LoadPlayerData", "serverguard.config.LoadPlayerData", function()
		for unique, callback in pairs(oldStored) do
			local data = file.Read("serverguard/config/" .. unique .. ".txt")
			
			if (data) then
				callback(serverguard.von.deserialize(data))
			end
		end
	end)
end