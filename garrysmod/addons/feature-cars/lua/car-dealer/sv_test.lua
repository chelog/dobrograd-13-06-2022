if not CFG.dev then return end

local maxGear = 10
local function vehThink(self)

	if CurTime() >= (self.nextGearChange or 0) and self.CurrentGear < math.min(maxGear, #self.Gears) and self:GetRPM() / self:GetLimitRPM() > 0.8 then
		self.PressedKeys['Alt'] = true
		self.PressedKeys['W'] = false
		self.PressedKeys['Shift'] = false
		timer.Simple(0.5, function()
			if not IsValid(self) then return end
			self.CurrentGear = self.CurrentGear + 1
			self:SetGear(self.CurrentGear)
			self.PressedKeys['Alt'] = false
			self.PressedKeys['W'] = true
			self.PressedKeys['Shift'] = true
		end)
		self.nextGearChange = CurTime() + 1.5
	end

end

concommand.Add('vehicle_test', function(ply, cmd, args)

	local duration = table.remove(args, 1)

	local nextPos = ply:GetEyeTrace().HitPos + Vector(0, 0, 50)
	local dir = ply:GetAimVector()
	dir.z = 0
	local ang = dir:Angle()
	local dirShift = ply:GetRight()

	local spawned = {}
	local function spawnVehs()
		for _, class in ipairs(args) do
			local cdData = carDealer.vehicles[class]
			if not cdData then continue end

			local spData = list.Get('simfphys_vehicles')[cdData.simfphysID]
			if not spData then continue end

			local veh = simfphys.SpawnVehicle(nil, nextPos, ang, spData.Model, spData.Class, class, spData, true)
			veh.IsAutonomous = true
			veh.OnTick = vehThink
			veh:SetActive(true)
			-- veh:SetProxyColors({ HSVToColor(math.random(0, 360), math.Rand(0.3, 0.8), math.Rand(0, 1)) })
			-- veh:SetLightsEnabled(true)
			-- veh:SetLampsEnabled(true)
			-- veh:SetEMSEnabled(true)
			spawned[#spawned + 1] = veh

			-- local prop = ents.Create 'prop_physics'
			-- prop:SetModel('models/hunter/blocks/cube2x2x2.mdl')
			-- prop:SetPos(nextPos + ang:Forward() * 250)
			-- prop:Spawn()
			-- prop:GetPhysicsObject():SetMass(800)
			-- prop:Activate()
			-- spawned[#spawned + 1] = prop

			nextPos = nextPos + dirShift * 150
		end
	end

	local function startVehs()
		for _, veh in ipairs(spawned) do
			if not IsValid(veh) or not veh.StartEngine then continue end
			veh.keys = {}
			veh:StartEngine()
			veh.PressedKeys['W'] = true
			veh.PressedKeys['Shift'] = true
		end
	end

	local function removeVehs(all)
		for _, veh in ipairs(all and ents.FindByClass('gmod_sent_vehicle_fphysics_base') or spawned) do
			veh:Remove()
		end
	end

	-- removeVehs(true)
	spawnVehs()
	timer.Simple(1, startVehs)
	timer.Simple(duration, removeVehs)

	timer.Simple(0.5, function()
		netstream.Start(ply, 'followVehicles', spawned, dir)
	end)

end)
