halloween.items = halloween.items or {}
halloween.caseItems = halloween.caseItems or {}
halloween.cases = halloween.cases or {}

function halloween.registerItem(id, data)
	if istable(data) or data == nil then
		halloween.items[id] = data
	end
end

function halloween.registerCaseItem(id, data)
	if data == nil then
		halloween.caseItems[id] = nil
		return
	elseif not istable(data) then return end
	data.maxMass, data.maxVolume = data.maxMass or 0, data.maxVolume or 0
	halloween.caseItems[id] = data
end

function halloween.registerCase(id, data)
	if data == nil then
		halloween.cases[id] = nil
		return
	elseif not istable(data) then return end
	data.mass = octolib.array.reduce(data.items, function(a, v) return math.max(a, halloween.caseItems[v[2]].maxMass) end, 0)
	data.volume = octolib.array.reduce(data.items, function(a, v) return math.max(a, halloween.caseItems[v[2]].maxVolume) end, 0)
	octolib.array.shuffle(data.items)
	halloween.cases[id] = data
end

function halloween.getClaimedAmount(ply, id)
	return ply:GetDBVar('hrewards', {})[id] or 0
end

function halloween.getPriceModifier(ply)
	if ply:GetUserGroup() ~= 'user' then return 0.8 end -- 20% discount for staff
	return 1
end

function halloween.sendItems(ply, toSend)
	if #ents.FindByClass('octoinv_mailbox') < 1 then
		ply:Notify('warning', 'На карте нет почтовых ящиков! Обратись к администрации')
		return false
	end

	local itemsPretty = {}
	for _, item in ipairs(toSend) do
		table.insert(itemsPretty, octoinv.itemStr(item))
	end
	hook.Run('octoinv.shop.order', ply, ply, itemsPretty, 0, 'halloween')

	timer.Simple(math.random(60, 120), function()
		local box = octoinv.sendToMailbox(ply, toSend)
		ply:AddMarker({
			txt = 'Хэллоуинская доставка',
			pos = box:GetPos() + Vector(0,0,40),
			col = Color(255,92,38),
			des = {'timedist', { 600, 100 }},
			icon = 'octoteam/icons-16/lorry.png',
		})
		ply:Notify('Твой хэллоуинский заказ доставлен в почтовый ящик!')
	end)
	return true

end

function halloween.claimCase(ply, id, amount, func)

	local case = halloween.cases[id]
	if not case then return func(false) end
	amount = math.min(math.Round(amount), 100, (case.max or math.huge) - halloween.getClaimedAmount(ply, id))
	if amount <= 0 then return func(false) end
	local cost = case.price * amount * halloween.getPriceModifier(ply)
	if ply:GetNetVar('sweets', 0) < cost then
		ply:Notify('warning', 'У тебя недостаточно конфет!')
		return func(false)
	end

	local item = octolib.array.series({'h20_case', { cid = id, mass = case.mass, volume = case.volume, expire = os.time() + 86400 }}, amount)
	local sent, msg = halloween.sendItems(ply, item)

	if sent then
		ply:Notify('hint', 'Загадочная коробка отправлена по почте и придет через пару минут')
		ply:SetDBVar('sweets', ply:GetDBVar('sweets', 0) - cost)
		ply:SetNetVar('sweets', ply:GetDBVar('sweets'))
	else ply:Notify('warning', msg or 'Не удалось отправить загадочную коробку') end

	func(sent)

end

function halloween.claim(ply, id, amount, func)

	func = func or octolib.func.zero
	if not (isstring(id) and isnumber(amount)) then return func(false) end

	if string.StartWith(id, 'case:') then
		return halloween.claimCase(ply, id:sub(6), amount, func)
	end

	local data = halloween.items[id]
	if not data then return func(false) end
	amount = math.min(math.Round(amount), 100, (data.max or math.huge) - halloween.getClaimedAmount(ply, id))
	if amount <= 0 then return func(false) end

	local cost = data.price * amount * halloween.getPriceModifier(ply)
	if ply:GetNetVar('sweets', 0) < cost then
		ply:Notify('warning', 'У тебя недостаточно конфет!')
		return func(false)
	end

	local sid = ply:SteamID()
	local function reward(succ)
		if not succ then return func(false) end
		octolib.getDBVar(sid, 'hrewards', {}):Then(function(items) -- get items data
			items[id] = (items[id] or 0) + 1
			return octolib.setDBVar(sid, 'hrewards', items) -- update items data
		end):Then(function()
			return octolib.getDBVar(sid, 'sweets', 0) -- get sweets amount
		end):Then(function(sweets)
			if IsValid(ply) then ply:SetNetVar('sweets', sweets - cost) end
			return octolib.setDBVar(sid, 'sweets', sweets - cost) -- update sweets amount
		end):Then(function()
			func(succ) -- callback
		end)
	end

	if data.deliver then
		return reward(data.deliver(ply, amount))
	end

	if data.deliverAsync then
		return data.deliverAsync(ply, amount, reward)
	end

	func(false) -- ???

end

