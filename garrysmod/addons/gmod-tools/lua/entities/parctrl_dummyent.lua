//This is a dummy entity used by serverside projectile effects. It doesn't do anything special except be a SENT (we can't use PhysicsInitBox on prop_physics, apparently),
//call its own particle effects (since the projectile effect entity can't do that serverside), and not get duplicated!

AddCSLuaFile()

ENT.Base 			= "base_gmodentity"
ENT.PrintName			= "Particle Controller Dummy Entity"
ENT.Author			= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

if CLIENT then
	language.Add("parctrl_dummyent", "Physics Object")  //for killfeed notices
end




function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "EffectName" );
	self:NetworkVar( "Vector", 0, "UtilEffectInfo" );
	self:NetworkVar( "Vector", 1, "ColorInfo" );
	self:NetworkVar( "Int", 0, "AttachNum" );

end




//Since we're creating these entities serverside, we can't create the particle effects in the projectile-firing function, so do them here instead:
function ENT:Think()

	if SERVER then return end
	if self.ParticleEffectCalled then return end

	local effectname = self:GetEffectName()
	local utileffectinfo = self:GetUtilEffectInfo()
	local colorinfo = self:GetColorInfo()
	local attachnum = self:GetAttachNum()

	if effectname != nil and effectname != "" and colorinfo != nil and utileffectinfo != nil and attachnum != nil then

		local projfxent = self   //terminology's a bit weird here since it's mostly all copy-pasted from the projectile tool, but it's not really worth the trouble changing it all

		if string.StartWith( effectname, "!UTILEFFECT!" ) then

			//Create a util effect

			//Unfortunately, we have to do all of this every single time the effect repeats, because if we do it in Initialize instead, a whole bunch of stuff doesn't work properly

			local effectscale = utileffectinfo.x
			local effectmagnitude = utileffectinfo.y
			local effectradius = utileffectinfo.z

			local projeffectdata = EffectData()
			projeffectdata:SetEntity( projfxent )
			//if ( string.find(effectname, "Tracer", 0, true) != nil ) then projeffectdata:SetScale(5000) else projeffectdata:SetScale( effectscale ) end  //for tracer effects, scale is the speed of the bullet, so we need to keep this high; useless for a projectile effect
			projeffectdata:SetScale( effectscale )
			projeffectdata:SetMagnitude( effectmagnitude )
			projeffectdata:SetRadius(effectradius )

			//flags can be set by typing !FLAG#! at the end of the effect name
			projeffectdata:SetFlags( 0 )
			if string.EndsWith( effectname, "!" ) then
				if string.find( effectname, "!FLAG1!" ) then projeffectdata:SetFlags( 1 ) effectname = string.Replace( effectname, "!FLAG1!", "" ) end
				if string.find( effectname, "!FLAG2!" ) then projeffectdata:SetFlags( 2 ) effectname = string.Replace( effectname, "!FLAG2!", "" ) end
				if string.find( effectname, "!FLAG3!" ) then projeffectdata:SetFlags( 3 ) effectname = string.Replace( effectname, "!FLAG3!", "" ) end
				if string.find( effectname, "!FLAG4!" ) then projeffectdata:SetFlags( 4 ) effectname = string.Replace( effectname, "!FLAG4!", "" ) end
				if string.find( effectname, "!FLAG5!" ) then projeffectdata:SetFlags( 5 ) effectname = string.Replace( effectname, "!FLAG5!", "" ) end
				if string.find( effectname, "!FLAG6!" ) then projeffectdata:SetFlags( 6 ) effectname = string.Replace( effectname, "!FLAG6!", "" ) end
				if string.find( effectname, "!FLAG7!" ) then projeffectdata:SetFlags( 7 ) effectname = string.Replace( effectname, "!FLAG7!", "" ) end
				if string.find( effectname, "!FLAG8!" ) then projeffectdata:SetFlags( 8 ) effectname = string.Replace( effectname, "!FLAG8!", "" ) end
				if string.find( effectname, "!FLAG9!" ) then projeffectdata:SetFlags( 9 ) effectname = string.Replace( effectname, "!FLAG9!", "" ) end
			end

			//colors can also be set the same way
			projeffectdata:SetColor(0)
			if string.EndsWith( effectname, "!" ) then
				if string.find( effectname, "!COLOR1!" ) then projeffectdata:SetColor( 1 ) effectname = string.Replace( effectname, "!COLOR1!", "" ) end
				if string.find( effectname, "!COLOR2!" ) then projeffectdata:SetColor( 2 ) effectname = string.Replace( effectname, "!COLOR2!", "" ) end
				if string.find( effectname, "!COLOR3!" ) then projeffectdata:SetColor( 3 ) effectname = string.Replace( effectname, "!COLOR3!", "" ) end
				if string.find( effectname, "!COLOR4!" ) then projeffectdata:SetColor( 4 ) effectname = string.Replace( effectname, "!COLOR4!", "" ) end
				if string.find( effectname, "!COLOR5!" ) then projeffectdata:SetColor( 5 ) effectname = string.Replace( effectname, "!COLOR5!", "" ) end
				if string.find( effectname, "!COLOR6!" ) then projeffectdata:SetColor( 6 ) effectname = string.Replace( effectname, "!COLOR6!", "" ) end
				if string.find( effectname, "!COLOR7!" ) then projeffectdata:SetColor( 7 ) effectname = string.Replace( effectname, "!COLOR7!", "" ) end
				if string.find( effectname, "!COLOR8!" ) then projeffectdata:SetColor( 8 ) effectname = string.Replace( effectname, "!COLOR8!", "" ) end
				if string.find( effectname, "!COLOR9!" ) then projeffectdata:SetColor( 9 ) effectname = string.Replace( effectname, "!COLOR9!", "" ) end
			end

			//dumb situational crap
			if string.find( string.lower(effectname), "shakeropes" ) then projeffectdata:SetMagnitude( effectmagnitude * 20 ) end
			if string.find( string.lower(effectname), "thumperdust" ) then projeffectdata:SetScale( effectscale * 50 ) end
			if string.find( string.lower(effectname), "bloodspray" ) then projeffectdata:SetScale( effectscale * 4 ) end

			//just in case someone makes a utileffect that works as a projectile effect
			if projfxent:GetAttachment(attachnum) != nil then
				projeffectdata:SetStart( projfxent:GetAttachment( attachnum ).Pos )
				projeffectdata:SetOrigin( projfxent:GetAttachment( attachnum ).Pos )
				projeffectdata:SetAngles( projfxent:GetAttachment( attachnum ).Ang )
				projeffectdata:SetNormal( projfxent:GetAttachment( attachnum ).Ang:Forward() )
			else
				projeffectdata:SetStart( projfxent:GetPos() )
				projeffectdata:SetOrigin( projfxent:GetPos() )
				projeffectdata:SetAngles( projfxent:GetAngles() )
				projeffectdata:SetNormal( projfxent:GetAngles():Forward() )
			end

			util.Effect( string.Replace( effectname, "!UTILEFFECT!", "" ), projeffectdata )

		else

			//Create a particlesystem effect

			//Since we can't specify attachment points with Entity:CreateParticleEffect(), create an entity there to use as a target
			local attachment1 = self:GetAttachment( attachnum )
			if attachment1 != nil then
				//if SERVER then
				//	projfxent = ents.Create("parctrl_dummyent")
				//	projfxent:SetModel("models/hunter/plates/plate.mdl")
				//end
				if CLIENT then
					projfxent = octolib.createDummy("models/hunter/plates/plate.mdl")
				end

				projfxent:SetParent(self, attachnum - 1)
				projfxent:SetPos( attachment1.Pos )
				projfxent:SetAngles( attachment1.Ang )
				projfxent:SetNoDraw(true)

				projfxent:Spawn()
				projfxent:Activate()

				self:CallOnRemove("RemoveProjFX", function() if IsValid(projfxent) then projfxent:Remove() end end)
			end


			local clrtb = nil
			if colorinfo == Vector(0,0,0) then
				//MsgN("color = false")
			else
				//MsgN("color = true")
				clrtb = { position = colorinfo }
			end
			local cpointtable = {}
				cpointtable[1] = { entity = projfxent, attachtype = PATTACH_ABSORIGIN_FOLLOW }

				for i = 2, 64 do
 					if clrtb then
						cpointtable[i] = clrtb
					else
						cpointtable[i] = cpointtable[1]
					end
				end

			projfxent:CreateParticleEffect(effectname,cpointtable)

		end

	self.ParticleEffectCalled = true

	end

end




//don't duplicate this
duplicator.RegisterEntityClass( "parctrl_dummyent", function( ply, data )
end, "Data" )
