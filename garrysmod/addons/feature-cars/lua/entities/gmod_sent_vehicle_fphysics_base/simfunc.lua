function ENT:ToggleHandbrake()
	self.k_togglehandbrake = not self.k_togglehandbrake
end

function ENT:WheelOnGround()
	self.FrontWheelPowered = self:GetPowerDistribution() ~= 1
	self.RearWheelPowered = self:GetPowerDistribution() ~= -1

	local dir = -self.Up
	local lenMul = math.Clamp(-self.Vel.z / 50,2.5,6)
	for i = 1, #self.Wheels do
		local Wheel = self.Wheels[i]
		if IsValid(Wheel) then
			local dmgMul = Wheel:GetDamaged() and 0.5 or 1
			local surfacemul = simfphys.TractionData[Wheel:GetSurfaceMaterial():lower()]

			self.VehicleData[ "SurfaceMul_" .. i ] = (surfacemul and math.max(surfacemul,0.001) or 1) * dmgMul

			local WheelPos = self:LogicWheelPos( i )

			local WheelRadius = WheelPos.IsFrontWheel and self.FrontWheelRadius or self.RearWheelRadius
			local startpos = Wheel:GetPos()
			local len = WheelRadius + lenMul
			local HullSize = Vector(WheelRadius,WheelRadius,0)
			local tr = util.TraceHull( {
				start = startpos,
				endpos = startpos + dir * len,
				maxs = HullSize,
				mins = -HullSize,
				filter = self.VehicleData["filter"]
			} )

			if tr.Hit then
				self.VehicleData[ "onGround_" .. i ] = 1
				Wheel:SetSpeed( Wheel.FX )
				Wheel:SetSkidSound( Wheel.skid )
				Wheel:SetSurfaceMaterial( util.GetSurfacePropName( tr.SurfaceProps ) )
				Wheel:SetOnGround(1)
			else
				self.VehicleData[ "onGround_" .. i ] = 0
				Wheel:SetOnGround(0)
			end
		end
	end

	local FrontOnGround = math.max(self.VehicleData[ "onGround_1" ],self.VehicleData[ "onGround_2" ])
	local RearOnGround = math.max(self.VehicleData[ "onGround_3" ],self.VehicleData[ "onGround_4" ],self.VehicleData[ "onGround_5" ],self.VehicleData[ "onGround_6" ])

	self.DriveWheelsOnGround = math.max(self.FrontWheelPowered and FrontOnGround or 0,self.RearWheelPowered and RearOnGround or 0)
end

