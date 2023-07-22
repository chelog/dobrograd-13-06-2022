AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'
include 'shared.lua'

function SWEP:Initialize()

	self.TypeData = self.Types[self.WorldModel]
	self:SetNetVar('WorldModel', self.WorldModel)

end


function SWEP:Deploy()

	self:SetHoldType(self.HoldType)
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
	octolib.stopAnimations(self:GetOwner())

end

function SWEP:Push()

	local ct = CurTime()
	if ct < (self.nextPush or 0) then return end

	self:SetNextPrimaryFire(ct)
	self:SetNextSecondaryFire(ct)

	local ply = self:GetOwner()
	local tr = {}
	tr.start = ply:GetShootPos()
	tr.endpos = tr.start + ply:GetAimVector() * 100
	tr.filter = { ply, self, self.collider }

	local ent = util.TraceLine(tr).Entity
	if not IsValid(ent) or not ent:IsPlayer() then return end

	local dir = ply:GetAimVector()
	dir:Normalize()
	dir.z = 0.3
	ent:SetVelocity(dir * 700)

	ent:ViewPunch(Angle(math.random(-5, 5), math.random(-5, 5), 0))
	ent:EmitSound('physics/body/body_medium_impact_soft'..math.random(1,7)..'.wav', 45)

	ply:DoAnimation(ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST)
	self.nextPush = ct + 2

end
SWEP.PrimaryAttack = SWEP.Push
SWEP.SecondaryAttack = SWEP.Push

function SWEP:Think()

	local pos, ang, mins, maxs = unpack(self.TypeData)

	local col = self.collider
	if not IsValid(col) then
		col = ents.Create 'collider'
		self.collider = col
		-- col:SetModel(self.WorldModel)
		-- col:SetRenderMode(RENDERMODE_TRANSALPHA)
		-- col:SetColor(0,0,0, 1)
		-- col:SetNoDraw(true)
		-- col:PhysicsInitBox(mins, maxs)
		-- col:SetSolid(SOLID_VPHYSICS)
		col:SetNetVar('weapon', self)
		col:Spawn()
		col:Activate()
		col:Setup('model', self.WorldModel)
		col:SetCustomCollisionCheck(true)
		col:CollisionRulesChanged()
		col:GetPhysicsObject():EnableMotion(false)
		col.OnTakeDamage = function(_, dmg) self:OnTakeDamage(dmg) end
	end

	local ply = self:GetOwner()
	local vel = ply:GetVelocity()

	local att = ply:GetAttachment(ply:LookupAttachment('anim_attachment_rh'))
	local propPos, propAng = LocalToWorld(pos, ang, att.Pos, att.Ang)
	if ply:GetAimVector():Dot(vel) > -0.25 then
		propPos:Add(vel * 0.1)
	end
	col:SetPos(propPos)
	col:SetAngles(propAng)

	self:NextThink(CurTime() + 0.2)

end

function SWEP:OnTakeDamage(dmg)

	if dmg:IsExplosionDamage() then return end

	local ply = self:GetOwner()
	if not ply:Crouching() then
		ply:SetVelocity(dmg:GetDamageForce() / 80)
	else
		ply:SetVelocity(dmg:GetDamageForce() / 200)
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(dmg:GetDamagePosition())
		effectdata:SetNormal(-dmg:GetDamageForce():GetNormalized())
	util.Effect(self.TypeData[3], effectdata)

end

function SWEP:Holster()
	self:RemoveCollider()
	return true
end

function SWEP:RemoveCollider()
	if IsValid(self.collider) then self.collider:Remove() end
end
SWEP.OwnerChanged = SWEP.RemoveCollider
SWEP.OnDrop = SWEP.RemoveCollider
SWEP.OnRemove = SWEP.RemoveCollider

hook.Add('octolib.canUseAnimation', 'dbg_shield', function(ply)

	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep:GetClass() == 'dbg_shield' then
		ply:Notify('warning', 'Ты не можешь это делать с щитом в руках')
		return false
	end

end)

hook.Add('EntityTakeDamage', 'dbg_shield', function(ply, dmg)

	if not ply:IsPlayer() or not dmg:IsExplosionDamage() then return end

	local tr = {}
	tr.start = dmg:GetDamagePosition()
	tr.endpos = ply:GetPos() + ply:OBBCenter()
	-- tr.collisiongroup = COLLISION_GROUP_PLAYER
	tr.filter = dmg:GetInflictor()

	local ent = util.TraceLine(tr).Entity
	if not IsValid(ent) or ent == ply then return end

	local wep = ply:GetActiveWeapon()
	if ent:GetClass() ~= 'collider' or ent:GetNetVar('weapon') ~= wep then return end

	if GAMEMODE.Config.DisallowDrop[wep:GetClass()] or ply:jobHasWeapon(wep:GetClass()) then
		ply:SelectWeapon('dbg_hands')
	else
		ply:dropDRPWeapon(wep)
	end

	return true

end)