SWEP.Base						= 'weapon_octo_base_pistol'
SWEP.PrintName = L.speedometer
SWEP.Author = 'chelog'
SWEP.Contact = ''
SWEP.Purpose = ''

SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model('models/weapons/v_crowbar.mdl')
SWEP.WorldModel = Model('models/weapons/w_toolgun.mdl')

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Ammo = 'none'
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = 'none'

SWEP.MuzzlePos = Vector(10, -0.7, 5)
SWEP.MuzzleAng = Angle(-3, -1, 0)

SWEP.Charge = 100
SWEP.CanScare = false
SWEP.IsLethal = false

function SWEP:DoEffect(tr)

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	-- local effectdata = EffectData()
	-- 	effectdata:SetOrigin(tr.HitPos)
	-- 	effectdata:SetStart(self.Owner:GetShootPos())
	-- 	effectdata:SetAttachment(1)
	-- 	effectdata:SetEntity(self)
	-- util.Effect('ToolTracer', effectdata)

end

function SWEP:PrimaryAttack()

	local ct = CurTime()
	if not IsFirstTimePredicted() or not self:CanFire() or
		(self.nextFire or 0) > ct or self:GetNextPrimaryFire() > ct
	then return end

	if self.Charge < 100 then
		if SERVER then
			self.Owner:EmitSound('weapons/clipempty_pistol.wav', 60)
		end

		self.nextFire = ct + 1
		self:SetNextPrimaryFire(self.nextFire)
		return
	end
	self.Charge = 0

	self.Owner:LagCompensation(true)
	local shootPos, shootDir = self:GetShootPosAndDir()
	local tr = util.TraceLine({
		start = shootPos,
		endpos = shootPos + shootDir * 32768,
		filter = self.Owner,
	})
	self.Owner:LagCompensation(false)

	self:DoEffect(tr)

	if SERVER then self:Measure(tr) end

end

function SWEP:Think()

	self.BaseClass.Think(self)
	if SERVER or (CLIENT and IsFirstTimePredicted()) then
		local oldCharge = self.Charge
		self.Charge = math.min(self.Charge + FrameTime() * 20, 100)
		if oldCharge ~= 100 and self.Charge >= 100 then self.Owner:EmitSound('ambient/energy/spark' .. math.random(1,4) .. '.wav', 60, 100, 0.3) end
	end

end

function SWEP:FailAttack()

	self:SetNextSecondaryFire(CurTime() + 0.5)
	self.Owner:EmitSound('Weapon_Pistol.Empty')

end

function SWEP:Reload()

	-- nothing

end

local shoulddisable = {}
shoulddisable[21] = true
shoulddisable[5003] = true
shoulddisable[6001] = true

function SWEP:FireAnimationEvent(pos, ang, event, options)

	if shoulddisable[event] then return true end

end
