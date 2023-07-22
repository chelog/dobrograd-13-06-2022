TOOL.Category = "Particle Controller"
TOOL.Name = "ParCtrl - Tracers"
TOOL.Command = nil
TOOL.ConfigName = "" 

TOOL.HighlightedEnt = nil
 
TOOL.ClientConVar[ "effectname" ] = "!UTILEFFECT!AR2Tracer"
//TOOL.ClientConVar[ "utileffect_scale" ] = "1"
//TOOL.ClientConVar[ "utileffect_magnitude" ] = "1"
//TOOL.ClientConVar[ "utileffect_radius" ] = "10"
TOOL.ClientConVar[ "color_enabled" ] = "0"
TOOL.ClientConVar[ "color_r" ] = "255"
TOOL.ClientConVar[ "color_g" ] = "20"
TOOL.ClientConVar[ "color_b" ] = "0"
TOOL.ClientConVar[ "color_outofone" ] = "0"

TOOL.ClientConVar[ "impactfx_enabled" ] = "1"
TOOL.ClientConVar[ "impactfx_effectname" ] = "!UTILEFFECT!AR2Impact"
TOOL.ClientConVar[ "impactfx_utileffect_scale" ] = "1"
TOOL.ClientConVar[ "impactfx_utileffect_magnitude" ] = "1"
TOOL.ClientConVar[ "impactfx_utileffect_radius" ] = "10"
TOOL.ClientConVar[ "impactfx_color_enabled" ] = "0"
TOOL.ClientConVar[ "impactfx_color_r" ] = "255"
TOOL.ClientConVar[ "impactfx_color_g" ] = "20"
TOOL.ClientConVar[ "impactfx_color_b" ] = "0"
TOOL.ClientConVar[ "impactfx_color_outofone" ] = "0"

//TOOL.ClientConVar[ "attachnum" ] = "1"   //we're using the standard tool's attachnum var instead so that the selected attachment stays consistent when swapping between tools
TOOL.ClientConVar[ "repeatrate" ] = "0.1"
TOOL.ClientConVar[ "effectlifetime" ] = "1.0"

TOOL.ClientConVar[ "tracerspread" ] = "0.02"
TOOL.ClientConVar[ "tracercount" ] = "1"
TOOL.ClientConVar[ "leavebulletholes" ] = "1"

TOOL.ClientConVar[ "propmodel" ] = "models/weapons/w_smg1.mdl"
TOOL.ClientConVar[ "propangle" ] = "2"
TOOL.ClientConVar[ "propinvis" ] = "0"

TOOL.ClientConVar[ "numpadkey" ] = "52"
TOOL.ClientConVar[ "toggle" ] = "1"
TOOL.ClientConVar[ "starton" ] = "1"

TOOL.Information = {
	{ name = "left0", stage = 0, icon = "gui/lmb.png" },
	{ name = "middle0", stage = 0, icon = "gui/mmb.png" },
	{ name = "right0", stage = 0, icon = "gui/rmb.png" },
	{ name = "reload0", stage = 0, icon = "gui/r.png" },
}

if ( CLIENT ) then
	language.Add( "tool.particlecontrol_tracer.name", "Adv. Particle Controller - Tracers" )
	language.Add( "tool.particlecontrol_tracer.desc", "Attach tracer effects to things" )
	language.Add( "tool.particlecontrol_tracer.help", "Tracer effects are particles that fire out like bullets, with one end at the attachment and the other end where the \"bullet\"  hits something." )

	language.Add( "tool.particlecontrol_tracer.left0", "Add a tracer effect to an object" )
	language.Add( "tool.particlecontrol_tracer.middle0", "Scroll through an object's attachments" )
	language.Add( "tool.particlecontrol_tracer.right0", "Attach a new prop with the tracer effect on it" )
	language.Add( "tool.particlecontrol_tracer.reload0", "Remove all tracer effects from an object" )
end

