sound.Add({
	name = 'REV_BEEP',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	sound = 'octoteam/vehicles/shared/REVERSE_WARNING.wav'
})

sound.Add({
	name = 'REV_BEEP_MRTASTY',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	sound = 'octoteam/vehicles/mrtasty_reversebeep.wav'
})

sound.Add({
	name = 'BRK',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	sound = 'octoteam/vehicles/shared/brake_disc.wav'
})

sound.Add({
	name = 'BRK_TRK',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	sound = 'octoteam/vehicles/shared/rig_brake_disc.wav'
})

sound.Add({
	name = 'BRK_TRK_STOP',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 70,
	sound = 'octoteam/vehicles/shared/BRAKE_RELEASE.wav'
})

sound.Add({
	name = 'COOLING_FAN',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 50,
	sound = 'octoteam/vehicles/shared/cooling_start.wav'
})

sound.Add({
	name = 'COOLING_FAN_END',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 50,
	sound = 'octoteam/vehicles/shared/cooling_end.wav'
})

sound.Add({
	name = 'GTA4_BULLHORN',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	sound = 'octoteam/vehicles/horns/police_horn.wav'
})

sound.Add({
	name = 'GTA4_SIREN_WAIL',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	sound = 'octoteam/vehicles/horns/police_wail.wav'
})

sound.Add({
	name = 'GTA4_SIREN_YELP',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	sound = 'octoteam/vehicles/horns/police_yelp.wav'
})

sound.Add({
	name = 'GTA4_SIREN_WARNING',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	sound = 'octoteam/vehicles/horns/police_warning.wav'
})

--GTA 4 functions for GTA 4 cars, written by a person who knows jackshit about LUA, code is most likely v bad
--if you do want to copy bits of it feel free, but do know that it's probably not good

REN = istable(REN) and REN or {} --define table to store all functions in

function REN.GTA4EngStartInit(self, Type)	--this bit selects the ignition type
	if Type == 0 then
		self.GTA4Ignition = CreateSound(self, 'octoteam/vehicles/shared/START_'..math.random(1,4)..'.wav')
		self.GTA4IgnitionTail = CreateSound(self, 'octoteam/vehicles/shared/START_'..math.random(1,4)..'_TAIL.wav')
		self.GTA4Ignition:SetSoundLevel(75)
		self.GTA4IgnitionTail:SetSoundLevel(75)
	elseif Type == 1 then
		self.GTA4Ignition = CreateSound(self, 'octoteam/vehicles/shared/TRUCK_IGNITION_1.wav')
		self.GTA4IgnitionTail = CreateSound(self, 'octoteam/vehicles/shared/TRUCK_IGNITION_TAIL.wav')
		self.GTA4Ignition:SetSoundLevel(80)
		self.GTA4IgnitionTail:SetSoundLevel(80)
	elseif Type == 2 then
		self.GTA4Ignition = CreateSound(self, 'octoteam/vehicles/shared/MOPED_600_CC_IGNITION.wav')
		self.GTA4IgnitionTail = CreateSound(self, 'octoteam/vehicles/shared/MOPED_600_CC_IGNITION_TAIL.wav')
		self.GTA4Ignition:SetSoundLevel(60)
		self.GTA4IgnitionTail:SetSoundLevel(60)
	end

	self.Ignition = false
end

local function GTA4IgnitionSwitch(self) --this bit actually turns the engine on after playing the ignition sound
	self.GTA4Ignition:Play()
	self.GTA4IgnitionTail:Stop()
	if self.Ignition then return end
	self.Ignition = true
	timer.Create('GTA4_IGNITION_' .. self:EntIndex(), (math.random(3,7)/10), 1, function()
		if self.GTA4Ignition:IsPlaying() then
			self.GTA4Ignition:Stop()
		end
		if !self.GTA4IgnitionTail:IsPlaying() then
			self.GTA4IgnitionTail:Play()
		end
		self.Ignition = false

		timer.Remove('GTA4_IGNITION_' .. self:EntIndex())

		if !self:CanStart() then return end

		self:SetActive(true)
		self.EngineRPM = self:GetEngineData().LimitRPM
		self:SetEngineActive(true)
	end)
