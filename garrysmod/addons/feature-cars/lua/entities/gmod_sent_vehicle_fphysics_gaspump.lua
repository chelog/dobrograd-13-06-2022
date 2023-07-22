AddCSLuaFile()

ENT.Type	= 'anim'
ENT.PrintName	= 'gas pump (petrol)'
ENT.Category	= 'simfphys'

ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar( 'Entity',0, 'User' )
	self:NetworkVar( 'Bool',0, 'Active' )
	self:NetworkVar( 'Float',0, 'FuelUsed' )

	if SERVER then
		self:NetworkVarNotify( 'Active', self.OnActiveChanged )
	end
end

local function bezier(p0, p1, p2, p3, t)
	local e = p0 + t * (p1 - p0)
	local f = p1 + t * (p2 - p1)
	local g = p2 + t * (p3 - p2)

	local h = e + t * (f - e)
	local i = f + t * (g - f)

	local p = h + t * (i - h)

	return p
end

if CLIENT then
	local cable = Material( 'cable/cable2' )
	local colors = CFG.skinColors

	surface.CreateFont( 'simfphys_gaspump', {
		font = 'Calibri',
		size = 34,
		weight = 300,
		antialias = true,
		extended = true
	})

	surface.CreateFont( 'simfphys_gaspump2', {
		font = 'Consolas',
		size = 22,
		weight = 300,
		antialias = true,
		extended = true
	})

	surface.CreateFont( 'simfphys_gaspump_note', {
		font = 'Calibri',
		size = 16,
		weight = 200,
		antialias = true,
		extended = true
	})

	local function GetDigit( value )
		local fvalue = math.floor(value,0)

		local decimal = 1000 + (value - fvalue) * 1000

		local digit1 =  fvalue % 10
		local digit2 =  (fvalue - digit1) % 100
		local digit3 = (fvalue - digit1 - digit2) % 1000

		local digit4 =  decimal % 10
		local digit5 =  (decimal - digit4) % 100
		local digit6 = (decimal - digit4 - digit5) % 1000

		local digits = {
			[1] = math.Round(digit1,0),
			[2] = math.Round(digit2 / 10,0),
			[3] = math.Round(digit3 / 100,0),
			[4] = math.Round(digit5 / 10,0),
			[5] = math.Round(digit6 / 100,0),
		}
		return digits
	end

	function ENT:Draw()
		self:DrawModel()

		if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 350000 then return end

		local pos = self:LocalToWorld( Vector(10,0,45) )
		local ang = self:LocalToWorldAngles( Angle(0,90,90) )
		local ply = self:GetUser()

		local startPos = self:LocalToWorld( Vector(0.06,-17.77,55.48) )
		local p2 = self:LocalToWorld( Vector(8,-17.77,30) )
		local p3 = self:LocalToWorld( Vector(0,-20,30) )
		local endPos = self:LocalToWorld( Vector(0.06,-20.3,37) )

		if IsValid( ply ) then
			local id = ply:LookupAttachment('anim_attachment_rh')
			local attachment = ply:GetAttachment( id )

			if not attachment then return end

			endPos = (attachment.Pos + attachment.Ang:Forward() * -3 + attachment.Ang:Right() * 2 + attachment.Ang:Up() * -3.5)
			p3 = endPos + attachment.Ang:Right() * 5 - attachment.Ang:Up() * 20
		end

		for i = 1,15 do
			local active = IsValid( ply )

			local de = active and 1 or 2

			if (not active and i > 1) or active then

				local sp = bezier(startPos, p2, p3, endPos, (i - de) / 15)
				local ep = bezier(startPos, p2, p3, endPos, i / 15)

				render.SetMaterial( cable )
				render.DrawBeam( sp, ep, 2, 1, 1, Color( 100, 100, 100, 255 ) )
			end
		end

		cam.Start3D2D( self:LocalToWorld( Vector(10,0,45) ), self:LocalToWorldAngles( Angle(0,90,90) ), 0.1 )
			draw.NoTexture()
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawRect( -150, -120, 300, 240 )

			draw.RoundedBox( 5, -130, -110, 260, 200, colors.g )
			draw.RoundedBox( 5, -128, -108, 256, 196, colors.bg )

			-- draw.RoundedBox( 5, -92, -36, 184, 32, Color( 102,170,170, 150 ) )
			draw.RoundedBox( 5, -90, -14, 180, 28, Color( 238, 238, 238, 255 ) )
			draw.RoundedBox( 5, -88, -12, 19, 24, Color( 255, 255, 255, 255 ) )
			draw.RoundedBox( 5, -68, -12, 19, 24, Color( 255, 255, 255, 255 ) )
			draw.RoundedBox( 5, -48, -12, 19, 24, Color( 255, 255, 255, 255 ) )
			draw.RoundedBox( 5, -23, -12, 19, 24, Color( 255, 255, 255, 255 ) )
			draw.RoundedBox( 5, -3, -12, 19, 24, Color( 255, 255, 255, 255 ) )
			draw.RoundedBox( 5, 23, -12, 66, 24, Color( 255, 255, 255, 255 ) )

			-- draw.RoundedBox( 5, -91, -25, 182, 30, Color( 240, 200, 0, 150 ) )
			-- draw.RoundedBox( 5, -90, -24, 180, 28, Color( 50, 50, 50, 255 ) )
			-- draw.RoundedBox( 5, -88, -22, 19, 24, Color( 0, 0, 0, 255 ) )
			-- draw.RoundedBox( 5, -68, -22, 19, 24, Color( 0, 0, 0, 255 ) )
			-- draw.RoundedBox( 5, -48, -22, 19, 24, Color( 0, 0, 0, 255 ) )
			-- draw.RoundedBox( 5, -28, -22, 19, 24, Color( 0, 0, 0, 255 ) )
			-- draw.RoundedBox( 5, -8, -22, 19, 24, Color( 0, 0, 0, 255 ) )
			-- draw.RoundedBox( 5, 12, -22, 76, 24, Color( 0, 0, 0, 255 ) )

			draw.SimpleText( L.liters, 'simfphys_gaspump2', 55, -10, Color( 0,0,0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			-- draw.SimpleText( 'ГАЛЛОНЫ', 'simfphys_gaspump', 50, -20, Color( 0,0,0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

			local liter = self:GetFuelUsed()
			-- local gallon = liter * 0.264172
			local l_digits = GetDigit( math.Round( liter, 2) )
			-- local g_digits = GetDigit( math.Round( gallon, 2) )

			draw.SimpleText( l_digits[4], 'simfphys_gaspump2', 11, -10, Color( 0,0,0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			draw.SimpleText( l_digits[5], 'simfphys_gaspump2', -9, -10, Color( 0,0,0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			draw.SimpleText( '.', 'simfphys_gaspump2', -21, -8, Color( 0,0,0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			draw.SimpleText( l_digits[1], 'simfphys_gaspump2', -34, -10, Color( 0,0,0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			draw.SimpleText( l_digits[2], 'simfphys_gaspump2', -54, -10, Color( 0,0,0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			draw.SimpleText( l_digits[3], 'simfphys_gaspump2', -74, -10, Color( 0,0,0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )


			-- draw.SimpleText( g_digits[4], 'simfphys_gaspump', 6, -20, Color( 200, 200, 200, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			-- draw.SimpleText( g_digits[5], 'simfphys_gaspump', -14, -20, Color( 200, 200, 200, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			-- draw.SimpleText( ',', 'simfphys_gaspump', -26, -15, Color( 200, 200, 200, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			-- draw.SimpleText( g_digits[1], 'simfphys_gaspump', -34, -20, Color( 200, 200, 200, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			-- draw.SimpleText( g_digits[2], 'simfphys_gaspump', -54, -20, Color( 200, 200, 200, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			-- draw.SimpleText( g_digits[3], 'simfphys_gaspump', -74, -20, Color( 200, 200, 200, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )

			draw.SimpleText( L.before_pay, 'simfphys_gaspump_note', 0, 50, Color( 238, 238, 238, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			draw.SimpleText( L.price2_for_liter, 'simfphys_gaspump_note', 0, 65, Color( 238, 238, 238, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

			draw.SimpleText( L.petrol, 'simfphys_gaspump', 0, -60, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

		cam.End3D2D()
	end

	net.Receive('dbg.fuelPurchase', function(len)
		Derma_StringRequest(
			L.buy_fuel,
			L.buy2_fuel,
			'50',
		function(res)
			local amount = tonumber(res)
			if not amount or amount <= 0 then
				octolib.notify.show('warning', L.incorrect_quantity)
				return
			end

			amount = math.min(amount, 500)
			net.Start('dbg.fuelPurchase')
				net.WriteUInt(amount, 10)
			net.SendToServer()
		end,
		function()
		end,
			L.buy,
			L.cancel
		)
	end)

	return
else
	util.AddNetworkString('dbg.fuelPurchase')
	net.Receive('dbg.fuelPurchase', function(len, ply)
		local amount = net.ReadUInt(10)
		local wep = ply:GetWeapon('weapon_simfillerpistol')
		if IsValid(wep) then
			local price = amount * simfphys.fuelPrices[wep:GetFuelType()]
			if not ply:canAfford(price) then
				ply:Notify('warning', L.not_enough_money)
				return
			end

			ply:addMoney(-price)
			ply:Notify(L.fuel_buy:format(amount, DarkRP.formatMoney(price)))
			ply.usedFuel = 0
			ply.usedFuelMax = amount
		else
			ply:Notify('warning', L.how_you_do_this)
		end
	end)
end

function ENT:Use( ply )
	if not self:GetActive() then
		if not ply.gas_InUse then
			ply.usedFuel = 0
			ply.usedFuelMax = 0
			self:SetActive( true )
			self:SetUser( ply )
			ply:Give( 'weapon_simfillerpistol' )
			ply:SelectWeapon( 'weapon_simfillerpistol' )
			ply.gas_InUse = true

			local weapon = ply:GetActiveWeapon()
			if IsValid( weapon ) and weapon:GetClass() == 'weapon_simfillerpistol' then
				weapon:SetFuelType( FUELTYPE_PETROL )
			end

			net.Start('dbg.fuelPurchase')
			net.Send(ply)
		end
	else
		if ply == self:GetUser() then
			ply:StripWeapon( 'weapon_simfillerpistol' )
			self:SetActive( false )
			self:SetUser( NULL )
			ply.gas_InUse = false
		end
	end
end

function ENT:OnActiveChanged( name, old, new)
	if new == old then return end

	if new then
		if self.sound then
			self.sound:Stop()
			self.sound = nil
		end
		self.sound = CreateSound(self, 'vehicles/crane/crane_idle_loop3.wav')
		self.sound:PlayEx(0,0)
		self.sound:ChangeVolume( 0.2,2 )
		self.sound:ChangePitch( 255,3 )
		if IsValid( self.PumpEnt ) then
			self.PumpEnt:SetNoDraw( true )
		end
	else
		if IsValid( self.PumpEnt ) then
			self.PumpEnt:SetNoDraw( false )
		end

		if self.sound then
			self.sound:ChangeVolume( 0,2 )
			self.sound:ChangePitch( 0,3 )
		end
	end
end

function ENT:Initialize()
	self:SetModel( 'models/props_wasteland/gaspump001a.mdl' )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

	self.PumpEnt = ents.Create( 'prop_dynamic' )
	self.PumpEnt:SetModel( 'models/props_equipment/gas_pump_p13.mdl' )
	self.PumpEnt:SetPos( self:LocalToWorld( Vector(-0.2,-14.6,45.7) ) )
	self.PumpEnt:SetAngles( self:LocalToWorldAngles( Angle(-0.3,92.3,-0.1) ) )
	self.PumpEnt:SetMoveType( MOVETYPE_NONE )
	self.PumpEnt:Spawn()
	self.PumpEnt:Activate()
	self.PumpEnt:SetNotSolid( true )
	self.PumpEnt:DrawShadow( false )
	self.PumpEnt:SetParent( self )

	local PObj = self:GetPhysicsObject()
	if not IsValid( PObj ) then return end

	PObj:EnableMotion( false )
end

function ENT:Think()
	self:NextThink( CurTime() + 0.5 )

	local ply = self:GetUser()
	if IsValid( ply ) then
		self:SetFuelUsed( ply.usedFuel )

		local Dist = (ply:GetPos() - self:GetPos()):Length()

		if ply:Alive() then
			if ply:InVehicle() then
				if ply:HasWeapon( 'weapon_simfillerpistol' ) then
					ply:StripWeapon( 'weapon_simfillerpistol' )
				end
				ply.gas_InUse = false
				self:Disable()
			else
				if ply:HasWeapon( 'weapon_simfillerpistol' ) then
					if not IsValid(ply:GetActiveWeapon()) or ply:GetActiveWeapon():GetClass() ~= 'weapon_simfillerpistol' or Dist >= 280 then
						ply:StripWeapon( 'weapon_simfillerpistol' )
						ply.gas_InUse = false
						self:Disable()
					end
				else
					ply.gas_InUse = false
					self:Disable()
				end
			end
		else
			ply.gas_InUse = false
			self:Disable()
		end
	end

	return true
end

function ENT:Disable()
	self:SetUser( NULL )
	self:SetActive( false )
end

function ENT:OnRemove()
	if self.sound then
		self.sound:Stop()
	end

	local ply = self:GetUser()

	if IsValid( ply ) then
		ply.gas_InUse = false
		if ply:Alive() then
			if ply:HasWeapon( 'weapon_simfillerpistol' ) then
				ply:StripWeapon( 'weapon_simfillerpistol' )
			end
		end
	end
end

function ENT:OnTakeDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )
end

function ENT:PhysicsCollide( data, physobj )
end
