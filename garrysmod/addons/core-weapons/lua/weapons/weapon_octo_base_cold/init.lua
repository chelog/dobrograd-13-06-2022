AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'
include 'shared.lua'

function SWEP:GenerateSegments(width, amount)

	local segmentWidth = width / amount
	local segments = {}
	for i = 0, amount - 1 do
		local ang = math.rad(i * segmentWidth)
		segments[#segments + 1] = { sin = math.sin(ang), cos = math.cos(ang) }
	end
	self.Segments = segments

end

function SWEP:OnInitialize()

	self:GenerateSegments(self.SwingWidth or 175, self.SwingSegmentAmount or 35)

end

-- calculate the trajectory and fire bullet
local trajectoryTypes = {

	point = function(self)
		local owner = self:GetOwner()
		local pos, aim = owner:GetShootPos(), owner:EyeAngles()
		local tr = util.TraceLine({
			start = pos,
			endpos = pos + (aim:Forward() * self.HitDistance * 1.5),
			filter = function(ent)
				if ent == owner then return false end
				if ent:IsPlayer() and ent:IsGhost() then return false end
				return true
			end,
			mask = MASK_SHOT,
		})
		if tr.Hit then return tr end
	end,
	
	swing = function(self)
		local owner = self:GetOwner()
		local pos, aim = owner:GetShootPos(), owner:EyeAngles()
		for _, seg in ipairs(self.Segments) do
			local from = pos - (aim:Up() * 10)
			local tr = util.TraceLine({
				start = from,
				endpos = from + (aim:Up() * (self.HitDistance * 0.7 * seg.cos)) + (aim:Forward() * (self.HitDistance * 1.5 * seg.sin)) + (aim:Right() * (self.HitInclination * self.HitDistance * seg.cos)),
				filter = self.Owner,
				mask = MASK_SHOT_HULL
			})
			if tr.Hit then return tr end
		end
	end,

}

-- fire bullet
function SWEP:Attack()

	local tr = trajectoryTypes[self.TrajectoryType](self)
	if not tr then return end
	-- if found something then shoot

	local bullet = {}
	bullet.Num	= 1
	bullet.Src	= tr.HitPos + tr.HitNormal
	bullet.Dir	= -tr.HitNormal
	bullet.Spread = Vector(0, 0, 0)
	bullet.Tracer = 0
	bullet.Force  = 10
	bullet.Hullsize = 0
	bullet.Distance = self.HitDistance * 1.5
	bullet.Damage = self.GetDamage and self:GetDamage(tr) or math.random(unpack(self.Damage))
	bullet.AmmoType = self.Primary.Ammo
	self.Owner:FireBullets(bullet)

	local ent = tr.Entity
	if IsValid(ent) and (ent:IsPlayer() or ent:GetClass():find('npc') or ent:GetClass():find('prop_ragdoll')) then
		self:EmitSound(self.HitSoundBody)
		ent:SetVelocity(self.Owner:GetAimVector() * Vector(1,1,0) * self.HitPushback)
	else
		self:EmitSound(self.HitSoundWorld)
	end

	self:OnBulletShot(tr, bullet)

end

function SWEP:OnBulletShot(trace, bullet)
	-- to be overriden
end
