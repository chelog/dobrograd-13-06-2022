-- This code is taken from NutScript.
-- NutScript and code license are found here:
-- https://github.com/Chessnut/NutScript

netvars = netvars or {}

local entityMeta = FindMetaTable('Entity')
local playerMeta = FindMetaTable('Player')

local stored = netvars.stored or {}
local locals = netvars.locals or {}
local globals = netvars.globals or {}
local registered = netvars.registered or {}

netvars.stored = stored
netvars.locals = locals
netvars.globals = globals
netvars.registered = registered

function netvars.Register(key, data)
	if data == nil or istable(data) then
		registered[key] = data
	end
end

function netvars.GetReceivers(key, receivers)

	if not (registered[key] and isfunction(registered[key].checkAccess)) then
		return receivers
	elseif not receivers then
		receivers = player.GetAll()
	elseif not istable(receivers) then
		receivers = { receivers }
	end

	return octolib.array.filter(receivers, registered[key].checkAccess)
end

function netvars.HasAccess(ply, key)
	return not (registered[key] and isfunction(registered[key].checkAccess)) or registered[key].checkAccess(ply)
end

function netvars.SetNetVar(key, value, receiver)
	if isfunction(value) or not istable(value) and globals[key] == value then return end

	globals[key] = value
	netstream.Start(netvars.GetReceivers(key, receiver), 'gVar', key, value)
end

function playerMeta:UpdateNetVars()
	local storedToSend, globalsToSend = {}, {}
	for k, v in pairs(registered) do
		if not v.checkAccess then continue end
		local hasAccess = v.checkAccess(self)
		if globals[k] ~= nil then
			if hasAccess then
				globalsToSend[k] = globals[k]
			end
		end
		for index, vars in pairs(stored) do
			if vars[k] ~= nil then
				storedToSend[index] = storedToSend[index] or {}
				if hasAccess then
					storedToSend[index][k] = vars[k]
				end
			end
		end
	end
	netstream.Heavy(self, 'nUpd', table.GetKeys(registered), storedToSend, globalsToSend)
end

function entityMeta:SendNetVar(key, receiver)
	local index = self:EntIndex()
	netstream.Start(netvars.GetReceivers(key, receiver), 'nVar', index, key, stored[index] and stored[index][key])
end

function entityMeta:ClearNetVars(receiver)
	local index = self:EntIndex()
	stored[index] = nil
	locals[index] = nil
	netstream.Start(receiver, 'nDel', index)
end

function entityMeta:SetNetVar(key, value, receiver)
	if isfunction(value) or not istable(value) and value == self:GetNetVar(key) then return end

	local index = self:EntIndex()
	stored[index] = stored[index] or {}
	stored[index][key] = value

	self:SendNetVar(key, receiver)
end

function entityMeta:GetNetVar(key, default)
	local index = self:EntIndex()

	local ourLocal = locals[index]
	local ourStored = stored[index]
	local value = ourLocal and ourLocal[key] or ourStored and ourStored[key]
	if value ~= nil then return value end

	return default
end

function playerMeta:SetLocalVar(key, value)
	if isfunction(value) or not istable(value) and value == self:GetNetVar(key) then return end

	local index = self:EntIndex()
	locals[index] = locals[index] or {}
	locals[index][key] = value

	netstream.Start(self, 'nLcl', key, value)
end

playerMeta.GetLocalVar = entityMeta.GetNetVar

function netvars.GetNetVar(key, default)
	local value = globals[key]
	if value ~= nil then return value end

	return default
end

hook.Add('EntityRemoved', 'nCleanUp', function(entity)
	entity:ClearNetVars()
end, 10) -- just in case addons use vars in this hook

hook.Add('PlayerFinishedLoading', 'nSync', function(ply)
	timer.Simple(10, function() -- sometimes it misses some info
		if not IsValid(ply) then return end

		local storedToSend = {} -- filter stored
		for index, vars in pairs(stored) do
			storedToSend[index] = {}
			local empty = true
			for key, value in pairs(vars) do
				if netvars.HasAccess(ply, key) then
					storedToSend[index][key], empty = value, false
				end
			end
			if empty then storedToSend[index] = nil end
		end

		local globalsToSend = {} -- filter globals
		for key, value in pairs(globals) do
			if netvars.HasAccess(ply, key) then
				globalsToSend[key] = value
			end
		end

		netstream.Heavy(ply, 'netvars_full', storedToSend, globalsToSend)

	end)
end)

hook.Add('octolib.updateNetVars', 'nUpd', playerMeta.UpdateNetVars)
