local V = {
	Name = 'Police Buffalo',
	Model = 'models/octoteam/vehicles/police3.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Службы',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Службы',

	Members = {
		Mass = 1500,
		Trunk = { 30 },

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_police3',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(113,74,113)}
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

		CustomWheelModel = 'models/octoteam/vehicles/police3_wheel.mdl',

		ModelInfo = {
			WheelColor = Color(10,10,10),
		},

		CustomWheelPosFL = Vector(67,32,-12),
		CustomWheelPosFR = Vector(67,-32,-12),
		CustomWheelPosRL = Vector(-61,32,-12),
		CustomWheelPosRR = Vector(-61,-32,-12),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-5,-17,17),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(8,-17,-15),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-30,18,-15),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-30,-18,-15),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-102,22,-14),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-102,-22,-14),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 5.5,
		FrontConstant = 33000,
		FrontDamping = 1000,
		FrontRelativeDamping = 1000,

		RearHeight = 5.5,
		RearConstant = 33000,
		RearDamping = 1000,
		RearRelativeDamping = 1000,

		FastSteeringAngle = 20,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 5.5,
		CounterSteeringMul = 0.85,

		MaxGrip = 62,
		Efficiency = 1.1,
		GripOffset = 0,
		BrakePower = 42,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6500,
		PeakTorque = 68,
		PowerbandStart = 1200,
		PowerbandEnd = 6200,
		Turbocharged = true,
		Supercharged = true,
		DoNotStall = false,
		PowerBoost = 1.3,

		FuelFillPos = Vector(-61,37,17),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1.05,
		snd_idle = 'octoteam/vehicles/buffalo_idle.wav',

		snd_low = 'octoteam/vehicles/buffalo_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/buffalo_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/buffalo_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/buffalo_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/buffalo_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/police/warning.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.45,
		Gears = {-0.12,0,0.12,0.18,0.24,0.32,0.42},

		Dash = { pos = Vector(22.469, 17.686, 13.903), ang = Angle(-0.0, -90.0, 77.0) },
		Radio = { pos = Vector(28.962, 0.010, 4.947), ang = Angle(-19.6, -180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(103.097, -0.016, -12.006), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-99.164, 0.008, 7.328), ang = Angle(-22.1, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(15.675, 0.030, 25.598),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(29.291, 36.604, 16.617),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(28.574, -37.075, 16.650),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tbogt_police3', V )

local colOff = Color(0,0,0, 0)
local emsCenter = Vector(-4, 0, 35)

local light_table = {
	L_HeadLampPos = Vector(91,29,5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(91,-29,5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-94,35,9),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-94,-35,9),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(91,29,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(91,-29,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(26.5,17,11),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(91,29,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(91,-29,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(26.5,18,11),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(95,30,-10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(95,-30,-10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-94,35,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-94,-35,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-96,30,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-96,-30,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-97,30,6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-97,-30,6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	ems_sounds = {'octoteam/vehicles/police/siren1.wav','octoteam/vehicles/police/siren2.wav','octoteam/vehicles/police/siren3.wav'},
	ems_sprites = {
		--
		-- FRONT
		--
		{
			pos = emsCenter + Vector(7.5, -14, 0),
			material = 'sprites/light_ignorez',
			size = 220,
			Colors = {
				Color(255,0,0, 20), colOff, Color(255,0,0, 20), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, -19.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,25,25, 255), colOff, Color(255,25,25, 255), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, -14, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,25,25, 255), colOff, Color(255,25,25, 255), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, -8.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,25,25, 255), colOff, Color(255,25,25, 255), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, -3, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 18,
			Colors = {
				Color(255,255,255, 255), colOff, Color(255,255,255, 255), colOff,
				Color(255,255,255, 255), colOff, Color(255,255,255, 255), colOff,
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, 0, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 220,
			Colors = {
				Color(255,255,255, 20), colOff, Color(255,255,255, 20), colOff,
				Color(255,255,255, 20), colOff, Color(255,255,255, 20), colOff,
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, 3, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 18,
			Colors = {
				Color(255,255,255, 255), colOff, Color(255,255,255, 255), colOff,
				Color(255,255,255, 255), colOff, Color(255,255,255, 255), colOff,
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, 8.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(0,0,255, 255), colOff, Color(0,0,255, 255), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, 14, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(0,0,255, 255), colOff, Color(0,0,255, 255), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, 19.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(0,0,255, 255), colOff, Color(0,0,255, 255), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, 14, 0),
			material = 'sprites/light_ignorez',
			size = 220,
			Colors = {
				colOff, colOff, colOff, colOff, Color(0,0,255, 20), colOff, Color(0,0,255, 20), colOff,
			},
			Speed = 0.07
		},

		--
		-- REAR
		--
		{
			pos = emsCenter + Vector(-7.5, -14, 0),
			material = 'sprites/light_ignorez',
			size = 220,
			Colors = {
				Color(255,0,0, 20), colOff, Color(255,0,0, 20), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, -19.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,25,25, 255), colOff, Color(255,25,25, 255), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, -14, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,25,25, 255), colOff, Color(255,25,25, 255), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, -8.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,25,25, 255), colOff, Color(255,25,25, 255), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, -3, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 18,
			Colors = {
				Color(255,255,255, 255), colOff, Color(255,255,255, 255), colOff,
				Color(255,255,255, 255), colOff, Color(255,255,255, 255), colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, -3, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 220,
			Colors = {
				Color(255,255,255, 30), colOff, Color(255,255,255, 30), colOff,
				Color(255,255,255, 30), colOff, Color(255,255,255, 30), colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, 3, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 18,
			Colors = {
				Color(255,255,255, 255), colOff, Color(255,255,255, 255), colOff,
				Color(255,255,255, 255), colOff, Color(255,255,255, 255), colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, 8.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(0,0,255, 255), colOff, Color(0,0,255, 255), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, 14, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(0,0,255, 255), colOff, Color(0,0,255, 255), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, 19.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(0,0,255, 255), colOff, Color(0,0,255, 255), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, 14, 0),
			material = 'sprites/light_ignorez',
			size = 220,
			Colors = {
				colOff, colOff, colOff, colOff, Color(0,0,255, 20), colOff, Color(0,0,255, 20), colOff,
			},
			Speed = 0.07
		},

		--
		-- SIDE
		--
		{
			pos = emsCenter + Vector(5, -24, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,0,0, 255), colOff, Color(255,0,0, 255), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(0, -25, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,0,0, 255), colOff, Color(255,0,0, 255), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-5, -24, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,0,0, 255), colOff, Color(255,0,0, 255), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(5, 24, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(0,0,255, 255), colOff, Color(0,0,255, 255), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(0, 25, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(0,0,255, 255), colOff, Color(0,0,255, 255), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-5, 24, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(0,0,255, 255), colOff, Color(0,0,255, 255), colOff,
			},
			Speed = 0.07
		},

		--
		-- HEAD/TAIL LIGHTS
		--
		{
			pos = Vector(97, 30, -10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,255,255, 255), colOff, Color(255,255,255, 255), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = Vector(97, -30, -10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(255,255,255, 255), colOff, Color(255,255,255, 255), colOff,
			},
			Speed = 0.07
		},
		{
			pos = Vector(-97, 30, 6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,255,255, 255), colOff, Color(255,255,255, 255), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = Vector(-97, -30, 6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(255,255,255, 255), colOff, Color(255,255,255, 255), colOff,
			},
			Speed = 0.07
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(95,31,-5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-95,31,14),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(26.5,19,11),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(95,-31,-5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-95,-31,14),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(26.5,16,11),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[10] = '',
				[11] = '',
				[13] = ''
			},
			Brake = {
				[10] = '',
				[11] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[13] = ''
			},
			Reverse = {
				[10] = '',
				[11] = '',
				[13] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
			Brake_Reverse = {
				[10] = '',
				[11] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[13] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = '',
				[13] = ''
			},
			Brake = {
				[10] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[13] = ''
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = '',
				[13] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[13] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = '',
				[13] = ''
			},
			Brake = {
				[10] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[13] = ''
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = '',
				[13] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[11] = 'models/gta4/vehicles/buffalo/buffalo_lights_on',
				[13] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
		},
		turnsignals = {
			left = {
				[9] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
			right = {
				[8] = 'models/gta4/vehicles/buffalo/buffalo_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_police3', light_table)