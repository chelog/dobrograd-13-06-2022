local function numpadFunction(key, pre, post)
	return function(sid, ent, keydown)
		local ply = player.GetBySteamID(sid)
		if not IsValid(ply) or not IsValid(ent) or ply.inFlyEditor then return false end
		if isfunction(pre) then
			keydown = pre(ply, ent, keydown)
		end
		if ent.PressedKeys then
			ent.PressedKeys[key] = keydown
		end
		if isfunction(post) then post(ply, ent, keydown) end
	end
end

numpad.Register('k_forward', numpadFunction('W'))
numpad.Register('k_reverse', numpadFunction('S', nil, function(ply, ent, keydown)
	netstream.StartPVS(ply:GetPos(), 'simfphys.anim', ply, 'rfoot', keydown and -1 or 0)
end))
numpad.Register('k_left', numpadFunction('A'))
numpad.Register('k_right', numpadFunction('D'))
numpad.Register('k_a_forward', numpadFunction('aW'))
numpad.Register('k_a_reverse', numpadFunction('aS'))
numpad.Register('k_a_left', numpadFunction('aA'))
numpad.Register('k_a_right', numpadFunction('aD'))
numpad.Register('k_gup', numpadFunction('M1', function(ply, ent, keydown)
	return keydown and not ply.blockcontrols
end))
numpad.Register('k_gdn', numpadFunction('M2', function(ply, ent, keydown)
	return keydown and not ply.blockcontrols
end))
numpad.Register('k_wot', numpadFunction('Shift'))
numpad.Register('k_clutch', numpadFunction('Alt', nil, function(ply, ent, keydown)
	netstream.StartPVS(ply:GetPos(), 'simfphys.anim', ply, 'lfoot', keydown)
end))
numpad.Register('k_hbrk', numpadFunction('Space', nil, function(ply, ent, keydown)
	netstream.StartPVS(ply:GetPos(), 'simfphys.anim', ply, 'brake', keydown)

	if not keydown or ply:GetInfoNum('cl_octolib_sticky_handbrake', 1) < 1 then return end

	local ct = CurTime()
	if ct - (ply.lastHandbrakeDown or 0) < 0.2 then
		ent:ToggleHandbrake()
	end
	ply.lastHandbrakeDown = ct
end))
numpad.Register('k_hbrk_t', function(sid, ent, keydown)
	if not IsValid(player.GetBySteamID(sid)) or not IsValid(ent) or not keydown then return false end
	ent:ToggleHandbrake()
end )

-- numpad.Register('k_cc', function(sid, ent, keydown)
-- 	if not IsValid(player.GetBySteamID(sid)) or not IsValid(ent) then return false end

-- 	if keydown then
-- 		ent:ToggleHandbrake()ply
-- 	end
-- end )

netstream.Hook('dbg-cars.belt', function(ply)

	local seat = ply:GetVehicle()
	local car = IsValid(seat) and seat:GetParent()
	if ply.belting or not IsValid(car) or car:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' then return end

	ply.belting = true
	if not ply:GetNetVar('belted') then
		ply:DoAnimation(ACT_SIGNAL_HALT)
		ply:DoEmote(L.belt_hint)
		ply:DelayedAction('belt', L.belting_hint, {
			time = 1.5,
			check = function() return IsValid(ply) and ply:Alive() and ply:GetVehicle() == seat end,
			succ = function()
				ply:SetLocalVar('belted', true)
				ply.belting = nil
			end,
			fail = function()
				ply.belting = nil
			end,
		})
	else
		ply:DoAnimation(ACT_SIGNAL_HALT)
		ply:DoEmote(L.unbelt_hint)
		ply:DelayedAction('belt', L.unbelting_hint, {
			time = 1.5,
			check = function() return IsValid(ply) and ply:Alive() and ply:GetVehicle() == seat end,
			succ = function()
				ply:SetLocalVar('belted', nil)
				ply.belting = nil
			end,
			fail = function()
				ply.belting = nil
			end,
		})
	end

end)

