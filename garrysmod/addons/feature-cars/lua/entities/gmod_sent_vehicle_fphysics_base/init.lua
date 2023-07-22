AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_lights.lua" )
include("shared.lua")
include("spawn.lua")
include("simfunc.lua")
include("numpads.lua")

function ENT:OnSpawn()
end

function ENT:OnTick()
end

function ENT:OnDelete()
end

function ENT:OnDestroyed()
end

function ENT:Think()
	local Time = CurTime()

	self:OnTick()

	self.NextTick = self.NextTick or 0
	if self.NextTick <= Time then
		self.NextTick = Time + 0.0625

		if IsValid( self.DriverSeat ) then
			local Driver = self.DriverSeat:GetDriver()
			Driver = IsValid( self.RemoteDriver ) and self.RemoteDriver or Driver

			local OldDriver = self:GetDriver()
			if OldDriver ~= Driver then
				self:SetDriver( Driver )

				local HadDriver = IsValid( OldDriver )
				local HasDriver = IsValid( Driver )

				if HasDriver then
					self:SetActive( true )
					self:SetupControls( Driver )

					-- if Driver:GetInfoNum( "cl_simfphys_autostart", 1 ) > 0 then
					-- 	self:StartEngine()
					-- end

				else
					-- self:UnLock()

					-- if self.ems then
					-- 	self.ems:Stop()
					-- end

					if self.horn then
						self.horn:Stop()
					end

					if self.PressedKeys then
						for k,v in pairs( self.PressedKeys ) do
							if isbool( v ) then
								self.PressedKeys[k] = false
							end
						end
					end

					if self.keys then
						for i = 1, table.Count( self.keys ) do
							numpad.Remove( self.keys[i] )
						end
					end

					if HadDriver then
						if self.k_togglehandbrake and not self:EngineActive() then
							self:SetActive( false )
						end
					-- 	if OldDriver:GetInfoNum( "cl_simfphys_autostart", 1 ) > 0 then
					-- 		self:StopEngine()
					-- 		self:SetActive( false )
					-- 	else
					-- 		self:ResetJoystick()
					--
					-- 		if not self:EngineActive() then
					-- 			self:SetActive( false )
					-- 		end
					-- 	end
					-- else
					-- 	self:SetActive( false )
					-- 	self:StopEngine()
					end
				end
			end
		end

		if self:IsInitialized() then
			self:SetColors()
			self:SimulateVehicle( Time )
			self:ControlLighting( Time )

			-- if istable( WireLib ) then
			-- 	self:UpdateWireOutputs()
			-- end

			self.NextWaterCheck = self.NextWaterCheck or 0
			if self.NextWaterCheck < Time then
				self.NextWaterCheck = Time + 0.2
				self:WaterPhysics()
			end

			if self:GetActive() then
				self:SetPhysics( (math.abs(self.ForwardSpeed) < 50) and (self.Brake > 0 or self.HandBrake > 0) )
			else
				self:SetPhysics( true )
			end
		end
	end

	self:NextThink( Time )

	return true
end

