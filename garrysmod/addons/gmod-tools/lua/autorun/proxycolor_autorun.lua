local entCache = {}
local entMeta = FindMetaTable('Entity')

if SERVER then
	AddCSLuaFile('matproxy/matproxycolors.lua')
else
	include('matproxy/matproxycolors.lua')
end

function entMeta:GetProxyColors()
	return self:GetNetVar('proxyCols')
end

function entMeta:SetProxyColors(cols)
	if not istable(cols) then return end

	for i = 1,7 do
		if IsColor(cols[i]) then cols[i] = cols[i]:ToVector() end
	end

	if SERVER then
		self:SetNetVar('proxyCols', cols)
		duplicator.StoreEntityModifier(self, 'proxyColors', cols)
	else
		for i = 1, 7 do
			self['ColorSlot' .. i] = cols[i]
		end
	end
end

if SERVER then
	duplicator.RegisterEntityModifier('proxyColors', function(ply, ent, cols)
		ent:SetProxyColors(cols)
	end)
else
	hook.Add('NotifyShouldTransmit', 'proxyColors', function(ent, should)
		if not should then return end
		local cols = ent:GetNetVar('proxyCols')
		if cols then ent:SetProxyColors(cols) end
	end)

	hook.Add('NetworkEntityCreated', 'proxyColors', function(ent)
		local cols = ent:GetNetVar('proxyCols')
		if cols then ent:SetProxyColors(cols) end
	end)

	hook.Add('octolib.netVarUpdate', 'proxyColors', function(index, key, value)
		if key ~= 'proxyCols' then return end
		local ent = Entity(index)
		if IsValid(ent) then ent:SetProxyColors(value) end
	end)
end