hook.Add('PlayerLeaveVehicle', 'dbg-cars.unbelt', function(ply, veh) ply.belting = nil ply:SetLocalVar('belted', nil) end)
hook.Add('CanExitVehicle', 'dbg-cars.unbelt', function(veh, ply)

	local belted = tobool(ply:GetNetVar('belted'))
	if ply.belting or belted then
		if tobool(ply.belting) ~= belted and ply:TriggerCooldown('numpads.beltWarning', 3) then
			ply:Notify('warning', 'Нужно отстегнуть ремень')
		end
		if ply.belting and belted and ply:TriggerCooldown('numpads.unbeltWarning', 3) then
			ply:Notify('warning', 'Нужно подождать, пока ремень отстегивается')
		end
		return false
	end

end)

numpad.Register('k_hrn', function(sid, ent, keydown)
	if not IsValid(player.GetBySteamID(sid)) or not IsValid(ent) then return false end

	if keydown then
		ent.horn = CreateSound(ent, ent.snd_horn or 'simulated_vehicles/horn_1.wav')
		if ent.siren and ent.ems then ent.ems:Stop() end
		ent.horn:Play()
	elseif ent.horn then
		ent.horn:Stop()
		if ent.siren and ent.ems then ent.ems:PlayEx(0.4, 100) end
	end

end)

numpad.Register('k_eng', function(sid, ent, keydown)
	local ply = player.GetBySteamID(sid)
	if not IsValid(ply) or not IsValid(ent) or ply.inFlyEditor then return false end

	if keydown then
		if ent:EngineActive() then
			ent:StopEngine()
			netstream.StartPVS(ply:GetPos(), 'simfphys.anim', ply, 'engine', true)
			timer.Simple(0.3, function()
				if not IsValid(ply) then return end
				netstream.StartPVS(ply:GetPos(), 'simfphys.anim', ply, 'engine', false)
			end)
		else
			if ply.starting then return end
			ply.starting = true
			netstream.StartPVS(ply:GetPos(), 'simfphys.anim', ply, 'engine', true)
			ply:DelayedAction('engine', 'Запуск двигателя', {
				time = 1,
				check = function() return IsValid(ent) and IsValid(ply) and ply:Alive() and ent:GetDriver() == ply end,
				succ = function()
					ply.starting = nil
					ent:StartEngine(true)
					netstream.StartPVS(ply:GetPos(), 'simfphys.anim', ply, 'engine', false)
				end,
				fail = function() ply.starting = nil end,
			})
		end
	end
end)

numpad.Register('k_lock', function( sid, ent, keydown )
	local ply = player.GetBySteamID(sid)
	if not IsValid(ply) or not IsValid(ent) or ply.inFlyEditor then return false end

	if keydown then
		if ent:GetIsLocked() then
			ent:UnLock()
		else
			if ply:KeyDown(IN_WALK) and istable(ent.pSeat) then
				if ent:GetVelocity():LengthSqr() > 100 then
					return ply:Notify('Нельзя высаживать пассажиров на ходу')
				end
				for _,v in ipairs(ent.pSeat) do
					if not IsValid(v) then continue end
					local driver = v:GetDriver()
					if IsValid(driver) then
						driver:ExitVehicle()
					end
				end
			end
			ent:Lock()
		end

		netstream.StartPVS(ply:GetPos(), 'simfphys.anim', ply, 'engine', true)
		timer.Simple(0.3, function()
			if not IsValid(ply) then return end
			netstream.StartPVS(ply:GetPos(), 'simfphys.anim', ply, 'engine', false)
		end)
	end
end )

numpad.Register('k_turnmenu', function(sid, ent, keydown)
	local ply = player.GetBySteamID(sid)
	if not IsValid(ply) or not IsValid(ent) then return false end
	ent.turnmenuOpened = keydown or nil
	if not keydown then netstream.StartPVS(ply:GetPos(), 'simfphys.anim', ply, 'lhandle') end
end)

numpad.Register('k_flgts', function( sid, ent, keydown )
	if not IsValid(player.GetBySteamID(sid)) or not IsValid(ent) or ent.preventEms then return false end

	local v_list = list.Get('simfphys_lights')[ent.LightsTable] or false
	if not (v_list and v_list.ems_sprites) then return end

	local Time = CurTime()

	if keydown then
		ent.KeyPressedTime = Time
	else
		if (Time - ent.KeyPressedTime) < 0.15 and not ent.emson then
			ent.emson = true
			if not ent:GetEMSEnabled() then
				ent:EmitSound('items/flashlight1.wav')
			end
		end

		if (Time - ent.KeyPressedTime) >= 0.22 then
			if ent.emson then
				ent.emson = false
				if ent:GetEMSEnabled() then
					ent:EmitSound('buttons/lightswitch2.wav')
				end
			end
		end
		ent:SetEMSEnabled(ent.emson)
	end

end)

