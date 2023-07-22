--[[------------------------------------------

	A.P.G. - a lightweight Anti Prop Griefing solution (v2.2.0)
	Made by :
	- While True (http://steamcommunity.com/id/76561197972967270)
	- LuaTenshi (http://steamcommunity.com/id/76561198096713277)

	============================
	 GHOSTING/UNGHOSTING MODULE
	============================

	Developper informations :
	---------------------------------
	Used variables :
		ghost_color = { value = Color(34, 34, 34, 220), desc = "Color set on ghosted props" }
		bad_ents = {
			value = {
				["prop_physics"] = true,
				["wire_"] = false,
				["gmod_"] = false },
			desc = "Entities to ghost/control/secure"}
		alwaysFrozen = { value = false, desc = "Set to true to auto freeze props on physgun drop" }

]]--------------------------------------------
local mod = "ghosting"

local disabledClasses = {
	gmod_sent_vehicle_fphysics_base = true,
	gmod_sent_vehicle_fphysics_wheel = true,
	gmod_sent_vehicle_fphysics_attachment = true,
}

--[[------------------------------------------
		Override base functions
]]--------------------------------------------
local ENT = FindMetaTable( "Entity" )
APG.oSetColGroup = APG.oSetColGroup or ENT.SetCollisionGroup
function ENT:SetCollisionGroup( group )
	if not disabledClasses[self:GetClass()] and APG.isBadEnt( self ) and APG.getOwner( self ) then
		if group == COLLISION_GROUP_NONE then
			if not self.APG_Frozen then
				group = COLLISION_GROUP_INTERACTIVE
			end
--[[		elseif group == COLLISION_GROUP_INTERACTIVE and APG.isTrap( self ) then
			group = COLLISION_GROUP_DEBRIS_TRIGGER --]]
		end
	end
	return APG.oSetColGroup( self, group )
end

local PhysObj = FindMetaTable("PhysObj")
APG.oEnableMotion = APG.oEnableMotion or PhysObj.EnableMotion
function PhysObj:EnableMotion( bool )
	local sent = self:GetEntity()
	if not disabledClasses[sent:GetClass()] and APG.isBadEnt( sent ) and APG.getOwner( sent ) then
		sent.APG_Frozen = not bool
		if not sent.APG_Frozen then
			sent:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
		end
	end
	return APG.oEnableMotion( self, bool)
end

function APG.isTrap( ent, output )
	local check = false
	local center = ent:LocalToWorld(ent:OBBCenter())
	local bRadius = ent:BoundingRadius()
	local cache = {}

	if not IsValid(ent:GetParent()) then
		for _,v in next, ents.FindInSphere(center, bRadius) do
			if (v:IsPlayer() and v:Alive() and not v:IsGhost()) then
				local pos = v:GetPos()
				local trace = { start = pos, endpos = pos, filter = v }
				local tr = util.TraceEntity( trace, v )

				if tr.Entity == ent then
					if output then
						table.insert(cache, v)
					else
						check = v
					end
				end
			elseif v:IsVehicle() then
				-- Check if the distance between the spheres centers is less than the sum of their radius.
				local vCenter = v:LocalToWorld(v:OBBCenter())
				if center:Distance( vCenter ) < v:BoundingRadius() then
					check = v
				end
			end

			if check then break end
		end
	end

	if output then
		return istable(cache) and cache or {}
	end

	return check or false
end

function APG.entGhost( ent, enforce, noCollide )
	if not APG.modules[ mod ] or not APG.isBadEnt( ent ) then return end
	if ent.jailWall or ent.apgIgnore then return end
	if disabledClasses[ent:GetClass()] then return end

	if not ent.APG_Ghosted then
		ent.FPPAntiSpamIsGhosted = nil -- Override FPP Ghosting.

		DropEntityIfHeld(ent)
		ent:ForcePlayerDrop()

		ent.APG_oColGroup = ent:GetCollisionGroup()

		if not enforce then
			-- If and old collision group was set get it.
			if ent.OldCollisionGroup then ent.APG_oColGroup = ent.OldCollisionGroup end -- For FPP
			if ent.DPP_oldCollision then ent.APG_oColGroup = ent.DPP_oldCollision end -- For DPP

			ent.OldCollisionGroup = nil
			ent.DPP_oldCollision = nil
		end

		ent.APG_Ghosted = true

		timer.Simple(0, function()
			if not IsValid(ent) then return end

			if not ent.APG_oldColor then
				ent.APG_oldColor = ent:GetColor()
				if not enforce then
					if ent.OldColor then ent.APG_oldColor = ent.OldColor end -- For FPP
					if ent.__DPPColor then ent.APG_oldColor = ent.__DPPColor end -- For DPP

					ent.OldColor = nil
					ent.__DPPColor = nil
				end
			end

			ent:SetColor( APG.cfg["ghost_color"].value )
			if noCollide then
				ent:SetCollisionGroup( COLLISION_GROUP_WORLD )
			else
				ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
			end
		end)

		-- ent:SetRenderMode(RENDERMODE_TRANSALPHA)
		ent:DrawShadow(false)

		if noCollide then
			ent:SetCollisionGroup( COLLISION_GROUP_WORLD )
		else
			ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
		end
	end
end

function APG.entUnGhost( ent, ply )
	if not APG.modules[ mod ] or not APG.isBadEnt( ent ) then return end
	if ent.APG_HeldBy and #ent.APG_HeldBy > 1 then return end
	if disabledClasses[ent:GetClass()] then return end

	if ent.APG_Ghosted != false and not ent.APG_Picked then
		ent.APG_isTrap = APG.isTrap(ent)
		if not ent.APG_isTrap then
			ent.APG_Ghosted  = false
			ent:DrawShadow(true)
			ent:SetColor( ent.APG_oldColor or Color(255,255,255,255))
			ent.APG_oldColor = false

			local newColGroup = COLLISION_GROUP_INTERACTIVE
			if ent.APG_oColGroup == COLLISION_GROUP_WORLD then
				newColGroup = ent.APG_oColGroup
			elseif ent.APG_Frozen then
				newColGroup = COLLISION_GROUP_NONE
			end
			ent:SetCollisionGroup( newColGroup )
		else
			APG.notify("There is something in this prop!", ply, 1)
			ent:SetCollisionGroup( COLLISION_GROUP_WORLD  )
		end
	end
	ent.APG_Busy = nil
end

function APG.ConstrainApply( ent, callback )
	local constrained = constraint.GetAllConstrainedEntities(ent)
	for _,v in next, constrained do
		if IsValid(v) and v != ent then
			callback( v )
		end
	end
end

--[[------------------------------------------
		Hooks/Timers
]]--------------------------------------------

APG.hookRegister( mod, "PhysgunPickup","APG_makeGhost",function(ply, ent)
	if ent.APG_Busy then return false end
	if not APG.canPhysGun( ent, ply ) then return end
	if not APG.modules[ mod ] or not APG.isBadEnt( ent ) then return end
	if disabledClasses[ent:GetClass()] then return end
	ent.APG_Picked = true

	APG.entGhost(ent, false, true)

	APG.ConstrainApply( ent, function( _ent )
		if not _ent.APG_Frozen then
			_ent.APG_Picked = true
			APG.entGhost( _ent, false, true )
		end
	end) -- Apply ghost to all constrained ents
end)

APG.hookRegister( mod, "PlayerUnfrozeObject", "APG_unFreezeInteract", function (ply, ent, object)
	if not APG.canPhysGun( ent, ply ) then return end
	if not APG.modules[ mod ] or not APG.isBadEnt( ent ) then return end
	if disabledClasses[ent:GetClass()] then return end
	if APG.cfg["alwaysFrozen"].value then return false end -- Do not unfreeze if Always Frozen is enabled !
	if ent:GetCollisionGroup( ) != COLLISION_GROUP_WORLD then
		ent:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	end
end)

APG.dJobRegister( "unghost", 0.1, 50, function( ent )
	if not IsValid( ent ) then return end
	APG.entUnGhost( ent )
end)

APG.hookRegister( mod, "PhysgunDrop", "APG_pGunDropUnghost", function( ply, ent )
	if not APG.modules[ mod ] or not APG.isBadEnt( ent ) then return end
	if disabledClasses[ent:GetClass()] then return end

	local changed = true
	local getallconst = constraint.GetAllConstrainedEntities( ent )
	if getallconst then
		for k,_ent in pairs(getallconst) do
			if _ent.APG_Picked and _ent ~= ent then
				changed = false
			end
		end
	end

	if changed then
		ent.APG_Picked = false

		if APG.cfg["alwaysFrozen"].value then
			APG.freezeIt( ent )
		end
		APG.entUnGhost( ent, ply )
		APG.ConstrainApply( ent, function( _ent )
			_ent.APG_Picked = false
			APG.startDJob( "unghost", _ent )
		end) -- Apply unghost to all constrained ents
	end
end)

local function fixCollision(ent)
	if not IsValid( ent ) then return end
	if disabledClasses[ent:GetClass()] then
		ent:SetCustomCollisionCheck(true)
		ent:CollisionRulesChanged()
		return
	end
	if not APG.modules[ mod ] or not APG.isBadEnt( ent ) then return end

	--timer.Simple(.1, function()
		APG.entGhost( ent, false, true )
	--end)
	ent.APG_Busy = true

	timer.Simple(0, function()
		local owner = APG.getOwner( ent )

		if IsValid( owner ) and owner:IsPlayer() then
			local pObj = ent:GetPhysicsObject()
			if IsValid(pObj) and APG.cfg["alwaysFrozen"].value then
				ent.APG_Frozen = true
				pObj:EnableMotion(false)
			elseif IsValid(pObj) and pObj:IsMoveable() then
				ent.APG_Frozen = false
				ent:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
			end
		end

		APG.startDJob( "unghost", ent )
	end)
end
APG.hookRegister(mod, "PlayerSpawnedEffect", "APG_noColOnCreate", function(_, _, ent) fixCollision(ent) end)
APG.hookRegister(mod, "PlayerSpawnedSENT", "APG_noColOnCreate", function(_, ent) fixCollision(ent) end)
APG.hookRegister(mod, "PlayerSpawnedProp", "APG_noColOnCreate", function(_, _, ent) fixCollision(ent) end)
APG.hookRegister(mod, "PlayerSpawnedProp", "APG_freeze", function(_, _, ent)
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
end)

local BlockedProperties = {"collision", "persist", "editentity", "drive", "ignite", "statue"}
APG.hookRegister(mod, "CanProperty", "APG_canProperty", function(ply, prop, ent)
	local prop = tostring(prop)
	if( table.HasValue(BlockedProperties,prop) and ent.APG_Ghosted ) then
		APG.log("Cannot set "..prop.." properties on ghosted entities!", ply)
		return false
	end
end)

-- Custom Hooks --

APG.hookRegister(mod, "APG.FadingDoorToggle", "APG_FadingDoor", function(ent, isFading)
	if not disabledClasses[ent:GetClass()] and APG.isBadEnt(ent) and APG.cfg["FadingDoorGhosting"].value then
		local ply = APG.getOwner( ent )
		if IsValid(ply) then
			if not isFading then
				local find = APG.isTrap(ent, true)
				for _,v in next, find do
					if v.IsPlayer and v:IsPlayer() then
						local dir = v:GetForward(); dir.z = 0
						v:SetCollisionGroup(COLLISION_GROUP_PUSHAWAY)
						v:SetAbsVelocity((dir * 600) + Vector(0,0,60))
						timer.Simple(1, function()
							v:SetCollisionGroup(COLLISION_GROUP_PLAYER)
						end)
					end
				end
			elseif ent.APG_Ghosted then
				APG.startDJob( "unghost", ent )
			end
		end
	end
end)

--[[------------------------------------------
		Load hooks and timers
]]--------------------------------------------
for k, v in next, APG[mod]["hooks"] do
	hook.Add( v.event, v.identifier, v.func )
end

for k, v in next, APG[mod]["timers"] do
	timer.Create( v.identifier, v.delay, v.repetitions, v.func )
end
