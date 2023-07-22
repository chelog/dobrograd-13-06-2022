local V = {
	Name = 'Contender',
	Model = 'models/octoteam/vehicles/e109.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Большие',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Большие',

	Members = {
		Mass = 2250,
		Trunk = {
			nil,
			{50, 1, 1},
			{50, 1, 2},
			{50, 1, 4},
		},

		EnginePos = Vector(70,0,10),

		LightsTable = 'gta4_e109',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(0,3)..math.random(0,1)	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,0,0)}
				-- CarCols[3] =  {REN.GTA4ColorTable(20,20,8)}
				-- CarCols[4] =  {REN.GTA4ColorTable(11,11,12)}
				-- CarCols[5] =  {REN.GTA4ColorTable(7,1,12)}
				-- CarCols[6] =  {REN.GTA4ColorTable(1,0,8)}
				-- CarCols[7] =  {REN.GTA4ColorTable(47,47,43)}
				-- CarCols[8] =  {REN.GTA4ColorTable(49,40,43)}
				-- CarCols[9] =  {REN.GTA4ColorTable(57,60,51)}
				-- CarCols[10] = {REN.GTA4ColorTable(65,64,63)}
				-- CarCols[11] = {REN.GTA4ColorTable(70,73,75)}
				-- CarCols[12] = {REN.GTA4ColorTable(85,85,58)}
				-- CarCols[13] = {REN.GTA4ColorTable(95,94,95)}
				-- CarCols[14] = {REN.GTA4ColorTable(102,90,106)}
				-- CarCols[15] = {REN.GTA4ColorTable(2,2,63)}
				-- CarCols[16] = {REN.GTA4ColorTable(21,21,72 )}
				-- CarCols[17] = {REN.GTA4ColorTable(22,22,72 )}
				-- CarCols[18] = {REN.GTA4ColorTable(13,11,91 )}
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

		CustomWheelModel = 'models/octoteam/vehicles/e109_wheel.mdl',

		CustomWheelPosFL = Vector(70,36,-10),
		CustomWheelPosFR = Vector(70,-36,-10),
		CustomWheelPosRL = Vector(-76,36,-10),
		CustomWheelPosRR = Vector(-76,-36,-10),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-12,-20,30),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-3,-20,-2),
				ang = Angle(0,-90,10),
				hasRadio = true
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-108.4,36.6,-14.4),
				ang = Angle(-100,-45,0),
			},
			{
				pos = Vector(-108.4,-36.6,-14.4),
				ang = Angle(-100,45,0),
			},
		},

		FrontHeight = 9,
		FrontConstant = 38000,
		FrontDamping = 950,
		FrontRelativeDamping = 950,

		RearHeight = 9,
		RearConstant = 38000,
		RearDamping = 950,
		RearRelativeDamping = 950,

		FastSteeringAngle = 12,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3.5,

		MaxGrip = 60,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 34,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 46,
		PowerbandStart = 1700,
		PowerbandEnd = 4600,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		PowerBoost = 2.5,

		FuelFillPos = Vector(-33,40,10),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 65,

		PowerBias = 0,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/e109_idle.wav',

		snd_low = 'octoteam/vehicles/e109_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/e109_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/e109_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/e109_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/e109_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/vigero_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.1,0,0.1,0.2,0.32,0.44,0.5},

		Dash = { pos = Vector(22.741, 19.793, 23.546), ang = Angle(-0.0, -90.0, 72.3) },
		Radio = { pos = Vector(25.582, -0.017, 19.804), ang = Angle(-17.0, -180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(109.110, -0.003, -3.951), ang = Angle(2.2, 0.0, 0.0) },
			Back = { pos = Vector(-121.217, 0.000, -7.136), ang = Angle(7.8, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(13.758, -0.002, 40.761),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(20.287, 41.161, 31.411),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(20.633, -41.754, 31.598),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},

		CanAttachPackages = true,
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_e109', V )

local V2 = {}
V2.Name = 'Irish Mob Contender'
V2.Model = 'models/octoteam/vehicles/e109.mdl'
V2.Class = 'gmod_sent_vehicle_fphysics_base'
V2.Category = 'Доброград - Особые'
V2.SpawnOffset = Vector(0,0,20)
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
	ent:SetBodyGroups('041'	 )

	if (ProxyColor ) then
		-- local CarCols = {}
		-- CarCols[1] =  {REN.GTA4ColorTable(56,56,59)}
		-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
	end

	REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
end,
list.Set('simfphys_vehicles', 'sim_fphys_gta4_e109_2', V2 )

local light_table = {
	L_HeadLampPos = Vector(99,32,13),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(99,-32,13),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-120,39,15),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-120,-39,15),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(99,32,13),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(99,-32,13),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(23,20,22),
			material = 'gta4/dash_lowbeam',
			size = 1,
			color = Color(255,57,50,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(100,26,13),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(100,-26,13),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(23,18,22),
			material = 'gta4/dash_highbeam',
			size = 1,
			color = Color(255,57,50,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-120,39,15),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-120,-39,15),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-120,39,15),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-120,-39,15),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(97,36.6,14.7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-120,39,20),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,22,22),
				material = 'gta4/dash_left',
				size = 1,
				color = Color(255,57,50,255),
			},]]
		},
		Right = {
			{
				pos = Vector(97,-36.6,14.7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},
			{
				pos = Vector(-120,-39,20),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(23,16,22),
				material = 'gta4/dash_right',
				size = 1,
				color = Color(255,57,50,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[5] = '',
				[6] = '',
			},
		},
		on_lowbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/e109/e_109_lights_on',
				[6] = '',
			},
		},
		on_highbeam = {
			Base = {
				[5] = 'models/gta4/vehicles/e109/e_109_lights_on',
				[6] = 'models/gta4/vehicles/e109/e_109_lights_on',
			},
		},
		turnsignals = {
			left = {
				[9] = 'models/gta4/vehicles/e109/e_109_lights_on'
			},
			right = {
				[10] = 'models/gta4/vehicles/e109/e_109_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_e109', light_table)