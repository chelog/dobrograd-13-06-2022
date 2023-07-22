local V = {
	Name = 'Tow Truck',
	Model = 'models/octoteam/vehicles/towtruck.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 2500.0,

		EnginePos = Vector(70,0,10),

		BackFire = true,

		LightsTable = 'gta4_towtruck',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(40,40,39)}
				-- CarCols[2] =  {REN.GTA4ColorTable(52,52,53)}
				-- CarCols[3] =  {REN.GTA4ColorTable(97,97,97)}
				-- CarCols[4] =  {REN.GTA4ColorTable(90,90,90)}
				-- CarCols[5] =  {REN.GTA4ColorTable(52,52,52)}
				-- CarCols[6] =  {REN.GTA4ColorTable(41,41,41)}
				-- CarCols[7] =  {REN.GTA4ColorTable(36,36,36)}
				-- CarCols[8] =  {REN.GTA4ColorTable(41,41,41)}
				-- CarCols[9] =  {REN.GTA4ColorTable(48,48,48)}
				-- CarCols[10] = {REN.GTA4ColorTable(55,55,55)}
				-- CarCols[11] = {REN.GTA4ColorTable(57,57,57)}
				-- CarCols[12] = {REN.GTA4ColorTable(64,64,64)}
				-- CarCols[13] = {REN.GTA4ColorTable(71,71,71)}
				-- CarCols[14] = {REN.GTA4ColorTable(77,77,77)}
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

		CustomWheelModel = 'models/octoteam/vehicles/slamvan_wheel.mdl',

		CustomWheelPosFL = Vector(60,37,-15),
		CustomWheelPosFR = Vector(60,-37,-15),
		CustomWheelPosRL = Vector(-60,37,-15),
		CustomWheelPosRR = Vector(-60,-37,-15),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,10),

		CustomSteerAngle = 35,

		SeatOffset = Vector(3,-17,29),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(7,-17,-3),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-35,36,-19),
				ang = Angle(-90,-80,0),
			},
			{
				pos = Vector(-31.5,36,-19),
				ang = Angle(-90,-80,0),
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

		MaxGrip = 90,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 19,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 125.0,
		PowerbandStart = 2200,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-24,-31,-6),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 70,

		PowerBias = 1,

		EngineSoundPreset = 0,

		Sound_Idle = 'octoteam/vehicles/towtruck_idle.wav',
		Sound_IdlePitch = 0.85,

		Sound_Mid = 'octoteam/vehicles/towtruck_low.wav',
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 60,
		Sound_MidFadeOutRate = 0.3,

		Sound_High = 'octoteam/vehicles/towtruck_high.wav',
		Sound_HighPitch = 1.3,
		Sound_HighVolume = 2,
		Sound_HighFadeInRPMpercent = 60,
		Sound_HighFadeInRate = 0.3,

		Sound_Throttle = 'octoteam/vehicles/towtruck_throttle.wav',
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 5,

		snd_horn = 'octoteam/vehicles/horns/vigero2_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.14,
		Gears = {-0.3,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tlad_towtruck', V )

local light_table = {
	L_HeadLampPos = Vector(92,33,0),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(92,-33,0),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-107,35.5,-3.5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-107,-35.5,-3.5),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(92,33,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(92,-33,0),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
	},

	Headlamp_sprites = {
		{pos = Vector(92,33,0),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(92,-33,0),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
	},

	Rearlight_sprites = {
		{
			pos = Vector(-107,35.5,-3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-107,-35.5,-3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-107,35.5,-3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-107,-35.5,-3.5),
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
				pos = Vector(-107,30.5,-3.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 20,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(33.5,20.4,21.3),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(255,0,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(-107,30.5,-3.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 20,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(33.5,14.8,21.3),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(255,0,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[9] = '',
			},
			Brake = {
				[9] = '',
			},
		},
		on_lowbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/slamvan/slamvan_lights_on',
			},
			Brake = {
				[9] = 'models/gta4/vehicles/slamvan/slamvan_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/slamvan/slamvan_lights_on',
			},
			Brake = {
				[9] = 'models/gta4/vehicles/slamvan/slamvan_lights_on',
			},
		},
		turnsignals = {
			left = {
				[5] = 'models/gta4/vehicles/slamvan/slamvan_lights_on'
			},
			right = {
				[10] = 'models/gta4/vehicles/slamvan/slamvan_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_towtruck', light_table)