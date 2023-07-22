netstream.Hook('og.setMember', function(ply, gID, sID)

	if not (gID and sID) then return end
	if not og.hasPerm(gID, ply:SteamID(), 'setMember') then return end

	local g = og.groups[gID]
	local tgt = player.GetBySteamID(sID)
	if not g or not IsValid(tgt) or g.members[sID] then return end

	ply:Notify('%s получил твое приглашение', tgt:Name())

	octolib.request.send(tgt, {{
		name = 'Приглашение',
		desc = ('Ты получил приглашение в группу %s от игрока %s. Нажми Отправить, чтобы согласиться, или закрой окно, чтобы отказаться'):format(g.name, ply:Name()),
	}}, function()
		og.setMember(gID, sID, 'member')
		if IsValid(ply) then ply:Notify('%s принял твое приглашение', tgt:Name()) end
	end, function()
		if IsValid(ply) then ply:Notify('%s отклонил твое приглашение', tgt:Name()) end
	end)

end)

netstream.Hook('og.setRank', function(ply, gID, sID, rank)

	if not (gID and sID) then return end
	if not og.hasPerm(gID, ply:SteamID(), 'setRank') then return end

	local g = og.groups[gID]
	if not g then return end

	local m = g.members[sID]
	if not m then return end

	local r = g.ranks[rank or '']
	local my, his, new = og.getOrder(gID, ply:SteamID()), og.getOrder(gID, sID), r and r.order or -1
	if my <= his or my <= new then return end

	og.setMember(gID, sID, rank)

end)

netstream.Hook('og.setSetting', function(ply, gID, name, val)

	if not (gID and name and val) then return end
	if not og.hasPerm(gID, ply:SteamID(), 'setSetting') then return end

	og.setSetting(gID, name, val)

end)

netstream.Hook('og.editRank', function(ply, gID, rank, data)

	if not (gID and rank) then return end
	if not og.hasPerm(gID, ply:SteamID(), 'editRank') then return end

	og.editRank(gID, rank, data)

end)

netstream.Hook('og.addedMoney', function(ply, gID, val)

	if not (gID and val) then return end
	if val > 0 then
		if not ply:BankHas(val) then
			ply:Notify('warning', 'У тебя в банке не хватает денег')
			return
		end

		ply:BankAdd(-val)
		og.addMoney(gID, val)
		ply:Notify(('Ты внес %s в группу'):format(DarkRP.formatMoney(val)))
	elseif og.hasPerm(gID, ply:SteamID(), 'useMoney') then
		val = -val
		if not og.hasMoney(gID, val) then
			ply:Notify('warning', 'В банке группы не хватает денег')
			return
		end

		og.addMoney(gID, -val)
		ply:BankAdd(val)
		ply:Notify(('Ты снял %s со счета группы'):format(DarkRP.formatMoney(val)))
	end

end)
