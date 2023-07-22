local meta = FindMetaTable 'Player'

local updateHooks

local function playerInvisibleHook(ply)
	if ply:IsInvisible() then
		ply:MakeInvisible(false)
		updateHooks()
	end
end

updateHooks = function()
	local haveInvisiblePlayers = false
	for _, user in ipairs(player.GetAll()) do
		if user:IsInvisible() then
			haveInvisiblePlayers = true
			break
		end
	end
	if haveInvisiblePlayers then
		hook.Add('PlayerEnteredVehicle', 'dbg-invisible', playerInvisibleHook)
		hook.Add('PlayerDeath', 'dbg-invisible', playerInvisibleHook)
	else
		hook.Remove('PlayerEnteredVehicle', 'dbg-invisible')
		hook.Remove('PlayerDeath', 'dbg-invisible')
	end
end

local function updateTransmitForAll(ent, state, ply)
	for _, v in ipairs(player.GetAll()) do
		if v == ply then continue end
		ent:SetPreventTransmit(v, state)
	end
	for _, v in ipairs(ent:GetChildren()) do
		updateTransmitForAll(v, state, ply)
	end
	ent:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
end

local function updateTransmitFor(ent, state, ply)
	ent:SetPreventTransmit(ply, state)
	for _, v in ipairs(ent:GetChildren()) do
		updateTransmitFor(v, state, ply)
	end
	ent:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
end

function meta:MakeInvisible(state)
	state = tobool(state)
	self:SetNoDraw(state)
	self:SetNotSolid(state)
	self:DrawWorldModel(not state)
	self.sg_invisible = state
	self:SetNetVar('Invisible', state or nil)

	for _, ent in ipairs(octolib.array.filter(self:GetChildren(), function(ent) return ent:GetClass() == 'ent_bonemerged' end)) do
		ent:SetNoDraw(state)
	end

	updateTransmitForAll(self, state, self)
	updateHooks()
end

function meta:IsInvisible()
	return tobool(self.sg_invisible)
end

hook.Add('PlayerFinishedLoading', 'dbg-invisible', function(ply)
	for _, v in ipairs(player.GetAll()) do
		if v.sg_invisible then
			updateTransmitFor(v, tobool(v.sg_invisible), ply)
		end
	end
end)

hook.Add('PlayerCanPickupWeapon', 'dbg-invisible', function(ply, wep)
	if ply:IsInvisible() then
		updateTransmitForAll(ply, true, ply)
		ply:DrawWorldModel(false)
	end
end)

hook.Add('PlayerSwitchWeapon', 'dbg-invisible', function(ply)
	if ply:IsInvisible() then
		updateTransmitForAll(ply, ply:IsInvisible(), ply)
		timer.Simple(0, function()
			if IsValid(ply) then updateTransmitForAll(ply, ply:IsInvisible(), ply) end
		end)
	end
end)

hook.Add('PlayerNoClip', 'dbg-invisible', function(ply, state)
	timer.Simple(0, function()
		local shouldInvisible = not ply:InVehicle() and ply:GetMoveType() == MOVETYPE_NOCLIP or ply.manualInvisibility

		if ply:IsInvisible() ~= shouldInvisible then
			ply:MakeInvisible(shouldInvisible)
		end
	end)
end)

hook.Add('dbg-char.spawn', 'dbg-invisible', meta.MakeInvisible) -- function(ply) ply:MakeInvisible(false) end
hook.Add('PlayerDisconnected', 'dbg-invisible', updateHooks)
