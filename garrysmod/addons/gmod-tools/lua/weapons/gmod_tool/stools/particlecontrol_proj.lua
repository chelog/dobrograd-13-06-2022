TOOL.Category = "Particle Controller"
TOOL.Name = "ParCtrl - Projectiles"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.HighlightedEnt = nil

TOOL.ClientConVar[ "projfx_enabled" ] = "1"
TOOL.ClientConVar[ "projfx_effectname" ] = "Rocket_Smoke"
TOOL.ClientConVar[ "projfx_utileffect_scale" ] = "1"
TOOL.ClientConVar[ "projfx_utileffect_magnitude" ] = "1"
TOOL.ClientConVar[ "projfx_utileffect_radius" ] = "10"
TOOL.ClientConVar[ "projfx_color_enabled" ] = "0"
TOOL.ClientConVar[ "projfx_color_r" ] = "255"
TOOL.ClientConVar[ "projfx_color_g" ] = "20"
TOOL.ClientConVar[ "projfx_color_b" ] = "0"
TOOL.ClientConVar[ "projfx_color_outofone" ] = "0"

TOOL.ClientConVar[ "impactfx_enabled" ] = "1"
TOOL.ClientConVar[ "impactfx_effectname" ] = "!UTILEFFECT!Explosion!FLAG4!"
TOOL.ClientConVar[ "impactfx_utileffect_scale" ] = "1"
TOOL.ClientConVar[ "impactfx_utileffect_magnitude" ] = "1"
TOOL.ClientConVar[ "impactfx_utileffect_radius" ] = "10"
TOOL.ClientConVar[ "impactfx_color_enabled" ] = "0"
TOOL.ClientConVar[ "impactfx_color_r" ] = "255"
TOOL.ClientConVar[ "impactfx_color_g" ] = "20"
TOOL.ClientConVar[ "impactfx_color_b" ] = "0"
TOOL.ClientConVar[ "impactfx_color_outofone" ] = "0"

//TOOL.ClientConVar[ "attachnum" ] = "1"   //we're using the standard tool's attachnum var instead so that the selected attachment stays consistent when swapping between tools
TOOL.ClientConVar[ "repeatrate" ] = "0.80"
TOOL.ClientConVar[ "projmodel" ] = "models/weapons/w_missile.mdl"
TOOL.ClientConVar[ "projmodel_skin" ] = "0"
TOOL.ClientConVar[ "projmodel_attachnum" ] = "1"
TOOL.ClientConVar[ "projmodel_material" ] = ""
TOOL.ClientConVar[ "projmodel_invis" ] = "0"
TOOL.ClientConVar[ "impactfx_effectlifetime" ] = "1.0"

TOOL.ClientConVar[ "projent_spread" ] = "0.04"
TOOL.ClientConVar[ "projent_velocity" ] = "1000"
TOOL.ClientConVar[ "projent_gravity" ] = "0"
TOOL.ClientConVar[ "projent_angle" ] = "0"
TOOL.ClientConVar[ "projent_spin" ] = "0"
TOOL.ClientConVar[ "projent_demomanfix" ] = "0"
TOOL.ClientConVar[ "projent_lifetime_prehit" ] = "10"
TOOL.ClientConVar[ "projent_lifetime_posthit" ] = "0"
TOOL.ClientConVar[ "projent_serverside" ] = "0"

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
	language.Add( "tool.particlecontrol_proj.name", "Adv. Particle Controller - Projectiles" )
	language.Add( "tool.particlecontrol_proj.desc", "Attach projectile effects to things" )
	language.Add( "tool.particlecontrol_proj.help", "Projectile effects launch props that have one particle attached to them, and another particle that plays once they expire, either on impact or on a timer." )

	language.Add( "tool.particlecontrol_proj.left0", "Add a projectile effect to an object" )
	language.Add( "tool.particlecontrol_proj.middle0", "Scroll through an object's attachments" )
	language.Add( "tool.particlecontrol_proj.right0", "Attach a new prop with the projectile effect on it" )
	language.Add( "tool.particlecontrol_proj.reload0", "Remove all projectile effects from an object" )
end

util.PrecacheSound("weapons/pistol/pistol_empty.wav")




