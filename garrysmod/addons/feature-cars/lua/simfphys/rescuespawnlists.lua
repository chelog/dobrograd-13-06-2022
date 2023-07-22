local mylist = list.Get( "Vehicles" )
for listname, _ in pairs( mylist ) do
	if mylist[listname].Class == "gmod_sent_vehicle_fphysics_base" then
		local V = { 
			Name = "blank",
			Model = "error.mdl",
			Category = "Added by rescue script",
			SpawnOffset = Vector(0,0,0),
			
			Members = { 
			}
		}
		
		V.Name = mylist[listname].Name
		V.Model = mylist[listname].Model
		V.Category = "(restored) "..mylist[listname].Category
		
		V.SpawnOffset = mylist[listname].Members.SpawnOffset or Vector(0,0,0)
		if mylist[listname].Members.Mass then V.Members.Mass = mylist[listname].Members.Mass end
		if mylist[listname].Members.LightsTable then V.Members.LightsTable = mylist[listname].Members.LightsTable end
		
		if mylist[listname].Members.MaxHealth then  V.Members.MaxHealth = mylist[listname].Members.MaxHealth end
		if mylist[listname].Members.AirFriction then  V.Members.AirFriction = mylist[listname].Members.AirFriction end
		
		if mylist[listname].Members.FrontWheelRadius then V.Members.FrontWheelRadius = mylist[listname].Members.FrontWheelRadius end
		if mylist[listname].Members.RearWheelRadius then V.Members.RearWheelRadius = mylist[listname].Members.RearWheelRadius  end
		if mylist[listname].Members.CustomWheels then V.Members.CustomWheels = mylist[listname].Members.CustomWheels end
		if mylist[listname].Members.CustomSuspensionTravel then V.Members.CustomSuspensionTravel = mylist[listname].Members.CustomSuspensionTravel end
		if mylist[listname].Members.CustomWheelModel then V.Members.CustomWheelModel = mylist[listname].Members.CustomWheelModel end
		if mylist[listname].Members.CustomWheelModel_R then 
			V.Members.CustomWheelModel_R = mylist[listname].Members.CustomWheelModel_R
		else 
			if mylist[listname].Members.CustomWheelModel then
				V.Members.CustomWheelModel_R = mylist[listname].Members.CustomWheelModel
			end
		end
		if mylist[listname].Members.CustomWheelPosFL then V.Members.CustomWheelPosFL = mylist[listname].Members.CustomWheelPosFL end
		if mylist[listname].Members.CustomWheelPosFR then V.Members.CustomWheelPosFR = mylist[listname].Members.CustomWheelPosFR end
		if mylist[listname].Members.CustomWheelPosRL then V.Members.CustomWheelPosRL = mylist[listname].Members.CustomWheelPosRL end
		if mylist[listname].Members.CustomWheelPosRR then V.Members.CustomWheelPosRR = mylist[listname].Members.CustomWheelPosRR end
		if mylist[listname].Members.CustomWheelAngleOffset then V.Members.CustomWheelAngleOffset = mylist[listname].Members.CustomWheelAngleOffset end
		if mylist[listname].Members.CustomMassCenter then V.Members.CustomMassCenter = mylist[listname].Members.CustomMassCenter end
		if mylist[listname].Members.CustomSteerAngle then V.Members.CustomSteerAngle = mylist[listname].Members.CustomSteerAngle end
		if mylist[listname].Members.CustomMassCenter then V.Members.CustomMassCenter = mylist[listname].Members.CustomMassCenter end
		V.Members.SeatOffset = mylist[listname].Members.SeatOffset
		V.Members.SeatPitch = mylist[listname].Members.SeatPitch
		if mylist[listname].Members.SeatYaw then V.Members.SeatYaw = mylist[listname].Members.SeatYaw end
		if mylist[listname].Members.SpeedoMax then V.Members.SpeedoMax = mylist[listname].Members.SpeedoMax end
		if mylist[listname].Members.PassengerSeats then V.Members.PassengerSeats = mylist[listname].Members.PassengerSeats end
		if mylist[listname].Members.ModelInfo then V.Members.ModelInfo = mylist[listname].Members.ModelInfo end
		if mylist[listname].Members.ExhaustPositions then V.Members.ExhaustPositions = mylist[listname].Members.ExhaustPositions end
		if mylist[listname].Members.Attachments then V.Members.Attachments = mylist[listname].Members.Attachments end
		if mylist[listname].Members.StrengthenSuspension then V.Members.StrengthenSuspension = mylist[listname].Members.StrengthenSuspension end
		V.Members.FrontHeight = mylist[listname].Members.FrontHeight
		V.Members.FrontConstant = mylist[listname].Members.FrontConstant
		V.Members.FrontDamping = mylist[listname].Members.FrontDamping
		V.Members.FrontRelativeDamping = mylist[listname].Members.FrontRelativeDamping
		V.Members.RearHeight = mylist[listname].Members.RearHeight
		V.Members.RearConstant = mylist[listname].Members.RearConstant
		V.Members.RearDamping = mylist[listname].Members.RearDamping
		V.Members.RearRelativeDamping = mylist[listname].Members.RearRelativeDamping
		V.Members.FastSteeringAngle = mylist[listname].Members.FastSteeringAngle
		V.Members.SteeringFadeFastSpeed = mylist[listname].Members.SteeringFadeFastSpeed
		V.Members.TurnSpeed = mylist[listname].Members.TurnSpeed
		V.Members.MaxGrip = mylist[listname].Members.MaxGrip
		V.Members.Efficiency = mylist[listname].Members.Efficiency
		V.Members.GripOffset = mylist[listname].Members.GripOffset
		V.Members.BrakePower = mylist[listname].Members.BrakePower
		V.Members.IdleRPM = mylist[listname].Members.IdleRPM
		V.Members.LimitRPM = mylist[listname].Members.LimitRPM
		if mylist[listname].Members.Revlimiter then V.Members.Revlimiter = mylist[listname].Members.Revlimiter end
		V.Members.PeakTorque = mylist[listname].Members.PeakTorque
		V.Members.PowerbandStart = mylist[listname].Members.PowerbandStart
		V.Members.PowerbandEnd = mylist[listname].Members.PowerbandEnd
		if mylist[listname].Members.Turbocharged then V.Members.Turbocharged = mylist[listname].Members.Turbocharged end
		if mylist[listname].Members.snd_blowoff then V.Members.snd_blowoff = mylist[listname].Members.snd_blowoff end
		if mylist[listname].Members.Supercharged then V.Members.Supercharged = mylist[listname].Members.Supercharged end
		V.Members.PowerBias = mylist[listname].Members.PowerBias
		V.Members.EngineSoundPreset = mylist[listname].Members.EngineSoundPreset
		if mylist[listname].Members.snd_pitch then V.Members.snd_pitch = mylist[listname].Members.snd_pitch end
		if mylist[listname].Members.snd_idle then V.Members.snd_idle = mylist[listname].Members.snd_idle end
		if mylist[listname].Members.snd_low then V.Members.snd_low = mylist[listname].Members.snd_low end
		if mylist[listname].Members.snd_low_revdown then V.Members.snd_low_revdown = mylist[listname].Members.snd_low_revdown end
		if mylist[listname].Members.snd_low_pitch then V.Members.snd_low_pitch = mylist[listname].Members.snd_low_pitch end
		if mylist[listname].Members.snd_mid then V.Members.snd_mid = mylist[listname].Members.snd_mid end
		if mylist[listname].Members.snd_mid_gearup then V.Members.snd_mid_gearup = mylist[listname].Members.snd_mid_gearup end
		if mylist[listname].Members.snd_mid_pitch then V.Members.snd_mid_pitch = mylist[listname].Members.snd_mid_pitch end
		if mylist[listname].Members.Sound_Idle then V.Members.Sound_Idle = mylist[listname].Members.Sound_Idle end
		if mylist[listname].Members.Sound_IdlePitch then V.Members.Sound_IdlePitch = mylist[listname].Members.Sound_IdlePitch end
		if mylist[listname].Members.Sound_Mid then V.Members.Sound_Mid =  mylist[listname].Members.Sound_Mid end
		if mylist[listname].Members.Sound_MidPitch then V.Members.Sound_MidPitch = mylist[listname].Members.Sound_MidPitch end
		if mylist[listname].Members.Sound_MidVolume then V.Members.Sound_MidVolume = mylist[listname].Members.Sound_MidVolume end
		if mylist[listname].Members.Sound_MidFadeOutRPMpercent then V.Members.Sound_MidFadeOutRPMpercent = mylist[listname].Members.Sound_MidFadeOutRPMpercent end
		if mylist[listname].Members.Sound_MidFadeOutRate then V.Members.Sound_MidFadeOutRate = mylist[listname].Members.Sound_MidFadeOutRate end
		if mylist[listname].Members.Sound_High then V.Members.Sound_High = mylist[listname].Members.Sound_High end
		if mylist[listname].Members.Sound_HighPitch then V.Members.Sound_HighPitch = mylist[listname].Members.Sound_HighPitch end
		if mylist[listname].Members.Sound_HighVolume then V.Members.Sound_HighVolume = mylist[listname].Members.Sound_HighVolume end
		if mylist[listname].Members.Sound_HighFadeInRPMpercent then V.Members.Sound_HighFadeInRPMpercent = mylist[listname].Members.Sound_HighFadeInRPMpercent end
		if mylist[listname].Members.Sound_HighFadeInRate then V.Members.Sound_HighFadeInRate = mylist[listname].Members.Sound_HighFadeInRate end
		if mylist[listname].Members.Sound_Throttle then V.Members.Sound_Throttle = mylist[listname].Members.Sound_Throttle end
		if mylist[listname].Members.Sound_ThrottlePitch then V.Members.Sound_ThrottlePitch = mylist[listname].Members.Sound_ThrottlePitch end
		if mylist[listname].Members.Sound_ThrottleVolume then V.Members.Sound_ThrottleVolume = mylist[listname].Members.Sound_ThrottleVolume end
		if mylist[listname].Members.snd_horn then V.Members.snd_horn = mylist[listname].Members.snd_horn end
		V.Members.DifferentialGear = mylist[listname].Members.DifferentialGear
		V.Members.Gears = mylist[listname].Members.Gears
		
		list.Set( "simfphys_vehicles", listname, V )
		list.GetForEdit( "Vehicles" )[ listname ] = nil
	end
end