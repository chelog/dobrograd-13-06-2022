local V = {
	Name = 'Sultan',
	Model = 'models/octoteam/vehicles/sultan.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,0),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1400.0,

		EnginePos = Vector(60,0,10),

		LightsTable = 'gta4_sultan',

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))
			-- ent:SetBodyGroups('0'..math.random(1,2)..'000' )

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] =  {REN.GTA4ColorTable(13,0,80)}
				-- CarCols[2] =  {REN.GTA4ColorTable(0,1,1)}
				-- CarCols[3] =  {REN.GTA4ColorTable(3,1,1)}
				-- CarCols[4] =  {REN.GTA4ColorTable(10,1,1)}
				-- CarCols[5] =  {REN.GTA4ColorTable(25,1,1)}
				-- CarCols[6] =  {REN.GTA4ColorTable(37,1,1)}
				-- CarCols[7] =  {REN.GTA4ColorTable(53,6,1)}
				-- CarCols[8] =  {REN.GTA4ColorTable(61,1,1)}
				-- CarCols[9] =  {REN.GTA4ColorTable(74,0,83)}
				-- CarCols[10] = {REN.GTA4ColorTable(92,1,1)}
				-- CarCols[11] = {REN.GTA4ColorTable(6,0,12)}
				-- CarCols[12] = {REN.GTA4ColorTable(10,0,12)}
				-- CarCols[13] = {REN.GTA4ColorTable(21,0,12)}
				-- CarCols[14] = {REN.GTA4ColorTable(23,0,12)}
				-- CarCols[15] = {REN.GTA4ColorTable(25,0,12)}
				-- CarCols[16] = {REN.GTA4ColorTable(33,0,35)}
				-- CarCols[17] = {REN.GTA4ColorTable(34,0,34)}
				-- CarCols[18] = {REN.GTA4ColorTable(47,0,35)}
				-- CarCols[19] = {REN.GTA4ColorTable(49,0,63)}
				-- CarCols[20] = {REN.GTA4ColorTable(52,0,56)}
				-- CarCols[21] = {REN.GTA4ColorTable(54,0,55)}
				-- CarCols[22] = {REN.GTA4ColorTable(65,0,63)}
				-- CarCols[23] = {REN.GTA4ColorTable(67,0,118)}
				-- CarCols[24] = {REN.GTA4ColorTable(70,0,65)}
				-- CarCols[25] = {REN.GTA4ColorTable(98,0,90)}
				-- CarCols[26] = {REN.GTA4ColorTable(16,0,76)}
				-- CarCols[27] = {REN.GTA4ColorTable(9,0,91 )}
				-- CarCols[28] = {REN.GTA4ColorTable(15,0,93)}
				-- CarCols[29] = {REN.GTA4ColorTable(19,0,93)}
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

		CustomWheelModel = 'models/octoteam/vehicles/sultan_wheel.mdl',

		CustomWheelPosFL = Vector(56,30,-3),
		CustomWheelPosFR = Vector(56,-30,-3),
		CustomWheelPosRL = Vector(-56,30,-3),
		CustomWheelPosRR = Vector(-56,-30,-3),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-10,-15,25),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(0,-15,-8),
				ang = Angle(0,-90,15),
				hasRadio = true
			},
			{
				pos = Vector(-27,15,-8),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-27,-15,-8),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-91,21,-5),
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

		MaxGrip = 80,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 30,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 145.0,
		PowerbandStart = 1700,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-70,33,20),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 80,

		PowerBias = 0.25,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/sultan_idle.wav',

		snd_low = 'octoteam/vehicles/sultan_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/sultan_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/sultan_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/sultan_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/sultan_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/emperor_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.22,
		Gears = {-0.4,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_sultan', V )

local V2 = {}
V2.Name = 'Korean Mob Sultan TT'
V2.Model = 'models/octoteam/vehicles/sultan.mdl'
V2.Class = 'gmod_sent_vehicle_fphysics_base'
V2.Category = 'Доброград - Особые'
V2.SpawnOffset = Vector(0,0,0)
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
	ent:SetBodyGroups('00111' )

	if (ProxyColor ) then
		-- local CarCols = {}
		-- CarCols[1] =  {REN.GTA4ColorTable(75,1,1)}
		-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
	end

	REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
end
V2.Members.ModelInfo = {
	WheelColor = Color(122,117,96),
},
list.Set('simfphys_vehicles', 'sim_fphys_gta4_sultan2', V2 )

local light_table = {
	L_HeadLampPos = Vector(76,29,9),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(76,-29,9),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-94,26,14),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-94,-26,14),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(76,29,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},
		{
			pos = Vector(76,-29,9),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,255),
		},

--[[		{
			pos = Vector(21,20,19.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(81,22,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(81,-22,8),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(21,19.2,19.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-94,26,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-94,-26,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-96,18,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-96,-18,14),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-95,25,17),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 40,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-95,-25,17),
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
				pos = Vector(-93,27,19),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(21,15.5,22.4),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(-93,-27,19),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(21,14.8,22.4),
				material = 'gta4/dash_right',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
	},

	SubMaterials = {
		off = {
			Base = {
				[9] = '',
				[12] = '',
				[4] = '',
				[8] = ''
			},
			Brake = {
				[9] = '',
				[12] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[4] = '',
				[8] = ''
			},
			Reverse = {
				[9] = '',
				[12] = '',
				[4] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[8] = ''
			},
			Brake_Reverse = {
				[9] = '',
				[12] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[4] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[8] = ''
			},
		},
		on_lowbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[12] = '',
				[4] = '',
				[8] = ''
			},
			Brake = {
				[9] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[12] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[4] = '',
				[8] = ''
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[12] = '',
				[4] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[8] = ''
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[12] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[4] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[8] = ''
			},
		},
		on_highbeam = {
			Base = {
				[9] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[12] = '',
				[4] = '',
				[8] = 'models/gta4/vehicles/sultan/sultan_lights_on'
			},
			Brake = {
				[9] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[12] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[4] = '',
				[8] = 'models/gta4/vehicles/sultan/sultan_lights_on'
			},
			Reverse = {
				[9] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[12] = '',
				[4] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[8] = 'models/gta4/vehicles/sultan/sultan_lights_on'
			},
			Brake_Reverse = {
				[9] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[12] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[4] = 'models/gta4/vehicles/sultan/sultan_lights_on',
				[8] = 'models/gta4/vehicles/sultan/sultan_lights_on'
			},
		},
		turnsignals = {
			left = {
				[11] = 'models/gta4/vehicles/sultan/sultan_lights_on'
			},
			right = {
				[5] = 'models/gta4/vehicles/sultan/sultan_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_sultan', light_table)