function ENT:SimulateEngine(IdleRPM,LimitRPM,Powerbandstart,Powerbandend,c_time)
	local PObj = self:GetPhysicsObject()

	local IsRunning = self:EngineActive()
	local Throttle = self:GetThrottle()

	-- if not self:IsDriveWheelsOnGround() then
	-- 	self.Clutch = 1
	-- end

	if self.Gears[self.CurrentGear] == 0 then
		self.GearRatio = 1
		self.Clutch = 1
		-- self.HandBrake = self.HandBrake + (self.HandBrakePower - self.HandBrake) * 0.2
	else
		self.GearRatio = self.Gears[self.CurrentGear] * self:GetDiffGear()
	end

	self:SetClutch( self.Clutch )
	local InvClutch = 1 - self.Clutch

	local GearedRPM = self.WheelRPM / math.abs(self.GearRatio)

	local MaxTorque = self:GetMaxTorque()

	local DesRPM = Lerp(InvClutch, math.max(IdleRPM + (LimitRPM - IdleRPM) * Throttle,0), GearedRPM )

	local TurboCharged = self:GetTurboCharged()
	local SuperCharged = self:GetSuperCharged()
	local boost = (TurboCharged and self:SimulateTurbo(Powerbandend) or 0) * 0.4 + (SuperCharged and self:SimulateBlower(Powerbandend) or 0)

	if self:GetCurHealth() <= self:GetMaxHealth() * 0.4 then
		MaxTorque = MaxTorque * (self:GetCurHealth() / (self:GetMaxHealth() * 0.4))
	end

	self.EngineRPM = self:EngineActive() and (math.Clamp(self.EngineRPM + math.Clamp(DesRPM - self.EngineRPM,-math.max(self.EngineRPM / 15, 1 ),math.max(-self.RpmDiff / 1.5 * InvClutch + (self.Torque * 5) / 0.15 * self.Clutch, 1)) + self.RPM_DIFFERENCE * Throttle,0,LimitRPM)) or 0
	self.Torque = (Throttle + boost) * math.max(MaxTorque * math.min(self.EngineRPM / Powerbandstart, (LimitRPM - self.EngineRPM) / (LimitRPM - Powerbandend),1), 0)
	self:SetFlyWheelRPM( math.min(self.EngineRPM + self.exprpmdiff * 2 * InvClutch,LimitRPM) )

	self.RpmDiff = self.EngineRPM - GearedRPM

	local signGearRatio = ((self.GearRatio > 0) and 1 or 0) + ((self.GearRatio < 0) and -1 or 0)
	local signThrottle = (Throttle > 0) and 1 or 0
	local signSpeed = ((self.ForwardSpeed > 0) and 1 or 0) + ((self.ForwardSpeed < 0) and -1 or 0)

	local TorqueDiff = (self.RpmDiff / LimitRPM) * 0.15 * self.Torque
	local EngineBrake = (signThrottle == 0) and self.EngineRPM * (self.EngineRPM / LimitRPM) ^ 2 / 300 * signSpeed or 0

	local GearedPower = ((self.ThrottleDelay <= c_time and (self.Torque + TorqueDiff) * signThrottle * signGearRatio or 0) - EngineBrake) / math.abs(self.GearRatio) / 50

	self.EngineTorque = IsRunning and GearedPower * InvClutch or 0

	if not self:GetDoNotStall() and IsRunning and self.EngineRPM <= IdleRPM * 0.2 then
		-- self.CurrentGear = 2
		self:StallAndRestart()
	end

	if IsRunning then
		local FuelUse = (Throttle * 0.6 + 0.4) * ((self.EngineRPM / LimitRPM) * MaxTorque * 20 + self.Torque * 10) / 5000000
		local Fuel = self:GetFuel()
		self:SetFuel( Fuel - FuelUse * 5 )
		self.UsedFuel = self.UsedFuel and (self.UsedFuel + FuelUse) or 0

		if Fuel <= 0 then
			self:StopEngine()
		end
	else
		self.UsedFuel = 0
	end

	if CurTime() >= (self.CheckUse or 0) then
		self.CheckUse = CurTime() + 1
		local newFuelUse = self.UsedFuel * 60
		if self:GetFuelUse() ~= newFuelUse then
			self:SetFuelUse(newFuelUse)
		end
		self.UsedFuel = 0
	end

	if CurTime() >= (self.nextFuelUpdate or 0) and self:GetNetVar("Fuel") ~= self.curFuel then
		self:SetNetVar("Fuel", math.Clamp(self.curFuel, 0, self:GetMaxFuel()))
		self.nextFuelUpdate = CurTime() + 10
	end

	local ReactionForce = (self.EngineTorque * 2 - math.Clamp(self.ForwardSpeed,-self.Brake,self.Brake)) * self.DriveWheelsOnGround
	local BaseMassCenter = PObj:GetMassCenter()
	local dt_mul = math.max( math.min(self:GetPowerDistribution() + 0.5,1),0)

	PObj:ApplyForceOffset( -self.Forward * self.Mass * ReactionForce, BaseMassCenter + self.Up * dt_mul )
	PObj:ApplyForceOffset( self.Forward * self.Mass * ReactionForce, BaseMassCenter - self.Up * dt_mul )
end

