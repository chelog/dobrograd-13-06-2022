local meta = FindMetaTable('Player')

function meta:GetOwnedEstates()
	local ests = {}
	local sID = self:SteamID()
	for i,data in pairs(netvars.GetNetVar('dbg-estates') or {}) do
		for _,v in ipairs(data.owners or {}) do
			if v == sID then
				ests[#ests + 1] = i
			end
		end
	end
	return ests
end

function meta:UnownAllDoors()
	local sID, price, amount = self:SteamID(), 0, 0
	for i,v in pairs(netvars.GetNetVar('dbg-estates') or {}) do
		if dbgEstates.removeOwner(i, sID) then
			price = price + (v.price or GAMEMODE.config.doorcost)
			amount = amount + 1
			hook.Run('dbg-estates.unowned', sID, i)
			local doors = dbgEstates.getData(i).doors
			if not doors then return end
			for _,door in ipairs(doors) do
				door:Fire('Close')
				door:DoLock()
				hook.Run('dbg-doors.unowned', door, sID, i)
			end
		end
	end
	return price, amount
end

netstream.Hook('dbg-estates.sellAll', function(ply)
	if not ply:Alive() or ply:IsGhost() then
		return ply:Notify('warning', L.dead_cant_do_this)
	end
	if netvars.GetNetVar('pendingTax') then
		return ply:Notify('warning', 'Скоро платить налоги, подожди')
	end
	local pr, amount = ply:UnownAllDoors()
	pr = math.floor(pr * 0.666 + 0.5)
	ply:addMoney(pr)
	ply:Notify(('Ты продал %s помещени%s за %s'):format(amount, octolib.string.formatCount(amount, 'е', 'я', 'й'), DarkRP.formatMoney(pr)))
end)