end

local function GTA4IgnitionBeater(self) --failed iginiton for the beaters
	self.GTA4Ignition:Play()
	self.GTA4IgnitionTail:Stop()
	if self.Ignition then return end

	local Beater = math.random(0,1)

	self.Ignition = true
	timer.Create('GTA4_IGNITION_' .. self:EntIndex(), (math.random(3,15)/10), 1, function()
		if self.GTA4Ignition:IsPlaying() then
			self.GTA4Ignition:Stop()
		end
		if !self.GTA4IgnitionTail:IsPlaying() then
			self.GTA4IgnitionTail:Play()
		end

		self.Ignition = false

		timer.Remove('GTA4_IGNITION_' .. self:EntIndex())

		timer.Simple(0.5, function()
			if IsValid(self) and IsValid(self:GetDriver()) then
				if Beater == 1 and !(self.BeaterCounter > 1) then
					GTA4IgnitionBeater(self)
					self.BeaterCounter = self.BeaterCounter + 1
				else
					GTA4IgnitionSwitch(self)
					self.BeaterCounter = 0
				end
			end
		end)
	end)
end

function REN.GTA4EngStart(self) --this bit calls for the engine turning on

	self.StartEngine = function(self, bIgnoreSettings)
		if not self:EngineActive() then
			if not bIgnoreSettings then
				self.CurrentGear = 2
			end

			if self.BeaterCountdown then
				local Beater = math.random(0,1)
				if Beater == 1 then
					GTA4IgnitionBeater(self)
				end
			end

			if not self.IsInWater then
				GTA4IgnitionSwitch(self)
				else
					if self:GetDoNotStall() then
						GTA4IgnitionSwitch(self)
					end
			end
		end
	end
end

function REN.GTA4EngStop(self, TypeShut) --engnie shutdown

    self.StopEngine = function(self)
		if self:EngineActive() then
			if TypeShut == 1 then
				self:EmitSound('octoteam/vehicles/shared/SHUT_DOWN_1.wav')
			end

			self.EngineRPM = 0
			self:SetEngineActive(false)

			self:SetFlyWheelRPM(0)
			self:SetIsCruiseModeOn(false)
		end
    end
end

function REN.GTA4Bullhorn(self) --bullhorn script for Службы vehicles
	-- if not IsValid(self) then return end
	-- local ply = self:GetDriver()
	-- if not IsValid(ply) or not ply:IsPlayer() then return end --if there is no driver, end the script, otherwise it would error

	-- if ply:KeyDown(2048) and IsValid(ply) then
	-- 	self.Bullhorn = CreateSound(self, 'GTA4_BULLHORN')
	-- 	self.Bullhorn:Play()
	-- else
	-- 	if self.Bullhorn then
	-- 		self.Bullhorn:Stop()
	-- 	end
	-- end
end

function REN.GTA4AlarmInit(self)
	self.ALRM = CreateSound(self, 'octoteam/vehicles/horns/CAR_ALARM_'..math.random(1,3)..'.wav') --picks an alarm sound
	self.ALRM:SetSoundLevel(90)

	self.CurHealthGot = false
	self.ALRMon = false
	self.ALRMArmed = false
	self.CurHealthLocked = self:GetCurHealth()

	-- self.ALRMRnd = math.random(0,2)
	self.ALRMRnd = 0
end

local function ActivateHorn(self, bool)
	if not self.horn then
		self.horn = CreateSound(self, self.snd_horn or 'simulated_vehicles/horn_1.wav')
		self.horn:PlayEx(0,100)
	end
	if bool then
		self.horn:Play()
	else
		self.horn:Stop()
	end
	-- self.HornKeyIsDown = bool
	-- self:ControlHorn()
end

