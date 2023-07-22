AddCSLuaFile("cl_init.lua") 
AddCSLuaFile("shared.lua") 
include("shared.lua")

local CAMERA_MODEL = Model("models/hunter/blocks/cube025x025x025.mdl")

ENT.PhysShadowControl = {}
ENT.PhysShadowControl.secondstoarrive  = .01
ENT.PhysShadowControl.pos			  = Vector(0, 0, 0)
ENT.PhysShadowControl.angle			= Angle(0, 0, 0)
ENT.PhysShadowControl.maxspeed		 = 1000000
ENT.PhysShadowControl.maxangular	   = 1000000
ENT.PhysShadowControl.maxspeeddamp	 = 1000000
ENT.PhysShadowControl.maxangulardamp   = 1000000
ENT.PhysShadowControl.dampfactor	   = 1
ENT.PhysShadowControl.teleportdistance = 0
ENT.PhysShadowControl.deltatime		= deltatime

function ENT:Initialize() 
	self.Entity:SetModel(CAMERA_MODEL)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_NONE)
	self.Entity:SetColor(Color(255,255,255,0))
	self.Entity:DrawShadow(false)
	
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	self.Entity:SetColor(0, 0, 0, 100)
	
	self.Victims = {}
	
	local phys = self:GetPhysicsObject()
	
	if phys and phys:IsValid() then
		phys:Wake()
	end
	
	self.LastYaw = (self:GetAngles().y - 180) / 180
	
	return self:StartMotionController()
end

function ENT:KeyValue(k, v)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:IsValidByFilter(ent, filter)
	if filter == 1 then -- any
		return true
	elseif filter == 2 then -- fire
		return (ent:IsOnFire() or string.find(ent:GetClass(), "_fire"))
	elseif filter == 3 then -- prop
		return (ent:GetClass() == "prop_physics")
	elseif filter == 4 then -- things with physics objects
		return (ent:GetPhysicsObject() and ent:GetPhysicsObject():IsValid())
	elseif filter == 5 then -- npcs
		return ent:IsNPC()
	elseif filter == 6 then -- players
		return ent:IsPlayer()
	elseif filter == 7 then -- light entities
		return (string.find(ent:GetClass(), "light") or (ent:GetClass() == "env_sprite"))
	elseif filter == 8 then -- 'info_particle_system's
		return (ent:GetClass() == "info_particle_system")
	end
end

function ENT:SearchForSmartLookTarget() -- I hate this function
	local selfpos = self:GetPos()
	
	local trace = {}
	local tr = {}
	tr.start = selfpos
	
	local dist = self.CatmullRomController.EntityList[self.CatmullRomController.CurSegment].SmartLookRange + 1337
	local ent
	
	for k, v in pairs(ents.FindInSphere(selfpos, self.CatmullRomController.EntityList[self.CatmullRomController.CurSegment].SmartLookRange)) do
		if (v ~= self) and (v:GetClass() ~= "sent_catmullrom_camera") then
			if self:IsValidByFilter(v, self.CatmullRomController.EntityList[self.CatmullRomController.CurSegment].SmartLookTargetFilter) then
				local vpos  = v:GetPos()
				
				tr.endpos = vpos
				tr.filter = {self.CatmullRomController.EntityList, game.GetWorld( ) }
				tr.mask = (self.CatmullRomController.EntityList[self.CatmullRomController.CurSegment].SmartLookTraceFilter ~= 0) and self.CatmullRomController.EntityList[self.CatmullRomController.CurSegment].SmartLookTraceFilter or nil
				
				trace = util.TraceLine(tr)
				--[[
				print("--")
				print(trace.HitPos)
				print(vpos)
				print(v)
				print(trace.Entity)
				print("--")
				--]]
				-- This handles some really strange case where sometimes two valid entities are superimposing and it always returns the other entity instead or when it would be a clear path but it wouldn't hit the other entity because it was immaterial
				if (trace.HitPos == vpos) or (trace.Entity and trace.Entity:IsValid() and ((trace.Entity == v) or self:IsValidByFilter(trace.Entity, self.CatmullRomController.EntityList[self.CatmullRomController.CurSegment].SmartLookTargetFilter))) then -- GOTCHA!
					local e = (trace.HitPos == vpos) and v or trace.Entity
					
					if not self.CatmullRomController.EntityList[self.CatmullRomController.CurSegment].SmartLookClosest then
						return e
					end
					
					local dist2 = e:Distance(selfpos)
					
					if dist2 < dist then
						ent = e
						
						dist = dist2
					end
				end
			end
		end
	end
	
	return ent
end

function ENT:CalcHitchcockEffect(width, fov)
	return (width / (2 * math.tan(math.pi * (fov / 360))))
end

