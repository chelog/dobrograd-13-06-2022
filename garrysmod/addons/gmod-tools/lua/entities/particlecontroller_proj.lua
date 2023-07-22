AddCSLuaFile()

ENT.Base 			= "base_gmodentity"
ENT.PrintName			= "Particle Controller - Projectile"
ENT.Author			= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup			= RENDERGROUP_NONE




function ENT:SetupDataTables()

	self:NetworkVar( "Entity", 0, 	"TargetEnt" );


	self:NetworkVar( "String", 0, 	"ProjFX_EffectName" );
	self:NetworkVar( "Vector", 0, 	"ProjFX_UtilEffectInfo" );  //x = scale, y = magnitude, x = radius
	self:NetworkVar( "Vector", 1, 	"ProjFX_ColorInfo" );

	self:NetworkVar( "String", 1, 	"ImpactFX_EffectName" );
	self:NetworkVar( "Vector", 2, 	"ImpactFX_UtilEffectInfo" );  //x = scale, y = magnitude, x = radius
	self:NetworkVar( "Vector", 3, 	"ImpactFX_ColorInfo" );

	self:NetworkVar( "Int", 0, 	"AttachNum" );
	self:NetworkVar( "Float", 0, 	"RepeatRate" );

	self:NetworkVar( "String", 2, 	"ProjModel" );
	self:NetworkVar( "Int", 1, 	"ProjModel_AttachNum" );
	self:NetworkVar( "Bool", 0, 	"ProjModel_Invis" );
	self:NetworkVar( "Float", 1, 	"ImpactFX_EffectLifetime" );

	self:NetworkVar( "Float", 2, 	"ProjEnt_Spread" );
	self:NetworkVar( "Int", 2, 	"ProjEnt_Velocity" );
	self:NetworkVar( "Bool", 1, 	"ProjEnt_Gravity" );
	self:NetworkVar( "Int", 3, 	"ProjEnt_Angle" );
	self:NetworkVar( "Int", 4, 	"ProjEnt_Spin" );
	self:NetworkVar( "Bool", 2, 	"ProjEnt_DemomanFix" );
	self:NetworkVar( "Float", 3, 	"ProjEnt_Lifetime_PreHit" );
	self:NetworkVar( "Float", 4, 	"ProjEnt_Lifetime_PostHit" );
	self:NetworkVar( "Bool", 3, 	"ProjEnt_Serverside" );


	self:NetworkVar( "Bool", 4, 	"Active" );
	self:NetworkVar( "Bool", 5, 	"Toggle" );
	self:NetworkVar( "Int", 5, 	"NumpadKey" );
	self:NetworkVar( "String", 3, 	"NumpadState" );

end




function ENT:Initialize()

	util.PrecacheModel(self:GetProjModel())
	local target = self:GetTargetEnt()


	if SERVER then

		//Use ourselves as the target - we'll fire projectiles from our own position and angles
		local attachment1 = target:GetAttachment( self:GetAttachNum() )
		if attachment1 != nil then
			self:SetPos( attachment1.Pos )
			self:SetAngles( attachment1.Ang )
			self:Fire("setparentattachment", target:GetAttachments()[self:GetAttachNum()].name, 0.01)
			self:SetTargetEnt(self)
		end

	else

		//Set things up for a particlesystem effect

		local projfx_effectname = self:GetProjFX_EffectName()
		if projfx_effectname != "" and !string.StartWith( projfx_effectname, "!UTILEFFECT!" ) then
			PrecacheParticleSystem(projfx_effectname)
		end

		local impactfx_effectname = self:GetImpactFX_EffectName()
		if impactfx_effectname != "" and !string.StartWith( impactfx_effectname, "!UTILEFFECT!" ) then
			PrecacheParticleSystem(impactfx_effectname)
		end

	end
	//super niche bug fix: if we're in multiplayer and our model has any attachment points, then we'll cause visual jittering in the buildbonepositions callback of
	//the entity we're parented to. originally we were using our own model to store the projectile model, but that was causing the aforementioned bug, so now we're
	//storing the projectile model separately and having this entity use a neutral model that won't cause problems.
	self:SetModel("models/hunter/plates/plate.mdl")
	self:SetNoDraw(true)


	//Don't let players set the repeat rate to a really low amount that lets them spam tons of props every second
	if self:GetRepeatRate() > 0 and self:GetRepeatRate() < 0.1 then self:SetRepeatRate(0.1) end

	if self:GetRepeatRate() > 0 then
		//we're going to be repeating the effect, so let's set that up and let think do the rest
		self.NextRepeat = 0
	else
		//we won't be repeating the effect, so just attach it right now
		if self:GetActive() then self:AttachParticle() end
	end

