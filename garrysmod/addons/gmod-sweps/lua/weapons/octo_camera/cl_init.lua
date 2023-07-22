include 'shared.lua'

SWEP.PrintName			= 'Octo Camera'
SWEP.Slot				= 5
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

-- local matLogo = Material('octoteam/icons/clock.png')

-- local url = 'https://i.imgur.com/hJG1POs.png'
-- local name = url:gsub('.+%/', '')
-- local pathFile = 'imgscreen/' .. name
-- local pathImg = '../data/' .. pathFile

-- http.Fetch(url, function(content)
-- 	file.Write(pathFile, content)
-- 	local matName = pathImg:gsub('%.png', '')
-- 	RunConsoleCommand('mat_reloadmaterial', matName)
-- 	matLogo = Material(pathImg)
-- end)

local cvLerpPos, cvLerpAng, cvLerpFov = GetConVar('octocam_lerp_pos'), GetConVar('octocam_lerp_ang'), GetConVar('octocam_lerp_fov')

function SWEP:ResetVariables()

	local ply = self:GetOwner()
	self.lastPos = ply:GetShootPos()
	self.lastAng = ply:EyeAngles()
	self.lastFov = ply:GetInfoNum('fov_desired', 75)
	self.tgtFov = self.lastFov

end

function SWEP:PrimaryAttack()
	-- nothing
end

function SWEP:SecondaryAttack()
	-- nothing
end

function SWEP:Reload()
	self:ResetVariables()
end

-- local poses = {
-- 	-- { Vector(28, 0, 0), Angle(90, 0, 0) },
-- 	{ Vector(-21.2, 7, 6.1), Angle(90, 90, 0) },
-- 	{ Vector(-21.2, -7.5, 6.1), Angle(90, -90, 0) },
-- }

-- hook.Add('PostDrawTranslucentRenderables', 'octocamera', function()

-- 	local lp = LocalPlayer()
-- 	for _, ply in ipairs(player.GetAll()) do
-- 		local wep = ply:GetActiveWeapon()
-- 		if not IsValid(wep) or wep:GetClass() ~= 'octo_camera' or ply == lp then continue end

-- 		local ent = wep.visEnt
-- 		if not IsValid(ent) then
-- 			ent = ClientsideModel('models/tools/camera/camera.mdl')
-- 			ent:SetModelScale(3, 0)
-- 			-- ent:SetNoDraw(true)
-- 			wep.visEnt = ent
-- 		end

-- 		wep:Lerp()
-- 		ent:SetPos(wep.lastPos)
-- 		ent:SetAngles(wep.lastAng)
-- 		-- ent:DrawModel()

-- 		for _, pose in ipairs(poses) do
-- 			local pos, ang = LocalToWorld(pose[1], pose[2], wep.lastPos, wep.lastAng)
-- 			cam.Start3D2D(pos, ang, 0.12)
-- 				surface.SetMaterial(matLogo)
-- 				surface.SetDrawColor(255,255,255, 255)
-- 				surface.DrawTexturedRect(-64, -64, 128, 128)
-- 			cam.End3D2D()
-- 		end
-- 	end

-- end)

function SWEP:DrawWorldModel()
	-- do not draw WM
end

function SWEP:OnRemove()

	if IsValid(self.visEnt) then
		self.visEnt:Remove()
	end

end

function SWEP:Deploy()
	self:ResetVariables()
end

function SWEP:Holster()

	if IsValid(self.visEnt) then
		self.visEnt:Remove()
	end

	return true

end

function SWEP:Lerp()

	local ct = CurTime()
	if ct <= (self.lerpAfter or 0) then return end

	local ply = self:GetOwner()
	if not self.lastPos then
		self:ResetVariables()
	end

	local ft = FrameTime()
	self.lastPos = LerpVector(ft / cvLerpPos:GetFloat(), self.lastPos, ply:GetShootPos())
	self.lastAng = LerpAngle(ft / cvLerpAng:GetFloat(), self.lastAng, ply:EyeAngles())
	self.lastFov = Lerp(ft / cvLerpFov:GetFloat(), self.lastFov, self.tgtFov)

	self.lerpAfter = ct

end

function SWEP:CalcView()

	if not self:GetNetVar('filming') then return end

	self:Lerp()
	return self.lastPos, self.lastAng, self.lastFov

end

function SWEP:Tick()

	if not self:GetNetVar('filming') then return end

	local cmd = self:GetOwner():GetCurrentCommand()
	local delta = -cmd:GetMouseWheel() * 0.25
	local v = math.min(self.tgtFov + delta, self.tgtFov)
	if v < 20 then delta = delta / (20 / v) end

	self.tgtFov = math.Clamp(self.tgtFov + delta, 1, 120)

end

local show = octolib.array.toKeys {'CHudChat'}
function SWEP:HUDShouldDraw(name)
	if not self:GetNetVar('filming') then return true end
	return show[name]
end
