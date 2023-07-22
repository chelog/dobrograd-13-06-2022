TOOL.Category = "Particle Controller"
TOOL.Name = "Adv. Particle Control"
TOOL.Command = nil
TOOL.ConfigName = "" 

TOOL.HighlightedEnt = nil
 
TOOL.ClientConVar[ "effectname" ] = "env_fire_large"
TOOL.ClientConVar[ "mode_beam" ] = "0"
TOOL.beamattach1 = 0
TOOL.beamattach2 = 0
TOOL.ClientConVar[ "utileffect_scale" ] = "1"
TOOL.ClientConVar[ "utileffect_magnitude" ] = "1"
TOOL.ClientConVar[ "utileffect_radius" ] = "10"
TOOL.ClientConVar[ "color_enabled" ] = "0"
TOOL.ClientConVar[ "color_r" ] = "255"
TOOL.ClientConVar[ "color_g" ] = "20"
TOOL.ClientConVar[ "color_b" ] = "0"
TOOL.ClientConVar[ "color_outofone" ] = "0"

TOOL.ClientConVar[ "attachnum" ] = "0"
TOOL.ClientConVar[ "repeatrate" ] = "0"
TOOL.ClientConVar[ "repeatsafety" ] = "1"

TOOL.ClientConVar[ "propmodel" ] = "models/hunter/plates/plate.mdl"
TOOL.ClientConVar[ "propangle" ] = "1"
TOOL.ClientConVar[ "propinvis" ] = "0"

TOOL.ClientConVar[ "numpadkey" ] = "52"
TOOL.ClientConVar[ "toggle" ] = "1"
TOOL.ClientConVar[ "starton" ] = "1"

TOOL.Information = {
	{ name = "info1", stage = 1, icon = "gui/info.png" },
	{ name = "left0", stage = 0, icon = "gui/lmb.png" },
	{ name = "left1", stage = 1, icon = "gui/lmb.png" },
	{ name = "middle01", icon = "gui/mmb.png" },
	{ name = "right0", stage = 0, icon = "gui/rmb.png" },
	{ name = "right1", stage = 1, icon = "gui/rmb.png" },
	{ name = "reload0", stage = 0, icon = "gui/r.png" },
	{ name = "reload1", stage = 1, icon = "gui/r.png" },
}

if ( CLIENT ) then
	language.Add( "tool.particlecontrol.name", "Advanced Particle Controller" )
	language.Add( "tool.particlecontrol.desc", "Attach particle effects to things" )
	language.Add( "tool.particlecontrol.help", "Particles are used for all sorts of different special effects. You can attach them to models and turn them on and off with a key." )

	language.Add( "tool.particlecontrol.info1", "BEAM EFFECT: Attaches to two points" )
	language.Add( "tool.particlecontrol.left0", "Add an effect to an object" )
	language.Add( "tool.particlecontrol.left1", "Add the other end to an object" )
	language.Add( "tool.particlecontrol.middle01", "Scroll through an object's attachments" )
	language.Add( "tool.particlecontrol.right0", "Attach a new prop with the effect on it" )
	language.Add( "tool.particlecontrol.right1", "Attach a new prop and add the other end to it" )
	language.Add( "tool.particlecontrol.reload0", "Remove all effects from an object" )
	language.Add( "tool.particlecontrol.reload1", "Cancel beam effect" )
end

util.PrecacheSound("weapons/pistol/pistol_empty.wav")




