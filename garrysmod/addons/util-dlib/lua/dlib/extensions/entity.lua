
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

local entMeta = FindMetaTable('Entity')
local plyMeta = FindMetaTable('Player')
local wepMeta = FindMetaTable('Weapon')
local vehMeta = FindMetaTable('Vehicle')
local npcMeta = FindMetaTable('NPC')

--[[
	@doc
	@fname Entity:IsClientsideEntity

	@returns
	boolean
]]
function entMeta:IsClientsideEntity()
	return false
end

--[[
	@doc
	@fname Entity:SetNWUInt
	@args string name, number value
]]

function entMeta:SetNWUInt(name, value)
	assert(type(value) == 'number', 'Value passed is not a number')

	if value < 0 then
		error('Value can not be negative')
	end

	if value > 0x100000000 then
		error('Integer overflow')
	end

	if value >= 0x7FFFFFFF then
		value = value - 0x100000000
	end

	self:SetNWInt(name, value)
end

--[[
	@doc
	@fname Entity:GetNWUInt
	@args string name, number ifNone

	@returns
	number
]]

function entMeta:GetNWUInt(name, ifNone)
	if type(ifNone) == 'number' then
		if ifNone < 0 then
			error('Value can not be negative')
		end

		if ifNone > 0x100000000 then
			error('Integer overflow')
		end
	end

	local value = self:GetNWInt(name, ifNone)

	if value < 0 then
		return 0x100000000 + value
	else
		return value
	end
end

--[[
	@doc
	@fname Entity:SetNW2UInt
	@args string name, number value
]]
function entMeta:SetNW2UInt(name, value)
	assert(type(value) == 'number', 'Value passed is not a number')

	if value < 0 then
		error('Value can not be negative')
	end

	if value > 0x100000000 then
		error('Integer overflow')
	end

	if value >= 0x7FFFFFFF then
		value = value - 0x100000000
	end

	self:SetNW2Int(name, value)
end

--[[
	@doc
	@fname Entity:GetNW2UInt
	@args string name, number ifNone

	@returns
	number
]]
function entMeta:GetNW2UInt(name, ifNone)
	if type(ifNone) == 'number' then
		if ifNone < 0 then
			error('Value can not be negative')
		end

		if ifNone > 0x100000000 then
			error('Integer overflow')
		end
	end

	local value = self:GetNW2Int(name, ifNone)

	if grab < 0 then
		return 0x100000000 + value
	else
		return value
	end
end

--[[
	@doc
	@fname Player:GetActiveWeaponClass

	@returns
	any: string or nil
]]
function plyMeta:GetActiveWeaponClass()
	local weapon = self:GetActiveWeapon()
	if not weapon:IsValid() then return nil end
	return weapon:GetClass()
end

npcMeta.GetActiveWeaponClass = plyMeta.GetActiveWeaponClass

if CLIENT then
	local CSEnt = FindMetaTable('CSEnt')

	function CSEnt:IsClientsideEntity()
		return true
	end

	function entMeta:IsClientsideEntity()
		local class = self:GetClass()
		return class == 'class C_PhysPropClientside' or class == 'class C_ClientRagdoll' or class == 'class CLuaEffect'
	end
else
	--[[
		@doc
		@fname Entity:BuddhaEnable
	]]

	function entMeta:BuddhaEnable()
		self:SetSaveValue('m_takedamage', DAMAGE_MODE_BUDDHA)
	end

	--[[
		@doc
		@fname Entity:BuddhaDisable
	]]
	function entMeta:BuddhaDisable()
		self:SetSaveValue('m_takedamage', DAMAGE_MODE_ENABLED)
	end

	--[[
		@doc
		@fname Entity:IsBuddhaEnabled

		@returns
		boolean
	]]
	function entMeta:IsBuddhaEnabled()
		return self:GetSaveTable().m_takedamage == DAMAGE_MODE_BUDDHA
	end
end

--[[
	@doc
	@fname Player:IsAlive

	@desc
	alias of !g:Player:Alive
	@enddesc

	@returns
	boolean
]]
function plyMeta:IsAlive()
	return self:Alive()
end

