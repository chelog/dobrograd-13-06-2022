//AddCSLuaFile()

local light_table = {
	L_RearLampPos = Vector(-131.97284, 36.89712,-40.0824),
	L_RearLampAng = Angle(0,0,0),

	R_RearLampPos = Vector(-131.97284,-36.89712,-40.0824),
	R_RearLampAng = Angle(0,0,0),
	Rearlight_sprites = {
		{pos = Vector(-143, 36.89712,-40.0824),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-143,-36.89712,-40.0824),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
	},
	ems_sprites = {
		{pos = Vector(-143, 36.89712,-40.0824),size = 35,Colors = {Color(255,0,0,255),Color(255,0,0,255)},Speed = 0.04,},
		{pos = Vector(-143,-36.89712,-40.0824),size = 35,Colors = {Color(255,0,0,255),Color(255,0,0,255)},Speed = 0.04,},
		{pos = Vector(-143, 30.522528,-40.0824),size = 35,Colors = {Color(255,0,0,255),Color(255,0,0,255)},Speed = 0.04,},
		{pos = Vector(-143,-30.522528,-40.0824),size = 35,Colors = {Color(255,0,0,255),Color(255,0,0,255)},Speed = 0.04,},
	},
	Reverselight_sprites = {
		{pos = Vector(-143, 30.522528,-40.0824),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-143,-30.522528,-40.0824),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	Turnsignal_sprites = {
		Left = {
			{pos = Vector(-143, 30.522528,-40.0824),size = 25},
		},
		Right = {
			{pos = Vector(-143,-30.522528,-40.0824),size = 25},
		},
	},
}
list.Set( "simfphys_lights", "gta_sa_artict1", light_table)

local TRAILER = {
    Name = "Articulated Trailer 1",
    Model = "models/octocar/industrial/artict1.mdl",
    Category = "GTA SA Trailers",
    SpawnOffset = Vector(0,0,40),
    SpawnAngleOffset = 90,

    Members = {
        Mass = 6666,

        OnSpawn = function(ent)
            if ent:SimfIsTrailer() != nil then
                ent:SetActive( true )
                ent:SetSimfIsTrailer(true)
                ent:SetTrailerCenterposition(Vector(220.877,0,-14.2606))
                ent:SetCenterposition(Vector(0,0,0))
            else
                print("INSTALL TRAILERS BASE FIRST")
            end
        end,
        OnTick = function(ent)
            if ent:SimfIsTrailer() != nil then
                ent:Lock() -- locks trailer
                if not ent:GetIsBraking() then
                    ent.ForceTransmission = 1
                    if ent:GetNWBool("zadnyaya_gear", false) then
                        ent.PressedKeys["joystick_throttle"] = 0 -- makes thottle to 0 when reverse, for remove handbrake
                        ent.PressedKeys["joystick_brake"] = 1 -- makes brake to 1, for turn on reverse
                    else
                        ent.PressedKeys["joystick_throttle"] = 1 -- makes thottle to 1, for remove handbrake
                        ent.PressedKeys["joystick_brake"] = 0 -- makes brake to 0, for turn off reverse
                    end
                end
            else
                print("INSTALL TRAILERS BASE FIRST")
            end
        end,

        LightsTable = "gta_sa_artict1",

        BulletProofTires = false,

        CustomSteerAngle = 0,

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/industrial/linerun_r_wheel.mdl",
		CustomWheelPosFL = Vector(-98.33184,-36.44172,-42),
		CustomWheelPosFR = Vector(-98.33184, 36.44172,-42),
		CustomWheelPosRL = Vector(-51.78024,-36.44172,-42),
		CustomWheelPosRR = Vector(-51.78024, 36.44172,-42),
		CustomWheelAngleOffset = Angle(0,90,0),

        CustomMassCenter = Vector(50,0,10),

        SeatOffset = Vector(0,0,0),
        SeatPitch = 0,
        SeatYaw = -90,

        MaxHealth = 9999999999,
        IsArmored = false,

        EnginePos = Vector(0,0,0),

        StrengthenSuspension = true,

        FrontHeight = 4,
        FrontWheelMass = 150,
        FrontConstant = 50000,
        FrontDamping = 3000,
        FrontRelativeDamping = 2000,

        RearHeight = 4,
        RearWheelMass = 150,
        RearConstant = 50000,
        RearDamping = 3000,
        RearRelativeDamping = 2000,

        FastSteeringAngle = 11,
        SteeringFadeFastSpeed = 535,

        TurnSpeed = 4,

        MaxGrip = 120,
        Efficiency = 0.85,
        GripOffset = 0,
        BrakePower = 0,

        IdleRPM = 0,
        LimitRPM = 0,
        Revlimiter = false,
        PeakTorque = 0,
        PowerbandStart = 0,
        PowerbandEnd = 0,
        Turbocharged = false,
        Supercharged = false,
        Backfire = false,

        FuelFillPos = Vector(0,0,0),
        FuelType = FUELTYPE_NONE,
        FuelTankSize = 0,

        PowerBias = 1,

        EngineSoundPreset = 1,
--
        snd_pitch = 0.5,
        snd_idle = "common/null.wav",

        snd_low = "common/null.wav",
        snd_low_revdown = "common/null.wav",
        snd_low_pitch = 1,

        snd_mid = "common/null.wav",
        snd_mid_gearup = "common/null.wav",
        snd_mid_geardown = "common/null.wav",
        snd_mid_pitch = 2,

        snd_horn = "common/null.wav",

        snd_blowoff = "common/null.wav",
        snd_backfire = "common/null.wav",
--
        DifferentialGear = 0.26666666666667,
        Gears = {-0.2,0,0.1}
    }
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_artict1", TRAILER )

local TRAILER = {
    Name = "Articulated Trailer 2 (with kasha)",
    Model = "models/octocar/industrial/artict2.mdl",
    Category = "GTA SA Trailers",
    SpawnOffset = Vector(0,0,40),
    SpawnAngleOffset = 90,

    Members = {
        Mass = 6666,

        OnSpawn = function(ent)
            if ent:SimfIsTrailer() != nil then
                ent:SetActive( true )
                ent:SetSimfIsTrailer(true)
                ent:SetTrailerCenterposition(Vector(220.877,0,-14.2606))
                ent:SetCenterposition(Vector(0,0,0))
            else
                print("INSTALL TRAILERS BASE FIRST")
            end
        end,
        OnTick = function(ent)
            if ent:SimfIsTrailer() != nil then
                ent:Lock() -- locks trailer
                if not ent:GetIsBraking() then
                    ent.ForceTransmission = 1
                    if ent:GetNWBool("zadnyaya_gear", false) then
                        ent.PressedKeys["joystick_throttle"] = 0 -- makes thottle to 0 when reverse, for remove handbrake
                        ent.PressedKeys["joystick_brake"] = 1 -- makes brake to 1, for turn on reverse
                    else
                        ent.PressedKeys["joystick_throttle"] = 1 -- makes thottle to 1, for remove handbrake
                        ent.PressedKeys["joystick_brake"] = 0 -- makes brake to 0, for turn off reverse
                    end
                end
            else
                print("INSTALL TRAILERS BASE FIRST")
            end
        end,

        LightsTable = "gta_sa_artict1",

        BulletProofTires = false,

        CustomSteerAngle = 0,

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/industrial/linerun_r_wheel.mdl",
		CustomWheelPosFL = Vector(-98.33184,-36.44172,-42),
		CustomWheelPosFR = Vector(-98.33184, 36.44172,-42),
		CustomWheelPosRL = Vector(-51.78024,-36.44172,-42),
		CustomWheelPosRR = Vector(-51.78024, 36.44172,-42),
		CustomWheelAngleOffset = Angle(0,90,0),

        CustomMassCenter = Vector(50,0,10),

        SeatOffset = Vector(0,0,0),
        SeatPitch = 0,
        SeatYaw = -90,

        MaxHealth = 9999999999,
        IsArmored = false,

        EnginePos = Vector(0,0,0),

        StrengthenSuspension = true,

        FrontHeight = 4,
        FrontWheelMass = 150,
        FrontConstant = 50000,
        FrontDamping = 3000,
        FrontRelativeDamping = 2000,

        RearHeight = 4,
        RearWheelMass = 150,
        RearConstant = 50000,
        RearDamping = 3000,
        RearRelativeDamping = 2000,

        FastSteeringAngle = 11,
        SteeringFadeFastSpeed = 535,

        TurnSpeed = 4,

        MaxGrip = 120,
        Efficiency = 0.85,
        GripOffset = 0,
        BrakePower = 0,

        IdleRPM = 0,
        LimitRPM = 0,
        Revlimiter = false,
        PeakTorque = 0,
        PowerbandStart = 0,
        PowerbandEnd = 0,
        Turbocharged = false,
        Supercharged = false,
        Backfire = false,

        FuelFillPos = Vector(0,0,0),
        FuelType = FUELTYPE_NONE,
        FuelTankSize = 0,

        PowerBias = 1,

        EngineSoundPreset = 1,
--
        snd_pitch = 0.5,
        snd_idle = "common/null.wav",

        snd_low = "common/null.wav",
        snd_low_revdown = "common/null.wav",
        snd_low_pitch = 1,

        snd_mid = "common/null.wav",
        snd_mid_gearup = "common/null.wav",
        snd_mid_geardown = "common/null.wav",
        snd_mid_pitch = 2,

        snd_horn = "common/null.wav",

        snd_blowoff = "common/null.wav",
        snd_backfire = "common/null.wav",
--
        DifferentialGear = 0.26666666666667,
        Gears = {-0.2,0,0.1}
    }
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_artict2", TRAILER )

local TRAILER = {
    Name = "Articulated Trailer 2 (empty)",
    Model = "models/octocar/industrial/artict2a.mdl",
    Category = "GTA SA Trailers",
    SpawnOffset = Vector(0,0,40),
    SpawnAngleOffset = 90,

    Members = {
        Mass = 2300,

        OnSpawn = function(ent)
            if ent:SimfIsTrailer() != nil then
                ent:SetActive( true )
                ent:SetSimfIsTrailer(true)
                ent:SetTrailerCenterposition(Vector(220.877,0,-14.2606))
                ent:SetCenterposition(Vector(0,0,0))
            else
                print("INSTALL TRAILERS BASE FIRST")
            end
        end,
        OnTick = function(ent)
            if ent:SimfIsTrailer() != nil then
                ent:Lock() -- locks trailer
                if not ent:GetIsBraking() then
                    ent.ForceTransmission = 1
                    if ent:GetNWBool("zadnyaya_gear", false) then
                        ent.PressedKeys["joystick_throttle"] = 0 -- makes thottle to 0 when reverse, for remove handbrake
                        ent.PressedKeys["joystick_brake"] = 1 -- makes brake to 1, for turn on reverse
                    else
                        ent.PressedKeys["joystick_throttle"] = 1 -- makes thottle to 1, for remove handbrake
                        ent.PressedKeys["joystick_brake"] = 0 -- makes brake to 0, for turn off reverse
                    end
                end
            else
                print("INSTALL TRAILERS BASE FIRST")
            end
        end,

        LightsTable = "gta_sa_artict1",

        BulletProofTires = false,

        CustomSteerAngle = 0,

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/industrial/linerun_r_wheel.mdl",
		CustomWheelPosFL = Vector(-98.33184,-36.44172,-42),
		CustomWheelPosFR = Vector(-98.33184, 36.44172,-42),
		CustomWheelPosRL = Vector(-51.78024,-36.44172,-42),
		CustomWheelPosRR = Vector(-51.78024, 36.44172,-42),
		CustomWheelAngleOffset = Angle(0,90,0),

        CustomMassCenter = Vector(50,0,10),

        SeatOffset = Vector(0,0,0),
        SeatPitch = 0,
        SeatYaw = -90,

        MaxHealth = 9999999999,
        IsArmored = false,

        EnginePos = Vector(0,0,0),

        StrengthenSuspension = true,

        FrontHeight = 4,
        FrontWheelMass = 150,
        FrontConstant = 50000,
        FrontDamping = 3000,
        FrontRelativeDamping = 2000,

        RearHeight = 4,
        RearWheelMass = 150,
        RearConstant = 50000,
        RearDamping = 3000,
        RearRelativeDamping = 2000,

        FastSteeringAngle = 11,
        SteeringFadeFastSpeed = 535,

        TurnSpeed = 4,

        MaxGrip = 120,
        Efficiency = 0.85,
        GripOffset = 0,
        BrakePower = 0,

        IdleRPM = 0,
        LimitRPM = 0,
        Revlimiter = false,
        PeakTorque = 0,
        PowerbandStart = 0,
        PowerbandEnd = 0,
        Turbocharged = false,
        Supercharged = false,
        Backfire = false,

        FuelFillPos = Vector(0,0,0),
        FuelType = FUELTYPE_NONE,
        FuelTankSize = 0,

        PowerBias = 1,

        EngineSoundPreset = 1,
--
        snd_pitch = 0.5,
        snd_idle = "common/null.wav",

        snd_low = "common/null.wav",
        snd_low_revdown = "common/null.wav",
        snd_low_pitch = 1,

        snd_mid = "common/null.wav",
        snd_mid_gearup = "common/null.wav",
        snd_mid_geardown = "common/null.wav",
        snd_mid_pitch = 2,

        snd_horn = "common/null.wav",

        snd_blowoff = "common/null.wav",
        snd_backfire = "common/null.wav",
--
        DifferentialGear = 0.26666666666667,
        Gears = {-0.2,0,0.1}
    }
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_artict2a", TRAILER )

local TRAILER = {
    Name = "Articulated Trailer 3",
    Model = "models/octocar/industrial/artict3.mdl",
    Category = "GTA SA Trailers",
    SpawnOffset = Vector(0,0,40),
    SpawnAngleOffset = 90,

    Members = {
        Mass = 6666,

        OnSpawn = function(ent)
            if ent:SimfIsTrailer() != nil then
                ent:SetActive( true )
                ent:SetSimfIsTrailer(true)
                ent:SetTrailerCenterposition(Vector(220.877,0,-14.2606))
                ent:SetCenterposition(Vector(-103.16232,0,-3.468312))
            else
                print("INSTALL TRAILERS BASE FIRST")
            end
        end,
        OnTick = function(ent)
            if ent:SimfIsTrailer() != nil then
                ent:Lock() -- locks trailer
                if not ent:GetIsBraking() then
                    ent.ForceTransmission = 1
                    if ent:GetNWBool("zadnyaya_gear", false) then
                        ent.PressedKeys["joystick_throttle"] = 0 -- makes thottle to 0 when reverse, for remove handbrake
                        ent.PressedKeys["joystick_brake"] = 1 -- makes brake to 1, for turn on reverse
                    else
                        ent.PressedKeys["joystick_throttle"] = 1 -- makes thottle to 1, for remove handbrake
                        ent.PressedKeys["joystick_brake"] = 0 -- makes brake to 0, for turn off reverse
                    end
                end
            else
                print("INSTALL TRAILERS BASE FIRST")
            end
        end,

        LightsTable = "gta_sa_artict1",

        BulletProofTires = false,

        CustomSteerAngle = 0,

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/industrial/linerun_r_wheel.mdl",
		CustomWheelPosFL = Vector(-98.33184,-36.44172,-42),
		CustomWheelPosFR = Vector(-98.33184, 36.44172,-42),
		CustomWheelPosRL = Vector(-51.78024,-36.44172,-42),
		CustomWheelPosRR = Vector(-51.78024, 36.44172,-42),
		CustomWheelAngleOffset = Angle(0,90,0),

        CustomMassCenter = Vector(50,0,10),

        SeatOffset = Vector(0,0,0),
        SeatPitch = 0,
        SeatYaw = -90,

        MaxHealth = 9999999999,
        IsArmored = false,

        EnginePos = Vector(0,0,0),

        StrengthenSuspension = true,

        FrontHeight = 4,
        FrontWheelMass = 150,
        FrontConstant = 50000,
        FrontDamping = 3000,
        FrontRelativeDamping = 2000,

        RearHeight = 4,
        RearWheelMass = 150,
        RearConstant = 50000,
        RearDamping = 3000,
        RearRelativeDamping = 2000,

        FastSteeringAngle = 11,
        SteeringFadeFastSpeed = 535,

        TurnSpeed = 4,

        MaxGrip = 120,
        Efficiency = 0.85,
        GripOffset = 0,
        BrakePower = 0,

        IdleRPM = 0,
        LimitRPM = 0,
        Revlimiter = false,
        PeakTorque = 0,
        PowerbandStart = 0,
        PowerbandEnd = 0,
        Turbocharged = false,
        Supercharged = false,
        Backfire = false,

        FuelFillPos = Vector(0,0,0),
        FuelType = FUELTYPE_NONE,
        FuelTankSize = 0,

        PowerBias = 1,

        EngineSoundPreset = 1,
--
        snd_pitch = 0.5,
        snd_idle = "common/null.wav",

        snd_low = "common/null.wav",
        snd_low_revdown = "common/null.wav",
        snd_low_pitch = 1,

        snd_mid = "common/null.wav",
        snd_mid_gearup = "common/null.wav",
        snd_mid_geardown = "common/null.wav",
        snd_mid_pitch = 2,

        snd_horn = "common/null.wav",

        snd_blowoff = "common/null.wav",
        snd_backfire = "common/null.wav",
--
        DifferentialGear = 0.26666666666667,
        Gears = {-0.2,0,0.1}
    }
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_artict3", TRAILER )

local light_table = {
	L_RearLampPos = Vector(-147.64004, 30.206448,-26.475696),
	L_RearLampAng = Angle(0,0,0),

	R_RearLampPos = Vector(-147.64004,-30.206448,-26.475696),
	R_RearLampAng = Angle(0,0,0),
	Rearlight_sprites = {
		{pos = Vector(-157.64004, 30.206448,-26.475696),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-157.64004,-30.206448,-26.475696),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
	},
	ems_sprites = {
		{pos = Vector(-157.64004, 30.206448,-26.475696),size = 35,Colors = {Color(255,0,0,255),Color(255,0,0,255)},Speed = 0.04,},
		{pos = Vector(-157.64004,-30.206448,-26.475696),size = 35,Colors = {Color(255,0,0,255),Color(255,0,0,255)},Speed = 0.04,},
		{pos = Vector(-157.64004, 37.72836,-26.475696),size = 35,Colors = {Color(255,0,0,255),Color(255,0,0,255)},Speed = 0.04,},
		{pos = Vector(-157.64004,-37.72836,-26.475696),size = 35,Colors = {Color(255,0,0,255),Color(255,0,0,255)},Speed = 0.04,},
	},
	Reverselight_sprites = {
		{pos = Vector(-157.64004, 37.72836,-26.475696),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-157.64004,-37.72836,-26.475696),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	Turnsignal_sprites = {
		Left = {
			{pos = Vector(-157.64004, 37.72836,-26.475696),size = 25},
		},
		Right = {
			{pos = Vector(-157.64004,-37.72836,-26.475696),size = 25},
		},
	},
}
list.Set( "simfphys_lights", "gta_sa_petrotr", light_table)

local TRAILER = {
    Name = "Tanker Trailer",
    Model = "models/octocar/industrial/petrotr.mdl",
    Category = "GTA SA Trailers",
    SpawnOffset = Vector(0,0,70),
    SpawnAngleOffset = 90,

    Members = {
        Mass = 8000,

        OnSpawn = function(ent)
            if ent:SimfIsTrailer() != nil then
                ent:SetActive( true )
                ent:SetSimfIsTrailer(true)
                ent:SetTrailerCenterposition(Vector(245.44044,0,-24.655356))
                ent:SetCenterposition(Vector(6,6,6))
            else
                print("INSTALL TRAILERS BASE FIRST")
            end
        end,
        OnTick = function(ent)
            if ent:SimfIsTrailer() != nil then
                ent:Lock() -- locks trailer
                if not ent:GetIsBraking() then
                    ent.ForceTransmission = 1
                    if ent:GetNWBool("zadnyaya_gear", false) then
                        ent.PressedKeys["joystick_throttle"] = 0 -- makes thottle to 0 when reverse, for remove handbrake
                        ent.PressedKeys["joystick_brake"] = 1 -- makes brake to 1, for turn on reverse
                    else
                        ent.PressedKeys["joystick_throttle"] = 1 -- makes thottle to 1, for remove handbrake
                        ent.PressedKeys["joystick_brake"] = 0 -- makes brake to 0, for turn off reverse
                    end
                end
            else
                print("INSTALL TRAILERS BASE FIRST")
            end
        end,

        LightsTable = "gta_sa_petrotr",

        BulletProofTires = false,

        CustomSteerAngle = 0,

		CustomWheels = true,
		CustomSuspensionTravel = 1,

		CustomWheelModel = "models/octocar/industrial/linerun_r_wheel.mdl",
		CustomWheelPosFL = Vector(-95.0526, 40.79556,-52.17804),
		CustomWheelPosFR = Vector(-95.0526,-40.79556,-52.17804),
		CustomWheelPosRL = Vector(-136.09188, 40.79556,-52.17804),
		CustomWheelPosRR = Vector(-136.09188,-40.79556,-52.17804),
		CustomWheelAngleOffset = Angle(0,90,0),

        CustomMassCenter = Vector(50,0,10),

        SeatOffset = Vector(0,0,0),
        SeatPitch = 0,
        SeatYaw = -90,

        MaxHealth = 9999999999,
        IsArmored = false,

        EnginePos = Vector(0,0,0),

        StrengthenSuspension = true,

        FrontHeight = 4,
        FrontWheelMass = 300,
        FrontConstant = 50000,
        FrontDamping = 3000,
        FrontRelativeDamping = 2000,

        RearHeight = 4,
        RearWheelMass = 300,
        RearConstant = 50000,
        RearDamping = 3000,
        RearRelativeDamping = 2000,

        FastSteeringAngle = 11,
        SteeringFadeFastSpeed = 535,

        TurnSpeed = 4,

        MaxGrip = 120,
        Efficiency = 0.85,
        GripOffset = 0,
        BrakePower = 0,

        IdleRPM = 0,
        LimitRPM = 0,
        Revlimiter = false,
        PeakTorque = 0,
        PowerbandStart = 0,
        PowerbandEnd = 0,
        Turbocharged = false,
        Supercharged = false,
        Backfire = false,

        FuelFillPos = Vector(0,0,0),
        FuelType = FUELTYPE_NONE,
        FuelTankSize = 0,

        PowerBias = 1,

        EngineSoundPreset = 1,
--
        snd_pitch = 0.5,
        snd_idle = "common/null.wav",

        snd_low = "common/null.wav",
        snd_low_revdown = "common/null.wav",
        snd_low_pitch = 1,

        snd_mid = "common/null.wav",
        snd_mid_gearup = "common/null.wav",
        snd_mid_geardown = "common/null.wav",
        snd_mid_pitch = 2,

        snd_horn = "common/null.wav",

        snd_blowoff = "common/null.wav",
        snd_backfire = "common/null.wav",
--
        DifferentialGear = 0.26666666666667,
        Gears = {-0.2,0,0.1}
    }
}
list.Set( "simfphys_vehicles", "simfphys_gta_sa_petrotr", TRAILER )