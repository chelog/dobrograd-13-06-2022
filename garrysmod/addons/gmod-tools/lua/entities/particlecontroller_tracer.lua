AddCSLuaFile()

ENT.Base 			= "base_gmodentity"
ENT.PrintName			= "Particle Controller - Tracer"
ENT.Author			= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup			= RENDERGROUP_NONE




function ENT:SetupDataTables()

	self:NetworkVar( "Entity", 0, "TargetEnt" );

	self:NetworkVar( "String", 0, "EffectName" );
	self:NetworkVar( "String", 1, "NumpadState" );
	self:NetworkVar( "String", 2, "Impact_EffectName" );

	self:NetworkVar( "Float", 0, "RepeatRate" );
	self:NetworkVar( "Float", 1, "TracerSpread" );
	self:NetworkVar( "Float", 2, "EffectLifetime" );

	self:NetworkVar( "Int", 0, "AttachNum" );
	self:NetworkVar( "Int", 1, "NumpadKey" );
	self:NetworkVar( "Int", 2, "TracerCount" );

	self:NetworkVar( "Bool", 0, "Active" );
	self:NetworkVar( "Bool", 1, "Toggle" );
	self:NetworkVar( "Bool", 2, "LeaveBulletHoles" );

	//we have 3 pieces of information we need for util.effect, and they're not going to be changed after the ent's been spawned, so there's no reason we can't save space by storing them all in this vector
	//self:NetworkVar( "Vector", 0, "UtilEffectInfo" );  //x = scale, y = magnitude, x = radius
	self:NetworkVar( "Vector", 0, "Impact_UtilEffectInfo" );  //x = scale, y = magnitude, x = radius
	self:NetworkVar( "Vector", 1, "Impact_ColorInfo" );

end




function ENT:Initialize()

	local target = self:GetTargetEnt()


	if SERVER then

		//Use ourselves as the target for control point 1 - because of how we have tracer effects set up, we're going to do this for both util and .pcf effects
		local attachment1 = target:GetAttachment( self:GetAttachNum() )
		if attachment1 != nil then
			self:SetPos( attachment1.Pos )
			self:SetAngles( attachment1.Ang )
			self:Fire("setparentattachment", target:GetAttachments()[self:GetAttachNum()].name, 0.01)
			self:SetTargetEnt(self)
		end

	else

		//Set things up for a particlesystem effect

		if !string.StartWith( self:GetEffectName(), "!UTILEFFECT!" ) then

			//Make a table of control point information, so we only have to do this once instead of every time AttachParticle runs.

			local clrtb = nil
			if self:GetColor().r == 0 and self:GetColor().g == 0 and self:GetColor().b == 0 then
				//MsgN("color = false")
			else
				//MsgN("color = true")
				if self:GetColor().a == 1 then
					clrtb = { position = Vector( self:GetColor().r / 255, self:GetColor().g / 255, self:GetColor().b / 255 )  }
				else
					clrtb = { position = Vector( self:GetColor().r, self:GetColor().g, self:GetColor().b )  }
				end
			end
			self.cpointtable = {}
				self.cpointtable[1] = { entity = target, attachtype = PATTACH_ABSORIGIN_FOLLOW }

				//this entry is a placeholder - we want the second controlpoint to be at the endpos of a trace we haven't performed yet
				self.cpointtable[2] = true

				for i = 3, 64 do
 					if clrtb then
						self.cpointtable[i] = clrtb
					else
						self.cpointtable[i] = self.cpointtable[1]
					end
				end

			PrecacheParticleSystem(self:GetEffectName())

		end

	end
	self:SetModel("models/hunter/plates/plate.mdl") //it's a tiny block so that model-covering fx show up at a single point instead of all over an invisible error model
	self:SetNoDraw(true)


	if self:GetRepeatRate() > 0 then
		//we're going to be repeating the effect, so let's set that up and let think do the rest
		self.NextRepeat = 0
	else
		//we won't be repeating the effect, so just attach it right now
		if self:GetActive() then self:AttachParticle() end
	end

end




