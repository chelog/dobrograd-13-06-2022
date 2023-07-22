local V = {
	Name = 'Ingot',
	Model = 'models/octoteam/vehicles/ingot.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Седаны',
	SpawnOffset = Vector(0,0,15),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Седаны',

	Members = {
		Mass = 1400,
		Trunk = { 50 },

		EnginePos = Vector(65,0,0),

		LightsTable = 'gta4_ingot',

		OnSpawn = function(ent)
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

		CustomWheelModel = 'models/octoteam/vehicles/ingot_wheel.mdl',

		CustomWheelPosFL = Vector(58,29,-16),
		CustomWheelPosFR = Vector(58,-29,-16),
		CustomWheelPosRL = Vector(-58,29,-16),
		CustomWheelPosRR = Vector(-58,-29,-16),
		CustomWheelAngleOffset = Angle(0,-90,0),

		CustomMassCenter = Vector(0,0,5),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-8,-16,17),
		SeatPitch = 0,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(3,-16,-15),
				ang = Angle(0,-90,20),
				hasRadio = true
			},
			{
				pos = Vector(-31,16,-15),
				ang = Angle(0,-90,20)
			},
			{
				pos = Vector(-31,-16,-15),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-92,22,-11),
				ang = Angle(-180,0,0),
			},
		},

		FrontHeight = 9,
		FrontConstant = 24000,
		FrontDamping = 800,
		FrontRelativeDamping = 800,

		RearHeight = 9,
		RearConstant = 24000,
		RearDamping = 800,
		RearRelativeDamping = 800,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 500,

		TurnSpeed = 3.5,

		MaxGrip = 40,
		Efficiency = 0.85,
		GripOffset = 0,
		BrakePower = 28,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 6000,
		PeakTorque = 38,
		PowerbandStart = 1200,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,

		FuelFillPos = Vector(-72,-33,9),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,

		AirFriction = -60,
		PowerBias = -1,

		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = 'octoteam/vehicles/lokus_idle.wav',

		snd_low = 'octoteam/vehicles/lokus_revdown_loop.wav',
		snd_low_revdown = 'octoteam/vehicles/lokus_revdown.wav',
		snd_low_pitch = 1,

		snd_mid = 'octoteam/vehicles/lokus_gear_loop.wav',
		snd_mid_gearup = 'octoteam/vehicles/lokus_gear.wav',
		snd_mid_geardown = 'octoteam/vehicles/lokus_shiftdown.wav',
		snd_mid_pitch = 1,

		snd_horn = 'octoteam/vehicles/horns/ingot_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.3,
		Gears = {-0.12,0,0.1,0.17,0.25,0.34,0.45},

		Dash = { pos = Vector(21.390, 15.208, 9.086), ang = Angle(-0.0, -90.0, 73.4) },
		Radio = { pos = Vector(27.524, 0.003, 8.706), ang = Angle(-19.3, 180.0, 0.0) },
		Plates = {
			Front = { pos = Vector(98.185, -0.001, -8.530), ang = Angle(0.0, 0.0, 0.0) },
			Back = { pos = Vector(-97.431, -0.004, 1.924), ang = Angle(0.0, 180.0, 0.0) },
		},
		Mirrors = {
			top = {
				pos = Vector(6.877, -0.002, 25.818),
				ang = Angle(10, 0, 0),
				w = 1 / 3,
				ratio = 3.5 / 1,
			},
			left = {
				pos = Vector(25.552, 36.748, 13.819),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
			right = {
				pos = Vector(25.506, -36.920, 13.885),
				w = 1 / 5,
				ratio = 4.5 / 3,
			},
		},
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_gta4_ingot', V )

local V2 = {}
V2.Name = 'Russian Mafia Ingot'
V2.Model = 'models/octoteam/vehicles/ingot.mdl'
V2.Class = 'gmod_sent_vehicle_fphysics_base'
V2.Category = 'Доброград - Особые'
V2.SpawnOffset = Vector(0,0,15)
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
	-- ent:SetBodyGroups('0111'..math.random(0,1) )

	if (ProxyColor ) then
		-- local CarCols = {}
		-- CarCols[1] =  {REN.GTA4ColorTable(0,0,33)}
		-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
	end

	REN.GTA4SimfphysInit(ent, 0, 1) --name of car 'ent', ignition type 0-Standard Car 1-Truck 2-Moped 3-Bike, has shutdown noise? 0/1
end
list.Set('simfphys_vehicles', 'sim_fphys_gta4_ingot2', V2 )

local light_table = {
	L_HeadLampPos = Vector(90,23,-1),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector(90,-23,-1),
	R_HeadLampAng = Angle(5,0,0),

	L_RearLampPos = Vector(-94,31,3),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-94,-31,3),
	R_RearLampAng = Angle(25,180,0),

	ModernLights = true,

	Headlight_sprites = {
		{
			pos = Vector(90,23,-1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},
		{
			pos = Vector(90,-23,-1),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(227,242,255,50),
		},

--[[		{
			pos = Vector(24,23,12.5),
			material = 'gta4/dash_lowbeam',
			size = 0.75,
			color = Color(0,255,0,255),
		},]]
	},

	Headlamp_sprites = {
		{pos = Vector(90,23,-1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},
		{pos = Vector(90,-23,-1),size = 80,material = 'octoteam/sprites/lights/gta4_corona'},

--[[		{
			pos = Vector(24,23,11.5),
			material = 'gta4/dash_highbeam',
			size = 0.75,
			color = Color(0,0,255,255),
		},]]
	},

	Rearlight_sprites = {
		{
			pos = Vector(-94,31,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-94,-31,3),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 60,
			color = Color(255,0,0,150),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-97,24,3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
		{
			pos = Vector(-97,-24,3.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 70,
			color = Color(255,0,0,150),
		},
	},
	Reverselight_sprites = {
		{
			pos = Vector(-97,16,1.5),
			material = 'octoteam/sprites/lights/gta4_corona',
			size = 30,
			color = Color(255,255,255,150),
		},
		{
			pos = Vector(-97,-16,1.5),
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
				pos = Vector(86,30,-1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-96,24,7.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(24,17,13.5),
				material = 'gta4/dash_left',
				size = 0.75,
				color = Color(0,255,0,255),
			},]]
		},
		Right = {
			{
				pos = Vector(86,-30,-1),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,250),
			},
			{
				pos = Vector(-96,-24,7.5),
				material = 'octoteam/sprites/lights/gta4_corona',
				size = 40,
				color = Color(255,135,0,150),
			},

--[[			{
				pos = Vector(24,13.7,13.5),
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
				[9] = '',
			},
			Brake = {
				[10] = '',
				[11] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
				[9] = '',
			},
			Reverse = {
				[10] = '',
				[11] = '',
				[9] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
			},
			Brake_Reverse = {
				[10] = '',
				[11] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
				[9] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
			},
		},
		on_lowbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
				[11] = '',
				[9] = '',
			},
			Brake = {
				[10] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
				[11] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
				[9] = '',
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
				[11] = '',
				[9] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
				[11] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
				[9] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
			},
		},
		on_highbeam = {
			Base = {
				[10] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
				[11] = '',
				[9] = '',
			},
			Brake = {
				[10] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
				[11] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
				[9] = '',
			},
			Reverse = {
				[10] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
				[11] = '',
				[9] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
			},
			Brake_Reverse = {
				[10] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
				[11] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
				[9] = 'models/gta4/vehicles/ingot/flatpack_lights_on',
			},
		},
		turnsignals = {
			left = {
				[6] = 'models/gta4/vehicles/ingot/flatpack_lights_on'
			},
			right = {
				[5] = 'models/gta4/vehicles/ingot/flatpack_lights_on'
			},
		},
	}
}
list.Set('simfphys_lights', 'gta4_ingot', light_table)