local V = {
	Name = 'Biff',
	Model = 'models/octoteam/vehicles/biff.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Индустриальные',
	SpawnOffset = Vector(0,0,40),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Индустриальные',

	Members = {
		Mass = 9000.0,

		EnginePos = Vector(140,0,30),

		LightsTable = 'gta4_biff',

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

			-- REN.GTA4Biff(ent, math.random(0,2))
			REN.GTA4SimfphysInit(ent, 1, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
		end,

		OnTick = function(ent)
			REN.GTA4SimfphysOnTick(ent, 1, 1, 2) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/biff_wheel.mdl',
		CustomWheelModel_R = 'models/octoteam/vehicles/biff_wheel_r.mdl',

		CustomWheelPosFL = Vector(126,45,-27),
		CustomWheelPosFR = Vector(126,-45,-27),
		CustomWheelPosML = Vector(-74,36,-27),
		CustomWheelPosMR = Vector(-74,-36,-27),
		CustomWheelPosRL = Vector(-126,36,-27),
		CustomWheelPosRR = Vector(-126,-36,-27),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,25),

		CustomSteerAngle = 40,

		SeatOffset = Vector(63,-21,57),
		SeatPitch = 10,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(76,-20,14),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(59,59,84),
				ang = Angle(-90,-90,0),
			},
			{
				pos = Vector(59,-59,84),
				ang = Angle(-90,90,0),
			},
		},

		StrengthenedSuspension = true,

		FrontHeight = 22,
		FrontConstant = 50000,
		FrontDamping = 2000,
		FrontRelativeDamping = 350,

		RearHeight = 12,
		RearConstant = 50000,
		RearDamping = 2000,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 700,

		TurnSpeed = 3,

		MaxGrip = 148,
		Efficiency = 0.8,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = false,

		IdleRPM = 700,
		LimitRPM = 4500,
		PeakTorque = 110.0,
		PowerbandStart = 1700,
		PowerbandEnd = 4000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(71.3,44,-9.3),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 160,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1.05,
		snd_idle = 'octoteam/vehicles/firetruk_idle.wav',

		snd_low = 'octoteam/vehicles/firetruk_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/firetruk_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/firetruk_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/firetruk_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/firetruk_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'TRUCK_HORN',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/DUMP_VALVE.wav',

		DifferentialGear = 0.11,
		Gears = {-0.6,0,0.2,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_biff', V )

local light_table = {
	L_HeadLampPos = Vector(161,32,-3),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(161,-32,-3),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-160,42,1),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-160,-42,1),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(161,32,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(161,-32,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(159,42,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(159,-42,-3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(104,17,39),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(161,32,-3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(161,-32,-3),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(104,16,39),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-160,42,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-160,-42,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-160,36.5,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-160,-36.5,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-160,42,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-160,-42,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-160,36.5,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-160,-36.5,1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-160,31.9,0.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-160,-31.9,0.2),
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
				pos = Vector(117,46,16),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-160,48,1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(104,24,39),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(117,-46,16),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-160,-48,1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,35,0,150),
			},

--[[			{
				pos = Vector(104,23,39),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[3] = '',
				[11] = ''
			},
			Reverse = {
				[3] = '',
				[11] = 'models/gta4/vehicles/biff/detail2_on'
			},
		},
		on_lowbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/biff/detail2_on',
				[11] = ''
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/biff/detail2_on',
				[11] = 'models/gta4/vehicles/biff/detail2_on'
			},
		},
		on_highbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/biff/detail2_on',
				[11] = ''
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/biff/detail2_on',
				[11] = 'models/gta4/vehicles/biff/detail2_on'
			},
		},
		turnsignals = {
			left = {
				[9] = 'models/gta4/vehicles/biff/detail2_on'
			},
			right = {
				[6] = 'models/gta4/vehicles/biff/detail2_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_biff', light_table)