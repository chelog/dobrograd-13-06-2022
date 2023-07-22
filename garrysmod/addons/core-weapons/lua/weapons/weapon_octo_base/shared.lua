SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false

SWEP.MuzzleAttachment			= '1'
SWEP.DrawCrosshair				= false
SWEP.ViewModelFOV				= 65
SWEP.ViewModelFlip				= true

SWEP.Primary.Sound 				= Sound('')
SWEP.Primary.Cone				= 0.2
SWEP.Primary.Recoil				= 10
SWEP.Primary.Damage				= 10
SWEP.Primary.Spread				= .008
SWEP.Primary.NumShots			= 1
SWEP.Primary.RPM				= 60
SWEP.Primary.ClipSize			= 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 0
SWEP.Primary.KickDown			= 0
SWEP.Primary.KickHorizontal		= 0
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo				= 'none'

SWEP.Secondary.ClipSize			= 0
SWEP.Secondary.DefaultClip		= 0
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo				= 'none'
SWEP.Secondary.IronFOV			= 0

SWEP.ReloadTime 				= 1

SWEP.ViewModel				= 'models/weapons/v_crowbar.mdl'
SWEP.WorldModel				= 'models/weapons/w_crowbar.mdl'

SWEP.PassiveHoldType 			= 'normal'
SWEP.ActiveHoldType 			= 'pistol'

SWEP.IsOctoWeapon = true
SWEP.Icon = 'octoteam/icons/gun_pistol.png'
SWEP.IsLethal = true
SWEP.CanScare = true
SWEP.CanBend = true

SWEP.BendAngles = {
	_default = {
		['ValveBiped.Bip01_Spine'] = Angle(15, 0, 0),
		['ValveBiped.Bip01_Spine1'] = Angle(15, 0, 0),
	},
	ar2 = {
		['ValveBiped.Bip01_Spine'] = Angle(30, 30, 0),
		['ValveBiped.Bip01_Spine1'] = Angle(-15, -15, 15),
	},
	smg = {
		['ValveBiped.Bip01_Spine'] = Angle(30, 30, 0),
		['ValveBiped.Bip01_Spine1'] = Angle(-15, -15, 15),
	},
}

local muzzlePosAngPerHoldtype = {
	_default = { Vector(10, 0.65, 3.5), Angle(-2, 5, 0) },
	revolver = { Vector(8, 0.65, 4), Angle(-2, 5, 0) },
	pistol = { Vector(10, 0.25, 3.5), Angle(-2, 5, 0) },
	ar2 = { Vector(25, -1, 7.5), Angle(-9, 0, 0) },
	smg = { Vector(12, -1, 7.5), Angle(-9, 0, 0) },
	duel = { Vector(9, 1, 3.5), Angle(0, 11, 0) },
}

--[[-------------------------------------------------------------------------
FUNCTIONS
---------------------------------------------------------------------------]]

function SWEP:Initialize()

	self:SetReady(false)
	if SERVER then
		self:SetNetVar('CanSetReady', true)
	end
	self:OnInitialize()

end
SWEP.OnInitialize = octolib.func.zero -- to be overriden

function SWEP:Precache()

	util.PrecacheSound(self.Primary.Sound)
	util.PrecacheModel(self.WorldModel)

end

function SWEP:CanFire()

	if not self:GetNetVar('CanSetReady') or not self:GetNetVar('IsReady') or
		CurTime() < self:GetNextPrimaryFire() or self.Owner:GetNetVar('ScareState', 0) > 0.6
		or self.Owner:WaterLevel() == 3
	then return false end

	local ply = self.Owner
	local t = {}
	t.start = ply:GetShootPos()
	t.endpos = self:GetShootPosAndDir()
	t.filter = ply
	return not util.TraceLine(t).Hit

end

function SWEP:GetShootPosAndDir()

	local ply = self.Owner
	local attID = ply:LookupAttachment('anim_attachment_rh')

	if attID then
		local att = ply:GetAttachment(attID)
		local offPos, offAng = self.MuzzlePos, self.MuzzleAng
		if not offPos then
			if muzzlePosAngPerHoldtype[self.ActiveHoldType] then
				offPos, offAng = unpack(muzzlePosAngPerHoldtype[self.ActiveHoldType])
			else
				offPos, offAng = unpack(muzzlePosAngPerHoldtype._default)
			end
		end

		local pos, ang = LocalToWorld(offPos, offAng, att.Pos, att.Ang)
		return pos, ang:Forward(), ang
	else
		return ply:GetShootPos(), (ply.viewAngs or ply:EyeAngles()):Forward(), ply.viewAngs
	end

end

function SWEP:Equip()

	self:SetReady(false)

end

function SWEP:Deploy()

	self:SetReady(false)
	if SERVER and self.DeploySound then
		self.Owner:EmitSound(self.DeploySound)
	end
	return true

end

