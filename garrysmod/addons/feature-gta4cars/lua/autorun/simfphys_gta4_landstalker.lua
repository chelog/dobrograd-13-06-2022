local V = {
	Name = 'Landstalker',
	Model = 'models/octoteam/vehicles/landstalker.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 2300.0,

		EnginePos = Vector(70,0,20),

		LightsTable = 'gta4_landstalker',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,2)..math.random(0,1)..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,95)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,0,4)}
				-- CarCols[3] =  {REN.GTA4ColorTable(1,1,9)}
				-- CarCols[4] =  {REN.GTA4ColorTable(6,6,63)}
				-- CarCols[5] =  {REN.GTA4ColorTable(40,40,27)}
				-- CarCols[6] =  {REN.GTA4ColorTable(57,57,51)}
				-- CarCols[7] =  {REN.GTA4ColorTable(64,64,63)}
				-- CarCols[8] =  {REN.GTA4ColorTable(85,85,118)}
				-- CarCols[9] =  {REN.GTA4ColorTable(88,88,87)}
				-- CarCols[10] = {REN.GTA4ColorTable(98,98,91)}
				-- CarCols[11] = {REN.GTA4ColorTable(104,104,103)}
				-- CarCols[12] = {REN.GTA4ColorTable(2,2,63)}
				-- CarCols[13] = {REN.GTA4ColorTable(21,21,72)}
				-- CarCols[14] = {REN.GTA4ColorTable(22,22,72)}
				-- CarCols[15] = {REN.GTA4ColorTable(13,11,91)}
				-- CarCols[16] = {REN.GTA4ColorTable(19,19,93)}
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

		CustomWheelModel = 'models/octoteam/vehicles/landstalker_wheel.mdl',

		CustomWheelPosFL = Vector(69,32,-1),
		CustomWheelPosFR = Vector(69,-32,-1),
		CustomWheelPosRL = Vector(-68,32,-1),
		CustomWheelPosRR = Vector(-68,-32,-1),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,10),

		CustomSteerAngle = 35,

		SeatOffset = Vector(0,-17,37),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(10,-18,5),
				ang = Angle(0,-90,10),
				hasRadio = true,
			},
			{
				pos = Vector(-31,18,5),
				ang = Angle(0,-90,10)
			},
			{
				pos = Vector(-31,-18,5),
				ang = Angle(0,-90,10)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-116,30,-6),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-116,-30,-6),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 12,
		FrontConstant = 32000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 12,
		RearConstant = 32000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3,

		MaxGrip = 80,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 25,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 135.0,
		PowerbandStart = 2000,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-84,38,28),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 100,

		PowerBias = 0,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/perennial_idle.wav',

		snd_low = 'octoteam/vehicles/perennial_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/perennial_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/perennial_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/perennial_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/perennial_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/patriot_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.13,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_landstalker', V )

local light_table = {
	L_HeadLampPos = Vector(93,28,21),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(93,-28,21),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-109,33,25),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-109,-33,25),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(93,28,21),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(93,-28,21),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(37,17.5,28),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(255,57,50,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(96,23,20),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(96,-23,20),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(37,16.5,28),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(255,57,50,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(101,25,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(101,-25,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-109,33,25),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-109,-33,25),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-111,34,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-111,-34,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-110,31,22),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-110,-31,22),
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
				pos = Vector(89,33,22),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-109,35,21.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(37,19,28),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(255,57,50,255),
			},]]
		},
		Right = {
			{
				pos = Vector(89,-33,22),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-109,-35,21.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(37,15,28),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(255,57,50,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[10] = '',
				[11] = '',
				[9] = '',
				[12] = ''
			},
			Brake = {
				[10] = '',
				[11] = '',
				[9] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[12] = ''
			},
			Reverse = {
				[10] = '',
				[11] = '',
				[9] = '',
				[12] = 'models/gta4/vehicles/landstalker/landstalker_lights_on'
			},
			Brake_Reverse = {
				[10] = '',
				[11] = '',
				[9] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[12] = 'models/gta4/vehicles/landstalker/landstalker_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[11] = '',
				[9] = '',
				[12] = ''
			},
			Brake = {
				[10] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[11] = '',
				[9] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[12] = ''
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[11] = '',
				[9] = '',
				[12] = 'models/gta4/vehicles/landstalker/landstalker_lights_on'
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[11] = '',
				[9] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[12] = 'models/gta4/vehicles/landstalker/landstalker_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[11] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[9] = '',
				[12] = ''
			},
			Brake = {
				[10] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[11] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[9] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[12] = ''
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[11] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[9] = '',
				[12] = 'models/gta4/vehicles/landstalker/landstalker_lights_on'
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[11] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[9] = 'models/gta4/vehicles/landstalker/landstalker_lights_on',
				[12] = 'models/gta4/vehicles/landstalker/landstalker_lights_on'
			},
		},
		turnsignals = {
			left = {
				[14] = 'models/gta4/vehicles/landstalker/landstalker_lights_on'
			},
			right = {
				[13] = 'models/gta4/vehicles/landstalker/landstalker_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_landstalker', light_table)