local function ChirpAlarmLocked(self)
	if self.ALRMRnd == 2 then
		self.ALRM:Play()
	else
		-- ActivateHorn(self, true)
	end
	self:SetLightsEnabled(true)
	timer.Simple(0.1, function()
		if IsValid(self) then
			self:SetLightsEnabled(false)
			if self.ALRMRnd == 2 then
				self.ALRM:Stop()
			else
				-- ActivateHorn(self, false)
			end
		end
	end)
end

local function ChirpAlarmUnLocked(self)
	if self.ALRMRnd == 2 then
		self.ALRM:Play()
	else
		-- ActivateHorn(self, true)
	end
	timer.Simple(0.12, function()
		if IsValid(self) then
			self:SetLightsEnabled(true)
			if self.ALRMRnd == 2 then
				self.ALRM:Stop()
			else
				-- ActivateHorn(self, false)
			end
		end
	end)
	timer.Simple(0.24, function()
		if IsValid(self) then
			if self.ALRMRnd == 2 then
				self.ALRM:Play()
			else
				-- ActivateHorn(self, true)
			end
		end
	end)
	timer.Simple(0.36, function()
		if IsValid(self) then
			self:SetLightsEnabled(false)
			if self.ALRMRnd == 2 then
				self.ALRM:Stop()
			else
				-- ActivateHorn(self, false)
			end
		end
	end)
end

local function TurnOffAlarm(self)
	if !self.ALRMArmed then return end

	if self.ALRMon then
		if self.ALRM then
			self.ALRM:Stop()
		end
	end
	if timer.Exists('GTA4_ALARM_' .. self:EntIndex()) then
		timer.Remove('GTA4_ALARM_' .. self:EntIndex())
	end
	self:SetLightsEnabled(false)
	self.ALRMon = false
	self.ALRMed = false
	self.CurHealthGot = false
end

function REN.GTA4Alarm(self, ALRMVal) -- alarm function
	if self:EngineActive() then return end
	if self.ALRMRnd == 0 then return end

	if self:GetIsLocked() then
		if !self.CurHealthGot then self.CurHealthLocked = self:GetCurHealth() end
		self.CurHealthGot = true

		if !self.ALRMArmed then ChirpAlarmLocked(self) end
		self.ALRMArmed = true

		if self:GetCurHealth() < self.CurHealthLocked then
			self.ALRMon = true
			if self.ALRMRnd == 2 then
				self.ALRM:Play()
			end

			if self.ALRMed then return end

			if !timer.Exists('GTA4_ALARM_' .. self:EntIndex()) then
				timer.Create('GTA4_ALARM_' .. self:EntIndex(), 1, 1, function()
					self:SetLightsEnabled(true)
					if self.ALRMRnd == 1 then
						ActivateHorn(self, true)
					end

					timer.Simple(0.5, function()
						if IsValid(self) then
							self:SetLightsEnabled(false)
							if self.ALRMRnd == 1 then
								ActivateHorn(self, false)
							end
						end
					end)
				end)
			end

			if !timer.Exists('GTA4_ALARM_KILL_' .. self:EntIndex()) and self.ALRMon then
				timer.Create('GTA4_ALARM_KILL_' .. self:EntIndex(), math.random(15,25), 1, function()
					if IsValid(self) then
						TurnOffAlarm(self)
						self.ALRMed = true
					end
				end)
			end
		end
	end

	if !self:GetIsLocked() then
		if self.ALRMArmed then ChirpAlarmUnLocked(self) end
		timer.Remove('GTA4_ALARM_KILL_' .. self:EntIndex())
		TurnOffAlarm(self)
		self.ALRMed = false
		self.ALRMArmed = false
	end
end

function REN.GTA4GearSoundsHelp(self) --actual gear change noise
	self.GTA4GearSwitch = CreateSound(self, 'octoteam/vehicles/shared/EXTERNAL_GEAR_CHANGE_'..math.random(1,5)..'.wav')
	self.GTA4GearSwitch:SetSoundLevel(70)
	self.GTA4GearSwitch:PlayEx(0.7,100)

	self.GearChanged = self:GetGear() --set the checking value to match the current gear
end