function SWEP:PrimaryAttack()

	local ct = CurTime()
	if not IsFirstTimePredicted() or not self:CanFire() or
		(self.nextFire or 0) > ct or self:GetNextPrimaryFire() > ct
	then return end

	if self:Clip1() == 0 then
		self:EmitSound('Weapon_AR2.Empty')
		self.nextFire = ct + 1
		self:SetNextPrimaryFire(self.nextFire)
		return
	end

	local ply = self.Owner

	local up, down, horiz = self.Primary.KickUp, self.Primary.KickDown, self.Primary.KickHorizontal
	local mul = 2
	if ply:Crouching() then mul = mul / 2 end
	if ply:InVehicle() then
		mul = mul * 2 -- to compensate lack of view punch
	else
		mul = mul + ply:GetVelocity():Length() / 80
	end
	local kickDir = Angle(math.Rand(-down, -up) * mul, math.Rand(-horiz, horiz) * mul, 0)

	if CLIENT then
		local ang = ply:EyeAngles()
		ang.p = ang.p + (kickDir.p / 2)
		ang.y = ang.y + (kickDir.y / 2)
		ply:SetEyeAngles(ang)
	-- else
	-- 	ply:ViewPunch(kickDir)
	end

	self.nextFire = ct + 1 / (self.Primary.RPM / 60)
	self:SetNextPrimaryFire(self.nextFire)
	self:TakePrimaryAmmo(1)

	ply:SetAnimation(PLAYER_ATTACK1)
	if CLIENT then
		ply:EmitSound(self.Primary.Sound)
		if self.Primary.DistantSound and StormFox2.Environment.GetOutSideFade() > 0.5 then
			ply:EmitSound(self.Primary.DistantSound)
		end
	else
		local filter = RecipientFilter()
		filter:AddAllPlayers()
		filter:RemovePlayer(ply)

		self:PlaySounds({ self.Primary.Sound, self.Primary.DistantSound }, filter)
	end
	self:ShootEffects()
	if not self.NoMuzzleflash then ply:MuzzleFlash() end

	local damage = self.Primary.Damage
	local spread = self.Primary.Spread
	local numShots = self.Primary.NumShots

	local shootPos, shootDir = self:GetShootPosAndDir()

	if self:CustomFireBullets(shootPos, shootDir) then
		return
	end

	if SERVER then
		local bullet = {}
		bullet.Num 		= numShots
		bullet.Src 		= shootPos
		bullet.Dir 		= shootDir
		bullet.Spread 	= Vector(spread, spread, 0)
		bullet.Tracer	= 3
		bullet.TracerName = TracerName
		bullet.Force	= damage * 0.25
		bullet.Damage	= damage
		bullet.Distance	= self.Primary.Distance
		bullet.Callback = function(attacker, bulletTrace, dmg)
			local ent = bulletTrace.Entity
			if not IsValid(ent) or ent:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' then
				return self:BulletHitCallback(bulletTrace, bullet)
			end

			-- try to trace bullet path through car

			local dir = (bulletTrace.HitPos - bulletTrace.StartPos):GetNormalized()
			local tr = {}
			tr.start = bulletTrace.HitPos - dir * 5
			tr.endpos = bulletTrace.HitPos + dir * 200
			tr.filter = ent
			local cEnt = util.TraceLine(tr).Entity
			if IsValid(cEnt) and cEnt:IsPlayer() then
				if IsValid(cEnt:GetVehicle()) and IsValid(cEnt:GetVehicle():GetParent()) and cEnt:GetVehicle():GetParent().cdBulletproof then
					dmg:SetDamage(0)
					return
				end
				bullet.Src = tr.start
				bullet.Dir = dir
				bullet.Spread = Vector()
				bullet.IgnoreEntity = ent
				bullet.Callback = function(attacker, bulletTrace)
					self:BulletHitCallback(bulletTrace, bullet)
				end
				bullet.Distance = 200
				ply:FireBullets(bullet)
			end
		end
		local seat = ply:GetVehicle()
		if IsValid(seat) and IsValid(seat:GetParent()) then
			bullet.IgnoreEntity = seat:GetParent()
		end
		ply:FireBullets(bullet)
	end

end

function SWEP:SecondaryAttack()

	-- keep calm and do nothing

end

function SWEP:BulletHitCallback(trace, bullet)
	self:PlayImpactEffect(trace)
end

function SWEP:CustomFireBullets(shootPos, shootDir)
	-- to be overridden, return true to disable default behaviour
end

function SWEP:Holster(wep)

	if self.Owner:KeyDown(IN_ATTACK2) then return false end
	return true

end

function SWEP:PlayImpactEffect(trace)
	local data = EffectData()
	data:SetStart(trace.StartPos)
	data:SetOrigin(trace.HitPos)
	data:SetNormal(trace.HitNormal)
	data:SetEntity(trace.Entity)
	data:SetSurfaceProp(trace.SurfaceProps)
	data:SetHitBox(trace.HitBox)
	util.Effect('Impact', data, true, true)
end

hook.Add('PlayerSwitchWeapon', 'dbg-scare', function(ply, oldW, newW)

	if ply:GetNetVar('ScareState', 0) > 0.6 and IsValid(newW) and newW:GetClass() ~= 'weapon_cuffed' then
		return true
	end

end)
