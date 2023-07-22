local V = {
	Name = 'Banshee',
	Model = 'models/octoteam/vehicles/banshee.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Спортивные',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Спортивные',

	Members = {
		Mass = 1500,
		Trunk = { 25 },

		Backfire = true,

		EnginePos = Vector(60,0,0),

		LightsTable = 'gta4_banshee',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,2)..math.random(0,1) )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,88)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,1,87)}
				-- CarCols[3] =  {REN.GTA4ColorTable(1,1,2)}
				-- CarCols[4] =  {REN.GTA4ColorTable(1,1,90)}
				-- CarCols[5] =  {REN.GTA4ColorTable(1,4,8)}
				-- CarCols[6] =  {REN.GTA4ColorTable(12,1,87)}
				-- CarCols[7] =  {REN.GTA4ColorTable(23,23,90)}
				-- CarCols[8] =  {REN.GTA4ColorTable(28,28,89)}
				-- CarCols[9] =  {REN.GTA4ColorTable(31,9,32)}
				-- CarCols[10] = {REN.GTA4ColorTable(35,0,28)}
				-- CarCols[11] = {REN.GTA4ColorTable(39,39,28)}
				-- CarCols[12] = {REN.GTA4ColorTable(46,46,28)}
				-- CarCols[13] = {REN.GTA4ColorTable(49,49,118)}
				-- CarCols[14] = {REN.GTA4ColorTable(52,4,118)}
				-- CarCols[15] = {REN.GTA4ColorTable(53,53,50)}
				-- CarCols[16] = {REN.GTA4ColorTable(62,89,65)}
				-- CarCols[17] = {REN.GTA4ColorTable(66,1,71)}
				-- CarCols[18] = {REN.GTA4ColorTable(89,1,50)}
				-- CarCols[19] = {REN.GTA4ColorTable(36,4,90)}
				-- CarCols[20] = {REN.GTA4ColorTable(77,48,118)}
				-- CarCols[21] = {REN.GTA4ColorTable(16,16,19)}
				-- CarCols[22] = {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[23] = {REN.GTA4ColorTable(15,0,93)}
				-- CarCols[24] = {REN.GTA4ColorTable(128,132,94)}
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

		CustomWheelModel = 'models/octoteam/vehicles/banshee_wheel.mdl',

		CustomWheelPosFL = Vector(55,34,-10),
		CustomWheelPosFR = Vector(55,-34,-10),
		CustomWheelPosRL = Vector(-55,34,-10),
		CustomWheelPosRR = Vector(-55,-34,-10),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 40,

		SeatOffset = Vector(-38,-18,16),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-25,-18,-15),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-35,38,-15.5),
				ang = Angle(-90,-80,0),
			},
			{
				pos = Vector(-35,-38,-15.5),
				ang = Angle(-90,80,0),
			},
		},

		FrontHeight = 4,
		FrontConstant = 38000,
		FrontDamping = 1100,
		FrontRelativeDamping = 1100,

		RearHeight = 4,
		RearConstant = 38000,
		RearDamping = 1100,
		RearRelativeDamping = 1100,

		FastSteeringAngle = 15,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 4,
		CounterSteeringMul = 0.95,

		MaxGrip = 80,
		Efficiency = 1.1,
		GripOffset = -4,
		BrakePower = 40,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 76,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = true,
		Supercharged = true,
		DoNotStall = false,

		FuelFillPos = Vector(-67,35,14),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		PowerBias = 0.8,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/banshee_idle.wav',

		snd_low = 'octoteam/vehicles/banshee_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/banshee_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/banshee_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/banshee_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/banshee_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/banshee_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.45,
		Gears = {-0.12,0,0.12,0.22,0.3,0.45,0.6},

		Dash = { pos = Vector(-8.365, 17.729, 11.988), ang = Angle(-0.0, -90.0, 77.6) },
		Radio = { pos = Vector(-5.885, -1.588, 0.980), ang = Angle(-27.6, 164.0, 0.0) },
		Plates = {
			Front = { pos = Vector(94.657, 0.001, -7.148), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-101.311, -0.000, 4.724), ang = Angle(-7.5, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(-7.062, 0.001, 22.430),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(-2.927, 33.530, 15.114),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(-2.888, -34.756, 15.376),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_banshee', V )

local light_table = {
	L_HeadLampPos = Vector(73,29,7),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(73,-29,7),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-100,23,3.5),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-100,-23,3.5),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(73,29,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(73,-29,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(75,23,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(75,-23,7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(-5,24.5,13),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(73,29,7),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(73,-29,7),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(75,23,7),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(75,-23,7),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(-5,24.5,12),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-100,23,3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-100,-23,3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-100,23,5.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-100,-23,5.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
--[[			{
				pos = Vector(-5,21.5,15),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeLeft = {
			{
				pos = Vector(-100,23,7.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
		Right = {
--[[			{
				pos = Vector(-5,14,15),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		TurnBrakeRight = {
			{
				pos = Vector(-100,-23,7.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 70,
				color = Color(255,0,0,150),
			},
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[4] = '',
				[9] = '',
				[11] = ''
			},
			Brake = {
				[4] = '',
				[9] = 'models/gta4/vehicles/banshee/banshee_lights_on',
				[11] = ''
			},
			Reverse = {
				[4] = '',
				[9] = '',
				[11] = 'models/gta4/vehicles/banshee/banshee_lights_on'
			},
			Brake_Reverse = {
				[4] = '',
				[9] = 'models/gta4/vehicles/banshee/banshee_lights_on',
				[11] = 'models/gta4/vehicles/banshee/banshee_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/banshee/banshee_lights_on',
				[9] = '',
				[11] = ''
			},
			Brake = {
				[4] = 'models/gta4/vehicles/banshee/banshee_lights_on',
				[9] = 'models/gta4/vehicles/banshee/banshee_lights_on',
				[11] = ''
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/banshee/banshee_lights_on',
				[9] = '',
				[11] = 'models/gta4/vehicles/banshee/banshee_lights_on'
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/banshee/banshee_lights_on',
				[9] = 'models/gta4/vehicles/banshee/banshee_lights_on',
				[11] = 'models/gta4/vehicles/banshee/banshee_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/banshee/banshee_lights_on',
				[9] = '',
				[11] = ''
			},
			Brake = {
				[4] = 'models/gta4/vehicles/banshee/banshee_lights_on',
				[9] = 'models/gta4/vehicles/banshee/banshee_lights_on',
				[11] = ''
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/banshee/banshee_lights_on',
				[9] = '',
				[11] = 'models/gta4/vehicles/banshee/banshee_lights_on'
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/banshee/banshee_lights_on',
				[9] = 'models/gta4/vehicles/banshee/banshee_lights_on',
				[11] = 'models/gta4/vehicles/banshee/banshee_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_banshee', light_table)