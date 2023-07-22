local V = {
	Name = 'Cabby',
	Model = 'models/octoteam/vehicles/cabby.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Сервис',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Сервис',

	Members = {
		Mass = 1550,
		Trunk = { 45 },

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_cabby',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1)..math.random(0,1)..math.random(0,1)..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(89,89,1)}
				-- CarCols[2] =  {REN.GTA4ColorTable(89,1,1)}
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

		CustomWheelModel = 'models/octoteam/vehicles/cabby_wheel.mdl',

		CustomWheelPosFL = Vector(63,33,-19),
		CustomWheelPosFR = Vector(63,-33,-19),
		CustomWheelPosRL = Vector(-63,33,-19),
		CustomWheelPosRR = Vector(-63,-33,-19),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,10),

		CustomSteerAngle = 34,

		SeatOffset = Vector(6,-19.5,20),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(15,-18,-13),
				ang = Angle(0,-90,15),
				hasRadio = true
			},
			{
				pos = Vector(-27,20,-13),
				ang = Angle(0,-90,15)
			},
			{
				pos = Vector(-27,-20,-13),
				ang = Angle(0,-90,15)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-104,27,-20),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 8,
		FrontConstant = 30000,
		FrontDamping = 900,
		FrontRelativeDamping = 900,

		RearHeight = 8,
		RearConstant = 30000,
		RearDamping = 900,
		RearRelativeDamping = 900,

		FastSteeringAngle = 15,
		SteeringFadeFastSpeed = 550,

		TurnSpeed = 4,

		MaxGrip = 46,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 32,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 38,
		PowerbandStart = 1200,
		PowerbandEnd = 5800,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-80,39,10),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 65,

		AirFriction = -40,
		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1.05,
		snd_idle = 'octoteam/vehicles/minivan_idle.wav',

		snd_low = 'octoteam/vehicles/minivan_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/minivan_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/minivan_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/minivan_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/minivan_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/taxi_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(37.423, 18.793, 12.673), ang = Angle(-0.0, -90.0, 73.2) },
		Radio = { pos = Vector(41.925, 0.023, 15.373), ang = Angle(-13.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(106.977, -0.005, -15.061), ang = Angle(1.9, 0.0, 0.0) },
			Back = { pos = Vector(-102.730, -0.001, 3.212), ang = Angle(1.9, 180.0, -0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(22.466, 0.000, 31.690),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(40.628, 43.190, 16.104),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(40.656, -43.068, 16.149),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_cabby', V )

local light_table = {
	L_HeadLampPos = Vector(95,29,-2.6),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(95,-29,-2.6),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-101,36,3),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-101,-36,3),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(95,29,-2.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(95,-29,-2.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(39,18.5,11),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(95,29,-2.6),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(95,-29,-2.6),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(39,19,11),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-101,36,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-101,-36,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-101,36,-2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-101,-36,-2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-101,36,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-101,-36,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	ems_sounds = {'octoteam/vehicles/police/siren1.wav','octoteam/vehicles/police/siren2.wav','octoteam/vehicles/police/siren3.wav'},
	ems_sprites = {
		{
			pos = Vector(98.0, -14.9, -0.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.035
		},
		{
			pos = Vector(98.0, 14.9, -0.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.034
		},
		{
			pos = Vector(98.0, -11.0, -0.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.033
		},
		{
			pos = Vector(98.0, 11.0, -0.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.032
		},
		{
			pos = Vector(-104.2, -8.8, 3.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.035
		},
		{
			pos = Vector(-104.2, 8.8, 3.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.034
		},
		{
			pos = Vector(-84.3, -34.9, 19.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.034
		},
		{
			pos = Vector(-84.3, 34.9, 19.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.032
		},
		{
			pos = Vector(40.8, -40.7, 13.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.035
		},
		{
			pos = Vector(40.8, 40.7, 13.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.034
		},
		{
			pos = Vector(0.1, -11.5, 43.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 45,
			Colors = {
				Color(255, 145, 0),
				Color(255, 145, 0),
				Color(0,0,0,0),
				--
				Color(255, 145, 0),
				Color(255, 145, 0),
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
				Color(255, 145, 0),
				Color(255, 145, 0),
				Color(0,0,0,0),
			},
			Speed = 0.035
		},
		{
			pos = Vector(0.1, 11.5, 43.8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 45,
			Colors = {
				Color(0,0,0,0),
				Color(0,0,0,0),
				Color(0,0,0,0),
				--
				Color(0,0,0,0),
				Color(0,0,0,0),
				Color(0,0,0,0),
				--
				Color(255, 145, 0),
				Color(255, 145, 0),
				Color(0,0,0,0),
				--
				Color(255, 145, 0),
				Color(255, 145, 0),
				Color(0,0,0,0),
				--
				Color(255, 145, 0),
				Color(255, 145, 0),
				Color(0,0,0,0),
				--
				Color(0,0,0,0),
				Color(0,0,0,0),
				Color(0,0,0,0),
			},
			Speed = 0.035
		},
		{
			pos = Vector(21.2, -22, 33.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.035
		},
		{
			pos = Vector(21.2, -18, 33.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.034
		},
		{
			pos = Vector(21.2, -14, 33.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.033
		},
		{
			pos = Vector(21.2, -10, 33.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.032
		},
		{
			pos = Vector(21.2, 22, 33.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.035
		},
		{
			pos = Vector(21.2, 18, 33.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.034
		},
		{
			pos = Vector(21.2, 14, 33.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.033
		},
		{
			pos = Vector(21.2, 10, 33.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.032
		},
		{
			pos = Vector(-75.5, -22, 36.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.035
		},
		{
			pos = Vector(-75.5, -18, 36.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.034
		},
		{
			pos = Vector(-75.5, -14, 36.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.033
		},
		{
			pos = Vector(-75.5, -10, 36.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.032
		},
		{
			pos = Vector(-75.5, 22, 36.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.035
		},
		{
			pos = Vector(-75.5, 18, 36.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.034
		},
		{
			pos = Vector(-75.5, 14, 36.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.033
		},
		{
			pos = Vector(-75.5, 10, 36.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 35,
			Colors = {
				Color(0,0,255,150),
				Color(0,0,0,0),
				Color(0,0,255,150),
				--
				Color(0,0,255,255),
				Color(0,0,255,50),
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
				Color(0,0,255,50),
				Color(0,0,255,255),
			},
			Speed = 0.032
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(86,36,-1.6),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-101,36,9.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(39,19.5,11),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(86,-36,-1.6),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-101,-36,9.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(39,18,11),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[7] = '',
				[12] = '',
				[8] = ''
			},
			Brake = {
				[7] = '',
				[12] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[8] = ''
			},
			Reverse = {
				[7] = '',
				[12] = '',
				[8] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
			Brake_Reverse = {
				[7] = '',
				[12] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[8] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = '',
				[8] = ''
			},
			Brake = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[8] = ''
			},
			Reverse = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = '',
				[8] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
			Brake_Reverse = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[8] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = '',
				[8] = ''
			},
			Brake = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[8] = ''
			},
			Reverse = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = '',
				[8] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
			Brake_Reverse = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[8] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
		},
		turnsignals = {
			left = {
				[8] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
			right = {
				[6] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_cabby', light_table)