function REN.GTA4GearSounds(self) --gear change calling script
	if not (self:GetGear() == 2) then
		if self.GearChanged == self:GetGear() then return end --check if the checking value matches the current gear, if not then play the noise
		REN.GTA4GearSoundsHelp(self)
	end
end

--[[function REN.GTA4SkidSounds(self, wheelsnds4) --replace skid sounds with GTA4 skid sounds (even though the tarmac skid is probably the exact same lmao)

	if wheelsnds4 == nil then
		wheelsnds4 = {}
		wheelsnds4.snd_skid = 'octoteam/vehicles/shared/tarmac_skid.wav'
		wheelsnds4.snd_skid_dirt = 'octoteam/vehicles/shared/gravel_skid.wav'
		wheelsnds4.snd_skid_grass = 'octoteam/vehicles/shared/grass_skid.wav'
	end

	for i = 1, table.Count(self.Wheels) do
		local Wheel = self.Wheels[i]
		Wheel.snd_skid = wheelsnds4.snd_skid
		Wheel.snd_skid_dirt = wheelsnds4.snd_skid_dirt
		Wheel.snd_skid_grass = wheelsnds4.snd_skid_grass
	end

end]] --nevermind, all the sounds are the exact same lol

function REN.GTA4ReverseBeep(self)
	self.REVBP = CreateSound(self, 'REV_BEEP')

	if (self:GetGear() == 1) then
		self.REVBP:Play()
	else
		self.REVBP:Stop()
	end
end

function REN.GTA4ReverseBeepMrTasty(self) -- insane level of detail from GTA4
	self.REVBP = CreateSound(self, 'REV_BEEP_MRTASTY')

	if (self:GetGear() == 1) then
		self.REVBP:Play()
	else
		self.REVBP:Stop()
	end
end

function REN.GTA4Braking(self) --brake disc sound
	if not self.BrakeSqueal then return end

	if self:GetIsBraking() and self.ForwardSpeed > 20 and self.ForwardSpeed < 400 then --check if the forward speed is correct and if the car is braking
		if not self.BRK or not self.BRK:IsPlaying() then
			self.BRK = CreateSound(self, 'BRK')
			self.BRK:PlayEx(0.75,100)
		end
	else
		if self.BRK and self.BRK:IsPlaying() then
			self.BRK:Stop()
		end
	end
end

function REN.GTA4TruckBraking(self) --brake disc sound but truck
	if self:GetIsBraking() and self.ForwardSpeed > 20 and self.ForwardSpeed < 500 then
		if not self.BRK or not self.BRK:IsPlaying() then
			self.BRK = CreateSound(self, 'BRK_TRK')
			self.BRK:PlayEx(0.75,100)
		end
	else
		if self.BRK and self.BRK:IsPlaying() then
			self.BRK:Stop()

			if not self.BRKSTP or not self.BRKSTP:IsPlaying() then
				self.BRKSTP = CreateSound(self, 'BRK_TRK_STOP')
				self.BRKSQK = CreateSound(self, 'octoteam/vehicles/shared/BRAKE_SQUEAK_'..math.random(1,3)..'.wav')
				self.BRKSTP:Play()
				self.BRKSQK:Play()
			end
		end
	end

	--this works but I wrote it a while ago so I don't remember how
	-- c:
end

function REN.GTA4CooldownTick(self)	--cooldown tick noise
	self.GTA4Cooldown = CreateSound(self, 'octoteam/vehicles/shared/HEAT_TICK_'..math.random(1,6)..'.wav')
	self.GTA4Cooldown:SetSoundLevel(45)
	self.GTA4Cooldown:PlayEx(0.5, 100)
end

