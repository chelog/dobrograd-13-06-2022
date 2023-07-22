local actions = {
	agree = {ACT_GMOD_GESTURE_AGREE,},
	eat = {ACT_GMOD_GESTURE_BECON,},
	bow = {ACT_GMOD_GESTURE_BOW,},
	disagree = {ACT_GMOD_GESTURE_DISAGREE,},
	wave = {ACT_GMOD_GESTURE_WAVE,},
	drop = {ACT_GMOD_GESTURE_ITEM_DROP, ACT_GMOD_GESTURE_ITEM_PLACE,},
	throw = {ACT_GMOD_GESTURE_ITEM_THROW,},
	shove = {ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND, ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,},
	give = {ACT_GMOD_GESTURE_ITEM_GIVE,},
}

local function numpadToggle(ent, bind)
	if not ent.bPressed then
		numpad.Activate( ent.ownerSID, bind, true )
		ent.bPressed = true
	else
		numpad.Deactivate( ent.ownerSID, bind, true )
		ent.bPressed = false
	end
end

local function doPlus(ply, ent, data)
	local owner = ent:CPPIGetOwner()
	if not IsValid(owner) then return false end
	netstream.Start(owner, 'gmpanel.executeObject', data.action, { ply:SteamID() })
end

local function doRegular(ply, ent, data)

	local time = (data.duration or 0)
	local title = string.Trim(data.title or '')
	local text = string.Trim(data.text or '')
	if time > 0 and title ~= '' or text ~= '' then
		if data.method == 'chat' then
			if title == '' then
				title = text
				text = ''
			end
			octochat.talkTo(ply, octochat.textColors.rp, title, ' ', color_white, text)
		elseif data.method == 'notify' then
			ply:Notify(text)
		elseif data.method == 'center' then
			if title ~= '' or text ~= '' then
				ply:Notify('admin', time, title, text)
			end
		end
	end

	local url = data.urlsound and string.Trim(data.urlsound) ~= ''
	if url or (data.gamesound and string.Trim(data.gamesound) ~= '') then
		netstream.Start(ply, 'trigger_sound', 'progress' .. ent:EntIndex(), url, string.Trim(url and data.urlsound or data.gamesound), data.volume or 1, {ent:GetPos(), ent:GetAngles()})
	end

end

hook.Add('KeyRelease', 'dbg-tools.progress', function(ply, key)

	if key ~= IN_USE then return end
	local ent = octolib.use.getTrace(ply).Entity
	if not IsValid(ent) then return end

	local data = ent.delayedActionData
	if not data then return end

	data.done = data.done or {}
	if data.done[ply] then return end

	local keys = {}
	local requirements = data.requirements
	if requirements and not table.IsEmpty(requirements) then
		for _, requirement in ipairs(requirements) do
			local class = requirement.class
			local password = requirement.password
			local amount = requirement.amount
			local item = ply:FindItem(password and password ~= '' and { class = 'key', password = password } or { class = class })

			if item and item:GetData("amount") >= amount then
				keys[item] = {
					amount = item:GetData("amount"),
					container = item:GetParent()
				}
			else
				local msg = password and password ~= '' and data.passwordMsg or data.passwordMsgKey
				if msg and string.Trim(msg) ~= '' then ply:Notify('warning', msg) end
				return
			end
		end
	end

	ply:DelayedAction('progress', data.name or 'Действие', {
		time = data.time or 5,
		check = function()
			if keys then
				for item, data in pairs(keys) do
					if not item then return end
					if item:GetParent() and item:GetParent() ~= data.container or item:GetData("amount") ~= data.amount then return end 
				end
			end

			return octolib.use.check(ply, ent) and ent.delayedActionData
		end,
		succ = function()
			
			if data.action then
				if doPlus(ply, ent, data) == false then return end
			else
				if doRegular(ply, ent, data) == false then return end
			end

			if data.mode == 1 then
				data.done[ply] = true
			elseif data.mode == 2 then
				ent.delayedActionData = nil
			end

			if data.bind then
				numpadToggle(ent, data.bind)
			end

			for _, requirement in pairs(requirements or {}) do
				if requirement.take then
					local class = requirement.class
					local password = requirement.password
					local item = ply:FindItem(password and password ~= '' and { class = 'key', password = password } or { class = class })

					ply:TakeItem(item.class, requirement.amount)
				end
			end
		end,
	}, {
		time = data.animTime or 0.5,
		inst = true,
		action = function()
			if data.animSound then
				ply:EmitSound(data.animSound, 50)
			end
			if data.animAction and actions[data.animAction] then
				ply:DoAnimation(actions[data.animAction][math.random(#actions[data.animAction])])
			end
		end,
	})

end)

duplicator.RegisterEntityModifier('del_action', function(ply, ent, data)
	local override = hook.Run('CanTool', ply, { Entity = ent }, 'del_action')
	if override == false then return end
	if data.action then
		if not IsValid(ply) then return octolib.msg('%s contains progress+ data, which can be pasted by an online player only', ent) end
		if not ply:query('DBG: Панель ивентов') then
			return ply:Notify('warning', 'У тебя нет доступа к панели игровых мастеров, поэтому данные инструмента "Прогресс (расширенный)" не были вставлены')
		end
	end
	ent.ownerSID = IsValid(ply) and ply:SteamID() or ''
	ent.delayedActionData = data
end)
