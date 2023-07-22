sound.Add({
	name = 'AMBULANCE_WARNING',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	sound = 'octoteam/vehicles/horns/ambulance_rumble.wav'
} )

local V = {
	Name = 'Ambulance',
	Model = 'models/octoteam/vehicles/ambulance.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Службы',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Службы',

	Members = {
		Mass = 3000,
		Trunk = { 100 },

		EnginePos = Vector(100,0,10),

		LightsTable = 'gta4_ambulance',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1) )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(113,28,113)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 1, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
			REN.GTA4Bullhorn(ent)
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/ambulance_wheel.mdl',
		CustomWheelModel_R = 'models/octoteam/vehicles/ambulance_wheel_r.mdl',

		CustomWheelPosFL = Vector(87,39,-17),
		CustomWheelPosFR = Vector(87,-39,-17),
		CustomWheelPosRL = Vector(-88,42,-17),
		CustomWheelPosRR = Vector(-88,-42,-17),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,30),

		CustomSteerAngle = 35,

		SeatOffset = Vector(30,-25,33),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(35,-25,1),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
			{
				pos = Vector(-145,36,1),
				ang = Angle(0,180,0)
			},
			{
				pos = Vector(-145,-36,1),
				ang = Angle(0,0,0)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-58.3,49.5,-21.7),
				ang = Angle(-90,-90,0),
			},
		},

		FrontHeight = 10,
		FrontConstant = 65000,
		FrontDamping = 2000,
		FrontRelativeDamping = 2000,

		RearHeight = 10,
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

		AirFriction = -60,
		PowerBias = 0,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/ambulance_idle.wav',

		snd_low = 'octoteam/vehicles/ambulance_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/ambulance_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/ambulance_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/ambulance_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/ambulance_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'simulated_vehicles/horn_2.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/DUMP_VALVE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.1,0,0.1,0.16,0.23,0.32,0.42},

		Dash = { pos = Vector(60.542, 24.688, 26.905), ang = Angle(-0.0, -90.0, 61.9) },
		Radio = { pos = Vector(62.325, -0.008, 20.204), ang = Angle(-24.9, -180.0, -0.0) },
		Plates = {
			Front = { pos = Vector(119.707, -0.010, -13.295), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-162.513, -0.000, -11.507), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			left = {
				pos = Vector(71.283, 51.079, 33.999),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(71.845, -51.321, 33.811),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_ambulance', V )

local colOff = Color(0,0,0, 0)
local emsCenter = Vector(31, 0, 58.5)
local emsRearCenter = Vector(-164, 0, 71)

local light_table = {
	L_HeadLampPos = Vector(110.8,36.4,11.8),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(110.8,-36.4,11.8),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-163.4,37.7,-11.5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-163.4,-37.7,-11.5),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(110.8,36.4,11.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(110.8,-36.4,11.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(61.1,21,28.1),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(112,27.1,11.8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(112,-27.1,11.8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(61.1,19.5,28.1),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-163.4,37.7,-11.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-163.4,-37.7,-11.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-163.4,30.7,-11.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-163.4,-30.7,-11.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},

	ems_sounds = {'octoteam/vehicles/medic/siren1.wav','octoteam/vehicles/medic/siren2.wav','octoteam/vehicles/medic/siren3.wav'},
	ems_sprites = {
		--
		-- FRONT
		--
		{
			pos = emsCenter + Vector(7.5, -14, 0),
			material = 'sprites/light_ignorez',
			size = 220,
			Colors = {
				Color(0,0,255, 20), colOff, Color(0,0,255, 20), Color(0,0,255, 20), colOff, Color(0,0,255, 20), colOff,
				Color(255,255,255, 8), colOff, Color(255,255,255, 8), Color(255,255,255, 8), colOff, Color(255,255,255, 8), colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsCenter + Vector(7.5, 14, 0),
			material = 'sprites/light_ignorez',
			size = 220,
			Colors = {
				Color(0,0,255, 20), colOff, Color(0,0,255, 20), Color(0,0,255, 20), colOff, Color(0,0,255, 20), colOff,
				Color(255,255,255, 8), colOff, Color(255,255,255, 8), Color(255,255,255, 8), colOff, Color(255,255,255, 8), colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsCenter + Vector(7.5, -19.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(25,25,255, 255), colOff, Color(25,25,255, 255), Color(25,25,255, 255), colOff, Color(25,25,255, 255), colOff,
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsCenter + Vector(7.5, -14, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
				Color(255,255,255, 200), colOff, Color(255,255,255, 200), Color(255,255,255, 200), colOff, Color(255,255,255, 200), colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsCenter + Vector(7.5, -8.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(25,25,255, 255), colOff, Color(25,25,255, 255), Color(25,25,255, 255), colOff, Color(25,25,255, 255), colOff,
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsCenter + Vector(7.5, -3, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
				Color(255,255,255, 200), colOff, Color(255,255,255, 200), Color(255,255,255, 200), colOff, Color(255,255,255, 200), colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsCenter + Vector(7.5, 3, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(25,25,255, 255), colOff, Color(25,25,255, 255), Color(25,25,255, 255), colOff, Color(25,25,255, 255), colOff,
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsCenter + Vector(7.5, 8.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
				Color(255,255,255, 200), colOff, Color(255,255,255, 200), Color(255,255,255, 200), colOff, Color(255,255,255, 200), colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsCenter + Vector(7.5, 14, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(25,25,255, 255), colOff, Color(25,25,255, 255), Color(25,25,255, 255), colOff, Color(25,25,255, 255), colOff,
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsCenter + Vector(7.5, 19.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
				Color(255,255,255, 200), colOff, Color(255,255,255, 200), Color(255,255,255, 200), colOff, Color(255,255,255, 200), colOff,
			},
			Speed = 0.05
		},

		--
		-- SIDE
		--
		{
			pos = emsCenter + Vector(5, -24, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
				Color(255,255,255, 200), colOff, Color(255,255,255, 200), Color(255,255,255, 200), colOff, Color(255,255,255, 200), colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsCenter + Vector(0, -25, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(25,25,255, 255), colOff, Color(25,25,255, 255), Color(25,25,255, 255), colOff, Color(25,25,255, 255), colOff,
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsCenter + Vector(-5, -24, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
				Color(255,255,255, 200), colOff, Color(255,255,255, 200), Color(255,255,255, 200), colOff, Color(255,255,255, 200), colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsCenter + Vector(5, 24, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(25,25,255, 255), colOff, Color(25,25,255, 255), Color(25,25,255, 255), colOff, Color(25,25,255, 255), colOff,
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsCenter + Vector(0, 25, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
				Color(255,255,255, 200), colOff, Color(255,255,255, 200), Color(255,255,255, 200), colOff, Color(255,255,255, 200), colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsCenter + Vector(-5, 24, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(25,25,255, 255), colOff, Color(25,25,255, 255), Color(25,25,255, 255), colOff, Color(25,25,255, 255), colOff,
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.05
		},

		--
		-- REAR
		--
		{
			pos = emsRearCenter + Vector(0, -21, 0),
			material = 'sprites/light_ignorez',
			size = 220,
			Colors = {
				Color(0,0,255, 20), colOff, Color(0,0,255, 20), Color(0,0,255, 20), colOff, Color(0,0,255, 20), colOff,
				Color(255,255,255, 8), colOff, Color(255,255,255, 8), Color(255,255,255, 8), colOff, Color(255,255,255, 8), colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsRearCenter + Vector(0, 21, 0),
			material = 'sprites/light_ignorez',
			size = 220,
			Colors = {
				Color(0,0,255, 20), colOff, Color(0,0,255, 20), Color(0,0,255, 20), colOff, Color(0,0,255, 20), colOff,
				Color(255,255,255, 8), colOff, Color(255,255,255, 8), Color(255,255,255, 8), colOff, Color(255,255,255, 8), colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsRearCenter + Vector(0, 42, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(25,25,255, 255), colOff, Color(25,25,255, 255), Color(25,25,255, 255), colOff, Color(25,25,255, 255), colOff,
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsRearCenter + Vector(0, 31.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
				Color(255,255,255, 200), colOff, Color(255,255,255, 200), Color(255,255,255, 200), colOff, Color(255,255,255, 200), colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsRearCenter + Vector(0, 21, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(25,25,255, 255), colOff, Color(25,25,255, 255), Color(25,25,255, 255), colOff, Color(25,25,255, 255), colOff,
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsRearCenter + Vector(0, 10.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
				Color(255,255,255, 200), colOff, Color(255,255,255, 200), Color(255,255,255, 200), colOff, Color(255,255,255, 200), colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsRearCenter + Vector(0, 0, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(25,25,255, 255), colOff, Color(25,25,255, 255), Color(25,25,255, 255), colOff, Color(25,25,255, 255), colOff,
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsRearCenter + Vector(0, -10.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
				Color(255,255,255, 200), colOff, Color(255,255,255, 200), Color(255,255,255, 200), colOff, Color(255,255,255, 200), colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsRearCenter + Vector(0, -21, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(25,25,255, 255), colOff, Color(25,25,255, 255), Color(25,25,255, 255), colOff, Color(25,25,255, 255), colOff,
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsRearCenter + Vector(0, -31.5, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
				Color(255,255,255, 200), colOff, Color(255,255,255, 200), Color(255,255,255, 200), colOff, Color(255,255,255, 200), colOff,
			},
			Speed = 0.05
		},
		{
			pos = emsRearCenter + Vector(0, -42, 0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(25,25,255, 255), colOff, Color(25,25,255, 255), Color(25,25,255, 255), colOff, Color(25,25,255, 255), colOff,
				colOff, colOff, colOff, colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.05
		},

		--
		-- HEAD/SIDE LIGHTS
		--
		{
			pos = Vector(115, 15, 12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				Color(25,25,255, 255), colOff, Color(25,25,255, 255), colOff, colOff, colOff, colOff, colOff,
			},
			Speed = 0.07
		},
		{
			pos = Vector(115, -15, 12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 22,
			Colors = {
				colOff, colOff, colOff, colOff, Color(25,25,255, 255), colOff, Color(25,25,255, 255), colOff,
			},
			Speed = 0.07
		},
	},


	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(108.6,43.1,11.6),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(108.6,43.1,4.1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 20,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-163.4,44.4,-11.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(61.1,31,28.1),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(108.6,-43.1,11.6),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(108.6,-43.1,4.1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 20,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-163.4,-44.4,-11.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(61.1,30,28.1),
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
				[5] = '',
				[10] = '',
			},
			Brake = {
				[4] = '',
				[5] = '',
				[10] = 'models/gta4/vehicles/ambulance/ambulance_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/ambulance/ambulance_lights_on',
				[5] = '',
				[10] = '',
			},
			Brake = {
				[4] = 'models/gta4/vehicles/ambulance/ambulance_lights_on',
				[5] = '',
				[10] = 'models/gta4/vehicles/ambulance/ambulance_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/ambulance/ambulance_lights_on',
				[5] = 'models/gta4/vehicles/ambulance/ambulance_lights_on',
				[10] = '',
			},
			Brake = {
				[4] = 'models/gta4/vehicles/ambulance/ambulance_lights_on',
				[5] = 'models/gta4/vehicles/ambulance/ambulance_lights_on',
				[10] = 'models/gta4/vehicles/ambulance/ambulance_lights_on',
			},
		},
		turnsignals = {
			left = {
				[13] = 'models/gta4/vehicles/ambulance/ambulance_lights_on'
			},
			right = {
				[14] = 'models/gta4/vehicles/ambulance/ambulance_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_ambulance', light_table)
