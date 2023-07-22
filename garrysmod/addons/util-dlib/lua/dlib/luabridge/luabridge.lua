
--
-- Copyright (C) 2017-2020 DBotThePony

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.


if CLIENT then
	local pixelvis_handle_t = FindMetaTable('pixelvis_handle_t')
	local util = util

	--[[
		@doc
		@fname pixelvis_handle_t:Visible
		@alias pixelvis_handle_t:IsVisible
		@alias pixelvis_handle_t:PixelVisible
		@args Vector pos, number radius

		@client

		@desc
		!g:util.PixelVisible
		@enddesc

		@returns
		number: visibility
	]]
	function pixelvis_handle_t:Visible(pos, rad)
		return util.PixelVisible(pos, rad, self)
	end

	function pixelvis_handle_t:IsVisible(pos, rad)
		return util.PixelVisible(pos, rad, self)
	end

	function pixelvis_handle_t:PixelVisible(pos, rad)
		return util.PixelVisible(pos, rad, self)
	end

	local player = player
	local IsValid = FindMetaTable('Entity').IsValid
	local GetTable = FindMetaTable('Entity').GetTable
	local GetVehicle = FindMetaTable('Player').GetVehicle
	local vehMeta = FindMetaTable('Vehicle')
	local NULL = NULL
	local ipairs = ipairs

	local LocalPlayer = LocalPlayer
	local GetWeapons = FindMetaTable('Player').GetWeapons

	local function updateWeaponFix()
		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		local weapons = GetWeapons(ply)
		if not weapons then return end

		for k, wep in ipairs(weapons) do
			local tab = GetTable(wep)

			if not tab.DrawWeaponSelection_DLib and tab.DrawWeaponSelection then
				tab.DrawWeaponSelection_DLib = tab.DrawWeaponSelection

				tab.DrawWeaponSelection = function(self, x, y, w, h, a)
					local can = hook.Run('DrawWeaponSelection', self, x, y, w, h, a)
					if can == false then return end

					hook.Run('PreDrawWeaponSelection', self, x, y, width, height, alpha)
					local A, B, C, D, E, F = tab.DrawWeaponSelection_DLib(self, x, y, w, h, a)
					hook.Run('PostDrawWeaponSelection', self, x, y, width, height, alpha)
					return A, B, C, D, E, F
				end
			end
		end
	end

	timer.Create('DLib.DrawWeaponSelection', 10, 0, updateWeaponFix)
	updateWeaponFix()

	--[[
		@doc
		@fname vgui.Create
		@replaces
		@args string tableName, Panel parent, vararg any

		@desc
		Patched !g:vgui.Create which
		throws an (no call aborting) error with stack trace when attempting to create non existant panel
		and with hooks `VGUIPanelConstructed`, `VGUIPanelInitialized` and `VGUIPanelCreated` being called inside it
		if other mod already overrides this function, override is aborted and i18n will be rendered useless for panels
		@enddesc

		@returns
		Panel: the created panel or nil if panel doesn't exist (with an error sent to error handler)
	]]

	--[[
		@doc
		@hook VGUIPanelConstructed
		@args Panel self, Panel parent, vararg any

		@desc
		Called **before** `Panel:Init()` called
		@enddesc
	]]

	--[[
		@doc
		@hook VGUIPanelInitialized
		@args Panel self, Panel parent, vararg any

		@desc
		Called **before** `Panel:Prepare()` called
		@enddesc
	]]

	--[[
		@doc
		@hook VGUIPanelCreated
		@args Panel self, Panel parent, vararg any

		@desc
		Called **after** everything.
		@enddesc
	]]


	vgui.DLib_Create = vgui.DLib_Create or vgui.Create

	local patched = DLib._PanelDefinitions ~= nil
	local vgui = vgui

	local function patch()
		if not vgui.CreateX then
			return
		end

		if not patched then
			if not vgui.GetControlTable then return end

			for i = 1, 10 do
				local name, value = debug.getupvalue(vgui.GetControlTable, 1)

				if name == 'PanelFactory' then
					PanelDefinitions = value
					break
				end
			end

			if not PanelDefinitions then
				return
			end

			patched = true
			vgui.CreateNative = vgui.CreateX
			DLib._PanelDefinitions = PanelDefinitions
			vgui.PanelDefinitions = PanelDefinitions
		end

		local PanelDefinitions = DLib._PanelDefinitions

		local CreateNative = vgui.CreateNative
		local error = error
		local table = table

		local function Create(from, class, parent, name, level, ...)
			if class == '' then
				error(debug.traceback('Tried to create panel with empty classname'))
				return
			end

			local meta = PanelDefinitions[class]

			if not meta then
				local panel = CreateNative(class, parent, name, ...)

				if not panel then
					if level == 1 then
						error(string.format('(Native) Panel %q does not exist.', class), level + 4)
					else
						error(string.format('%q tried to derive from (native) panel %q which does not exist.', from, class), level + 4)
					end
				end

				return panel, true
			end

			if not meta.Base then
				error(string.format('Meta table of %q does not contain `Base` panel classname', class))
			end

			local panel = Create(class, meta.Base, parent, name or class, level + 1, ...)

			if not panel then
				error(string.format('%q cannot derive from %q', class, meta.Base), level + 4)
			end

			table.Merge(panel:GetTable(), meta)
			panel.BaseClass = PanelDefinitions[meta.Base]
			panel.ClassName = class

			if level == 1 then
				hook.Run('VGUIPanelConstructed', panel, ...)
			end

			if panel.Init then
				panel:Init(...)
			end

			if level == 1 then
				hook.Run('VGUIPanelInitialized', panel, ...)
			end

			panel:Prepare()

			if level == 1 then
				hook.Run('VGUIPanelCreated', panel, ...)
			end

			return panel
		end

		function vgui.Create(class, parent, name, ...)
			if class == '' then
				DLib.MessageError(debug.traceback('BACKWARDS COMPATIVILITY WITH GMOD ENGINE: Tried to create panel with empty classname'))
				return
			end

			local panel, isNative
			local packed, size = {...}, select('#', ...)

			local status = ProtectedCall(function()
				panel, isNative = Create(nil, class, parent, name, 1, unpack(packed, 1, size))
			end)

			if not status then
				-- error(string.format('Cannot create panel %q! Look for errors above', class), 2)
				local rebuild = {}

				for i, line in ipairs(debug.traceback(string.format('Cannot create panel %q! Look for errors above', class)):split('\n')) do
					table.insert(rebuild, line)
					table.insert(rebuild, '\n')
				end

				DLib.MessageError(unpack(rebuild))
				return
			end

			if isNative then
				hook.Run('VGUIPanelConstructed', panel, ...)
				hook.Run('VGUIPanelInitialized', panel, ...)
				hook.Run('VGUIPanelCreated', panel, ...)
			end

			return panel
		end

		function vgui.CreateFromTable(meta, parent, name, ...)
			if not meta or not istable(meta) then
				error('Invalid meta (PANEL table) provided (typeof ' .. type(meta) .. ')')
			end

			if not meta.Base then
				error(string.format('Meta table of %p (%s) does not contain `Base` panel classname', meta, meta))
			end

			local panel, isNative
			local packed, size = {...}, select('#', ...)

			local status = ProtectedCall(function()
				panel, isNative = Create(string.format('%p (%s)', meta, meta), meta.Base, parent, name, 2, unpack(packed, 1, size))
			end)

			if not status then
				error(string.format('Cannot create panel %p (%s)! Look for errors above', meta, meta), 2)
			end

			table.Merge(panel:GetTable(), meta)
			panel.BaseClass = PanelDefinitions[meta.Base]

			hook.Run('VGUIPanelConstructed', panel, ...)

			if panel.Init then
				panel:Init(...)
			end

			hook.Run('VGUIPanelInitialized', panel, ...)
			panel:Prepare()
			hook.Run('VGUIPanelCreated', panel, ...)

			return panel
		end
	end

	--if not DLib._PanelDefinitions then
	patch()

	if not patched then
		DLib.Message('Unable to fully replace vgui.Create, falling back to old one patch of vgui.Create... Localization might break!')
		local vgui = vgui
		local ignore = 0

		function vgui.Create(...)
			if ignore == FrameNumberL() then return vgui.DLib_Create(...) end

			ignore = FrameNumberL()
			local pnl = vgui.DLib_Create(...)
			ignore = 0

			if not pnl then return end
			hook.Run('VGUIPanelConstructed', pnl, ...)
			hook.Run('VGUIPanelInitialized', pnl, ...)
			hook.Run('VGUIPanelCreated', pnl, ...)
			return pnl
		end
	end
	--end