util.PrecacheSound("weapons/pistol/pistol_empty.wav")




function TOOL:LeftClick( trace )

	local effectname = self:GetClientInfo( "effectname", 0 )
	local attachnum = self:GetOwner():GetInfoNum( "particlecontrol_attachnum", 0 )   //use the standard tool's attachnum var

	local repeatrate  = self:GetClientNumber( "repeatrate", 0 )

	local numpadkey  = self:GetClientNumber( "numpadkey", 0 )
	local toggle  = self:GetClientNumber( "toggle", 0 )
	local starton  = self:GetClientNumber( "starton", 0 )

	//local utileffectinfo = Vector( self:GetClientNumber( "utileffect_scale", 0 ), self:GetClientNumber( "utileffect_magnitude", 0 ), self:GetClientNumber( "utileffect_radius", 0 ) )
	local colorinfo = nil
	if self:GetClientNumber( "color_enabled", 0 ) == 1 then
		if self:GetClientNumber( "color_outofone", 0 ) == 1 then
			colorinfo = Color( self:GetClientNumber( "color_r", 0 ), self:GetClientNumber( "color_g", 0 ), self:GetClientNumber( "color_b", 0 ), 1 )  //we're using the alpha value to store color_outofone
		else
			colorinfo = Color( self:GetClientNumber( "color_r", 0 ), self:GetClientNumber( "color_g", 0 ), self:GetClientNumber( "color_b", 0 ), 0 )
		end
	end

	local tracerspread = self:GetClientNumber( "tracerspread", 0 )
	local tracercount = self:GetClientNumber( "tracercount", 0 )
	local leavebulletholes = self:GetClientNumber( "leavebulletholes", 0 )
	local effectlifetime = self:GetClientNumber( "effectlifetime", 0 )

	local impactinfo = nil
	if self:GetClientNumber( "impactfx_enabled", 0 ) == 1 then
		impactinfo = {
			effectname = self:GetClientInfo( "impactfx_effectname", 0 ),
			utileffectinfo = Vector( self:GetClientNumber( "impactfx_utileffect_scale", 0 ), self:GetClientNumber( "impactfx_utileffect_magnitude", 0 ), self:GetClientNumber( "impactfx_utileffect_radius", 0 ) ),
		}
		if self:GetClientNumber( "impactfx_color_enabled", 0 ) == 1 then
			if self:GetClientNumber( "impactfx_color_outofone", 0 ) == 1 then
				impactinfo.colorinfo = Color( self:GetClientNumber( "impactfx_color_r", 0 ), self:GetClientNumber( "impactfx_color_g", 0 ), self:GetClientNumber( "impactfx_color_b", 0 ), 1 )  //we're using the alpha value to store color_outofone
			else
				impactinfo.colorinfo = Color( self:GetClientNumber( "impactfx_color_r", 0 ), self:GetClientNumber( "impactfx_color_g", 0 ), self:GetClientNumber( "impactfx_color_b", 0 ), 0 )
			end
		end
	end

	local ply = self:GetOwner()



	if ( trace.Entity:IsValid() ) then
		if CLIENT then return true end
		if trace.Entity:GetClass() == "prop_effect" and trace.Entity.AttachedEntity then trace.Entity = trace.Entity.AttachedEntity end
		AttachParticleControllerTracer( ply, trace.Entity, { NewTable = { 
			EffectName = effectname, 
			AttachNum = attachnum, 

			RepeatRate = repeatrate, 

			Toggle = toggle, 
			StartOn = starton, 
			NumpadKey = numpadkey, 

			ColorInfo = colorinfo, 

			TracerSpread = tracerspread, 
			TracerCount = tracercount, 
			LeaveBulletHoles = leavebulletholes, 
			EffectLifetime = effectlifetime,

			ImpactInfo = impactinfo,
		} } )
		return true
	end

end




