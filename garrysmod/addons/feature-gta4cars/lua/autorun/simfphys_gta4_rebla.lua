local V = {
	Name = 'Rebla',
	Model = 'models/octoteam/vehicles/rebla.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 1550,
		Trunk = { 45 },

		EnginePos = Vector(60,0,10),

		LightsTable = 'gta4_rebla',

		OnSpawn = function(ent)
			ent.Tuned = math.random(0,1)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..ent.Tuned..ent.Tuned..ent.Tuned..math.random(0,1)..ent.Tuned	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,3)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,0,0)}
				-- CarCols[3] =  {REN.GTA4ColorTable(0,0,103)}
				-- CarCols[4] =  {REN.GTA4ColorTable(3,3,103)}
				-- CarCols[5] =  {REN.GTA4ColorTable(1,1,79)}
				-- CarCols[6] =  {REN.GTA4ColorTable(3,3,73)}
				-- CarCols[7] =  {REN.GTA4ColorTable(4,4,82)}
				-- CarCols[8] =  {REN.GTA4ColorTable(6,6,84)}
				-- CarCols[9] =  {REN.GTA4ColorTable(11,11,86)}
				-- CarCols[10] = {REN.GTA4ColorTable(16,16,92)}
				-- CarCols[11] = {REN.GTA4ColorTable(23,23,25)}
				-- CarCols[12] = {REN.GTA4ColorTable(34,34,28)}
				-- CarCols[13] = {REN.GTA4ColorTable(36,36,27)}
				-- CarCols[14] = {REN.GTA4ColorTable(47,47,91)}
				-- CarCols[15] = {REN.GTA4ColorTable(52,52,53)}
				-- CarCols[16] = {REN.GTA4ColorTable(53,53,51)}
				-- CarCols[17] = {REN.GTA4ColorTable(64,64,65)}
				-- CarCols[18] = {REN.GTA4ColorTable(69,69,63)}
				-- CarCols[19] = {REN.GTA4ColorTable(70,70,64)}
				-- CarCols[20] = {REN.GTA4ColorTable(73,73,58)}
				-- CarCols[21] = {REN.GTA4ColorTable(76,76,58)}
				-- CarCols[22] = {REN.GTA4ColorTable(2,2,63)}
				-- CarCols[23] = {REN.GTA4ColorTable(21,21,72)}
				-- CarCols[24] = {REN.GTA4ColorTable(22,22,72)}
				-- CarCols[25] = {REN.GTA4ColorTable(13,11,91)}
				-- CarCols[26] = {REN.GTA4ColorTable(19,19,93)}
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

		CustomWheelModel = 'models/octoteam/vehicles/rebla_wheel.mdl',

		CustomWheelPosFL = Vector(56,29,-10),
		CustomWheelPosFR = Vector(56,-29,-10),
		CustomWheelPosRL = Vector(-57,29,-10),
		CustomWheelPosRR = Vector(-57,-29,-10),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-8,-16,25),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(2,-17,-7),
				ang = Angle(0,-90,10),
				hasRadio = true
			},
			{
				pos = Vector(-33,17,-7),
				ang = Angle(0,-90,10)
			},
			{
				pos = Vector(-33,-17,-7),
				ang = Angle(0,-90,10)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-88,18.5,-15),
				ang = Angle(-120,0,0),
				OnBodyGroups = {
					[5] = {0},
				}
			},
			{
				pos = Vector(-88,-18.5,-15),
				ang = Angle(-120,0,0),
				OnBodyGroups = {
					[5] = {0},
				}
			},
			{
				pos = Vector(-96,17.5,-16),
				ang = Angle(-110,0,0),
				OnBodyGroups = {
					[5] = {1},
				}
			},
			{
				pos = Vector(-96,-17.5,-16),
				ang = Angle(-110,0,0),
				OnBodyGroups = {
					[5] = {1},
				}
			},
		},

		FrontHeight = 8,
		FrontConstant = 30000,
		FrontDamping = 900,
		FrontRelativeDamping = 900,

		RearHeight = 8,
		RearConstant = 30000,
		RearDamping = 900,
		RearRelativeDamping = 900,

		FastSteeringAngle = 15,
		SteeringFadeFastSpeed = 550,

		TurnSpeed = 4,

		MaxGrip = 46,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 32,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 38,
		PowerbandStart = 1200,
		PowerbandEnd = 5800,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-68,34,19),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		AirFriction = -40,
		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/perennial_idle.wav',

		snd_low = 'octoteam/vehicles/perennial_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/perennial_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/perennial_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/perennial_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/perennial_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/rebla_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(27.0, 16.158, 18.0), ang = Angle(-0.0, -90.0, 71.1) },
		Radio = { pos = Vector(28.647, 0.000, 16.742), ang = Angle(-21.1, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(90.657, 0.001, -11.279), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-90.493, -0.001, 9.418), ang = Angle(-16.8, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(9.069, -0.001, 35.410),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(20.691, 36.915, 24.521),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(20.427, -36.883, 24.539),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_rebla', V )

local light_table = {
	L_HeadLampPos = Vector(78,25.5,8.5),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(78,-25.5,8.5),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-89,25,14),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-89,-25,14),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(78,25.5,8.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(78,-25.5,8.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(82,20,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 20,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(82,-20,8),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 20,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(28,15.5,18.5),
			material = 'gta4/dash_lowbeam',
			size = 1,
			color = Color(255,57,50,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(82,20,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(82,-20,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(28,17,18.5),
			material = 'gta4/dash_highbeam',
			size = 1,
			color = Color(255,57,50,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-89,25,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-89,-25,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-87,30,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-87,-30,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-90,24,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-90,-24,9),
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
				pos = Vector(88,20,-2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-88,29,9),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(28,18,18.5),
				material = 'gta4/dash_left',
				size = 1,
				color = Color(255,57,50,255),
			},]]
		},
		Right = {
			{
				pos = Vector(88,-20,-2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-88,-29,9),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(28,14.5,18.5),
				material = 'gta4/dash_right',
				size = 1,
				color = Color(255,57,50,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[4] = '',
				[10] = '',
				[11] = ''
			},
			Brake = {
				[4] = '',
				[10] = 'models/gta4/vehicles/rebla/rebla_lights_on',
				[11] = ''
			},
			Reverse = {
				[4] = '',
				[10] = '',
				[11] = 'models/gta4/vehicles/rebla/rebla_lights_on'
			},
			Brake_Reverse = {
				[4] = '',
				[10] = 'models/gta4/vehicles/rebla/rebla_lights_on',
				[11] = 'models/gta4/vehicles/rebla/rebla_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/rebla/rebla_lights_on',
				[10] = '',
				[11] = ''
			},
			Brake = {
				[4] = 'models/gta4/vehicles/rebla/rebla_lights_on',
				[10] = 'models/gta4/vehicles/rebla/rebla_lights_on',
				[11] = ''
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/rebla/rebla_lights_on',
				[10] = '',
				[11] = 'models/gta4/vehicles/rebla/rebla_lights_on'
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/rebla/rebla_lights_on',
				[10] = 'models/gta4/vehicles/rebla/rebla_lights_on',
				[11] = 'models/gta4/vehicles/rebla/rebla_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/rebla/rebla_lights_on',
				[10] = '',
				[11] = ''
			},
			Brake = {
				[4] = 'models/gta4/vehicles/rebla/rebla_lights_on',
				[10] = 'models/gta4/vehicles/rebla/rebla_lights_on',
				[11] = ''
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/rebla/rebla_lights_on',
				[10] = '',
				[11] = 'models/gta4/vehicles/rebla/rebla_lights_on'
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/rebla/rebla_lights_on',
				[10] = 'models/gta4/vehicles/rebla/rebla_lights_on',
				[11] = 'models/gta4/vehicles/rebla/rebla_lights_on'
			},
		},
		turnsignals = {
			left = {
				[6] = 'models/gta4/vehicles/rebla/rebla_lights_on'
			},
			right = {
				[7] = 'models/gta4/vehicles/rebla/rebla_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_rebla', light_table)