
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

-- Those are based on source engine entities

-- Willox (C)
-- it's less of a limitation and more of proper usage
-- a real source mod is going to add dtvars to the player class, they are a compile-time thing so addons can't really do that
-- although tf2 does have certain controller entities that parent to players and have dtvars, so i guess it's not too different to that
-- i didn't think the jetpack would be so many lines of code... not a great example

-- despite everything
-- this module does not work (because entities don't work they way i want to use them for this)
-- consider using DLib.PredictedVarList
-- or NW2Vars when their proper version get merged with stable/x64/chromium branch

local net = net
local DLib = DLib
local string = string
local table = table
local pairs = pairs
local math = math

if SERVER then
	net.pool('dlib_pred_ack')
end

DLib.pred = DLib.pred or {}
local pred = DLib.pred
local plyMeta = FindMetaTable('Player')

pred._ack = {}

local lockRebuild = false

pred.Vars = pred.Vars or {}
pred._known = pred._known or {}
pred._Vars = pred._Vars or {}
pred.MaxEnt = pred.MaxEnt or 0

pred.SlotCounters = pred.SlotCounters or {
	String = 0,
	Bool = 0,
	Float = 0,
	Int = 0,
	Vector = 0,
	Angle = 0,
	Entity = 0,
}

pred.Slots = pred.Slots or {
	String = {},
	Bool = {},
	Float = {},
	Int = {},
	Vector = {},
	Angle = {},
	Entity = {},
}

--[[
	@doc
	@fname DLib.pred.Reload
	@internal

	@desc
	Forcefully rebuilds all entity definition for mimicking. Does nothing when gmod version is fresh enough.
	@enddesc
]]
function pred.Reload()
	local vars = pred.Vars
	pred.Vars = {}
	pred.MaxEnt = 0
	pred._known = {}
	pred._Vars = {}

	pred.SlotCounters = {
		String = 0,
		Bool = 0,
		Float = 0,
		Int = 0,
		Vector = 0,
		Angle = 0,
		Entity = 0,
	}

	lockRebuild = true

	for key, value in pairs(vars) do
		pred.Define(key, value.type, value.default)
	end

	lockRebuild = false

	for i = 0, pred.MaxEnt do
		pred.RebuildEntityDefinition(i)
	end
end

--[[
	@doc
	@fname DLib.pred.Define
	@args string identify, string type, any default
	@deprecated

	@desc
	If gmod version is good enough, this function just defines NW2Vars methods to player metatable based
	on identify you provided (e.g.)
	`plyMeta['Get' .. identify]`
	`plyMeta['Set' .. identify]`
	`plyMeta['Add' .. identify]`
	`plyMeta['Reset' .. identify]`

	if gmod version is old, it tries to mimic NW2Vars behavior by creating predicted network entities
	(which of course sometimes do and sometimes do not work properly, thanks to gmod)
	Also, in such case, you have to call `Player:DLibInvalidatePrediction(true)` and `Player:DLibInvalidatePrediction(false)`
	where you would normally call !g:Entity:SetPredictable
	`Player:DLibInvalidatePrediction` is safe to be called serverside and does nothing there

	Types for `type` argument you can find on [Data Tables](https://wiki.garrysmod.com/page/Networking_Entities) gmod wiki page
	This function is marked as deprecated since it is somewhat *very* dirty hack over gmod,
	but it probably won't be removed
	@enddesc
]]
function pred.Define(identify, mtype, default)
	if VERSION >= 0x0002e8fb then
		plyMeta['Get' .. identify] = function(self)
			return self['GetNW2' .. mtype](self, identify, default)
		end

		plyMeta['Set' .. identify] = function(self, val)
			return self['SetNW2' .. mtype](self, identify, val)
		end

		plyMeta['Add' .. identify] = function(self, val, min, max)
			if min and not max then
				if val < 0 then
					return self['SetNW2' .. mtype](self, identify, math.max(self['GetNW2' .. mtype](self, identify, default) + val, min))
				else
					return self['SetNW2' .. mtype](self, identify, math.min(self['GetNW2' .. mtype](self, identify, default) + val, min))
				end
			elseif min and max then
				return self['SetNW2' .. mtype](self, identify, math.clamp(self['GetNW2' .. mtype](self, identify, default) + val, min, max))
			end

			return self['SetNW2' .. mtype](self, identify, self['GetNW2' .. mtype](self, identify, default) + val)
		end

		plyMeta['Reset' .. identify] = function(self)
			return self['SetNW2' .. mtype](self, identify, default)
		end

		return
	end

	if pred.Vars[identify] then
		-- assert(pred.Vars[identify].type == mtype, 'Can not change type of variable at runtime')

		if pred.Vars[identify].type ~= mtype then
			pred.Vars[identify].default = default
			pred.Vars[identify].type = mtype

			pred.Reload()

			return
		end

		pred.Vars[identify].default = default

		return
	end

	if not pred.SlotCounters[mtype] then
		error('Invalid variable type provided: ' .. mtype)
	end

	local crc = util.CRC(identify):tonumber()

	if crc < 0 then
		crc = 0xFFFFFFFF + crc
	end

	pred.Vars[identify] = {
		identify = identify,
		type = mtype,
		--slot = slot,
		crc = crc,
		default = default
	}

	local mData = pred.Vars[identify]
	local sorted = {}

	for key, data in pairs(pred.Vars) do
		sorted[data.type] = sorted[data.type] or {}
		table.insert(sorted[data.type], data)
	end

	local function sorter(a, b)
		return a.crc > b.crc
	end

	for itype, list in pairs(sorted) do
		table.sort(list, sorter)

		for i, data in ipairs(list) do
			data.slot = i - 1
		end
	end

	pred._Vars = {}
	pred.MaxEnt = 0

	for key, data in pairs(pred.Vars) do
		local _, entId, realSlot = pred.GetEntityAndSlot(key)
		data.realSlot = realSlot
		data.entId = entId
		pred._Vars[entId] = pred._Vars[entId] or {}
		pred._Vars[entId][key] = data
		pred.MaxEnt = pred.MaxEnt:max(entId)
	end

	if not lockRebuild then
		for i = 0, pred.MaxEnt do
			timer.Create('DLib.pred.DeferReload' .. i, 0, 1, function()
				pred.RebuildEntityDefinition(i)
			end)
		end
	end

	plyMeta['Get' .. identify] = function(self)
		local ent = self.__dlib_pred_ent and self.__dlib_pred_ent[mData.entId + 1]
		if not IsValid(ent) then return mData.default end
		if not ent['Get' .. identify] then return mData.default end
		return ent['Get' .. identify](ent)
	end

	plyMeta['Set' .. identify] = function(self, newValue)
		local ent = self.__dlib_pred_ent and self.__dlib_pred_ent[mData.entId + 1]
		if not IsValid(ent) then return end
		if not ent['Set' .. identify] then return end
		return ent['Set' .. identify](ent, newValue)
	end

	plyMeta['Add' .. identify] = function(self, val, min, max)
		if min and not max then
			if val < 0 then
				return self['SetNW2' .. mtype](self, identify, math.max(self['Get' .. identify](self) + val, min))
			else
				return self['SetNW2' .. mtype](self, identify, math.min(self['Get' .. identify](self) + val, min))
			end
		elseif min and max then
			return self['SetNW2' .. mtype](self, identify, math.clamp(self['Get' .. identify](self) + val, min, max))
		end

		return self['SetNW2' .. mtype](self, identify, self['Get' .. identify](self) + val)
	end


	plyMeta['Reset' .. identify] = function(self)
		return self['Set' .. identify](self, pred.Vars[identify].default)
	end
end

--[[
	@doc
	@fname plyMeta:DLibInvalidatePrediction
	@args boolean status = false

	@desc
	Sets !g:Entity:SetPredictable on all parented DLib vars entities to desired state
	Does nothing when gmod version is fresh enough
	@enddesc
]]
function plyMeta:DLibInvalidatePrediction(status)
	if not self.__dlib_pred_ent or SERVER then return end

	for i, ent in ipairs(self.__dlib_pred_ent) do
		if IsValid(ent) then
			ent:SetPredictable(status or false)
		end
	end
end

--[[
	@doc
	@fname DLib.pred.Fingerprint
	@args number entitySlotID = nil

	@returns
	number: the fingerpring
]]
function pred.Fingerprint(entId)
	local fingerprint = 0

	if not entId then
		for key, data in pairs(pred.Vars) do
			fingerprint = fingerprint + ((data.crc % 4634661) / 12):floor()
			fingerprint = fingerprint + ((util.CRC(data.type):tonumber():rshift(4) % 612348) / 5):floor()
			fingerprint = fingerprint + (data.slot:rshift(6) + 23):band(65535)

			fingerprint = fingerprint % 5839581561
		end
	elseif pred._Vars[entId] then
		for key, data in pairs(pred._Vars[entId]) do
			fingerprint = fingerprint + ((data.crc % 4634661) / 12):floor()
			fingerprint = fingerprint + ((util.CRC(data.type):tonumber():rshift(4) % 612348) / 5):floor()
			fingerprint = fingerprint + (data.slot:rshift(6) + 23):band(65535)

			fingerprint = fingerprint % 5839581561
		end
	end

	return fingerprint
end

--[[
	@doc
	@fname DLib.pred.RebuildEntityDefinition
	@args number entitySlotID, boolean _now = false
	@internal
]]
function pred.RebuildEntityDefinition(entId, _now)
	if SERVER and not _now then
		pred._ack[entId] = player.GetHumans()

		if #pred._ack[entId] == 0 then
			pred.RebuildEntityDefinition(entId, true)
			return
		end

		net.Start('dlib_pred_ack')
		net.WriteUInt8(entId)
		net.WriteUInt64(pred.Fingerprint())
		net.Broadcast()

		timer.Start('DLib.pred.RebuildAck', 10, 1, function()
			pred.RebuildEntityDefinition(entId, true)
		end)

		return
	end

	pred._ack[entId] = nil

	local ENT = {}
	ENT.Type = 'anim'
	ENT.Spawnable = false
	ENT.AdminSpawnable = false
	ENT.Author = 'DBotThePony'
	ENT.PrintName = 'DLib Predicted player variables bundle'

	function ENT:Initialize()
		self:SetSolid(SOLID_NONE)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetNoDraw(true)
		self:SetTransmitWithParent(true)
	end

	function ENT:Draw()

	end

	function ENT:SetupDataTables()
		if not pred._Vars[entId] then return end

		for k, v in pairs(pred._Vars[entId]) do
			self:NetworkVar(v.type, v.realSlot, k)
		end

		for k, v in pairs(pred._Vars[entId]) do
			self['Set' .. k](self, v.default)
		end
	end

	function ENT:DumpVariables()
		local output = {}
		if not pred._Vars[entId] then return output end

		for k, v in pairs(pred._Vars[entId]) do
			if self['Get' .. k] then
				output[k] = self['Get' .. k](self)
			end
		end

		return output
	end

	function ENT:LoadVariables(input)
		for k, v in pairs(input) do
			if self['Set' .. k] then
				self['Set' .. k](self, v)
			end
		end
	end

	function ENT:Think()
		if not IsValid(self:GetParent()) then
			if CLIENT then return end

			if not IsValid(self.__dlib_parent) then
				SafeRemoveEntity(self)
				return
			else
				self:SetParent(self.__dlib_parent)
				self:SetPos(self.__dlib_parent:GetPos())
			end
		end

		local ply = self:GetParent():GetTable()

		if not ply.__dlib_pred_ent then
			ply.__dlib_pred_ent = {}
		end

		if SERVER and IsValid(ply.__dlib_pred_ent[entId + 1]) and ply.__dlib_pred_ent[entId + 1] ~= self then
			SafeRemoveEntity(ply.__dlib_pred_ent[entId + 1])
		end

		ply.__dlib_pred_ent[entId + 1] = self
	end

	scripted_ents.Register(ENT, 'dlib_predictednw' .. entId)

	if CLIENT then return end

	for i, ent in ipairs(ents.FindByClass('dlib_predictednw' .. entId)) do
		local dump = ent:DumpVariables()
		local ply = ent:GetParent()
		SafeRemoveEntity(ent)

		if IsValid(ply) then
			ent = ents.Create('dlib_predictednw' .. entId)
			ent:SetParent(ply)
			ent:SetPos(ply:GetPos())
			ent:LoadVariables(dump)
			ent:Spawn()
			ent:LoadVariables(dump)
			ent.__dlib_parent = ply
			ent:Activate()
			ent:Think()
		end
	end

	for i, ply in ipairs(player.GetAll()) do
		if not ply.__dlib_pred_ent then
			for entId = 0, pred.MaxEnt do
				local ent = ents.Create('dlib_predictednw' .. entId)
				ent:SetParent(ply)
				ent:SetPos(ply:GetPos())
				ent:Spawn()
				ent.__dlib_parent = ply
				ent:Activate()
				ent:Think()
			end
		else
			for entId = 0, pred.MaxEnt do
				if not ply.__dlib_pred_ent[entId + 1] then
					local ent = ents.Create('dlib_predictednw' .. entId)
					ent:SetParent(ply)
					ent:SetPos(ply:GetPos())
					ent:Spawn()
					ent.__dlib_parent = ply
					ent:Activate()
					ent:Think()
				end
			end
		end
	end
end

for entId = 0, pred.MaxEnt do
	pred.RebuildEntityDefinition(entId)
end

function pred.GetEntityAndSlot(identify)
	local data = assert(pred.Vars[identify], 'Unknown variable name provided')

	if data.type == 'String' then
		return data.slot, (data.slot - data.slot % 4) / 4, data.slot % 4
	end

	return data.slot, (data.slot - data.slot % 32) / 32, data.slot % 32
end

if CLIENT then
	net.receive('dlib_pred_ack', function()
		local entId = net.ReadUInt8()
		local fingerprint = net.ReadUInt64()
		pred.RebuildEntityDefinition(entId)
		local mfinger = pred.Fingerprint(entId)

		if mfinger ~= fingerprint then
			DLib.MessageError('Integrity check failed in prediction module. Server expected ', fingerprint, ' fingerprint but i got ', mfinger, '. Expect desyncs with server!')
		end

		net.Start('dlib_pred_ack')
		net.WriteUInt8(entId)
		net.WriteUInt64(mfinger)
		net.SendToServer()
	end)

	return
end

net.receive('dlib_pred_ack', function(len, ply)
	local entId = net.ReadUInt8()
	if not pred._ack[entId] then return end
	local hit = false

	for i, ply2 in ipairs(pred._ack[entId]) do
		if ply2 == ply then
			hit = true
			table.remove(pred._ack[entId], i)
			break
		end
	end

	if not hit then return end
	local fingerprint = net.ReadUInt64()
	local mfinger = pred.Fingerprint(entId)

	if mfinger ~= fingerprint then
		DLib.MessageError('Integrity check failed in prediction module over client. Client expected ', fingerprint, ' fingerprint, but i got ', mfinger, '. Expect desyncs with that client!')
	end

	if #pred._ack[entId] == 0 then
		pred.RebuildEntityDefinition(entId, true)
	end
end)

hook.Add('PlayerAuthed', 'DLib.pred', function(ply)
	for entId = 0, pred.MaxEnt do
		local ent = ents.Create('dlib_predictednw' .. entId)
		ent:SetParent(ply)
		ent:SetPos(ply:GetPos())
		ent:Spawn()
		ent.__dlib_parent = ply
		ent:Activate()
		ent:Think()
	end
end, -3)

hook.Add('PostCleanupMap', 'DLib.pred', function()
	for i, ply in ipairs(player.GetAll()) do
		if ply.__dlib_pred_ent then
			for entId = 0, pred.MaxEnt do
				if not IsValid(ply.__dlib_pred_ent[entId + 1]) then
					local ent = ents.Create('dlib_predictednw' .. entId)
					ent:SetParent(ply)
					ent:SetPos(ply:GetPos())
					ent:Spawn()
					ent.__dlib_parent = ply
					ent:Activate()
					ent:Think()
				end
			end
		end
	end
end, -3)