function ENT:SimulateTransmission(k_throttle,k_brake,k_fullthrottle,k_clutch,k_handbrake,k_gearup,k_geardown,IdleRPM,Powerbandstart,Powerbandend,cruisecontrol,curtime)

	local GearsCount = table.Count( self.Gears )
	local cruiseThrottle = math.min( math.max(self.cc_speed - math.abs(self.ForwardSpeed),0) / 10 ^ 2, 1)

	if isnumber(self.ForceTransmission) then
		isauto = self.ForceTransmission <= 1
	end

	self.Brake = self:GetBrakePower() * math.max( k_brake, self.PressedKeys["joystick_brake"] )
	self.HandBrake = self.HandBrakePower * (self.k_togglehandbrake and 1 or k_handbrake)
	self.Clutch = math.max( k_clutch, k_handbrake, self.PressedKeys["joystick_clutch"] )

	local AutoThrottle = self:EngineActive() and ((self.EngineRPM < IdleRPM) and (IdleRPM - self.EngineRPM) / IdleRPM or 0) / 4 or 0
	self.InputThrottle = math.max( (0.5 + 0.5 * k_fullthrottle) * k_throttle, self.PressedKeys["joystick_throttle"] )
	local Throttle = self.InputThrottle + AutoThrottle
	self:SetThrottle(Throttle)

	if k_gearup ~= self.GearUpPressed then
		self.GearUpPressed = k_gearup

		if k_gearup == 1 and k_clutch == 1 then
			if self.CurrentGear ~= GearsCount then
				self.ThrottleDelay = curtime + 0.4 - 0.4 * k_clutch
			end

			local newGear = math.Clamp(self.CurrentGear + 1,1,GearsCount)
			if newGear ~= self.CurrentGear then
				local ply = self:GetDriver()
				if IsValid(ply) then
					ply:EmitSound('car/changegear.wav', 55, 100, 1)
					netstream.StartPVS(ply:GetPos(), 'simfphys.anim', ply, 'gear')
				end
				self.CurrentGear = newGear
			end
		end
	end

	if k_geardown ~= self.GearDownPressed then
		self.GearDownPressed = k_geardown

		if k_geardown == 1 and k_clutch == 1 then
			if self.CurrentGear == 1 then
				self.ThrottleDelay = curtime + 0.25
			end

			local newGear = math.Clamp(self.CurrentGear - 1,1,GearsCount)
			if newGear ~= self.CurrentGear then
				local ply = self:GetDriver()
				if IsValid(ply) then
					ply:EmitSound('car/changegear.wav', 55, 100, 1)
					netstream.StartPVS(ply:GetPos(), 'simfphys.anim', ply, 'gear')
				end
				self.CurrentGear = newGear
			end
		end
	end

	self:SetIsBraking( self.Brake > 0 )
	self:SetGear( self.CurrentGear )
	self:SetHandBrakeEnabled( self.HandBrake > 0 )

end

function ENT:GetTransformedDirection()
	local SteerAngForward = self.Forward:Angle()
	local SteerAngRight = self.Right:Angle()
	local SteerAngForward2 = self.Forward:Angle()
	local SteerAngRight2 = self.Right:Angle()

	SteerAngForward:RotateAroundAxis(-self.Up, self.VehicleData[ "Steer" ])
	SteerAngRight:RotateAroundAxis(-self.Up, self.VehicleData[ "Steer" ])
	SteerAngForward2:RotateAroundAxis(-self.Up, -self.VehicleData[ "Steer" ])
	SteerAngRight2:RotateAroundAxis(-self.Up, -self.VehicleData[ "Steer" ])

	local SteerForward = SteerAngForward:Forward()
	local SteerRight = SteerAngRight:Forward()
	local SteerForward2 = SteerAngForward2:Forward()
	local SteerRight2 = SteerAngRight2:Forward()

	return {Forward = SteerForward,Right = SteerRight,Forward2 = SteerForward2, Right2 = SteerRight2}
end

function ENT:LogicWheelPos( index )
	local IsFront = index == 1 or index == 2
	local IsRight = index == 2 or index == 4 or index == 6

	return {IsFrontWheel = IsFront, IsRightWheel = IsRight}
end

