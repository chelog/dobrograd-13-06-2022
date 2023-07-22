local advertPrice = 250
octochat.registerCommand('/advert', {
	log = true,
	phone = true,
	execute = function(ply, txt)
		if not ply:Alive() or ply:IsGhost() then
			return L.death_cannot_do_this
		end
		if ply:isArrested() then
			return L.you_arrested
		end
		if ply:IsHandcuffed() then
			return L.handcuffed_cannot_do_this
		end

		if not ply:BankHas(advertPrice) then
			return L.advert_money:format(DarkRP.formatMoney(advertPrice))
		end

		netstream.Start(ply, 'octochat.advert', txt, ply:GetCooldown('advert') and math.ceil(ply:GetCooldown('advert') - CurTime()) or 0)

	end,
	aliases = {'/ad'},
})

netstream.Hook('octochat.advert', function(ply, txt)
	local nextAdvert = ply:GetCooldown('advert')
	if nextAdvert then return ply:Notify('warning', 'Следующую рекламу можно будет отправить через ' .. niceTime(nextAdvert - CurTime())) end
	if txt == '' then return ply:Notify('warning', 'Формат: /advert Текст сообщения') end
	txt = txt:gsub('\n', ' ')
	ply:BankAdd(-advertPrice)
	for _, v in ipairs(player.GetAll()) do
		if v:HasPhone() then
			octochat.talkTo(v, octochat.textColors.rp, L.advert_hint, ply:Name(), ': ', Color(250,250,200), unpack(octolib.string.splitByUrl(txt)))
		end
	end
	ply:TriggerCooldown('advert', 5 * 60)
end)

local function sayThroughRadio(ply, txt, distance, action, color, noTalk)

	if txt == '' then return end

	if not ply:Alive() or ply:IsGhost() then
		return L.death_cannot_do_this
	end
	if ply:isArrested() then
		return L.you_arrested
	end
	if ply:IsHandcuffed() then
		return L.handcuffed_cannot_do_this
	end
	if not ply:HasTalkie() then
		return L.you_dont_have_radio
	end
	if ply:IsTalkieDisabled() then
		return 'Твоя рация отключена'
	end
	local freq = ply:GetFrequency()
	if not ply:CanSpeakToChannel(freq, true) then
		return 'Микрофон твоей рации сломан'
	end

	local sources = {ply}
	for _, v in ipairs(player.GetAll()) do
		if v == ply then continue end
		if not v:HasTalkie() or v:IsTalkieDisabled() then continue end
		local vFreq = v:GetFrequency()
		if vFreq ~= freq then
			if v:GetNetVar('NoTalkieParenting') then continue end
			local chan = talkie.channels[vFreq]
			if not chan or not chan.parent or chan.parent ~= freq then continue end
		end
		if v:CanListenToChannel(vFreq, true) then sources[#sources + 1] = v end
	end

	local heard = octolib.array.toKeys(sources)
	local shouldTalk, voice, hideTalkieMessage = not noTalk and ply:GetNetVar('os_govorilka') and not ply:IsGovorilkaMuted(), ply:GetVoice(), hook.Run('dbg-talkie.hideTalkieMessage', ply)
	local hearsFunc = function(v)
		if v:IsPlayer() and not heard[v] then
			heard[v] = true
			return true
		else return false end
	end
	for _, source in ipairs(sources) do
		if source ~= ply then
			source:EmitSound('npc/combine_soldier/vo/off' .. math.random(1,2) ..  '.wav', 45)
		end

		local hears = octolib.array.filter(ents.FindInSphere(source:GetShootPos(), distance), hearsFunc)
		if source ~= ply then
			if not hideTalkieMessage then
				octochat.talkTo(hears, color or octochat.textColors.rp, 'Кто-то', action .. ' из рации: ', color_white, txt)
			end
			octochat.talkTo(source, color or octochat.textColors.rp, ply:Name(), action .. ' из рации: ', color_white, txt)
		else
			octochat.talkTo(hears, color or octochat.textColors.rp, ply:Name(), action .. ' в рацию: ', color_white, txt)
			octochat.talkTo(source, color or octochat.textColors.rp, ply:Name(), action .. ' в рацию: ', color_white, txt)
		end

		if shouldTalk then
			hears[#hears + 1] = source
			source:DoVoice(txt, voice, hears)
		end

	end

end
octochat.registerCommand('/radio', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, txt)
		sayThroughRadio(ply, txt, CFG.radioChatDistance, ' говорит')
	end,
	aliases = {'/r'},
})
octochat.registerCommand('/wradio', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, txt)
		sayThroughRadio(ply, txt, CFG.radioChatDistance * 0.36, ' шепчет')
	end,
	aliases = {'/wr'},
})
octochat.registerCommand('/yradio', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, txt)
		if txt == '' then return end
		if txt:sub(-1) ~= '!' then txt = txt .. '!' end
		sayThroughRadio(ply, txt, CFG.radioChatDistance * 2.2, ' кричит')
	end,
	aliases = {'/yr'},
})
octochat.registerCommand('/lradio', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, txt)
		if txt == '' then return end
		sayThroughRadio(ply, txt, CFG.radioChatDistance, ' говорит', octochat.textColors.ooc, true)
	end,
	aliases = {'/lr'},
})