function TOOL:LeftClick( trace )

	local effectname = self:GetClientInfo( "effectname", 0 )
	local attachnum = self:GetClientNumber( "attachnum", 0 )

	local repeatrate = self:GetClientNumber( "repeatrate", 0 )
	local repeatsafety = self:GetClientNumber( "repeatsafety", 0 )

	local numpadkey = self:GetClientNumber( "numpadkey", 0 )
	local toggle = self:GetClientNumber( "toggle", 0 )
	local starton = self:GetClientNumber( "starton", 0 )

	local utileffectinfo = Vector( self:GetClientNumber( "utileffect_scale", 0 ), self:GetClientNumber( "utileffect_magnitude", 0 ), self:GetClientNumber( "utileffect_radius", 0 ) )
	local colorinfo = nil
	if self:GetClientNumber( "color_enabled", 0 ) == 1 then
		if self:GetClientNumber( "color_outofone", 0 ) == 1 then
			colorinfo = Color( self:GetClientNumber( "color_r", 0 ), self:GetClientNumber( "color_g", 0 ), self:GetClientNumber( "color_b", 0 ), 1 )  //we're using the alpha value to store color_outofone
		else
			colorinfo = Color( self:GetClientNumber( "color_r", 0 ), self:GetClientNumber( "color_g", 0 ), self:GetClientNumber( "color_b", 0 ), 0 )
		end
	end

	local ply = self:GetOwner()



	if self:GetClientNumber( "mode_beam", 0 ) == 0 then
		//Not a beam, attach the effect to one entity
		if ( trace.Entity:IsValid() ) then
			if CLIENT then return true end
			if trace.Entity:GetClass() == "prop_effect" and trace.Entity.AttachedEntity then trace.Entity = trace.Entity.AttachedEntity end
			AttachParticleControllerNormal( ply, trace.Entity, { NewTable = { 
				EffectName = effectname, 
				AttachNum = attachnum, 

				RepeatRate = repeatrate, 
				RepeatSafety = repeatsafety, 

				Toggle = toggle, 
				StartOn = starton, 
				NumpadKey = numpadkey, 

				UtilEffectInfo = utileffectinfo, 
				ColorInfo = colorinfo 
			} } )
			return true
		end
	else
		//It's a beam, attach the effect between two entities
		local iNum = self:NumObjects()

		if ( trace.Entity:IsValid() ) then
			//if CLIENT then return true end
			if trace.Entity:GetClass() == "prop_effect" and trace.Entity.AttachedEntity then trace.Entity = trace.Entity.AttachedEntity end

			self:SetObject( iNum + 1, trace.Entity, trace.HitPos, nil, nil, trace.HitNormal )
			if iNum == 0 then
				self.beamattach1 = attachnum
			else
				self.beamattach2 = attachnum
			end

			if ( iNum > 0 ) then
				if ( CLIENT ) then
					self:ClearObjects()
					return true
				end
				
				local Ent1, Ent2 = self:GetEnt(1), self:GetEnt(2)
				local constraint = constraint.AttachParticleControllerBeam( Ent1, Ent2, { 
					EffectName = effectname, 
					AttachNum = self.beamattach1, 
					AttachNum2 = self.beamattach2, 

					RepeatRate = repeatrate, 
					RepeatSafety = repeatsafety, 

					Toggle = toggle, 
					StartOn = starton, 
					NumpadKey = numpadkey, 

					UtilEffectInfo = utileffectinfo, 
					ColorInfo = colorinfo 
				}, ply )	
		
				self:ClearObjects()
			else
				self:SetStage( iNum+1 )
			end

			return true
		end
	end

end




