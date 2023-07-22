local V = {
	Name = 'Ripley',
	Model = 'models/octoteam/vehicles/ripley.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Индустриальные',
	SpawnOffset = Vector(0,0,40),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Индустриальные',
	FLEX = {
		Trailers = {
			inputPos = Vector(199,0,-25),
			inputType = 'ballsocket',
			outputPos = Vector(-167,0,-25),
			outputType = 'ballsocket'
		}
	},

	Members = {
		Mass = 9500.0,

		EnginePos = Vector(0,0,0),

		LightsTable = 'gta4_ripley',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(113,113,113)}
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

		CustomWheelModel = 'models/octoteam/vehicles/ripley_wheel.mdl',

		CustomWheelPosFL = Vector(68,41,-27),
		CustomWheelPosFR = Vector(68,-41,-27),
		CustomWheelPosRL = Vector(-68,41,-27),
		CustomWheelPosRR = Vector(-68,-41,-27),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,25),

		CustomSteerAngle = 45,

		SeatOffset = Vector(130,-38,35),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(137,-38,-20),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},

		StrengthenedSuspension = true,

		FrontHeight = 5,
		FrontConstant = 50000,
		FrontDamping = 2000,
		FrontRelativeDamping = 350,

		RearHeight = 5,
		RearConstant = 50000,
		RearDamping = 2000,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 400,

		TurnSpeed = 3,

		MaxGrip = 150,
		Efficiency = 1,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = false,

		IdleRPM = 700,
		LimitRPM = 3500,
		PeakTorque = 70.0,
		PowerbandStart = 1300,
		PowerbandEnd = 3000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(0,58,-20),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 130,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1.05,
		snd_idle = 'octoteam/vehicles/firetruk_idle.wav',

		snd_low = 'octoteam/vehicles/firetruk_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/firetruk_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/firetruk_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/firetruk_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/firetruk_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'BUS_HORN',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/DUMP_VALVE.wav',

		DifferentialGear = 0.16,
		Gears = {-0.3,0,0.1,0.25,0.35}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_ripley', V )

local light_table = {
	L_HeadLampPos = Vector(193,27,-24),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(193,-27,-24),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-157,46,-7),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-157,-46,-7),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(193,27,-24),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(193,-27,-24),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(169,50,-1),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(193,27,-24),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(193,-27,-24),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(169,49,-1),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-157,46,-7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-157,-46,-7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-157,46,-7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-157,-46,-7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-157,40,-7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-157,-40,-7),
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
				pos = Vector(193,51,-19),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-157,53,-7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(171,48,2),
				material = 'gta4/dash_left',
				size = 1,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(193,-51,-19),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-157,-53,-7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(171,42,2),
				material = 'gta4/dash_right',
				size = 1,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[8] = '',
				[9] = '',
				[12] = ''
			},
			Brake = {
				[8] = '',
				[9] = 'models/gta4/vehicles/ripley/detail2_on',
				[12] = ''
			},
			Reverse = {
				[8] = '',
				[9] = '',
				[12] = 'models/gta4/vehicles/ripley/detail2_on'
			},
			Brake_Reverse = {
				[8] = '',
				[9] = 'models/gta4/vehicles/ripley/detail2_on',
				[12] = 'models/gta4/vehicles/ripley/detail2_on'
			},
		},
		on_lowbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/ripley/detail2_on',
				[9] = 'models/gta4/vehicles/ripley/detail2_on',
				[12] = ''
			},
			Reverse = {
				[8] = 'models/gta4/vehicles/ripley/detail2_on',
				[9] = 'models/gta4/vehicles/ripley/detail2_on',
				[12] = 'models/gta4/vehicles/ripley/detail2_on'
			},
		},
		on_highbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/ripley/detail2_on',
				[9] = 'models/gta4/vehicles/ripley/detail2_on',
				[12] = ''
			},
			Reverse = {
				[8] = 'models/gta4/vehicles/ripley/detail2_on',
				[9] = 'models/gta4/vehicles/ripley/detail2_on',
				[12] = 'models/gta4/vehicles/ripley/detail2_on'
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/ripley/detail2_on'
			},
			right = {
				[11] = 'models/gta4/vehicles/ripley/detail2_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_ripley', light_table)