local leaveMeAloneID = 1
local function callTeam(ply, who, emote, txt, group, icon, filterFunc)

	local people = octolib.array.filter(player.GetAll(), filterFunc)
	if not people[1] then ply:Notify('warning', ('В городе сейчас нет %s, поэтому реагировать на вызов некому'):format(who)) return end

	local msg = L.prefix_request:format(DarkRP.nextEMSRequest, ply:Name())
	local marker = {
		id = group .. leaveMeAloneID,
		group = group,
		txt = L.police_call .. DarkRP.nextEMSRequest,
		pos = ply:GetPos() + Vector(0,0,40),
		col = Color(235,120,120),
		des = {'timedist', {600, 300}},
		icon = octolib.icons.silk16(icon),

	}

	octolib.request.send(ply, {{
		type = 'check',
		name = 'Вызов ' .. who,
		desc = msg .. txt,
		txt = 'Отправить координаты вызова',
	}}, function(data)
		local sendPos = tobool(data and data[1])

		ply:DoEmote(emote)

		octochat.talkTo(ply, octochat.textColors.rp, msg, color_red, txt)
		for _, v in ipairs(people) do
			octochat.talkTo(v, octochat.textColors.rp, msg, color_red, txt)
			if sendPos then v:AddMarker(marker) end
			v:EmitSound('ambient/chatter/cb_radio_chatter_' .. math.random(1,3) .. '.wav', 45, 100, 0.5)
		end

		ply.nextEMSRequest = CurTime() + 10
		leaveMeAloneID = leaveMeAloneID + 1
	end)

	return true

end

octochat.registerCommand('/callmed', {
	cooldown = 60,
	log = true,
	phone = true,
	execute = function(ply, txt)
		callTeam(ply, 'медицинских работников', '{name} вызывает врача', txt, 'med', 'asterisk_orange', DarkRP.isMedic)
	end,
})

octochat.registerCommand('/callmech', {
	cooldown = 60,
	log = true,
	phone = true,
	execute = function(ply, txt)
		callTeam(ply, 'автомехаников', L.call_mech_hint, txt, 'mech', 'wrench', DarkRP.isMech)
	end,
})

octochat.registerCommand('/callfire', {
	cooldown = 0,
	log = true,
	phone = true,
	execute = function(ply, txt)
		callTeam(ply, 'спасателей', '{name} вызывает пожарных', txt, 'fire', 'fire', DarkRP.isFirefighter)
	end,
})

octochat.registerCommand('/callworker', {
	cooldown = 60,
	log = true,
	phone = true,
	execute = function(ply, txt)
		callTeam(ply, 'городских рабочих', '{name} вызывает городского рабочего', txt, 'worker', 'wrench', DarkRP.isWorker)
	end,
})

octochat.registerCommand('/calltaxi', {
	cooldown = 60,
	log = true,
	phone = true,
	execute = function(ply, txt)
		callTeam(ply, 'таксистов', '{name} вызывает такси', txt, 'taxi', 'car_taxi', DarkRP.isTaxist)
	end,
})

