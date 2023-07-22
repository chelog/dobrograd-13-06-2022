local V = {
	Name = 'Huntley Sport',
	Model = 'models/octoteam/vehicles/huntley.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 2300,
		Trunk = { 50 },

		EnginePos = Vector(60,0,10),

		LightsTable = 'gta4_huntley',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('00'	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable2(76,76,58,76)}
				-- CarCols[2] =  {REN.GTA4ColorTable2(0,0,103,0)}
				-- CarCols[3] =  {REN.GTA4ColorTable2(1,1,79,1)}
				-- CarCols[4] =  {REN.GTA4ColorTable2(3,3,103,3)}
				-- CarCols[5] =  {REN.GTA4ColorTable2(4,4,82,4)}
				-- CarCols[6] =  {REN.GTA4ColorTable2(6,6,84,6)}
				-- CarCols[7] =  {REN.GTA4ColorTable2(11,11,86,11)}
				-- CarCols[8] =  {REN.GTA4ColorTable2(16,16,92,16)}
				-- CarCols[9] =  {REN.GTA4ColorTable2(23,23,25,23)}
				-- CarCols[10] = {REN.GTA4ColorTable2(34,34,28,34)}
				-- CarCols[11] = {REN.GTA4ColorTable2(36,36,27,36)}
				-- CarCols[12] = {REN.GTA4ColorTable2(47,47,91,47)}
				-- CarCols[13] = {REN.GTA4ColorTable2(52,52,53,52)}
				-- CarCols[14] = {REN.GTA4ColorTable2(53,53,51,53)}
				-- CarCols[15] = {REN.GTA4ColorTable2(64,64,65,64)}
				-- CarCols[16] = {REN.GTA4ColorTable2(69,69,63,69)}
				-- CarCols[17] = {REN.GTA4ColorTable2(70,70,64,70)}
				-- CarCols[18] = {REN.GTA4ColorTable2(0,0,12,32)}
				-- CarCols[19] = {REN.GTA4ColorTable2(73,73,58,73)}
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

		CustomWheelModel = 'models/octoteam/vehicles/huntley_wheel.mdl',

		CustomWheelPosFL = Vector(60,33,-12),
		CustomWheelPosFR = Vector(60,-33,-12),
		CustomWheelPosRL = Vector(-60,33,-12),
		CustomWheelPosRR = Vector(-60,-33,-12),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-10,-18,25),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-5,-20,-7),
				ang = Angle(0,-90,10),
				hasRadio = true,
			},
			{
				pos = Vector(-37,20,-6),
				ang = Angle(0,-90,10)
			},
			{
				pos = Vector(-37,-20,-6),
				ang = Angle(0,-90,10)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-100,18,-9),
				ang = Angle(-90,0,0),
				OnBodyGroups = {
					[1] = {0},
				}
			},
			{
				pos = Vector(-100,-18,-9),
				ang = Angle(-90,0,0),
				OnBodyGroups = {
					[1] = {0},
				}
			},
			{
				pos = Vector(-38.5,41.5,-17.1),
				ang = Angle(-80,-70,0),
				OnBodyGroups = {
					[1] = {1},
				}
			},
			{
				pos = Vector(-38.5,-41.5,-17.1),
				ang = Angle(-80,70,0),
				OnBodyGroups = {
					[1] = {1},
				}
			},
		},

		FrontHeight = 8,
		FrontConstant = 40000,
		FrontDamping = 1200,
		FrontRelativeDamping = 1200,

		RearHeight = 8,
		RearConstant = 40000,
		RearDamping = 1200,
		RearRelativeDamping = 1200,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3.5,

		MaxGrip = 60,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 35,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 62,
		PowerbandStart = 1700,
		PowerbandEnd = 5300,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 1.8,

		FuelFillPos = Vector(-80,36,17),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 80,

		AirFriction = -60,
		PowerBias = 0,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/feroci_idle.wav',

		snd_low = 'octoteam/vehicles/feroci_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/feroci_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/feroci_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/feroci_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/feroci_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/huntley_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.1,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(21.661, 18.166, 16.7), ang = Angle(-0.0, -90.0, 74.7) },
		Radio = { pos = Vector(30.318, 0.048, 17.829), ang = Angle(-21.2, 180.0, -0.0) },
		Plates = {
			Front = { pos = Vector(94.744, 0.001, -7.049), ang = Angle(0.9, 0.0, -0.0) },
			Back = { pos = Vector(-98.672, -0.002, 15.790), ang = Angle(-4.6, -180.0, -0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(10.909, -0.002, 40.261),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(23.973, 39.382, 28.223),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(24.246, -38.981, 27.872),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_huntley', V )

local V2 = {}
V2.Name = 'Jamaican Huntley Sport'
V2.Model = 'models/octoteam/vehicles/huntley.mdl'
V2.Class = 'gmod_sent_vehicle_fphysics_base'
V2.Category = 'Доброград - Особые'
V2.SpawnOffset = Vector(0,0,10)
V2.SpawnAngleOffset = 90
V2.NAKGame = 'Доброград'
V2.NAKType = 'Большие'

local V2Members = {}
for k,v in pairs(V.Members) do
	V2Members[k] = v
end
V2.Members = V2Members
V2.Members.OnSpawn = function(ent)
	-- ent:SetSkin(math.random(0,2))
	ent:SetBodyGroups('01'	 )

	if (ProxyColor ) then
		-- local CarCols = {}
		-- CarCols[1] =  {REN.GTA4ColorTable2(0,59,113,90)}
		-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
	end

	REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
end
list.Set('simfphys_vehicles', 'sim_fphys_gta4_huntley2', V2 )

local light_table = {
	L_HeadLampPos = Vector(83,32,11),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(83,-32,11),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-98,32,11),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-98,-32,11),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(83,32,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(83,-32,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(29.7,18,17.2),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(255,57,50,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(85,25,11),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(85,-25,11),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(29.7,19,17.2),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(255,57,50,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(90,26,-12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(90,-26,-12),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-98,32,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-98,-32,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-98,32,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-98,-32,11),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-81,0,43),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-98,32,15),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-98,-32,15),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
	},

	ems_sounds = {'octoteam/vehicles/police/siren1.wav','octoteam/vehicles/police/siren2.wav','octoteam/vehicles/police/siren3.wav'},
	ems_sprites = {
		{
			pos = Vector(91.0, -24.0, 0.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.035
		},
		{
			pos = Vector(91.0, 24.0, 0.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(94.6, -8.6, -6.9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.03
		},
		{
			pos = Vector(94.6, 8.6, -6.9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.025
		},
		{
			pos = Vector(89.1, -12.9, 10.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.035
		},
		{
			pos = Vector(89.1, 12.9, 10.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.035
		},
		{
			pos = Vector(26.1, -36.7, 23.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.035
		},
		{
			pos = Vector(26.1, 36.7, 23.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.035
		},
		{
			pos = Vector(34.3, -38.1, -13.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.035
		},
		{
			pos = Vector(34.3, 38.1, -13.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-34.3, 38.1, -13.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-34.3, -38.1, -13.4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-98.7, -9.0, 15.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.035
		},
		{
			pos = Vector(-98.7, 9.0, 15.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.033
		},
		{
			pos = Vector(12, 22, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.034
		},
		{
			pos = Vector(12, 18, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.033
		},
		{
			pos = Vector(12, 14, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.034
		},
		{
			pos = Vector(12, 10, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.032
		},
		{
			pos = Vector(12, -22, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.034
		},
		{
			pos = Vector(12, -18, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.033
		},
		{
			pos = Vector(12, -14, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.034
		},
		{
			pos = Vector(12, -10, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.032
		},
		{
			pos = Vector(-79.3, -22, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.034
		},
		{
			pos = Vector(-79.3, -18, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.033
		},
		{
			pos = Vector(-79.3, -14, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.034
		},
		{
			pos = Vector(-79.3, -10, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.032
		},
		{
			pos = Vector(-79.3, 22, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.034
		},
		{
			pos = Vector(-79.3, 18, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.033
		},
		{
			pos = Vector(-79.3, 14, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.033
		},
		{
			pos = Vector(-79.3, 10, 41.2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			Colors = {
						Color(0,0,255,150),
						Color(0,0,0,0),
						Color(0,0,255,150),
						--
						Color(0,0,255,255),
						Color(0,0,255,50),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						--
						Color(0,0,255,50),
						Color(0,0,255,255),
					},
			Speed = 0.032
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(87,23,8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-97.4,32.3,18.3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(29.7,20,17.2),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(255,57,50,255),
			},]]
		},
		Right = {
			{
				pos = Vector(87,-23,8),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-97.4,-32.3,18.3),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(29.7,17,17.2),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(255,57,50,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[3] = '',
				[13] = '',
				[9] = '',
				[12] = ''
			},
			Brake = {
				[3] = '',
				[13] = '',
				[9] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[12] = ''
			},
			Reverse = {
				[3] = '',
				[13] = '',
				[9] = '',
				[12] = 'models/gta4/vehicles/huntley/huntley_lights_on'
			},
			Brake_Reverse = {
				[3] = '',
				[13] = '',
				[9] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[12] = 'models/gta4/vehicles/huntley/huntley_lights_on'
			},
		},
		on_lowbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[13] = '',
				[9] = '',
				[12] = ''
			},
			Brake = {
				[3] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[13] = '',
				[9] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[12] = ''
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[13] = '',
				[9] = '',
				[12] = 'models/gta4/vehicles/huntley/huntley_lights_on'
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[13] = '',
				[9] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[12] = 'models/gta4/vehicles/huntley/huntley_lights_on'
			},
		},
		on_highbeam = {
			Base = {
				[3] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[13] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[9] = '',
				[12] = ''
			},
			Brake = {
				[3] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[13] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[9] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[12] = ''
			},
			Reverse = {
				[3] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[13] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[9] = '',
				[12] = 'models/gta4/vehicles/huntley/huntley_lights_on'
			},
			Brake_Reverse = {
				[3] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[13] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[9] = 'models/gta4/vehicles/huntley/huntley_lights_on',
				[12] = 'models/gta4/vehicles/huntley/huntley_lights_on'
			},
		},
		turnsignals = {
			left = {
				[14] = 'models/gta4/vehicles/huntley/huntley_lights_on'
			},
			right = {
				[8] = 'models/gta4/vehicles/huntley/huntley_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_huntley', light_table)