function TOOL:LeftClick( trace )

	local projinfo = nil
	if self:GetClientNumber( "projfx_enabled", 0 ) == 1 then
		projinfo = {
			effectname = self:GetClientInfo( "projfx_effectname", 0 ),
			utileffectinfo = Vector( self:GetClientNumber( "projfx_utileffect_scale", 0 ), self:GetClientNumber( "projfx_utileffect_magnitude", 0 ), self:GetClientNumber( "projfx_utileffect_radius", 0 ) ),
		}
		if self:GetClientNumber( "projfx_color_enabled", 0 ) == 1 then
			if self:GetClientNumber( "projfx_color_outofone", 0 ) == 1 then
				projinfo.colorinfo = Color( self:GetClientNumber( "projfx_color_r", 0 ), self:GetClientNumber( "projfx_color_g", 0 ), self:GetClientNumber( "projfx_color_b", 0 ), 1 )  //we're using the alpha value to store color_outofone
			else
				projinfo.colorinfo = Color( self:GetClientNumber( "projfx_color_r", 0 ), self:GetClientNumber( "projfx_color_g", 0 ), self:GetClientNumber( "projfx_color_b", 0 ), 0 )
			end
		end
	end

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

	local attachnum = self:GetOwner():GetInfoNum( "particlecontrol_attachnum", 0 )   //use the standard tool's attachnum var
	local repeatrate = self:GetClientNumber( "repeatrate", 0 )
	local projmodel = self:GetClientInfo( "projmodel", 0 )
	local projmodel_skin = self:GetClientNumber( "projmodel_skin", 0 )
	local projmodel_attachnum = self:GetClientNumber( "projmodel_attachnum", 0 )
	local projmodel_material = self:GetClientInfo( "projmodel_material", 0 )
	local projmodel_invis = self:GetClientNumber( "projmodel_invis", 0 )
	local impactfx_effectlifetime = self:GetClientNumber( "impactfx_effectlifetime", 0 )

	local projent_spread = self:GetClientNumber( "projent_spread", 0 )
	local projent_velocity = self:GetClientNumber( "projent_velocity", 0 )
	local projent_gravity = self:GetClientNumber( "projent_gravity", 0 )
	local projent_angle = self:GetClientNumber( "projent_angle", 0 )
	local projent_spin = self:GetClientNumber( "projent_spin", 0 )
	local projent_demomanfix = self:GetClientNumber( "projent_demomanfix", 0 )
	local projent_lifetime_prehit = self:GetClientNumber( "projent_lifetime_prehit", 0 )
	local projent_lifetime_posthit = self:GetClientNumber( "projent_lifetime_posthit", 0 )
	local projent_serverside = self:GetClientNumber( "projent_serverside", 0 )

	local numpadkey = self:GetClientNumber( "numpadkey", 0 )
	local toggle = self:GetClientNumber( "toggle", 0 )
	local starton = self:GetClientNumber( "starton", 0 )

	local ply = self:GetOwner()



	if ( trace.Entity:IsValid() ) then
		if CLIENT then return true end
		if trace.Entity:GetClass() == "prop_effect" and trace.Entity.AttachedEntity then trace.Entity = trace.Entity.AttachedEntity end
		AttachParticleControllerProj( ply, trace.Entity, { NewTable = { 
			ProjFXInfo = projinfo, 
			ImpactFXInfo = impactinfo, 

			AttachNum = attachnum,
			RepeatRate = repeatrate,
			ProjModel = projmodel,
			ProjModel_Skin = projmodel_skin,
			ProjModel_AttachNum = projmodel_attachnum,
			ProjModel_Material = projmodel_material,
			ProjModel_Invis = projmodel_invis,
			ImpactFX_EffectLifetime = impactfx_effectlifetime,

			ProjEnt_Spread = projent_spread,
			ProjEnt_Velocity = projent_velocity,
			ProjEnt_Gravity = projent_gravity,
			ProjEnt_Angle = projent_angle,
			ProjEnt_Spin = projent_spin,
			ProjEnt_DemomanFix = projent_demomanfix,
			ProjEnt_Lifetime_PreHit = projent_lifetime_prehit,
			ProjEnt_Lifetime_PostHit = projent_lifetime_posthit,
			ProjEnt_Serverside = projent_serverside,

			NumpadKey = numpadkey, 
			Toggle = toggle, 
			StartOn = starton, 
		} } )
		return true
	end

end