function ENT:Think()

	if SERVER then return end

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

	if SERVER then return end

	local target		= self:GetTargetEnt()
	//local attachnum	= self:GetAttachNum()  //this isn't used anywhere
	local effectname	= self:GetEffectName()

	local tracerspread	= math.Clamp( self:GetTracerSpread(), 0, 4)
	local tracercount	= self:GetTracerCount()
	local leavebulletholes	= self:GetLeaveBulletHoles()
	local effectlifetime	= math.Clamp( self:GetEffectLifetime(), 0.5, 5)

	local impact_effectname	= self:GetImpact_EffectName()

	if effectname == nil or !target:IsValid() then return end


	for i = 1, tracercount do

		//Do a trace to find the endpoint of the bullet
		local tracedata = {}
		if self:GetParent() != NULL then tracedata.filter = {self:GetParent(), self:GetParent():GetParent()} end  //this returns a null entity if the player is outside of the visleaf, be careful
		local tracepos = target:GetPos()
		local traceang = target:GetAngles()

		//spread
		local randang = AngleRand()
		traceang:RotateAroundAxis( traceang:Forward(), randang.r )
		traceang:RotateAroundAxis( traceang:Right(), randang.p * (tracerspread / 2) )
		traceang:RotateAroundAxis( traceang:Up(), randang.y * (tracerspread / 4) )

		tracedata.start = tracepos
		tracedata.endpos = tracepos+(traceang:Forward()*20000)
		local trace = util.TraceLine(tracedata)


		//we're going to tie the tracer effect and impact effect to a clientside ent that expires quickly, so people can't create a million permanent medigun beams or anything like that
		local tracerent = octolib.createDummy("models/hunter/plates/plate.mdl")
		tracerent.RenderGroup = RENDERGROUP_OTHER
		tracerent:SetNoDraw(true)
		tracerent:SetPos(trace.HitPos)
		tracerent:SetAngles(trace.HitNormal:Angle())
		timer.Simple(effectlifetime, function() if IsValid(tracerent) then tracerent:Remove() end; end)
		tracerent:Spawn()
		tracerent:Activate()

		if self.cpointtable then self.cpointtable[2] = { entity = tracerent, attachtype = PATTACH_ABSORIGIN_FOLLOW } end


		//Create a bullet hole effect, if enabled
		if leavebulletholes == true then
			local impacteffectdata = EffectData()
			impacteffectdata:SetStart( tracepos )
			impacteffectdata:SetOrigin( trace.HitPos )
			impacteffectdata:SetNormal( trace.HitNormal )
			impacteffectdata:SetEntity( trace.Entity )
			impacteffectdata:SetSurfaceProp( trace.SurfaceProps )
			impacteffectdata:SetHitBox( trace.HitBox )
			util.Effect( "Impact", impacteffectdata )
		end


		//Create the tracer effect
		if string.StartWith( effectname, "!UTILEFFECT!" ) then

			//Create a util effect

			//Unfortunately, we have to do all of this every single time the effect repeats, because if we do it in Initialize instead, a whole bunch of stuff doesn't work properly

			//local effectscale = self:GetUtilEffectInfo().x
			//local effectmagnitude = self:GetUtilEffectInfo().y
			//local effectradius = self:GetUtilEffectInfo().z

			local luaeffectdata = EffectData()
			luaeffectdata:SetEntity( tracerent )

			luaeffectdata:SetScale(5000) //for tracer effects, scale is the speed of the bullet, so we need to keep this high
			//luaeffectdata:SetMagnitude( 20 )
			//luaeffectdata:SetRadius( 10 )

			//flags can be set by typing !FLAG#! at the end of the effect name
			luaeffectdata:SetFlags( 0 )
			if string.EndsWith( effectname, "!" ) then
				if string.find( effectname, "!FLAG1!" ) then luaeffectdata:SetFlags( 1 ) effectname = string.Replace( effectname, "!FLAG1!", "" ) end
				if string.find( effectname, "!FLAG2!" ) then luaeffectdata:SetFlags( 2 ) effectname = string.Replace( effectname, "!FLAG2!", "" ) end
				if string.find( effectname, "!FLAG3!" ) then luaeffectdata:SetFlags( 3 ) effectname = string.Replace( effectname, "!FLAG3!", "" ) end
				if string.find( effectname, "!FLAG4!" ) then luaeffectdata:SetFlags( 4 ) effectname = string.Replace( effectname, "!FLAG4!", "" ) end
				if string.find( effectname, "!FLAG5!" ) then luaeffectdata:SetFlags( 5 ) effectname = string.Replace( effectname, "!FLAG5!", "" ) end
				if string.find( effectname, "!FLAG6!" ) then luaeffectdata:SetFlags( 6 ) effectname = string.Replace( effectname, "!FLAG6!", "" ) end
				if string.find( effectname, "!FLAG7!" ) then luaeffectdata:SetFlags( 7 ) effectname = string.Replace( effectname, "!FLAG7!", "" ) end
				if string.find( effectname, "!FLAG8!" ) then luaeffectdata:SetFlags( 8 ) effectname = string.Replace( effectname, "!FLAG8!", "" ) end
				if string.find( effectname, "!FLAG9!" ) then luaeffectdata:SetFlags( 9 ) effectname = string.Replace( effectname, "!FLAG9!", "" ) end
			end

			//colors can also be set the same way - i don't think there are any tracers that use these
			luaeffectdata:SetColor(0)
			if string.EndsWith( effectname, "!" ) then
				if string.find( effectname, "!COLOR1!" ) then luaeffectdata:SetColor( 1 ) effectname = string.Replace( effectname, "!COLOR1!", "" ) end
				if string.find( effectname, "!COLOR2!" ) then luaeffectdata:SetColor( 2 ) effectname = string.Replace( effectname, "!COLOR2!", "" ) end
				if string.find( effectname, "!COLOR3!" ) then luaeffectdata:SetColor( 3 ) effectname = string.Replace( effectname, "!COLOR3!", "" ) end
				if string.find( effectname, "!COLOR4!" ) then luaeffectdata:SetColor( 4 ) effectname = string.Replace( effectname, "!COLOR4!", "" ) end
				if string.find( effectname, "!COLOR5!" ) then luaeffectdata:SetColor( 5 ) effectname = string.Replace( effectname, "!COLOR5!", "" ) end
				if string.find( effectname, "!COLOR6!" ) then luaeffectdata:SetColor( 6 ) effectname = string.Replace( effectname, "!COLOR6!", "" ) end
				if string.find( effectname, "!COLOR7!" ) then luaeffectdata:SetColor( 7 ) effectname = string.Replace( effectname, "!COLOR7!", "" ) end
				if string.find( effectname, "!COLOR8!" ) then luaeffectdata:SetColor( 8 ) effectname = string.Replace( effectname, "!COLOR8!", "" ) end
				if string.find( effectname, "!COLOR9!" ) then luaeffectdata:SetColor( 9 ) effectname = string.Replace( effectname, "!COLOR9!", "" ) end
			end

			//dumb situational crap
			//if string.find( string.lower(effectname), "shakeropes" ) then luaeffectdata:SetMagnitude( effectmagnitude * 20 ) end
			//if string.find( string.lower(effectname), "thumperdust" ) then luaeffectdata:SetScale( effectscale * 50 ) end
			//if string.find( string.lower(effectname), "bloodspray" ) then luaeffectdata:SetScale( effectscale * 4 ) end

			luaeffectdata:SetOrigin( trace.HitPos )
			luaeffectdata:SetStart( tracepos )
			//luaeffectdata:SetAngles( traceang )
			luaeffectdata:SetNormal( trace.HitNormal:Angle():Forward() )

			util.Effect( string.Replace( effectname, "!UTILEFFECT!", "" ), luaeffectdata )

		else

			//Create a particlesystem effect

			tracerent:CreateParticleEffect(effectname,self.cpointtable)

		end


		//Create the impact effect, if enabled
		if impact_effectname != "" then
			if string.StartWith( impact_effectname, "!UTILEFFECT!" ) then

				//Create a util effect

				//Unfortunately, we have to do all of this every single time the effect repeats, because if we do it in Initialize instead, a whole bunch of stuff doesn't work properly

				local effectscale = self:GetImpact_UtilEffectInfo().x
				local effectmagnitude = self:GetImpact_UtilEffectInfo().y
				local effectradius = self:GetImpact_UtilEffectInfo().z

				local impacteffectdata = EffectData()
				impacteffectdata:SetEntity( tracerent )
				if ( string.find(impact_effectname, "Tracer", 0, true) != nil ) then impacteffectdata:SetScale(5000) else impacteffectdata:SetScale( effectscale ) end  //for tracer effects, scale is the speed of the bullet, so we need to keep this high
				impacteffectdata:SetMagnitude( effectmagnitude )
				impacteffectdata:SetRadius(effectradius )

				//flags can be set by typing !FLAG#! at the end of the effect name
				impacteffectdata:SetFlags( 0 )
				if string.EndsWith( impact_effectname, "!" ) then
					if string.find( impact_effectname, "!FLAG1!" ) then impacteffectdata:SetFlags( 1 ) impact_effectname = string.Replace( impact_effectname, "!FLAG1!", "" ) end
					if string.find( impact_effectname, "!FLAG2!" ) then impacteffectdata:SetFlags( 2 ) impact_effectname = string.Replace( impact_effectname, "!FLAG2!", "" ) end
					if string.find( impact_effectname, "!FLAG3!" ) then impacteffectdata:SetFlags( 3 ) impact_effectname = string.Replace( impact_effectname, "!FLAG3!", "" ) end
					if string.find( impact_effectname, "!FLAG4!" ) then impacteffectdata:SetFlags( 4 ) impact_effectname = string.Replace( impact_effectname, "!FLAG4!", "" ) end
					if string.find( impact_effectname, "!FLAG5!" ) then impacteffectdata:SetFlags( 5 ) impact_effectname = string.Replace( impact_effectname, "!FLAG5!", "" ) end
					if string.find( impact_effectname, "!FLAG6!" ) then impacteffectdata:SetFlags( 6 ) impact_effectname = string.Replace( impact_effectname, "!FLAG6!", "" ) end
					if string.find( impact_effectname, "!FLAG7!" ) then impacteffectdata:SetFlags( 7 ) impact_effectname = string.Replace( impact_effectname, "!FLAG7!", "" ) end
					if string.find( impact_effectname, "!FLAG8!" ) then impacteffectdata:SetFlags( 8 ) impact_effectname = string.Replace( impact_effectname, "!FLAG8!", "" ) end
					if string.find( impact_effectname, "!FLAG9!" ) then impacteffectdata:SetFlags( 9 ) impact_effectname = string.Replace( impact_effectname, "!FLAG9!", "" ) end
				end

				//colors can also be set the same way
				impacteffectdata:SetColor(0)
				if string.EndsWith( impact_effectname, "!" ) then
					if string.find( impact_effectname, "!COLOR1!" ) then impacteffectdata:SetColor( 1 ) impact_effectname = string.Replace( impact_effectname, "!COLOR1!", "" ) end
					if string.find( impact_effectname, "!COLOR2!" ) then impacteffectdata:SetColor( 2 ) impact_effectname = string.Replace( impact_effectname, "!COLOR2!", "" ) end
					if string.find( impact_effectname, "!COLOR3!" ) then impacteffectdata:SetColor( 3 ) impact_effectname = string.Replace( impact_effectname, "!COLOR3!", "" ) end
					if string.find( impact_effectname, "!COLOR4!" ) then impacteffectdata:SetColor( 4 ) impact_effectname = string.Replace( impact_effectname, "!COLOR4!", "" ) end
					if string.find( impact_effectname, "!COLOR5!" ) then impacteffectdata:SetColor( 5 ) impact_effectname = string.Replace( impact_effectname, "!COLOR5!", "" ) end
					if string.find( impact_effectname, "!COLOR6!" ) then impacteffectdata:SetColor( 6 ) impact_effectname = string.Replace( impact_effectname, "!COLOR6!", "" ) end
					if string.find( impact_effectname, "!COLOR7!" ) then impacteffectdata:SetColor( 7 ) impact_effectname = string.Replace( impact_effectname, "!COLOR7!", "" ) end
					if string.find( impact_effectname, "!COLOR8!" ) then impacteffectdata:SetColor( 8 ) impact_effectname = string.Replace( impact_effectname, "!COLOR8!", "" ) end
					if string.find( impact_effectname, "!COLOR9!" ) then impacteffectdata:SetColor( 9 ) impact_effectname = string.Replace( impact_effectname, "!COLOR9!", "" ) end
				end

				//dumb situational crap
				if string.find( string.lower(impact_effectname), "shakeropes" ) then impacteffectdata:SetMagnitude( effectmagnitude * 20 ) end
				if string.find( string.lower(impact_effectname), "thumperdust" ) then impacteffectdata:SetScale( effectscale * 50 ) end
				if string.find( string.lower(impact_effectname), "bloodspray" ) then impacteffectdata:SetScale( effectscale * 4 ) end

				impacteffectdata:SetStart( tracerent:GetPos() )
				impacteffectdata:SetOrigin( tracerent:GetPos() )
				impacteffectdata:SetAngles( tracerent:GetAngles() )
				impacteffectdata:SetNormal( trace.HitNormal )

				util.Effect( string.Replace( impact_effectname, "!UTILEFFECT!", "" ), impacteffectdata )

			else

				//Create a particlesystem effect

				local clrtb = nil
				if self:GetImpact_ColorInfo() == Vector(0,0,0) then
					//MsgN("color = false")
				else
					//MsgN("color = true")
					clrtb = { position = self:GetImpact_ColorInfo() }
				end
				local impactcpointtable = {}
					impactcpointtable[1] = { entity = tracerent, attachtype = PATTACH_ABSORIGIN_FOLLOW }

					for i = 2, 64 do
 						if clrtb then
							impactcpointtable[i] = clrtb
						else
							impactcpointtable[i] = impactcpointtable[1]
						end
					end

				tracerent:CreateParticleEffect(impact_effectname,impactcpointtable)

			end
		end

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
duplicator.RegisterEntityClass( "particlecontroller_tracer", function( ply, data )
end, "Data" )
