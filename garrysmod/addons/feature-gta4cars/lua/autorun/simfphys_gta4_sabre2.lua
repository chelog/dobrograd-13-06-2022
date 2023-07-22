local V = {
	Name = 'Sabre (Beater)',
	Model = 'models/octoteam/vehicles/sabre2.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Маслкары',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Маслкары',

	Members = {
		Mass = 1700.0,

		EnginePos = Vector(70,0,10),

		LightsTable = 'gta4_sabre2',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,1))
			-- ent:SetBodyGroups('0'..math.random(0,2)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(3,1,8)}
				-- CarCols[2] =  {REN.GTA4ColorTable(4,1,8)}
				-- CarCols[3] =  {REN.GTA4ColorTable(10,3,8)}
				-- CarCols[4] =  {REN.GTA4ColorTable(11,11,12)}
				-- CarCols[5] =  {REN.GTA4ColorTable(20,1,12)}
				-- CarCols[6] =  {REN.GTA4ColorTable(22,6,12)}
				-- CarCols[7] =  {REN.GTA4ColorTable(28,0,4)}
				-- CarCols[8] =  {REN.GTA4ColorTable(31,34,31)}
				-- CarCols[9] =  {REN.GTA4ColorTable(34,34,34)}
				-- CarCols[10] = {REN.GTA4ColorTable(39,39,39)}
				-- CarCols[11] = {REN.GTA4ColorTable(49,49,50)}
				-- CarCols[12] = {REN.GTA4ColorTable(52,52,50)}
				-- CarCols[13] = {REN.GTA4ColorTable(57,52,50)}
				-- CarCols[14] = {REN.GTA4ColorTable(68,64,63)}
				-- CarCols[15] = {REN.GTA4ColorTable(69,69,63)}
				-- CarCols[16] = {REN.GTA4ColorTable(72,72,72)}
				-- CarCols[17] = {REN.GTA4ColorTable(95,1,90)}
				-- CarCols[18] = {REN.GTA4ColorTable(98,98,98)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
			REN.GTA4BeaterInit(ent)
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
			REN.GTA4Beater(ent)
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/sabre2_wheel.mdl',

		CustomWheelPosFL = Vector(58,31,-7),
		CustomWheelPosFR = Vector(58,-31,-7),
		CustomWheelPosRL = Vector(-58,31,-7),
		CustomWheelPosRR = Vector(-58,-31,-7),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-13,-17,22),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(0,-17,-10),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-94,22,-11),
				ang = Angle(-90,-10,0),
				OnBodyGroups = {
					[1] = {0},
				}
			},
			{
				pos = Vector(-93.2,-26.9,-13.6),
				ang = Angle(-100,35,0),
				OnBodyGroups = {
					[1] = {0},
				}
			},
			{
				pos = Vector(-92.7,26.8,-15.3),
				ang = Angle(-100,-25,0),
				OnBodyGroups = {
					[1] = {1},
				}
			},
			{
				pos = Vector(-33.1,29,-12.7),
				ang = Angle(-90,-80,0),
				OnBodyGroups = {
					[1] = {2},
				}
			},
			{
				pos = Vector(-36.9,29,-12.7),
				ang = Angle(-90,-75,0),
				OnBodyGroups = {
					[1] = {2},
				}
			},
		},

		FrontHeight = 9,
		FrontConstant = 25000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 11,
		RearConstant = 25000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 72,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 20,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 140.0,
		PowerbandStart = 1700,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-62,35,14),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 80,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 0.9,
		snd_idle = 'octoteam/vehicles/faction_idle.wav',

		snd_low = 'octoteam/vehicles/faction_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/faction_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/faction_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/faction_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/faction_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/sabre2_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.14,
		Gears = {-0.5,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_sabre2', V )

local light_table = {
	L_HeadLampPos = Vector(95,28,7.7),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(95,-28,7.7),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-99,30,14),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-99,-30,14),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(95,28,7.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(95,-28,7.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(18.6,24.8,18),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(95,28,7.7),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(95,-28,7.7),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(18.1,24.8,17),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-101,30,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-101,-30,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-99,30,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-99,-30,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-103,27,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-103,-27,7),
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
				pos = Vector(94,33,7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-102,33,7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,100,0,150),
			},
		},
		Right = {
			{
				pos = Vector(94,-33,7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-102,-33,7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,100,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[3] = '',
				[9] = '',
				[6] = '',
			},
			Brake = {
				[3] = '',
				[9] = 'models/gta4/vehicles/sabre/carlito_lights_on',
				[6] = '',
			},
			Reverse = {
				[3] = '',
				[9] = '',
				[6] = 'models/gta4/vehicles/sabre/carlito_lights_on',
			},
			Brake_Reverse = {
				[3] = '',
				[9] = 'models/gta4/vehicles/sabre/carlito_lights_on',
				[6] = 'models/gta4/vehicles/sabre/carlito_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/sabre/carlito_lights_on',
				[9] = '',
				[6] = '',
			},
			Brake = {
				[3] = 'models/gta4/vehicles/sabre/carlito_lights_on',
				[9] = 'models/gta4/vehicles/sabre/carlito_lights_on',
				[6] = '',
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/sabre/carlito_lights_on',
				[9] = '',
				[6] = 'models/gta4/vehicles/sabre/carlito_lights_on',
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/sabre/carlito_lights_on',
				[9] = 'models/gta4/vehicles/sabre/carlito_lights_on',
				[6] = 'models/gta4/vehicles/sabre/carlito_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/sabre/carlito_lights_on',
				[9] = '',
				[6] = '',
			},
			Brake = {
				[3] = 'models/gta4/vehicles/sabre/carlito_lights_on',
				[9] = 'models/gta4/vehicles/sabre/carlito_lights_on',
				[6] = '',
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/sabre/carlito_lights_on',
				[9] = '',
				[6] = 'models/gta4/vehicles/sabre/carlito_lights_on',
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/sabre/carlito_lights_on',
				[9] = 'models/gta4/vehicles/sabre/carlito_lights_on',
				[6] = 'models/gta4/vehicles/sabre/carlito_lights_on',
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/sabre/carlito_lights_on'
			},
			right = {
				[11] = 'models/gta4/vehicles/sabre/carlito_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_sabre2', light_table)