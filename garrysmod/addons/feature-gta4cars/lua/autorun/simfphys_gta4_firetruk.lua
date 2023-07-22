sound.Add({
	name = 'FIRETRUK_HORN',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	sound = 'octoteam/vehicles/fire/engine/horn.wav'
} )

local V = {
	Name = 'Fire Truck',
	Model = 'models/octoteam/vehicles/firetruk.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Службы',
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Службы',

	Members = {
		Mass = 3000,
		Trunk = { 100 },

		EnginePos = Vector(160,0,0),

		LightsTable = 'gta4_firetruk',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(113,28,113)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 1, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 1, 1, 2) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		ModelInfo = {
			WheelColor = Color(150,8,0),
		},

		CustomWheelModel = 'models/octoteam/vehicles/firetruk_wheel.mdl',
		CustomWheelModel_R = 'models/octoteam/vehicles/firetruk_wheel_r.mdl',

		CustomWheelPosFL = Vector(104,38,-25),
		CustomWheelPosFR = Vector(104,-38,-25),
		CustomWheelPosRL = Vector(-91,38,-25),
		CustomWheelPosRR = Vector(-91,-38,-25),
		CustomWheelAngleOffset = Angle(0,-90,0),

		FrontWheelRadius = 23.1,
		RearWheelRadius = 23.2,

		CustomMassCenter = Vector(0,0,35),

		CustomSteerAngle = 35,

		SeatOffset = Vector(125,-27,30),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(130,-27,-2),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
			{
				pos = Vector(42,-27,4),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(42,0,4),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(42,27,4),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(94,-27,4),
				ang = Angle(0,90,0)
			},
			{
				pos = Vector(94,27,4),
				ang = Angle(0,90,0)
			},
		},

		FrontHeight = 6,
		FrontConstant = 65000,
		FrontDamping = 2000,
		FrontRelativeDamping = 2000,

		RearHeight = 6,
		RearConstant = 65000,
		RearDamping = 2000,
		RearRelativeDamping = 2000,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 70,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 4500,
		PeakTorque = 60,
		PowerbandStart = 1700,
		PowerbandEnd = 4300,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 2,

		FuelFillPos = Vector(-112,53,7),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 100,

		AirFriction = -65,
		PowerBias = 0,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/firetruk_idle.wav',

		snd_low = 'octoteam/vehicles/firetruk_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/firetruk_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/firetruk_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/firetruk_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/firetruk_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/fire/engine/horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/DUMP_VALVE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.1,0,0.1,0.16,0.23,0.32,0.42},

		Dash = { pos = Vector(152.660, 25.913, 20.201), ang = Angle(-0.0, -90.0, 68.9) },
		Radio = { pos = Vector(154.534, 3.947, 20.433), ang = Angle(-16.9, 155.1, 3.1) },
		Plates = {
			Front = { pos = Vector(188.185, 0, -20.485), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-153.702, 12.336, -14.985), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			left = {
				pos = Vector(156.945, 51.876, 39.757),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(156.559, -52.183, 42.992),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_firetruk', V )

local light_table = {
	L_HeadLampPos = Vector(172,34,1),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(172,-34,1),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-155,38,7),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-155,-38,7),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(172,34,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(172,-34,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(154,30,22),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(172,26,1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(172,-26,1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(154,27.5,22),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-155,38,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-155,-38,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-155,38,-5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-155,-38,-5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-155,38,-11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-155,-38,-11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	ems_sounds = {'octoteam/vehicles/fire/engine/siren1.wav','octoteam/vehicles/fire/engine/siren2.wav','octoteam/vehicles/fire/engine/siren3.wav'},
	ems_sprites = {
		{
			pos = Vector(56,31,65),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 180,
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
			pos = Vector(-151,32,63),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 170,
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
			pos = Vector(140,31,65),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 180,
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
			pos = Vector(148,0,65),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 170,
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
			pos = Vector(140,-31,65),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 180,
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
			pos = Vector(-151,-32,63),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 170,
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
			pos = Vector(56,-31,65),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 180,
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
				pos = Vector(172,31,11),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-155,38,1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(153.5,28.9,21.5),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(172,-31,11),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-155,-38,1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(153.5,23.9,21.5),
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
				[10] = '',
				[14] = '',
				[6] = ''
			},
			Brake = {
				[3] = '',
				[10] = '',
				[14] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[6] = ''
			},
			Reverse = {
				[3] = '',
				[10] = '',
				[14] = '',
				[6] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on'
			},
			Brake_Reverse = {
				[3] = '',
				[10] = '',
				[14] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[6] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on'
			},
		},
		on_lowbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[10] = '',
				[14] = '',
				[6] = ''
			},
			Brake = {
				[3] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[10] = '',
				[14] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[6] = ''
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[10] = '',
				[14] = '',
				[6] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on'
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[10] = '',
				[14] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[6] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on'
			},
		},
		on_highbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[10] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[14] = '',
				[7] = ''
			},
			Brake = {
				[3] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[10] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[14] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[7] = ''
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[10] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[14] = '',
				[7] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on'
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[10] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[14] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on',
				[7] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on'
			},
		},
		turnsignals = {
			left = {
				[11] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on'
			},
			right = {
				[15] = 'models/gta4/vehicles/firetruk/firetruck_lights_glass_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_firetruk', light_table)
