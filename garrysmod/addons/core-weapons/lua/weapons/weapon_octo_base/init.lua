AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'
include 'shared.lua'

util.AddNetworkString('octoweapons.sound')
util.AddNetworkString('octoweapons.bend')

-- 1 = left, 2 = right
local function applyBend(ply, doBend)
	local ct = CurTime()
	if ply.bendApplied == doBend or doBend and (ply.nextBend or 0) > ct then return end
	ply.bendApplied = doBend
	if doBend then
		ply.nextBend = ct + 0.75
	end

	local mul = doBend and 1 or 0

	net.Start('octoweapons.bend')
		net.WriteEntity(ply)
		net.WriteInt(mul, 8)
	net.SendPVS(ply:GetPos())

	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) or not wep.CanBend then return end

	timer.Simple(0.32, function()
		for bone, ang in pairs(wep.BendAngles[wep:GetHoldType()] or wep.BendAngles._default) do
			ply:ManipulateBoneAngles(ply:LookupBone(bone), ang * mul)
		end
	end)
end

function SWEP:SetReady(b)

	if not self:GetNetVar('CanSetReady') then return end
	local ply = self.Owner
	if not ply:IsOnGround() then return end

	local newHT = b and self.ActiveHoldType or self.PassiveHoldType
	if IsValid(ply:GetVehicle()) and newHT == 'revolver' then newHT = 'pistol' end
	self:SetHoldType(newHT)
	self:SetNetVar('IsReady', b)

	self.lastOwner = ply
	if not self.CanRunWhenReady then
		ply:MoveModifier('weapon', b and {
			norun = true,
			nojump = true,
		} or nil)
	end

	if b then
		self:SetNextPrimaryFire(CurTime() + (self.ReadyDelay or 60 / self.Primary.RPM))
	else
		applyBend(ply, nil)
	end
end

hook.Add('octolib.canUseAnimation', 'dbg_weapons', function(ply, cat)

	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep:GetNetVar('IsReady') and (cat.stand or cat.freeze) then
		return false
	end

end)

function SWEP:Think()

	local ply = self.Owner
	if ply:KeyDown(IN_ATTACK2) and not self:GetNetVar('IsReady') and not ply:IsUsingTalkie() then
		if ply.octolib_customAnim and ply.octolib_customAnim[1] == 'walk' then
			octolib.stopAnimations(ply)
		end

		if ply.octolib_customAnim or CurTime() < (ply.nextAnim or 0) then
			return
		end

		self:SetReady(true)
	elseif !ply:KeyDown(IN_ATTACK2) and self:GetNetVar('IsReady') then
		self:SetReady(false)
	end

	if self:GetNetVar('IsReady') then
		if ply.bendApplied and ply:GetVelocity():Length2DSqr() > 10 then
			applyBend(ply, nil)
		end

		local _, aim = self:GetShootPosAndDir()
		local trStart = ply:GetShootPos()
		local trEnd = trStart + aim * 400
		local tr = util.TraceLine({
			start = trStart,
			endpos = trEnd,
			filter = function(ent)
				if not ent:IsPlayer() then return true end
				return ent ~= ply and not ent:IsGhost()
			end
		})

		local tgt = tr.Hit and tr.Entity
		if IsValid(tgt) and tgt:IsPlayer() and self.CanScare and tgt:Team() ~= TEAM_ADMIN then
			if ply:isCP() and tgt:isCP() then return end
			local jtOwner, jtTgt = ply:getJobTable(), tgt:getJobTable()
			if jtOwner.orgID and jtOwner.orgID == jtTgt.orgID then return end
			tgt:SetNetVar('ScareState', math.min(tgt:GetNetVar('ScareState', 0) + (FrameTime() / 3) * (self.ScareMultiplier or 1), 1))
			if tgt.lastScare <= 0.6 and tgt:GetNetVar('ScareState', 0) > 0.6 then
				tgt:EmitSound('d1_trainstation.cryingloop')
				tgt:MoveModifier('scare', {
					walkmul = 0.5,
					norun = true,
					nujump = true,
				})
				hook.Run('dbg.scareStart', tgt, ply, self)
			end

			if not self.isScaring then
				hook.Run('dbg.scareInit', tgt, ply, self)
			end
			self.isScaring = true
		else
			self.isScaring = nil
		end

		ply.lastAim = CurTime()
	end

end

function SWEP:Reload()

	if not self:GetNetVar('CanSetReady') then return end
	if self:Clip1() >= self:GetMaxClip1() or self:Ammo1() < 1 then return end

	self:SetNextPrimaryFire(CurTime() + self.ReloadTime)

	self:SetReady(false)
	self:SetHoldType(self.ActiveHoldType) -- just to be sure we do it BEFORE sending animation
	timer.Simple(.2, function()
		self.Weapon:DefaultReload(ACT_VM_RELOAD)
	end)

	self:SetNetVar('CanSetReady', false)
	timer.Simple(self.ReloadTime + .3, function()
		if IsValid(self) then
			self:SetHoldType(self.PassiveHoldType)
			self:SetNetVar('CanSetReady', true)
		end
	end)

end

function SWEP:ResetStats()

	local owner = self.lastOwner or self.Owner
	if IsValid(owner) then
		owner:MoveModifier('weapon', nil)
		applyBend(owner, nil)
	end

end

function SWEP:Holster()

	self:ResetStats()
	return true

end

function SWEP:OnRemove()

	self:ResetStats()

end

function SWEP:OnDrop()

	self:ResetStats()

end

function SWEP:PlaySounds(sounds, filter)
	net.Start('octoweapons.sound', true)
		net.WriteUInt(#sounds, 5)
		net.WriteVector(self:GetPos())
		for _, name in ipairs(sounds) do
			net.WriteString(name)
		end
	if filter then
		net.Send(filter)
	else
		net.SendPVS()
	end
end

net.Receive('octoweapons.bend', function(_, ply)
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep.CanBend and ply:GetVelocity():Length2DSqr() < 10 then
		applyBend(ply, net.ReadBool() or nil)
	end
end)

hook.Add('PlayerSpawn', 'dbg-scare', function(ply)

	ply.lastScare = 0
	ply:StopSound('d1_trainstation.cryingloop')

end)

hook.Add('Think', 'dbg-scare', function(ply)

	for i, ply in ipairs(player.GetAll()) do
		local scare = ply:GetNetVar('ScareState', 0)
		if scare <= ply.lastScare and scare ~= 0 then
			scare = math.max(scare - FrameTime() / 10, 0)
			ply:SetNetVar('ScareState', scare)

			if ply.lastScare > 0.6 and ply:GetNetVar('ScareState', 0) <= 0.6 then
				ply:StopSound('d1_trainstation.cryingloop')
				ply:MoveModifier('scare', nil)
				hook.Run('dbg.scareEnd', ply)
			end
		end
		ply.lastScare = scare
	end

end)

hook.Add('PlayerDisconnected', 'dbg-scare', function(ply)

	if ply:GetNetVar('ScareState', 0) > 0.6 then
		ply:Kill()
		octodeath.triggerDeath(ply)
	end

end)

local disabledCmds = {'/cr', '/sms', '/pm'}

hook.Add('octochat.canExecute', 'dbg-scare', function(ply, cmd)

	if ply:GetNetVar('ScareState', 0) > 0.6 and table.HasValue(disabledCmds, cmd) then
		return false, L.you_scared
	end

end)

hook.Add('closelook.canZoom', 'dbg-weapons', function(ply)
	local weapon = ply:GetActiveWeapon()
	if IsValid(weapon) and weapon.HasZoom and weapon:GetNetVar('IsReady') then
		return true
	end
end)
