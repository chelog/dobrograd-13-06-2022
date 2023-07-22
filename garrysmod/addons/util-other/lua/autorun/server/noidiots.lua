hook.Add('OnPhysgunReload', 'antiPropKill', function(wep, ply)

	return false

end)

hook.Add('PlayerSpawnedProp', 'dbg.noIdiots', function(ply, mdl, ent)

	if IsValid(ent) then
		local mins, maxs = ent:GetModelBounds()
		local size = maxs - mins
		local vol = size.x * size.y * size.z
		if (size.x > 1000 or size.y > 1000 or size.z > 1000 or vol > 2000000) and not (ply:query('DBG: Большие пропы') or ply:GetNetVar('os_build')) then
			ent:Remove()
			ply:Notify('warning', L.too_big)
			return
		end
	end

end)

local minTimeToBuild = 1 * 60 * 60 -- 1 hour
local newbieMsg = 'У тебя недостаточно наигранного времени для того, чтобы начать строить. Советуем уделить первый час игры ознакомлению с механиками сервера!'
local function canSpawn(ply)

	-- lookbook
	if ply:GetDBVar('lookbook') then return end

	if ply:TriggerCooldown('lookbook', 10) then
		local request = {{
			name = 'Стиль построек Доброграда',
			desc = 'Мы заинтересованы в том, чтобы все постройки в городе выглядели естественно и вписывались в общую картину. Похоже, ты собираешься внести свой вклад в эту картину. Пожалуйста, ознакомься с этим списком рекомендаций по постройке, чтобы не испортить ее:',
			buttonText = 'Лукбук Доброграда',
			buttonURL = 'https://octo.gg/lookbook',
		}}
		if CFG.dev or ply:GetTimeTotal() >= minTimeToBuild then
			request[#request + 1] = {
				desc = 'Если администраторы посчитают твою постройку нарушающей общую стилистику Доброграда, они в уведомлении попросят тебя исправить что-то в ней или перестроить вовсе. Если эти просьбы будут проигнорированы, им придется удалить постройку.\n\nОтметь ниже, когда ознакомишься с лукбуком, осознаешь важность поддержания общей стилистики Доброграда и будешь готов украшать город своей постройкой:',
				type = 'check',
				txt = 'Вперед строить!',
				required = true,
			}
		else
			request[#request + 1] = { desc = newbieMsg }
		end
		
		octolib.request.send(ply, request, function(data)
			if not IsValid(ply) then return end
			if not CFG.dev and ply:GetTimeTotal() < minTimeToBuild then
				return ply:Notify('warning', newbieMsg)
			end
			if data and data[2] then
				ply:SetDBVar('lookbook', true)
			end
		end)
	end

	return false

end
hook.Add('PlayerSpawnProp', 'dbg.noIdiots', canSpawn)
hook.Add('PlayerSpawnEffect', 'dbg.noIdiots', canSpawn)
hook.Add('CanTool', 'dbg.noIdiots', canSpawn)

local function freezeRagdoll(ent)
	if ent:GetClass() == 'prop_ragdoll' then
		for i = 0, ent:GetPhysicsObjectCount() - 1 do
			local phys = ent:GetPhysicsObjectNum(i)
			if IsValid(phys) then phys:EnableMotion(false) end
		end
	end
end

hook.Add('octoperma.spawned', 'dbg.freezeRagdolls', function(entities)
	for _, ent in pairs(entities) do
		freezeRagdoll(ent)
	end
end)

local timeForAD2 = 10 * 60 * 60 -- 10 hours
hook.Add('CanTool', 'dbg-tools', function(ply, tr, tool)

	if tool == 'advdupe2' and not CFG.dev and ply:GetTimeTotal() < timeForAD2 then
		ply:Notify('warning', L.need_10_hours)
		return false
	end

	if tool == 'remover' then
		local ent = tr.Entity
		if IsValid(ent) and ent:IsDoor() then return false end
	end

end)

hook.Add('PhysgunPickup', 'dbg.helloFromTawich', function(ply, ent)
	if ent:GetName() == 'trainent' then
		return false
	end
end)

local disabled = octolib.array.toKeys {'octo_trigger', 'octo_trigger_plus'}
hook.Add('PhysgunPickup', 'dbg.helloFromSighty', function(ply, ent)
	if disabled[ent:GetClass()] then
		return false
	end
end)

concommand.Add('gmod_admin_cleanup', function(ply, cmd, args)
	if IsValid(ply) and not ply:IsSuperAdmin() then
		ply:Notify('warning', 'Данная кнопка запломбирована')
	else cleanup.CC_AdminCleanup(ply, cmd, args) end
end, nil, '', {FCVAR_DONTRECORD})

--
-- PROP PUSH FIXES
--
local noPickup = {
	gmod_button = true,
	keypad = true,
}
hook.Add('PhysgunPickup', 'dbg.noPropSurf', function(ply, ent)
	if noPickup[ent:GetClass()] and not ply:IsSuperAdmin() then return false end
end)

local ghost = {
	gmod_button = true,
	keypad = true,
	gmod_light = true,
}
hook.Add('APGisBadEnt', 'dbg.noPropPush', function(ent)
	if ghost[ent:GetClass()] then return true end
end)

-- i think something will be added here later
