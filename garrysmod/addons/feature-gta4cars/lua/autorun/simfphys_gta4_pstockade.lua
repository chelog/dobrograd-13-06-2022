local V = {
	Name = 'Police Stockade',
	Model = 'models/octoteam/vehicles/pstockade.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Службы',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Службы',

	Members = {
		Mass = 6500.0,

		EnginePos = Vector(102,0,34),

		LightsTable = 'gta4_pstockade',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(113,74,113)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 1, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 1, 0, 2) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
			REN.GTA4Bullhorn(ent)
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		MaxHealth = 5000,
		IsArmored = true,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/pstockade_wheel.mdl',
		CustomWheelModel_R = 'models/octoteam/vehicles/pstockade_wheel_r.mdl',

		CustomWheelPosFL = Vector(93,44,-4),
		CustomWheelPosFR = Vector(93,-44,-4),
		CustomWheelPosRL = Vector(-93,44,-4),
		CustomWheelPosRR = Vector(-93,-44,-4),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,25),

		CustomSteerAngle = 35,

		SeatOffset = Vector(20,-30,70),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(30,-29,30),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-131,-40,30),
				ang = Angle(0,0,0)
			},
			{
				pos = Vector(-105,-40,30),
				ang = Angle(0,0,0)
			},
			{
				pos = Vector(-131,40,30),
				ang = Angle(0,180,0)
			},
			{
				pos = Vector(-105,40,30),
				ang = Angle(0,180,0)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-56.1,-46.4,-11.3),
				ang = Angle(-90,90,0),
			},
			{
				pos = Vector(-52.1,-46.4,-11.3),
				ang = Angle(-90,90,0),
			},
		},

		FrontHeight = 18,
		FrontConstant = 50000,
		FrontDamping = 2000,
		FrontRelativeDamping = 350,

		RearHeight = 18,
		RearConstant = 50000,
		RearDamping = 2000,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 700,

		TurnSpeed = 3,

		MaxGrip = 148,
		Efficiency = 0.8,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = false,

		IdleRPM = 700,
		LimitRPM = 4500,
		PeakTorque = 120.0,
		PowerbandStart = 1700,
		PowerbandEnd = 4000,
		Turbocharged = true,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-10.1,50.6,6.7),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 160,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/stockade_idle.wav',

		snd_low = 'octoteam/vehicles/stockade_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/stockade_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/stockade_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/stockade_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/stockade_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/stockade_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/DUMP_VALVE.wav',

		DifferentialGear = 0.12,
		Gears = {-0.4,0,0.2,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_pstockade', V )

local light_table = {
	L_HeadLampPos = Vector(128,41,19),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(128,-41,19),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-148.7,42.6,33.4),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-148.7,-42.6,33.4),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(128,41,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(128,-41,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(58,37,55),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(128,41,19),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(128,-41,19),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(58,38,55),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-148.7,42.6,33.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-148.7,-42.6,33.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-148.7,42.6,78.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-148.7,-42.6,78.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},

	ems_sounds = {'GTA4_SIREN_WAIL','GTA4_SIREN_YELP','GTA4_SIREN_WARNING'},
	ems_sprites = {
		{
			pos = Vector(70.7,36,92.8),
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
			pos = Vector(70.7,24,92.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			Colors = {
						Color(0,0,0,0),
						Color(255,255,255,50),
						Color(255,255,255,100),
						--
						Color(255,255,255,150),
						Color(255,255,255,255),
						Color(255,255,255,150),
						--
						Color(255,255,255,100),
						Color(255,255,255,50),
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
			pos = Vector(70.7,12,92.8),
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
			pos = Vector(70.7,0,92.8),
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
						Color(255,255,255,50),
						Color(255,255,255,100),
						--
						Color(255,255,255,150),
						Color(255,255,255,255),
						Color(255,255,255,150),
						--
						Color(255,255,255,100),
						Color(255,255,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(70.7,-12,92.8),
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
			pos = Vector(70.7,-24,92.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			Colors = {
						Color(0,0,0,0),
						Color(255,255,255,50),
						Color(255,255,255,100),
						--
						Color(255,255,255,150),
						Color(255,255,255,255),
						Color(255,255,255,150),
						--
						Color(255,255,255,100),
						Color(255,255,255,50),
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
			pos = Vector(70.7,-36,92.8),
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
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(-148.7,42.6,23.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(60,35,57),
				material = 'gta4/dash_left',
				size = 1,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(-148.7,-42.6,23.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(60,22,57),
				material = 'gta4/dash_right',
				size = 1,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[11] = '',
				[5] = ''
			},
			Brake = {
				[11] = '',
				[5] = 'models/gta4/vehicles/stockade/detail2_on'
			},
		},
		on_lowbeam = {
			Base = {
				[11] = 'models/gta4/vehicles/stockade/detail2_on',
				[5] = ''
			},
			Brake = {
				[11] = 'models/gta4/vehicles/stockade/detail2_on',
				[5] = 'models/gta4/vehicles/stockade/detail2_on'
			},
		},
		on_highbeam = {
			Base = {
				[11] = 'models/gta4/vehicles/stockade/detail2_on',
				[5] = ''
			},
			Brake = {
				[11] = 'models/gta4/vehicles/stockade/detail2_on',
				[5] = 'models/gta4/vehicles/stockade/detail2_on'
			},
		},
		turnsignals = {
			left = {
				[2] = 'models/gta4/vehicles/stockade/detail2_on'
			},
			right = {
				[3] = 'models/gta4/vehicles/stockade/detail2_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_pstockade', light_table)