function TOOL:RightClick( trace )

	local effectname = self:GetClientInfo( "effectname", 0 )
	local attachnum = self:GetOwner():GetInfoNum( "particlecontrol_attachnum", 0 )   //use the standard tool's attachnum var

	local repeatrate  = self:GetClientNumber( "repeatrate", 0 )

	local numpadkey  = self:GetClientNumber( "numpadkey", 0 )
	local toggle  = self:GetClientNumber( "toggle", 0 )
	local starton  = self:GetClientNumber( "starton", 0 )

	//local utileffectinfo = Vector( self:GetClientNumber( "utileffect_scale", 0 ), self:GetClientNumber( "utileffect_magnitude", 0 ), self:GetClientNumber( "utileffect_radius", 0 ) )
	local colorinfo = nil
	if self:GetClientNumber( "color_enabled", 0 ) == 1 then
		if self:GetClientNumber( "color_outofone", 0 ) == 1 then
			colorinfo = Color( self:GetClientNumber( "color_r", 0 ), self:GetClientNumber( "color_g", 0 ), self:GetClientNumber( "color_b", 0 ), 1 )  //we're using the alpha value to store color_outofone
		else
			colorinfo = Color( self:GetClientNumber( "color_r", 0 ), self:GetClientNumber( "color_g", 0 ), self:GetClientNumber( "color_b", 0 ), 0 )
		end
	end

	local tracerspread = self:GetClientNumber( "tracerspread", 0 )
	local tracercount = self:GetClientNumber( "tracercount", 0 )
	local leavebulletholes = self:GetClientNumber( "leavebulletholes", 0 )
	local effectlifetime = self:GetClientNumber( "effectlifetime", 0 )

	local impactinfo = nil
	if self:GetClientNumber( "impactfx_enabled", 0 ) == 1 then
		impactinfo = {
			effectname = self:GetClientInfo( "impactfx_effectname", 0 ),
			utileffectinfo = Vector( self:GetClientNumber( "impactfx_utileffect_scale", 0 ), self:GetClientNumber( "impactfx_utileffect_magnitude", 0 ), self:GetClientNumber( "impactfx_utileffect_radius", 0 ) ),
		}
		if self:GetClientNumber( "impactfx_color_enabled", 0 ) == 1 then
			if self:GetClientNumber( "impactfx_color_outofone", 0 ) == 1 then
				impactinfo.colorinfo = Color( self:GetClientNumber( "impactfx_color_r", 0 ), self:GetClientNumber( "impactfx_color_g", 0 ), self:GetClientNumber( "impactfx_color_b", 0 ), 1 )  //we're using the alpha value to store color_outofone
			else
				impactinfo.colorinfo = Color( self:GetClientNumber( "impactfx_color_r", 0 ), self:GetClientNumber( "impactfx_color_g", 0 ), self:GetClientNumber( "impactfx_color_b", 0 ), 0 )
			end
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



	if ( prop:IsValid() ) then
		AttachParticleControllerTracer( ply, prop, { NewTable = { 
			EffectName = effectname, 
			AttachNum = attachnum, 

			RepeatRate = repeatrate, 

			Toggle = toggle, 
			StartOn = starton, 
			NumpadKey = numpadkey, 

			ColorInfo = colorinfo, 

			TracerSpread = tracerspread, 
			TracerCount = tracercount, 
			LeaveBulletHoles = leavebulletholes, 
			EffectLifetime = effectlifetime,

			ImpactInfo = impactinfo,
		} } )
		return true
	end

end