octochat.registerCommand('/givecert', {
	cooldown = 15,
	log = true,
	execute = function(ply)

		local tgt = octolib.use.getTrace(ply).Entity
		if not IsValid(tgt) or not tgt:IsPlayer() then tgt = ply end

		local curCert, allowed = tgt:GetDBVar('cert'), ply:GetDBVar('allowedCert')
		if not allowed then
			return 'Ты не можешь выдавать удостоверения'
		end
		if curCert and curCert.id ~= allowed.id then
			return 'Этот игрок уже имеет удостоверение другой организации'
		end
		if not allowed.title then
			allowed.title = dbgCerts.certTitles[allowed.id] or 'Удостоверение'
			ply:SetDBVar('allowedCert', allowed)
		end

		local issue, rem = os.time(), os.time() + allowed.period * 24 * 60 * 60
		octolib.request.send(ply, {
			{
				name = 'Доп. поле',
				type = 'strShort',
				ph = 'Отсутствует',
				default = curCert and curCert.add or 'Код ' .. math.random(100000, 999999),
			}, {
				name = 'Кому выдано',
				type = 'strShort',
				desc = '(' .. tgt:Name() .. ' в дательном падеже)',
				ph = 'Не показывать',
				default = curCert and curCert.em or '',
			}, {
				name = 'Должность',
				type = 'strShort',
				ph = 'Отсутствует',
				default = curCert and curCert.pos or '',
			}, {
				name = 'Дата выдачи',
				desc = os.date('%d.%m.%Y', issue),
			}, {
				name = 'Действ. до',
				desc = os.date('%d.%m.%Y', rem),
			}, {
				desc = 'Пожалуйста, внимательно пересмотри ВСЕ пункты!',
			},
		}, function(data)
			if not IsValid(tgt) then
				return ply:Notify('Игрок вышел :(')
			end
			for i = 1, #data do
				data[i] = string.Trim(data[i])
				data[i] = data[i] ~= '' and data[i] or nil
			end
			if dbgCerts.give(tgt, allowed.id, allowed.title, data[1], data[2], data[3], issue, rem) then
				ply:Notify('Выдано удостоверение:')
				dbgCerts.show(tgt, ply, true, true)
				dbgCerts.show(tgt, tgt, true, true)
			else ply:Notify('warning', 'Не получилось выдать удостоверение') end
		end)

	end,
})

octochat.registerCommand('/delcert', {
	cooldown = 15,
	log = true,
	execute = function(ply)

		local tgt = octolib.use.getTrace(ply).Entity
		if not IsValid(tgt) then
			return L.must_be_looking_at:format('игрока')
		end

		local cert, allowed = tgt:GetDBVar('cert'), ply:GetDBVar('allowedCert')
		if not allowed and ply:Team() ~= TEAM_ADMIN then
			return 'Ты не можешь выдавать удостоверения'
		end
		if not cert then
			return 'У этого игрока нет удостоверения'
		end
		if cert.vthru < os.time() or not dbgCerts.certTitles[cert.id] then
			tgt:SetDBVar('cert', nil)
			return 'У этого игрока нет удостоверения'
		end
		if cert.id ~= allowed.id and ply:Team() ~= TEAM_ADMIN then
			return 'Этот игрок имеет удостоверение другой организации'
		end

		local sid = tgt:SteamID()
		octolib.request.send(ply, {
			{
				name = 'Вид',
				desc = dbgCerts.certTitles[cert.id],
			}, {
				name = 'Доп. поле',
				desc = cert.add or 'Отсутствует'
			}, {
				name = 'Кому выдано',
				desc = cert.em or 'Не указано',
			}, {
				name = 'Должность',
				desc = cert.pos or 'Не указана',
			}, {
				name = 'Дата выдачи',
				desc = os.date('%d.%m.%Y', cert.iss),
			}, {
				name = 'Действ. до',
				desc = os.date('%d.%m.%Y', cert.vthru),
			}, {
				desc = 'Удалить удостоверение игрока?',
			},
		}, function()
			octolib.setDBVar(sid, 'cert', nil)
			ply:Notify('Удостоверение удалено')
		end)

	end,
})

octochat.registerCommand('/ammo', {
	cooldown = 1.5,
	execute = function(ply)

		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) or wep:Clip1() == -1 then
			return 'Для этого нужно держать в руках оружие'
		end

		ply:DoEmote('{name} проверяет магазин')
		timer.Simple(1, function()

			if not IsValid(wep) then return 'Для этого нужно держать в руках оружие' end

			ply:Notify('Патронов в магазине: ' .. wep:Clip1())
			if wep:HasAmmo() then
				ply:Notify('Патронов в запасе: ' .. wep:Ammo1())
			end

		end)

	end,
})

octochat.registerCommand('/getbank', {
	cooldown = 1.5,
	phone = true,
	execute = function(ply)
		ply:DoEmote('{name} проверяет счет в банке')
		timer.Simple(1, function()
			ply:Notify('Твой баланс в банке: ' .. DarkRP.formatMoney(BraxBank.PlayerMoney(ply)))
		end)
	end,
	aliases = {'/bank'},
})

