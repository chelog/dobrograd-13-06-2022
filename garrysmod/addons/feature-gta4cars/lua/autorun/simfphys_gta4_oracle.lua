local V = {
	Name = 'Oracle',
	Model = 'models/octoteam/vehicles/oracle.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,20),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1800.0,

		EnginePos = Vector(70,0,10),

		LightsTable = 'gta4_oracle',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			ent:SetBodyGroups('00100'	 )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(0,0,0)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,0,61)}
				-- CarCols[3] =  {REN.GTA4ColorTable(1,1,54)}
				-- CarCols[4] =  {REN.GTA4ColorTable(7,7,48)}
				-- CarCols[5] =  {REN.GTA4ColorTable(10,10,18)}
				-- CarCols[6] =  {REN.GTA4ColorTable(11,11,97)}
				-- CarCols[7] =  {REN.GTA4ColorTable(20,20,86)}
				-- CarCols[8] =  {REN.GTA4ColorTable(22,22,66)}
				-- CarCols[9] =  {REN.GTA4ColorTable(46,46,91)}
				-- CarCols[10] = {REN.GTA4ColorTable(40,40,35)}
				-- CarCols[11] = {REN.GTA4ColorTable(49,49,53)}
				-- CarCols[12] = {REN.GTA4ColorTable(52,52,51)}
				-- CarCols[13] = {REN.GTA4ColorTable(54,54,53)}
				-- CarCols[14] = {REN.GTA4ColorTable(57,57,58)}
				-- CarCols[15] = {REN.GTA4ColorTable(70,70,118)}
				-- CarCols[16] = {REN.GTA4ColorTable(76,76,118)}
				-- CarCols[17] = {REN.GTA4ColorTable(106,106,108)}
				-- CarCols[18] = {REN.GTA4ColorTable(16,16,76)}
				-- CarCols[19] = {REN.GTA4ColorTable(9,9,91)}
				-- CarCols[20] = {REN.GTA4ColorTable(15,15,93)}
				-- CarCols[21] = {REN.GTA4ColorTable(19,19,93)}
				-- CarCols[22] = {REN.GTA4ColorTable(13,13,80)}
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

		CustomWheelModel = 'models/octoteam/vehicles/oracle_wheel.mdl',

		CustomWheelPosFL = Vector(63,33,-20),
		CustomWheelPosFR = Vector(63,-33,-20),
		CustomWheelPosRL = Vector(-63,33,-20),
		CustomWheelPosRR = Vector(-63,-33,-20),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-5,-18,10),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(7,-17,-20),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-37,17,-20),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-37,-17,-20),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-105,25,-21),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-105,-25,-21),
				ang = Angle(-90,0,0),
			},
		},

		FrontHeight = 10,
		FrontConstant = 25000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 10,
		RearConstant = 25000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 600,

		TurnSpeed = 3,

		MaxGrip = 83,
		Efficiency = 0.7,
		GripOffset = 0,
		BrakePower = 25,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5500,
		PeakTorque = 143.0,
		PowerbandStart = 2500,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-73,37,5),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 90,

		PowerBias = 1,

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

		snd_horn = 'octoteam/vehicles/horns/infernus_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.17,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_oracle', V )

local V2 = {}
V2.Name = 'Irish Mob Oracle'
V2.Model = 'models/octoteam/vehicles/oracle.mdl'
V2.Class = 'gmod_sent_vehicle_fphysics_base'
V2.Category = 'Доброград - Особые'
V2.SpawnOffset = Vector(0,0,20)
V2.SpawnAngleOffset = 90
V2.NAKGame = 'Доброград'
V2.NAKType = 'Седаны'

local V2Members = {}
for k,v in pairs(V.Members) do
	V2Members[k] = v
end
V2.Members = V2Members
V2.Members.OnSpawn = function(ent)
	-- ent:SetSkin(math.random(0,2))
	ent:SetBodyGroups('01011'	 )

	if (ProxyColor ) then
		-- local CarCols = {}
		-- CarCols[1] =  {REN.GTA4ColorTable(0,0,57)}
		-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
	end

	REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
end
list.Set('simfphys_vehicles', 'sim_fphys_gta4_oracle2', V2 )

local light_table = {
	L_HeadLampPos = Vector(86,32,-4),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(86,-32,-4),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-100,33,2),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-100,-33,2),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(86,32,-4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},
		{
			pos = Vector(86,-32,-4),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},

--[[		{
			pos = Vector(28,29,7),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(90,25,-4),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(90,-25,-4),size = 60,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(28,29,6),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	FogLight_sprites = {
		{
			pos = Vector(93,28,-21),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(93,-28,-21),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(227,242,255,255),
		},
	},
	Rearlight_sprites = {
		{
			pos = Vector(-100,33,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-100,-33,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-100,33,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-100,-33,2),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-105,14,5.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-105,-14,5.7),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
	},

	DelayOn = 0,
	DelayOff = 0,

	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(92,29,-7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-100,33,-1.6),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(28,24,9),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(92,-29,-7),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-100,-33,-1.6),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(28,17.5,9),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[4] = '',
				[5] = '',
				[11] = '',
				[10] = '',
			},
			Brake = {
				[4] = '',
				[5] = '',
				[11] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[10] = '',
			},
			Reverse = {
				[4] = '',
				[5] = '',
				[11] = '',
				[10] = 'models/gta4/vehicles/oracle/oracle_lights_on',
			},
			Brake_Reverse = {
				[4] = '',
				[5] = '',
				[11] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[10] = 'models/gta4/vehicles/oracle/oracle_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[5] = '',
				[11] = '',
				[10] = '',
			},
			Brake = {
				[4] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[5] = '',
				[11] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[10] = '',
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[5] = '',
				[11] = '',
				[10] = 'models/gta4/vehicles/oracle/oracle_lights_on',
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[5] = '',
				[11] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[10] = 'models/gta4/vehicles/oracle/oracle_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[4] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[5] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[11] = '',
				[10] = '',
			},
			Brake = {
				[4] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[5] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[11] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[10] = '',
			},
			Reverse = {
				[4] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[5] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[11] = '',
				[10] = 'models/gta4/vehicles/oracle/oracle_lights_on',
			},
			Brake_Reverse = {
				[4] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[5] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[11] = 'models/gta4/vehicles/oracle/oracle_lights_on',
				[10] = 'models/gta4/vehicles/oracle/oracle_lights_on',
			},
		},
		turnsignals = {
			left = {
				[8] = 'models/gta4/vehicles/oracle/oracle_lights_on'
			},
			right = {
				[9] = 'models/gta4/vehicles/oracle/oracle_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_oracle', light_table)