function TOOL:Reload( trace )

	if ( trace.Entity:IsValid() ) then
		local fx = false

		if trace.Entity:GetClass() == "prop_effect" and trace.Entity.AttachedEntity then trace.Entity = trace.Entity.AttachedEntity end

		for _, asdf in pairs( ents:GetAll() ) do
			if asdf:GetClass() == "particlecontroller_tracer" and asdf:GetParent() == trace.Entity then 
				if SERVER then asdf:Remove() end
				fx = true
			end
		end
		if SERVER then
			duplicator.ClearEntityModifier( trace.Entity, "DupeParticleControllerTracer" )
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
		local attachnum = self:GetOwner():GetInfoNum( "particlecontrol_attachnum", 0 )   //use the standard tool's attachnum var

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
				local self = get_active_tool(ply, "particlecontrol_tracer")
				if not self then return end
			
				return self:ScrollDown(ply:GetEyeTraceNoCursor())
			elseif bind == "invprev" then
				local self = get_active_tool(ply, "particlecontrol_tracer")
				if not self then return end

				return self:ScrollUp(ply:GetEyeTraceNoCursor())
			end
		end
	
		if game.SinglePlayer() then -- wtfgarry (have to have a delay in single player or the hook won't get added)
			timer.Simple(5,function() hook.Add( "PlayerBindPress", "particlecontrol_tracer_playerbindpress", hookfunc ) end)
		else
			hook.Add( "PlayerBindPress", "particlecontrol_tracer_playerbindpress", hookfunc )
		end
	//End shamefully copied code here.

	function TOOL:Scroll(trace,dir)
		if !IsValid(self.HighlightedEnt) then return end

		local attachcount = 0
		if self.HighlightedEnt:GetAttachments() then attachcount = table.Count(self.HighlightedEnt:GetAttachments()) end
		local oldattachnum = self:GetOwner():GetInfoNum( "particlecontrol_attachnum", 0 )   //use the standard tool's attachnum var
		if oldattachnum > attachcount then oldattachnum = 0 end
		local attachnum = oldattachnum + dir

		if attachnum < 0 then attachnum = attachcount end
		if attachnum > attachcount then attachnum = 0 end
		RunConsoleCommand("particlecontrol_attachnum", tostring(attachnum))   //use the standard tool's attachnum var
		self:GetOwner():EmitSound("weapons/pistol/pistol_empty.wav")
		return true
	end
	function TOOL:ScrollUp(trace) return self:Scroll(trace,-1) end
	function TOOL:ScrollDown(trace) return self:Scroll(trace,1) end

end




if SERVER then

	local function SpawnParticleControllerTracer(ply, ent, DataTable)

		if DataTable == nil or DataTable == {} or DataTable.EffectName == nil or ent == nil or !IsValid(ent) then return end


		local ParticleControlTracer = ents.Create( "particlecontroller_tracer" )
		ParticleControlTracer:SetPos(ent:GetPos())
		ParticleControlTracer:SetAngles(ent:GetAngles())
		ParticleControlTracer:SetParent(ent)
		ent:DeleteOnRemove(ParticleControlTracer)

		ParticleControlTracer:SetTargetEnt(ent)
		ParticleControlTracer:SetEffectName(DataTable.EffectName)
		ParticleControlTracer:SetAttachNum(DataTable.AttachNum)
		//ParticleControlTracer:SetUtilEffectInfo(DataTable.UtilEffectInfo)
		if DataTable.ColorInfo != nil then ParticleControlTracer:SetColor(DataTable.ColorInfo) else ParticleControlTracer:SetColor( Color(0,0,0,0) ) end

		ParticleControlTracer:SetTracerSpread(DataTable.TracerSpread)
		ParticleControlTracer:SetTracerCount(DataTable.TracerCount)
		if DataTable.LeaveBulletHoles == 1 or DataTable.LeaveBulletHoles == true then ParticleControlTracer:SetLeaveBulletHoles(true) else ParticleControlTracer:SetLeaveBulletHoles(false) end
		ParticleControlTracer:SetEffectLifetime(DataTable.EffectLifetime or 1.00)  //old dupes will have nil

		if DataTable.ImpactInfo != nil then
			ParticleControlTracer:SetImpact_EffectName(DataTable.ImpactInfo.effectname)
			ParticleControlTracer:SetImpact_UtilEffectInfo(DataTable.ImpactInfo.utileffectinfo)
			if DataTable.ImpactInfo.colorinfo != nil then
				local impactcolor = Vector(DataTable.ImpactInfo.colorinfo.r, DataTable.ImpactInfo.colorinfo.g, DataTable.ImpactInfo.colorinfo.b)
				if DataTable.ImpactInfo.colorinfo.a then
					impactcolor = impactcolor / 255
				end
				ParticleControlTracer:SetImpact_ColorInfo( impactcolor )
			else
				ParticleControlTracer:SetImpact_ColorInfo( Vector(0,0,0) )
			end
		else
			ParticleControlTracer:SetImpact_EffectName("")
		end

		ParticleControlTracer:SetRepeatRate(DataTable.RepeatRate)


		if DataTable.StartOn == 1 or DataTable.StartOn == true then ParticleControlTracer:SetActive(true) else ParticleControlTracer:SetActive(false) end
		if DataTable.Toggle == 1 or DataTable.Toggle == true then ParticleControlTracer:SetToggle(true) else ParticleControlTracer:SetToggle(false) end
		ParticleControlTracer:SetNumpadKey(DataTable.NumpadKey)

		numpad.OnDown( 	 ply, 	DataTable.NumpadKey, 	"Particle_Press", 	ParticleControlTracer )
		numpad.OnUp( 	 ply, 	DataTable.NumpadKey, 	"Particle_Release", 	ParticleControlTracer )
		ParticleControlTracer:SetNumpadState("")


		ParticleControlTracer:Spawn()
		ParticleControlTracer:Activate()

	end


	function AttachParticleControllerTracer( ply, ent, Data )

		if Data.NewTable then
			SpawnParticleControllerTracer(ply, ent, Data.NewTable)

			local dupetable = {}
			if ent.EntityMods and ent.EntityMods.DupeParticleControllerTracer then dupetable = ent.EntityMods.DupeParticleControllerTracer end
			table.insert(dupetable, Data.NewTable)
			duplicator.StoreEntityModifier( ent, "DupeParticleControllerTracer", dupetable )
		return end

	end


	function DupeParticleControllerTracer( ply, ent, Data )

		local override = hook.Run('CanTool', ply, { Entity = ent }, 'particlecontrol_tracer')
		if override == false then return end

		//due to a problem with the easy bonemerge tool that causes entity modifiers to be applied TWICE, we need to remove the effects that were added the first time
		for _, asdf in pairs( ents:GetAll() ) do
			if asdf:GetClass() == "particlecontroller_tracer" and asdf:GetParent() == ent then
				asdf:Remove()
			end
		end

		for _, DataTable in pairs (Data) do
			SpawnParticleControllerTracer(ply, ent, DataTable)
		end

	end
	duplicator.RegisterEntityModifier( "DupeParticleControllerTracer", DupeParticleControllerTracer )

end




//we're still testing out a lot of stuff with the cpanel, so let's add a way to refresh it by reselecting the tool
--[[
TOOL.ClientConVar[ "refresh" ] = 1
function TOOL:Think()
	if SERVER then return end
	if self:GetClientNumber("refresh") == 1 then
		RunConsoleCommand("particlecontrol_tracer_refresh", "0");
		//refresh the cpanel
		local panel = controlpanel.Get( "particlecontrol_tracer" )
		if ( !panel ) then return end
		panel:ClearControls()
		self.BuildCPanel(panel)
	end
end
function TOOL:Deploy()
	RunConsoleCommand("particlecontrol_tracer_refresh", "1");
end
]]

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel(panel)

	panel:AddControl( "Header", { Description = "#tool.particlecontrol_tracer.help" } )

	//Presets
	panel:AddControl( "ComboBox", { 
		MenuButton = 1, 
		Folder = "particlecontrol_tracer", 
		Options = { 
			//[ "#preset.default" ] = ConVarsDefault
			[ "Example: Pulse Rifle" ] = ConVarsDefault,
			[ "Example: Generic Bullets" ] = { particlecontrol_tracer_color_b = "0", particlecontrol_tracer_color_enabled = "0", particlecontrol_tracer_color_g = "20", particlecontrol_tracer_color_outofone = "0", particlecontrol_tracer_color_r = "255", particlecontrol_tracer_effectlifetime = "1.000000", particlecontrol_tracer_effectname = "!UTILEFFECT!Tracer", particlecontrol_tracer_impactfx_color_b = "0", particlecontrol_tracer_impactfx_color_enabled = "0", particlecontrol_tracer_impactfx_color_g = "20", particlecontrol_tracer_impactfx_color_outofone = "0", particlecontrol_tracer_impactfx_color_r = "255", particlecontrol_tracer_impactfx_effectname = "!UTILEFFECT!AR2Impact", particlecontrol_tracer_impactfx_enabled = "0", particlecontrol_tracer_impactfx_utileffect_magnitude = "1", particlecontrol_tracer_impactfx_utileffect_radius = "10", particlecontrol_tracer_impactfx_utileffect_scale = "1", particlecontrol_tracer_leavebulletholes = "1", particlecontrol_tracer_numpadkey = "52", 
							particlecontrol_tracer_propangle = "2", particlecontrol_tracer_propinvis = "0", particlecontrol_tracer_propmodel = "models/weapons/w_smg1.mdl", particlecontrol_tracer_repeatrate = "0.080000", particlecontrol_tracer_starton = "1", particlecontrol_tracer_toggle = "1", particlecontrol_tracer_tracercount = "1", particlecontrol_tracer_tracerspread = "0.050000" },
			[ "Example: Toolgun" ] = { particlecontrol_tracer_color_b = "0", particlecontrol_tracer_color_enabled = "0", particlecontrol_tracer_color_g = "20", particlecontrol_tracer_color_outofone = "0", particlecontrol_tracer_color_r = "255", particlecontrol_tracer_effectlifetime = "1.000000", particlecontrol_tracer_effectname = "!UTILEFFECT!ToolTracer", particlecontrol_tracer_impactfx_color_b = "0", particlecontrol_tracer_impactfx_color_enabled = "0", particlecontrol_tracer_impactfx_color_g = "20", particlecontrol_tracer_impactfx_color_outofone = "0", particlecontrol_tracer_impactfx_color_r = "255", particlecontrol_tracer_impactfx_effectname = "!UTILEFFECT!selection_indicator", particlecontrol_tracer_impactfx_enabled = "1", particlecontrol_tracer_impactfx_utileffect_magnitude = "1", particlecontrol_tracer_impactfx_utileffect_radius = "10", particlecontrol_tracer_impactfx_utileffect_scale = "1", particlecontrol_tracer_leavebulletholes = "0", particlecontrol_tracer_numpadkey = "52", 
							particlecontrol_tracer_propangle = "2", particlecontrol_tracer_propinvis = "0", particlecontrol_tracer_propmodel = "models/weapons/w_smg1.mdl", particlecontrol_tracer_repeatrate = "1", particlecontrol_tracer_starton = "1", particlecontrol_tracer_toggle = "1", particlecontrol_tracer_tracercount = "1", particlecontrol_tracer_tracerspread = "0" },
		}, 
		CVars = table.GetKeys( ConVarsDefault ) 
	} )



	AddParticleBrowserTracer(panel, { 
		name = "Tracer Effect", 
		commands = { 
			effectname = "particlecontrol_tracer_effectname", 
			color = "particlecontrol_tracer_color",
		}, 
	})



	//panel:AddControl( "Label", { Text = "" }  )
	//panel:AddControl( "Label", { Text = "" }  )



	panel:AddControl( "Checkbox", { Label = "Enable impact effects?", Command = "particlecontrol_tracer_impactfx_enabled" } )

	AddParticleBrowser(panel, { 
		name = "Impact Effect", 
		commands = { 
			effectname = "particlecontrol_tracer_impactfx_effectname", 
			color = "particlecontrol_tracer_impactfx_color",
			utileffect = "particlecontrol_tracer_impactfx_utileffect",

			enabled = "particlecontrol_tracer_impactfx_enabled",
		}, 
	})



	//panel:AddControl( "Label", { Text = "" }  )
	panel:AddControl( "Label", { Text = "" }  )



	panel:AddControl("Slider", {
		Label = "Attachment",
	 	Type = "Integer",
		Min = "0",
		Max = "10",
		Command = "particlecontrol_attachnum",   //use the standard tool's attachnum var
	})
	panel:ControlHelp( "Attachment point on the model to fire tracers from. Set to 0 to fire from the model origin." )

	panel:AddControl("Slider", {
		Label = "Repeat Rate",
	 	Type = "Float",
		Min = "0",
		Max = "1",
		Command = "particlecontrol_tracer_repeatrate"
	})
	panel:ControlHelp( "How often the tracer fires. Set to 0 to not repeat." )



	panel:AddControl( "Label", { Text = "" }  )
	panel:AddControl( "Label", { Text = "" }  )



	panel:AddControl("Slider", {
		Label = "Tracer Spread",
	 	Type = "Float",
		Min = "0",
		Max = "1",
		Command = "particlecontrol_tracer_tracerspread"
	})
	panel:ControlHelp( "Each unit is 90 degrees of spread - you can type in 2 for 180 degrees or even 4 for 360 degrees." )

	panel:AddControl("Slider", {
		Label = "Tracers per shot",
	 	Type = "Integer",
		Min = "1",
		Max = "10",
		Command = "particlecontrol_tracer_tracercount"
	})

	panel:AddControl( "Checkbox", { Label = "Leave bullet holes?", Command = "particlecontrol_tracer_leavebulletholes" } )

	panel:AddControl("Slider", {
		Label = "Effect Lifetime",
	 	Type = "Float",
		Min = "0.5",
		Max = "5",
		Command = "particlecontrol_tracer_effectlifetime"
	})
	//panel:ControlHelp( "Number of seconds before tracer and impact effects are removed." )



	panel:AddControl( "Label", { Text = "" }  )
	panel:AddControl( "Label", { Text = "" }  )



	local modellist = { Label = "Prop:", ConVar = "particlecontrol_tracer_propmodel", Category = "Prop", Height = 1, Models = {} }
	modellist.Models["models/hunter/plates/plate025x025.mdl"] = {}
	modellist.Models["models/hunter/plates/plate.mdl"] = {}
	modellist.Models["models/weapons/w_smg1.mdl"] = {}
	modellist.Models["models/weapons/w_models/w_shotgun.mdl"] = {}

	panel:AddControl( "PropSelect", modellist )

	panel:AddControl( "ComboBox",  {
		Label = "Prop Angle", 
		MenuButton = "0", 
		Options = {
			["Spawn upright"] = { particlecontrol_tracer_propangle = "1" },
			["Spawn at surface angle"] = { particlecontrol_tracer_propangle = "2" }
		}
	})

	panel:AddControl( "Checkbox", { Label = "Invisible prop (particles only)", Command = "particlecontrol_tracer_propinvis" } )



	panel:AddControl( "Label", { Text = "" }  )
	panel:AddControl( "Label", { Text = "" }  )



	panel:AddControl( "Numpad", {
		Label = "Effect Key",
		Command = "particlecontrol_tracer_numpadkey",
		ButtonSize = 22 
	})

	panel:AddControl( "Checkbox", { Label = "Toggle", Command = "particlecontrol_tracer_toggle" } )

	panel:AddControl( "Checkbox", { Label = "Start on?", Command = "particlecontrol_tracer_starton" } )

end