end




function ENT:Think()

	if self:GetProjEnt_Serverside() then
		if CLIENT then return end
	else
		if SERVER then return end
	end

	if self:GetNumpadState() == "off" then
		//MsgN("turn off")
		self:SetNumpadState("")
	end

	if self:GetNumpadState() == "on" then
		//MsgN("turn on")
		self:SetNumpadState("")
		if self:GetRepeatRate() > 0 then
			//we're going to be repeating the effect, so let's set that up and let think do the rest
			self.NextRepeat = 0
		else
			//we won't be repeating the effect, so just attach it right now
			if self:GetActive() then self:AttachParticle() end
		end
	end


	if self:GetActive() == true and self:GetRepeatRate() > 0 then
		if !( self.NextRepeat > CurTime() ) then
			self:AttachParticle()
			self.NextRepeat = CurTime() + self:GetRepeatRate()
		end
	end

	self:NextThink(CurTime())
	return true

end




function ENT:AttachParticle()

	if !self then return end

	if self:GetProjEnt_Serverside() then
		if CLIENT then return end
	else
		if SERVER then return end
	end

	local projent_spread		= math.Clamp( self:GetProjEnt_Spread(), 0, 4)
	local projent_velocity		= self:GetProjEnt_Velocity()
	local projent_gravity		= self:GetProjEnt_Gravity()
	local projent_angle		= self:GetProjEnt_Angle()
	local projent_spin		= self:GetProjEnt_Spin()
	local projent_demomanfix	= self:GetProjEnt_DemomanFix()
	local projent_lifetime_prehit	= math.Clamp( self:GetProjEnt_Lifetime_PreHit(), 0, 10)
	local projent_lifetime_posthit	= math.Clamp( self:GetProjEnt_Lifetime_PostHit(), 0, 10)

	local projfx_effectname		= self:GetProjFX_EffectName()
	local projmodel_attachnum	= self:GetProjModel_AttachNum()

	local impactfx_effectname	= self:GetImpactFX_EffectName()
	local impactfx_effectlifetime	= math.Clamp( self:GetImpactFX_EffectLifetime(), 0, 10)
	local impactfx_utileffectinfo	= self:GetImpactFX_UtilEffectInfo()
	local impactfx_colorinfo	= self:GetImpactFX_ColorInfo()



	//Create the projectile entity
	local proj = nil
	if SERVER then
		proj = ents.Create("parctrl_dummyent")
		proj:SetModel(self:GetProjModel())
	end
	if CLIENT then
		proj = octolib.createDummy(self:GetProjModel())
	end

	if !util.IsValidProp(self:GetProjModel()) then
		proj:PhysicsInitBox(proj:GetModelBounds())
	else
		proj:PhysicsInit(SOLID_VPHYSICS)
	end
	proj:GetPhysicsObject():Wake()

	proj:SetNoDraw(self:GetProjModel_Invis())
	proj:SetSkin(self:GetSkin())
	proj:SetMaterial(self:GetMaterial())
	proj:SetPos(self:GetPos())


	proj:Spawn()
	proj:Activate()
	local projphys = proj:GetPhysicsObject()

	local selfang = self:GetAngles()
	//a lot of attachment points are oriented at an angle on the roll axis - correct this, we want the default projectile angle to be upright
	if self:GetParent() != NULL then  //this returns a null entity if the player is outside of the visleaf, be careful
		if self:GetParent():GetAttachment( self:GetAttachNum() ) then
			local _, attachang = WorldToLocal(self:GetPos(), selfang, self:GetParent():GetPos(), self:GetParent():GetAngles())
			selfang = Angle(selfang.p,selfang.y,selfang.r - attachang.r)
		end
	end
	//muzzle attachments on demoman weapons are oriented 90 degrees to the side for some reason - give players an option to fix this
	if projent_demomanfix == true then selfang:RotateAroundAxis( selfang:Up(), -90 ) end

	//spread
	local projang = Angle(selfang.p,selfang.y,selfang.r)  //self:GetAngles()
	local randang = AngleRand()
	projang:RotateAroundAxis( projang:Forward(), randang.r )
	projang:RotateAroundAxis( projang:Right(), randang.p * (projent_spread / 2) )
	projang:RotateAroundAxis( projang:Up(), randang.y * (projent_spread / 4) )
	//set the velocity
	projphys:SetVelocity(projang:Forward() * projent_velocity)
	//now de-randomize the roll - we only needed to do that for the velocity
	projang:RotateAroundAxis( projang:Forward(), -randang.r )

	//change the angle of the projectile
	local rotationang = Angle(0,0,0)
	//0 = forward, don't change it
	//1 = left
	if projent_angle == 1 then projang:RotateAroundAxis( projang:Up(), 90 ) rotationang = Angle(0,-90,0)
	//2 = right
	elseif projent_angle == 2 then projang:RotateAroundAxis( projang:Up(), -90 ) rotationang = Angle(0,90,0)
	//3 = up
	elseif projent_angle == 3 then projang:RotateAroundAxis( projang:Right(), 90 ) rotationang = Angle(90,0,0)
	//4 = down
	elseif projent_angle == 4 then projang:RotateAroundAxis( projang:Right(), -90 ) rotationang = Angle(-90,0,0)
	//5 = back
	elseif projent_angle == 5 then projang:RotateAroundAxis( projang:Up(), 180 ) rotationang = Angle(0,180,0) end
	proj:SetAngles(projang)

	//add spin - spin should be the same regardless of which way we've oriented the prop with projent_angle
	//0 - don't spin
	//1 - spin pitch
	if projent_spin == 1 then projphys:AddAngleVelocity( rotationang:Right() * -350 )
	//2 - spin yaw
	elseif projent_spin == 2 then projphys:AddAngleVelocity( rotationang:Forward() * 350 )
	//3 - spin roll
	elseif projent_spin == 3 then projphys:AddAngleVelocity( rotationang:Up() * -350 )
	//4 - spin random
	elseif projent_spin == 4 then projphys:AddAngleVelocity( VectorRand() * -350 ) end

	projphys:EnableGravity(projent_gravity)
	projphys:SetMaterial("gmod_silent")   //don't play physics sounds
	proj:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)   //don't collide with other projectiles
	proj:SetOwner(self:GetParent())   //don't collide with the prop that the effect ent is parented to
	if SERVER then self:DeleteOnRemove(proj) end   //delete the proj if the effect ent is removed - i'd love to do this for clientside projs too but this function is serverside only



	//Create the projectile effect, if enabled
	if projfx_effectname != "" then

		local projfxent = proj

		if SERVER then
			//since we can't call util.Effect or CreateParticleEffect on the server, we have to get the ent to do it itself
			projfxent:SetEffectName(projfx_effectname)
			projfxent:SetColorInfo(self:GetProjFX_ColorInfo())
			projfxent:SetUtilEffectInfo(self:GetProjFX_UtilEffectInfo())
			projfxent:SetAttachNum(projmodel_attachnum)
		end
		if CLIENT then
			if string.StartWith( projfx_effectname, "!UTILEFFECT!" ) then

				//Create a util effect

				//Unfortunately, we have to do all of this every single time the effect repeats, because if we do it in Initialize instead, a whole bunch of stuff doesn't work properly

				local effectscale = self:GetProjFX_UtilEffectInfo().x
				local effectmagnitude = self:GetProjFX_UtilEffectInfo().y
				local effectradius = self:GetProjFX_UtilEffectInfo().z

				local projeffectdata = EffectData()
				projeffectdata:SetEntity( projfxent )
				//if ( string.find(projfx_effectname, "Tracer", 0, true) != nil ) then projeffectdata:SetScale(5000) else projeffectdata:SetScale( effectscale ) end  //for tracer effects, scale is the speed of the bullet, so we need to keep this high; useless for a projectile effect
				projeffectdata:SetScale( effectscale )
				projeffectdata:SetMagnitude( effectmagnitude )
				projeffectdata:SetRadius(effectradius )

				//flags can be set by typing !FLAG#! at the end of the effect name
				projeffectdata:SetFlags( 0 )
				if string.EndsWith( projfx_effectname, "!" ) then
					if string.find( projfx_effectname, "!FLAG1!" ) then projeffectdata:SetFlags( 1 ) projfx_effectname = string.Replace( projfx_effectname, "!FLAG1!", "" ) end
					if string.find( projfx_effectname, "!FLAG2!" ) then projeffectdata:SetFlags( 2 ) projfx_effectname = string.Replace( projfx_effectname, "!FLAG2!", "" ) end
					if string.find( projfx_effectname, "!FLAG3!" ) then projeffectdata:SetFlags( 3 ) projfx_effectname = string.Replace( projfx_effectname, "!FLAG3!", "" ) end
					if string.find( projfx_effectname, "!FLAG4!" ) then projeffectdata:SetFlags( 4 ) projfx_effectname = string.Replace( projfx_effectname, "!FLAG4!", "" ) end
					if string.find( projfx_effectname, "!FLAG5!" ) then projeffectdata:SetFlags( 5 ) projfx_effectname = string.Replace( projfx_effectname, "!FLAG5!", "" ) end
					if string.find( projfx_effectname, "!FLAG6!" ) then projeffectdata:SetFlags( 6 ) projfx_effectname = string.Replace( projfx_effectname, "!FLAG6!", "" ) end
					if string.find( projfx_effectname, "!FLAG7!" ) then projeffectdata:SetFlags( 7 ) projfx_effectname = string.Replace( projfx_effectname, "!FLAG7!", "" ) end
					if string.find( projfx_effectname, "!FLAG8!" ) then projeffectdata:SetFlags( 8 ) projfx_effectname = string.Replace( projfx_effectname, "!FLAG8!", "" ) end
					if string.find( projfx_effectname, "!FLAG9!" ) then projeffectdata:SetFlags( 9 ) projfx_effectname = string.Replace( projfx_effectname, "!FLAG9!", "" ) end
				end

				//colors can also be set the same way
				projeffectdata:SetColor(0)
				if string.EndsWith( projfx_effectname, "!" ) then
					if string.find( projfx_effectname, "!COLOR1!" ) then projeffectdata:SetColor( 1 ) projfx_effectname = string.Replace( projfx_effectname, "!COLOR1!", "" ) end
					if string.find( projfx_effectname, "!COLOR2!" ) then projeffectdata:SetColor( 2 ) projfx_effectname = string.Replace( projfx_effectname, "!COLOR2!", "" ) end
					if string.find( projfx_effectname, "!COLOR3!" ) then projeffectdata:SetColor( 3 ) projfx_effectname = string.Replace( projfx_effectname, "!COLOR3!", "" ) end
					if string.find( projfx_effectname, "!COLOR4!" ) then projeffectdata:SetColor( 4 ) projfx_effectname = string.Replace( projfx_effectname, "!COLOR4!", "" ) end
					if string.find( projfx_effectname, "!COLOR5!" ) then projeffectdata:SetColor( 5 ) projfx_effectname = string.Replace( projfx_effectname, "!COLOR5!", "" ) end
					if string.find( projfx_effectname, "!COLOR6!" ) then projeffectdata:SetColor( 6 ) projfx_effectname = string.Replace( projfx_effectname, "!COLOR6!", "" ) end
					if string.find( projfx_effectname, "!COLOR7!" ) then projeffectdata:SetColor( 7 ) projfx_effectname = string.Replace( projfx_effectname, "!COLOR7!", "" ) end
					if string.find( projfx_effectname, "!COLOR8!" ) then projeffectdata:SetColor( 8 ) projfx_effectname = string.Replace( projfx_effectname, "!COLOR8!", "" ) end
					if string.find( projfx_effectname, "!COLOR9!" ) then projeffectdata:SetColor( 9 ) projfx_effectname = string.Replace( projfx_effectname, "!COLOR9!", "" ) end
				end

				//dumb situational crap
				if string.find( string.lower(projfx_effectname), "shakeropes" ) then projeffectdata:SetMagnitude( effectmagnitude * 20 ) end
				if string.find( string.lower(projfx_effectname), "thumperdust" ) then projeffectdata:SetScale( effectscale * 50 ) end
				if string.find( string.lower(projfx_effectname), "bloodspray" ) then projeffectdata:SetScale( effectscale * 4 ) end

				//just in case someone makes a utileffect that works as a projectile effect
				if projfxent:GetAttachment(projmodel_attachnum) != nil then
					projeffectdata:SetStart( projfxent:GetAttachment( projmodel_attachnum ).Pos )
					projeffectdata:SetOrigin( projfxent:GetAttachment( projmodel_attachnum ).Pos )
					projeffectdata:SetAngles( projfxent:GetAttachment( projmodel_attachnum ).Ang )
					projeffectdata:SetNormal( projfxent:GetAttachment( projmodel_attachnum ).Ang:Forward() )
				else
					projeffectdata:SetStart( projfxent:GetPos() )
					projeffectdata:SetOrigin( projfxent:GetPos() )
					projeffectdata:SetAngles( projfxent:GetAngles() )
					projeffectdata:SetNormal( projfxent:GetAngles():Forward() )
				end

				util.Effect( string.Replace( projfx_effectname, "!UTILEFFECT!", "" ), projeffectdata )

			else

				//Create a particlesystem effect

				//Since we can't specify attachment points with Entity:CreateParticleEffect(), create an entity there to use as a target
				local attachment1 = proj:GetAttachment( projmodel_attachnum )
				if attachment1 != nil then
					//if SERVER then
					//	projfxent = ents.Create("parctrl_dummyent")
					//	projfxent:SetModel("models/hunter/plates/plate.mdl")
					//end
					if CLIENT then
						projfxent = octolib.createDummy("models/hunter/plates/plate.mdl")
					end

					projfxent:SetParent(proj, projmodel_attachnum - 1)
					projfxent:SetPos( attachment1.Pos )
					projfxent:SetAngles( attachment1.Ang )
					projfxent:SetNoDraw(true)

					projfxent:Spawn()
					projfxent:Activate()

					proj:CallOnRemove("RemoveProjFX", function() if IsValid(projfxent) then projfxent:Remove() end end)
				end


				local clrtb = nil
				if self:GetProjFX_ColorInfo() == Vector(0,0,0) then
					//MsgN("color = false")
				else
					//MsgN("color = true")
					clrtb = { position = self:GetProjFX_ColorInfo() }
				end
				local projcpointtable = {}
					projcpointtable[1] = { entity = projfxent, attachtype = PATTACH_ABSORIGIN_FOLLOW }

					for i = 2, 64 do
 						if clrtb then
							projcpointtable[i] = clrtb
						else
							projcpointtable[i] = projcpointtable[1]
						end
					end

				projfxent:CreateParticleEffect(projfx_effectname,projcpointtable)

			end
		end
	end



	local function projexpire(ent, pos, ang)

		//Create the impact effect, if enabled
		if impactfx_effectname != "" then

			//Create a new entity to attach the impact effect to - we can't use proj since we're removing it immediately after this
			local impactfxent = nil
			if SERVER then
				impactfxent = ents.Create("parctrl_dummyent")
				impactfxent:SetModel("models/hunter/plates/plate.mdl")
			end
			if CLIENT then
				impactfxent = octolib.createDummy("models/hunter/plates/plate.mdl")
			end
			impactfxent:SetPos( pos or proj:GetPos() )
			impactfxent:SetAngles( ang or proj:GetAngles() )
			impactfxent:SetNoDraw(true)
			timer.Simple(impactfx_effectlifetime, function() if IsValid(impactfxent) then impactfxent:Remove() end; end)
			impactfxent:Spawn()
			impactfxent:Activate()

			if SERVER then
				//since we can't call util.Effect or CreateParticleEffect on the server, we have to get the ent to do it itself
				impactfxent:SetEffectName(impactfx_effectname)
				impactfxent:SetColorInfo(impactfx_colorinfo)
				impactfxent:SetUtilEffectInfo(impactfx_utileffectinfo)
				impactfxent:SetAttachNum(0)
			end
			if CLIENT then
				if string.StartWith( impactfx_effectname, "!UTILEFFECT!" ) then

					//Create a util effect

					//Unfortunately, we have to do all of this every single time the effect repeats, because if we do it in Initialize instead, a whole bunch of stuff doesn't work properly

					local effectscale = impactfx_utileffectinfo.x
					local effectmagnitude = impactfx_utileffectinfo.y
					local effectradius = impactfx_utileffectinfo.z

					local impacteffectdata = EffectData()
					impacteffectdata:SetEntity(impactfxent)
					//if ( string.find(impactfx_effectname, "Tracer", 0, true) != nil ) then impacteffectdata:SetScale(5000) else impacteffectdata:SetScale(effectscale) end  //for tracer effects, scale is the speed of the bullet, so we need to keep this high; useless for an impact effect
					impacteffectdata:SetScale(effectscale)
					impacteffectdata:SetMagnitude(effectmagnitude)
					impacteffectdata:SetRadius(effectradius)

					//flags can be set by typing !FLAG#! at the end of the effect name
					impacteffectdata:SetFlags( 0 )
					if string.EndsWith( impactfx_effectname, "!" ) then
						if string.find( impactfx_effectname, "!FLAG1!" ) then impacteffectdata:SetFlags( 1 ) impactfx_effectname = string.Replace( impactfx_effectname, "!FLAG1!", "" ) end
						if string.find( impactfx_effectname, "!FLAG2!" ) then impacteffectdata:SetFlags( 2 ) impactfx_effectname = string.Replace( impactfx_effectname, "!FLAG2!", "" ) end
						if string.find( impactfx_effectname, "!FLAG3!" ) then impacteffectdata:SetFlags( 3 ) impactfx_effectname = string.Replace( impactfx_effectname, "!FLAG3!", "" ) end
						if string.find( impactfx_effectname, "!FLAG4!" ) then impacteffectdata:SetFlags( 4 ) impactfx_effectname = string.Replace( impactfx_effectname, "!FLAG4!", "" ) end
						if string.find( impactfx_effectname, "!FLAG5!" ) then impacteffectdata:SetFlags( 5 ) impactfx_effectname = string.Replace( impactfx_effectname, "!FLAG5!", "" ) end
						if string.find( impactfx_effectname, "!FLAG6!" ) then impacteffectdata:SetFlags( 6 ) impactfx_effectname = string.Replace( impactfx_effectname, "!FLAG6!", "" ) end
						if string.find( impactfx_effectname, "!FLAG7!" ) then impacteffectdata:SetFlags( 7 ) impactfx_effectname = string.Replace( impactfx_effectname, "!FLAG7!", "" ) end
						if string.find( impactfx_effectname, "!FLAG8!" ) then impacteffectdata:SetFlags( 8 ) impactfx_effectname = string.Replace( impactfx_effectname, "!FLAG8!", "" ) end
						if string.find( impactfx_effectname, "!FLAG9!" ) then impacteffectdata:SetFlags( 9 ) impactfx_effectname = string.Replace( impactfx_effectname, "!FLAG9!", "" ) end
					end

					//colors can also be set the same way
					impacteffectdata:SetColor(0)
					if string.EndsWith( impactfx_effectname, "!" ) then
						if string.find( impactfx_effectname, "!COLOR1!" ) then impacteffectdata:SetColor( 1 ) impactfx_effectname = string.Replace( impactfx_effectname, "!COLOR1!", "" ) end
						if string.find( impactfx_effectname, "!COLOR2!" ) then impacteffectdata:SetColor( 2 ) impactfx_effectname = string.Replace( impactfx_effectname, "!COLOR2!", "" ) end
						if string.find( impactfx_effectname, "!COLOR3!" ) then impacteffectdata:SetColor( 3 ) impactfx_effectname = string.Replace( impactfx_effectname, "!COLOR3!", "" ) end
						if string.find( impactfx_effectname, "!COLOR4!" ) then impacteffectdata:SetColor( 4 ) impactfx_effectname = string.Replace( impactfx_effectname, "!COLOR4!", "" ) end
						if string.find( impactfx_effectname, "!COLOR5!" ) then impacteffectdata:SetColor( 5 ) impactfx_effectname = string.Replace( impactfx_effectname, "!COLOR5!", "" ) end
						if string.find( impactfx_effectname, "!COLOR6!" ) then impacteffectdata:SetColor( 6 ) impactfx_effectname = string.Replace( impactfx_effectname, "!COLOR6!", "" ) end
						if string.find( impactfx_effectname, "!COLOR7!" ) then impacteffectdata:SetColor( 7 ) impactfx_effectname = string.Replace( impactfx_effectname, "!COLOR7!", "" ) end
						if string.find( impactfx_effectname, "!COLOR8!" ) then impacteffectdata:SetColor( 8 ) impactfx_effectname = string.Replace( impactfx_effectname, "!COLOR8!", "" ) end
						if string.find( impactfx_effectname, "!COLOR9!" ) then impacteffectdata:SetColor( 9 ) impactfx_effectname = string.Replace( impactfx_effectname, "!COLOR9!", "" ) end
					end

					//dumb situational crap
					if string.find( string.lower(impactfx_effectname), "shakeropes" ) then impacteffectdata:SetMagnitude( effectmagnitude * 20 ) end
					if string.find( string.lower(impactfx_effectname), "thumperdust" ) then impacteffectdata:SetScale( effectscale * 50 ) end
					if string.find( string.lower(impactfx_effectname), "bloodspray" ) then impacteffectdata:SetScale( effectscale * 4 ) end

					impacteffectdata:SetStart( impactfxent:GetPos() )
					impacteffectdata:SetOrigin( impactfxent:GetPos() )
					impacteffectdata:SetAngles( impactfxent:GetAngles() )
					impacteffectdata:SetNormal( impactfxent:GetAngles():Forward() )

					util.Effect( string.Replace( impactfx_effectname, "!UTILEFFECT!", "" ), impacteffectdata )

				else

					//Create a particlesystem effect

					local clrtb = nil
					if impactfx_colorinfo == Vector(0,0,0) then
						//MsgN("color = false")
					else
						//MsgN("color = true")
						clrtb = { position = impactfx_colorinfo }
					end
					local impactcpointtable = {}
						impactcpointtable[1] = { entity = impactfxent, attachtype = PATTACH_ABSORIGIN_FOLLOW }

						for i = 2, 64 do
 							if clrtb then
								impactcpointtable[i] = clrtb
							else
								impactcpointtable[i] = impactcpointtable[1]
							end
						end

					impactfxent:CreateParticleEffect(impactfx_effectname,impactcpointtable)

				end
			end
		end

		ent:Remove()

	end

	timer.Simple(projent_lifetime_prehit, function() if IsValid(proj) then projexpire(proj) end; end)

	local function projcollide(entity, data)
		if IsValid(entity) then
			if entity.HasHitSomething then return end   //there's no reason to call this more than once
			entity.HasHitSomething = true

			if projent_lifetime_posthit == 0 then
				//if lifetime_posthit is 0, then move the impactfx to the pos and angle of impact -
				//we still need to use a timer because directly calling ent:Remove() in a PhysicsCollide callback crashes the game
				timer.Simple(0, function() if IsValid(proj) then projexpire(proj, data.HitPos, -data.HitNormal:Angle()) end; end)
			else
				timer.Simple(projent_lifetime_posthit, function() if IsValid(proj) then projexpire(proj) end; end)
			end
		end
	end
	if CLIENT then
		proj:AddCallback("PhysicsCollide", projcollide)
	else
		proj.PhysicsCollide = projcollide  //AddCallback inexplicably won't work on our sent we're using serverside, but overriding its physicscollide function seems to do it
	end

end




//numpad functions
if SERVER then

local function NumpadPress( pl, ent )

	if ( !ent || ent == NULL ) then return end

	if ( ent:GetToggle() ) then
		if ent:GetActive() == false then
			ent:SetActive(true)
			ent:SetNumpadState("on")
		else
			ent:SetActive(false)
			ent:SetNumpadState("off")
		end
	else
		ent:SetActive( true )
		ent:SetNumpadState("on")
	end

end

local function NumpadRelease( pl, ent )

	if ( !ent || ent == NULL ) then return end

	if ( ent:GetToggle() ) then return end

	ent:SetActive(false)
	ent:SetNumpadState("off")

end

numpad.Register( "Particle_Press", NumpadPress )
numpad.Register( "Particle_Release", NumpadRelease )

end




//don't duplicate this
duplicator.RegisterEntityClass( "particlecontroller_proj", function( ply, data )
end, "Data" )
