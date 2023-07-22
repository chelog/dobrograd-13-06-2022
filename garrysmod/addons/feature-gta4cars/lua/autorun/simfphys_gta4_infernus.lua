local V = {
	Name = 'Infernus',
	Model = 'models/octoteam/vehicles/infernus.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Спортивные',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Спортивные',

	Members = {
		Mass = 1700.0,

		Backfire = true,

		EnginePos = Vector(-50,0,10),

		LightsTable = 'gta4_infernus',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1) )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,63)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,0,59)}
				-- CarCols[3] =  {REN.GTA4ColorTable(33,33,27)}
				-- CarCols[4] =  {REN.GTA4ColorTable(46,46,127)}
				-- CarCols[5] =  {REN.GTA4ColorTable(6,6,8)}
				-- CarCols[6] =  {REN.GTA4ColorTable(49,49,59)}
				-- CarCols[7] =  {REN.GTA4ColorTable(59,59,127)}
				-- CarCols[8] =  {REN.GTA4ColorTable(88,88,124)}
				-- CarCols[9] =  {REN.GTA4ColorTable(62,62,63)}
				-- CarCols[10] = {REN.GTA4ColorTable(22,22,64)}
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

		CustomWheelModel = 'models/octoteam/vehicles/infernus_wheel.mdl',

		CustomWheelPosFL = Vector(56,32,-9),
		CustomWheelPosFR = Vector(56,-32,-9),
		CustomWheelPosRL = Vector(-56,35,-9),
		CustomWheelPosRR = Vector(-56,-35,-9),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 30,

		SeatOffset = Vector(-6,-17,15),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(8,-17,-15),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-84,0,8.7),
				ang = Angle(-70,0,0),
			},
			{
				pos = Vector(-84,3,8.7),
				ang = Angle(-70,0,0),
			},
			{
				pos = Vector(-84,-3,8.7),
				ang = Angle(-70,0,0),
			},
			{
				pos = Vector(-85,0,5.8),
				ang = Angle(-70,0,0),
			},
			{
				pos = Vector(-83,0,11.6),
				ang = Angle(-70,0,0),
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

		MaxGrip = 93,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 160.0,
		PowerbandStart = 1500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = true,
		DoNotStall = false,

		FuelFillPos = Vector(-18,29,19),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 70,

		PowerBias = 0.65,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/infernus_idle.wav',

		snd_low = 'octoteam/vehicles/infernus_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/infernus_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/infernus_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/infernus_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/infernus_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/infernus_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.25,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_infernus', V )

local light_table = {
	L_HeadLampPos = Vector(73.5,31.7,5.6),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(73.5,-31.7,5.6),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-83.8,28,10.7),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-83.8,-28,10.7),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(73.5,31.7,5.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(73.5,-31.7,5.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(28.6,17.8,10.6),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(75.5,25.7,4.3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(75.5,-25.7,4.3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(28.6,17.2,10.6),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-83.8,28,10.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-83.8,-28,10.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-83.8,28,10.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-83.8,-28,10.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-85.4,33.3,5.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-85.4,-33.3,5.7),
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
				pos = Vector(-85.4,33.3,5.7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(28.6,18,12.2),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(-85.4,-33.3,5.7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(28.6,16.9,12.2),
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
				[14] = '',
				[11] = '',
				[15] = ''
			},
			Brake = {
				[6] = '',
				[14] = '',
				[11] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[15] = ''
			},
			Reverse = {
				[6] = '',
				[14] = '',
				[11] = '',
				[15] = 'models/gta4/vehicles/infernus/infernus_lights_on'
			},
			Brake_Reverse = {
				[6] = '',
				[14] = '',
				[11] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[15] = 'models/gta4/vehicles/infernus/infernus_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[6] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[14] = '',
				[11] = '',
				[15] = ''
			},
			Brake = {
				[6] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[14] = '',
				[11] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[15] = ''
			},
			Reverse = {
				[6] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[14] = '',
				[11] = '',
				[15] = 'models/gta4/vehicles/infernus/infernus_lights_on'
			},
			Brake_Reverse = {
				[6] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[14] = '',
				[11] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[15] = 'models/gta4/vehicles/infernus/infernus_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[6] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[14] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[11] = '',
				[15] = ''
			},
			Brake = {
				[6] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[14] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[11] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[15] = ''
			},
			Reverse = {
				[6] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[14] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[11] = '',
				[15] = 'models/gta4/vehicles/infernus/infernus_lights_on'
			},
			Brake_Reverse = {
				[6] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[14] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[11] = 'models/gta4/vehicles/infernus/infernus_lights_on',
				[15] = 'models/gta4/vehicles/infernus/infernus_lights_on'
			},
		},
		turnsignals = {
			left = {
				[7] = 'models/gta4/vehicles/infernus/infernus_lights_on'
			},
			right = {
				[10] = 'models/gta4/vehicles/infernus/infernus_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_infernus', light_table)