include 'shared.lua'

SWEP.Slot = 5
SWEP.SlotPos = 19
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

function SWEP:Holster()

	return true

end

function SWEP:Deploy()

	return true

end

function SWEP:OnRemove()

	self:Holster()

end

function SWEP:OnDrop()

	self:Holster()
	
end