end

local CSoundPatch = FindMetaTable('CSoundPatch')

--[[
	@doc
	@fname CSoundPatch:IsValid

	@returns
	boolean: IsPlaying()
]]
function CSoundPatch:IsValid()
	return self:IsPlaying()
end

--[[
	@doc
	@fname CSoundPatch:Remove
]]
function CSoundPatch:Remove()
	return self:Stop()
end

local meta = getmetatable(function() end) or {}

function meta:tonumber(base)
	return tonumber(self, base)
end

function meta:tostring()
	return tostring(self)
end

debug.setmetatable(function() end, meta)

--[[
	@doc
	@fname string.tonumber
	@args number base = 10

	@returns
	number
]]

--[[
	@doc
	@fname string:tonumber
	@args number base = 10

	@returns
	number
]]

--[[
	@doc
	@fname math.tonumber
	@args number base = 10

	@returns
	number
]]

--[[
	@doc
	@fname number:tonumber
	@args number base = 10

	@returns
	number
]]

--[[
	@doc
	@fname string.tostring

	@returns
	string
]]

--[[
	@doc
	@fname string:tostring

	@returns
	string
]]

--[[
	@doc
	@fname math.tostring

	@returns
	string
]]

--[[
	@doc
	@fname number:tostring

	@returns
	string
]]
string.tonumber = meta.tonumber
string.tostring = meta.tostring

math.tonumber = meta.tonumber
math.tostring = meta.tostring
