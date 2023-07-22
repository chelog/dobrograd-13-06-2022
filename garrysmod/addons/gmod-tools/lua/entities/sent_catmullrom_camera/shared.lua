ENT.Type = "anim"
-- We're the root controller, we'll be handling all the real camera stuff (the interpolation will be clientside, but the server will periodicly move the ViewEntity to update the client's PVS)
ENT.PrintName		= "Cubic Cameras"
ENT.Author			= "Olivier 'LuaPineapple' Hamel"
ENT.Contact			= "evilpineapple@cox.net"
ENT.Purpose			= "For the lulz."
ENT.Instructions	= "Try the GMod Tower servers, but be sure to check out Duke Nukem: Forever first!"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

function ENT:InitController()
	self.CatmullRomController = CatmullRomCams.SH.Controller:New(self)
end

function ENT:TrackEntity(ent, lpos)
	if not (ent and lpos and ent.IsValid and ent:IsValid()) then return end

	self.TrackEnt = ent

	return self:SetAngles(((ent:IsPlayer() and (ent:LocalToWorld(lpos) + Vector(0, 0, 54)) or ent:LocalToWorld(lpos)) - self:GetPos()):Angle())
end

function ENT:Toggle(ply)
	if ply:GetNetVar("UnderControlCatmullRomCamera", NULL) ~= NULL then
		if ply:GetNetVar("UnderControlCatmullRomCamera", NULL) == self then
			self:Off(ply)
		end
	else
		self:On(ply)
	end
end

function ENT:On(ply)
	if SERVER and self:GetNetVar("IsMasterController") and (ply:GetNetVar("UnderControlCatmullRomCamera", NULL) == NULL) then
		print("toggle on: ", ply)

		self:GetPointData()

		if #self.CatmullRomController.PointsList < 4 then
			return print("not enough points: ", #self.CatmullRomController.PointsList)
		end

		ply:SetNetVar("UnderControlCatmullRomCamera", self)

		self:GetPointData()
		--self.CatmullRomController:CalcEntireSpline(self.VecList)

		self.ViewPointEnt = ents.Create("sent_catmullrom_camera_viewpnt")
		self.ViewPointEnt:SetPos(self.CatmullRomController.PointsList[2])
		self.ViewPointEnt:SetAngles(self:GetAngles())
		self.ViewPointEnt:Spawn()

		self.ViewPointEnt.Master			   = self
		self.ViewPointEnt.CatmullRomController = self.CatmullRomController

		self.ViewPointEnt.FaceTravelDir = self.FaceTravelDir
		self.ViewPointEnt.BankOnTurn	= self.BankOnTurn

		self.ViewPointEnt.DeltaBankConstant = self.DeltaBankConstant or 0

		self.ViewPointEnt:SetPlayers(ply)

		self.Playing = true
		self:SetNetVar("IsPlaying", true)

		self.PlyVictim = ply

		self:OnChangeSegment(2)
	end
end

function ENT:Off(ply)
	if self:GetNetVar("IsMasterController") and (ply:GetNetVar("UnderControlCatmullRomCamera", NULL) == self) then
		ply:SetNetVar("UnderControlCatmullRomCamera", NULL)
		print("toggle off: ", ply)
		if self.ViewPointEnt and self.ViewPointEnt:IsValid() then
			self.ViewPointEnt:Remove()
		end

		self.Playing = false
		self:SetNetVar("IsPlaying", false)
	end
end

function ENT:End()
	return self:Off(self.PlyVictim)
end

function ENT:SetPlayer(ply)
	return self:SetNetVar("ControllingPlayer", ply)
end

function ENT:RequestSaveData()
	local tbl = {}

	tbl.Duration = (self:GetNetVar("Duration", 0) > 0) and self:GetNetVar("Duration", 0) or 2

	if self:GetNetVar("IsMasterController") then
		-- ?
	else -- Because there's no point in saving key trigger or map io data, even if there is some, for the controller
		tbl.MapIO		  = self.MapIO
		tbl.KeyTriggerData = self.OnNodeTriggerNumPadKey
	end

	tbl.FaceTravelDir = self.FaceTravelDir

	tbl.EnableRoll = self.EnableRoll
	tbl.Roll	   = self.Roll

	tbl.SmartLookEnabled	  = self.SmartLookEnabled
	tbl.SmartLookRange		= self.SmartLookRange
	tbl.SmartLookPerc		 = self.SmartLookPerc
	tbl.SmartLookTargetFilter = self.SmartLookTargetFilter
	tbl.SmartLookTraceFilter  = self.SmartLookTraceFilter
	tbl.SmartLookClosest	  = self.SmartLookClosest

	tbl.BankOnTurn	 = self.BankOnTurn
	tbl.DeltaBankMax   = self.DeltaBankMax
	tbl.DeltaBankMulti = self.DeltaBankMulti

	tbl.HitchcockEffect = self.HitchcockEffect

	tbl.Zoom = self.Zoom

	tbl.UndoData = self.UndoData

	tbl.ChildCamera = self:GetNetVar("ChildCamera", NULL):IsValid() and self:GetNetVar("ChildCamera", NULL):EntIndex() or nil

	return tbl
end

function ENT:ApplySaveData(ply, plyID, CreatedEntities, CatmullRomCamsDupData)
	if not CreatedEntities.EntityList then return self:Remove() end

	local tbl = CatmullRomCamsDupData

	self:SetPlayer(ply)

	self:SetNetVar("Duration", (tbl.Duration > 0) and tbl.Duration or nil)

	self.FaceTravelDir = tbl.FaceTravelDir

	self.EnableRoll = tbl.EnableRoll
	self.Roll	   = tbl.Roll

	self.SmartLookEnabled	  = tbl.SmartLookEnabled
	self.SmartLookRange		= tbl.SmartLookRange
	self.SmartLookPerc		 = tbl.SmartLookPerc
	self.SmartLookTargetFilter = tbl.SmartLookTargetFilter
	self.SmartLookTraceFilter  = tbl.SmartLookTraceFilter
	self.SmartLookClosest	  = tbl.SmartLookClosest

	self.BankOnTurn	 = tbl.BankOnTurn
	self.DeltaBankMax   = tbl.DeltaBankMax
	self.DeltaBankMulti = tbl.DeltaBankMulti

	self.HitchcockEffect	  = tbl.HitchcockEffect

	self:SetZoom(tbl.Zoom)

	self.UndoData = tbl.UndoData

	CatmullRomCams.Tracks[plyID]					= CatmullRomCams.Tracks[plyID]					or {}
	CatmullRomCams.Tracks[plyID][self.UndoData.Key] = CatmullRomCams.Tracks[plyID][self.UndoData.Key] or {}

	if CatmullRomCams.Tracks[plyID][self.UndoData.Key][self.UndoData.TrackIndex] and CatmullRomCams.Tracks[plyID][self.UndoData.Key][self.UndoData.TrackIndex]:IsValid() then
		CatmullRomCams.Tracks[plyID][self.UndoData.Key][self.UndoData.TrackIndex]:Remove()
		CatmullRomCams.Tracks[plyID][self.UndoData.Key][self.UndoData.TrackIndex] = nil
	end

	CatmullRomCams.Tracks[plyID][self.UndoData.Key][self.UndoData.TrackIndex] = self

	if tbl.UndoData.TrackIndex == 1 then
		self:SetKey(self.UndoData.Key)

		self:SetNetVar("IsMasterController", true)
		self:SetNetVar("ControllingPlayer", ply)

		numpad.OnDown(ply, self.Key, "CatmullRomCamera_Toggle", self)

		for k, v in pairs(CatmullRomCams.Tracks[plyID][self.UndoData.Key]) do
			v:SetNetVar("MasterController", self)

			--print(v, "'s controller set to ", CatmullRomCams.Tracks[plyID][self.UndoData.Key][1])
		end
	else -- Because there's no point in saving key trigger or map io, even if there is some, for the controller
		self.MapIO		  = tbl.MapIO
		self.KeyTriggerData = tbl.OnNodeTriggerNumPadKey

		if CatmullRomCams.Tracks[plyID][self.UndoData.Key][1] and CatmullRomCams.Tracks[plyID][self.UndoData.Key][1]:IsValid() then
			self:SetNetVar("MasterController", CatmullRomCams.Tracks[plyID][self.UndoData.Key][1])

			--print("Set controller to ", CatmullRomCams.Tracks[plyID][self.UndoData.Key][1])
		end
	end

	local child = CreatedEntities[CatmullRomCamsDupData.ChildCamera]

	if (not (child and child:IsValid())) and (not CreatedEntities.EntityList[CatmullRomCamsDupData.ChildCamera]) then
		child = ents.GetByIndex(CatmullRomCamsDupData.ChildCamera)
	end

	if child and child:IsValid() then
		self:DeleteOnRemove(child) -- Because we don't want to have broken chains let's daisy chain them to self destruct

		self:SetNetVar("ChildCamera", child)
	end

	--return self:InitController()
end

function ENT:SetTracking(ent, LPos)
	if ent and ent.IsValid and ent:IsValid() then
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_BBOX)
	else
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
	end

	self:SetNetVar("TrackEntLPos", LPos)
	self:SetNetVar("TrackEnt",	 ent)

	return self:NextThink(CurTime())
end

function ENT:SetBankOnTurn(val)
	self.BankOnTurn = val
end

function ENT:SetBankDeltaMax(val)
	self.DeltaBankMax = val
end

function ENT:SetBankMultiplier(val)
	self.DeltaBankMulti = val
end

function ENT:SetFaceTravelDir(val)
	self.FaceTravelDir = val
end

function ENT:SetKey(key)
	self.Key = key

	self:SetNetVar("NumPadKey", key)
end

function ENT:SetSmartLook(bool)
	self.SmartLookEnabled = bool
end

function ENT:SetSmartLookPerc(val)
	self.SmartLookPerc = math.Clamp(val, .01, 1)
end

function ENT:SetSmartLookRange(val)
	self.SmartLookRange = math.abs(val)
end

function ENT:SetSmartLookTraceFilter(val)
	self.SmartLookTraceFilter = val
end

function ENT:SetSmartLookTargetFilter(val)
	self.SmartLookTargetFilter = val
end

function ENT:SetSmartLookClosest(val)
	self.SmartLookClosest = val
end

function ENT:SetEnableRoll(bool)
	self.EnableRoll = bool
end

function ENT:SetRoll(roll)
	self.Roll = roll
end

function ENT:SetZoom(zoom)
	self.Zoom = zoom

	self:SetNetVar("CamZoom", zoom)
end

function ENT:SetHitchcockEffect(val)
	self.HitchcockEffect = val
end

function ENT:CalcPerc()
	if not self:GetNetVar("IsMasterController") then return end

	return self.CatmullRomController:CalcPerc()
end

function ENT:GetPointData(terminating_entity_marker)
	if not self:GetNetVar("IsMasterController") then return end
	if self:SetNetVar("IsMapController") then return end

	local lastent = self
	local count = 1

	self.CatmullRomController:AddPointAngle(count, lastent:GetPos(), lastent:GetAngles())

	while true do
		count = count + 1

		local ent = lastent:GetNetVar("ChildCamera", NULL)

		if ent == terminating_entity_marker then break end

		if CLIENT then
			lastent.CLTrackIndex = count - 1
		end

		local zoom = lastent:GetNetVar("CamZoom", 0)

		self.CatmullRomController:AddZoomPoint(count, (zoom > 0) and zoom or 75)

		if ent and ent:IsValid() then
			lastent = ent

			local dur = lastent:GetNetVar("Duration", 0)

			self.CatmullRomController:AddPointAngle(count, lastent:GetPos(), lastent:GetAngles(), (dur > 0) and dur or 2)

			if CLIENT then
				lastent.CLTrackIndex = count - 1
			end

			local zoom = lastent:GetNetVar("CamZoom", 0)

			self.CatmullRomController:AddZoomPoint(count, (zoom > 0) and zoom or 75)

			self.CatmullRomController.EntityList[count] = lastent
		else
			break
		end
	end

	if CLIENT then
		self.CatmullRomController.CLEntityListCount = #self.CatmullRomController.EntityList
	end
end

function ENT:ResetController(ent)
	self.CatmullRomController.PointsList	= {}

	self.CatmullRomController.FacingsList   = {}
	self.CatmullRomController.RotationsList = {}

	self.CatmullRomController.DurationList  = {}
	self.CatmullRomController.EntityList	= {}

	self.CatmullRomController.ZoomList	  = {} -- needed serverside as well if there's a hitchcock camera in the track

	if CLIENT then
		self.CatmullRomController.Spline	= {}
	end
end

function ENT:RebuildTrack(ent)
	self:ResetController()

	return self:GetPointData(ent)
end

function ENT:ClearTrack(ent, trackidx, dont_loop_back)
	if trackidx == 1 then return end

	if (not self:GetNetVar("IsMasterController")) then
		if self:GetNetVar("MasterController", NULL):IsValid() then
			return self:GetNetVar("MasterController", NULL):ClearTrack(ent, trackidx, dont_loop_back)
		end

		return
	end
	if !self.CatmullRomController["PointsList"] then self:ResetController(self) end -- This is all I could think of.
	self.CatmullRomController.PointsList[trackidx]	= nil

	self.CatmullRomController.FacingsList[trackidx]   = nil
	self.CatmullRomController.RotationsList[trackidx] = nil

	self.CatmullRomController.DurationList[trackidx]  = nil
	self.CatmullRomController.EntityList[trackidx]	= nil

	self.CatmullRomController.ZoomList[trackidx]  = nil

	if CLIENT then
		self.CatmullRomController.Spline[trackidx]	= nil
	elseif self.Playing then
		self:End()
	end

	if trackidx < 3 then return end

	if dont_loop_back then
		return self:GetNetVar("MasterController", NULL):RebuildTrack(ent)
	else
		return self:ClearTrack(ent, trackidx - 1, true)
	end
end

function ENT:OnRemove()
	local trackidx = -1

	if SERVER then
		if self.ViewPointEnt and self.ViewPointEnt.IsValid and self.ViewPointEnt:IsValid() then
			self.ViewPointEnt:Remove()
		end

		if self.UndoData then
			CatmullRomCams.Tracks[self.UndoData.PID][self.UndoData.Key][self.UndoData.TrackIndex] = nil

			trackidx = self.UndoData.TrackIndex
		end
	else
		self:RemoveGuideGhost()

		if not self.CLTrackIndex then


			if self:GetNetVar("MasterController", NULL) then
				self:GetNetVar("MasterController", NULL):GetPointData()
			end






		end

		trackidx = self.CLTrackIndex
	end

	return self:ClearTrack(self, trackidx)
end
