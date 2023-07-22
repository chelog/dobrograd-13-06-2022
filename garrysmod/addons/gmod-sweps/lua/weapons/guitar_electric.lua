if SERVER then
	AddCSLuaFile()
end

SWEP.Base 			= 'octolib_custom'
SWEP.Category		= L.dobrograd
SWEP.PrintName		= 'Гитара - Электронная'
SWEP.Instructions 	= ''
SWEP.Slot			= 1
SWEP.SlotPos		= 9
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.ViewModel		= ''
SWEP.HoldType		= 'slam'
SWEP.Spawnable		= true
SWEP.AdminOnly		= true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ''

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ''

SWEP.WorldModel = 'models/props_phx/misc/fender.mdl'
SWEP.WorldModelAtt = 'anim_attachment_lh'
SWEP.WorldModelPos = Vector(-2.5, -6.6, -9.6)
SWEP.WorldModelAng = Angle(112.5, 44.6, -16.0)
SWEP.WorldModelBones = {
	['ValveBiped.Bip01_R_Clavicle'] = Angle(8.8, 12.5, 27.6),
	['ValveBiped.Bip01_R_UpperArm'] = Angle(11.9, 4.1, -5.5),
	['ValveBiped.Bip01_R_Forearm'] = Angle(-32.1, 8.5, 14.2),
	['ValveBiped.Bip01_R_Hand'] = Angle(-3.4, -56.4, 0.0),
	['ValveBiped.Bip01_L_Clavicle'] = Angle(-17.3, 2.2, 12.8),
	['ValveBiped.Bip01_L_UpperArm'] = Angle(-12.3, -9.8, -55.9),
	['ValveBiped.Bip01_L_Forearm'] = Angle(12.8, -82.2, -26.1),
	['ValveBiped.Bip01_L_Hand'] = Angle(-46.5, -14.6, -52.5),
}

local sounds = {}
for i = 1, 11 do table.insert(sounds, 'weapons/guitar_electric/guitar_' .. i .. '.mp3') end

if SERVER then
function SWEP:StopMusic()
	if self.sound and self.sound:IsPlaying() then self.sound:Stop() end
end
end

function SWEP:PrimaryAttack()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if SERVER then
		self:StopMusic()
		self.sound = CreateSound(self, sounds[math.random(1, 6)])
		self.sound:Play()
	end
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if SERVER then
		self:StopMusic()
		self.sound = CreateSound(self, sounds[math.random(7, 11)])
		self.sound:Play()
	end
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:Reload()
	local ct = CurTime()
	if (self.nextReload or 0) > ct then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if SERVER then self:StopMusic() end
	self.nextReload = ct + 1
end

function SWEP:OnRemove()
	if CLIENT then
		self:RemoveModel()
	else self:StopMusic() end
	return true
end
