SWEP.Base				= 'octolib_custom'
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.Category			= L.dobrograd
SWEP.PrintName			= 'Гранатомет'
SWEP.ViewModel			= ''
SWEP.Author			 = ''
SWEP.Instructions		= ''
SWEP.HoldType			= 'smg'
SWEP.DrawCrosshair		= true
SWEP.HasFlashlight		= true

SWEP.Icon = 'octoteam/icons/grenade_launcher.png'

SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic			= false
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

SWEP.WorldModel = 'models/saraphines/eft/eft_fn_gl40.mdl'
SWEP.WorldModelAtt = 'anim_attachment_rh'
SWEP.WorldModelPos = Vector(4, -1, 5.5)
SWEP.WorldModelAng = Angle(-12, 0, 0)
SWEP.WorldModelSkin = 1
SWEP.WorldModelBodyGroups = {
	[1] = 1,
	[7] = 1,
	[9] = 1,
}

SWEP.ChargeTypes = {
	frag = {
		name = 'Осколочный снаряд',
		icon = 'grenade_frag',
		max = 5,
		class = 'ent_dbg_grenade_frag',
		bodygroup = 0,
		delay = 2,
	},
	smoke = {
		name = 'Дымовой снаряд',
		icon = 'grenade_smoke',
		max = 5,
		class = 'ent_dbg_grenade_smoke',
		bodygroup = 2,
		delay = 2,
	},
	stun = {
		name = 'Светошумовой снаряд',
		icon = 'grenade_flash',
		max = 5,
		class = 'ent_dbg_grenade_stun',
		bodygroup = 4,
		delay = 1,
	},
	shock = {
		name = 'Шоковый снаряд',
		icon = 'grenade_shock',
		max = 5,
		class = 'ent_dbg_grenade_shock',
		bodygroup = 6,
		delay = 2,
	},
	gas = {
		name = 'Газовый снаряд',
		icon = 'grenade_gas',
		max = 5,
		class = 'ent_dbg_grenade_gas',
		bodygroup = 10,
		delay = 2,
	},
}

function SWEP:PrimaryAttack()
	if not IsValid(self:GetOwner()) then return end

	local ct = CurTime()
	if not IsFirstTimePredicted() or
		(self.nextFire or 0) > ct or self:GetNextPrimaryFire() > ct or (self.nextRecharge or 0) > ct
	then return end

	local charge = self:GetNetVar('charge')
	if not (charge and self.ChargeTypes[charge]) then
		self:EmitSound('Weapon_AR2.Empty')
		self.nextFire = ct + 1
		self:SetNextPrimaryFire(self.nextFire)
		return
	end

	if SERVER then
		self:GetOwner():EmitSound('grenade_launcher/grenade_launcher_shot.wav')
		local cfg = self.ChargeTypes[charge]
		local proj = ents.Create(cfg.class)
		proj:SetModel('models/saraphines/eft/eft_fn_gl40_grenade.mdl')
		proj.Model = 'models/saraphines/eft/eft_fn_gl40_grenade.mdl'
		proj.charge = cfg
		self:Shoot(proj, 2)
		proj:SetBodygroup(0, cfg.bodygroup or 0)
		self:SetNetVar('charge', nil)
		self:SetNetVar('chargeDelayed', nil)
	end

	self.nextFire = ct + 1
	self:SetNextPrimaryFire(ct + 1)

end

function SWEP:SecondaryAttack()

	-- nothing

end