function ENT:SimulateWheels(k_clutch,LimitRPM)
	local Steer = self:GetTransformedDirection()

	local MaxGrip = self:GetMaxTraction()
	local GripOffset = self:GetTractionBias() * MaxGrip
	local Efficiency = self:GetEfficiency()

	for i = 1, table.Count( self.Wheels ) do
		local Wheel = self.Wheels[i]

		if IsValid( Wheel ) then
			local WheelPos = self:LogicWheelPos( i )
			local WheelRadius = WheelPos.IsFrontWheel and self.FrontWheelRadius or self.RearWheelRadius
			local WheelDiameter = WheelRadius * 2
			local SurfaceMultiplicator = self.VehicleData[ "SurfaceMul_" .. i ]
			local MaxTraction = ((WheelPos.IsFrontWheel and (MaxGrip + GripOffset) or (MaxGrip - GripOffset)) * SurfaceMultiplicator) * 1.5

			local IsPoweredWheel = (WheelPos.IsFrontWheel and self.FrontWheelPowered or not WheelPos.IsFrontWheel and self.RearWheelPowered) and 1 or 0

			local OnGround = self.VehicleData[ "onGround_" .. i ]

			local Forward = WheelPos.IsFrontWheel and Steer.Forward or self.Forward
			local Right = WheelPos.IsFrontWheel and Steer.Right or self.Right

			if self.CustomWheels then
				if WheelPos.IsFrontWheel then
					Forward = IsValid(self.SteerMaster) and Steer.Forward or self.Forward
					Right = IsValid(self.SteerMaster) and Steer.Right or self.Right
				else
					if IsValid( self.SteerMaster2 ) then
						Forward = Steer.Forward2
						Right = Steer.Right2
					end
				end
			end

			local Velocity = Wheel:GetVelocity()
			local VelocityLength = Velocity:Length()
			local VelForward = Velocity:GetNormalized()
			local Stopped = VelocityLength == 0

			local AngY = Stopped and 0 or math.acos( math.Clamp( Forward:Dot(VelForward) ,-1,1) )
			local AngX = Stopped and 0 or math.asin( math.Clamp( Right:Dot(VelForward) ,-1,1) )
			local VelY = Stopped and 0 or math.cos(AngY) * VelocityLength
			local VelX = Stopped and 0 or math.sin(AngX) * VelocityLength
			local absFy = math.abs(VelX)
			local absFx = math.abs(VelY)

			local PowerBiasMul = WheelPos.IsFrontWheel and (1 - self:GetPowerDistribution()) * 0.5 or (1 + self:GetPowerDistribution()) * 0.5

			local LockWheel = not WheelPos.IsFrontWheel and self.HandBrake > 0
			local ForwardForce = LockWheel and 0 or (self.EngineTorque * PowerBiasMul * IsPoweredWheel * 2.5)
			if (self.PowerBoost and (ForwardForce > 0 and VelY < 175 or ForwardForce < 0 and VelY > -175)) then ForwardForce = ForwardForce * self.PowerBoost end

			local TractionCycle = Vector(math.min(absFy,MaxTraction),ForwardForce,0):Length()
			local GripLoss = LockWheel and absFx > 30 and MaxTraction or math.max(TractionCycle - MaxTraction,0)
			local GripRemaining = math.max(MaxTraction - GripLoss,math.min(absFy / 25,MaxTraction / 2))

			local signForwardForce = ((ForwardForce > 0) and 1 or 0) + ((ForwardForce < 0) and -1 or 0)
			local signEngineTorque = ((self.EngineTorque > 0) and 1 or 0) + ((self.EngineTorque < 0) and -1 or 0)
			local brake = math.max(self.Brake, self.HandBrake)
			local BrakeForce = math.Clamp(-VelY,-brake,brake) * SurfaceMultiplicator

			local Power = ForwardForce * Efficiency - GripLoss * signForwardForce + BrakeForce
			local Force = -Right * math.Clamp(VelX,-GripRemaining,GripRemaining) + Forward * Power

			local wRad = Wheel:GetDamaged() and Wheel.dRadius or WheelRadius
			local TurnWheel = LockWheel and 0 or (((VelY * OnGround + GripLoss * 35 * signEngineTorque * IsPoweredWheel) / wRad * 1.85) + self.EngineRPM / 80 * (1 - OnGround) * IsPoweredWheel * (1 - k_clutch)) * 1.6

			Wheel.FX = VelY
			Wheel.skid = LockWheel and (VelocityLength / 500) or (GripLoss / MaxTraction)

			local RPM = LockWheel and 0 or (absFx / (3.14 * WheelDiameter)) * 52 * OnGround
			local GripLossFaktor = math.Clamp(GripLoss,0,MaxTraction) / MaxTraction

			self.VehicleData[ "WheelRPM_".. i ] = RPM
			self.VehicleData[ "GripLossFaktor_".. i ] = GripLossFaktor
			self.VehicleData[ "Exp_GLF_".. i ] = GripLossFaktor ^ 2
			Wheel:SetGripLoss( GripLossFaktor )

			if WheelPos.IsFrontWheel then
				self.VehicleData[ "spin_" .. i ] = self.VehicleData[ "spin_" .. i ] + TurnWheel
			else
				if self.HandBrake < MaxTraction then
					self.VehicleData[ "spin_" .. i ] = self.VehicleData[ "spin_" .. i ] + TurnWheel
				end
			end

			if self.CustomWheels then
				local GhostEnt = self.GhostWheels[i]
				local ang = GhostEnt:GetAngles()
				local axle = Wheel:LocalToWorldAngles(Angle(0, 0, (WheelPos.IsRightWheel and 1 or -1) * (self.camber or 0))):Right()
				ang:RotateAroundAxis(axle, -TurnWheel)

				self.GhostWheels[i]:SetAngles( ang )
			else
				self:SetPoseParameter(self.VehicleData[ "pp_spin_" .. i ],self.VehicleData[ "spin_" .. i ])
			end

			if not self.PhysicsEnabled then
				Wheel:GetPhysicsObject():ApplyForceCenter( Force * 185 * OnGround )
			end
		end
	end

	local target_diff = math.max(LimitRPM * 0.95 - self.EngineRPM,0)

	if self.FrontWheelPowered and self.RearWheelPowered then
		self.WheelRPM = math.max(self.VehicleData[ "WheelRPM_1" ] or 0,self.VehicleData[ "WheelRPM_2" ] or 0,self.VehicleData[ "WheelRPM_3" ] or 0,self.VehicleData[ "WheelRPM_4" ] or 0)
		self.RPM_DIFFERENCE = target_diff * math.max(self.VehicleData[ "GripLossFaktor_1" ] or 0,self.VehicleData[ "GripLossFaktor_2" ] or 0,self.VehicleData[ "GripLossFaktor_3" ] or 0,self.VehicleData[ "GripLossFaktor_4" ] or 0)
		self.exprpmdiff = target_diff * math.max(self.VehicleData[ "Exp_GLF_1" ] or 0,self.VehicleData[ "Exp_GLF_2" ] or 0,self.VehicleData[ "Exp_GLF_3" ] or 0,self.VehicleData[ "Exp_GLF_4" ] or 0)
	elseif not self.FrontWheelPowered and self.RearWheelPowered then
		self.WheelRPM = math.max(self.VehicleData[ "WheelRPM_3" ] or 0,self.VehicleData[ "WheelRPM_4" ] or 0)
		self.RPM_DIFFERENCE = target_diff * math.max(self.VehicleData[ "GripLossFaktor_3" ] or 0,self.VehicleData[ "GripLossFaktor_4" ] or 0)
		self.exprpmdiff = target_diff * math.max(self.VehicleData[ "Exp_GLF_3" ] or 0,self.VehicleData[ "Exp_GLF_4" ] or 0)
	elseif self.FrontWheelPowered and not self.RearWheelPowered then
		self.WheelRPM = math.max(self.VehicleData[ "WheelRPM_1" ] or 0,self.VehicleData[ "WheelRPM_2" ] or 0)
		self.RPM_DIFFERENCE = target_diff * math.max(self.VehicleData[ "GripLossFaktor_1" ] or 0,self.VehicleData[ "GripLossFaktor_2" ] or 0)
		self.exprpmdiff = target_diff * math.max(self.VehicleData[ "Exp_GLF_1" ] or 0,self.VehicleData[ "Exp_GLF_2" ] or 0)
	else
		self.WheelRPM = 0
		self.RPM_DIFFERENCE = 0
		self.exprpmdiff = 0
	end