function halloween.collectData(ply)
	local items = {}
	local claimed = ply:GetDBVar('hrewards', {})
	local sweets = ply:GetDBVar('sweets', 0)
	local priceMod = halloween.getPriceModifier(ply)
	for k, v in pairs(halloween.items) do
		local amount = math.min(100, (v.max or math.huge) - (claimed[k] or 0), math.floor(sweets / (v.price * priceMod)))
		items[#items + 1] = {
			id = k,
			name = v.name,
			icon = v.icon,
			desc = v.desc,
			max = amount,
			mdl = v.mdl,
			skin = v.skin,
			price = v.price * priceMod,
		}
	end
	local caseItems = octolib.table.map(halloween.caseItems, function(v, k) return { id = k, name = v.name, icon = v.icon } end)
	local cases = {}
	for k, v in pairs(halloween.cases) do
		local amount = math.min(100, (v.max or math.huge) - (claimed[k] or 0), math.floor(sweets / (v.price * priceMod)))
		cases[#cases + 1] = {
			id = k,
			name = v.name,
			icon = v.icon,
			desc = v.desc,
			max = amount,
			price = v.price * priceMod,
			items = v.items,
		}
	end
	return { items = items, caseItems = caseItems, cases = cases }
end

netstream.Hook('dbg-halloween.claim', function(ply, ent, id, amount)
	if not IsValid(ent) or not ent:GetNetVar('Jack') then
		return netstream.Start(ply, 'dbg-halloween.closeRewards')
	end
	local head = ply:GetShootPos()
	if ent:NearestPoint(head):DistToSqr(head) > CFG.useDistSqr then
		return netstream.Start(ply, 'dbg-halloween.closeRewards')
	end

	local responded = false
	local function response()
		if responded then return end
		responded = true
		if not IsValid(ply) then return end
		if ply:GetNetVar('sweets', 0) <= 0 then
			octochat.talkTo(ply, octochat.textColors.rp, 'Джек говорит: ', color_white, 'Здорово поторговались! Спасибо, приятель. Хорошего дня тебе')
			netstream.Start(ply, 'dbg-halloween.closeRewards')
			ply:SetNetVar('sweets')
			ply:SetDBVar('sweets')
		else
			netstream.Start(ply, 'dbg-halloween.openRewards', ent, halloween.collectData(ply), true)
		end
	end
	halloween.claim(ply, id, amount, response)
	timer.Simple(10, response)
end)

netstream.Hook('dbg-halloween.flushRewards', function(ply, ent)
	if not IsValid(ent) or not ent:GetNetVar('Jack') then
		return netstream.Start(ply, 'dbg-halloween.closeRewards')
	end
	local head = ply:GetShootPos()
	if ent:NearestPoint(head):DistToSqr(head) > CFG.useDistSqr then
		return netstream.Start(ply, 'dbg-halloween.closeRewards')
	end

	local sweets = ply:GetDBVar('sweets')
	if not sweets then
		ply:SetNetVar('sweets')
		return netstream.Start(ply, 'dbg-halloween.closeRewards')
	end
	local money = sweets * 65
	ply:BankAdd(money)
	ply:SetDBVar('sweets')
	ply:SetNetVar('sweets')

	octochat.talkTo(ply, octochat.textColors.rp, 'Джек говорит: ', color_white, 'Перевел ' .. DarkRP.formatMoney(money) .. ' тебе на банковский счет')
	netstream.Start(ply, 'dbg-halloween.closeRewards')
end)

-- JACK
local function jackInteraction(self, name, _, ply)

	if not (name == 'Use' and IsValid(ply) and ply:IsPlayer()) then return end
	local ct = CurTime()
	if (ply.nextRewardsUse or 0) > ct then return end

	if ply:GetNetVar('sweets', 0) <= 0 then
		ply.nextRewardsUse = ct + 60
		return octochat.talkTo(ply, octochat.textColors.rp, 'Джек говорит: ', color_white, 'Нет конфет? Очень жаль. Надеюсь, увидимся на следующий Хэллоуин!')
	end
	ply.nextRewardsUse = ct + 2

	netstream.Start(ply, 'dbg-halloween.openRewards', self, halloween.collectData(ply))
	local mod = 1 - halloween.getPriceModifier(ply)
	if mod > 0 then
		octochat.talkTo(ply, octochat.textColors.rp, 'Джек говорит: ', color_white, ('О, мне про тебя рассказывали! Сделаю-ка я тебе скидку в %s%%'):format(mod * 100))
	end

end

local jackSpawns = {
	rp_eastcoast_v4c = { Vector(-1931.4, 1649.8, 1.5), Angle(0, 90, 0) },
	rp_evocity_dbg_210308 = { Vector(-7851.3, -10327, 72), Angle(0, 90, 0) },
}
local function respawnJack()

	for _, v in ipairs(ents.FindByClass('base_ai')) do
		if v:GetNetVar('Jack') then v:Remove() end
	end

	local data = jackSpawns[game.GetMap()]
	if not data then return end

	local jack = ents.Create('base_ai')
	jack:SetPos(data[1])
	jack:SetAngles(data[2])
	jack:SetModel('models/humans/octo/male_09_04.mdl')
	jack:SetSkin(16)

	jack:SetHullType(HULL_HUMAN)
	jack:SetHullSizeNormal()
	jack:SetNPCState(NPC_STATE_SCRIPT)
	jack:SetSolid(SOLID_BBOX)
	jack:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))
	jack:SetUseType(SIMPLE_USE)

	jack:Spawn()
	jack:ResetSequence('idle_all_01')
	jack:SetNetVar('Jack', true)
	jack.AcceptInput = jackInteraction

end
hook.Add('InitPostEntity', 'dbg-halloween.spawnJack', respawnJack)
concommand.Add('jack_reload', function(ply)
	if IsValid(ply) and not ply:IsAdmin() then return end
	respawnJack()
end)
