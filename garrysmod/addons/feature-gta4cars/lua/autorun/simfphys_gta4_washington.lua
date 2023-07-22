local V = {
	Name = 'Washington',
	Model = 'models/octoteam/vehicles/washington.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1750.0,

		EnginePos = Vector(70,0,5),

		LightsTable = 'gta4_washington',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,12)}
				-- CarCols[2] =  {REN.GTA4ColorTable(4,4,12)}
				-- CarCols[3] =  {REN.GTA4ColorTable(6,6,12)}
				-- CarCols[4] =  {REN.GTA4ColorTable(10,10,12)}
				-- CarCols[5] =  {REN.GTA4ColorTable(21,21,12)}
				-- CarCols[6] =  {REN.GTA4ColorTable(23,23,12)}
				-- CarCols[7] =  {REN.GTA4ColorTable(25,25,12)}
				-- CarCols[8] =  {REN.GTA4ColorTable(33,33,35)}
				-- CarCols[9] =  {REN.GTA4ColorTable(37,37,32)}
				-- CarCols[10] = {REN.GTA4ColorTable(49,49,63)}
				-- CarCols[11] = {REN.GTA4ColorTable(52,52,56)}
				-- CarCols[12] = {REN.GTA4ColorTable(54,54,55)}
				-- CarCols[13] = {REN.GTA4ColorTable(65,65,63)}
				-- CarCols[14] = {REN.GTA4ColorTable(67,67,118)}
				-- CarCols[15] = {REN.GTA4ColorTable(70,70,65)}
				-- CarCols[16] = {REN.GTA4ColorTable(98,98,90)}
				-- CarCols[17] = {REN.GTA4ColorTable(16,16,76)}
				-- CarCols[18] = {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[19] = {REN.GTA4ColorTable(15,15,93)}
				-- CarCols[20] = {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[21] = {REN.GTA4ColorTable(13,13,80)}
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

		CustomWheelModel = 'models/octoteam/vehicles/washington_wheel.mdl',

		CustomWheelPosFL = Vector(68,33,-11),
		CustomWheelPosFR = Vector(68,-33,-11),
		CustomWheelPosRL = Vector(-68,33,-11),
		CustomWheelPosRR = Vector(-68,-33,-11),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 33,

		SeatOffset = Vector(-14,-19.5,22),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(0,-20,-10),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-50,20,-10),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-50,-20,-10),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-118,25,-11),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-118,21.5,-11),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-118,-21.5,-11),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-118,-25,-11),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 12,
		FrontConstant = 20000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 12,
		RearConstant = 20000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3,

		MaxGrip = 73,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 22,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 135.0,
		PowerbandStart = 2500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-81,39,15),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 90,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/admiral_idle.wav',

		snd_low = 'octoteam/vehicles/admiral_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/admiral_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/admiral_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/admiral_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/admiral_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/admiral_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.13,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_washington', V )

local light_table = {
	L_HeadLampPos = Vector(100,26,7),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(100,-26,7),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-113,34,5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-113,-34,5),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(100,26,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(100,-26,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(23,25,18),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(100,26,7),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(100,-26,7),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(23,16,18),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-113,34,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-113,-34,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-111,34,12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-111,-34,12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-114,29,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-114,-29,5),
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
				pos = Vector(100,28,4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-112,30,10),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,24,18),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(100,-28,4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-112,-30,10),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,17,18),
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
				[4] = '',
				[12] = ''
			},
			Brake = {
				[10] = '',
				[4] = 'models/gta4/vehicles/washington/washington_lights_on',
				[12] = ''
			},
			Reverse = {
				[10] = '',
				[4] = '',
				[12] = 'models/gta4/vehicles/washington/washington_lights_on'
			},
			Brake_Reverse = {
				[10] = '',
				[4] = 'models/gta4/vehicles/washington/washington_lights_on',
				[12] = 'models/gta4/vehicles/washington/washington_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/washington/washington_lights_on',
				[4] = '',
				[12] = ''
			},
			Brake = {
				[10] = 'models/gta4/vehicles/washington/washington_lights_on',
				[4] = 'models/gta4/vehicles/washington/washington_lights_on',
				[12] = ''
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/washington/washington_lights_on',
				[4] = '',
				[12] = 'models/gta4/vehicles/washington/washington_lights_on'
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/washington/washington_lights_on',
				[4] = 'models/gta4/vehicles/washington/washington_lights_on',
				[12] = 'models/gta4/vehicles/washington/washington_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/washington/washington_lights_on',
				[4] = '',
				[12] = ''
			},
			Brake = {
				[10] = 'models/gta4/vehicles/washington/washington_lights_on',
				[4] = 'models/gta4/vehicles/washington/washington_lights_on',
				[12] = ''
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/washington/washington_lights_on',
				[4] = '',
				[12] = 'models/gta4/vehicles/washington/washington_lights_on'
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/washington/washington_lights_on',
				[4] = 'models/gta4/vehicles/washington/washington_lights_on',
				[12] = 'models/gta4/vehicles/washington/washington_lights_on'
			},
		},
		turnsignals = {
			left = {
				[11] = 'models/gta4/vehicles/washington/washington_lights_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/washington/washington_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_washington', light_table)