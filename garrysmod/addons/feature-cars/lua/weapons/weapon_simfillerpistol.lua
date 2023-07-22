AddCSLuaFile()

SWEP.Category				= "simfphys"
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
SWEP.ViewModel			= "models/weapons/v_slam.mdl"
SWEP.WorldModel			= "models/props_equipment/gas_pump_p13.mdl"
SWEP.UseHands				= false
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 10
SWEP.Weight 				= 42
SWEP.AutoSwitchTo 			= true
SWEP.AutoSwitchFrom 		= true
SWEP.HoldType				= "slam"

SWEP.RefilAmount			= 0.95
SWEP.MaxDistance			= 120

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo		= "none"

local inv_time = 0

function SWEP:SetupDataTables()
	self:NetworkVar( "Int",0, "FuelType" )
end

function SWEP:IsAimingAt( vpos )
	if not IsValid( self.Owner ) then return false end
	local dir = self.Owner:GetAimVector()
	local pos = self.Owner:GetShootPos()
	local des_dir = (vpos - pos):GetNormalized()

	local dist = (pos - vpos):Length()
	local ang = math.acos( math.Clamp( dir:Dot(des_dir) ,-1,1) ) * (180 / math.pi)

	local IsAimingAt = ang < 5 and dist < self.MaxDistance

	return IsAimingAt
end

if SERVER then
	util.AddNetworkString( "simfphys_gasspill" )

	net.Receive( "simfphys_gasspill", function( length, ply )
		local Pos = net.ReadVector()
		local Dir = net.ReadVector()

		if not ply:HasWeapon('weapon_simfillerpistol') then
			ply:addExploitAttempt(0.25)
			return
		end

		timer.Simple(0.2, function()
			util.Decal("beersplash", Pos - Dir, Pos + Dir)

			for i = 0,8 do
				local sc = math.Rand(0.1,0.15)
				local effectdata = EffectData()
					effectdata:SetOrigin( Pos )
					--effectdata:SetAngles( angle )
					effectdata:SetNormal( Dir * 2 )
					effectdata:SetMagnitude( sc )
					effectdata:SetScale( sc )
					effectdata:SetRadius( sc )
				util.Effect( "StriderBlood", effectdata )
			end

			sound.Play( Sound( "ambient/water/water_spray"..math.random(1,3)..".wav" ), Pos, 55)
		end)
	end )
end

