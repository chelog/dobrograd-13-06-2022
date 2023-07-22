gmpanel.registerAction('karma', function(obj, ply)
	local status, players = obj.value or nil
	local players = gmpanel.buildTargets(obj.test and {ply:SteamID()} or obj.players or {})
	for _,pl in ipairs(players) do
		pl.karmaDisabled = status
	end

	if obj.test then

		local amount = -1
		local curKarma = ply:GetNetVar('dbg.karma', 0)
		if curKarma > 0 and amount < 0 then
			amount = amount + math.floor(amount * curKarma / 25)
		end

		ply:Notify('Текущая карма: ' .. curKarma)
		timer.Simple(0.2, function()
			if not IsValid(ply) then return end
			ply:AddKarma(-1, 'Ты воспользовался панелью гейм-мастеров.')
			timer.Simple(0.2, function()
				if not IsValid(ply) then return end
				ply:AddKarma(-amount, 'Ты воспользовался панелью гейм-мастеров.')
				ply.karmaDisabled = nil
			end)
		end)

	else ply:Notify('Изменение кармы для игроков в группе ' .. (status and 'от' or 'в') .. 'ключено') end
end)