octochat.registerCommand('/time', {
	cooldown = 1.5,
	execute = function(ply)
		ply:DoEmote(L.see_time_hint)
		timer.Simple(1, function()
			ply:Notify(L.the_clock_shows:format(CWI.TimeToString()))
		end)
	end,
})

octochat.registerCommand('/title', {
	log = true,
	execute = function(ply, title)

		local door = ply:GetEyeTrace().Entity
		if not IsValid(door) or not door:IsDoor() then
			return L.must_be_looking_at:format(L.door)
		end

		if door:NearestPoint(ply:GetShootPos()):DistToSqr(ply:GetShootPos()) > CFG.useDistSqr then
			return L.must_be_looking_at:format(L.door)
		end

		if door:GetPlayerOwner() ~= ply:SteamID() and not ply:IsSuperAdmin() then
			return L.this_is_not_your_door
		end

		if title == '' then title = nil end
		door:SetTitle(title)

	end,
})

octochat.registerCommand('/write', {
	cooldown = 10,
	execute = function(ply)

		if ply:GetLetterCount() >= 3 then return L.too_much_letter end

		local letter = ents.Create 'letter'
		letter:SetNetVar('Owner', ply)
		letter:SetPos(octolib.use.getTrace(ply).HitPos)
		letter.nodupe = true
		letter:Spawn()
		letter.SID = ply.SID

	end,
})

octochat.registerCommand('/removewrite', {
	cooldown = 10,
	execute = function(ply)
		local ent = octolib.use.getTrace(ply).Entity
		if IsValid(ent) and ent:GetClass() == 'letter' and (ent:GetNetVar('Owner') == ply or ply:IsAdmin()) then
			ent:Remove()
		end
	end,
})

octochat.registerCommand('/removewrites', {
	cooldown = 10,
	execute = function(ply)
		for _,v in ipairs(ents.FindByClass('letter')) do
			if v:GetNetVar('Owner') == ply then
				v:Remove()
			end
		end
	end,
})

octochat.registerCommand('/dropweapon', {
	execute = function(ply)

		local ent = ply:GetActiveWeapon()
		if not IsValid(ent) or not ent:GetModel() or ent:GetModel() == '' then
			return L.cannot_drop_weapon
		end

		if not hook.Run('canDropWeapon', ply, ent) then return L.cannot_drop_weapon end

		ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP)
		timer.Simple(0.88, function()

			if not IsValid(ply) or not IsValid(ent) or not ent:GetModel() or ent:GetModel() == '' then return end

			local pos, ang = ply:GetBonePosition(ply:LookupBone('ValveBiped.Bip01_L_Hand') or 16)
			local vel = ply:GetAimVector()
			vel.z = 0
			ply:dropDRPWeapon(ent, pos, ang, vel * 200)

		end)

	end,
	aliases = {'/drop'},
	cooldown = 1,
})

octochat.registerCommand('/holsterweapon', {
	execute = function(ply)

		local ent = ply:GetActiveWeapon()
		if not IsValid(ent) or not ent:GetModel() or ent:GetModel() == '' then
			return L.cannot_drop_weapon
		end

		if not hook.Run('canDropWeapon', ply, ent) then return L.cannot_drop_weapon end

		ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP)
		timer.Simple(0.88, function()
			if IsValid(ply) and IsValid(ent) and ent:GetModel() and ent:GetModel() ~= '' and ent:GetOwner() == ply then
				ply:HolsterWeapon(ent)
			end
		end)

	end,
	aliases = {'/holster'},
	cooldown = 1,
})

local function wearMask(ply, class)
	local mask = ply:GetNetVar('hMask')
	if mask and mask[1] ~= class then return 'Нужно снять аксессуар' end
	if mask then ply:SetNetVar('hMask') return end
	ply:SetNetVar('hMask', {class, unequip = true})
end

octochat.registerCommand('/gasmask', {
	cooldown = 1.5,
	execute = function(ply)
		wearMask(ply, 'gasmask')
	end,
	check = function(ply)
		return ply:GetActiveRank('dpd') == 'swat' or ply:GetActiveRank('wcso') == 'seb'
	end,
})

octochat.registerCommand('/medmask', {
	cooldown = 1.5,
	execute = function(ply)
		wearMask(ply, 'medical_mask')
	end,
	check = function(ply)
		return ply:isMedic()
	end,
})
