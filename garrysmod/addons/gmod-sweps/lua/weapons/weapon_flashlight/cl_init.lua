include('shared.lua')

SWEP.Slot = 0
SWEP.SlotPos = 5
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.WeaponIcon = surface.GetTextureID("weapons/weapon_flashlight")
killicon.Add( "weapon_flashlight", "weapons/weapon_flashlight_kill", Color( 255, 80, 0, 255 ) ) 

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)

	surface.SetDrawColor( 255, 240, 0, 255 )
	surface.SetTexture( self.WeaponIcon )
	surface.DrawTexturedRect( x + wide * 0.15, y, wide / 1.5, tall )
	
end

function SWEP:PrimaryAttack()

	-- keep calm and do nothing

end