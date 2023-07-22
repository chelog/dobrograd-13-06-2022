gmpanel.registerAction('hunger', function(obj, ply)
	local status, players = obj.value or nil
	local players = gmpanel.buildTargets(obj.players or {})
	for _,pl in ipairs(players) do
		pl.hungerDisabled = status
	end

	ply:Notify('Изменение голода для игроков в группе ' .. (status and 'от' or 'в') .. 'ключено')
end)

hook.Add('hungerUpdate', 'gmpanel', function(ply)
	if ply.hungerDisabled then return true end
end)
