if SERVER then
	AddCSLuaFile()
end

SWEP.Base 			= 'octolib_custom'
SWEP.Category		= 'octoinv'
SWEP.PrintName		= 'Инструмент для сбора'
SWEP.Instructions 	= ''
SWEP.Slot			= 1
SWEP.SlotPos		= 9
SWEP.DrawAmmo		= false
SWEP.ViewModel		= ''
SWEP.Spawnable		= true
SWEP.AdminOnly		= true
SWEP.DrawCrosshair = true
SWEP.HoldType = 'melee2'

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ''

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ''

function SWEP:PrimaryAttack()

	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + (self:GetNetVar('Collector').interval or 1))

	if SERVER then
		timer.Create('collector.tryCollect_' .. self:EntIndex(), self.Collector.delay or 0, 1, function()
			if not IsValid(self) then return end
			self:TryCollect()
		end)
	end

end