function TOOL:RightClick( trace )

	local projinfo = nil
	if self:GetClientNumber( "projfx_enabled", 0 ) == 1 then
		projinfo = {
			effectname = self:GetClientInfo( "projfx_effectname", 0 ),
			utileffectinfo = Vector( self:GetClientNumber( "projfx_utileffect_scale", 0 ), self:GetClientNumber( "projfx_utileffect_magnitude", 0 ), self:GetClientNumber( "projfx_utileffect_radius", 0 ) ),
		}
		if self:GetClientNumber( "projfx_color_enabled", 0 ) == 1 then
			if self:GetClientNumber( "projfx_color_outofone", 0 ) == 1 then
				projinfo.colorinfo = Color( self:GetClientNumber( "projfx_color_r", 0 ), self:GetClientNumber( "projfx_color_g", 0 ), self:GetClientNumber( "projfx_color_b", 0 ), 1 )  //we're using the alpha value to store color_outofone
			else
				projinfo.colorinfo = Color( self:GetClientNumber( "projfx_color_r", 0 ), self:GetClientNumber( "projfx_color_g", 0 ), self:GetClientNumber( "projfx_color_b", 0 ), 0 )
			end
		end
	end

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

	local attachnum = self:GetOwner():GetInfoNum( "particlecontrol_attachnum", 0 )   //use the standard tool's attachnum var
	local repeatrate = self:GetClientNumber( "repeatrate", 0 )
	local projmodel = self:GetClientInfo( "projmodel", 0 )
	local projmodel_skin = self:GetClientNumber( "projmodel_skin", 0 )
	local projmodel_attachnum = self:GetClientNumber( "projmodel_attachnum", 0 )
	local projmodel_material = self:GetClientInfo( "projmodel_material", 0 )
	local projmodel_invis = self:GetClientNumber( "projmodel_invis", 0 )
	local impactfx_effectlifetime = self:GetClientNumber( "impactfx_effectlifetime", 0 )

	local projent_spread = self:GetClientNumber( "projent_spread", 0 )
	local projent_velocity = self:GetClientNumber( "projent_velocity", 0 )
	local projent_gravity = self:GetClientNumber( "projent_gravity", 0 )
	local projent_angle = self:GetClientNumber( "projent_angle", 0 )
	local projent_spin = self:GetClientNumber( "projent_spin", 0 )
	local projent_demomanfix = self:GetClientNumber( "projent_demomanfix", 0 )
	local projent_lifetime_prehit = self:GetClientNumber( "projent_lifetime_prehit", 0 )
	local projent_lifetime_posthit = self:GetClientNumber( "projent_lifetime_posthit", 0 )
	local projent_serverside = self:GetClientNumber( "projent_serverside", 0 )

	local numpadkey = self:GetClientNumber( "numpadkey", 0 )
	local toggle = self:GetClientNumber( "toggle", 0 )
	local starton = self:GetClientNumber( "starton", 0 )

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
		prop:SetCollisionGroup(COLLISION_GROUP_NONE)
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
		AttachParticleControllerProj( ply, prop, { NewTable = { 
			ProjFXInfo = projinfo, 
			ImpactFXInfo = impactinfo, 

			AttachNum = attachnum,
			RepeatRate = repeatrate,
			ProjModel = projmodel,
			ProjModel_Skin = projmodel_skin,
			ProjModel_AttachNum = projmodel_attachnum,
			ProjModel_Material = projmodel_material,
			ProjModel_Invis = projmodel_invis,
			ImpactFX_EffectLifetime = impactfx_effectlifetime,

			ProjEnt_Spread = projent_spread,
			ProjEnt_Velocity = projent_velocity,
			ProjEnt_Gravity = projent_gravity,
			ProjEnt_Angle = projent_angle,
			ProjEnt_Spin = projent_spin,
			ProjEnt_DemomanFix = projent_demomanfix,
			ProjEnt_Lifetime_PreHit = projent_lifetime_prehit,
			ProjEnt_Lifetime_PostHit = projent_lifetime_posthit,
			ProjEnt_Serverside = projent_serverside,

			NumpadKey = numpadkey, 
			Toggle = toggle, 
			StartOn = starton, 
		} } )
		return true
	end

end




