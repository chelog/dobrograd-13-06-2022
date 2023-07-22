AddCSLuaFile()

ENT.Base 			= "base_gmodentity"
ENT.PrintName			= "Particle Controller - Normal"
ENT.Author			= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup			= RENDERGROUP_NONE




function ENT:SetupDataTables()

	self:NetworkVar( "Entity", 0, "TargetEnt" );
	self:NetworkVar( "Entity", 1, "TargetEnt2" );

	self:NetworkVar( "String", 0, "EffectName" );
	self:NetworkVar( "String", 1, "NumpadState" );

	self:NetworkVar( "Float", 0, "RepeatRate" );

	self:NetworkVar( "Int", 0, "AttachNum" );
	self:NetworkVar( "Int", 1, "AttachNum2" );
	self:NetworkVar( "Int", 2, "NumpadKey" );

	self:NetworkVar( "Bool", 0, "Active" );
	self:NetworkVar( "Bool", 1, "RepeatSafety" );
	self:NetworkVar( "Bool", 2, "Toggle" );

	//we have 3 pieces of information we need for util.effect, and they're not going to be changed after the ent's been spawned, so there's no reason we can't save space by storing them all in this vector
	self:NetworkVar( "Vector", 0, "UtilEffectInfo" );  //x = scale, y = magnitude, x = radius

end




function ENT:Initialize()

	local target = self:GetTargetEnt()
	local target2 = self:GetTargetEnt2()


	if !string.StartWith( self:GetEffectName(), "!UTILEFFECT!" ) then

		//Set things up for a particlesystem effect

		if SERVER then	
	
			//Since we can't specify attachment points with Entity:CreateParticleEffect(), we have to improvise.
	
			//If target1 is using an attachment, move ourselves to the pos/ang of that attachment and use ourselves as the target for control point 1.
			local attachment1 = target:GetAttachment( self:GetAttachNum() )
			if attachment1 != nil then 
				self:SetPos( attachment1.Pos )
				self:SetAngles( attachment1.Ang )
				self:Fire("setparentattachment", target:GetAttachments()[self:GetAttachNum()].name, 0.01)
				self:SetTargetEnt(self)
			end
		
			//If target2 is using an attachment, then spawn an entity at the pos/ang of that attachment to use as the target for control point 2.	
			if IsValid(target2) then
				local attachment2 = target2:GetAttachment( self:GetAttachNum2() )
				if attachment2 != nil then
					if self.endpoint then self.endpoint = nil end
					self.endpoint = ents.Create( "info_particle_system" )
					self.endpoint:SetKeyValue( "effect_name", "combineball" )
					self.endpoint:SetParent(target2)	
	
					self.endpoint:SetPos( attachment2.Pos )
					self.endpoint:SetAngles( attachment2.Ang )
					self.endpoint:Fire("setparentattachment", target2:GetAttachments()[self:GetAttachNum2()].name, 0.01)
	
					self:DeleteOnRemove(self.endpoint)
					self.endpoint:Spawn()
					self.endpoint:Activate()
					self:SetTargetEnt2(self.endpoint)
				end
			end
	
		else

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

				if IsValid(target2) then
					self.cpointtable[2] = { entity = target2, attachtype = PATTACH_ABSORIGIN_FOLLOW } 
				else
					if clrtb then 
						self.cpointtable[2] = clrtb
					else
						self.cpointtable[2] = self.cpointtable[1]
					end
				end

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
		//we're going to be repeating the effect, so let's set that up and let think do the test
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
		self:RemoveParticle(false,self:GetEffectName()) 
	end

	if self:GetNumpadState() == "on" then
		//MsgN("turn on")
		self:SetNumpadState("")
		if self:GetRepeatRate() > 0 then
			//we're going to be repeating the effect, so let's set that up and let think do the test
			self.NextRepeat = 0
		else
			//we won't be repeating the effect, so just attach it right now
			if self:GetActive() then self:AttachParticle() end
		end
	end


	if self:GetActive() == true and self:GetRepeatRate() > 0 then
		if !( self.NextRepeat > CurTime() ) then
			//the repeat function is built into removeparticle so that we can be sure the old particle is gone before we add a new one
			//disabling repeat safety lets the user bypass this if they want
			if self:GetRepeatSafety() then
				self:RemoveParticle(true,self:GetEffectName())
			else
				self:AttachParticle()
			end
			self.NextRepeat = CurTime() + self:GetRepeatRate()
		end
	end
	
	self:NextThink(CurTime())
	return true

