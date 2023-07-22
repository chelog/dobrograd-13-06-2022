local V = {
	Name = 'Speedo',
	Model = 'models/octoteam/vehicles/speedo.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 2500.0,

		EnginePos = Vector(80,0,10),

		LightsTable = 'gta4_speedo',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,11))
			-- ent:SetBodyGroups('0'..math.random(0,4)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =   {REN.GTA4ColorTable(9,9,9)}
				-- CarCols[2] =   {REN.GTA4ColorTable(11,11,11)}
				-- CarCols[3] =   {REN.GTA4ColorTable(1,1,2)}
				-- CarCols[4] =   {REN.GTA4ColorTable(13,13,13)}
				-- CarCols[5] =   {REN.GTA4ColorTable(23,23,3)}
				-- CarCols[6] =   {REN.GTA4ColorTable(68,68,68)}
				-- CarCols[7] =   {REN.GTA4ColorTable(31,31,31)}
				-- CarCols[8] =   {REN.GTA4ColorTable(36,36,36)}
				-- CarCols[9] =   {REN.GTA4ColorTable(41,41,41)}
				-- CarCols[10] =  {REN.GTA4ColorTable(48,48,48)}
				-- CarCols[11] =  {REN.GTA4ColorTable(55,55,55)}
				-- CarCols[12] =  {REN.GTA4ColorTable(57,57,57)}
				-- CarCols[13] =  {REN.GTA4ColorTable(64,64,64)}
				-- CarCols[14] =  {REN.GTA4ColorTable(71,71,71)}
				-- CarCols[15] =  {REN.GTA4ColorTable(77,77,77)}
				-- CarCols[16] =  {REN.GTA4ColorTable(90,90,90)}
				-- CarCols[17] =  {REN.GTA4ColorTable(104,104,104)}
				-- CarCols[18] =  {REN.GTA4ColorTable(106,106,104)}
				-- CarCols[19] =  {REN.GTA4ColorTable(0,0,1)}
				-- CarCols[20] =  {REN.GTA4ColorTable(4,4,4)}
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

		CustomWheelModel = 'models/octoteam/vehicles/speedo_wheel.mdl',

		CustomWheelPosFL = Vector(70,36,-19),
		CustomWheelPosFR = Vector(70,-36,-19),
		CustomWheelPosRL = Vector(-69,36,-19),
		CustomWheelPosRR = Vector(-69,-36,-19),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,10),

		CustomSteerAngle = 35,

		SeatOffset = Vector(18,-21,30),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(23,-20,-3),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-102.9,36.8,-18.4),
				ang = Angle(-100,-50,0),
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

		MaxGrip = 85,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 20,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 125.0,
		PowerbandStart = 2200,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-40,41,-10),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 90,

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

		snd_horn = 'octoteam/vehicles/horns/speedo_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.13,
		Gears = {-0.3,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_speedo', V )

local light_table = {
	L_HeadLampPos = Vector(97,29,5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(97,-29,5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-109,36,19),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-109,-36,19),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(97,29,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(97,-29,5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(51,24,21),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(97,29,5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(97,-29,5),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(51,25,21),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-109,36,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-109,-36,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-109,36,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-109,-36,19),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-110,36,13.6),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-110,-36,13.6),
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
				pos = Vector(97,36,-0.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-108,35,25),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 20,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(52,22,22),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(97,-36,-0.4),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-108,-35,25),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 20,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(52,18,22),
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
				[3] = '',
				[11] = '',
			},
			Brake = {
				[10] = '',
				[3] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[11] = '',
			},
			Reverse = {
				[10] = '',
				[3] = '',
				[11] = 'models/gta4/vehicles/speedo/speedo_lights_on'
			},
			Brake_Reverse = {
				[10] = '',
				[3] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[11] = 'models/gta4/vehicles/speedo/speedo_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[3] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[11] = '',
			},
			Brake = {
				[10] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[3] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[11] = '',
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[3] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[11] = 'models/gta4/vehicles/speedo/speedo_lights_on'
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[3] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[11] = 'models/gta4/vehicles/speedo/speedo_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[3] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[11] = '',
			},
			Brake = {
				[10] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[3] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[11] = '',
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[3] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[11] = 'models/gta4/vehicles/speedo/speedo_lights_on'
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[3] = 'models/gta4/vehicles/speedo/speedo_lights_on',
				[11] = 'models/gta4/vehicles/speedo/speedo_lights_on'
			},
		},
		turnsignals = {
			left = {
				[8] = 'models/gta4/vehicles/speedo/speedo_lights_on'
			},
			right = {
				[5] = 'models/gta4/vehicles/speedo/speedo_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_speedo', light_table)