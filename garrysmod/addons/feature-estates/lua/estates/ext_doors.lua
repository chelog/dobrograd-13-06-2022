local meta = FindMetaTable('Entity')

local doorClasses = octolib.array.toKeys { 'prop_door_rotating', 'func_door_rotating', 'func_door' }

function meta:IsDoor()
	if not IsValid(self) then return false end
	return tobool(doorClasses[self:GetClass()])
end

function meta:isKeysOwnable()
	return self:IsVehicle() or self:IsDoor()
end

--[[
	(string|nil)
	Returns ID of estate this door belongs to
]]
function meta:GetEstateID()
	return self:GetNetVar('estate', 0)
end

--[[
	(table|nil)
	Returns information about estate this door belongs to
]]
function meta:GetEstate()
	return dbgEstates.getData(self:GetEstateID())
end

--[[
	(SteamID|nil)
	Returns SteamID of player who owns this door, or nil if no owner
]]
function meta:GetPlayerOwner()
	if not self:IsDoor() or self:IsBlocked() then return end
	local data = self:GetEstate()
	if not data then return end
	for _,v in ipairs(data.owners or {}) do
		if octolib.string.isSteamID(v) then
			return v
		end
	end
end

function meta:IsOwned()
	if not self:IsDoor() or self:IsBlocked() then return end
	local data = self:GetEstate()
	if not data then return false end
	data.owners = data.owners or {}
	return data.owners[1] ~= nil
end

function meta:IsBlocked()
	if not self:IsDoor() then return end
	return self:GetEstateID() == 0
end

function meta:CanBeOwned()
	if not self:IsDoor() or self:IsBlocked() then return end
	return not self:GetEstate().owners[1]
end

function meta:GetPrice()
	if not self:IsDoor() or self:IsBlocked() then return 0 end
	local data = self:GetEstate()
	return data and data.price or GAMEMODE.Config.doorcost or 50
end

function meta:GetTitle()
	return self:IsDoor() and self:GetNetVar('tempTitle')
end

function meta:ShouldObey(ply)
	if not self:IsDoor() or self:IsBlocked() then return end
	if self:GetPlayerOwner() == ply:SteamID() then return true end

	local data = self:GetEstate() -- check job
	local job = 'j:' .. RPExtraTeams[ply:Team()].command
	for _,v in ipairs(data.owners or {}) do
		if v == job then return true end
	end

	return false
end