end




function ENT:AttachParticle()

	if SERVER then return end

	local target		= self:GetTargetEnt()
	local attachnum		= self:GetAttachNum()
	local effectname	= self:GetEffectName()
	local target2		= self:GetTargetEnt2()
	local attachnum2	= self:GetAttachNum2()

	if effectname == nil or !target:IsValid() then return end


	if string.StartWith( effectname, "!UTILEFFECT!" ) then

		//Create a util effect

		//Unfortunately, we have to do all of this every single time the effect repeats, because if we do it in Initialize instead, a whole bunch of stuff doesn't work properly

		local effectscale = self:GetUtilEffectInfo().x
		local effectmagnitude = self:GetUtilEffectInfo().y
		local effectradius = self:GetUtilEffectInfo().z

		local luaeffectdata = EffectData()
		luaeffectdata:SetEntity( target )
		if ( string.find(effectname, "Tracer", 0, true) != nil ) then luaeffectdata:SetScale(5000) else luaeffectdata:SetScale( effectscale ) end  //for tracer effects, scale is the speed of the bullet, so we need to keep this high
		luaeffectdata:SetMagnitude( effectmagnitude )
		luaeffectdata:SetRadius(effectradius )

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

		//colors can also be set the same way
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
		if string.find( string.lower(effectname), "shakeropes" ) then luaeffectdata:SetMagnitude( effectmagnitude * 20 ) end
		if string.find( string.lower(effectname), "thumperdust" ) then luaeffectdata:SetScale( effectscale * 50 ) end
		if string.find( string.lower(effectname), "bloodspray" ) then luaeffectdata:SetScale( effectscale * 4 ) end

		if target:GetAttachment(attachnum) != nil then
			luaeffectdata:SetAttachment( attachnum )
			luaeffectdata:SetStart( target:GetAttachment( attachnum ).Pos )
			luaeffectdata:SetOrigin( target:GetAttachment( attachnum ).Pos )
			luaeffectdata:SetAngles( target:GetAttachment( attachnum ).Ang )
			luaeffectdata:SetNormal( target:GetAttachment( attachnum ).Ang:Forward() )
		else
			luaeffectdata:SetStart( target:GetPos() )
			luaeffectdata:SetOrigin( target:GetPos() )
			luaeffectdata:SetAngles( target:GetAngles() )
			luaeffectdata:SetNormal( target:GetAngles():Forward() )
		end

		if IsValid(target2) then
			if target2:GetAttachment(attachnum2) != nil then
				luaeffectdata:SetOrigin( target2:GetAttachment( attachnum2 ).Pos )
				luaeffectdata:SetNormal( target2:GetAttachment( attachnum2 ).Ang:Forward() )
			else
				luaeffectdata:SetOrigin( target2:GetPos() )
				luaeffectdata:SetNormal( target2:GetAngles():Forward() )
			end
		end

		util.Effect( string.Replace( effectname, "!UTILEFFECT!", "" ), luaeffectdata )

	else

		//Create a particlesystem effect

		target:CreateParticleEffect(effectname,self.cpointtable)

	end

end



function ENT:RemoveParticle(arewerepeating,effectwereremoving)

	local target = self:GetTargetEnt()

	if CLIENT then 
		if target:IsValid() then target:StopParticleEmission(effectwereremoving) end

		//StopParticleEmission is broken and removes ALL effects on the entity, not just the one specified, so to try and counteract this we'll reactivate them.
		if target != self then
			for _, asdf in pairs( ents:GetAll() ) do
				if asdf != self then
					if IsValid(asdf) and asdf:GetClass() == "particlecontroller_normal" and asdf:GetParent() == target then
						//Make sure the ent is active, but not already creating the particle by itself. We don't want to double their particle by mistake.
						if asdf.GetActive and asdf:GetActive() == true and asdf:GetNumpadState() == "" then asdf:AttachParticle() end
					end
				end
			end
		end
	end

	if arewerepeating == true then self:AttachParticle() end

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




function ENT:OnRemove()
	self:RemoveParticle(false,self:GetEffectName())
end




//don't duplicate this
duplicator.RegisterEntityClass( "particlecontroller_normal", function( ply, data )
end, "Data" )