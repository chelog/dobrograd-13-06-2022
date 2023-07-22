local V = {
	Name = 'Feltzer',
	Model = 'models/octoteam/vehicles/feltzer.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Спортивные',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Спортивные',

	Members = {
		Mass = 1550,
		Trunk = { 30 },

		EnginePos = Vector(60,0,0),

		LightsTable = 'gta4_feltzer',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,2)..'1' )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(13,13,65)}
				-- CarCols[2] =  {REN.GTA4ColorTable(62,62,63)}
				-- CarCols[3] =  {REN.GTA4ColorTable(0,0,63)}
				-- CarCols[4] =  {REN.GTA4ColorTable(1,1,64)}
				-- CarCols[5] =  {REN.GTA4ColorTable(3,3,12)}
				-- CarCols[6] =  {REN.GTA4ColorTable(6,6,16)}
				-- CarCols[7] =  {REN.GTA4ColorTable(7,7,15)}
				-- CarCols[8] =  {REN.GTA4ColorTable(15,15,17)}
				-- CarCols[9] =  {REN.GTA4ColorTable(28,28,28)}
				-- CarCols[10] = {REN.GTA4ColorTable(40,40,28)}
				-- CarCols[11] = {REN.GTA4ColorTable(49,49,50)}
				-- CarCols[12] = {REN.GTA4ColorTable(50,50,51)}
				-- CarCols[13] = {REN.GTA4ColorTable(57,57,55)}
				-- CarCols[14] = {REN.GTA4ColorTable(65,65,55)}
				-- CarCols[15] = {REN.GTA4ColorTable(74,74,63)}
				-- CarCols[16] = {REN.GTA4ColorTable(16,16,76)}
				-- CarCols[17] = {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[18] = {REN.GTA4ColorTable(15,15,93)}
				-- CarCols[19] = {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[20] = {REN.GTA4ColorTable(13,13,80)}
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

		CustomWheelModel = 'models/octoteam/vehicles/feltzer_wheel.mdl',

		CustomWheelPosFL = Vector(54,31,-10),
		CustomWheelPosFR = Vector(54,-31,-10),
		CustomWheelPosRL = Vector(-54,33,-10),
		CustomWheelPosRR = Vector(-54,-33,-10),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,-5),

		CustomSteerAngle = 38,

		SeatOffset = Vector(-25,-17,15),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-10,-17,-15),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-95,20,-11),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-95,-20,-11),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 7,
		FrontConstant = 38000,
		FrontDamping = 1100,
		FrontRelativeDamping = 1100,

		RearHeight = 8,
		RearConstant = 38000,
		RearDamping = 1100,
		RearRelativeDamping = 1100,

		FastSteeringAngle = 15,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 4,
		CounterSteeringMul = 0.83,

		MaxGrip = 70,
		Efficiency = 1,
		GripOffset = -2,
		BrakePower = 35,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 60,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-67,34,13),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 40,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/feltzer_idle.wav',

		snd_low = 'octoteam/vehicles/feltzer_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/feltzer_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/feltzer_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/feltzer_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/feltzer_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/cavalcade_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.35,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(8.230, 17.082, 10.5), ang = Angle(-0.0, -90.0, 71.1) },
		Radio = { pos = Vector(14.965, 0.000, 5.526), ang = Angle(-10.0, -180.0, -0.0) },
		Plates = {
			Front = { pos = Vector(93.877, -0.008, -10.839), ang = Angle(9.8, 0.0, 0.0) },
			Back = { pos = Vector(-90.890, 0.004, 8.821), ang = Angle(-4.6, 180.0, -0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(-2.283, 0.249, 22.410),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(11.902, 35.314, 15.312),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(11.768, -35.243, 14.669),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_feltzer', V )

local light_table = {
	L_HeadLampPos = Vector(75,29,2),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(75,-29,2),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-89,27,7),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-89,-27,7),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(75,29,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(75,-29,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(10,18.7,9.3),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(82,22,1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(82,-22,1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(10,18,9.3),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-89,27,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-89,-27,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-89,27,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-89,-27,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-90,27,4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-90,-27,4),
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
				pos = Vector(82,25.4,-0.1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-88,27,11),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(10.25,21,10),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(82,-25.4,-0.1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-88,-27,11),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(10.25,14.8,10),
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
				[11] = '',
				[5] = '',
				[12] = ''
			},
			Brake = {
				[10] = '',
				[11] = '',
				[5] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[12] = ''
			},
			Reverse = {
				[10] = '',
				[11] = '',
				[5] = '',
				[12] = 'models/gta4/vehicles/feltzer/feltzer_lights_on'
			},
			Brake_Reverse = {
				[10] = '',
				[11] = '',
				[5] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[12] = 'models/gta4/vehicles/feltzer/feltzer_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[11] = '',
				[5] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[12] = ''
			},
			Brake = {
				[10] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[11] = '',
				[5] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[12] = ''
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[11] = '',
				[5] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[12] = 'models/gta4/vehicles/feltzer/feltzer_lights_on'
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[11] = '',
				[5] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[12] = 'models/gta4/vehicles/feltzer/feltzer_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[11] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[5] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[12] = ''
			},
			Brake = {
				[10] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[11] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[5] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[12] = ''
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[11] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[5] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[12] = 'models/gta4/vehicles/feltzer/feltzer_lights_on'
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[11] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[5] = 'models/gta4/vehicles/feltzer/feltzer_lights_on',
				[12] = 'models/gta4/vehicles/feltzer/feltzer_lights_on'
			},
		},
		turnsignals = {
			left = {
				[9] = 'models/gta4/vehicles/feltzer/feltzer_lights_on'
			},
			right = {
				[6] = 'models/gta4/vehicles/feltzer/feltzer_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_feltzer', light_table)