--[[
	@doc
	@fname Player:GetIsAlive

	@desc
	alias of !g:Player:Alive
	@enddesc

	@returns
	boolean
]]
function plyMeta:GetIsAlive()
	return self:Alive()
end

--[[
	@doc
	@fname Weapon:GetClip1

	@desc
	alias of !g:Weapon:Clip1
	@enddesc

	@returns
	number
]]
function wepMeta:GetClip1()
	return self:Clip1()
end

--[[
	@doc
	@fname Weapon:GetClip2

	@desc
	alias of !g:Weapon:Clip2
	@enddesc

	@returns
	number
]]
function wepMeta:GetClip2()
	return self:Clip2()
end

--[[
	@doc
	@fname Player:GetMaxArmor

	@returns
	number
]]
-- placeholder for now
function plyMeta:GetMaxArmor()
	return 100
end

local VehicleListIterable = {}

local function rebuildVehicleList()
	for classname, data in pairs(list.GetForEdit('Vehicles')) do
		if data.Model then
			VehicleListIterable[data.Model:lower()] = data
		end
	end
end

timer.Create('DLib.RebuildVehicleListNames', 10, 0, rebuildVehicleList)
rebuildVehicleList()

--[[
	@doc
	@fname Vehicle:GetAmmoType

	@returns
	number
]]
function vehMeta:GetAmmoType()
	return select(1, self:GetAmmo())
end

--[[
	@doc
	@fname Vehicle:GetAmmoClip

	@returns
	number
]]
function vehMeta:GetAmmoClip()
	return select(2, self:GetAmmo())
end

--[[
	@doc
	@fname Vehicle:GetAmmoCount

	@returns
	number
]]
function vehMeta:GetAmmoCount()
	return select(3, self:GetAmmo())
end

if SERVER then
	net.pool('dlib_emitsoundpredicted')
end

--[[
	@doc
	@fname Entity:EmitSoundPredictedR

	@desc
	Same as !g:Entity:EmitSound , but if `self` is a player, the sound will not be networked to him.
	This DOES NOT correspond to !g:IsFirstTimePredicted , since in some predicted hooks  `IsFirstTimePredicted()` always return `false`
	Achieved with GMod
	basically it is partial fix for https://github.com/Facepunch/garrysmod-issues/issues/2651
	@enddesc
]]
function entMeta:EmitSoundPredictedR(soundName, soundLevel, pitch, volume, channel)
	assert(type(soundName) == 'string', 'Whats up with sound name')
	soundLevel = soundLevel or 75
	pitch = pitch or 100
	volume = volume or 1
	channel = channel or CHAN_AUTO

	if not self:IsPlayer() then
		self:EmitSound(soundName, soundLevel, pitch, volume, channel)
		return
	end

	if game.SinglePlayer() then
		if CLIENT then return end
		self:EmitSound(soundName, soundLevel, pitch, volume, channel)
		return
	end

	if CLIENT then
		self:EmitSound(soundName, soundLevel, pitch, volume, channel)
		return
	end

	if player.GetCount() <= 1 then return end

	local filter = RecipientFilter()
	filter:AddPAS(self:EyePos())
	filter:RemovePlayer(self)

	if filter:GetCount() == 0 then return end

	net.Start('dlib_emitsoundpredicted', true)
	net.WriteString(soundName)
	net.WriteUInt16(soundLevel)
	net.WriteUInt8(pitch)
	net.WriteFloat(volume)
	net.WriteUInt8(channel)
	net.WriteEntity(self)
	net.Send(filter)
end

--[[
	@doc
	@fname Entity:EmitSoundPredicted

	@desc
	Same as !g:Entity:EmitSound , but if `self` is a player, the sound will not be networked to him.
	This do correspond to !g:IsFirstTimePredicted
	Achieved with GMod
	basically it is partial fix for https://github.com/Facepunch/garrysmod-issues/issues/2651

	Look at `Entity:EmitSoundPredictedR` for non !g:IsFirstTimePredicted based version of this function
	@enddesc
]]
function entMeta:EmitSoundPredicted(...)
	if not IsFirstTimePredicted() then return end
	return self:EmitSoundPredictedR(...)
