local V = {
	Name = 'Benson',
	Model = 'models/octoteam/vehicles/benson.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Индустриальные',
	SpawnOffset = Vector(0,0,30),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Индустриальные',

	Members = {
		Mass = 7500.0,

		EnginePos = Vector(140,0,10),

		LightsTable = 'gta4_benson',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,6)..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(113,17,113)}
				-- CarCols[2] = {REN.GTA4ColorTable(116,108,116)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 1, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 1, 0, 2) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/benson_wheel.mdl',
		CustomWheelModel_R = 'models/octoteam/vehicles/benson_wheel_r.mdl',

		CustomWheelPosFL = Vector(132,45,-25),
		CustomWheelPosFR = Vector(132,-45,-25),
		CustomWheelPosRL = Vector(-140,46,-25),
		CustomWheelPosRR = Vector(-140,-46,-25),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,25),

		CustomSteerAngle = 35,

		SeatOffset = Vector(65,-23.5,50),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(75,-22,3),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-40.3,16.3,-25),
				ang = Angle(-100,-25,0),
			},
		},

		FrontHeight = 18,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 700,

		RearHeight = 18,
		RearConstant = 50000,
		RearDamping = 3000,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 700,

		TurnSpeed = 3,

		MaxGrip = 103,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 45,
		BulletProofTires = false,

		IdleRPM = 700,
		LimitRPM = 4500,
		PeakTorque = 120.0,
		PowerbandStart = 1700,
		PowerbandEnd = 4000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(60,57,-14),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 140,

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

		snd_horn = 'octoteam/vehicles/horns/benson_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/DUMP_VALVE.wav',

		DifferentialGear = 0.12,
		Gears = {-0.4,0,0.2,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_benson', V )

local light_table = {
	L_HeadLampPos = Vector(168,43,-6),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(168,-43,-6),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-224,53.4,84),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-224,-53.4,84),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(168,43,-6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(168,-43,-6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(99,21,32),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(168,43,-6),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(168,-43,-6),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(99,19.5,32),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-224,53.4,84),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-224,-53.4,84),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-225,53.4,25),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-225,-53.4,25),
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
				pos = Vector(160.2,44.6,7.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(99,30,32),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeLeft = {
			{
				pos = Vector(-225,53.4,33),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
		Right = {
			{
				pos = Vector(160.2,-44.6,7.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(99,29,32),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeRight = {
			{
				pos = Vector(-225,-53.4,33),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[2] = '',
				[8] = '',
				[11] = '',
			},
			Brake = {
				[2] = '',
				[8] = 'models/gta4/vehicles/benson/detail2_on',
				[11] = '',
			},
			Reverse = {
				[2] = '',
				[8] = '',
				[11] = 'models/gta4/vehicles/benson/detail2_on',
			},
			Brake_Reverse = {
				[2] = '',
				[8] = 'models/gta4/vehicles/benson/detail2_on',
				[11] = 'models/gta4/vehicles/benson/detail2_on',
			},
		},
		on_lowbeam = {
			Base = {
				[2] = 'models/gta4/vehicles/benson/detail2_on',
				[8] = '',
				[11] = '',
			},
			Brake = {
				[2] = 'models/gta4/vehicles/benson/detail2_on',
				[8] = 'models/gta4/vehicles/benson/detail2_on',
				[11] = '',
			},
			Reverse = {
				[2] = 'models/gta4/vehicles/benson/detail2_on',
				[8] = '',
				[11] = 'models/gta4/vehicles/benson/detail2_on',
			},
			Brake_Reverse = {
				[2] = 'models/gta4/vehicles/benson/detail2_on',
				[8] = 'models/gta4/vehicles/benson/detail2_on',
				[11] = 'models/gta4/vehicles/benson/detail2_on',
			},
		},
		on_highbeam = {
			Base = {
				[2] = 'models/gta4/vehicles/benson/detail2_on',
				[8] = '',
				[11] = '',
			},
			Brake = {
				[2] = 'models/gta4/vehicles/benson/detail2_on',
				[8] = 'models/gta4/vehicles/benson/detail2_on',
				[11] = '',
			},
			Reverse = {
				[2] = 'models/gta4/vehicles/benson/detail2_on',
				[8] = '',
				[11] = 'models/gta4/vehicles/benson/detail2_on',
			},
			Brake_Reverse = {
				[2] = 'models/gta4/vehicles/benson/detail2_on',
				[8] = 'models/gta4/vehicles/benson/detail2_on',
				[11] = 'models/gta4/vehicles/benson/detail2_on',
			},
		},
		turnsignals = {
			left = {
				[9] = 'models/gta4/vehicles/benson/detail2_on'
			},
			right = {
				[7] = 'models/gta4/vehicles/benson/detail2_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_benson', light_table)