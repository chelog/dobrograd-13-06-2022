if SERVER then
	AddCSLuaFile()
end

SWEP.Base 			= 'weapon_base'
SWEP.Category		= L.dobrograd
SWEP.PrintName		= 'Пушка-наказушка'
SWEP.Instructions 	= 'ЛКМ - кикнуть игрока\nПКМ - выдать мут игроку\nR - скопировать SteamID игрока'
SWEP.Slot			= 4
SWEP.SlotPos		= 10
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.ViewModelFlip	= false
SWEP.ViewModelFOV	= 62
SWEP.ViewModel		= 'models/weapons/v_rpg.mdl'
SWEP.WorldModel		= 'models/weapons/w_rocket_launcher.mdl'
SWEP.HoldType		= 'normal'
SWEP.UseHands	   = true
SWEP.AutoSwitchTo	= false
SWEP.AutoSwitchFrom	= false
SWEP.Spawnable		= true
SWEP.AdminOnly		= true
SWEP.Author			= 'Wani4ka'
SWEP.Contact		= '4wk@wani4ka.ru'
SWEP.Purpose		= 'Оперативное устранение игроков, нарушающих атмосферу на ивентах'
SWEP.UseHands		= true
SWEP.Icon			= octolib.icons.color('gun_rpg')

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ''

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ''

function SWEP:Initialize()

	self:DrawShadow(false)
	self:SetHoldType('normal')

end

function SWEP:Holster()
	return true
end

function SWEP:Deploy()
	local owner = self.Owner
	if not (IsValid(owner) and (owner:query('Kick') or owner:query('Mute') or owner:query('Gag'))) then
		if IsValid(owner) then owner:ConCommand('lastinv') end
		return self:Remove()
	end
	self:SetNextPrimaryFire(CurTime() + 0.5)
	self:SetNextSecondaryFire(CurTime() + 0.5)
end