function TOOL:RightClick( trace )

	local effectname = self:GetClientInfo( "effectname", 0 )
	local attachnum  = self:GetClientNumber( "attachnum", 0 )

	local repeatrate  = self:GetClientNumber( "repeatrate", 0 )
	local repeatsafety  = self:GetClientNumber( "repeatsafety", 0 )

	local numpadkey  = self:GetClientNumber( "numpadkey", 0 )
	local toggle  = self:GetClientNumber( "toggle", 0 )
	local starton  = self:GetClientNumber( "starton", 0 )

	local utileffectinfo = Vector( self:GetClientNumber( "utileffect_scale", 0 ), self:GetClientNumber( "utileffect_magnitude", 0 ), self:GetClientNumber( "utileffect_radius", 0 ) )
	local colorinfo = nil
	if self:GetClientNumber( "color_enabled", 0 ) == 1 then
		if self:GetClientNumber( "color_outofone", 0 ) == 1 then
			colorinfo = Color( self:GetClientNumber( "color_r", 0 ), self:GetClientNumber( "color_g", 0 ), self:GetClientNumber( "color_b", 0 ), 1 )  //we're using the alpha value to store color_outofone
		else
			colorinfo = Color( self:GetClientNumber( "color_r", 0 ), self:GetClientNumber( "color_g", 0 ), self:GetClientNumber( "color_b", 0 ), 0 )
		end
	end

	local ply = self:GetOwner()



	local propmodel = self:GetClientInfo( "propmodel", 0 )
	local propangle = self:GetClientNumber( "propangle", 0 )
	//propangle 1: spawn upright
	//propangle 2: spawn at surface angle

	if !util.IsValidModel(propmodel) then return false end
	if !util.IsValidProp(propmodel) then return false end
	if CLIENT then return true end

	prop = ents.Create( "prop_physics" )
		prop:SetModel( propmodel )
		prop:SetPos( trace.HitPos - trace.HitNormal * prop:OBBMins().z )
		if propangle == 1 then prop:SetAngles(Angle(0,trace.HitNormal:Angle().y,0)) else prop:SetAngles(trace.HitNormal:Angle()) end
		prop:SetCollisionGroup(20) //COLLISION_GROUP_NONE, nocollide with everything except world
	prop:Spawn()

	local shouldweweld = true										//don't weld if...
	if ( !util.IsValidPhysicsObject(prop, 0) ) then shouldweweld = false end				//the prop doesn't have a phys object
	if ( !trace.Entity:IsValid() ) then shouldweweld = false end						//the thing we clicked on doesn't exist/is the world
	if ( trace.Entity && trace.Entity:IsPlayer() ) then shouldweweld = false end				//the thing we clicked on is a player
	if ( !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then shouldweweld = false end  //the thing we clicked on doesn't have a phys object
	if shouldweweld == true then
		local const = constraint.Weld( prop, trace.Entity, 0, trace.PhysicsBone, 0, true, true )
	else
		if util.IsValidPhysicsObject(prop, 0) then prop:GetPhysicsObject():EnableMotion(false) end
	end

	if self:GetClientNumber( "propinvis", 0 ) == 1 then
		prop:SetRenderMode(1)  //we need to change the render mode so the transparency actually shows up
		prop:SetColor( Color(255,255,255,0) )
		duplicator.StoreEntityModifier( prop, "colour", { Color = Color(255,255,255,0), RenderMode = 1, RenderFX = 0 } )
	end

	undo.Create( "prop" )
		undo.AddEntity( prop )
		undo.SetPlayer( ply )
	undo.Finish( "Prop ("..tostring(propmodel)..")" )



	if ( !prop:IsValid() ) then return false end
	if self:GetClientNumber( "mode_beam", 0 ) == 0 then
		//Not a beam, attach the effect to one entity.
		AttachParticleControllerNormal( ply, prop, { NewTable = { 
			EffectName = effectname, 
			AttachNum = attachnum, 

			RepeatRate = repeatrate, 
			RepeatSafety = repeatsafety, 

			Toggle = toggle, 
			StartOn = starton, 
			NumpadKey = numpadkey, 

			UtilEffectInfo = utileffectinfo, 
			ColorInfo = colorinfo 
		} } )
	else
		//It's a beam, attach the effect between two entities
		local iNum = self:NumObjects()

		self:SetObject( iNum + 1, prop, trace.HitPos, nil, nil, trace.HitNormal )
		if iNum == 0 then
			self.beamattach1 = attachnum
		else
			self.beamattach2 = attachnum
		end

		if ( iNum > 0 ) then
			if ( CLIENT ) then
				self:ClearObjects()
				return true
			end
			
			local Ent1, Ent2 = self:GetEnt(1), self:GetEnt(2)
			local constraint = constraint.AttachParticleControllerBeam( Ent1, Ent2, { 
				EffectName = effectname, 
				AttachNum = self.beamattach1, 
				AttachNum2 = self.beamattach2, 

				RepeatRate = repeatrate, 
				RepeatSafety = repeatsafety, 

				Toggle = toggle, 
				StartOn = starton, 
				NumpadKey = numpadkey, 

				UtilEffectInfo = utileffectinfo, 
				ColorInfo = colorinfo 
			}, ply )	
	
			self:ClearObjects()
		else
			self:SetStage( iNum+1 )
		end

		return true
	end

	return true

end




function TOOL:Reload( trace )

	//if we've selected something for a beam effect, then let us deselect it with reload
	if self:GetClientNumber( "mode_beam", 0 ) != 0 and self:NumObjects() > 0 then
		//self:GetEnt(1)
		self:ClearObjects()
		self:SetStage(0)
		return true
	end

	if ( trace.Entity:IsValid() ) then
		local fx = false

		if trace.Entity:GetClass() == "prop_effect" and trace.Entity.AttachedEntity then trace.Entity = trace.Entity.AttachedEntity end

		for _, asdf in pairs( ents:GetAll() ) do
			if asdf:GetClass() == "particlecontroller_normal" then 
				if asdf:GetParent() == trace.Entity then 
					if SERVER then asdf:Remove() end
					fx = true
				end
				if IsValid(asdf:GetTargetEnt2()) then
					if asdf:GetTargetEnt2() == trace.Entity or asdf:GetTargetEnt2():GetParent() == trace.Entity then 
						if SERVER then asdf:Remove() end
						fx = true
					end
				end
			end
		end
		if SERVER then
			duplicator.ClearEntityModifier( trace.Entity, "DupeParticleControllerNormal" )
			constraint.RemoveConstraints( trace.Entity, "AttachParticleControllerBeam" )
		end

		return fx
	end
	
end




if CLIENT then

	local colorborder   = Color(0,0,0,255)
	local colorselect   = Color(0,255,0,255)
	local colorunselect = Color(255,255,255,255)

	function TOOL:DrawHUD()
		local pl = LocalPlayer()
		local tr = pl:GetEyeTrace()
		local attachnum = self:GetClientNumber( "attachnum", 0 )

		local function DrawHighlightAttachments(ent)

			//If there aren't any attachments, then draw the model origin as selected and stop here:
			if !ent:GetAttachments() or !ent:GetAttachments()[1] then
				local _pos,_ang = ent:GetPos(), ent:GetAngles()
				local _pos = _pos:ToScreen()
				local textpos = {x = _pos.x+5,y = _pos.y-5}

				draw.RoundedBox(0,_pos.x - 3,_pos.y - 3,6,6,colorborder)
				draw.RoundedBox(0,_pos.x - 1,_pos.y - 1,2,2,colorselect)
				draw.SimpleTextOutlined("0: (origin)","Default",textpos.x,textpos.y,colorselect,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,2,colorborder)

				return
			end


			//Draw the unselected model origin, if applicable:
			if ent:GetAttachments()[attachnum] then
				local _pos,_ang = ent:GetPos(), ent:GetAngles()
				local _pos = _pos:ToScreen()
				local textpos = {x = _pos.x+5,y = _pos.y-5}

				draw.RoundedBox(0,_pos.x - 2,_pos.y - 2,4,4,colorborder)
				draw.RoundedBox(0,_pos.x - 1,_pos.y - 1,2,2,colorunselect)
				draw.SimpleTextOutlined("0: (origin)","Default",textpos.x,textpos.y,colorunselect,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,1,colorborder)
			end

			//Draw the unselected attachment points:
			for _, table in pairs(ent:GetAttachments()) do
				local _pos,_ang = ent:GetAttachment(table.id).Pos,ent:GetAttachment(table.id).Ang
				local _pos = _pos:ToScreen()
				local textpos = {x = _pos.x+5,y = _pos.y-5}

				if table.id != attachnum then
					draw.RoundedBox(0,_pos.x - 2,_pos.y - 2,4,4,colorborder)
					draw.RoundedBox(0,_pos.x - 1,_pos.y - 1,2,2,colorunselect)
					draw.SimpleTextOutlined(table.id ..": ".. table.name,"Default",textpos.x,textpos.y,colorunselect,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,1,colorborder)
				end
			end
			
			//Draw the selected attachment point or model origin last, so it renders above all the others:
			if !ent:GetAttachments()[attachnum] then
				//Model origin
				local _pos,_ang = ent:GetPos(), ent:GetAngles()
				local _pos = _pos:ToScreen()
				local textpos = {x = _pos.x+5,y = _pos.y-5}

				draw.RoundedBox(0,_pos.x - 3,_pos.y - 3,6,6,colorborder)
				draw.RoundedBox(0,_pos.x - 1,_pos.y - 1,2,2,colorselect)
				draw.SimpleTextOutlined("0: (origin)","Default",textpos.x,textpos.y,colorselect,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,2,colorborder)
			else
				//Attachment
				local _pos,_ang = ent:GetAttachment(attachnum).Pos,ent:GetAttachment(attachnum).Ang
				local _pos = _pos:ToScreen()
				local textpos = {x = _pos.x+5,y = _pos.y-5}

				draw.RoundedBox(0,_pos.x - 3,_pos.y - 3,6,6,colorborder)
				draw.RoundedBox(0,_pos.x - 1,_pos.y - 1,2,2,colorselect)
				draw.SimpleTextOutlined(attachnum ..": ".. ent:GetAttachments()[attachnum].name,"Default",textpos.x,textpos.y,colorselect,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,2,colorborder)
			end
		end

		if IsValid(tr.Entity) and tr.Entity == self.HighlightedEnt then
			DrawHighlightAttachments(self.HighlightedEnt) 
		return end

		if IsValid(tr.Entity) and tr.Entity != self.HighlightedEnt then
			//unhighlight the old ent if it exists
			if self.HighlightedEnt != nil then
				self.HighlightedEnt = nil
			end

			//highlight the new ent
			self.HighlightedEnt = tr.Entity
		end

		if !IsValid(tr.Entity) and self.HighlightedEnt != nil then
			self.HighlightedEnt = nil
		end
	end

	function TOOL:Holster()
		if self.HighlightedEnt != nil then
			self.HighlightedEnt = nil
		end
	end




	//All credit for the toolgun scroll wheel code goes to the Wiremod devs. You guys are the best.
		local function get_active_tool(ply, tool)
			-- find toolgun
			local activeWep = ply:GetActiveWeapon()
			if not IsValid(activeWep) or activeWep:GetClass() ~= "gmod_tool" or activeWep.Mode ~= tool then return end

			return activeWep:GetToolObject(tool)
		end

		local function hookfunc( ply, bind, pressed )
			if not pressed then return end
			if bind == "invnext" then
				local self = get_active_tool(ply, "particlecontrol")
				if not self then return end
			
				return self:ScrollDown(ply:GetEyeTraceNoCursor())
			elseif bind == "invprev" then
				local self = get_active_tool(ply, "particlecontrol")
				if not self then return end

				return self:ScrollUp(ply:GetEyeTraceNoCursor())
			end
		end
	
		if game.SinglePlayer() then -- wtfgarry (have to have a delay in single player or the hook won't get added)
			timer.Simple(5,function() hook.Add( "PlayerBindPress", "particlecontrol_playerbindpress", hookfunc ) end)
		else
			hook.Add( "PlayerBindPress", "particlecontrol_playerbindpress", hookfunc )
		end
	//End shamefully copied code here.

	function TOOL:Scroll(trace,dir)
		if !IsValid(self.HighlightedEnt) then return end

		local attachcount = 0
		if self.HighlightedEnt:GetAttachments() then attachcount = table.Count(self.HighlightedEnt:GetAttachments()) end
		local oldattachnum = self:GetClientNumber( "attachnum", 0 )
		if oldattachnum > attachcount then oldattachnum = 0 end
		local attachnum = oldattachnum + dir

		if attachnum < 0 then attachnum = attachcount end
		if attachnum > attachcount then attachnum = 0 end
		RunConsoleCommand("particlecontrol_attachnum", tostring(attachnum))
		self:GetOwner():EmitSound("weapons/pistol/pistol_empty.wav")
		return true
	end
	function TOOL:ScrollUp(trace) return self:Scroll(trace,-1) end
	function TOOL:ScrollDown(trace) return self:Scroll(trace,1) end

end




if SERVER then

	local function SpawnParticleControllerNormal(ply, ent, DataTable)

		if DataTable == nil or DataTable == {} or DataTable.EffectName == nil or ent == nil or !IsValid(ent) then return end


		local ParticleControlNormal = ents.Create( "particlecontroller_normal" )
		ParticleControlNormal:SetPos(ent:GetPos())
		ParticleControlNormal:SetAngles(ent:GetAngles())
		ParticleControlNormal:SetParent(ent)
		ent:DeleteOnRemove(ParticleControlNormal)

		ParticleControlNormal:SetTargetEnt(ent)
		ParticleControlNormal:SetEffectName(DataTable.EffectName)
		ParticleControlNormal:SetAttachNum(DataTable.AttachNum)
		ParticleControlNormal:SetUtilEffectInfo(DataTable.UtilEffectInfo)
		if DataTable.ColorInfo != nil then ParticleControlNormal:SetColor(DataTable.ColorInfo) else ParticleControlNormal:SetColor( Color(0,0,0,0) ) end

		ParticleControlNormal:SetRepeatRate(DataTable.RepeatRate)
		if DataTable.RepeatSafety == 1 or DataTable.RepeatSafety == true then ParticleControlNormal:SetRepeatSafety(true) else ParticleControlNormal:SetRepeatSafety(false) end


		if DataTable.StartOn == 1 or DataTable.StartOn == true then ParticleControlNormal:SetActive(true) else ParticleControlNormal:SetActive(false) end
		if DataTable.Toggle == 1 or DataTable.Toggle == true then ParticleControlNormal:SetToggle(true) else ParticleControlNormal:SetToggle(false) end
		ParticleControlNormal:SetNumpadKey(DataTable.NumpadKey)

		numpad.OnDown( 	 ply, 	DataTable.NumpadKey, 	"Particle_Press", 	ParticleControlNormal )
		numpad.OnUp( 	 ply, 	DataTable.NumpadKey, 	"Particle_Release", 	ParticleControlNormal )
		ParticleControlNormal:SetNumpadState("")


		ParticleControlNormal:Spawn()
		ParticleControlNormal:Activate()

	end


	function AttachParticleControllerNormal( ply, ent, Data )

		if Data.NewTable then
			SpawnParticleControllerNormal(ply, ent, Data.NewTable)

			local dupetable = {}
			if ent.EntityMods and ent.EntityMods.DupeParticleControllerNormal then dupetable = ent.EntityMods.DupeParticleControllerNormal end
			table.insert(dupetable, Data.NewTable)
			duplicator.StoreEntityModifier( ent, "DupeParticleControllerNormal", dupetable )
		return end

	end


	function DupeParticleControllerNormal( ply, ent, Data )

		local override = hook.Run('CanTool', ply, { Entity = ent }, 'particlecontrol')
		if override == false then return end

		//due to a problem with the easy bonemerge tool that causes entity modifiers to be applied TWICE, we need to remove the effects that were added the first time
		for _, asdf in pairs( ents:GetAll() ) do
			if asdf:GetClass() == "particlecontroller_normal" and asdf:GetParent() == ent then
				asdf:Remove()
			end
		end

		for _, DataTable in pairs (Data) do
			SpawnParticleControllerNormal(ply, ent, DataTable)
		end

	end
	duplicator.RegisterEntityModifier( "DupeParticleControllerNormal", DupeParticleControllerNormal )




	//we have to redefine some of the constraint functions here because they're local functions that don't exist outside of constraints.lua
	//not sure how well these'll work, one of them is ripped straight from the nocollide world tool which uses the same trick for its custom constraints
		local MAX_CONSTRAINTS_PER_SYSTEM = 100
		local function CreateConstraintSystem()
			local System = ents.Create("phys_constraintsystem")
			if !IsValid(System) then return end
			System:SetKeyValue("additionaliterations", GetConVarNumber("gmod_physiterations"))
			System:Spawn()
			System:Activate()
			return System
		end
		local function FindOrCreateConstraintSystem( Ent1, Ent2 )
			local System = nil
			Ent2 = Ent2 or Ent1
			-- Does Ent1 have a constraint system?
			if ( !Ent1:IsWorld() && Ent1:GetTable().ConstraintSystem && Ent1:GetTable().ConstraintSystem:IsValid() ) then 
				System = Ent1:GetTable().ConstraintSystem
			end
			-- Don't add to this system - we have too many constraints on it already.
			if ( System && System:IsValid() && System:GetVar( "constraints", 0 ) > MAX_CONSTRAINTS_PER_SYSTEM ) then System = nil end
			-- Does Ent2 have a constraint system?
			if ( !System && !Ent2:IsWorld() && Ent2:GetTable().ConstraintSystem && Ent2:GetTable().ConstraintSystem:IsValid() ) then 
				System = Ent2:GetTable().ConstraintSystem
			end
			-- Don't add to this system - we have too many constraints on it already.
			if ( System && System:IsValid() && System:GetVar( "constraints", 0 ) > MAX_CONSTRAINTS_PER_SYSTEM ) then System = nil end
			-- No constraint system yet (Or they're both full) - make a new one
			if ( !System || !System:IsValid() ) then
				--Msg("New Constrant System\n")
				System = CreateConstraintSystem()
			end
			Ent1.ConstraintSystem = System
			Ent2.ConstraintSystem = System
			System.UsedEntities = System.UsedEntities or {}
			table.insert( System.UsedEntities, Ent1 )
			table.insert( System.UsedEntities, Ent2 )
			local ConstraintNum = System:GetVar( "constraints", 0 )
			System:SetVar( "constraints", ConstraintNum + 1 )
			--Msg("System has "..tostring( System:GetVar( "constraints", 0 ) ).." constraints\n")
			return System
		end
	//end ripped constraint functions here.

	//multiple-point "beam" effects use a constraint so the duplicator can group the two entities together
	function constraint.AttachParticleControllerBeam( Ent1, Ent2, Data, ply )
		if !Ent1 or !Ent2 then return end

		//onStartConstraint( Ent1, Ent2 )
		local system = FindOrCreateConstraintSystem( Ent1, Ent2 )
		SetPhysConstraintSystem( system )
		
		//create a dummy ent for the constraint functions to use
		local Constraint = ents.Create("logic_collision_pair")
		Constraint:Spawn()
		Constraint:Activate()



		local ParticleControlBeam = ents.Create( "particlecontroller_normal" )
		ParticleControlBeam:SetPos(Ent1:GetPos())
		ParticleControlBeam:SetAngles(Ent1:GetAngles())
		ParticleControlBeam:SetParent(Ent1)
		Ent1:DeleteOnRemove(ParticleControlBeam)
		Ent2:DeleteOnRemove(ParticleControlBeam)

		ParticleControlBeam:SetTargetEnt(Ent1)
		ParticleControlBeam:SetTargetEnt2(Ent2)
		ParticleControlBeam:SetEffectName(Data.EffectName)
		ParticleControlBeam:SetAttachNum(Data.AttachNum)
		ParticleControlBeam:SetAttachNum2(Data.AttachNum2)
		ParticleControlBeam:SetUtilEffectInfo(Data.UtilEffectInfo)
		if Data.ColorInfo != nil then ParticleControlBeam:SetColor(Data.ColorInfo) else ParticleControlBeam:SetColor( Color(0,0,0,0) ) end

		ParticleControlBeam:SetRepeatRate(Data.RepeatRate)
		if Data.RepeatSafety == 1 or Data.RepeatSafety == true then ParticleControlBeam:SetRepeatSafety(true) else ParticleControlBeam:SetRepeatSafety(false) end

		if Data.StartOn == 1 or Data.StartOn == true then ParticleControlBeam:SetActive(true) else ParticleControlBeam:SetActive(false) end
		if Data.Toggle == 1 or Data.Toggle ==  true then ParticleControlBeam:SetToggle(true) else ParticleControlBeam:SetToggle(false) end
		ParticleControlBeam:SetNumpadKey(Data.NumpadKey)

		numpad.OnDown( 	 ply, 	Data.NumpadKey, 	"Particle_Press", 	ParticleControlBeam )
		numpad.OnUp( 	 ply, 	Data.NumpadKey, 	"Particle_Release", 	ParticleControlBeam )
		ParticleControlBeam:SetNumpadState("")

		ParticleControlBeam:Spawn()
		ParticleControlBeam:Activate()
		


		//onFinishConstraint( Ent1, Ent2 )
		SetPhysConstraintSystem( NULL )

		constraint.AddConstraintTable( Ent1, Constraint, Ent2 )
		
		local ctable  = 
		{
			Type  = "AttachParticleControllerBeam",
			Ent1  = Ent1,
			Ent2  = Ent2,
			Data  = Data,
			ply   = ply,
		}
	
		Constraint:SetTable( ctable )
	
		return Constraint
	end
	duplicator.RegisterConstraint( "AttachParticleControllerBeam", constraint.AttachParticleControllerBeam, "Ent1", "Ent2", "Data", "ply" )

end




//we're still testing out a lot of stuff with the cpanel, so let's add a way to refresh it by reselecting the tool
--[[
TOOL.ClientConVar[ "refresh" ] = 1
function TOOL:Think()
	if SERVER then return end
	if self:GetClientNumber("refresh") == 1 then
		RunConsoleCommand("particlecontrol_refresh", "0");
		//refresh the cpanel
		local panel = controlpanel.Get( "particlecontrol" )
		if ( !panel ) then return end
		panel:ClearControls()
		self.BuildCPanel(panel)
	end
end
function TOOL:Deploy()
	RunConsoleCommand("particlecontrol_refresh", "1");
end
]]

local ConVarsDefault = TOOL:BuildConVarList()
ConVarsDefault["particlecontrol_attachnum"] = nil  //don't save the attachnum in presets, it's used by the other tools too

function TOOL.BuildCPanel(panel)

	panel:AddControl( "Header", { Description = "#tool.particlecontrol.help" } )

	//Presets
	panel:AddControl( "ComboBox", { 
		MenuButton = 1, 
		Folder = "particlecontrol", 
		Options = { 
			[ "#preset.default" ] = ConVarsDefault
		}, 
		CVars = table.GetKeys( ConVarsDefault ) 
	} )



	AddParticleBrowser(panel, { 
		name = "Effect", 
		commands = { 
			effectname = "particlecontrol_effectname", 
			mode_beam = "particlecontrol_mode_beam",
			color = "particlecontrol_color",
			utileffect = "particlecontrol_utileffect",
		}, 
	})



	//panel:AddControl( "Label", { Text = "" }  )
	panel:AddControl( "Label", { Text = "" }  )



	panel:AddControl("Slider", {
		Label = "Attachment",
	 	Type = "Integer",
		Min = "0",
		Max = "10",
		Command = "particlecontrol_attachnum",
	})
	panel:ControlHelp( "Attachment point on the model to use. Set to 0 to attach to the model origin or to attach model-covering effects to the entire model." )

	panel:AddControl("Slider", {
		Label = "Repeat Rate",
	 	Type = "Float",
		Min = "0",
		Max = "5",
		Command = "particlecontrol_repeatrate",
	})
	panel:ControlHelp( "How often the effect plays. Set to 0 to not repeat." )

	panel:AddControl( "CheckBox", { Label = "Repeat Safety", Command = "particlecontrol_repeatsafety" } )
	panel:ControlHelp( "If on, effects are removed before being repeated. This stops them from piling up endlessly, but can also cause small problems, like effects being cut off. You should probably keep this on unless you know what you're doing." )



	panel:AddControl( "Label", { Text = "" }  )
	panel:AddControl( "Label", { Text = "" }  )



	local modellist = { Label = "Prop", ConVar = "particlecontrol_propmodel", Category = "Prop", Height = 1, Models = {} }
	modellist.Models["models/hunter/plates/plate025x025.mdl"] = {}
	modellist.Models["models/hunter/plates/plate.mdl"] = {}
	modellist.Models["models/weapons/w_smg1.mdl"] = {}
	modellist.Models["models/props_junk/popcan01a.mdl"] = {}
	panel:AddControl( "PropSelect", modellist )

	panel:AddControl( "ComboBox",  {
		Label = "Prop Angle", 
		MenuButton = "0", 
		Options = {
			["Spawn upright"] = { particlecontrol_propangle = "1" },
			["Spawn at surface angle"] = { particlecontrol_propangle = "2" }
		}
	})

	panel:AddControl( "CheckBox", { Label = "Invisible prop (particles only)", Command = "particlecontrol_propinvis" } )



	panel:AddControl( "Label", { Text = "" }  )
	panel:AddControl( "Label", { Text = "" }  )



	panel:AddControl( "Numpad", {
		Label = "Effect Key",
		Command = "particlecontrol_numpadkey",
	})

	panel:AddControl( "CheckBox", { Label = "Toggle", Command = "particlecontrol_toggle" } )

	panel:AddControl( "CheckBox", { Label = "Start on?", Command = "particlecontrol_starton" } )

end
