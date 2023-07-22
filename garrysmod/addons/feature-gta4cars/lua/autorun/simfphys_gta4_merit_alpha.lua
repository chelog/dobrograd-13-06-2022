local V = {
	Name = 'Merit (Alpha)',
	Model = 'models/octoteam/vehicles/police2.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Службы',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Службы',

	Members = {
		Mass = 1700,
		Trunk = { 30 },

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_merit_alpha',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(113,74,113)}
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

		CustomWheelModel = 'models/octoteam/vehicles/police2_wheel.mdl',

		ModelInfo = {
			WheelColor = Color(10,10,10),
		},

		CustomWheelPosFL = Vector(65,32,-16),
		CustomWheelPosFR = Vector(65,-32,-16),
		CustomWheelPosRL = Vector(-59,32,-16),
		CustomWheelPosRR = Vector(-59,-32,-16),
		CustomWheelAngleOffset = Angle(0,-90,0),

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

		FrontHeight = 6,
		FrontConstant = 37000,
		FrontDamping = 1100,
		FrontRelativeDamping = 1100,

		RearHeight = 6,
		RearConstant = 37000,
		RearDamping = 1100,
		RearRelativeDamping = 1100,

		FastSteeringAngle = 15,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 5,
		CounterSteeringMul = 0.85,

		MaxGrip = 56,
		Efficiency = 0.9,
		GripOffset = 0,
		BrakePower = 32,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 7000,
		PeakTorque = 52,
		PowerbandStart = 1200,
		PowerbandEnd = 6600,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 1.2,

		FuelFillPos = Vector(-82.4,-34.3,9.8),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 70,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1.04,
		snd_idle = 'octoteam/vehicles/merit_idle.wav',

		snd_low = 'octoteam/vehicles/merit_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/merit_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/merit_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/merit_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/merit_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/police/warning.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(26.848, 18.013, 8.520), ang = Angle(-0.0, -90.0, 79.2) },
		Radio = { pos = Vector(33.926, 0.008, 4.649), ang = Angle(-22.0, -180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(105.224, 15.504, -11.844), ang = Angle(0.0, 14.5, 0.0) },
			Back = { pos = Vector(-102.317, 0.011, 6.691), ang = Angle(-9.3, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(17.398, -0.002, 26.016),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(27.358, 40.902, 12.988),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(27.295, -40.646, 13.462),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_merit_alpha', V )

local colOff = Color(0,0,0, 0)
local emsCenter = Vector(-1, 0, 34.7)

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

	ems_sounds = {'octoteam/vehicles/police/siren1.wav','octoteam/vehicles/police/siren2.wav','octoteam/vehicles/police/siren3.wav'},
	ems_sprites = {
		--
		-- FRONT
		--
		{
			pos = emsCenter + Vector(7.5, -14, 0),
			material = 'sprites/light_ignorez',
			size = 22,
			Colors = {
				Color(255,135,0,150), colOff, Color(255,135,0,150), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, -19.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,135,0,150), colOff, Color(255,135,0,150), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, -14, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,135,0,150), colOff, Color(255,135,0,150), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, -8.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,135,0,150), colOff, Color(255,135,0,150), colOff, colOff, colOff, colOff, colOff,
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
			size = 22,
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
				colOff, colOff, colOff, colOff, Color(255,135,0,150), colOff, Color(255,135,0,150), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, 14, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(255,135,0,150), colOff, Color(255,135,0,150), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, 19.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(255,135,0,150), colOff, Color(255,135,0,150), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(7.5, 14, 0),
			material = 'sprites/light_ignorez',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(255,135,0,150), colOff, Color(255,135,0,150), colOff,
			},
			Speed = 0.07
		},

		--
		-- REAR
		--
		{
			pos = emsCenter + Vector(-7.5, -14, 0),
			material = 'sprites/light_ignorez',
			size = 22,
			Colors = {
				Color(255,135,0,150), colOff, Color(255,135,0,150), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, -19.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,135,0,150), colOff, Color(255,135,0,150), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, -14, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,135,0,150), colOff, Color(255,135,0,150), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, -8.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,135,0,150), colOff, Color(255,135,0,150), colOff, colOff, colOff, colOff, colOff,
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
			size = 22,
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
				colOff, colOff, colOff, colOff, Color(255,135,0,150), colOff, Color(255,135,0,150), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, 14, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(255,135,0,150), colOff, Color(255,135,0,150), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, 19.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(255,135,0,150), colOff, Color(255,135,0,150), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-7.5, 14, 0),
			material = 'sprites/light_ignorez',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(255,135,0,150), colOff, Color(255,135,0,150), colOff,
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
				Color(255,135,0,150), colOff, Color(255,135,0,150), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(0, -25, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,135,0,150), colOff, Color(255,135,0,150), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-5, -24, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,135,0,150), colOff, Color(255,135,0,150), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(5, 24, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(255,135,0,150), colOff, Color(255,135,0,150), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(0, 25, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(255,135,0,150), colOff, Color(255,135,0,150), colOff,
			},
			Speed = 0.07
		},
		{
			pos = emsCenter + Vector(-5, 24, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(255,135,0,150), colOff, Color(255,135,0,150), colOff,
			},
			Speed = 0.07
		},

		--
		-- HEAD/TAIL LIGHTS
		--
		{
			pos = Vector(98.5, 29.2, -13),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,255,255, 255), colOff, Color(255,255,255, 255), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = Vector(98.5, -29.2, -13),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(255,255,255, 255), colOff, Color(255,255,255, 255), colOff,
			},
			Speed = 0.07
		},
		{
			pos = Vector(-102.2, 21.2, 10.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(255,255,255, 255), colOff, Color(255,255,255, 255), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = Vector(-102.2, -21.2, 10.4),
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
				[4] = '',
				[11] = '',
				[9] = '',
				[5] = ''
			},
			Brake = {
				[4] = '',
				[11] = 'models/gta4/vehicles/merit/police2_lights_on',
				[9] = '',
				[5] = ''
			},
			Reverse = {
				[4] = '',
				[11] = '',
				[9] = 'models/gta4/vehicles/merit/police2_lights_on',
				[5] = ''
			},
			Brake_Reverse = {
				[4] = '',
				[11] = 'models/gta4/vehicles/merit/police2_lights_on',
				[9] = 'models/gta4/vehicles/merit/police2_lights_on',
				[5] = ''
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/merit/police2_lights_on',
				[11] = '',
				[9] = '',
				[5] = ''
			},
			Brake = {
				[4] = 'models/gta4/vehicles/merit/police2_lights_on',
				[11] = 'models/gta4/vehicles/merit/police2_lights_on',
				[9] = '',
				[5] = ''
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/merit/police2_lights_on',
				[11] = '',
				[9] = 'models/gta4/vehicles/merit/police2_lights_on',
				[5] = ''
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/merit/police2_lights_on',
				[11] = 'models/gta4/vehicles/merit/police2_lights_on',
				[9] = 'models/gta4/vehicles/merit/police2_lights_on',
				[5] = ''
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/merit/police2_lights_on',
				[11] = '',
				[9] = '',
				[5] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
			Brake = {
				[4] = 'models/gta4/vehicles/merit/police2_lights_on',
				[11] = 'models/gta4/vehicles/merit/police2_lights_on',
				[9] = '',
				[5] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/merit/police2_lights_on',
				[11] = '',
				[9] = 'models/gta4/vehicles/merit/police2_lights_on',
				[5] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/merit/police2_lights_on',
				[11] = 'models/gta4/vehicles/merit/police2_lights_on',
				[9] = 'models/gta4/vehicles/merit/police2_lights_on',
				[5] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
			right = {
				[8] = 'models/gta4/vehicles/merit/police2_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_merit_alpha', light_table)