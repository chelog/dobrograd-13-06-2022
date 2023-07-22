local V = {
	Name = 'Caddy',
	Model = 'models/octoteam/vehicles/caddy.mdl',
	Class = 'gmod_sent_vehicle_fphysics_base',
	Category = 'Доброград - Сервис',
	SpawnOffset = Vector(0,0,0),
	SpawnAngleOffset = 90,
	NAKGame = 'Доброград',
	NAKType = 'Сервис',

	Members = {
		Mass = 1000.0,

		EnginePos = Vector(-20,0,10),

		OnSpawn = function(ent)
			-- ent:SetSkin(math.random(0,2))

			if (ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {REN.GTA4ColorTable(112,112,112)}
				-- ent:SetProxyColors(CarCols[math.random(1,table.Count(CarCols))] )
			end

			REN.GTA4EngStop(ent, 0)

			ent.GearChanged = 0

			ent.StartEngine = function(ent, bIgnoreSettings)
			if not ent:EngineActive() then
				if not bIgnoreSettings then
					ent.CurrentGear = 2
				end

				if not ent.IsInWater then
					ent.GTA4Ignition = CreateSound(ent, 'octoteam/vehicles/START_CLICK.wav' )
					ent.GTA4Ignition:Play()

					if !ent:CanStart() then return end

					ent.EngineRPM = ent:GetEngineData().IdleRPM
					ent:SetEngineActive(true)
					else
						if ent:GetDoNotStall() then
							ent.GTA4Ignition = CreateSound(ent, 'octoteam/vehicles/START_CLICK.wav' )
							ent.GTA4Ignition:Play()

							if !ent:CanStart() then return end

							ent.EngineRPM = ent:GetEngineData().IdleRPM
							ent:SetEngineActive(true)
						end
					end
				end
			end
		end,

		OnTick = function(ent)
			REN.GTA4GearSounds(ent)
			REN.GTA4Braking(ent)

			ent.WheelSND = CreateSound(ent, 'octoteam/vehicles/GOLF_KART_WHEEL_LOOP.wav' )
			ent.WheelSND:PlayEx(0,100)

			ent.WheelSND:ChangeVolume(math.Clamp(math.abs(ent.ForwardSpeed/200),0,0.6), 0 )
			ent.WheelSND:ChangePitch(math.Clamp(math.abs(ent.ForwardSpeed/5),25,100), 0 )
		end,

		OnDelete = function(ent)
			REN.GTA4Delete(ent) --MUST call on EVERY car that uses gta 4 functions

			ent.WheelSND:Stop()
		end,

		CustomWheels = true,
		CustomSuspensionTravel = 1.5,

		CustomWheelModel = 'models/octoteam/vehicles/caddy_wheel.mdl',

		CustomWheelPosFL = Vector(40,22,-3),
		CustomWheelPosFR = Vector(40,-22,-3),
		CustomWheelPosRL = Vector(-40,22,-3),
		CustomWheelPosRR = Vector(-40,-22,-3),
		CustomWheelAngleOffset = Angle(0,-90,0),

		FrontWheelRadius = 10,
		RearWheelRadius = 10,

		CustomMassCenter = Vector(0,0,2),

		CustomSteerAngle = 35,

		SeatOffset = Vector(-25,-12,38),
		SeatPitch = 15,
		SeatYaw = 90,

		PassengerSeats = {
			{
				pos = Vector(-10,-10,10),
				ang = Angle(0,-90,0),
				hasRadio = true
			},
		},

		FrontHeight = 10,
		FrontConstant = 20000,
		FrontDamping = 750,
		FrontRelativeDamping = 350,

		RearHeight = 10,
		RearConstant = 20000,
		RearDamping = 750,
		RearRelativeDamping = 350,

		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 350,

		TurnSpeed = 3,

		MaxGrip = 65,
		Efficiency = 0.65,
		GripOffset = 0,
		BrakePower = 10,
		BulletProofTires = false,

		IdleRPM = 800,
		LimitRPM = 5000,
		PeakTorque = 140.0,
		PowerbandStart = 2000,
		PowerbandEnd = 4000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = true,

		FuelFillPos = Vector(-28,24,16),
		FuelType = FUELTYPE_ELECTRIC,
		FuelTankSize = 45,

		PowerBias = 1,

		EngineSoundPreset = 0,

		Sound_Idle = 'octoteam/vehicles/GOLF_KART_IDLE.wav',
		Sound_IdlePitch = 0.9,

		Sound_Mid = 'octoteam/vehicles/GOLF_KART_REVS_OFF.wav',
		Sound_MidPitch = 1,
		Sound_MidVolume = 0.3,
		Sound_MidFadeOutRPMpercent = 50,
		Sound_MidFadeOutRate = 0.3,

		Sound_High = 'octoteam/vehicles/GOLF_KART_MAIN_LOOP.wav',
		Sound_HighPitch = 1,
		Sound_HighVolume = 0.5,
		Sound_HighFadeInRPMpercent = 50,
		Sound_HighFadeInRate = 0.3,

		Sound_Throttle = 'common/null.wav',
		Sound_ThrottlePitch = 1,
		Sound_ThrottleVolume = 1,

		snd_horn = 'octoteam/vehicles/horns/airtug_horn.wav',
		snd_bloweron = 'common/null.wav',
		snd_bloweroff = 'octoteam/vehicles/shared/TURBO_2.wav',
		snd_spool = 'octoteam/vehicles/shared/TURBO_3.wav',
		snd_blowoff = 'octoteam/vehicles/shared/WASTE_GATE.wav',

		DifferentialGear = 0.30,
		Gears = {-0.3,0,0.3}
	}
}
list.Set('simfphys_vehicles', 'sim_fphys_tbogt_caddy', V )