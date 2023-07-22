local V = {
	Name = 'Faction',
	Model = 'models/octoteam/vehicles/faction.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Маслкары',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Маслкары',

	Members = {
		Mass = 1200.0,

		EnginePos = Vector(60,0,10),

		LightsTable = 'gta4_faction',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1)..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,8)}
				-- CarCols[2] =  {REN.GTA4ColorTable(2,0,4)}
				-- CarCols[3] =  {REN.GTA4ColorTable(6,0,4)}
				-- CarCols[4] =  {REN.GTA4ColorTable(8,1,8)}
				-- CarCols[5] =  {REN.GTA4ColorTable(11,1,8)}
				-- CarCols[6] =  {REN.GTA4ColorTable(25,6,8)}
				-- CarCols[7] =  {REN.GTA4ColorTable(42,42,34)}
				-- CarCols[8] =  {REN.GTA4ColorTable(47,47,34)}
				-- CarCols[9] =  {REN.GTA4ColorTable(52,0,52)}
				-- CarCols[10] = {REN.GTA4ColorTable(57,1,57)}
				-- CarCols[11] = {REN.GTA4ColorTable(61,1,61)}
				-- CarCols[12] = {REN.GTA4ColorTable(69,69,63)}
				-- CarCols[13] = {REN.GTA4ColorTable(76,76,63)}
				-- CarCols[14] = {REN.GTA4ColorTable(78,78,65)}
				-- CarCols[15] = {REN.GTA4ColorTable(86,86,68)}
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
			REN.GTA4SimfphysOnTick(ent, 0, 0, 0) --name of car 'ent', Has reversing beep? 0/1, Uses big rig brakes? 0/1 Handbrake type? 0-Standard 1-Sporty 2-Truck
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/faction_wheel.mdl',

		CustomWheelPosFL = Vector(58,32,-7),
		CustomWheelPosFR = Vector(58,-32,-7),
		CustomWheelPosRL = Vector(-60,32,-7),
		CustomWheelPosRR = Vector(-60,-32,-7),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-13,-17,22),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(0,-17,-10),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-95,32,-9),
				ang = Angle(-100,-45,0),
			},
			{
				pos = Vector(-95,-32,-9),
				ang = Angle(-100,45,0),
			},
		},

		FrontHeight = 9,
		FrontConstant = 23000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 8,
		RearConstant = 23000,
		RearDamping = 800,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 550,

		TurnSpeed = 3.5,

		MaxGrip = 35,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 25,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 27,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-81,35,13),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 40,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 0.9,
		snd_idle = 'octoteam/vehicles/faction_idle.wav',
		BrakeSqueal = true,

		snd_low = 'octoteam/vehicles/faction_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/faction_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/faction_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/faction_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/faction_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/faction_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(18.369, 16.982, 16.792), ang = Angle(-0.0, -90.0, 77.1) },
		Radio = { pos = Vector(24.152, -1.018, 12.339), ang = Angle(0.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(103.757, -0.004, -6.021), ang = Angle(1.1, 0.0, -0.0) },
			Back = { pos = Vector(-105.127, 0.002, 9.425), ang = Angle(-11.7, -180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(5.862, -0.003, 30.826),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(16.260, 36.051, 22.960),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(15.697, -35.998, 22.630),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_faction', V )

local light_table = {
	L_HeadLampPos = Vector(96,26.5,6.7),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(96,-26.5,6.7),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-105,25,10),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-105,-25,10),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(96,26.5,6.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(96,-26.5,6.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(96,20.3,6.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,230,100,255),
		},
		{
			pos = Vector(96,-20.3,6.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,230,100,255),
		},

--[[		{
			pos = Vector(18.4,24.6,17),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(96,26.5,6.7),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(96,-26.5,6.7),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(18.2,24.6,16),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-105,25,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-105,-25,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-105,16,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-105,-16,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-110,24.6,1.3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-110,-24.6,1.3),
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
				pos = Vector(100,23,-5.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(80.2,34.5,-2.2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 20,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-104,34,10),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(18.7,24.6,18.5),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(100,-23,-5.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(80.2,-34.5,-2.2),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 20,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-104,-34,10),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(18.7,9.1,18.5),
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
				[11] = '',
				[8] = '',
			},
			Brake = {
				[5] = '',
				[11] = 'models/gta4/vehicles/faction/faction_lights_on',
				[8] = '',
			},
			Reverse = {
				[5] = '',
				[11] = '',
				[8] = 'models/gta4/vehicles/faction/faction_lights_on',
			},
			Brake_Reverse = {
				[5] = '',
				[11] = 'models/gta4/vehicles/faction/faction_lights_on',
				[8] = 'models/gta4/vehicles/faction/faction_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/faction/faction_lights_on',
				[11] = '',
				[8] = '',
			},
			Brake = {
				[5] = 'models/gta4/vehicles/faction/faction_lights_on',
				[11] = 'models/gta4/vehicles/faction/faction_lights_on',
				[8] = '',
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/faction/faction_lights_on',
				[11] = '',
				[8] = 'models/gta4/vehicles/faction/faction_lights_on',
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/faction/faction_lights_on',
				[11] = 'models/gta4/vehicles/faction/faction_lights_on',
				[8] = 'models/gta4/vehicles/faction/faction_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/faction/faction_lights_on',
				[11] = '',
				[8] = '',
			},
			Brake = {
				[5] = 'models/gta4/vehicles/faction/faction_lights_on',
				[11] = 'models/gta4/vehicles/faction/faction_lights_on',
				[8] = '',
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/faction/faction_lights_on',
				[11] = '',
				[8] = 'models/gta4/vehicles/faction/faction_lights_on',
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/faction/faction_lights_on',
				[11] = 'models/gta4/vehicles/faction/faction_lights_on',
				[8] = 'models/gta4/vehicles/faction/faction_lights_on',
			},
		},
		turnsignals = {
			left = {
				[4] = 'models/gta4/vehicles/faction/faction_lights_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/faction/faction_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_faction', light_table)