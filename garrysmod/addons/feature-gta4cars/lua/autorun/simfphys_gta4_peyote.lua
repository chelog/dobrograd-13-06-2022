local V = {
	Name = 'Peyote',
	Model = 'models/octoteam/vehicles/peyote.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Маслкары',
	SpawnOffset = Vector(0,0,0),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Маслкары',

	Members = {
		Mass = 1500,
		Trunk = { 35 },

		EnginePos = Vector(70,0,10),

		LightsTable = 'gta4_peyote',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,1)..math.random(0,1)..math.random(0,2) )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,12)}
				-- CarCols[2] =  {REN.GTA4ColorTable(17,17,12)}
				-- CarCols[5] =  {REN.GTA4ColorTable(41,41,35)}
				-- CarCols[4] =  {REN.GTA4ColorTable(46,46,127)}
				-- CarCols[5] =  {REN.GTA4ColorTable(51,51,127)}
				-- CarCols[6] =  {REN.GTA4ColorTable(52,52,59)}
				-- CarCols[7] =  {REN.GTA4ColorTable(55,55,60)}
				-- CarCols[8] =  {REN.GTA4ColorTable(61,61,113)}
				-- CarCols[9] =  {REN.GTA4ColorTable(65,65,80)}
				-- CarCols[10] = {REN.GTA4ColorTable(68,68,12)}
				-- CarCols[11] = {REN.GTA4ColorTable(76,76,126)}
				-- CarCols[12] = {REN.GTA4ColorTable(91,91,89)}
				-- CarCols[13] = {REN.GTA4ColorTable(93,93,91)}
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

		CustomWheelModel = 'models/octoteam/vehicles/peyote_wheel.mdl',

		CustomWheelPosFL = Vector(63,34,-2),
		CustomWheelPosFR = Vector(63,-34,-2),
		CustomWheelPosRL = Vector(-63,34,-2),
		CustomWheelPosRR = Vector(-63,-34,-2),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-33,-17,26),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-22,-17,-6),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-98,32,-8),
				ang = Angle(-110,-25,0),
			},
			{
				pos = Vector(-98,-32,-8),
				ang = Angle(-110,25,0),
			},
		},

		FrontHeight = 8,
		FrontConstant = 27000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 8,
		RearConstant = 27000,
		RearDamping = 800,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3.5,

		MaxGrip = 45,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 25,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 40,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-65,39,19),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 35,

		PowerBias = 1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/patriot_idle.wav',

		snd_low = 'octoteam/vehicles/patriot_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/patriot_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/patriot_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/patriot_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/patriot_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/patriot_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(0.805, -0.036, 23), ang = Angle(0.0, -90.0, 90.0) },
		Radio = { pos = Vector(5.775, 0.019, 16.600), ang = Angle(0.0, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(95.926, 13.785, -3.091), ang = Angle(15.4, 9.7, -0.0) },
			Back = { pos = Vector(-115.504, -29.275, -5.971), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(-1.223, -0.011, 35.403),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(-5.350, 40.093, 26.101),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(-4.864, -40.369, 25.709),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_peyote', V )

local light_table = {
	L_HeadLampPos = Vector(91,34,18),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(91,-34,18),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-113,35,10),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-113,-35,10),
	R_RearLampAng = Angle(25,180,0),

	Headlight_sprites = {
		{
			pos = Vector(91,34,18),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},
		{
			pos = Vector(91,-34,18),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,238,200,150),
		},

--[[		{
			pos = Vector(2,17,24.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(91,34,8),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(91,-34,8),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(2,16,24.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-113,35,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-113,-35,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-113,35,4.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-113,-35,4.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-113,35,10),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-113,-35,10),
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
				pos = Vector(-113,35,4.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(2,18,24.5),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(-113,-35,4.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(2,15,24.5),
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
				[10] = '',
				[11] = '',
			},
			Brake = {
				[5] = '',
				[6] = '',
				[10] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[11] = '',
			},
			Reverse = {
				[5] = '',
				[6] = '',
				[10] = '',
				[11] = 'models/gta4/vehicles/peyote/peyote_lights_on',
			},
			Brake_Reverse = {
				[5] = '',
				[6] = '',
				[10] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[11] = 'models/gta4/vehicles/peyote/peyote_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[6] = '',
				[10] = '',
				[11] = '',
			},
			Brake = {
				[5] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[6] = '',
				[10] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[11] = '',
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[6] = '',
				[10] = '',
				[11] = 'models/gta4/vehicles/peyote/peyote_lights_on',
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[6] = '',
				[10] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[11] = 'models/gta4/vehicles/peyote/peyote_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[6] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[10] = '',
				[11] = '',
			},
			Brake = {
				[5] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[6] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[10] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[11] = '',
			},
			Reverse = {
				[5] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[6] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[10] = '',
				[11] = 'models/gta4/vehicles/peyote/peyote_lights_on',
			},
			Brake_Reverse = {
				[5] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[6] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[10] = 'models/gta4/vehicles/peyote/peyote_lights_on',
				[11] = 'models/gta4/vehicles/peyote/peyote_lights_on',
			},
		},
		turnsignals = {
			left = {
				[12] = 'models/gta4/vehicles/peyote/peyote_lights_on'
			},
			right = {
				[7] = 'models/gta4/vehicles/peyote/peyote_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_peyote', light_table)