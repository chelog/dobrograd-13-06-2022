AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"

include "shared.lua"

local transferDiff = {70, 130} -- time difference in %

netstream.Hook('dbg-travel.submit', function(ply, from, to)

	if from == to then return end
	local stops = ents.FindByClass('ent_dbg_travel')
	if from < 1 or from > #stops then return end
	if to < 1 or to > #stops then return end

	local travel = stops[from]
	if CurTime() - travel.pendingTransfer > 3 then return end
	if not travel:IsPlayerWaiting(ply) then return end

	local dist = octolib.math.loopedDist(from, to, 0, #stops)
	local fee = travel:GetFee(ply, dist)
	if not travel:CanTransfer(ply, fee, notify) then return end

	local time = dist * travel.transferLength * math.random(unpack(transferDiff)) * 0.01
	ply:ScreenFade(SCREENFADE.OUT, color_black, 1, time)
	timer.Simple(1.5, function()
		if IsValid(ply) then
			ply:ExitVehicle()
			ply:SetNoDraw(true)
			ply:SetNotSolid(true)
			ply:Freeze(true)
		end
	end)
	timer.Simple(time, function()
		if IsValid(ply) then
			local pos = stops[to]:LocalToWorld(Vector(45, -30 + 35 * stops[to].transferPos, 10))
			stops[to].transferPos = (stops[to].transferPos + 1) % 3
			ply:SetPos(pos)
			ply:SetNoDraw(false)
			if IsValid(ply:GetActiveWeapon()) then ply:GetActiveWeapon():SetNoDraw(false) end
			ply:SetNotSolid(false)
			ply:Freeze()
			ply:addMoney(-fee)
			ply:Notify(L.you_used_bus .. DarkRP.formatMoney(fee))
			ply:ScreenFade(SCREENFADE.IN, color_black, 1, 1)
		end
	end)
end)

function ENT:Initialize()

	self:SetModel('models/octoteam/props/modern_bus_stop.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.pendingTransfer = 0
	self.transferPos = 0
	self.nextMenuShow = 0

end

function ENT:Think()

	if self:GetNetVar('nextTransfer', 0) <= CurTime() then
		self:TransferPlayers()
	elseif self:GetNetVar('nextTransfer', 0) - CurTime() <= 3 then
		self.pendingTransfer = CurTime()
	end
	if self.nextMenuShow <= CurTime() then
		self:ShowMenu()
	end

	self:NextThink(CurTime() + 1)
	return true

end

function ENT:IsPlayerWaiting(ply)
	for _,v in ipairs(self:GetWaitingPlayers()) do
		if v == ply then return true end
	end
	return false
end

function ENT:GetWaitingPlayers()
	return ents.FindInSphere(self:LocalToWorld(self:OBBCenter()), self:BoundingRadius() * 0.5)
end

function ENT:TransferPlayers()
	local transferTime = CurTime() + math.random(unpack(CurTime() < 1800 and self.transferIntervalLow or self.transferInterval))
	self:SetNetVar('nextTransfer', transferTime)
	self.nextMenuShow = math.max(CurTime(), transferTime - self.menuLength)
end

function ENT:ShowMenu()
	local stops = {}
	for _,v in ipairs(ents.FindByClass('ent_dbg_travel')) do
		stops[#stops+1] = {v:GetPos()}
		if v == self then stops[#stops][2] = true end
	end
	for i, ply in ipairs(self:GetWaitingPlayers()) do
		if not ply:IsPlayer() or ply:IsAFK() or ply.sg_invisible then continue end
		if self:CanTransfer(ply, self:GetFee(ply), true) then
			netstream.Start(ply, 'dbg-travel.buildMenu', stops, self:GetNetVar('nextTransfer', 0), false, self)
		end
	end
	self.nextMenuShow = math.huge
end

function ENT:Use(activator)
	if not self:IsPlayerWaiting(activator) then return end
	if not self:CanTransfer(activator, self:GetFee(activator), true) then return end
	if self:GetNetVar('nextTransfer', 0) - CurTime() > self.menuLength then
		activator:Notify('Автобус еще не приехал')
		return
	end
	local stops = {}
	for _,v in ipairs(ents.FindByClass('ent_dbg_travel')) do
		stops[#stops+1] = {v:GetPos()}
		if v == self then stops[#stops][2] = true end
	end
	netstream.Start(activator, 'dbg-travel.buildMenu', stops, self:GetNetVar('nextTransfer', 0), false, self)
end

-- send player bus stops' positions
hook.Add('PlayerFinishedLoading', 'dbg-travel', function(ply)

	local stops = {}
	for _,v in ipairs(ents.FindByClass('ent_dbg_travel')) do
		stops[#stops+1] = {v:GetPos()}
	end

	netstream.Start(ply, 'dbg-travel.buildMenu', stops, 0, true)

end)