if CLIENT then
	SWEP.PrintName		= "Fuel filler pistol"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 12
	SWEP.IconLetter			= "k"

	--SWEP.WepSelectIcon 			= surface.GetTextureID( "weapons/s_repair" )
	SWEP.DrawWeaponInfoBox 	= false

	function SWEP:OnRemove()
		if IsValid(self.pViewModel) then
			self.pViewModel:Remove()
		end
	end

	function SWEP:CreateModel()
		if self.creatingModel or IsValid(self.pViewModel) then return end
		self.creatingModel = true
		timer.Simple(0, function()
			if not IsValid(self) then return end
			self.pViewModel = octolib.createDummy("models/props_equipment/gas_pump_p13.mdl", RENDERGROUP_OPAQUE)
			self.pViewModel:SetNoDraw(true)
			self.creatingModel = nil
		end)
	end

	function SWEP:ViewModelDrawn()
		if IsValid( self.Owner ) then

			local ZOOM = self.Owner:KeyDown( IN_ZOOM )

			self.ViewModelFOV = ZOOM and 30 or 10

			if ZOOM then return end

			local vm = self.Owner:GetViewModel()
			local bm = vm:GetBoneMatrix(0)
			local pos =  bm:GetTranslation()
			local ang =  bm:GetAngles()

			pos = pos + ang:Up() * 220
			pos = pos + ang:Right() * 2
			pos = pos + ang:Forward() * -12

			ang:RotateAroundAxis(ang:Forward(), -85)
			ang:RotateAroundAxis(ang:Right(), -20)
			ang:RotateAroundAxis(ang:Up(), -70)

			if not IsValid(self.pViewModel) then
				return self:CreateModel()
			end

			self.pViewModel:SetPos(pos)
			self.pViewModel:SetAngles(ang)
			self.pViewModel:DrawModel()
		end
	end

	function SWEP:DrawWorldModel()
		if not IsValid( self.Owner ) then return end

		local id = self.Owner:LookupAttachment("anim_attachment_rh")
		local attachment = self.Owner:GetAttachment( id )

		if not attachment then return end

		local pos = attachment.Pos + attachment.Ang:Forward() * 6 + attachment.Ang:Right() * -1.5 + attachment.Ang:Up() * 2.2
		local ang = attachment.Ang
		ang:RotateAroundAxis(attachment.Ang:Up(), 20)
		ang:RotateAroundAxis(attachment.Ang:Right(), -30)
		ang:RotateAroundAxis(attachment.Ang:Forward(), 0)

		self:SetRenderOrigin( pos )
		self:SetRenderAngles( ang )

		self:DrawModel()
	end


	local fuelposmat = Material( "sprites/fuelfiller_icon" )
	local wrong_type = Material( "conquest/aim_friendly" )

	function SWEP:DrawHUD()
		if LocalPlayer():InVehicle() then return end

		local screenw = ScrW()
		local screenh = ScrH()
		local Widescreen = (screenw / screenh) > (4 / 3)
		local sizex = screenw * (Widescreen and 1 or 1.32)
		local sizey = screenh
		local xpos = sizex * 0.02
		local ypos = sizey * 0.85
		local dia =  screenw * 0.025
		local radius = dia * 0.5

		local Trace = self.Owner:GetEyeTrace()
		local ent = Trace.Entity

		surface.SetDrawColor( 255, 0, 0,255 * math.Clamp(inv_time + 0.5 - CurTime(),0,1) )
		surface.SetMaterial( wrong_type )
		surface.DrawTexturedRect( screenw * 0.5 - radius, screenh * 0.5 - radius, dia, dia )

		surface.SetDrawColor( 0, 0, 0, 80 )
		surface.DrawRect( xpos, ypos, sizex * 0.118, sizey * 0.02 )

		if not IsValid( ent ) then
			draw.SimpleText( "0 / 0", "simfphysfont", xpos + sizex * 0.059, ypos + sizey * 0.01, Color( 238,238,238, 255 ), 1, 1 )
			return
		end

		if simfphys.IsCar( ent ) then
			local fuelpos = ent:GetFuelPos()
			local IsAimingAt = self:IsAimingAt( fuelpos )
			local col = IsAimingAt and Color(0,255,0,50) or Color(255,255,255,255)
			local size = IsAimingAt and 4 or 8
			cam.Start3D()
				render.SetMaterial( fuelposmat )
				render.DrawSprite( fuelpos, size, size, col )
			cam.End3D()

			local MaxFuel = math.Round( ent:GetMaxFuel() , 1)
			local Fuel = math.Round( ent:GetFuel() , 1 )
			local fueltype = ent:GetFuelType()

			if fueltype == FUELTYPE_ELECTRIC then
				MaxFuel = MaxFuel * 0.5
				Fuel = Fuel * 0.5
			end

			local fueltype_color = Color(102,170,170,150)
			if fueltype == 1 then
				fueltype_color = Color(102,170,170,150)
			elseif fueltype == 2 then
				fueltype_color = Color(170,119,102,150)
			end

			surface.SetDrawColor( fueltype_color.r, fueltype_color.g, fueltype_color.b, fueltype_color.a )
			surface.DrawRect( xpos, ypos, ((sizex * 0.118) / MaxFuel) * Fuel, sizey * 0.02, fueltype_color )

			draw.SimpleText( Fuel.." / "..MaxFuel, "simfphysfont", xpos + sizex * 0.059, ypos + sizey * 0.01, Color( 238, 238, 238, 255 ), 1, 1 )
		else
			draw.SimpleText( "0 / 0", "simfphysfont", xpos + sizex * 0.059, ypos + sizey * 0.01, Color( 238, 238, 238, 255 ), 1, 1 )
		end
	end
end

function SWEP:Initialize()
	self.Weapon:SetHoldType( self.HoldType )
	if IsValid( self.Owner ) then
		self.Owner.usedFuel = 0
	end
end

function SWEP:OwnerChanged()
end

