local V = {
	Name = 'Super Drop Diamond',
	Model = 'models/octoteam/vehicles/superd2.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Особые',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 2000,
		Trunk = { 45 },

		EnginePos = Vector(70,0,10),

		LightsTable = 'gta4_superd2',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(134,136,134)}
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

		CustomWheelModel = 'models/octoteam/vehicles/superd2_wheel.mdl',

		ModelInfo = {
			WheelColor = Color(10,10,10),
		},

		CustomWheelPosFL = Vector(75,33,-7),
		CustomWheelPosFR = Vector(75,-33,-7),
		CustomWheelPosRL = Vector(-75,33,-7),
		CustomWheelPosRR = Vector(-75,-33,-7),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-22,-19,27),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-10,-19,-5),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-43,19,-5),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-43,-19,-5),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-127,22,-7),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-127,-22,-7),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 8.5,
		FrontConstant = 30000,
		FrontDamping = 1100,
		FrontRelativeDamping = 1100,

		RearHeight = 8.5,
		RearConstant = 30000,
		RearDamping = 1100,
		RearRelativeDamping = 1100,

		FastSteeringAngle = 15,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 4.5,

		MaxGrip = 58,
		Efficiency = 0.9,
		GripOffset = 0,
		BrakePower = 35,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 52,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 1.15,

		FuelFillPos = Vector(-98,-38,18),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 70,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/diamond_idle.wav',

		snd_low = 'octoteam/vehicles/diamond_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/diamond_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/diamond_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/diamond_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/diamond_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/admiral_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(14.205, 19.777, 24.012), ang = Angle(-0.0, -90.0, 76.3) },
		Radio = { pos = Vector(27.466, 0.016, 17.587), ang = Angle(-23.0, -180.0, -0.0) },
		Plates = {
			Front = { pos = Vector(106.875, -0.019, -5.275), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-128.161, 0.038, 13.874), ang = Angle(-4.6, -180.0, -0.0) },
		},
		Mirrors = {
			left = {
				pos = Vector(12.522, 40.232, 25.299),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(12.994, -40.403, 25.315),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tbogt_superd2', V )

local light_table = {
	L_HeadLampPos = Vector(102,29.5,12.5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(102,-29.5,12.5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-125,31.5,12.5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-125,-31.5,12.5),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(102,29.5,12.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(102,-29.5,12.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(102,23.5,12.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(102,-23.5,12.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(14,20.5,21.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(102,29.5,12.5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(102,-29.5,12.5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(102,23.5,12.5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(102,-23.5,12.5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(14,18.5,21.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-125,31.5,12.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-125,-31.5,12.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-125.5,26,13),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-125.5,-26,13),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(104,25.5,6.9),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-126,28,9),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(14,22.5,21.5),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(104,-25.5,6.9),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-126,-28,9),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(14,16.5,21.5),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[8] = '',
				[4] = '',
			},
			Brake = {
				[8] = '',
				[4] = 'models/gta4/vehicles/superd/diamond_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/superd/diamond_lights_on',
				[4] = '',
			},
			Brake = {
				[8] = 'models/gta4/vehicles/superd/diamond_lights_on',
				[4] = 'models/gta4/vehicles/superd/diamond_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[8] = 'models/gta4/vehicles/superd/diamond_lights_on',
				[4] = '',
			},
			Brake = {
				[8] = 'models/gta4/vehicles/superd/diamond_lights_on',
				[4] = 'models/gta4/vehicles/superd/diamond_lights_on',
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/superd/diamond_lights_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/superd/diamond_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_superd2', light_table)