end

local language = language

if CLIENT then
	net.receive('dlib_emitsoundpredicted', function()
		local soundName, soundLevel, pitch, volume, channel, self = net.ReadString(), net.ReadUInt16(), net.ReadUInt8(), net.ReadFloat(), net.ReadUInt8(), net.ReadEntity()

		if not IsValid(self) then return end
		self:EmitSound(soundName, soundLevel, pitch, volume, channel)
	end)

	local player = player
	local IsValid = FindMetaTable('Entity').IsValid
	local GetTable = FindMetaTable('Entity').GetTable
	local GetVehicle = FindMetaTable('Player').GetVehicle
	local NULL = NULL
	local ipairs = ipairs

	--[[
		@doc
		@replaces
		@fname Vehicle:GetDriver

		@desc
		Same as !g:Vehicle:GetDriver
		but this function is now Shared
		@enddesc

		@returns
		Entity: or NULL
	]]
	-- function vehMeta:GetDriver()
	-- 	return self._dlib_vehfix or NULL
	-- end

	-- local function Think()
	-- 	for i, ply in ipairs(player.GetAll()) do
	-- 		local ply2 = GetTable(ply)
	-- 		local veh = GetVehicle(ply)

	-- 		if veh ~= ply2._dlib_vehfix then
	-- 			if IsValid(ply2._dlib_vehfix) then
	-- 				ply2._dlib_vehfix._dlib_vehfix = NULL
	-- 			end

	-- 			ply2._dlib_vehfix = veh

	-- 			if IsValid(veh) then
	-- 				veh._dlib_vehfix = ply
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- hook.Add('Think', 'DLib.GetDriverFix', Think)

	--[[
		@doc
		@fname Vehicle:GetPrintName

		@returns
		string
	]]
	function vehMeta:GetPrintName()
		if self.__dlibCachedName then
			return self.__dlibCachedName
		end

		local getname = self.PrintName or (VehicleListIterable[self:GetModel()] and VehicleListIterable[self:GetModel()].Name)

		if not getname then
			local classname = self:GetClass()
			getname = language.GetPhrase(classname)
		end

		self.__dlibCachedName = getname

		return getname
	end
else
	entMeta.GetNetworkName = entMeta.GetName
	entMeta.SetNetworkName = entMeta.SetName
	entMeta.GetNetworkedName = entMeta.GetName
	entMeta.SetNetworkedName = entMeta.SetName
	entMeta.GetTargetName = entMeta.GetName
	entMeta.SetTargetName = entMeta.SetName

	function vehMeta:GetPrintName()
		if self.__dlibCachedName then
			return self.__dlibCachedName
		end

		local getname = self.PrintName

		if not getname then
			getname = VehicleListIterable[self:GetModel()] or self:GetClass()
		end

		self.__dlibCachedName = getname

		return getname
	end
end

--[[
	@doc
	@fname Vehicle:GetPrintNameDLib
	@args boolean unlocalized = false

	@desc
	When `unlocalized` is `true`, if i18n phrase is present, it will return unlocalized.
	@enddesc

	@returns
	string
]]
function entMeta:GetPrintNameDLib(unlocalized)
	if self:IsPlayer() then return self:Nick() end

	if self.GetPrintName then
		local pname = self:GetPrintName()

		if SERVER and pname and pname:startsWith('#') then
			local class = self:GetClass() or 'unknown'
			local localized = 'info.entity.' .. class .. '.name'

			if DLib.i18n.exists(localized) then
				return unlocalized and localized or DLib.i18n.localize(localized)
			end
		end

		return pname or '<MISSING PRINT NAME>'
	end

	local class = self:GetClass() or 'unknown'
	local localized = 'info.entity.' .. class .. '.name'

	if DLib.i18n.exists(localized) then
		return unlocalized and localized or DLib.i18n.localize(localized)
	end

	local str = self.PrintName

	if not str or #str == 0 then
		str = language and language.GetPhrase and language.GetPhrase(class) or class
	end

	if str:startsWith('#') and language and language.GetPhrase then
		str = language.GetPhrase(str:sub(1)) or str
	end

	return str or self:GetName()
end