function SWEP:Think()
	if CLIENT then
		self.nextThink = self.nextThink or 0

		if self.nextThink > CurTime() then return end

		self.nextThink = CurTime() + 0.02

		if not IsValid( self.Owner ) then return end
		if not self.Owner:KeyDown( IN_ATTACK ) then return end
		if self:GetNetVar('NoFuel') then return end

		local Trace = self.Owner:GetEyeTrace()
		local ent = Trace.Entity
		local InRange = (Trace.HitPos - self.Owner:GetPos()):Length() < self.MaxDistance
		local HIT = IsValid( ent ) and simfphys.IsCar( ent ) and InRange

		if HIT then
			if self:GetFuelType() ~=  ent:GetFuelType() then inv_time = CurTime() return end
		end

		if self:GetFuelType() == FUELTYPE_ELECTRIC then return end

		local id = self.Owner:LookupAttachment("anim_attachment_rh")
		local attachment = self.Owner:GetAttachment( id )

		if not attachment then return end

		local Pos = (attachment.Pos + attachment.Ang:Forward() * 14 + attachment.Ang:Right() * -5 + attachment.Ang:Up() * 7 )

		local FirstPerson = self.Owner == LocalPlayer() and self.Owner:GetViewEntity() == self.Owner
		if FirstPerson then
			Pos = self.Owner:GetShootPos() + self.Owner:EyeAngles():Forward() * 10 + self.Owner:EyeAngles():Right() * 3 - self.Owner:EyeAngles():Up()  * 2
		end


		local emitter = ParticleEmitter( Pos, false )
		local particle = emitter:Add( "effects/slime1", Pos )

		if not HIT and InRange or (IsValid( ent ) and simfphys.IsCar( ent ) and ent:GetFuel() >= ent:GetMaxFuel()) or (IsValid( ent ) and simfphys.IsCar( ent ) and not self:IsAimingAt( ent:GetFuelPos() ) )  then
			self.NextSplash = self.NextSplash or 0
			if self.NextSplash < CurTime() then
				self.NextSplash = CurTime() + math.Rand(0.05,0.2)

				net.Start( "simfphys_gasspill" )
					net.WriteVector( Trace.HitPos )
					net.WriteVector( Trace.HitNormal )
				net.SendToServer()
			end
		end

		if particle then
			local dir = attachment.Ang
			dir:RotateAroundAxis(attachment.Ang:Up(), 20)

			if FirstPerson then
				dir = self.Owner:EyeAngles() + Angle(-15,10,0)
			end

			particle:SetVelocity( dir:Forward() * 320 )
			particle:SetDieTime( HIT and 0.1 or 0.3 )
			particle:SetAirResistance( 400 )
			particle:SetStartAlpha( 100 )
			particle:SetStartSize( 1 )
			particle:SetEndSize( HIT and 1 or 2 )
			particle:SetRoll( math.Rand( -1, 1 ) )
			particle:SetColor( 240,200,0,255 )
			particle:SetGravity( Vector( 0, 0, -600 ) )
			particle:SetCollide( true )
		end
		emitter:Finish()
	end
end

function SWEP:CanPrimaryAttack()
	self.NextFire = self.NextFire or 0

	if self.NextFire > CurTime() then
		return false
	end

	return true
end

function SWEP:SetNextPrimaryFire( time )
	self.NextFire = time
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local Trace = self.Owner:GetEyeTrace()
	local ent = Trace.Entity
	local InRange = (Trace.HitPos - self.Owner:GetPos()):Length() < self.MaxDistance
	local HIT = IsValid( ent ) and simfphys.IsCar( ent ) and InRange

	if SERVER then
		self.Owner.usedFuel = self.Owner.usedFuel or 0
		if self.Owner.usedFuel >= self.Owner.usedFuelMax then
			self:SetNetVar('NoFuel', true)
			return
		end

		local fuelUse = math.min(self.RefilAmount, self.Owner.usedFuelMax - self.Owner.usedFuel)

		if HIT then
			local Fuel = ent:GetFuel()
			local MaxFuel = ent:GetMaxFuel()

			if self:IsAimingAt( ent:GetFuelPos() ) and Fuel < MaxFuel then
				timer.Simple(0.2, function()
					if not IsValid( ent ) or not IsValid( self ) or not IsValid( self.Owner ) then return end
					if self:GetFuelType() ~=  ent:GetFuelType() then return end

					local newFuel = Fuel + fuelUse
					ent:SetFuel(newFuel)
					ent:SetNetVar('Fuel', newFuel)

					timer.Simple(0.2, function()
						if self:GetFuelType() == FUELTYPE_ELECTRIC then
							sound.Play( Sound( "items/battery_pickup.wav" ), Trace.HitPos, 50)

							local effectdata = EffectData()
								effectdata:SetOrigin( Trace.HitPos )
								effectdata:SetNormal( Trace.HitNormal * 3 )
								effectdata:SetMagnitude( 2 )
								effectdata:SetRadius( 8 )
							util.Effect( "Sparks", effectdata, true, true )

							self.Owner.usedFuel = self.Owner.usedFuel + fuelUse
						else
							sound.Play( Sound( "vehicles/jetski/jetski_no_gas_start.wav" ), Trace.HitPos, 65)
						end
					end)
				end)
			end
		end

		if self:GetFuelType() ~= FUELTYPE_ELECTRIC then
			self.Owner.usedFuel = self.Owner.usedFuel + fuelUse
		end

	end
	self:SetNextPrimaryFire( CurTime() + 0.5 )
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	return true
end

function SWEP:Holster()
	return true
end
