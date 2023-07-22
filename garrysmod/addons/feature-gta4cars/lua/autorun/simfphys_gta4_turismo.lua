local V = {
	Name = 'Turismo',
	Model = 'models/octoteam/vehicles/turismo.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Спортивные',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Спортивные',

	Members = {
		Mass = 1500.0,

		EnginePos = Vector(-40,0,0),

		LightsTable = 'gta4_turismo',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,1)}
				-- CarCols[2] =  {REN.GTA4ColorTable(35,35,127)}
				-- CarCols[3] =  {REN.GTA4ColorTable(1,1,3)}
				-- CarCols[4] =  {REN.GTA4ColorTable(17,17,34)}
				-- CarCols[5] =  {REN.GTA4ColorTable(21,21,21)}
				-- CarCols[6] =  {REN.GTA4ColorTable(31,31,33)}
				-- CarCols[7] =  {REN.GTA4ColorTable(38,38,30)}
				-- CarCols[8] =  {REN.GTA4ColorTable(52,52,50)}
				-- CarCols[9] =  {REN.GTA4ColorTable(69,69,63)}
				-- CarCols[10] = {REN.GTA4ColorTable(72,72,63)}
				-- CarCols[11] = {REN.GTA4ColorTable(81,81,63)}
				-- CarCols[12] = {REN.GTA4ColorTable(89,89,89)}
				-- CarCols[13] = {REN.GTA4ColorTable(95,95,90)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 0, 0, 1) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/turismo_wheel.mdl',

		CustomWheelPosFL = Vector(54,33,-9),
		CustomWheelPosFR = Vector(54,-33,-9),
		CustomWheelPosRL = Vector(-54,33,-9),
		CustomWheelPosRR = Vector(-54,-33,-9),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-7,-18,13),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(5,-18,-18),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-87,1.5,-8.5),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-87,-1.5,-8.5),
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

		MaxGrip = 102,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 34,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 160.0,
		PowerbandStart = 1500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = true,
		DoNotStall = false,

		FuelFillPos = Vector(-66,-36,15),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 70,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/turismo_idle.wav',

		snd_low = 'octoteam/vehicles/turismo_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/turismo_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/turismo_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/turismo_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/turismo_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/infernus_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.23,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_turismo', V )

local light_table = {
	L_HeadLampPos = Vector(78,32,5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(78,-32,5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-80,29,10),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-80,-29,10),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(78,32,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,100),
		},
		{
			pos = Vector(78,-32,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,100),
		},

--[[		{
			pos = Vector(28.7,17.9,9.9),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(79,25,4),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(79,-25,4),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(28.7,18.9,9.9),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-80,29,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-80,-29,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-82,19,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-82,-19,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-83,15,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-83,-15,7),
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
				pos = Vector(-81,25,7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(29.25,20.6,11.5),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(-81,-25,7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(29.25,16,11.5),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[5] = '',
				[6] = '',
				[11] = '',
				[10] = ''
			},
			Brake = {
				[5] = '',
				[6] = '',
				[11] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[10] = ''
			},
			Reverse = {
				[5] = '',
				[6] = '',
				[11] = '',
				[10] = 'models/gta4/vehicles/turismo/turismo_lights_on'
			},
			Brake_Reverse = {
				[5] = '',
				[6] = '',
				[11] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[10] = 'models/gta4/vehicles/turismo/turismo_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[6] = '',
				[11] = '',
				[10] = ''
			},
			Brake = {
				[5] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[6] = '',
				[11] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[10] = ''
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[6] = '',
				[11] = '',
				[10] = 'models/gta4/vehicles/turismo/turismo_lights_on'
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[6] = '',
				[11] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[10] = 'models/gta4/vehicles/turismo/turismo_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[6] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[11] = '',
				[10] = ''
			},
			Brake = {
				[5] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[6] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[11] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[10] = ''
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[6] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[11] = '',
				[10] = 'models/gta4/vehicles/turismo/turismo_lights_on'
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[6] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[11] = 'models/gta4/vehicles/turismo/turismo_lights_on',
				[10] = 'models/gta4/vehicles/turismo/turismo_lights_on'
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/turismo/turismo_lights_on'
			},
			right = {
				[13] = 'models/gta4/vehicles/turismo/turismo_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_turismo', light_table)