SWEP.Author			= 'chelog'
SWEP.Contact		= ''
SWEP.Purpose		= ''
SWEP.Instructions	= [[R - вкл/выкл
Колесико - зум
Shift - быстро
Ctrl - медленно
Space - вверх
Alt - вниз]]

SWEP.HoldType		= 'camera'

SWEP.ViewModel		= 'models/weapons/c_arms_animations.mdl'
SWEP.WorldModel		= 'models/tools/camera/camera.mdl'

SWEP.Primary.ClipSize	= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo	= 'none'

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo	= 'none'

local cvSpeed = GetConVar('octocam_speed')
local vector_up = Vector(0, 0, 1)

hook.Add('SetupMove', 'octocamera', function(ply, mv, cmd)
	local wep = ply:GetActiveWeapon()
	if ply:GetMoveType() ~= MOVETYPE_NOCLIP or not IsValid(wep) or wep:GetClass() ~= 'octo_camera' or not wep:GetNetVar('filming') then return end

	local speed = (mv:KeyDown(IN_SPEED) and 0.3 or mv:KeyDown(IN_DUCK) and 0.02 or 0.1) * 5000
	if SERVER then
		speed = speed * ply:GetInfoNum('octocam_speed', 1)
	elseif ply == LocalPlayer() then
		speed = speed * cvSpeed:GetFloat()
	end

	if mv:KeyDown(IN_JUMP) then
		cmd:SetUpMove(10000)
		mv:SetButtons(bit.bxor(mv:GetButtons(), IN_JUMP))
	elseif mv:KeyDown(IN_WALK) then
		cmd:SetUpMove(-10000)
		mv:SetButtons(bit.bxor(mv:GetButtons(), IN_WALK))
	end

	local ang = ply:EyeAngles()
	local moveVector =
		ang:Forward() * cmd:GetForwardMove() +
		ang:Right() * cmd:GetSideMove() +
		vector_up * cmd:GetUpMove()

	mv:SetForwardSpeed(0)
	mv:SetSideSpeed(0)
	mv:SetUpSpeed(0)
	mv:SetOrigin(ply:GetPos() + FrameTime() * moveVector:GetNormalized() * speed)
end)
