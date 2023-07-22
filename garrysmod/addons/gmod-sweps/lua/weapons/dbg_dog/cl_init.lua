include('shared.lua')

SWEP.DrawWorldModel = octolib.func.no
SWEP.DrawWorldModelTranslucent = octolib.func.no
SWEP.PrimaryAttack = octolib.func.zero
SWEP.SecondaryAttack = octolib.func.zero

function SWEP:Think()
	local ct = CurTime()
	if (self.nextThink or 0) > ct then return end
	dbgView.hideHead(true)
	self.nextThink = ct + 3
end
