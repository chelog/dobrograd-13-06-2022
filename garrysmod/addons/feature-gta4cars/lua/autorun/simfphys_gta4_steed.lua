local V = {
	Name = 'Steed',
	Model = 'models/octoteam/vehicles/steed.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Индустриальные',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Индустриальные',

	Members = {
		Mass = 5500.0,

		EnginePos = Vector(110,0,20),

		LightsTable = 'gta4_steed',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,11))
			-- ent:SetBodyGroups('0'..math.random(0,6)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(113,113,113)}
				-- CarCols[2] = {REN.GTA4ColorTable(116,1,115)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 1, 0, 2) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/steed_wheel.mdl',
		CustomWheelModel_R = 'models/octoteam/vehicles/steed_wheel_r.mdl',

		CustomWheelPosFL = Vector(102,34,-5),
		CustomWheelPosFR = Vector(102,-34,-5),
		CustomWheelPosRL = Vector(-104,37,-5),
		CustomWheelPosRR = Vector(-104,-37,-5),
		CustomWheelAngleOffset = Angle(0,-90,0),

		FrontWheelRadius = 15.3,
		RearWheelRadius = 15.3,

		CustomMassCenter = Vector(0,0,25),

		CustomSteerAngle = 40,

		SeatOffset = Vector(37,-20,53),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(50,-22,10),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-52,16,-8),
				ang = Angle(-120,-25,0),
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
		Efficiency = 1,
		GripOffset = 0,
		BrakePower = 45,
		BulletProofTires = false,

		IdleRPM = 700,
		LimitRPM = 5000,
		PeakTorque = 100.0,
		PowerbandStart = 1700,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(85,41,8),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 100,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/burrito_idle.wav',

		snd_low = 'octoteam/vehicles/burrito_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/burrito_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/burrito_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/burrito_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/burrito_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/burrito_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/DUMP_VALVE.wav',

		DifferentialGear = 0.11,
		Gears = {-0.4,0,0.2,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_steed', V )

local light_table = {
	L_HeadLampPos = Vector(132,28,17),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(132,-28,17),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-169,33,-3),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-169,-33,-3),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(132,28,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(132,-28,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(77.5,24,38.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(132,28,17),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(132,-28,17),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(77.5,25,38.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-169,33,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-169,-33,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-169,25,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-169,-25,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-179,37,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-179,-37,14),
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
				pos = Vector(130,37,17),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-169,39,-3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(79,26,41),
				material = 'gta4/dash_left',
				size = 1,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(130,-37,17),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-169,-39,-3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(79,18,41),
				material = 'gta4/dash_right',
				size = 1,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[5] = '',
				[10] = '',
				[9] = '',
			},
			Brake = {
				[5] = '',
				[10] = 'models/gta4/vehicles/steed/steed_lights_on',
				[9] = '',
			},
			Reverse = {
				[5] = '',
				[10] = '',
				[9] = 'models/gta4/vehicles/steed/steed_lights_on',
			},
			Brake_Reverse = {
				[5] = '',
				[10] = 'models/gta4/vehicles/steed/steed_lights_on',
				[9] = 'models/gta4/vehicles/steed/steed_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/steed/steed_lights_on',
				[10] = '',
				[9] = '',
			},
			Brake = {
				[5] = 'models/gta4/vehicles/steed/steed_lights_on',
				[10] = 'models/gta4/vehicles/steed/steed_lights_on',
				[9] = '',
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/steed/steed_lights_on',
				[10] = '',
				[9] = 'models/gta4/vehicles/steed/steed_lights_on',
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/steed/steed_lights_on',
				[10] = 'models/gta4/vehicles/steed/steed_lights_on',
				[9] = 'models/gta4/vehicles/steed/steed_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/steed/steed_lights_on',
				[10] = '',
				[9] = '',
			},
			Brake = {
				[5] = 'models/gta4/vehicles/steed/steed_lights_on',
				[10] = 'models/gta4/vehicles/steed/steed_lights_on',
				[9] = '',
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/steed/steed_lights_on',
				[10] = '',
				[9] = 'models/gta4/vehicles/steed/steed_lights_on',
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/steed/steed_lights_on',
				[10] = 'models/gta4/vehicles/steed/steed_lights_on',
				[9] = 'models/gta4/vehicles/steed/steed_lights_on',
			},
		},
		turnsignals = {
			left = {
				[8] = 'models/gta4/vehicles/steed/steed_lights_on'
			},
			right = {
				[4] = 'models/gta4/vehicles/steed/steed_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_steed', light_table)