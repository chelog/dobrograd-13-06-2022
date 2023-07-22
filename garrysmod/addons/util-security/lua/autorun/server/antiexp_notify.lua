local bigMoney = 2000000

local function notify(text)
	if not CFG.webhooks.unban then return end

	octoservices:post('/discord/webhook/' .. CFG.webhooks.unban, {
		username = GetHostName(),
		content = text,
	})
end

local function notifyChelog(text)
	if not CFG.webhooks.chelog then return end

	octoservices:post('/discord/webhook/' .. CFG.webhooks.chelog, {
		username = GetHostName(),
		content = text,
	})
end

hook.Add('atm.withdraw', 'antiexp.notify', function(ply, amount)
	if amount < bigMoney then return end

	notify(('<@153885767230291968> %s (%s) снял с банка %s'):format(
		ply:Name(),
		ply:SteamID(),
		DarkRP.formatMoney(amount)
	))
end)

hook.Add('atm.deposit', 'antiexp.notify', function(ply, amount)
	if amount < bigMoney then return end

	notify(('<@153885767230291968> %s (%s) положил в банк %s'):format(
		ply:Name(),
		ply:SteamID(),
		DarkRP.formatMoney(amount)
	))
end)

hook.Add('octoinv.pickup', 'antiexp.notify', function(ply, ent, item, amount)
	if not item or item.class ~= 'money' or (amount or 1) < bigMoney then return end

	notify(('<@153885767230291968> %s (%s) поднял %s'):format(
		ply:Name(),
		ply:SteamID(),
		DarkRP.formatMoney(amount)
	))
end)

hook.Add('octoinv.plymoved', 'antiexp.notify', function(ply, item, from, to, amount)
	if not item or item.class ~= 'money' or (amount or 1) < bigMoney then return end
	if not ply:TriggerCooldown('moveBigMoney', 10) then return end

	notify(('<@153885767230291968> %s (%s) переместил %s'):format(
		ply:Name(),
		ply:SteamID(),
		DarkRP.formatMoney(amount)
	))
end)

hook.Add('octolib.family.newHwids', 'antiexp.notify', function(family, hwids)
	table.sort(family.hwids)
	table.sort(family.steamids)
	table.sort(hwids)

	notifyChelog(('<@153885767230291968> новые ID в семье `%s`:\n```Старые:\n%s\n\nНовые:\n%s```'):format(
		table.concat(family.steamids, ', '), table.concat(family.hwids, '\n'), table.concat(hwids, '\n')
	))
end)

hook.Add('octolib.family.mergedByHwid', 'antiexp.notify', function(families)
	notifyChelog('<@153885767230291968> Объединение семей:\n\n' .. table.concat(octolib.array.map(families, function(family)
		table.sort(family.steamids)
		table.sort(family.hwids)

		return ('```SteamIDs: %s\n\nHWIDs:\n%s```'):format(
			table.concat(family.steamids, ', '),
			table.concat(family.hwids, '\n')
		)
	end), ' '))
end)
