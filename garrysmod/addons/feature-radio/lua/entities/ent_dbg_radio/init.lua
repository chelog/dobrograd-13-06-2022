AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function ENT:Initialize()

	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.whitelisted = false

end

function ENT:UpdateDuplicatorData()
	self.radioData = {
		whitelisted = self.whitelisted,
		allowedStations = self.allowedStations,
		stationsWhitelist = self.stationsWhitelist,
		volume = self:GetVolume(),
		dist = self:GetDistance(),
		stream = self:GetStreamURL(),
	}
end

function ENT:SetVolume(vol)
	vol = vol or 0.2
	if vol > 1 then vol = vol / 100 end
	self:SetNetVar('volume', math.Clamp(vol or 0.2, 0, 1))
	self:UpdateDuplicatorData()
end

function ENT:SetDistance(dist)
	dist = math.Clamp(dist or 600, 200, 1500)
	self:SetNetVar('distSqr', dist * dist)
	self:SetNetVar('dist', dist)
	self:UpdateDuplicatorData()
end

function ENT:SetStreamURL(url)
	if url == '' then url = nil end
	self:SetNetVar('stream', url)
	self:UpdateDuplicatorData()
end

function ENT:SetStationsWhitelist(whitelist)
	if whitelist and not istable(whitelist) then return end
	if not whitelist then
		self.whitelisted, self.allowedStations, self.stationsWhitelist = false
		self:UpdateDuplicatorData()
		return
	end
	self.whitelisted, self.allowedStations, self.stationsWhitelist = true, {}, {}
	for _, v in ipairs(whitelist) do
		self.allowedStations[v.id] = v
		self.stationsWhitelist[#self.stationsWhitelist + 1] = v.id
	end
	self:UpdateDuplicatorData()
end

-- returns bool (is station allowed to listen to) and table (overrides of station properties, optional)
function ENT:GetStationModifies(id)
	if not self.allowedStations then return true end
	if not self.allowedStations[id] then return false end
	return true, self.allowedStations[id]
end

duplicator.RegisterEntityClass('ent_dbg_radio', function(ply, data)

	if IsValid(ply) and not ply:IsAdmin() then return false end

	local ent = duplicator.GenericDuplicatorFunction(ply, data)
	data = data.radioData or {}
	ent.whitelisted = data.whitelisted
	ent.allowedStations = data.allowedStations
	ent.stationsWhitelist = data.stationsWhitelist
	ent:SetVolume(data.volume)
	ent:SetDistance(data.dist)
	ent:SetStreamURL(data.stream)
	ent.duplicated = true
	ent:GetPhysicsObject():EnableMotion(false)
	ent.static = true
	ent.pinned = true

	return ent

end, 'Data', 'radioData')
