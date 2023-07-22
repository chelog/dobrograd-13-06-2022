local V = {
	Name = 'Gang Burrito',
	Model = 'models/octoteam/vehicles/gburrito.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Особые',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 2500.0,

		EnginePos = Vector(90,0,10),

		LightsTable = 'gta4_gburrito',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =   {REN.GTA4ColorTable(1,2,0)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 2) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/gburrito_wheel.mdl',

		CustomWheelPosFL = Vector(80,40,-25),
		CustomWheelPosFR = Vector(80,-40,-25),
		CustomWheelPosRL = Vector(-80,40,-25),
		CustomWheelPosRR = Vector(-80,-40,-25),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,10),

		CustomSteerAngle = 30,

		SeatOffset = Vector(30,-27,27),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(32,-25,-5),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-48,48,-26),
				ang = Angle(-90,-70,0),
			},
			{
				pos = Vector(-53,48,-26),
				ang = Angle(-90,-70,0),
			},
			{
				pos = Vector(-48,-48,-26),
				ang = Angle(-90,70,0),
			},
			{
				pos = Vector(-53,-48,-26),
				ang = Angle(-90,70,0),
			},
		},

		FrontHeight = 10,
		FrontConstant = 25000,
		FrontDamping = 500,
		FrontRelativeDamping = 350,

		RearHeight = 10,
		RearConstant = 25000,
		RearDamping = 500,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 95,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 20,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 130.0,
		PowerbandStart = 2200,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-50,48,-10),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 80,

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
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.16,
		Gears = {-0.3,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tlad_gburrito', V )

local light_table = {
	L_HeadLampPos = Vector(104,36,7),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(104,-36,7),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-113,36,19),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-113,-36,19),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(104,36,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(104,-36,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(57,20,23),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(105,27,7),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(105,-27,7),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(57,21,23),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-113,36,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-113,-36,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-113,36.3,15.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-113,-36.3,15.5),
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
				pos = Vector(102,43,7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(102,43,-0.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 20,
				color = Color(255,135,0,150),
			},
--[[			{
				pos = Vector(57,31,23),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeLeft = {
			{
				pos = Vector(-113,36,19),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 60,
				color = Color(255,0,0,150),
			},
		},
		Right = {
			{
				pos = Vector(102,-43,7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(102,-43,-0.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 20,
				color = Color(255,135,0,150),
			},
--[[			{
				pos = Vector(57,30,23),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeRight = {
			{
				pos = Vector(-113,-36,19),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 60,
				color = Color(255,0,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[3] = '',
				[12] = '',
				[10] = '',
			},
			Reverse = {
				[3] = '',
				[12] = '',
				[10] = 'models/gta4/vehicles/burrito/burrito_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/burrito/burrito_lights_on',
				[12] = '',
				[10] = '',
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/burrito/burrito_lights_on',
				[12] = '',
				[10] = 'models/gta4/vehicles/burrito/burrito_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/burrito/burrito_lights_on',
				[12] = 'models/gta4/vehicles/burrito/burrito_lights_on',
				[10] = '',
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/burrito/burrito_lights_on',
				[12] = 'models/gta4/vehicles/burrito/burrito_lights_on',
				[10] = 'models/gta4/vehicles/burrito/burrito_lights_on'
			},
		},
		turnsignals = {
			left = {
				[11] = 'models/gta4/vehicles/burrito/burrito_lights_on'
			},
			right = {
				[8] = 'models/gta4/vehicles/burrito/burrito_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_gburrito', light_table)