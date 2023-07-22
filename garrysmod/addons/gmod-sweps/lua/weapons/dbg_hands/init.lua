AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

local SwingSound = Sound('WeaponFrag.Throw')
local HitSound = Sound('Flesh.ImpactHard')

SWEP.HitDistance = 48
SWEP.KnockDistSqr = 65 * 65
SWEP.isDragging = false
SWEP.pickedEnt = nil
SWEP.pickedEntOffset = Vector(0,0,0)

-------------------------------------------------
-- MAIN
-------------------------------------------------

local function isCarOwner(ent, ply)

	local owner = ent:CPPIGetOwner()
	return IsValid(owner) and
		(owner == ply or owner.Buddies and owner.Buddies[ply] and table.HasValue(owner.Buddies[ply], true)) and
		not ply:InVehicle() -- to prevent mouse clicks lock/unlock the car

end

function SWEP:lookingAtLockable(ply, ent)

	local eyepos = ply:EyePos()
	if not IsValid(ent) then return false end

	if ent:IsDoor() and not ent:IsBlocked() and eyepos:DistToSqr(ent:GetPos()) < self.KnockDistSqr then
		return true
	end

	if ent.isFadingDoor and ent:GetPos():DistToSqr(eyepos) < self.KnockDistSqr then return true end
	if ent.IsSimfphyscar then return true end

end

function SWEP:lockUnlockAnimation(ply, snd)

	ply:EmitSound('doors/door_latch1.wav')
	ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)

end

function SWEP:doKnock(ply, sound)

	ply:EmitSound(sound, 100, math.random(90, 110))
	ply:DoAnimation(ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST)

end

SWEP.UseDel = CurTime()
function SWEP:DoTrace()

	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + (self.Owner:GetAimVector() * 10000)
	trace.filter = { self.Owner, self.Weapon }
	local tr = util.TraceLine(trace)

	return tr

end

function SWEP:DealDamage()

	if not self.anim then return end

	local owner = self:GetOwner()
	owner:LagCompensation(true)

	local aim = owner:EyeAngles():Forward()
	local tr = util.TraceLine({
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + aim * self.HitDistance,
		filter = owner,
		mask = MASK_SHOT_HULL
	})

	if not IsValid(tr.Entity) then
		tr = util.TraceHull({
			start = owner:GetShootPos(),
			endpos = owner:GetShootPos() + aim * self.HitDistance,
			filter = owner,
			mins = Vector(-10, -10, -8),
			maxs = Vector(10, 10, 8),
			mask = MASK_SHOT_HULL
		})
	end

	if tr.Hit then
		owner:EmitSound(HitSound)
	end

	if (SERVER and IsValid(tr.Entity) and (tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:Health() > 0)) then
		local dmginfo = DamageInfo()

		local attacker = owner
		if not IsValid(attacker) then attacker = self end
		dmginfo:SetAttacker(attacker)

		dmginfo:SetInflictor(self)
		local dmgAmount = math.random(8, 12)
		if tr.Entity:IsPlayer() then dmgAmount = math.Clamp(tr.Entity:Health() - (attacker:HasBuff('Meth') and 0 or 20), 0, dmgAmount) end
		dmginfo:SetDamage(dmgAmount)
		dmginfo:SetDamageType(DMG_CLUB)

		if (self.anim == 'fists_left') then
			dmginfo:SetDamageForce(owner:GetRight() * 4912 + owner:GetForward() * 9998)
		elseif (self.anim == 'fists_right') then
			dmginfo:SetDamageForce(owner:GetRight() * -4912 + owner:GetForward() * 9989)
		end

		tr.Entity:TakeDamageInfo(dmginfo)

		-- if tr.Entity:GetClass() == 'func_breakable_surf' then
		-- 	tr.Entity:Fire('Shatter', Vector(0,0,0))
		--	 owner:TakeDamage(math.random(10, 15), Entity(0), tr.Entity)
		-- end
	end

	if SERVER and IsValid(tr.Entity) then
		local phys = tr.Entity:GetPhysicsObject()
		if (IsValid(phys)) then
			phys:ApplyForceOffset(owner:GetAimVector() * 80 * phys:GetMass(), tr.HitPos)
		end

		local ent = tr.Entity
		local carOwner = ent:CPPIGetOwner()
		if IsValid(carOwner) and ent.IsSimfphyscar and carOwner ~= owner
		and not (carOwner.Buddies and carOwner.Buddies[owner] and table.HasValue(carOwner.Buddies[owner], true))
		and CurTime() - (owner.karmaLast.cardamage or -180) > 180 then
			owner:AddKarma(-1, L.cardamage)
			print('[KARMA] ' .. tostring(owner) .. ' -1 karma for car fists damage')
			owner.karmaLast.cardamage = CurTime()
		end
	end

	owner:LagCompensation(false)