--[[function REN.GTA4Cooldown(self) --script that handles cooldown ticks and engine heat (old version, it works but it's badly designed)

	local THRTL = (self:GetEngineRPM() / 1000) / 1.5
	if !self.EngHeat then return end

	if (self:EngineActive() and not (self.EngHeat > 4999)) then
		if self.EngHeat > -3 then
			self.EngHeat = self.EngHeat + (THRTL - 1)
			if self.EngHeat > 4999 then
				self.EngHeat = self.EngHeat - 5
			end
		else
			self.EngHeat = self.EngHeat + 1
		end
	end

	if (self.EngHeat > 4000) and self.CoolingAllowed then
			self.CoolingAllowed = false
			self.Cooling = true
			if !self.GTA4Cooling:IsPlaying() then
				self.GTA4Cooling:Play()
				self.GTA4CoolingEnd:Stop()
			end
		timer.Create('GTA4_COOLING_END_' .. self:EntIndex(), 15, 1, function()
			if self.GTA4Cooling:IsPlaying() then
				self.GTA4Cooling:Stop()
				if !self.GTA4CoolingEnd:IsPlaying() then
					self.GTA4CoolingEnd:Play()
				end
			end
			self.Cooling = false
			timer.Remove('GTA4_COOLING_END_' .. self:EntIndex())
		end)
		timer.Create('GTA4_COOLING_TIMER_' .. self:EntIndex(), 25, 1, function()
			self.CoolingAllowed = true
			timer.Remove('GTA4_COOLING_TIMER_' .. self:EntIndex())
		end)
	end

	if self.Cooling then
		self.EngHeat = self.EngHeat - 2
	end

	if not (self:EngineActive() or self.EngHeat < -1) then
		self.EngHeat = self.EngHeat - 0.5
	end

	local LOW = (5010 - self.EngHeat) / 1000
	local HIGH = LOW + 0.3

	if not timer.Exists('GTA4_COOLDOWN_' .. self:EntIndex()) then
		if (!self:EngineActive() and self.EngHeat > 2000) then
			timer.Create('GTA4_COOLDOWN_' .. self:EntIndex(), math.random(LOW,HIGH), 1, function()
				REN.GTA4CooldownTick(self)
				timer.Remove('GTA4_COOLDOWN_' .. self:EntIndex())
			end)
		end
	end
end]]

function REN.GTA4Cooldown(self) --new engine heat simulation, cooldown ticks and cooling
	--safety checks
	if !self.EngHeat then return end
	if !self.Cooling then return end

	--init (still runs on every frame lol)
	local THRTL = math.Round(self:GetEngineRPM() / 1000 , 2)
	local LIMIT = self:GetEngineData().LimitRPM
	local IDLE = self:GetEngineData().IdleRPM
	local LOW2 = ((LIMIT*1.75 - self.EngHeat) / 1000) - LIMIT / 1000
	local LOW = math.Clamp(LOW2,0.2,4)
	local HIGH = LOW + 0.025

	--handle cooldown ticks after engine is off
	if (!timer.Exists('GTA4_COOLDOWN_' .. self:EntIndex()) and LOW < 2.75) then
		if !self:EngineActive() then
			timer.Create('GTA4_COOLDOWN_' .. self:EntIndex(), math.random(HIGH, HIGH + 0.01), 2, function()
				if !self:EngineActive() then REN.GTA4CooldownTick(self) end
			end)
		end
	end
	if (!timer.Exists('GTA4_COOLDOWN2_' .. self:EntIndex()) and LOW < 2.75) then
		if !self:EngineActive() then
			timer.Create('GTA4_COOLDOWN2_' .. self:EntIndex(), LOW + 0.2, 1, function()
				if !self:EngineActive() then
					self.GTA4Cooldown2 = CreateSound(self, 'octoteam/vehicles/shared/HEAT_TICK_4.wav')
					self.GTA4Cooldown2:SetSoundLevel(45)
					self.GTA4Cooldown2:PlayEx(0.4,100)
				end
			end)
		end
	end

	--handle engine cooling
	if self.EngHeat > LIMIT + LIMIT/2 then
		self.Cooling = 1
		if !self.GTA4Cooling:IsPlaying() then
			self.GTA4Cooling:Play()
			self.GTA4CoolingEnd:Stop()
		end
	elseif self.EngHeat < LIMIT then
		if self.GTA4Cooling:IsPlaying() then
			self.GTA4Cooling:Stop()
			if !self.GTA4CoolingEnd:IsPlaying() then
				self.GTA4CoolingEnd:Play()
			end
		end
		self.Cooling = 0
	end

	--handle engine heat simulation
	COOL = -2 * self.Cooling
	THRTL = math.Round(THRTL / (self.EngHeat / 3000) , 3)
	THRTL = math.Clamp(THRTL, 0, 10)
	self.EngHeat = math.Clamp(self.EngHeat + (THRTL - self.EngHeat / (LIMIT*1.25) + COOL),IDLE/100,LIMIT*2)

	--[[debug
	print('THRTL: '..THRTL)
	print('EngHeat: '..self.EngHeat)
	print(LOW..', '..HIGH)
	print('Cooling Treshold: '..(LIMIT + LIMIT/2))
	print('---')]]
end

function REN.GTA4Handbrake(self, HNDBRK) --handbrake noise
	local ply = self:GetDriver()

	if !IsValid(self) or !IsValid(self.DriverSeat)  or !IsValid(self.DriverSeat:GetDriver()) then return end --if there is no driver, end the script, otherwise it would error
	if !ply:IsPlayer() then return end --checks if the driver is an actual player, not an AI

	local filter = RecipientFilter()
	if IsValid(self:GetDriver()) then
		filter:AddPlayer(ply)
	end

	if (HNDBRK == 0) then
		self.HandbrakeSND = CreateSound(self, 'octoteam/vehicles/shared/STANDARD_HANDBRAKE.wav', filter)
	elseif (HNDBRK == 1) then
		self.HandbrakeSND = CreateSound(self, 'octoteam/vehicles/shared/SPORTS_HANDBRAKE.wav', filter)
	elseif (HNDBRK == 2) then
		self.HandbrakeSND = CreateSound(self, 'octoteam/vehicles/shared/TRUCK_HANDBRAKE.wav', filter)
	elseif (HNDBRK == 3) then
		self.HandbrakeSND = CreateSound(self, 'common/null.wav', filter)
	end
	self.HandbrakeSND:SetSoundLevel(120)

	if self:GetHandBrakeEnabled() then
		if self.CanHandbrake then
			local vehicle = ply:GetVehicle()
			if vehicle:GetThirdPersonMode()~= nil then
				if !vehicle:GetThirdPersonMode() then
					self.HandbrakeSND:Play()
				end
			end
		end
		self.CanHandbrake = false
	end

	if !self:GetHandBrakeEnabled() then
		self.CanHandbrake = true
	end
end

function REN.GTA4BeaterInit(self)
	DMGNumber = math.random(1,5)
	self.BeaterCountdown = 0
	self.BeaterCounter = 0

	self.GTA4Beater1 = CreateSound(self, 'octoteam/vehicles/old_car_noises/EXTRA_DAMAGE_'..DMGNumber..'_A.wav') --picks 2 random but matching engine damage noises
	self.GTA4Beater2 = CreateSound(self, 'octoteam/vehicles/old_car_noises/EXTRA_DAMAGE_'..DMGNumber..'_B.wav') --these stay the same for the car, but can be different for different cars
	self.GTA4Beater1:SetSoundLevel(70)
	self.GTA4Beater2:SetSoundLevel(70)
end

function REN.GTA4Beater(self)
	PITCH = (self:GetEngineRPM()/50) + 80
	if !self.BeaterCountdown then return end

	if self:GetCurHealth() > (self.GetMaxHealth(self) / 2) + 100 then --makes beater cars un-repairable, like in IV
		self:SetCurHealth((self.GetMaxHealth(self) / 2) + 100)
	end

	if self:EngineActive() then
		self.BeaterCountdown = 0
		if self.ForwardSpeed < 500 then
			self.GTA4Beater1:PlayEx(0.3,PITCH)
			if self.GTA4Beater2 then
				self.GTA4Beater2:Stop()
			end
		elseif self.ForwardSpeed > 500 then
			if self.GTA4Beater1 then
				self.GTA4Beater1:Stop()
			end
			self.GTA4Beater2:PlayEx(0.3,PITCH)
		end
		if not timer.Exists('GTA4_BEATER_' .. self:EntIndex()) then
			timer.Create('GTA4_BEATER_' .. self:EntIndex(), math.random(1,10), 1, function()
				local Beater = math.random(0,1)

				if self:EngineActive() then
					if Beater == 1 and self.ForwardSpeed > 100 then
						net.Start('simfphys_backfire')
							net.WriteEntity(self) --make the car randomly backfire while driving
						net.Broadcast()
					else
						sound.Play('octoteam/vehicles/old_car_noises/BREAKDOWN_'..math.random(1,5)..'.wav', self:GetPos()) --plays random breakdown noises. I think gta4 does this, maybe not though
					end
				end
				timer.Remove('GTA4_BEATER_' .. self:EntIndex())
			end)
		end
	elseif !self:EngineActive() then
		if not (timer.Exists('GTA4_BEATERS_' .. self:EntIndex()) and self.BeaterCountdown < 3) then
			timer.Create('GTA4_BEATERS_' .. self:EntIndex(), 0.2, 1, function()
				sound.Play('octoteam/vehicles/old_car_noises/BREAKDOWN_'..math.random(1,5)..'.wav', self:GetPos()) --breakdown noises when the engine stops
				self.BeaterCountdown = self.BeaterCountdown + 1
			end)
		end
		if self.GTA4Beater1 then
			self.GTA4Beater1:Stop()
		end
		if self.GTA4Beater2 then
			self.GTA4Beater2:Stop()
		end
	end
end

function REN.GTA4SimfphysInit(self, Type, TypeShut)
	REN.GTA4EngStartInit(self, Type)
	REN.GTA4EngStart(self)
	REN.GTA4EngStop(self, TypeShut)
	REN.GTA4AlarmInit(self)

	self.GTA4Cooling = CreateSound(self, 'COOLING_FAN')
	self.GTA4CoolingEnd = CreateSound(self, 'COOLING_FAN_END')
	self.Cooling = 0
	self.BrakingAllowed = true

	self.EngHeat = 1

	self.GearChanged = 0
end

function REN.GTA4Delete(self) --fixed, now no longer errors if the car is removed before it initializes
	timer.Remove('GTA4_COOLDOWN_' .. self:EntIndex())
	timer.Remove('GTA4_COOLDOWN2_' .. self:EntIndex())
	timer.Remove('GTA4_BEATER_' .. self:EntIndex())
	timer.Remove('GTA4_BEATERS_' .. self:EntIndex())
	timer.Remove('GTA4_COOLING_END_' .. self:EntIndex())
	timer.Remove('GTA4_IGNITION_' .. self:EntIndex())
	timer.Remove('GTA4_ALARM_' .. self:EntIndex())
	if self.GTA4Cooling then
		self.GTA4Cooling:Stop()
	end
	if self.GTA4CoolingEnd then
		self.GTA4CoolingEnd:Stop()
	end
	if self.GTA4Ignition then
		self.GTA4Ignition:Stop()
	end
	if self.GTA4IgnitionTail then
		self.GTA4IgnitionTail:Stop()
	end
	if self.GTA4Beater1 then
		self.GTA4Beater1:Stop()
	end
	if self.GTA4Beater2 then
		self.GTA4Beater2:Stop()
	end
	if self.BRK then
		self.BRK:Stop()
	end
	if self.Bullhorn then
		self.Bullhorn:Stop()
	end
	if self.ALRM then
		self.ALRM:Stop()
	end
end

function REN.GTA4SimfphysOnTick(self, RevBeep, Braking, HndBrk)
	REN.GTA4Cooldown(self)
	REN.GTA4GearSounds(self)
	REN.GTA4Handbrake(self, HndBrk)
	REN.GTA4Alarm(self)

	if (RevBeep == 1) then
		REN.GTA4ReverseBeep(self)
	elseif (RevBeep == 2) then
		REN.GTA4ReverseBeepMrTasty(self)
	end

	if (Braking == 0) then
		REN.GTA4Braking(self)
	else
		REN.GTA4TruckBraking(self)
	end
end