function ENT:PhysicsSimulate(phys, deltatime)
	--if self.Entity:IsPlayerHolding() then return SIM_NOTHING end
	
	self.CatmullRomController:CalcPerc() -- Can't be done in the parameter call or a side effect doesn't manifest properly
	
	local CurPos  = self:GetPos()
	local CurNode = self.CatmullRomController.EntityList[self.CatmullRomController.CurSegment]
	
	phys:Wake()
	
	if CurNode.HitchcockEffect then
		self.HitchcockEffectEndpoint = self.HitchcockEffectEndpoint or (self.CatmullRomController.PointsList[self.CatmullRomController.CurSegment + 2] - self.CatmullRomController.PointsList[self.CatmullRomController.CurSegment + 1]):GetNormal()
		
		self.PhysShadowControl.pos = self.CatmullRomController.PointsList[self.CatmullRomController.CurSegment] + (self.HitchcockEffectEndpoint * CatmullRomCams.SH.MetersToUnits(self:CalcHitchcockEffect(CurNode.HitchcockEffect, self.CatmullRomController:CalcZoom())))
	else
		self.HitchcockEffectEndpoint = nil
		
		self.PhysShadowControl.pos = self.CatmullRomController:Point()
	end
	
	if CurNode.FaceTravelDir then
		self.PhysShadowControl.angle = self:GetVelocity():Angle()
		
		if CurNode.BankOnTurn then -- :/
			self.LastPos = self.LastPos or CurPos
			
			local NextPosNrml = self:WorldToLocal(self.PhysShadowControl.pos):GetNormal()
			local Multi = (math.abs(NextPosNrml.y) / NextPosNrml.y) * -1
			
			local a = (CurPos - self.LastPos):GetNormal()
			local b = (self.PhysShadowControl.pos - CurPos):GetNormal()
			local dot = math.Clamp((1 - (a:Dot(b) )) * CurNode.DeltaBankMulti * 50, -1, 1) * 90 * CurNode.DeltaBankMax
			
			self.LastPos = CurPos
			
			self.PhysShadowControl.angle.r = dot * 1.0
		end
	else
		self.PhysShadowControl.angle = self.CatmullRomController:Angle()
	end
	
	if CurNode.SmartLookEnabled then
		if not self.SmartLookNodeCount then
			self:GetSmartLookNodeCount()
		end
		
		if not self.HasSmartLookTarget then
			self.HasSmartLookTarget = self:SearchForSmartLookTarget()
		end
		
		if self.HasSmartLookTarget then
			if self:IsOnlyOneSmartNode() then
				self.PhysShadowControl.angle = LerpAngle((1 - math.abs(self.CatmullRomController.Perc - .5)) * CurNode.SmartLookPerc, self.PhysShadowControl.angle, (self.HasSmartLookTarget:GetPos() - CurPos):Angle())
			else
				local perc = self.CatmullRomController.Perc * CurNode.SmartLookPerc
				
				if self:IsFirstSmartNode() then
					self.PhysShadowControl.angle = LerpAngle(perc, self.PhysShadowControl.angle, (self.HasSmartLookTarget:GetPos() - CurPos):Angle())
				elseif self:IsLastSmartNode() then
					self.PhysShadowControl.angle = LerpAngle(perc, (self.HasSmartLookTarget:GetPos() - CurPos):Angle(), self.PhysShadowControl.angle)
				else
					self.PhysShadowControl.angle = LerpAngle(CurNode.SmartLookPerc, self.PhysShadowControl.angle, (self.HasSmartLookTarget:GetPos() - CurPos):Angle())
				end
			end
		else
			--print("no target")
		end
	elseif self.HasSmartLookTarget then
		self.HasSmartLookTarget = nil
	end
	
	self.PhysShadowControl.deltatime = deltatime
	
	return phys:ComputeShadowControl(self.PhysShadowControl)
end

function ENT:IsOnlyOneSmartNode()
	return (self.SmartLookNodeCount == 1)
end

function ENT:IsFirstSmartNode()
	return ((self.CatmullRomController.CurSegment - self.SmartNodeOffset) == 0)
end

function ENT:IsLastSmartNode()
	return (self.CatmullRomController.CurSegment == (self.SmartNodeOffset + self.SmartNodeOffset))
end

function ENT:GetSmartLookNodeCount()
	self.SmartLookNodeCount = 1
	self.SmartNodeOffset	= self.CatmullRomController.CurSegment
	
	while true do
		if not (self.CatmullRomController.EntityList[self.CatmullRomController.CurSegment + self.SmartLookNodeCount] and self.CatmullRomController.EntityList[self.CatmullRomController.CurSegment + self.SmartLookNodeCount].SmartLookEnabled) then
			break
		end
		
		self.SmartLookNodeCount = self.SmartLookNodeCount + 1
	end
end

function ENT:SetPlayers(players)
	if players.IsPlayer then -- Single player
		self.Victims[1] = players
	else
		self.Victims = players
	end
	
	for _, v in pairs(self.Victims) do
		if v.IsValid and v:IsValid() and v.SetViewEntity then
			v:SetViewEntity(self.Entity)
		end
	end
end

-- The following line checks to see if we have an active player(s) and if we do then we release him/her/it/shi
function ENT:OnRemove()
	self.CatmullRomController.CurSegmentTimestamp = 0
	self.CatmullRomController.CurSegment = 2
	
	for _, v in pairs(self.Victims) do
		if v.IsValid and v:IsValid() and v.SetViewEntity then
			v:SetViewEntity(v)
		end
	end
end