end

function SWEP:PrimaryAttack()

	local owner = self:GetOwner()
	if owner:IsGhost() or owner:IsHandcuffed() then return end

	if self.isFists and self:GetHoldType() == 'fist' then
		local can, why = hook.Run('dbg-hands.canPunch', owner, owner:GetEyeTrace())
		if can == false then
			if why then owner:Notify('warning', why) end
			return
		end
		owner:SetAnimation(PLAYER_ATTACK1)

		self.anim = self.punchRight and 'fists_right' or 'fists_left'
		owner:EmitSound(SwingSound)

		self:SetNextMeleeAttack(CurTime() + 0.2)
		self:SetNextPrimaryFire(CurTime() + 0.9)
		self:SetNextSecondaryFire(CurTime() + 0.9)

		self.punchRight = not self.punchRight
	else
		local ent = owner:GetEyeTrace().Entity

		if not self:lookingAtLockable(owner, ent) or owner:GetNetVar('Ghost') then return end
		self:SetNextPrimaryFire(CurTime() + 0.3)

		if ent:CanBeLockedBy(owner) and CurTime() > (ent.nextLock or 0) then
		owner:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)

		owner:DelayedAction('door_lock', 'Закрытие замка', {
			time = 1.5,
			check = function() return octolib.use.check(owner, ent) end,
			succ = function()
				ent:EmitSound('doors/door_latch1.wav')
				ent:DoLock()
			end,
		})
		elseif ent.IsSimfphyscar then
			if isCarOwner(ent, owner) and CurTime() > (ent.nextLock or 0) then
				ent:Lock()
			end
		else
			self:doKnock(owner, 'physics/wood/wood_crate_impact_hard2.wav')
		end
	end

end

function SWEP:SecondaryAttack()

	local owner = self.Owner
	if owner:IsGhost() or owner:IsHandcuffed() then return end

	local ent = owner:GetEyeTrace().Entity
	if not self:lookingAtLockable(owner, ent) then return end

	self:SetNextSecondaryFire(CurTime() + 0.3)

	if ent:CanBeUnlockedBy(owner) then
		ent:DoUnlock()
		ent:EmitSound('doors/door_latch1.wav')
		owner:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
	elseif ent.IsSimfphyscar then
		if isCarOwner(ent, owner) then
			ent:UnLock()
		end
	else
		self:doKnock(owner, 'physics/wood/wood_crate_impact_hard3.wav')
	end

end

function SWEP:Reload()

	-- do nothing

end

function SWEP:PrimaryAttackPressed()

	if self.isFists then return end

	if self.isDragging then
		self:StopDragging()
		return
	end

	local owner = self:GetOwner()
	local veh = owner:GetVehicle()
	if IsValid(veh) and IsValid(veh:GetParent()) then return end

	local tr = util.TraceLine({
		start = owner:EyePos(),
		endpos = owner:EyePos() + owner:GetAimVector() * 100,
		filter = owner
	})

	local ent = tr.Entity
	if not IsValid(ent) then
		self:SetHoldType('pistol')
		self.isPointing = true
		return
	end

	local can, why = hook.Run('dbg-hands.canDrag', owner, ent, tr)
	if can == false then
		if why then owner:Notify('warning', why) end
		return
	end

	local class = ent:GetClass()
	local ph = class and not self.doNotDrag[class] and ent:GetPhysicsObjectNum(tr.PhysicsBone)
	local should = not ent:IsPlayer() or (not ent:IsGhost() and ent:Crouching() and ent:KeyDown(IN_ATTACK))
	if should and IsValid(ph) and not ent:IsDoor() then
		self.pickedEnt = ent
		if ent.OnHandsPickup then
			ent:OnHandsPickup(owner, self)
		end
		self.pickedEntBone = tr.PhysicsBone
		self.pickedEntOffset = ph:WorldToLocal(tr.HitPos)
		self.isDragging = true
		self.pickedEnt.lastCarrier = owner -- to register killer
		self:SetHoldType(IsValid(veh) and 'pistol' or 'magic')

		if class == 'prop_ragdoll' then
			local name = owner:Name()
			if owner:isCP() then name = name .. L.analyzer_cop end

			ent.criminals = ent.criminals or {}
			if not table.HasValue(ent.criminals, name) then table.insert(ent.criminals, name) end
		end
	else
		self:SetHoldType('pistol')
		self.isPointing = true
	end

