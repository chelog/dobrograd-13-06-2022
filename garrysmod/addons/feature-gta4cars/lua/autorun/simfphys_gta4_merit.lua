local V = {
	Name = 'Merit',
	Model = 'models/octoteam/vehicles/merit.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1450,
		Trunk = { 30 },

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_merit',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(1,0,7)}
				-- CarCols[2] =  {REN.GTA4ColorTable(10,0,10)}
				-- CarCols[3] =  {REN.GTA4ColorTable(33,33,27)}
				-- CarCols[4] =  {REN.GTA4ColorTable(45,1,30)}
				-- CarCols[5] =  {REN.GTA4ColorTable(49,49,50)}
				-- CarCols[6] =  {REN.GTA4ColorTable(50,49,51)}
				-- CarCols[7] =  {REN.GTA4ColorTable(57,0,58)}
				-- CarCols[8] =  {REN.GTA4ColorTable(64,64,63)}
				-- CarCols[9] =  {REN.GTA4ColorTable(68,64,8)}
				-- CarCols[10] = {REN.GTA4ColorTable(2,2,63)}
				-- CarCols[11] = {REN.GTA4ColorTable(21,21,72)}
				-- CarCols[12] = {REN.GTA4ColorTable(22,22,72)}
				-- CarCols[13] = {REN.GTA4ColorTable(13,11,91)}
				-- CarCols[14] = {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[15] = {REN.GTA4ColorTable(2,133,63)}
				-- CarCols[16] = {REN.GTA4ColorTable(21,133,72)}
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

		CustomWheelModel = 'models/octoteam/vehicles/merit_wheel.mdl',

		CustomWheelPosFL = Vector(65,32,-16),
		CustomWheelPosFR = Vector(65,-32,-16),
		CustomWheelPosRL = Vector(-59,32,-16),
		CustomWheelPosRR = Vector(-59,-32,-16),
		CustomWheelAngleOffset = Angle(0,90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 32,

		SeatOffset = Vector(0,-19.5,15),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(8,-20,-18),
				ang = Angle(0,-90,15),
				hasRadio = true
			},
			{
				pos = Vector(-27,20,-15),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-27,-20,-15),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-104.4,21.3,-15.2),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 7,
		FrontConstant = 28000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 7,
		RearConstant = 28000,
		RearDamping = 800,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3.5,

		MaxGrip = 45,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 25,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 39,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-82.4,-34.3,9.8),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 45,

		AirFriction = -45,
		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/merit_idle.wav',

		snd_low = 'octoteam/vehicles/merit_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/merit_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/merit_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/merit_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/merit_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/merit_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(30.752, 18.121, 11.628), ang = Angle(-0.0, -90.0, 70.6) },
		Radio = { pos = Vector(33.077, 1.293, 2.084), ang = Angle(-21.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(105.428, 13.770, -11.570), ang = Angle(9.1, 12.8, -0.0) },
			Back = { pos = Vector(-102.606, -0.002, 6.751), ang = Angle(-9.2, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(18.062, 0.002, 25.635),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(28.599, 40.558, 12.955),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(28.430, -40.797, 12.255),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_merit', V )

local light_table = {
	L_HeadLampPos = Vector(95.5,29.2,-1.6),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(95.5,-29.2,-1.6),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-101.7,28,5.9),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-101.7,-28,5.9),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(95.5,29.2,-1.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(95.5,-29.2,-1.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(30.6,24.7,10.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(97.7,23.7,-2),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(97.7,-23.7,-2),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(30.6,24.7,9.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(98.7,29.4,-13.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(98.7,-29.4,-13.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-101.7,28,5.9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-101.7,-28,5.9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-102.7,20.7,5.9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-102.7,-20.7,5.9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-102.2,21.2,10.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-102.2,-21.2,10.4),
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
				pos = Vector(92.4,33.4,-1.1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-100.8,29.6,10.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(31.3,20.8,12.4),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(92.4,-33.4,-1.1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-100.8,-29.6,10.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(31.3,15.5,12.4),
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
				[12] = '',
				[13] = '',
				[11] = ''
			},
			Brake = {
				[3] = '',
				[12] = 'models/gta4/vehicles/merit/police2_lights_on',
				[13] = '',
				[11] = ''
			},
			Reverse = {
				[3] = '',
				[12] = '',
				[13] = 'models/gta4/vehicles/merit/police2_lights_on',
				[11] = ''
			},
			Brake_Reverse = {
				[3] = '',
				[12] = 'models/gta4/vehicles/merit/police2_lights_on',
				[13] = 'models/gta4/vehicles/merit/police2_lights_on',
				[11] = ''
			},
		},
		on_lowbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/merit/police2_lights_on',
				[12] = '',
				[13] = '',
				[11] = ''
			},
			Brake = {
				[3] = 'models/gta4/vehicles/merit/police2_lights_on',
				[12] = 'models/gta4/vehicles/merit/police2_lights_on',
				[13] = '',
				[11] = ''
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/merit/police2_lights_on',
				[12] = '',
				[13] = 'models/gta4/vehicles/merit/police2_lights_on',
				[11] = ''
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/merit/police2_lights_on',
				[12] = 'models/gta4/vehicles/merit/police2_lights_on',
				[13] = 'models/gta4/vehicles/merit/police2_lights_on',
				[11] = ''
			},
		},
		on_highbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/merit/police2_lights_on',
				[12] = '',
				[13] = '',
				[11] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
			Brake = {
				[3] = 'models/gta4/vehicles/merit/police2_lights_on',
				[12] = 'models/gta4/vehicles/merit/police2_lights_on',
				[13] = '',
				[11] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/merit/police2_lights_on',
				[12] = '',
				[13] = 'models/gta4/vehicles/merit/police2_lights_on',
				[11] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/merit/police2_lights_on',
				[12] = 'models/gta4/vehicles/merit/police2_lights_on',
				[13] = 'models/gta4/vehicles/merit/police2_lights_on',
				[11] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
		},
		turnsignals = {
			left = {
				[8] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
			right = {
				[10] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_merit', light_table)