local function UnderSky2(pos, ply)
	local r = util.QuickTrace(pos, Vector(0,0,262144), ply)
	return r.HitSky and r.HitPos
end

local function isWarm(ply)
	if StormFox2.Temperature.Get() > 2 then return true end
	if ply.warmClothes then return true end
	if ply:Team() == TEAM_ADMIN then return true end
	if hook.Run('dbg-winter.isWarm', ply) == true then return true end
	local veh = ply:GetVehicle()
	if IsValid(veh) and veh.fphysSeat and veh:GetParent():EngineActive() then return true end

	return not UnderSky2(ply:GetPos(), ply)
end

timer.Create('dbg-winter.frost', 10, 0, function()
	octolib.func.throttle(player.GetAll(), 10, 0.1, function(ply)
		if not IsValid(ply) then return end
		if ply:IsAFK() or ply:IsGhost() then return end
		if isWarm(ply) then
			ply:SetNetVar('frost', math.max(ply:GetNetVar('frost', 0) - 3, 0))
		else
			local new = math.min(ply:GetNetVar('frost', 0) + 1, 100)
			ply:SetNetVar('frost', new)
			if new == 50 then ply:Notify(L.frost_hint) end
			if new == 99 then ply:Notify('warning', L.frost_hint2) end
			if new >= 50 and math.random(3) == 1 then ply:EmitSound('ambient/voices/cough'..math.random(1,4)..'.wav', 60) end
			if new >= 100 then
				local h = ply:Health()
				if h > 20 then ply:SetHealth(h - 2) end
			end
		end
	end)
end)

hook.Add('PlayerSpawn', 'dbg-winter', function(ply)
	ply.warmClothes = nil
	ply:SetNetVar('frost', 0)
end)

hook.Add('KeyRelease', 'dbg-winter.snowball', function(ply, key)
	if key ~= IN_USE then return end

	local hand = ply:GetInventory():GetContainer('_hand')
	if not hand then return end

	local tr = octolib.use.getTrace(ply)
	if IsValid(tr.Entity) or tr.MatType ~= MAT_SNOW then return end

	ply:DelayedAction('snowball', 'Лепка снежка', {
		time = 2.5,
		check = function()
			local tr = octolib.use.getTrace(ply)
			return not IsValid(tr.Entity) and tr.MatType == MAT_SNOW and ply:GetInventory():GetContainer('_hand') ~= nil
		end,
		succ = function()
			hand:AddItem('throwable', {
				name = 'Снежок',
				usesLeft = 1,
				gc = 'ent_dbg_snowball',
				desc = 'Брр... Холодный!',
				icon = 'octoteam/icons/snowball.png',
				model = 'models/weapons/w_snowball_thrown.mdl',
				expire = os.time() + 20,
			})
		end,
	}, {
		time = 1.5,
		inst = true,
		action = function()
			ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0, 1))
			ply:EmitSound('player/footsteps/snow' .. math.random(1, 6) .. '.wav')
		end,
	})
end)