function TOOL:Reload( trace )

	if ( trace.Entity:IsValid() ) then
		local fx = false

		if trace.Entity:GetClass() == "prop_effect" and trace.Entity.AttachedEntity then trace.Entity = trace.Entity.AttachedEntity end

		for _, asdf in pairs( ents:GetAll() ) do
			if asdf:GetClass() == "particlecontroller_proj" and asdf:GetParent() == trace.Entity then
				if SERVER then asdf:Remove() end
				fx = true
			end
		end
		if SERVER then
			duplicator.ClearEntityModifier( trace.Entity, "DupeParticleControllerProj" )
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
				local self = get_active_tool(ply, "particlecontrol_proj")
				if not self then return end
			
				return self:ScrollDown(ply:GetEyeTraceNoCursor())
			elseif bind == "invprev" then
				local self = get_active_tool(ply, "particlecontrol_proj")
				if not self then return end

				return self:ScrollUp(ply:GetEyeTraceNoCursor())
			end
		end
	
		if game.SinglePlayer() then -- wtfgarry (have to have a delay in single player or the hook won't get added)
			timer.Simple(5,function() hook.Add( "PlayerBindPress", "particlecontrol_proj_playerbindpress", hookfunc ) end)
		else
			hook.Add( "PlayerBindPress", "particlecontrol_proj_playerbindpress", hookfunc )
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

	local function SpawnParticleControllerProj(ply, ent, DataTable)

		if DataTable == nil or DataTable == {} or DataTable.ProjModel == nil or ent == nil or !IsValid(ent) then return end


		local ParticleControlProj = ents.Create( "particlecontroller_proj" )
		ParticleControlProj:SetPos(ent:GetPos())
		ParticleControlProj:SetAngles(ent:GetAngles())
		ParticleControlProj:SetParent(ent)
		ent:DeleteOnRemove(ParticleControlProj)

		ParticleControlProj:SetTargetEnt(ent)


		if DataTable.ProjFXInfo != nil then
			ParticleControlProj:SetProjFX_EffectName(DataTable.ProjFXInfo.effectname)
			ParticleControlProj:SetProjFX_UtilEffectInfo(DataTable.ProjFXInfo.utileffectinfo)
			if DataTable.ProjFXInfo.colorinfo != nil then
				local projfxcolor = Vector(DataTable.ProjFXInfo.colorinfo.r, DataTable.ProjFXInfo.colorinfo.g, DataTable.ProjFXInfo.colorinfo.b)
				if DataTable.ProjFXInfo.colorinfo.a then
					projfxcolor = projfxcolor / 255
				end
				ParticleControlProj:SetProjFX_ColorInfo( projfxcolor )
			else
				ParticleControlProj:SetProjFX_ColorInfo( Vector(0,0,0) )
			end
		else
			ParticleControlProj:SetProjFX_EffectName("")
		end

		if DataTable.ImpactFXInfo != nil then
			ParticleControlProj:SetImpactFX_EffectName(DataTable.ImpactFXInfo.effectname)
			ParticleControlProj:SetImpactFX_UtilEffectInfo(DataTable.ImpactFXInfo.utileffectinfo)
			if DataTable.ImpactFXInfo.colorinfo != nil then
				local impactfxcolor = Vector(DataTable.ImpactFXInfo.colorinfo.r, DataTable.ImpactFXInfo.colorinfo.g, DataTable.ImpactFXInfo.colorinfo.b)
				if DataTable.ImpactFXInfo.colorinfo.a then
					impactfxcolor = impactfxcolor / 255
				end
				ParticleControlProj:SetImpactFX_ColorInfo( impactfxcolor )
			else
				ParticleControlProj:SetImpactFX_ColorInfo( Vector(0,0,0) )
			end
		else
			ParticleControlProj:SetImpactFX_EffectName("")
		end

		ParticleControlProj:SetAttachNum(DataTable.AttachNum)
		ParticleControlProj:SetRepeatRate(DataTable.RepeatRate)

		ParticleControlProj:SetProjModel(DataTable.ProjModel)
		ParticleControlProj:SetSkin(DataTable.ProjModel_Skin)		//also use the controller ent to store the skin
		ParticleControlProj:SetProjModel_AttachNum(DataTable.ProjModel_AttachNum)
		ParticleControlProj:SetMaterial(DataTable.ProjModel_Material)	//and the material
		ParticleControlProj:SetProjModel_Invis( tobool(DataTable.ProjModel_Invis) )
		ParticleControlProj:SetImpactFX_EffectLifetime(DataTable.ImpactFX_EffectLifetime)

		ParticleControlProj:SetProjEnt_Spread(DataTable.ProjEnt_Spread)
		ParticleControlProj:SetProjEnt_Velocity(DataTable.ProjEnt_Velocity)
		ParticleControlProj:SetProjEnt_Gravity( tobool(DataTable.ProjEnt_Gravity) )
		ParticleControlProj:SetProjEnt_Angle(DataTable.ProjEnt_Angle)
		ParticleControlProj:SetProjEnt_Spin(DataTable.ProjEnt_Spin)
		ParticleControlProj:SetProjEnt_DemomanFix( tobool(DataTable.ProjEnt_DemomanFix) )
		ParticleControlProj:SetProjEnt_Lifetime_PreHit(DataTable.ProjEnt_Lifetime_PreHit)
		ParticleControlProj:SetProjEnt_Lifetime_PostHit(DataTable.ProjEnt_Lifetime_PostHit)
		ParticleControlProj:SetProjEnt_Serverside( tobool(DataTable.ProjEnt_Serverside) )


		ParticleControlProj:SetActive( tobool(DataTable.StartOn) )
		ParticleControlProj:SetToggle( tobool(DataTable.Toggle) )
		ParticleControlProj:SetNumpadKey(DataTable.NumpadKey)

		numpad.OnDown( 	 ply, 	DataTable.NumpadKey, 	"Particle_Press", 	ParticleControlProj )
		numpad.OnUp( 	 ply, 	DataTable.NumpadKey, 	"Particle_Release", 	ParticleControlProj )
		ParticleControlProj:SetNumpadState("")


		ParticleControlProj:Spawn()
		ParticleControlProj:Activate()

	end


	function AttachParticleControllerProj( ply, ent, Data )

		if Data.NewTable then
			SpawnParticleControllerProj(ply, ent, Data.NewTable)

			local dupetable = {}
			if ent.EntityMods and ent.EntityMods.DupeParticleControllerProj then dupetable = ent.EntityMods.DupeParticleControllerProj end
			table.insert(dupetable, Data.NewTable)
			duplicator.StoreEntityModifier( ent, "DupeParticleControllerProj", dupetable )
		return end

	end


	function DupeParticleControllerProj( ply, ent, Data )

		local override = hook.Run('CanTool', ply, { Entity = ent }, 'particlecontrol_proj')
		if override == false then return end

		//due to a problem with the easy bonemerge tool that causes entity modifiers to be applied TWICE, we need to remove the effects that were added the first time
		for _, asdf in pairs( ents:GetAll() ) do
			if asdf:GetClass() == "particlecontroller_proj" and asdf:GetParent() == ent then
				asdf:Remove()
			end
		end

		for _, DataTable in pairs (Data) do
			SpawnParticleControllerProj(ply, ent, DataTable)
		end

	end
	duplicator.RegisterEntityModifier( "DupeParticleControllerProj", DupeParticleControllerProj )

end




//we're still testing out a lot of stuff with the cpanel, so let's add a way to refresh it by reselecting the tool
--[[
TOOL.ClientConVar[ "refresh" ] = 1
function TOOL:Think()
	if SERVER then return end
	if self:GetClientNumber("refresh") == 1 then
		RunConsoleCommand("particlecontrol_proj_refresh", "0");
		//refresh the cpanel
		local panel = controlpanel.Get( "particlecontrol_proj" )
		if ( !panel ) then return end
		panel:ClearControls()
		self.BuildCPanel(panel)
	end
end
function TOOL:Deploy()
	RunConsoleCommand("particlecontrol_proj_refresh", "1");
end
]]

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel(panel)

	panel:AddControl( "Header", { Description = "#tool.particlecontrol_proj.help" } )

	//Presets
	panel:AddControl( "ComboBox", { 
		MenuButton = 1, 
		Folder = "particlecontrol_proj", 
		Options = { 
			//[ "#preset.default" ] = ConVarsDefault
			[ "Example: Generic Rockets" ] = ConVarsDefault,
			[ "Example: TF2 Rockets" ] = { particlecontrol_proj_impactfx_color_b = "0", particlecontrol_proj_impactfx_color_enabled = "0", particlecontrol_proj_impactfx_color_g = "20", particlecontrol_proj_impactfx_color_outofone = "0", particlecontrol_proj_impactfx_color_r = "255", particlecontrol_proj_impactfx_effectlifetime = "1.000000", particlecontrol_proj_impactfx_effectname = "ExplosionCore_Wall", particlecontrol_proj_impactfx_enabled = "1", particlecontrol_proj_impactfx_utileffect_magnitude = "1", particlecontrol_proj_impactfx_utileffect_radius = "10", particlecontrol_proj_impactfx_utileffect_scale = "1", particlecontrol_proj_numpadkey = "52", particlecontrol_proj_projent_angle = "0", particlecontrol_proj_projent_demomanfix = "0", particlecontrol_proj_projent_gravity = "0", particlecontrol_proj_projent_lifetime_posthit = "0.000000", particlecontrol_proj_projent_lifetime_prehit = "10.000000", particlecontrol_proj_projent_serverside = "0", particlecontrol_proj_projent_spin = "0", 
							particlecontrol_proj_projent_spread = "0", particlecontrol_proj_projent_velocity = "1100.000000", particlecontrol_proj_projfx_color_b = "0", particlecontrol_proj_projfx_color_enabled = "0", particlecontrol_proj_projfx_color_g = "20", particlecontrol_proj_projfx_color_outofone = "0", particlecontrol_proj_projfx_color_r = "255", particlecontrol_proj_projfx_effectname = "rockettrail", particlecontrol_proj_projfx_enabled = "1", particlecontrol_proj_projfx_utileffect_magnitude = "1", particlecontrol_proj_projfx_utileffect_radius = "10", particlecontrol_proj_projfx_utileffect_scale = "1", particlecontrol_proj_projmodel = "models/weapons/w_models/w_rocket.mdl", particlecontrol_proj_projmodel_attachnum = "1", particlecontrol_proj_projmodel_invis = "0", particlecontrol_proj_projmodel_skin = "0", particlecontrol_proj_propangle = "2", particlecontrol_proj_propinvis = "0", particlecontrol_proj_propmodel = "models/weapons/w_smg1.mdl", particlecontrol_proj_repeatrate = "0.800000", 
							particlecontrol_proj_starton = "1", particlecontrol_proj_toggle = "1" },
			[ "Example: TF2 Grenades, red" ] = { particlecontrol_proj_impactfx_color_b = "0", particlecontrol_proj_impactfx_color_enabled = "0", particlecontrol_proj_impactfx_color_g = "20", particlecontrol_proj_impactfx_color_outofone = "0", particlecontrol_proj_impactfx_color_r = "255", particlecontrol_proj_impactfx_effectlifetime = "1.000000", particlecontrol_proj_impactfx_effectname = "ExplosionCore_MidAir", particlecontrol_proj_impactfx_enabled = "1", particlecontrol_proj_impactfx_utileffect_magnitude = "1", particlecontrol_proj_impactfx_utileffect_radius = "10", particlecontrol_proj_impactfx_utileffect_scale = "1", particlecontrol_proj_numpadkey = "52", particlecontrol_proj_projent_angle = "0", particlecontrol_proj_projent_demomanfix = "0", particlecontrol_proj_projent_gravity = "1", particlecontrol_proj_projent_lifetime_posthit = "2.300000", particlecontrol_proj_projent_lifetime_prehit = "2.300000", particlecontrol_proj_projent_serverside = "0", particlecontrol_proj_projent_spin = "4", 
							particlecontrol_proj_projent_spread = "0", particlecontrol_proj_projent_velocity = "1217.000000", particlecontrol_proj_projfx_color_b = "0", particlecontrol_proj_projfx_color_enabled = "0", particlecontrol_proj_projfx_color_g = "20", particlecontrol_proj_projfx_color_outofone = "0", particlecontrol_proj_projfx_color_r = "255", particlecontrol_proj_projfx_effectname = "pipebombtrail_red", particlecontrol_proj_projfx_enabled = "1", particlecontrol_proj_projfx_utileffect_magnitude = "1", particlecontrol_proj_projfx_utileffect_radius = "10", particlecontrol_proj_projfx_utileffect_scale = "1", particlecontrol_proj_projmodel = "models/weapons/w_models/w_grenade_grenadelauncher.mdl", particlecontrol_proj_projmodel_attachnum = "0", particlecontrol_proj_projmodel_invis = "0", particlecontrol_proj_projmodel_skin = "0", particlecontrol_proj_propangle = "2", particlecontrol_proj_propinvis = "0", particlecontrol_proj_propmodel = "models/weapons/w_smg1.mdl", particlecontrol_proj_repeatrate = "0.600000", 
							particlecontrol_proj_starton = "1", particlecontrol_proj_toggle = "1" },
			[ "Example: TF2 Grenades, blue" ] = { particlecontrol_proj_impactfx_color_b = "0", particlecontrol_proj_impactfx_color_enabled = "0", particlecontrol_proj_impactfx_color_g = "20", particlecontrol_proj_impactfx_color_outofone = "0", particlecontrol_proj_impactfx_color_r = "255", particlecontrol_proj_impactfx_effectlifetime = "1.000000", particlecontrol_proj_impactfx_effectname = "ExplosionCore_MidAir", particlecontrol_proj_impactfx_enabled = "1", particlecontrol_proj_impactfx_utileffect_magnitude = "1", particlecontrol_proj_impactfx_utileffect_radius = "10", particlecontrol_proj_impactfx_utileffect_scale = "1", particlecontrol_proj_numpadkey = "52", particlecontrol_proj_projent_angle = "0", particlecontrol_proj_projent_demomanfix = "0", particlecontrol_proj_projent_gravity = "1", particlecontrol_proj_projent_lifetime_posthit = "2.300000", particlecontrol_proj_projent_lifetime_prehit = "2.300000", particlecontrol_proj_projent_serverside = "0", particlecontrol_proj_projent_spin = "4", 
							particlecontrol_proj_projent_spread = "0", particlecontrol_proj_projent_velocity = "1217.000000", particlecontrol_proj_projfx_color_b = "0", particlecontrol_proj_projfx_color_enabled = "0", particlecontrol_proj_projfx_color_g = "20", particlecontrol_proj_projfx_color_outofone = "0", particlecontrol_proj_projfx_color_r = "255", particlecontrol_proj_projfx_effectname = "pipebombtrail_blue", particlecontrol_proj_projfx_enabled = "1", particlecontrol_proj_projfx_utileffect_magnitude = "1", particlecontrol_proj_projfx_utileffect_radius = "10", particlecontrol_proj_projfx_utileffect_scale = "1", particlecontrol_proj_projmodel = "models/weapons/w_models/w_grenade_grenadelauncher.mdl", particlecontrol_proj_projmodel_attachnum = "0", particlecontrol_proj_projmodel_invis = "0", particlecontrol_proj_projmodel_skin = "1", particlecontrol_proj_propangle = "2", particlecontrol_proj_propinvis = "0", particlecontrol_proj_propmodel = "models/weapons/w_smg1.mdl", particlecontrol_proj_repeatrate = "0.600000", 
							particlecontrol_proj_starton = "1", particlecontrol_proj_toggle = "1" },
		}, 
		CVars = table.GetKeys( ConVarsDefault ) 
	} )



	panel:AddControl( "Checkbox", { Label = "Enable projectile effects?", Command = "particlecontrol_proj_projfx_enabled" } )

	AddParticleBrowser(panel, { 
		name = "Projectile Effect", 
		commands = { 
			effectname = "particlecontrol_proj_projfx_effectname", 
			color = "particlecontrol_proj_projfx_color",
			utileffect = "particlecontrol_proj_projfx_utileffect",

			enabled = "particlecontrol_proj_projfx_enabled",
		}, 
	})

	panel:AddControl( "Checkbox", { Label = "Enable impact/expire effects?", Command = "particlecontrol_proj_impactfx_enabled" } )

	AddParticleBrowser(panel, { 
		name = "Impact/Expire Effect", 
		commands = { 
			effectname = "particlecontrol_proj_impactfx_effectname", 
			color = "particlecontrol_proj_impactfx_color",
			utileffect = "particlecontrol_proj_impactfx_utileffect",

			enabled = "particlecontrol_proj_impactfx_enabled",
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
	panel:ControlHelp( "Attachment point on the model to fire projectiles from. Set to 0 to fire from the model origin." )

	panel:AddControl("Slider", {
		Label = "Repeat Rate",
	 	Type = "Float",
		Min = "0",
		Max = "1",
		Command = "particlecontrol_proj_repeatrate"
	})
	panel:ControlHelp( "How often the projectile fires. Set to 0 to not repeat." )



	panel:AddControl( "Label", { Text = "" }  )
	panel:AddControl( "Label", { Text = "" }  )



	local projmodellist = { Label = "Projectile Model:", ConVar = "particlecontrol_proj_projmodel", Category = "Projectile Model", Height = 1, Models = {} }
	projmodellist.Models["models/hunter/plates/plate.mdl"] = {}
	projmodellist.Models["models/weapons/w_missile.mdl"] = {}
	projmodellist.Models["models/weapons/w_models/w_rocket.mdl"] = {}
	projmodellist.Models["models/weapons/w_models/w_grenade_grenadelauncher.mdl"] = {}

	panel:AddControl( "PropSelect", projmodellist )

	local projmodelentry = vgui.Create( "DTextEntry", panel )
	projmodelentry:SetConVar( "particlecontrol_proj_projmodel" )
	panel:AddItem(projmodelentry)

	panel:AddControl("Slider", {
		Label = "Projectile Skin",
	 	Type = "Integer",
		Min = "0",
		Max = "10",
		Command = "particlecontrol_proj_projmodel_skin",
	})

	panel:AddControl("Slider", {
		Label = "Projectile Attachment",
	 	Type = "Integer",
		Min = "0",
		Max = "10",
		Command = "particlecontrol_proj_projmodel_attachnum",
	})
	panel:ControlHelp( "Attachment point on the projectile to attach the effect to. Set to 0 to attach to model origin." )

	panel:AddControl("TextBox", {
		Label = "Projectile Material", 
		Description = "", 
		MaxLength = 255, 
		Text = "", 
		Command = "particlecontrol_proj_projmodel_material", 
	})

	panel:AddControl( "Checkbox", { Label = "Invisible projectiles (particles only)", Command = "particlecontrol_proj_projmodel_invis" } )



	panel:AddControl( "Label", { Text = "" }  )
	panel:AddControl( "Label", { Text = "" }  )



	panel:AddControl("Slider", {
		Label = "Projectile Spread",
	 	Type = "Float",
		Min = "0",
		Max = "1",
		Command = "particlecontrol_proj_projent_spread"
	})
	panel:ControlHelp( "Each unit is 90 degrees of spread - you can type in 2 for 180 degrees or even 4 for 360 degrees." )

	panel:AddControl("Slider", {
		Label = "Projectile Velocity",
	 	Type = "Float",
		Min = "0",
		Max = "3000",
		Command = "particlecontrol_proj_projent_velocity"
	})
	//panel:ControlHelp( "" )

	panel:AddControl( "Checkbox", { Label = "Projectile Gravity", Command = "particlecontrol_proj_projent_gravity" } )

	panel:AddControl( "ComboBox",  {
		Label = "Projectile Angle", 
		MenuButton = "0", 
		Options = {
			["Forward"] = { particlecontrol_proj_projent_angle = 0 },
			["Left"] = { particlecontrol_proj_projent_angle = 1 },
			["Right"] = { particlecontrol_proj_projent_angle = 2 },
			["Up"] = { particlecontrol_proj_projent_angle = 3 },
			["Down"] = { particlecontrol_proj_projent_angle = 4 },
			["Back"] = { particlecontrol_proj_projent_angle = 5 },
		}
	})

	panel:AddControl( "ComboBox",  {
		Label = "Projectile Spin", 
		MenuButton = "0", 
		Options = {
			["Don't spin"] = { particlecontrol_proj_projent_spin = 0 },
			["Spin pitch"] = { particlecontrol_proj_projent_spin = 1 },
			["Spin yaw"] = { particlecontrol_proj_projent_spin = 2 },
			["Spin roll"] = { particlecontrol_proj_projent_spin = 3 },
			["Spin random"] = { particlecontrol_proj_projent_spin = 4 },
		}
	})

	panel:AddControl( "Checkbox", { Label = "Demoman Weapon Fix", Command = "particlecontrol_proj_projent_demomanfix" } )
	panel:ControlHelp( "Demoman weapon props have their muzzle attachment at an angle for some reason. Use this to fix it." )

	panel:AddControl("Slider", {
		Label = "Lifetime",
	 	Type = "Float",
		Min = "0",
		Max = "10",
		Command = "particlecontrol_proj_projent_lifetime_prehit"
	})
	panel:ControlHelp( "How long projectiles last after being launched." )

	panel:AddControl("Slider", {
		Label = "Lifetime (after impact)",
	 	Type = "Float",
		Min = "0",
		Max = "10",
		Command = "particlecontrol_proj_projent_lifetime_posthit"
	})
	panel:ControlHelp( "How long projectiles last after hitting something. Set to 0 to expire on impact." )  
	panel:AddControl( "Checkbox", { Label = "Serverside projectiles?", Command = "particlecontrol_proj_projent_serverside" } )
	panel:ControlHelp( "Use serverside props for projectiles. These will collide properly with everything instead of passing through, but they'll also put a lot more stress on the game (meaning more lag), and they'll show up in the wrong spot if bonemerged. Only turn this on if you need it." )

	panel:AddControl("Slider", {
		Label = "Impact Effect Lifetime",
	 	Type = "Float",
		Min = "0.5",
		Max = "5",
		Command = "particlecontrol_proj_impactfx_effectlifetime"
	})
	//panel:ControlHelp( "Number of seconds before impact effects are removed." )



	panel:AddControl( "Label", { Text = "" }  )
	panel:AddControl( "Label", { Text = "" }  )



	local modellist = { Label = "Prop:", ConVar = "particlecontrol_proj_propmodel", Category = "Prop", Height = 1, Models = {} }
	modellist.Models["models/hunter/plates/plate025x025.mdl"] = {}
	modellist.Models["models/hunter/plates/plate.mdl"] = {}
	modellist.Models["models/weapons/w_smg1.mdl"] = {}
	modellist.Models["models/weapons/w_models/w_rocketlauncher.mdl"] = {}

	panel:AddControl( "PropSelect", modellist )

	panel:AddControl( "ComboBox",  {
		Label = "Prop Angle", 
		MenuButton = "0", 
		Options = {
			["Spawn upright"] = { particlecontrol_proj_propangle = "1" },
			["Spawn at surface angle"] = { particlecontrol_proj_propangle = "2" }
		}
	})

	panel:AddControl( "Checkbox", { Label = "Invisible prop (particles only)", Command = "particlecontrol_proj_propinvis" } )



	panel:AddControl( "Label", { Text = "" }  )
	panel:AddControl( "Label", { Text = "" }  )



	panel:AddControl( "Numpad", {
		Label = "Effect Key",
		Command = "particlecontrol_proj_numpadkey",
		ButtonSize = 22 
	})

	panel:AddControl( "Checkbox", { Label = "Toggle", Command = "particlecontrol_proj_toggle" } )

	panel:AddControl( "Checkbox", { Label = "Start on?", Command = "particlecontrol_proj_starton" } )

end