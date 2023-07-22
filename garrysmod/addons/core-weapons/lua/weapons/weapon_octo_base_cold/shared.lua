SWEP.Base							= 'weapon_octo_base'

SWEP.Spawnable						= false
SWEP.AdminSpawnable				= false

SWEP.MuzzleAttachment			= '1'
SWEP.DrawCrosshair				= false
SWEP.ViewModelFOV					= 65
SWEP.ViewModelFlip				= true

SWEP.ViewModelFOV					= 67
SWEP.UseHands						= false

SWEP.ReadyDelay					= 1

SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo					= 'none'

SWEP.Primary.Sound 				= Sound('')
SWEP.Primary.Cone					= 0.2
SWEP.Primary.Recoil				= 10
SWEP.Primary.Damage				= 10
SWEP.Primary.Spread				= .01
SWEP.Primary.NumShots			= 1
SWEP.Primary.RPM					= 60
SWEP.Primary.KickUp				= 0
SWEP.Primary.KickDown			= 0
SWEP.Primary.KickHorizontal	= 0

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo				= 'none'
SWEP.Secondary.IronFOV			= 0

SWEP.ReloadTime 					= 0.5

SWEP.PassiveHoldType 			= 'normal'
SWEP.ActiveHoldType 				= 'melee'
SWEP.CanRunWhenReady				= true
SWEP.TrajectoryType				= 'swing' -- could be also 'point'
SWEP.DeploySound				= nil

SWEP.Damage							= {34, 40}

SWEP.SwingWidth					= 175
SWEP.SwingSegmentAmount			= 35

game.AddAmmoType({
	name = 'blunt',
	dmgtype = DMG_SHOCK,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 1000,
	minsplash = 10,
	maxsplash = 5,
})

game.AddAmmoType({
	name = 'sharp',
	dmgtype = DMG_SONIC,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 1000,
	minsplash = 10,
	maxsplash = 5,
})

function SWEP:PrimaryAttack()

	if not IsFirstTimePredicted() then return end

	local time = CurTime()

	local ok = self:GetNetVar('CanSetReady') and self:GetNetVar('IsReady') and self:GetNextPrimaryFire() <= time and self.Owner:GetNetVar('ScareState', 0) <= 0.6
	if not ok then return end
	self:SetNextPrimaryFire(time + self.HitRate)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if SERVER then
		if self.SwingSound then self.Owner:EmitSound(self.SwingSound) end -- prevent doubling on client
		timer.Create('hitdelay' .. self:EntIndex(), 0.1, 1, function() self:Attack() end)
	end

end

SWEP.Reload = octolib.func.zero
