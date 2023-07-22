include("shared.lua")

CreateConVar("cl_draw_catmullrom_cameras", "1")

ENT.RenderGroup = RENDERGROUP_BOTH

local SpriteOffset = Vector(0, 0, 32)

local CAMERA_MODEL = Model("models/dav0r/camera.mdl")

local MatLaser  = Material("cable/physbeam")
local MatLaserB = Material("cable/white")
local MatSprite = Material("sprites/physg_glow1")

local color_yellow = Color(255, 255, 0, 100)
local color_red	= Color(255, 0,   0, 100)

local PointColour  = Color(64, 168, 255, 128)

local VectorUp = Vector(1.25, 1.25, 1.25)

local IconMats = {}
IconMats.Node			   = Material("gui/silkicons/camera_link")
IconMats.Controller		 = Material("gui/silkicons/camera")
IconMats.Controller_Playing = Material("gui/silkicons/camera_go")

ENT.KeyTextures = {}

function ENT:Initialize()
	self:InitController()

	self.ShouldDraw	 = 1
	self.ShouldDrawInfo = false

	self.LastDrawCheckTimestamp = 0

	self.ZoomTimestamp = 0
	self.LastGuideBeamRenderTimestamp = 0

	self:FireShootOff()
end
---[[
function ENT:Think()
	if self.NeedCameraGhost then
		if not self.GuideCameraGhost then
			self.GuideCameraGhost = octolib.createDummy(CAMERA_MODEL, RENDERGROUP_OPAQUE)
		end
	end

	if self:GetNetVar("IsMapController") then return end
	if not self:GetNetVar("MasterController", NULL).DoZoom then return end -- Haven't received the controller yet

	if LocalPlayer():GetNetVar("UnderControlCatmullRomCamera") == self:GetNetVar("MasterController", NULL) then
		if not self.WasPlayingFOVHackz then
			self.CatmullRomController:Reset()

			self.WasPlayingFOVHackz = true
		end

		self:RemoveGuideGhost()

		return self:GetNetVar("MasterController", NULL):DoZoom()
	else
		self.WasPlayingFOVHackz = false
	end

	self:TrackEntity(self.Entity:GetNetVar("TrackEnt"), self.Entity:GetNetVar("TrackEntLPos"))

	self.ShouldDrawInfo = (self:GetNetVar("MasterController", NULL):GetNetVar("ControllingPlayer") == LocalPlayer())
	self.ShouldDraw	 = (GetConVarNumber("cl_draw_catmullrom_cameras") == 0) and 0 or 1 -- Like that you can see other player's cameras while you're filming

	if (self.ShouldDraw == 0) then return end
	if not self:GetNetVar("IsMasterController") then return end

	self.Key = self:GetNetVar("NumPadKey")

	if not self.KeyTextures[self.Key] then

	end

	self.Texture = self.Key

	self:GetPointData()

	if #self.CatmullRomController.PointsList >= 4 then
		self.CatmullRomController:CalcEntireSpline()
	else
		self:RemoveGuideGhost()
	end

	self:NextThink(CurTime() + .5)
end
---[[
function ENT:Draw()
	if self:GetNetVar("IsMapController") then return end
	if not self:GetNetVar("MasterController", NULL).RequestGuideBeamDraw then return end -- Haven't received the controller yet

	if self.ShouldDraw == 0 then return end
	if LocalPlayer():GetNetVar("UnderControlCatmullRomCamera") == self:GetNetVar("MasterController", NULL) then return end

	local wep = LocalPlayer():GetActiveWeapon()

	if wep:IsValid() and (wep:GetClass() == "gmod_camera") then return end

	self:DrawGuideBeam()
	self:RequestGuideBeamDraw(self.CLTrackIndex)

	self.Entity:DrawModel()

	return self:Icon()
end

function ENT:DrawTranslucent()
	if self:GetNetVar("IsMapController") then return end
	if not self:GetNetVar("IsMasterController") then return end

	if (not self.ShouldDrawInfo) or (not self.Texture) then return end
	if LocalPlayer():GetNetVar("UnderControlCatmullRomCamera") == self:GetNetVar("MasterController", NULL) then return end

	local wep = LocalPlayer():GetActiveWeapon()

	if wep:IsValid() then
		if wep:GetClass() == "gmod_camera" then return end
	end

	local SPOS = self:GetPos():ToScreen()
	draw.DrawText("" .. self.Texture .. "", "ChatFont", SPOS.x, SPOS.y, Color(255, 0, 0, 255),TEXT_ALIGN_CENTER)

	return self:Icon()
end

function ENT:DoZoom()
	local CTime = CurTime()

	if self.ZoomTimestamp < CTime then
		self.ZoomTimestamp = CTime

		self.CatmullRomController:CalcPerc() -- Can't be done in the parameter call or a side effect doesn't manifest properly
		LocalPlayer().CatmullRomCamsTrackZoom = self.CatmullRomController:CalcZoom()
	end
end

local scrn = 1
local size = 2 * scrn

function ENT:Icon()
	local pos = self:GetPos() + (self:GetRight() * 1.75) + (self:GetForward() * -3.5) + (self:GetUp() * -2)
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(),	 90)
	ang:RotateAroundAxis(ang:Right(),  90)

	cam.Start3D2D(pos, ang, scrn)
		local ok, err = pcall(self.DrawIcon, self)
		if not ok then ErrorNoHalt(err, "\n") end
	cam.End3D2D()
end

function ENT:DrawIcon()
	local CTime = SysTime()
	local alpha = 200 + (math.sin(CTime * 3) * 55)

	surface.SetMaterial(self:GetNetVar("IsMasterController") and IconMats.Controller or IconMats.Node)
	surface.SetDrawColor(255, 255, 255, alpha)
	surface.DrawTexturedRect(0, 0, size, size)

	if self.CurShootOff ~= 0 then
		local perc = (self.CurShootOff - CTime) / .75

		if perc > 0 then
			local size   = size + ((1 - perc) * 2 * size)
			local offset = (1 - perc)

			surface.SetDrawColor(255, 255, 255, perc * 150)
			surface.DrawTexturedRectRotated(1, 1, size, size, 0)
			--surface.DrawTexturedRectRotated(1, 1, size, size, perc * 360 * self.CurShootOffRoll)
		else
			self.CurShootOff = 0

			--timer.Simple(math.random(1, 2.5), self.FireShootOff, self)
		end
	elseif (alpha > 254) and (math.random(1, 2) == 1) then
		self:FireShootOff()
	end
end

function ENT:FireShootOff()
	if not (self and self:IsValid()) then return end

	self.CurShootOffStart = SysTime()
	self.CurShootOff	  = self.CurShootOffStart + .75
	--[[
	if math.random(1, 2) == 1 then
		self.CurShootOffRoll = (math.random(1, 2) == 1) and math.random() or math.random() * -1
	else
		self.CurShootOffRoll = 0
	end
	--]]
end

function ENT:DrawGuideBeam()
	if self:GetNetVar("IsMapController") then return end

	if not self:GetNetVar("IsMasterController") then
		if self:GetNetVar("MasterController", NULL):IsValid() and (LocalPlayer():GetNetVar("UnderControlCatmullRomCamera") ~= self:GetNetVar("MasterController", NULL)) then
			return self:GetNetVar("MasterController", NULL):DrawGuideBeam()
		end

		return
	end

	if #self.CatmullRomController.PointsList < 4 then
		self:RemoveGuideGhost()

		return --print("not enough points.", #self.CatmullRomController.PointsList)
	end

	local CTime = UnPredictedCurTime()

	if self.LastDrawCheckTimestamp > CTime then return end--print("too soon") end

	self.LastDrawCheckTimestamp = CTime

	local size = 35 + math.abs(self.CatmullRomController.Perc - .5) * 100

	local pos, ang = self:GetGuideCamPosAng()

	self.NeedCameraGhost = true

	if self.GuideCameraGhost then

	local VMC1 =  VectorUp * (math.sin(1 - math.abs(self.CatmullRomController.Perc - .5)) * .5 + .6)
	local VMC2 = Matrix()
	VMC2:Scale( VMC1 )
	self.GuideCameraGhost:EnableMatrix( "RenderMultiply", VMC2 )


		self.GuideCameraGhost:SetAngles(ang)
		self.GuideCameraGhost:SetPos(pos)
	end
end

function ENT:RequestGuideBeamDraw(trackindex)
	if not trackindex then return end
	if (not self:GetNetVar("IsMasterController")) then
		if self:GetNetVar("MasterController", NULL).RequestGuideBeamDraw then
			return self:GetNetVar("MasterController", NULL):RequestGuideBeamDraw(trackindex)
		end

		return
	end

	if (trackindex == 1) or (trackindex == self.CatmullRomController.CLEntityListCount) or (self.CatmullRomController.CLEntityListCount == 0) then return end

	local CTime = CurTime()

	--self.LastGuideBeamRenderTimestamp = self.LastGuideBeamRenderTimestamp or 0 -- Had some strange issues with this in MP testing so patch it here
	--self.CatmullRomController.EntityList[trackindex - 1].LastGuideBeamRenderTimestamp = self.CatmullRomController.EntityList[trackindex - 1].LastGuideBeamRenderTimestamp or 0 -- Here too. :/

	local drawbackbeam	= (trackindex > 2) and self.CatmullRomController.EntityList[trackindex - 1] and (self.CatmullRomController.EntityList[trackindex - 1].LastGuideBeamRenderTimestamp < CurTime())
	local drawforwardbeam = (trackindex < self.CatmullRomController.CLEntityListCount - 1) and self.CatmullRomController.EntityList[trackindex] and (self.CatmullRomController.EntityList[trackindex].LastGuideBeamRenderTimestamp < CurTime())

	if drawbackbeam then
		self.CatmullRomController.EntityList[trackindex - 1].LastGuideBeamRenderTimestamp = CTime

		render.SetMaterial(MatLaser)
		render.StartBeam(self.CatmullRomController.STEPS + 2)
			ok, err = pcall(self.RenderSubBeams, self, CTime, (trackindex - 1))
		render.EndBeam()
	end

	if drawforwardbeam then
		self.CatmullRomController.EntityList[trackindex].LastGuideBeamRenderTimestamp = CTime

		render.SetMaterial(MatLaser)
		render.StartBeam(self.CatmullRomController.STEPS + 2)
			ok, err = pcall(self.RenderSubBeams, self, CTime, trackindex)
		render.EndBeam()
	end
end

function ENT:GetGuideCamPosAng(pos1, pos2, pos3, pos4)
	if self:GetNetVar("IsMasterController") then
		self:CalcPerc() -- Can't be done in the parameter call or a side effect doesn't manifest properly

		return self.CatmullRomController:Point(), self.CatmullRomController:Angle()
	end
end

function ENT:RenderBeams()
	local CTime = CurTime()

	render.AddBeam(self.CatmullRomController.PointsList[2], 10, CTime, color_white)

	for i = 1, #self.CatmullRomController.Spline do
		render.AddBeam(self.CatmullRomController.Spline[i], 10, CTime, color_white)
	end
end

function ENT:RenderSubBeams(CTime, trackindex)
	local base = (trackindex - 2) * self.CatmullRomController.STEPS

	render.AddBeam(self.CatmullRomController.PointsList[trackindex], 10, CTime or 1, color_white)
----------------------------------------------------
	for i = 1, self.CatmullRomController.STEPS do
		render.AddBeam(self.CatmullRomController.Spline[base + i], 10, CTime or 1, color_white)
	end

	render.AddBeam(self.CatmullRomController.PointsList[trackindex + 1], 10, CTime or 1, color_white)
end

function ENT:RemoveGuideGhost()
	if self.GuideCameraGhost and self.GuideCameraGhost:IsValid() then
		self.GuideCameraGhost:Remove()

		self.GuideCameraGhost = nil
	end

	--return collectgarbage()
end

function ENT:Lock()
	self.IsLocked = true
end

function ENT:Unlock()
	self.IsLocked = false
end