end

function SWEP:PrimaryAttackReleased()

	if not self.isPointing then return end

	self:SetHoldType('normal')
	self.isPointing = nil

end

function SWEP:SecondaryAttackPressed()

	self.isFists = true
	self.isPointing = nil

	self:SetHoldType('fist')
	octolib.stopAnimations(self:GetOwner())

end

function SWEP:SecondaryAttackReleased()

	self.isFists = nil

	self:SetHoldType('normal')
	self.anim = nil

end

function SWEP:StopDragging()

	if self.isDragging then
		self.isDragging = false
		self.pickedEnt = nil
		self:SetHoldType('normal')

		netstream.Start(self:GetOwner(), 'dbg_hands.StopDragging')
	end

end

function SWEP:Think()

	local owner = self:GetOwner()
	if owner:IsGhost() then return end

	if self.isDragging then
		local ent = self.pickedEnt
		if not IsValid(ent) then
			self:StopDragging()
			return
		end

		local should = owner:KeyDown(IN_ATTACK) and not owner:KeyDown(IN_ATTACK2) and owner:GetGroundEntity() ~= ent and not ent.APG_Picked
		if ent:IsPlayer() and not (ent:KeyDown(IN_ATTACK) and ent:Crouching() and not ent:IsGhost()) then should = false end
		if ent.IsSimfphyscar and ent:EngineActive() and ent:GetThrottle() > 0.5 then should = false end

		if not should then return self:StopDragging() end

		local ph = ent:GetPhysicsObjectNum(self.pickedEntBone)
		local ph2 = ent:GetPhysicsObject()

		local pos = owner:EyePos() + owner:GetAimVector()*80
		local pos2 = ph:LocalToWorld(self.pickedEntOffset)
		if (pos - pos2):LengthSqr() > 10000 then
			self:StopDragging()
			return
		end

		local force = math.min(100, math.pow(ph2:GetMass(), 0.7) * 4)
		if ent:GetPhysicsObjectCount() > 1 then force = force * 1.5 end
		local vel = (pos - pos2) * force
		if vel.z > 0 and ph:GetVelocity().z < 0 then vel.z = vel.z * 2.5 end

		ph:ApplyForceOffset(vel, pos2)
		ph:ApplyForceCenter(-ph:GetVelocity() * 0.3)
		ph:AddAngleVelocity(-ph:GetAngleVelocity() * 0.3)

		vel.z = vel.z * 0.4
		owner:SetVelocity(-vel * 0.02)
	elseif self.isFists then
		local meleetime = self:GetNextMeleeAttack()
		if meleetime > 0 and CurTime() > meleetime and owner:KeyDown(IN_ATTACK2) then
			if not owner:InVehicle() then
				self:DealDamage()
			end
			self:SetNextMeleeAttack(0)
		end
	end

	self:NextThink(CurTime() + 0.03)
	return true

end

-------------------------------------------------
-- JOB-SPECIFIC
-------------------------------------------------

util.AddNetworkString 'dbg-revive'
net.Receive('dbg-revive', function(len, ply)

	local target = net.ReadEntity()
	if not IsValid(target) or not target:IsPlayer() or not target:IsGhost()
	or ply:IsGhost() or ply:Team() ~= TEAM_PRIEST or target:GetPos():DistToSqr(ply:GetPos()) > 6000 then
		return
	end

	local ghostBuffs = target:GetDBVar('ghostBuffs', 0)
	if ghostBuffs >= 10 then
		ply:Notify('error', 'Священник может помочь грешникам, но всему есть предел!')
		return
	end
	target:SetDBVar('ghostBuffs', ghostBuffs + 1)

	target:SetNetVar('_SpawnTime', math.max((math.min(CurTime() + 5, target:GetNetVar('_SpawnTime', 0))), target:GetNetVar('_SpawnTime', 0) - 30))
	target:EmitSound('dbg/revive.ogg', 70, 100, 0.8)
	local effectdata = EffectData()
	effectdata:SetOrigin(target:GetPos() + Vector(0,0,45))
	effectdata:SetMagnitude(2.5)
	effectdata:SetScale(2)
	effectdata:SetRadius(3)
	util.Effect('GlassImpact', effectdata, true, true)

end)

-------------------------------------------------
-- HOOKS
-------------------------------------------------

function SWEP:CanUseAnimation()

	if self:GetHoldType() ~= 'normal' then
		return false
	end

end

hook.Add('AllowPlayerPickup', 'dbg_hands', function()
	return false
end)
