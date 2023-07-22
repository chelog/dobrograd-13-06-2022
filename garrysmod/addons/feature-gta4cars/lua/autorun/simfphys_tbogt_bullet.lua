local V = {
	Name = 'Bullet GT',
	Model = 'models/octoteam/vehicles/bullet.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Спортивные',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Спортивные',

	Members = {
		Mass = 1500.0,

		Backfire = true,

		EnginePos = Vector(-46,0,10),

		LightsTable = 'gta4_bullet',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1) )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(34,1,28)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,0,2)}
				-- CarCols[3] =  {REN.GTA4ColorTable(76,0,75)}
				-- CarCols[4] =  {REN.GTA4ColorTable(132,0,133)}
				-- CarCols[5] =  {REN.GTA4ColorTable(120,120,133)}
				-- CarCols[6] =  {REN.GTA4ColorTable(20,20,4)}
				-- CarCols[7] =  {REN.GTA4ColorTable(0,0,84)}
				-- CarCols[8] =  {REN.GTA4ColorTable(74,74,128)}
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

		CustomWheelModel = 'models/octoteam/vehicles/bullet_wheel.mdl',

		CustomWheelPosFL = Vector(52,34,-4),
		CustomWheelPosFR = Vector(52,-34,-4),
		CustomWheelPosRL = Vector(-62,34,-4),
		CustomWheelPosRR = Vector(-62,-34,-4),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 30,

		SeatOffset = Vector(-16,-20,17),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-5,-20,-15),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-92,15,4.5),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-92,11.6,4.5),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-92,-15,4.5),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-92,-11.6,4.5),
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

		MaxGrip = 106,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 34,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 163.0,
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
		snd_idle = 'octoteam/vehicles/bullet_idle.wav',

		snd_low = 'octoteam/vehicles/bullet_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/bullet_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/bullet_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/bullet_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/bullet_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/infernus_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.235,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tbogt_bullet', V )

local light_table = {
	L_HeadLampPos = Vector(78,25.5,9.3),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(78,-25.5,9.3),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-95,26.5,14),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-95,-26.5,14),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(78,25.5,9.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(78,-25.5,9.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(78,21.5,9.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(78,-21.5,9.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(18,20.7,15),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(78,25.5,9.3),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(78,-25.5,9.3),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(78,21.5,9.3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(78,-21.5,9.3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(18.3,20,15.7),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-95,26.5,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-95,-26.5,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-95,19.3,13.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-95,-19.3,13.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-95,19.3,13.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-95,-19.3,13.5),
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
				pos = Vector(78,28.5,10.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-95,26.5,14),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(18.5,22.15,17.1),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(78,-28.5,10.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-95,-26.5,14),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(18.5,17.5,17),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[11] = '',
				[8] = '',
				[12] = ''
			},
			Brake = {
				[11] = '',
				[8] = 'models/gta4/vehicles/bullet/bullet_lights_on',
				[12] = ''
			},
			Reverse = {
				[11] = '',
				[8] = '',
				[12] = 'models/gta4/vehicles/bullet/bullet_lights_on'
			},
			Brake_Reverse = {
				[11] = '',
				[8] = 'models/gta4/vehicles/bullet/bullet_lights_on',
				[12] = 'models/gta4/vehicles/bullet/bullet_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[11] = 'models/gta4/vehicles/bullet/bullet_lights_on',
				[8] = '',
				[12] = ''
			},
			Brake = {
				[11] = 'models/gta4/vehicles/bullet/bullet_lights_on',
				[8] = 'models/gta4/vehicles/bullet/bullet_lights_on',
				[12] = ''
			},
			Reverse = {
				[11] = 'models/gta4/vehicles/bullet/bullet_lights_on',
				[8] = '',
				[12] = 'models/gta4/vehicles/bullet/bullet_lights_on'
			},
			Brake_Reverse = {
				[11] = 'models/gta4/vehicles/bullet/bullet_lights_on',
				[8] = 'models/gta4/vehicles/bullet/bullet_lights_on',
				[12] = 'models/gta4/vehicles/bullet/bullet_lights_on'
			},
		},
		turnsignals = {
			left = {
				[13] = 'models/gta4/vehicles/bullet/bullet_lights_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/bullet/bullet_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_bullet', light_table)