numpad.Register('k_siren', function( sid, ent, keydown )
	if not IsValid(player.GetBySteamID(sid)) or not IsValid(ent) or ent.preventEms then return false end

	local v_list = list.Get('simfphys_lights')[ent.LightsTable] or false
	if not (v_list and v_list.ems_sounds) then return end

	local ply, Time = player.GetBySteamID(sid), CurTime()

	if keydown then
		if ply:KeyDown(IN_DUCK) and not ent.siren then
			ent.ems = CreateSound(ent, v_list.ems_sounds[1])
			ent.ems:PlayEx(0.4, 100)
		end
		ent.KeyPressedTime = Time
	else

		if ent.ems then
			ent.ems:Stop()
		end

		if (Time - ent.KeyPressedTime) < 0.15 and not ent.siren and not ply:KeyDown(IN_DUCK) then
			ent.siren = true
			ent.cursound = 0
		end

		if (Time - ent.KeyPressedTime) >= 0.22 then
			if ent.siren then
				ent.siren = false
			end
		else
			if ent.siren then
				local sounds = v_list.ems_sounds
				local numsounds = table.Count( sounds )

				if numsounds <= 1 and ent.ems then
					ent.siren = false
					ent.ems = nil
					return
				end

				ent.cursound = ent.cursound + 1
				if ent.cursound > table.Count( sounds ) then
					ent.cursound = 1
				end

				ent.ems = CreateSound(ent, sounds[ent.cursound])
				ent.ems:PlayEx(0.4, 100)
			end
		end
	end

end)

numpad.Register('k_spcl', function( sid, ent, keydown )
	if not IsValid(player.GetBySteamID(sid)) or not IsValid(ent) or not ent.HasSpecial then return false end

	local controller = ent.TowController
	if not IsValid(controller) then return end

	local tName = 'towSync' .. ent:EntIndex()
	if keydown then
		controller.nextDir = controller.nextDir == 1 and -1 or 1
		controller:SetDirection(controller.nextDir)
		timer.Create(tName, 0.2, 0, function()
			if not IsValid(ent) then return timer.Remove(tName) end
			if controller.current_length == controller.max_length or controller.current_length == controller.min_length then
				ent:SetNetVar('hookDirection', 0)
				timer.Remove(tName)
			end
		end)
	else
		controller:SetDirection(0)
		timer.Remove(tName)
	end

	ent:SetNetVar('hookDirection', controller:GetDirection())
end)

numpad.Register('k_lgts', function( sid, ent, keydown )
	local ply = player.GetBySteamID(sid)
	if not IsValid(ply) or not IsValid(ent) or not ent.LightsTable then return false end
	if keydown then
		ent.LightsPressStart = CurTime()
	else
		local vehiclelist = list.Get('simfphys_lights')[ent.LightsTable] or false
		if not vehiclelist then return end

		netstream.StartPVS(ply:GetPos(), 'simfphys.anim', ply, 'rhandle')

		if CurTime() - (ent.LightsPressStart or 0) > 0.3 then
			if ent.LightsActivated then
				ent.LightsActivated = false
				ent:SetLightsEnabled(false)
				ent.LampsActivated = false
				ent:SetLampsEnabled(false)
				ent:EmitSound('items/flashlight1.wav')
				ent:PlayPP(false)

				if vehiclelist.BodyGroups then
					ent:SetBodygroup(vehiclelist.BodyGroups.Off[1], vehiclelist.BodyGroups.Off[2] )
				end
				if vehiclelist.Animation then
					ent:PlayAnimation( vehiclelist.Animation.Off )
				end
			end

			return
		end

		if ent.LightsActivated then
			local lamps = not ent.LampsActivated
			ent.LampsActivated = lamps
			ent:SetLampsEnabled(lamps)
		end

		ent.LightsActivated = true
		ent:SetLightsEnabled(true)
		ent:EmitSound('buttons/lightswitch2.wav')

		if vehiclelist.BodyGroups then
			ent:SetBodygroup(vehiclelist.BodyGroups.On[1], vehiclelist.BodyGroups.On[2] )
		end
		if vehiclelist.Animation then
			ent:PlayAnimation( vehiclelist.Animation.On )
		end
		ent:PlayPP(true)
	end
end)