function ENT:ForceGear(desGear)
	self.CurrentGear = math.Clamp(math.Round(desGear, 0), 1, #self.Gears)
	self:SetGear(self.CurrentGear)
end

function ENT:OnActiveChanged( name, old, new)
	if new == old then return end

	if not self:IsInitialized() then return end

	local TurboCharged = self:GetTurboCharged()
	local SuperCharged = self:GetSuperCharged()

	if new == true then

		self.HandBrakePower = self:GetMaxTraction() - self:GetTractionBias() * self:GetMaxTraction()

		-- if self:GetEMSEnabled() then
		-- 	if self.ems then
		-- 		self.ems:Play()
		-- 	end
		-- end

		if TurboCharged then
			self.Turbo = CreateSound(self, self.snd_spool or "simulated_vehicles/turbo_spin.wav")
			self.Turbo:PlayEx(0,0)
		end

		if SuperCharged then
			self.Blower = CreateSound(self, self.snd_bloweroff or "simulated_vehicles/blower_spin.wav")
			self.BlowerWhine = CreateSound(self, self.snd_bloweron or "simulated_vehicles/blower_gearwhine.wav")

			self.Blower:PlayEx(0,0)
			self.BlowerWhine:PlayEx(0,0)
		end
	else
		self:StopEngine()

		if TurboCharged then
			self.Turbo:Stop()
		end

		if SuperCharged then
			self.Blower:Stop()
			self.BlowerWhine:Stop()
		end

		-- self:SetIsBraking( false )
	end

	if istable( self.Wheels ) then
		for i = 1, table.Count( self.Wheels ) do
			local Wheel = self.Wheels[ i ]
			if IsValid(Wheel) then
				Wheel:SetOnGround( 0 )
			end
		end
	end
end

ENT.SendThrottleAnim = octolib.func.debounceStart(function(self)
	local ply = IsValid(self) and self:GetDriver()
	if IsValid(ply) then
		netstream.StartPVS(ply:GetPos(), 'simfphys.anim', ply, 'rfoot', self.InputThrottle)
	end
end, 0.25)

function ENT:OnThrottleChanged( name, old, new)
	if new == old then return end
	self:SendThrottleAnim()

	local Health = self:GetCurHealth()
	local MaxHealth = self:GetMaxHealth()
	local Active = self:EngineActive()

	if new == 1 then
		if Health < MaxHealth * 0.6 then
			if Active then
				if math.Round(math.random(0,4),0) == 1 then
					self:DamagedStall()
				end
			end
		end
	end

	if new == 0 then
		if self:GetTurboCharged() then
			if (self.SmoothTurbo > 350) then
				local Volume = math.Clamp( ((self.SmoothTurbo - 300) / 150) ,0, 1) * 0.5
				self.SmoothTurbo = 0
				self.BlowOff:Stop()
				self.BlowOff = CreateSound(self, self.snd_blowoff or "simulated_vehicles/turbo_blowoff.ogg")
				self.BlowOff:PlayEx(Volume,100)
			end
		end
	end
end

function ENT:WaterPhysics()
	if self:WaterLevel() <= 1 then self.IsInWater = false return end

	if self:GetDoNotStall() then

		self:SetOnFire( false )
		self:SetOnSmoke( false )

		return
	end

	if not self.IsInWater then
		if self:EngineActive() then
			self:EmitSound( "vehicles/jetski/jetski_off.wav" )
		end

		self.IsInWater = true
		self:SetEngineActive(false)
		self.EngineRPM = 0
		self:SetFlyWheelRPM( 0 )

		self:SetOnFire( false )
		self:SetOnSmoke( false )
	end

	local phys = self:GetPhysicsObject()
	phys:ApplyForceCenter( -self:GetVelocity() * 0.5 * phys:GetMass() * 2.5 )
end

function ENT:SetColors()
	if self.ColorableProps then

		local Color = self:GetColor()
		local dot = Color.r * Color.g * Color.b * Color.a

		if dot ~= self.OldColor then

			for i, prop in pairs( self.ColorableProps ) do
				if IsValid(prop) then
					prop:SetColor( Color )
					prop:SetRenderMode( self:GetRenderMode() )
				end
			end

			self.OldColor = dot
		end
	end
end

function ENT:ControlLighting( curtime )
	if (self.NextLightCheck or 0) < curtime and self.LightsActivated ~= self.DoCheck then
		self.DoCheck = self.LightsActivated

		if self.LightsActivated then
			self:SetLightsEnabled(true)
		end
	end
end

function ENT:GetEngineData()
	local LimitRPM = math.max(self:GetLimitRPM(),4)
	local Powerbandend = math.Clamp(self:GetPowerBandEnd(),3,LimitRPM - 1)
	local Powerbandstart = math.Clamp(self:GetPowerBandStart(),2,Powerbandend - 1)
	local IdleRPM = math.Clamp(self:GetIdleRPM(),1,Powerbandstart - 1)
	local Data = {
		IdleRPM = IdleRPM,
		Powerbandstart = Powerbandstart,
		Powerbandend = Powerbandend,
		LimitRPM = LimitRPM,
	}
	return Data
end

local halfpi1, halfpi2 = 180 / math.pi, math.pi / 180
local var1 = 0.0568182 * 0.75
function ENT:SimulateVehicle( curtime )
	local Active = self:GetActive()

	local EngineData = self:GetEngineData()
	local LimitRPM = EngineData.LimitRPM
	local Powerbandend = EngineData.Powerbandend
	local Powerbandstart = EngineData.Powerbandstart
	local IdleRPM = EngineData.IdleRPM

	self.Forward =  self:LocalToWorldAngles( self.VehicleData.LocalAngForward ):Forward()
	self.Right = self:LocalToWorldAngles( self.VehicleData.LocalAngRight ):Forward()
	self.Up = self:GetUp()

	self.Vel = self:GetVelocity()
	self.VelNorm = self.Vel:GetNormalized()

	local speed = self.Vel:Length()
	if speed > 0 then
		self.MoveDir = math.acos( math.Clamp( self.Forward:Dot(self.VelNorm), -1, 1) ) * halfpi1
		self.ForwardSpeed = math.cos(self.MoveDir * halfpi2) * self.Vel:Length()
	else
		self.MoveDir = 0
		self.ForwardSpeed = 0
	end

	if self.poseon then
		self.cpose = self.cpose or self.LightsPP.min
		self.cpose = math.Approach(self.cpose, self.poseon, FrameTime() * 2)
		self:SetPoseParameter(self.LightsPP.name, self.cpose)
	end

	self:SetPoseParameter("vehicle_guage", (math.abs(self.ForwardSpeed) * var1) / (self.SpeedoMax or 120))

	if self.RPMGaugePP then
		local flywheelrpm = self:GetFlyWheelRPM()
		local rpm
		if self:GetRevlimiter() then
			local throttle = self:GetThrottle()
			local maxrpm = self:GetLimitRPM()
			local revlimiter = (maxrpm > 2500) and (throttle > 0)
			rpm = math.Round(((flywheelrpm >= maxrpm - 200) and revlimiter) and math.Round(flywheelrpm - 200 + math.sin(curtime * 50) * 600,0) or flywheelrpm,0)
		else
			rpm = flywheelrpm
		end

		self:SetPoseParameter(self.RPMGaugePP,  rpm / self.RPMGaugeMax)
	end

	if Active then
		local ply = self:GetDriver()
		local IsValidDriver = IsValid( ply )

		local GearUp = self.PressedKeys["M1"] and 1 or self.PressedKeys["joystick_gearup"]
		local GearDown = self.PressedKeys["M2"] and 1 or self.PressedKeys["joystick_geardown"]

		local W = self.PressedKeys["W"] and 1 or 0
		local A = not self.turnmenuOpened and (self.PressedKeys["A"] and 1 or self.PressedKeys["joystick_steer_left"]) or 0
		local S = self.PressedKeys["S"] and 1 or 0
		local D = not self.turnmenuOpened and (self.PressedKeys["D"] and 1 or self.PressedKeys["joystick_steer_right"]) or 0

		if IsValidDriver then self:PlayerSteerVehicle( ply, A, D ) end

		local k_Shift = self.PressedKeys["Shift"]
		local Shift = k_Shift and 1 or 0

		local Alt = self.PressedKeys["Alt"] and 1 or 0
		local Space = self.PressedKeys["Space"] and 1 or self.PressedKeys["joystick_handbrake"]

		self:SimulateEngine( IdleRPM, LimitRPM, Powerbandstart, Powerbandend, curtime )
		if IsValidDriver or self.IsAutonomous then
			self:SimulateTransmission(W,S,Shift,Alt,Space,GearUp,GearDown,IdleRPM,Powerbandstart,Powerbandend,cruise,curtime)
			self:SimulateWheels( math.max(Space,Alt), LimitRPM )
		else
			local vel = self:GetVelocity():LengthSqr()
			if vel > 40 or math.abs(self.EngineTorque) > 0.001 then
				self:SimulateWheels( math.max(Space,Alt), LimitRPM )
			end

			if vel < 40 and vel > 0.01 then
				local phys = self:GetPhysicsObject()
				phys:AddVelocity(-phys:GetVelocity() * 0.5)
				phys:AddAngleVelocity(-phys:GetAngleVelocity() * 0.5)
			end
		end

		if self.WheelOnGroundDelay < curtime then
			self:WheelOnGround()
			self.WheelOnGroundDelay = curtime + 0.15
		end
	end

	if self.CustomWheels then
		self:PhysicalSteer()
	end
end

function ENT:SetupControls( ply )
	self:ResetJoystick()

	if self.keys then
		for i = 1, table.Count( self.keys ) do
			numpad.Remove( self.keys[i] )
		end
	end

	if IsValid(ply) then
		self.cl_SteerSettings = {
			Overwrite = (ply:GetInfoNum( "cl_simfphys_overwrite", 0 ) >= 1),
			TurnSpeed = math.Clamp(ply:GetInfoNum( "cl_simfphys_steerspeed", 8 ), 1, 20),
			fadespeed = math.Clamp(ply:GetInfoNum( "cl_simfphys_fadespeed", 535 ), 1, 1000),
			fastspeedangle = math.Clamp(ply:GetInfoNum( "cl_simfphys_steerangfast", 10 ), 1, 30),
			smoothsteer = (ply:GetInfoNum( "cl_simfphys_smoothsteer", 0 ) >= 1),
		}

		local W = ply:GetInfoNum( "cl_simfphys_keyforward", 0 )
		local A = ply:GetInfoNum( "cl_simfphys_keyleft", 0 )
		local S = ply:GetInfoNum( "cl_simfphys_keyreverse", 0 )
		local D = ply:GetInfoNum( "cl_simfphys_keyright", 0 )

		local aW = ply:GetInfoNum( "cl_simfphys_key_air_forward", 0 )
		local aA = ply:GetInfoNum( "cl_simfphys_key_air_left", 0 )
		local aS = ply:GetInfoNum( "cl_simfphys_key_air_reverse", 0 )
		local aD = ply:GetInfoNum( "cl_simfphys_key_air_right", 0 )

		local GearUp = ply:GetInfoNum( "cl_simfphys_keygearup", 0 )
		local GearDown = ply:GetInfoNum( "cl_simfphys_keygeardown", 0 )

		local R = ply:GetInfoNum( "cl_simfphys_keyhandbrake_toggle", 0 )

		local F = ply:GetInfoNum( "cl_simfphys_lights", 0 )

		local M = ply:GetInfoNum( "cl_simfphys_emssiren", 0 )
		local N = ply:GetInfoNum( "cl_simfphys_emslights", 0 )
		local kSpecial = ply:GetInfoNum( "cl_simfphys_special", 0 )

		local H = ply:GetInfoNum( "cl_simfphys_keyhorn", 0 )

		local I = ply:GetInfoNum( "cl_simfphys_keyengine", 0 )

		local Shift = ply:GetInfoNum( "cl_simfphys_keywot", 0 )

		local Alt = ply:GetInfoNum( "cl_simfphys_keyclutch", 0 )
		local Space = ply:GetInfoNum( "cl_simfphys_keyhandbrake", 0 )

		local lock = ply:GetInfoNum( "cl_simfphys_key_lock", 0 )
		local turnMenu = ply:GetInfoNum('cl_simfphys_key_turnmenu', 0)

		local w_dn = numpad.OnDown( ply, W, "k_forward",self, true )
		local w_up = numpad.OnUp( ply, W, "k_forward",self, false )
		local s_dn = numpad.OnDown( ply, S, "k_reverse",self, true )
		local s_up = numpad.OnUp( ply, S, "k_reverse",self, false )
		local a_dn = numpad.OnDown( ply, A, "k_left",self, true )
		local a_up = numpad.OnUp( ply, A, "k_left",self, false )
		local d_dn = numpad.OnDown( ply, D, "k_right",self, true )
		local d_up = numpad.OnUp( ply, D, "k_right",self, false )

		local aw_dn = numpad.OnDown( ply, aW, "k_a_forward",self, true )
		local aw_up = numpad.OnUp( ply, aW, "k_a_forward",self, false )
		local as_dn = numpad.OnDown( ply, aS, "k_a_reverse",self, true )
		local as_up = numpad.OnUp( ply, aS, "k_a_reverse",self, false )
		local aa_dn = numpad.OnDown( ply, aA, "k_a_left",self, true )
		local aa_up = numpad.OnUp( ply, aA, "k_a_left",self, false )
		local ad_dn = numpad.OnDown( ply, aD, "k_a_right",self, true )
		local ad_up = numpad.OnUp( ply, aD, "k_a_right",self, false )

		local gup_dn = numpad.OnDown( ply, GearUp, "k_gup",self, true )
		local gup_up = numpad.OnUp( ply, GearUp, "k_gup",self, false )

		local gdn_dn = numpad.OnDown( ply, GearDown, "k_gdn",self, true )
		local gdn_up = numpad.OnUp( ply, GearDown, "k_gdn",self, false )

		local shift_dn = numpad.OnDown( ply, Shift, "k_wot",self, true )
		local shift_up = numpad.OnUp( ply, Shift, "k_wot",self, false )

		local alt_dn = numpad.OnDown( ply, Alt, "k_clutch",self, true )
		local alt_up = numpad.OnUp( ply, Alt, "k_clutch",self, false )

		local space_dn = numpad.OnDown( ply, Space, "k_hbrk",self, true )
		local space_up = numpad.OnUp( ply, Space, "k_hbrk",self, false )

		local k_cruise_dn = numpad.OnDown( ply, R, "k_hbrk_t",self, true )
		local k_cruise_up = numpad.OnUp( ply, R, "k_hbrk_t",self, false )

		local k_lights_dn = numpad.OnDown( ply, F, "k_lgts",self, true )
		local k_lights_up = numpad.OnUp( ply, F, "k_lgts",self, false )

		local k_flights_dn = numpad.OnDown( ply, M, "k_flgts",self, true )
		local k_flights_up = numpad.OnUp( ply, M, "k_flgts",self, false )

		local k_siren_dn = numpad.OnDown( ply, N, "k_siren",self, true )
		local k_siren_up = numpad.OnUp( ply, N, "k_siren",self, false )

		local k_special_dn = numpad.OnDown( ply, kSpecial, "k_spcl",self, true )
		local k_special_up = numpad.OnUp( ply, kSpecial, "k_spcl",self, false )

		local k_horn_dn = numpad.OnDown( ply, H, "k_hrn",self, true )
		local k_horn_up = numpad.OnUp( ply, H, "k_hrn",self, false )

		local k_engine_dn = numpad.OnDown( ply, I, "k_eng",self, true )
		local k_engine_up = numpad.OnUp( ply, I, "k_eng",self, false )

		local k_lock_dn = numpad.OnDown( ply, lock, "k_lock",self, true )
		local k_lock_up = numpad.OnUp( ply, lock, "k_lock",self, false )

		local k_tm_dn = numpad.OnDown(ply, turnMenu, 'k_turnmenu', self, true)
		local k_tm_up = numpad.OnUp(ply, turnMenu, 'k_turnmenu', self, false)

		self.keys = {
			w_dn,w_up,
			s_dn,s_up,
			a_dn,a_up,
			d_dn,d_up,
			aw_dn,aw_up,
			as_dn,as_up,
			aa_dn,aa_up,
			ad_dn,ad_up,
			gup_dn,gup_up,
			gdn_dn,gdn_up,
			shift_dn,shift_up,
			alt_dn,alt_up,
			space_dn,space_up,
			k_cruise_dn,k_cruise_up,
			k_lights_dn,k_lights_up,
			k_horn_dn,k_horn_up,
			k_flights_dn,k_flights_up,
			k_siren_dn,k_siren_up,
			k_special_dn,k_special_up,
			k_engine_dn,k_engine_up,
			k_lock_dn,k_lock_up,
			k_tm_dn,k_tm_up,
		}
	end
end

function ENT:PlayAnimation( animation )
	local anims = string.Implode( ",", self:GetSequenceList() )

	if not animation or not string.match( string.lower(anims), string.lower( animation ), 1 ) then return end

	local sequence = self:LookupSequence( animation )

	self:ResetSequence( sequence )
	self:SetPlaybackRate( 1 )
	self:SetSequence( sequence )
end

function ENT:PhysicalSteer()

	if IsValid(self.SteerMaster) then
		local physobj = self.SteerMaster:GetPhysicsObject()
		if not IsValid(physobj) then return end

		if physobj:IsMotionEnabled() then
			physobj:EnableMotion(false)
		end

		self.SteerMaster:SetAngles( self:LocalToWorldAngles( Angle(0,math.Clamp(-self.VehicleData[ "Steer" ],-self.CustomSteerAngle,self.CustomSteerAngle),0) ) )
	end

	if IsValid(self.SteerMaster2) then
		local physobj = self.SteerMaster2:GetPhysicsObject()
		if not IsValid(physobj) then return end

		if physobj:IsMotionEnabled() then
			physobj:EnableMotion(false)
		end

		self.SteerMaster2:SetAngles( self:LocalToWorldAngles( Angle(0,math.Clamp(self.VehicleData[ "Steer" ],-self.CustomSteerAngle,self.CustomSteerAngle),0) ) )
	end
end

function ENT:IsInitialized()
	return (self.EnableSuspension == 1)
end

function ENT:EngineActive()
	return self:GetEngineActive()
end

function ENT:IsDriveWheelsOnGround()
	return (self.DriveWheelsOnGround == 1)
end

function ENT:GetRPM()
	local RPM = self.EngineRPM and self.EngineRPM or 0
	return RPM
end

function ENT:GetEngineRPM()
	local flywheelrpm = self:GetRPM()
	local rpm
	if self:GetRevlimiter() then
		local throttle = self:GetThrottle()
		local maxrpm = self:GetLimitRPM()
		local revlimiter = (maxrpm > 2500) and (throttle > 0)
		rpm = math.Round(((flywheelrpm >= maxrpm - 200) and revlimiter) and math.Round(flywheelrpm - 200 + math.sin(CurTime()* 50) * 600,0) or flywheelrpm,0)
	else
		rpm = flywheelrpm
	end

	return rpm
end

function ENT:GetDiffGear()
	return math.max(self:GetDifferentialGear(),0.01)
end

function ENT:DamagedStall()
	if not self:GetActive() then return end

	local rtimer = math.random(5, 15)
	self.CantStart = true

	self:StallAndRestart( rtimer, true )
	timer.Simple( rtimer, function()
		if not IsValid( self ) then return end
		net.Start( "simfphys_backfire" )
			net.WriteEntity( self )
		net.Broadcast()
		self.CantStart = nil
	end)
end

function ENT:StopEngine()
	if self:EngineActive() then
		self:EmitSound( "vehicles/jetski/jetski_off.wav" )

		self.EngineRPM = 0
		self:SetEngineActive(false)

		self:SetFlyWheelRPM( 0 )
		self:SetIsCruiseModeOn( false )
	end
end

function ENT:CanStart()
	local FuelSystemOK = self:GetFuel() > 0
	local canstart = self:GetCurHealth() > (self:GetMaxHealth() * 0.1) and FuelSystemOK

	return canstart and not self.CantStart
end

function ENT:StartEngine()
	if not self:CanStart() then return end

	if not self:EngineActive() then
		if not self.IsInWater then
			self.EngineRPM = self:GetEngineData().IdleRPM
			self:SetEngineActive(true)
		else
			if self:GetDoNotStall() then
				self.EngineRPM = self:GetEngineData().IdleRPM
				self:SetEngineActive(true)
			end
		end
	end
end

function ENT:StallAndRestart()
	self:StopEngine()
end

function ENT:PlayerSteerVehicle(ply, left, right)
	if not IsValid(ply) then return end

	local leftRight = right - left
	local speedFrac = math.Clamp((self.ForwardSpeed - 300) / (self:GetFastSteerConeFadeSpeed() - 300), 0, 1)
	local wantedSteer = leftRight ~= 0 and leftRight or self.wantedSteer or 0
	local localDrift = math.acos(math.Clamp(self.Right:Dot(self.VelNorm), -1, 1)) * halfpi1 - 90
	local steerAngle = octolib.math.remap(speedFrac, 0, 1, self.VehicleData.steerangle, math.Clamp(math.abs(localDrift) * 1.2, self.FastSteeringAngle, self.VehicleData.steerangle))
	local steerSpeed = self:GetSteerSpeed() * steerAngle / self.VehicleData.steerangle

	if wantedSteer == 0 and self.CounterSteeringMul and self.ForwardSpeed > 50 then
		wantedSteer = wantedSteer - math.min(localDrift, self.CounterSteeringAng or 90) * self.CounterSteeringMul / steerAngle
	end

	local oldAng = self.SmoothAng
	self.SmoothAng = math.Approach(self.SmoothAng, math.Clamp(wantedSteer, -1, 1) * steerAngle, steerSpeed * FrameTime() * 24)

	if oldAng > 5 and self.SmoothAng <= 5 and self.turnMode == 3
	or oldAng < -5 and self.SmoothAng >= -5 and self.turnMode == 2 then
		self:TurnSignal(0)
	end

	if self.SmoothAng ~= self.VehicleData.Steer then
		self:SteerVehicle(self.SmoothAng)
	end
end

function ENT:SteerVehicle(steer)
	self.VehicleData.Steer = steer
	self:SetVehicleSteer(steer / self.VehicleData.steerangle)
end

local function flash(veh, times)
	local oldModes = {
		veh:GetLightsEnabled(),
		veh:GetIsBraking(),
	}

	for i = 0, times - 1 do
		timer.Simple(i * 0.25, function()
			veh:SetLightsEnabled(not oldModes[1])
			veh:SetIsBraking(not oldModes[2])
		end)
		timer.Simple(i * 0.25 + 0.15, function()
			veh:SetLightsEnabled(oldModes[1])
			veh:SetIsBraking(oldModes[2])
		end)
	end
	timer.Simple(times * 0.25 + 0.2, function()
		veh:SetLightsEnabled(oldModes[1])
		veh:SetIsBraking(oldModes[2])
	end)
end

function ENT:Lock()
	if self.lockpicked or self:GetIsLocked() then return end
	self:SetIsLocked(true)
	self:EmitSound("car/carlock.wav")
	flash(self, 2)
	-- netstream.StartPVS(self:GetPos(), 'simfphys.flash', self, 2)
end

function ENT:UnLock()
	if self.lockpicked or not self:GetIsLocked() then return end
	self:SetIsLocked(false)
	self:EmitSound("car/carunlock.wav")
	flash(self, 1)
	-- netstream.StartPVS(self:GetPos(), 'simfphys.flash', self, 1)
end

function ENT:ForceLightsOff()
	local vehiclelist = list.Get( "simfphys_lights" )[self.LightsTable] or false
	if not vehiclelist then return end

	if vehiclelist.Animation then
		if self.LightsActivated then
			self.LightsActivated = false
			self.LampsActivated = false

			self:SetLightsEnabled(false)
			self:SetLampsEnabled(false)
		end
	end
end

function ENT:EnteringSequence( ply )
	local LinkedDoorAnims = istable(self.ModelInfo) and istable(self.ModelInfo.LinkDoorAnims)
	if not istable(self.Enterpoints) and not LinkedDoorAnims then return end

	local sequence
	local pos
	local dist

	if LinkedDoorAnims then
		for i,_ in pairs( self.ModelInfo.LinkDoorAnims ) do
			local seq_ = self.ModelInfo.LinkDoorAnims[ i ].enter

			local a_pos = self:GetAttachment( self:LookupAttachment( i ) ).Pos
			local a_dist = (ply:GetPos() - a_pos):Length()

			if not sequence then
				sequence = seq_
				pos = a_pos
				dist = a_dist
			else
				if a_dist < dist then
					sequence = seq_
					pos = a_pos
					dist = a_dist
				end
			end
		end
	else
		for i = 1, table.Count( self.Enterpoints ) do
			local a_ = self.Enterpoints[ i ]

			local a_pos = self:GetAttachment( self:LookupAttachment( a_ ) ).Pos
			local a_dist = (ply:GetPos() - a_pos):Length()

			if i == 1 then
				sequence = a_
				pos = a_pos
				dist = a_dist
			else
				if  (a_dist < dist) then
					sequence = a_
					pos = a_pos
					dist = a_dist
				end
			end
		end
	end

	self:PlayAnimation( sequence )
	self:ForceLightsOff()
end

function ENT:GetMouseSteer()
	return 0
end

function ENT:Use( ply )
	if IsValid(ply:GetNetVar('dragging')) then
		local target = ply:GetNetVar('dragging')
		target.isForce = true
		self:SetPassenger(target, true)
		return
	end
	self:SetPassenger( ply )
end

function ENT:CanDrive( ply )
	local owner = self:CPPIGetOwner()
	return not (ply:IsHandcuffed() or ply:getJobTable().notHuman) and (ply == owner or self.lockpicked or (IsValid(owner) and owner.Buddies and owner.Buddies[ply] and table.HasValue(owner.Buddies[ply], true))) or ply:Team() == TEAM_ADMIN or false
end

function ENT:FindAvailableSeat(ply)
	if not IsValid(self:GetDriver()) and not ply:KeyDown(IN_SPEED) and self:CanDrive(ply) and IsValid(self.DriverSeat) then
		return self.DriverSeat
	end
	if not self.PassengerSeats then return end
	local closestSeat = self:GetClosestSeat(ply)
	if not IsValid(closestSeat) or IsValid(closestSeat:GetDriver()) then
		for i = 1, #self.pSeat do
			if IsValid(self.pSeat[i]) and not IsValid(self.pSeat[i]:GetDriver()) then
				return self.pSeat[i]
			end
		end
	else return closestSeat end
end

function ENT:SetPassenger( ply, instant )
	if not IsValid(ply) then return end

	if self:GetIsLocked() or self:HasPassengerEnemyTeam( ply ) then
		self:EmitSound( "doors/latchlocked2.wav" )
		return
	end

	if ply:InVehicle() or ply.entering then return end

	local owner = self:CPPIGetOwner()
	local seat = self:FindAvailableSeat(ply)
	if not IsValid(seat) then return end

	ply.entering = true
	ply:DelayedAction('enterCar', L.enter_car, {
		time = instant and 0 or 2,
		check = function()
			if not IsValid(ply) then return false end
			if not IsValid(self) or not isfunction(self.FindAvailableSeat) then return false end
			if not IsValid(seat) or IsValid(seat:GetDriver()) or (seat == self.DriverSeat and not self:CanDrive(ply)) then
				seat = self:FindAvailableSeat(ply)
				if not IsValid(seat) then return false end
			end
			return octolib.use.check(ply, self)
		end,
		succ = function()
			local driver = seat == self.DriverSeat
			self:EnteringSequence(ply)
			ply:EnterVehicle(seat)
			ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			netstream.Start(ply, 'simfphys.updateFuelUse', self, self.fuelUse)

			if driver then
				ply:SetAllowWeaponsInVehicle(false)
				ply:SelectWeapon('dbg_hands')
			else ply:SetAllowWeaponsInVehicle(true) end

			ply:SetEyeAngles(Angle(0,90,0))

			if driver and ply == owner then self.lockpicked = nil end
			ply.entering = nil
		end,
		fail = function()
			ply.entering = nil
		end,
	}, {
		time = 1.5,
		inst = true,
		action = function()
			ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
		end,
	})

end
hook.Add('PlayerLeaveVehicle', 'simfphys-delay.fix', function(ply, veh) ply.entering = nil end)

function ENT:GetClosestSeat( ply )
	local Seat = self.pSeat[1]
	if not IsValid(Seat) then return false end

	local Distance = (Seat:GetPos() - ply:GetPos()):LengthSqr()

	for i = 1, table.Count( self.pSeat ) do
		local Dist = (self.pSeat[i]:GetPos() - ply:GetPos()):LengthSqr()
		if (Dist < Distance) then
			Seat = self.pSeat[i]
		end
	end

	return Seat
end

function ENT:HasPassengerEnemyTeam( ply )
	if not GetConVar( "sv_simfphys_teampassenger" ):GetBool() then return false end

	if not IsValid( ply ) then return true end

	local myteam = ply:Team()
	if IsValid( self:GetDriver() ) then
		if self:GetDriver():Team() ~= myteam then
			return true
		end
	end

	if self.PassengerSeats then
		for i = 1, table.Count( self.pSeat ) do
			if IsValid(self.pSeat[i]) then

				local Passenger = self.pSeat[i]:GetDriver()
				if IsValid( Passenger ) then
					if Passenger:Team() ~= myteam then
						return true
					end
				end
			end
		end
	end

	return false
end

function ENT:SetPhysics( enable )
	if enable then
		if not self.PhysicsEnabled then
			for i = 1, table.Count( self.Wheels ) do
				local Wheel = self.Wheels[i]
				if IsValid(Wheel) then
					Wheel:GetPhysicsObject():SetMaterial("jeeptire")
				end
			end
			self.PhysicsEnabled = true
		end
	else
		if self.PhysicsEnabled ~= false then
			for i = 1, table.Count( self.Wheels ) do
				local Wheel = self.Wheels[i]
				if IsValid(Wheel) then
					Wheel:GetPhysicsObject():SetMaterial("friction_00")
				end
			end
			self.PhysicsEnabled = false
		end
	end
end

function ENT:SetSuspension( index , bIsDamaged )
	local bIsDamaged = bIsDamaged or false

	local h_mod = index <= 2 and self:GetFrontSuspensionHeight() or self:GetRearSuspensionHeight()

	local heights = {
		[1] = self.FrontHeight + self.VehicleData.suspensiontravel_fl * -h_mod,
		[2] = self.FrontHeight + self.VehicleData.suspensiontravel_fr * -h_mod,
		[3] = self.RearHeight + self.VehicleData.suspensiontravel_rl * -h_mod,
		[4] = self.RearHeight + self.VehicleData.suspensiontravel_rr * -h_mod,
		[5] = self.RearHeight + self.VehicleData.suspensiontravel_rl * -h_mod,
		[6] = self.RearHeight + self.VehicleData.suspensiontravel_rr * -h_mod
	}
	local Wheel = self.Wheels[index]
	if not IsValid(Wheel) then return end

	local subRadius = bIsDamaged and Wheel.dRadius or 0

	local newheight = heights[index] + subRadius

	local Elastic = self.Elastics[index]
	if IsValid(Elastic) then
		Elastic:Fire( "SetSpringLength", newheight )
	end

	if self.StrengthenSuspension == true then
		local Elastic2 = self.Elastics[index * 10]
		if IsValid(Elastic2) then
			Elastic2:Fire( "SetSpringLength", newheight )
		end
	end
end

function ENT:OnFrontSuspensionHeightChanged( name, old, new )
	if old == new then return end
	if not self.CustomWheels and new > 0 then new = 0 end
	if not self:IsInitialized() then return end

	if IsValid(self.Wheels[1]) then
		local Elastic = self.Elastics[1]
		if IsValid(Elastic) then
			Elastic:Fire( "SetSpringLength", self.FrontHeight + self.VehicleData.suspensiontravel_fl * -new )
		end

		if self.StrengthenSuspension == true then

			local Elastic2 = self.Elastics[10]

			if IsValid(Elastic2) then
				Elastic2:Fire( "SetSpringLength", self.FrontHeight + self.VehicleData.suspensiontravel_fl * -new )
			end
		end
	end

	if IsValid(self.Wheels[2]) then
		local Elastic = self.Elastics[2]
		if IsValid(Elastic) then
			Elastic:Fire( "SetSpringLength", self.FrontHeight + self.VehicleData.suspensiontravel_fr * -new )
		end

		if self.StrengthenSuspension == true then

			local Elastic2 = self.Elastics[20]

			if (IsValid(Elastic2)) then
				Elastic2:Fire( "SetSpringLength", self.FrontHeight + self.VehicleData.suspensiontravel_fr * -new )
			end
		end
	end
end

function ENT:OnRearSuspensionHeightChanged( name, old, new )
	if old == new then return end
	if not self.CustomWheels and new > 0 then new = 0 end
	if not self:IsInitialized() then return end

	if IsValid(self.Wheels[3]) then
		local Elastic = self.Elastics[3]
		if IsValid(Elastic) then
			Elastic:Fire( "SetSpringLength", self.RearHeight + self.VehicleData.suspensiontravel_rl * -new )
		end

		if self.StrengthenSuspension == true then

			local Elastic2 = self.Elastics[30]

			if IsValid(Elastic2) then
				Elastic2:Fire( "SetSpringLength", self.RearHeight + self.VehicleData.suspensiontravel_rl * -new )
			end
		end
	end

	if IsValid(self.Wheels[4]) then
		local Elastic = self.Elastics[4]
		if IsValid(Elastic) then
			Elastic:Fire( "SetSpringLength", self.RearHeight + self.VehicleData.suspensiontravel_rr * -new )
		end

		if self.StrengthenSuspension == true then

			local Elastic2 = self.Elastics[40]

			if IsValid(Elastic2) then
				Elastic2:Fire( "SetSpringLength", self.RearHeight + self.VehicleData.suspensiontravel_rr * -new )
			end
		end
	end

	if IsValid(self.Wheels[5]) then
		local Elastic = self.Elastics[5]
		if IsValid(Elastic) then
			Elastic:Fire( "SetSpringLength", self.RearHeight + self.VehicleData.suspensiontravel_rl * -new )
		end

		if self.StrengthenSuspension == true then

			local Elastic2 = self.Elastics[50]

			if IsValid(Elastic2) then
				Elastic2:Fire( "SetSpringLength", self.RearHeight + self.VehicleData.suspensiontravel_rl * -new )
			end
		end
	end

	if IsValid(self.Wheels[6]) then
		local Elastic = self.Elastics[6]
		if IsValid(Elastic) then
			Elastic:Fire( "SetSpringLength", self.RearHeight + self.VehicleData.suspensiontravel_rr * -new )
		end

		if self.StrengthenSuspension == true then

			local Elastic2 = self.Elastics[60]

			if IsValid(Elastic2) then
				Elastic2:Fire( "SetSpringLength", self.RearHeight + self.VehicleData.suspensiontravel_rr * -new )
			end
		end
	end
end

function ENT:OnTurboCharged( name, old, new )
	if old == new then return end
	local Active = self:GetActive()

	if new == true and Active then
		self.Turbo:Stop()
		self.Turbo = CreateSound(self, self.snd_spool or "simulated_vehicles/turbo_spin.wav")
		self.Turbo:PlayEx(0,0)

	elseif new == false then
		if self.Turbo then
			self.Turbo:Stop()
		end
	end
end

function ENT:OnSuperCharged( name, old, new )
	if old == new then return end
	local Active = self:GetActive()

	if new == true and Active then
		self.Blower:Stop()
		self.BlowerWhine:Stop()

		self.Blower = CreateSound(self, self.snd_bloweroff or "simulated_vehicles/blower_spin.wav")
		self.BlowerWhine = CreateSound(self, self.snd_bloweron or "simulated_vehicles/blower_gearwhine.wav")

		self.Blower:PlayEx(0,0)
		self.BlowerWhine:PlayEx(0,0)
	elseif new == false then
		if self.Blower then
			self.Blower:Stop()
		end
		if self.BlowerWhine then
			self.BlowerWhine:Stop()
		end
	end
end

function ENT:OnRemove()
	if self.Wheels then
		for i = 1, table.Count( self.Wheels ) do
			local Ent = self.Wheels[ i ]
			if IsValid(Ent) then
				Ent:Remove()
			end
		end
	end
	if self.keys then
		for i = 1, table.Count( self.keys ) do
			numpad.Remove( self.keys[i] )
		end
	end
	if self.Turbo then
		self.Turbo:Stop()
	end
	if self.Blower then
		self.Blower:Stop()
	end
	if self.BlowerWhine then
		self.BlowerWhine:Stop()
	end
	if self.horn then
		self.horn:Stop()
	end
	if self.ems then
		self.ems:Stop()
	end

	self:OnDelete()
end

function ENT:PlayPP( On )
	if not self.LightsPP then return end
	self.poseon = On and self.LightsPP.max or self.LightsPP.min
end

function ENT:DamageLoop()
	if not self:OnFire() then return end

	local CurHealth = self:GetCurHealth()

	if CurHealth <= 0 then return end

	if self:GetMaxHealth() > 30 then
		if CurHealth > 30 then
			self:TakeDamage(1, Entity(0), Entity(0) )
		elseif CurHealth < 30 then
			self:SetCurHealth( CurHealth + 1 )
		end
	end

	if self.inv and math.random(10) == 1 then
		self.inv:PerformRandom({ maxVolume = 1, maxItems = 100 }, function(item, amount)
			local nostack = item:GetData('nostack')
			if nostack then
				item:Remove()
			else
				item:Remove(amount)
			end

			hook.Run('dbg-cars.itemBurned', self, item, nostack and 1 or amount)
			return amount
		end)
	end

	timer.Simple( 0.15, function()
		if IsValid( self ) then
			self:DamageLoop()
		end
	end)
end

function ENT:SetOnFire( bOn )
	if bOn == self:OnFire() then return end
	self:SetNetVar( "OnFire", bOn )

	if bOn then
		self:DamagedStall()
		self:DamageLoop()
	end
end

function ENT:SetOnSmoke( bOn )
	if bOn == self:OnSmoke() then return end
	self:SetNetVar( "OnSmoke", bOn )

	if bOn then
		self:DamagedStall()
	end
end

function ENT:SetMaxHealth( nHealth )
	self:SetNetVar( "MaxHealth", nHealth )
end

function ENT:SetCurHealth( nHealth )
	self:SetNetVar( "Health", nHealth )
end

function ENT:SetMaxFuel( nFuel )
	self:SetNetVar( "MaxFuel", nFuel )
end

function ENT:SetFuel( nFuel )
	self.curFuel = nFuel
end

function ENT:SetFuelUse( nFuel )
	self.fuelUse = nFuel
	local passengers = {}
	for _, v in ipairs(self:GetChildren()) do
		if v:GetClass() == 'prop_vehicle_prisoner_pod' and IsValid(v:GetDriver()) then
			passengers[#passengers + 1] = v:GetDriver()
		end
	end
	netstream.Start(passengers, 'simfphys.updateFuelUse', self, nFuel)
end

function ENT:SetFuelType( fueltype )
	self:SetNetVar( "FuelType", fueltype )
end

function ENT:SetFuelPos( vPos )
	self:SetFuelPortPosition( vPos )
end

function ENT:TurnSignal(mode)

	net.Start("simfphys_turnsignal")
		net.WriteEntity(self)
		net.WriteInt(mode, 32)
	net.Broadcast()

	self.turnMode = mode

	if mode == 0 or mode == 1 then return end
	timer.Create('simfphys_turn' .. self:EntIndex(), 10, 1, function()
		if not IsValid(self) then return end
		if self.turnMode == mode then self:TurnSignal(0) end
	end)

end
