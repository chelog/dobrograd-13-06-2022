local V = {
	Name = 'Stretch E',
	Model = 'models/octoteam/vehicles/limo2.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 2500.0,

		EnginePos = Vector(70,0,0),

		LightsTable = 'gta4_limo2',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1) )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,8)}
				-- CarCols[2] =  {REN.GTA4ColorTable(1,1,12)}
				-- CarCols[3] =  {REN.GTA4ColorTable(113,113,113)}
				-- CarCols[4] =  {REN.GTA4ColorTable(16,16,76)}
				-- CarCols[5] =  {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[6] =  {REN.GTA4ColorTable(15,15,93)}
				-- CarCols[7] =  {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[8] =  {REN.GTA4ColorTable(13,13,80)}
				-- CarCols[9] =  {REN.GTA4ColorTable(0,0,1)}
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

		CustomWheelModel = 'models/octoteam/vehicles/limo2_wheel.mdl',

		CustomWheelPosFL = Vector(85,33,-10),
		CustomWheelPosFR = Vector(85,-33,-10),
		CustomWheelPosRL = Vector(-85,33,-10),
		CustomWheelPosRR = Vector(-85,-33,-10),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 35,

		SeatOffset = Vector(10,-19,25),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(20,-19,-8),
				ang = Angle(0,-90,15),
				hasRadio = true
			},
			{
				pos = Vector(-62,19,-8),
				ang = Angle(0,-90,15)
			},
			{
				pos = Vector(-62,-19,-8),
				ang = Angle(0,-90,15)
			},
			{
				pos = Vector(-22,19,-8),
				ang = Angle(0,90,15)
			},
			{
				pos = Vector(-22,-19,-8),
				ang = Angle(0,90,15)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-132,19,-9.5),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-133,14,-9.5),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-132,-19,-9.5),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-133,-14,-9.5),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 12,
		FrontConstant = 25000,
		FrontDamping = 1000,
		FrontRelativeDamping = 350,

		RearHeight = 12,
		RearConstant = 25000,
		RearDamping = 1000,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3,

		MaxGrip = 83,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 22,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 140.0,
		PowerbandStart = 2500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-100,-33.5,17),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 90,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/limo2_idle.wav',

		snd_low = 'octoteam/vehicles/limo2_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/limo2_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/limo2_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/limo2_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/limo2_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/admiral_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.14,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tbogt_limo2', V )

local light_table = {
	L_HeadLampPos = Vector(107,31,8.5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(107,-31,8.5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-126,30,14.5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-126,-30,14.5),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(107,31,8.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(107,-31,8.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(45,19.5,21),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(111,26,7.2),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(111,-26,7.2),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(45,18,21),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(115,27,-7.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(115,-27,-7.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-126,30,14.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-126,-30,14.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-129,22,13.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-129,-22,13.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-130,18,13),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-130,-18,13),
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
				pos = Vector(104,34,9.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-125,31,11),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(45,21.5,23),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(104,-34,9.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-125,-31,11),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(45,16,23),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[6] = '',
				[10] = '',
				[8] = '',
				[12] = '',
			},
			Brake = {
				[6] = '',
				[10] = '',
				[8] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[12] = '',
			},
			Reverse = {
				[6] = '',
				[10] = '',
				[8] = '',
				[12] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
			},
			Brake_Reverse = {
				[6] = '',
				[10] = '',
				[8] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[12] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[6] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[10] = '',
				[8] = '',
				[12] = '',
			},
			Brake = {
				[6] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[10] = '',
				[8] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[12] = '',
			},
			Reverse = {
				[6] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[10] = '',
				[8] = '',
				[12] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
			},
			Brake_Reverse = {
				[6] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[10] = '',
				[8] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[12] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[6] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[10] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[8] = '',
				[12] = '',
			},
			Brake = {
				[6] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[10] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[8] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[12] = '',
			},
			Reverse = {
				[6] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[10] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[8] = '',
				[12] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
			},
			Brake_Reverse = {
				[6] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[10] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[8] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
				[12] = 'models/gta4/vehicles/schafter2/limo2_lights_on',
			},
		},
		turnsignals = {
			left = {
				[7] = 'models/gta4/vehicles/schafter2/limo2_lights_on'
			},
			right = {
				[11] = 'models/gta4/vehicles/schafter2/limo2_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_limo2', light_table)