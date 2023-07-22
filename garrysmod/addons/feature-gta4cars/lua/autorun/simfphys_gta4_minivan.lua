local V = {
	Name = 'Minivan',
	Model = 'models/octoteam/vehicles/minivan.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 2300.0,

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_minivan',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1)..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,2)}
				-- CarCols[2] =  {REN.GTA4ColorTable(1,1,2)}
				-- CarCols[3] =  {REN.GTA4ColorTable(3,3,2)}
				-- CarCols[4] =  {REN.GTA4ColorTable(6,6,8)}
				-- CarCols[5] =  {REN.GTA4ColorTable(7,7,8)}
				-- CarCols[6] =  {REN.GTA4ColorTable(10,10,12)}
				-- CarCols[7] =  {REN.GTA4ColorTable(26,26,12)}
				-- CarCols[8] =  {REN.GTA4ColorTable(45,45,32)}
				-- CarCols[9] =  {REN.GTA4ColorTable(62,62,53)}
				-- CarCols[10] = {REN.GTA4ColorTable(71,71,71)}
				-- CarCols[11] = {REN.GTA4ColorTable(77,77,76)}
				-- CarCols[12] = {REN.GTA4ColorTable(87,87,86)}
				-- CarCols[13] = {REN.GTA4ColorTable(16,16,76)}
				-- CarCols[14] = {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[15] = {REN.GTA4ColorTable(15,15,93)}
				-- CarCols[16] = {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[17] = {REN.GTA4ColorTable(13,13,80)}
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

		CustomWheelModel = 'models/octoteam/vehicles/minivan_wheel.mdl',

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

		FrontHeight = 10,
		FrontConstant = 35000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 10,
		RearConstant = 35000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 80,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 20,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 130.0,
		PowerbandStart = 2500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-80,39,10),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 80,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/minivan_idle.wav',

		snd_low = 'octoteam/vehicles/minivan_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/minivan_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/minivan_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/minivan_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/minivan_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/minivan_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.13,
		Gears = {-0.25,0,0.15,0.35,0.5,0.75}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_minivan', V )

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
				[9] = ''
			},
			Brake = {
				[7] = '',
				[12] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[9] = ''
			},
			Reverse = {
				[7] = '',
				[12] = '',
				[9] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
			Brake_Reverse = {
				[7] = '',
				[12] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[9] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = '',
				[9] = ''
			},
			Brake = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[9] = ''
			},
			Reverse = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = '',
				[9] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
			Brake_Reverse = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[9] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = '',
				[9] = ''
			},
			Brake = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[9] = ''
			},
			Reverse = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = '',
				[9] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
			Brake_Reverse = {
				[7] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[12] = 'models/gta4/vehicles/minivan/taxivan_lights_on',
				[9] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
		},
		turnsignals = {
			left = {
				[8] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
			right = {
				[3] = 'models/gta4/vehicles/minivan/taxivan_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_minivan', light_table)