end

function ENT:SimulateTurbo(LimitRPM)
	if not self.Turbo then return end

	local Throttle = self:GetThrottle()

	self.SmoothTurbo = self.SmoothTurbo + math.Clamp(math.min(self.EngineRPM / LimitRPM,1) * 600 * (0.75 + 0.25 * Throttle) - self.SmoothTurbo,-15,15)

	local Volume = math.Clamp( ((self.SmoothTurbo - 300) / 150) ,0, 1) * 0.5
	local Pitch = math.Clamp( self.SmoothTurbo / 7 , 0 , 255)

	local boost = math.Clamp( -0.25 + (self.SmoothTurbo / 500) ^ 5,0,1)

	self.Turbo:ChangeVolume( Volume )
	self.Turbo:ChangePitch( Pitch )

	return boost
end

function ENT:SimulateBlower(LimitRPM)
	if not self.Blower or not self.BlowerWhine then return end

	local Throttle = self:GetThrottle()

	self.SmoothBlower = self.SmoothBlower + math.Clamp(math.min(self.EngineRPM / LimitRPM,1) * 500 - self.SmoothBlower,-20,20)

	local Volume1 = math.Clamp( self.SmoothBlower / 400 * (1 - 0.4 * Throttle) ,0, 1)
	local Volume2 = math.Clamp( self.SmoothBlower / 400 * (0.10 + 0.4 * Throttle) ,0, 1)

	local Pitch1 = 50 + math.Clamp( self.SmoothBlower / 4.5 , 0 , 205)
	local Pitch2 = Pitch1 * 1.2

	local boost = math.Clamp( (self.SmoothBlower / 600) ^ 4 ,0,1)

	self.Blower:ChangeVolume( Volume1 )
	self.Blower:ChangePitch( Pitch1 )

	self.BlowerWhine:ChangeVolume( Volume2 )
	self.BlowerWhine:ChangePitch( Pitch2 )

	return boost
end
