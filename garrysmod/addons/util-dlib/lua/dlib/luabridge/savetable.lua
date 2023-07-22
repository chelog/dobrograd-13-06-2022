
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

local DLib = DLib
local net = net
local player = player
local util = util
local bit = bit

if SERVER then
	net.pool('dlib_sync_savetable_values')
end

DLib.__TrackedSaveTableValues = DLib.__TrackedSaveTableValues or {}
DLib.__TrackedSaveTableTypes = DLib.__TrackedSaveTableTypes or {}
local track = DLib.__TrackedSaveTableValues
local trackr = {}
local tracktypes = DLib.__TrackedSaveTableTypes

for i, ply in ipairs(player.GetAll()) do
	ply.__dlib_st_cache = nil
end

local typesFuncs = {
	string = {
		net.WriteString,
		net.ReadString
	},

	int = {
		net.WriteInt32,
		net.ReadInt32
	},

	float = {
		net.WriteFloat,
		net.ReadFloat
	},

	smallint = {
		net.WriteInt16,
		net.ReadInt16
	},

	byte = {
		net.WriteInt8,
		net.ReadInt8
	},

	uint = {
		net.WriteUInt32,
		net.ReadUInt32
	},

	smalluint = {
		net.WriteUInt16,
		net.ReadUInt16
	},

	ubyte = {
		net.WriteUInt8,
		net.ReadUInt8
	},

	angle = {
		net.WriteAngle,
		net.ReadAngle
	},

	vector = {
		net.WriteVector,
		net.ReadVector
	},

	angle_double = {
		net.WriteAngleDouble,
		net.ReadAngleDouble
	},

	vector_double = {
		net.WriteVectorDouble,
		net.ReadVectorDouble
	},

	bool = {
		net.WriteBool,
		net.ReadBool
	},

	entity = {
		net.WriteEntity,
		net.ReadEntity
	},

	any = {
		net.WriteType,
		net.ReadType
	},
}

--[[
	@doc
	@fname DLib.TrackSaveTableVar
	@args string varname, string vartype
	@deprecated

	@desc
	Asks DLib for networking this savetable variable to clients.
	This function very bandwidth efficently does so, however, it increase serverside lag because
	it use !g:GetInternalVariable which is **damn slow**
	`vartype` can be anything from next:
	`string`
	`int`
	`uint`
	`smallint`
	`usmallint`
	`byte`
	`ubyte`
	`float`
	`angle`
	`vector`
	`angle_double`
	`vector_double`
	`bool`
	`entity`
	`any`
	This is basically a workaround for https://github.com/Facepunch/garrysmod-issues/issues/2552
	@enddesc

	@returns
	boolean: whenever variable was registered before. if so, it just updates it's type
]]
function DLib.TrackSaveTableVar(varname, vartype)
	if vartype == 'Entity' then vartype = 'entity' end

	if not typesFuncs[vartype] then
		error('Unknown variable type provided')
	end

	tracktypes[varname] = vartype

	if table.qhasValue(track, varname) then
		return false
	end

	table.insert(track, varname)
	table.sort(track)

	for i, var in ipairs(track) do
		if var == varname then
			trackr[varname] = i
		end
	end

	return true
end

for i, varname in ipairs(track) do
	trackr[varname] = i
end

local plyMeta = FindMetaTable('Player')

--[[
	@doc
	@fname Player:LookupServerInternalVariable
	@args string varname, any default
	@deprecated

	@returns
	any: stored variable
]]
function plyMeta:LookupServerInternalVariable(varname, def)
	if SERVER then
		local val = self:GetInternalVariable(varname)
		if val == nil then return def end
		return val
	end

	if not self.__dlib_st_cache then return def end
	local val = self.__dlib_st_cache[varname]
	if val == nil then return def end
	return val
end

if SERVER then
	local function PlayerPostThink(ply)
		local data = ply.__dlib_st_cache

		if not data then
			data = {}
			ply.__dlib_st_cache = data
		end

		local send

		for i, var in ipairs(track) do
			local getvar = ply:GetInternalVariable(var)

			if getvar ~= data[var] and getvar ~= nil then
				send = send or {}
				send[var] = getvar
				data[var] = getvar
			end
		end

		if not send then return end

		net.Start('dlib_sync_savetable_values')
		local flags = {}
		local mflags = (#track - #track % 32) / 32

		for slot = 0, mflags do
			flags[slot] = 0
		end

		for var in pairs(send) do
			local i = trackr[var] - 1
			local slot = (i - i % 32) / 32
			flags[slot] = flags[slot]:bor(bit.lshift(1, i % 32))
		end

		for slot = 0, mflags do
			net.WriteInt32(flags[slot])
		end

		for i, var in ipairs(track) do
			local val = send[var]

			if val ~= nil then
				typesFuncs[tracktypes[var]][1](val)
			end
		end

		net.Send(ply)
	end

	hook.Add('PlayerPostThink', 'DLib.SaveTableTrack', PlayerPostThink)
	return
end

local LocalPlayer = LocalPlayer

net.receive('dlib_sync_savetable_values', function()
	local ply = LocalPlayer()
	local data = ply.__dlib_st_cache

	if not data then
		data = {}
		ply.__dlib_st_cache = data
	end

	local flags = {}

	for slot = 0, (#track - #track % 32) / 32 do
		flags[slot] = net.ReadInt32()
	end

	for i, var in ipairs(track) do
		i = i - 1

		if flags[(i - i % 32) / 32]:band(bit.lshift(1, i % 32)) ~= 0 then
			data[var] = typesFuncs[tracktypes[var]][2]()
		end
	end
end)
