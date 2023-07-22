local V = {
	Name = 'Voodoo',
	Model = 'models/octoteam/vehicles/voodoo.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Маслкары',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Маслкары',

	Members = {
		Mass = 2100.0,

		EnginePos = Vector(65,0,5),

		LightsTable = 'gta4_voodoo',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('00'..math.random(0,1) )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable2(0,0,29,90)}
				-- CarCols[2] =  {REN.GTA4ColorTable2(113,74,113,113)}
				-- CarCols[5] =  {REN.GTA4ColorTable2(1,133,8,113)}
				-- CarCols[4] =  {REN.GTA4ColorTable2(5,3,113,113)}
				-- CarCols[5] =  {REN.GTA4ColorTable2(0,28,90,127)}
				-- CarCols[6] =  {REN.GTA4ColorTable2(31,24,90,113)}
				-- CarCols[7] =  {REN.GTA4ColorTable2(34,32,124,113)}
				-- CarCols[8] =  {REN.GTA4ColorTable2(9,59,113,113)}
				-- CarCols[9] =  {REN.GTA4ColorTable2(102,93,113,113)}
				-- CarCols[10] = {REN.GTA4ColorTable2(109,114,113,113)}
				-- CarCols[11] = {REN.GTA4ColorTable2(68,86,113,113)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/voodoo_wheel.mdl',

		CustomWheelPosFL = Vector(65,34,-10),
		CustomWheelPosFR = Vector(65,-34,-10),
		CustomWheelPosRL = Vector(-64,34,-10),
		CustomWheelPosRR = Vector(-64,-34,-10),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-8,-19,17),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(3,-19,-13),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-104,40,-15),
				ang = Angle(-110,-65,0),
				OnBodyGroups = {
					[1] = {0},
				}
			},
			{
				pos = Vector(-23,44,-16),
				ang = Angle(-80,-80,0),
				OnBodyGroups = {
					[1] = {1},
				}
			},
			{
				pos = Vector(-23,43,-13),
				ang = Angle(-80,-80,0),
				OnBodyGroups = {
					[1] = {1},
				}
			},
			{
				pos = Vector(-23,-44,-16),
				ang = Angle(-80,80,0),
				OnBodyGroups = {
					[1] = {1},
				}
			},
			{
				pos = Vector(-23,-43,-13),
				ang = Angle(-80,80,0),
				OnBodyGroups = {
					[1] = {1},
				}
			},
		},

		FrontHeight = 10,
		FrontConstant = 25000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 10,
		RearConstant = 25000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 80,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 25,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 120.0,
		PowerbandStart = 1700,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = true,
		DoNotStall = false,

		FuelFillPos = Vector(-62,41,9),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 70,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/patriot_idle.wav',

		snd_low = 'octoteam/vehicles/patriot_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/patriot_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/patriot_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/patriot_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/patriot_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/merit_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.11,
		Gears = {-0.5,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_voodoo', V )

local V2 = {}
V2.Name = 'Jamaican Voodoo'
V2.Model = 'models/octoteam/vehicles/voodoo.mdl'
V2.Class = 'gmod_sent_vehicle_fphysics_base'
V2.Category = 'Доброград - Особые'
V2.SpawnOffset = Vector(0,0,10)
V2.SpawnAngleOffset = 90
V2.NAKGame = 'Доброград'
V2.NAKType = 'Маслкары'

local V2Members = {}
for k,v in pairs(V.Members) do
	V2Members[k] = v
end
V2.Members = V2Members
V2.Members.OnSpawn = function(ent)
	-- ent:SetSkin(math.random(0,2))
	ent:SetBodyGroups('011' )

	if (ProxyColor ) then
		-- local CarCols = {}
		-- CarCols[1] =  {REN.GTA4ColorTable2(0,59,113,127)}
		-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
	end

	REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
end
V2.Members.ModelInfo = {
	WheelColor = Color(215,142,16),
},
list.Set('simfphys_vehicles', 'sim_fphys_gta4_voodoo2', V2 )

local light_table = {
	L_HeadLampPos = Vector(95,34,6),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(95,-34,6),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-120,27,3),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-120,-27,3),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(95,34,6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(95,-34,6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(96,26,6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(96,-26,6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(25,29,11),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(95,34,6),size = 40,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(95,-34,6),size = 40,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(96,26,6),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(96,-26,6),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(25,28,11),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-120,27,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-120,-27,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-120,17,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-120,-17,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-118,16,-9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-118,-16,-9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(-120,36,3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(25,23,11),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(-120,-36,3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(25,17,11),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[3] = '',
				[4] = '',
				[13] = '',
			},
			Brake = {
				[3] = '',
				[4] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
				[13] = '',
			},
			Reverse = {
				[3] = '',
				[4] = '',
				[13] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
			},
			Brake_Reverse = {
				[3] = '',
				[4] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
				[13] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
				[4] = '',
				[13] = '',
			},
			Brake = {
				[3] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
				[4] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
				[13] = '',
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
				[4] = '',
				[13] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
				[4] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
				[13] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
				[4] = '',
				[13] = '',
			},
			Brake = {
				[3] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
				[4] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
				[13] = '',
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
				[4] = '',
				[13] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
				[4] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
				[13] = 'models/gta4/vehicles/voodoo/voodoo_lights_on',
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/voodoo/voodoo_lights_on'
			},
			right = {
				[11] = 'models/gta4/vehicles/voodoo/voodoo_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_voodoo', light_table)