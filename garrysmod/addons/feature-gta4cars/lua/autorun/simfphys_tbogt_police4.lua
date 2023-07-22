local V = {
	Name = 'Police Stinger',
	Model = 'models/octoteam/vehicles/police4.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Службы',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Службы',

	Members = {
		Mass = 2200.0,

		EnginePos = Vector(70,0,0),

		Backfire = true,

		LightsTable = 'gta4_police4',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(69,69,35)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
			REN.GTA4Bullhorn(ent)
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/police4_wheel.mdl',

		ModelInfo = {
			WheelColor = Color(10,10,10),
		},

		CustomWheelPosFL = Vector(60,30,-14),
		CustomWheelPosFR = Vector(60,-30,-14),
		CustomWheelPosRL = Vector(-60,30,-14),
		CustomWheelPosRR = Vector(-60,-30,-14),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 34,

		SeatOffset = Vector(-5,-18,18),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(7,-17,-12),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-38,17,-12),
				ang = Angle(0,-90,10)
			},
			{
				pos = Vector(-38,-17,-12),
				ang = Angle(0,-90,10)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-100,21,-18),
				ang = Angle(-80,0,0),
			},
			{
				pos = Vector(-100,-21,-18),
				ang = Angle(-80,0,0),
			},
		},

		FrontHeight = 10,
		FrontConstant = 30000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 10,
		RearConstant = 30000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 101,
		Efficiency = 0.75,
		GripOffset = 0,
		BrakePower = 34,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 160.0,
		PowerbandStart = 1700,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = true,
		DoNotStall = false,

		FuelFillPos = Vector(-73,-31,18),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 90,

		PowerBias = 0.65,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/buffalo2_idle.wav',

		snd_low = 'octoteam/vehicles/buffalo2_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/buffalo2_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/buffalo2_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/buffalo2_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/buffalo2_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/huntley_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.25,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tbogt_police4', V )

local light_table = {
	L_HeadLampPos = Vector(87,25,2),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(87,-25,2),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-97,28,10),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-97,-28,10),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(87,25,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},
		{
			pos = Vector(87,-25,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},
		{
			pos = Vector(90,25,-14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},
		{
			pos = Vector(90,-25,-14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},

--[[		{
			pos = Vector(29,25,13),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(87,25,2),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(87,-25,2),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(29,25,12),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(91,24,-12.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(91,-24,-12.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-97,28,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-97,-28,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-97,28,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-97,-28,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-97,0,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-97,29,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-97,-29,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
	},

	ems_sounds = {'GTA4_SIREN_WAIL','GTA4_SIREN_YELP','GTA4_SIREN_WARNING'},
	ems_sprites = {
		{
			pos = Vector(-13,-16,35.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 80,
			Colors = {
						Color(100,100,255,150),
						Color(100,100,255,255),
						Color(100,100,255,150),
						--
						Color(100,100,255,100),
						Color(100,100,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(100,100,255,50),
						Color(100,100,255,100),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-13,-5,35.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			Colors = {
						Color(0,0,0,0),
						Color(255,0,0,50),
						Color(255,0,0,100),
						--
						Color(255,0,0,150),
						Color(255,0,0,255),
						Color(255,0,0,150),
						--
						Color(255,0,0,100),
						Color(255,0,0,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-13,5,35.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 80,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(100,100,255,50),
						Color(100,100,255,100),
						--
						Color(100,100,255,150),
						Color(100,100,255,255),
						Color(100,100,255,150),
						--
						Color(100,100,255,100),
						Color(100,100,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-13,16,35.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(255,0,0,50),
						Color(255,0,0,100),
						--
						Color(255,0,0,150),
						Color(255,0,0,255),
						Color(255,0,0,150),
						--
						Color(255,0,0,100),
						Color(255,0,0,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(93,15,-14.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 80,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(255,0,0,50),
						Color(255,0,0,100),
						--
						Color(255,0,0,150),
						Color(255,0,0,255),
						Color(255,0,0,150),
						--
						Color(255,0,0,100),
						Color(255,0,0,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(93,-15,-14.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			Colors = {
						Color(0,0,0,0),
						Color(100,100,255,50),
						Color(100,100,255,100),
						--
						Color(100,100,255,150),
						Color(100,100,255,255),
						Color(100,100,255,150),
						--
						Color(100,100,255,100),
						Color(100,100,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-65,20.5,22),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 80,
			Colors = {
						Color(255,0,0,150),
						Color(255,0,0,255),
						Color(255,0,0,150),
						--
						Color(255,0,0,100),
						Color(255,0,0,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(255,0,0,50),
						Color(255,0,0,100),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-65,-20.5,22),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			Colors = {
						Color(0,0,0,0),
						Color(100,100,255,50),
						Color(100,100,255,100),
						--
						Color(100,100,255,150),
						Color(100,100,255,255),
						Color(100,100,255,150),
						--
						Color(100,100,255,100),
						Color(100,100,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(83,29,4.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(227,242,255,50),
			},
			{
				pos = Vector(-95,28,16),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(30,21,15),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(83,-29,4.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(227,242,255,50),
			},
			{
				pos = Vector(-95,-28,16),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(30,15,15),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[13] = '',
				[6] = '',
				[14] = '',
				[11] = '',
			},
			Brake = {
				[13] = '',
				[6] = 'models/gta4/vehicles/pres/cts_lights_on',
				[14] = 'models/gta4/vehicles/pres/cts_lights_on',
				[11] = '',
			},
			Reverse = {
				[13] = '',
				[6] = '',
				[14] = '',
				[11] = 'models/gta4/vehicles/pres/cts_lights_on',
			},
			Brake_Reverse = {
				[13] = '',
				[6] = 'models/gta4/vehicles/pres/cts_lights_on',
				[14] = 'models/gta4/vehicles/pres/cts_lights_on',
				[11] = 'models/gta4/vehicles/pres/cts_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[13] = 'models/gta4/vehicles/pres/cts_lights_on',
				[6] = 'models/gta4/vehicles/pres/cts_lights_on',
				[14] = '',
				[11] = '',
			},
			Brake = {
				[13] = 'models/gta4/vehicles/pres/cts_lights_on',
				[6] = 'models/gta4/vehicles/pres/cts_lights_on',
				[14] = 'models/gta4/vehicles/pres/cts_lights_on',
				[11] = '',
			},
			Reverse = {
				[13] = 'models/gta4/vehicles/pres/cts_lights_on',
				[6] = 'models/gta4/vehicles/pres/cts_lights_on',
				[14] = '',
				[11] = 'models/gta4/vehicles/pres/cts_lights_on',
			},
			Brake_Reverse = {
				[13] = 'models/gta4/vehicles/pres/cts_lights_on',
				[6] = 'models/gta4/vehicles/pres/cts_lights_on',
				[14] = 'models/gta4/vehicles/pres/cts_lights_on',
				[11] = 'models/gta4/vehicles/pres/cts_lights_on',
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/pres/cts_lights_on'
			},
			right = {
				[5] = 'models/gta4/vehicles/pres/cts_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_police4', light_table)