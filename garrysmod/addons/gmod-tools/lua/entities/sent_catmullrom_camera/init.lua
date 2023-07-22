AddCSLuaFile("cl_init.lua") 
AddCSLuaFile("shared.lua") 
include("shared.lua")

local CAMERA_MODEL = Model("models/dav0r/camera.mdl")

ENT.KeyTriggerInformation = {}

function ENT:Initialize() 
	self.Entity:SetModel(CAMERA_MODEL)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	self.Entity:DrawShadow(false)
	
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)

	local phys = self.Entity:GetPhysicsObject()

	if phys:IsValid() then
		phys:Sleep()
	end
	
	if not self.CatmullRomController then
		return self:InitController()
	end
end

function ENT:Think()
	if self.IsMapController then return end
	
	self:TrackEntity(self.Entity:GetNetVar("TrackEnt"), self.Entity:GetNetVar("TrackEntLPos"))
	
	if self:GetNetVar("IsMasterController") then
		if self.Playing and self.ViewPointEnt then
			self:GetPointData()
			
			if #self.CatmullRomController.PointsList < 4 then
				self.ViewPointEnt:Remove()
				
				self.Playing = false
				self:SetNetVar("IsPlaying", false)
			end
		end
	end
	
	self.Entity:NextThink(CurTime())
end

function ENT:OnChangeSegment(segment)
	local ent = CatmullRomCams.Tracks[self.UndoData.PID][self.UndoData.Key][segment]
	
	if ent and ent:IsValid() and ent.OnNodeTriggerNumPadKey then
		local ply	= self:GetNetVar("ControllingPlayer")
		
		self:InternalQuickToggleNumpad(ent.OnNodeTriggerNumPadKey.Keys, ply, ply:UniqueID())
		
		if not ent.OnNodeTriggerNumPadKey.Hold then
			return timer.Simple(.25, self.InternalQuickToggleNumpad, self, ent.OnNodeTriggerNumPadKey.Keys, ply, ply:UniqueID())
		end
	end
end

function ENT:InternalQuickToggleNumpad(keys, ply, plyid)
	for _, key in pairs(keys) do
		if self.KeyTriggerInformation[key] then
			numpad.Deactivate(ply, nil, {key}, plyid) -- Stupid numpad lib needs this as a table ):<
		else
			numpad.Activate(ply, nil, {key}, plyid)
		end
		
		self.KeyTriggerInformation[key] = not self.KeyTriggerInformation[key]
	end
end

function ENT:PhysicsUpdate(physobj)
	if not self.Entity:IsPlayerHolding() then
		if self.IsMapController then
			physobj:EnableMotion(false)
		else
			physobj:Sleep()
		end
	end
end

function ENT:LoadForMap(filename)
	filename = filename or ""
	
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	
	self.IsMapController = true
	self:SetNetVar("IsMapController", true)
	
	if not CatmullRomCams then
		include("autorun/sh_CatmullRomCams")
	end
	
	self:InitController()
	
	local data = file.Read("CatmullRomCameraTracks/" .. filename .. ".txt")
	
	if not data then return Error("Could not load filename track '" .. filename .. "' from disk! " .. tostring(self) .. " map controller will not work!!!\n") end
	
	data = util.KeyValuesToTable(data)
	
	for k, v in ipairs(data) do
	end
	
	local lastent = self
	local count = 1
	
	self.CatmullRomController.PointsList = {}
	self.CatmullRomController.AnglesList = {}
	
	self.CatmullRomController.DurationList = {}
	
	self.CatmullRomController.Spline = {}
	
	self.CatmullRomController:AddPointAngle(count, lastent:GetPos(), lastent:GetAngles())
	
	while true do
		count = count + 1
		
		local ent = lastent:GetNetVar("ChildCamera")
		
		if ent and ent:IsValid() then
			lastent = ent
			
			local dur = lastent:GetNetVar("Duration")
			
			self.CatmullRomController:AddPointAngle(count, lastent:GetPos(), lastent:GetAngles(), (dur > 0) and dur or 2)
			
			self.CatmullRomController.EntityList[count] = lastent
		else
			break
		end
	end
end

function ENT:KeyValue(k, v)
	if k == "TrackFilename" then
		return self:LoadForMap(v)
	end
end

function ENT:PreEntityCopy() -- build the DupeInfo table and save it as an entity mod
	return duplicator.StoreEntityModifier(self.Entity, "CatmullRomCamsDupData", self:RequestSaveData())
end

function ENT:PostEntityPaste(Player, Ent, CreatedEntities)
	local plyID = Player:UniqueID()
	
	if Ent.EntityMods and Ent.EntityMods.CatmullRomCamsDupData then
		--[[
		if not CatmullRomCams.Tracks[plyID][Ent.EntityMods.CatmullRomCamsDupData.UndoData.Key].IsLockedForLoad then  -- hackz
			for k, v in pairs(CatmullRomCams.Tracks[plyID][Ent.EntityMods.CatmullRomCamsDupData.UndoData.Key]) do
				if v and v:IsValid() then
					v:Remove()
				end
			end
			
			CatmullRomCams.Tracks[plyID][Ent.EntityMods.CatmullRomCamsDupData.UndoData.Key] = {}
			CatmullRomCams.Tracks[plyID][Ent.EntityMods.CatmullRomCamsDupData.UndoData.Key].IsLockedForLoad = true
		end
		--]]
		return CatmullRomCams.SV.AdvDupPaste(self, Player, plyID, Ent, CreatedEntities)
	else
		self:Remove()
	end
end

function ENT:BuildDupeInfo()
end

function ENT:ApplyDupeInfo(ply, ent, data, CreatedEntities)
end

function ENT.AfterPasteMods(ply, Ent, DupeInfo) -- Happens before PostEntityPaste for some reason <_<
end
duplicator.RegisterEntityModifier("CatmullRomCamsDupData", ENT.AfterPasteMods)
