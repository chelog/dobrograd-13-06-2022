local V = {
	Name = 'Tampa',
	Model = 'models/octoteam/vehicles/tampa.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Маслкары',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Маслкары',

	Members = {
		Mass = 1700.0,

		EnginePos = Vector(60,0,0),

		LightsTable = 'gta4_tampa',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,49)}
				-- CarCols[2] =  {REN.GTA4ColorTable(38,38,85)}
				-- CarCols[3] =  {REN.GTA4ColorTable(0,97,102)}
				-- CarCols[4] =  {REN.GTA4ColorTable(3,0,12)}
				-- CarCols[5] =  {REN.GTA4ColorTable(6,6,4)}
				-- CarCols[6] =  {REN.GTA4ColorTable(11,4,12)}
				-- CarCols[7] =  {REN.GTA4ColorTable(13,13,12)}
				-- CarCols[8] =  {REN.GTA4ColorTable(16,95,90)}
				-- CarCols[9] =  {REN.GTA4ColorTable(24,1,12)}
				-- CarCols[10] = {REN.GTA4ColorTable(21,21,12)}
				-- CarCols[11] = {REN.GTA4ColorTable(23,23,2)}
				-- CarCols[12] = {REN.GTA4ColorTable(31,31,27)}
				-- CarCols[13] = {REN.GTA4ColorTable(32,113,34)}
				-- CarCols[14] = {REN.GTA4ColorTable(34,12,34)}
				-- CarCols[15] = {REN.GTA4ColorTable(49,13,41)}
				-- CarCols[16] = {REN.GTA4ColorTable(52,0,59)}
				-- CarCols[17] = {REN.GTA4ColorTable(62,13,69)}
				-- CarCols[18] = {REN.GTA4ColorTable(76,4,76)}
				-- CarCols[19] = {REN.GTA4ColorTable(82,85,76)}
				-- CarCols[20] = {REN.GTA4ColorTable(87,8,76)}
				-- CarCols[21] = {REN.GTA4ColorTable(89,0,4)}
				-- CarCols[22] = {REN.GTA4ColorTable(92,95,90)}
				-- CarCols[23] = {REN.GTA4ColorTable(95,95,2)}
				-- CarCols[24] = {REN.GTA4ColorTable(106,103,2)}
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

		CustomWheelModel = 'models/octoteam/vehicles/tampa_wheel.mdl',

		CustomWheelPosFL = Vector(60,33,-8),
		CustomWheelPosFR = Vector(60,-33,-8),
		CustomWheelPosRL = Vector(-59,33,-8),
		CustomWheelPosRR = Vector(-59,-33,-8),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-17,-18,18),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-4,-18,-13),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-107,20.5,-3.5),
				ang = Angle(-90,-5,0),
			},
			{
				pos = Vector(-107,-20.5,-3.5),
				ang = Angle(-90,5,0),
			},
		},

		FrontHeight = 13,
		FrontConstant = 18000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 13,
		RearConstant = 18000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 87,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 23,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 145.0,
		PowerbandStart = 1500,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-58,-38,15),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 70,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/dukes_idle.wav',

		snd_low = 'octoteam/vehicles/vigero_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/vigero_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/vigero_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/vigero_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/vigero_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/sabre_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.22,
		Gears = {-0.3,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tbogt_tampa', V )

local light_table = {
	L_HeadLampPos = Vector(84,30,5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(84,-30,5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-105.5,27,11),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-105.5,-27,11),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(84,30,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(84,-30,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(14,12,14),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(88,21.5,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(88,-21.5,5),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(13,12,13),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-105.5,27,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-105.5,-27,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-105.5,21,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-105.5,-21,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-105.5,21,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-105.5,-21,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(89,27,-6.7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 60,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-105.5,27,11),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 60,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(14,19,14),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(89,-27,-6.7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 60,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-105.5,-27,11),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 60,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(14,16,14),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[14] = '',
				[15] = '',
				[13] = '',
				[12] = ''
			},
			Brake = {
				[14] = '',
				[15] = '',
				[13] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[12] = ''
			},
			Reverse = {
				[14] = '',
				[15] = '',
				[13] = '',
				[12] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on'
			},
			Brake_Reverse = {
				[14] = '',
				[15] = '',
				[13] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[12] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[14] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[15] = '',
				[13] = '',
				[12] = ''
			},
			Brake = {
				[14] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[15] = '',
				[13] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[12] = ''
			},
			Reverse = {
				[14] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[15] = '',
				[13] = '',
				[12] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on'
			},
			Brake_Reverse = {
				[14] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[15] = '',
				[13] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[12] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[14] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[15] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[13] = '',
				[12] = ''
			},
			Brake = {
				[14] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[15] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[13] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[12] = ''
			},
			Reverse = {
				[14] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[15] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[13] = '',
				[12] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on'
			},
			Brake_Reverse = {
				[14] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[15] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[13] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on',
				[12] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on'
			},
		},
		turnsignals = {
			left = {
				[10] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on'
			},
			right = {
				[6] = 'models/gta4/vehicles/tampa/sabreturbo_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_tampa', light_table)