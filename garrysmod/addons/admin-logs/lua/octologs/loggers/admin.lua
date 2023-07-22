local noLogCmds = octolib.array.toKeys({ 'mute', 'gag', 'invisible' })
hook.Add('serverguard.RanCommand', 'octologs', function(ply, commandTable, silent, _args)

	local cmdStr = commandTable.command
	if noLogCmds[cmdStr] or noLogCmds[cmdStr:gsub('un', '')] then return end

	if _args and #_args > 0 then
		cmdStr = cmdStr .. ' ' .. table.concat(_args, ' ')
	end

	octologs.createLog(octologs.CAT_ADMIN)
		:Add(octologs.ply(ply), ' used SG command: ', octologs.string(cmdStr))
	:Save()

end)

hook.Add('octoinv.adminGive', 'octologs', function(ply, item)

	if item and IsValid(ply) and ply:IsPlayer() then
		local class = item.class
		local name = item.name or octoinv.items[item.class].name
		local itemStr = ('%sx[%s, %s]'):format(item.amount or 1, class, name)
		octologs.createLog(octologs.CAT_ADMIN)
			:Add(octologs.ply(ply), ' created ', octologs.table(itemStr, item, true))
		:Save()
	end

end)

hook.Add('dbg-admin.tell', 'octologs', function(ply, time, title, msg, target)
	octologs.createLog(octologs.CAT_ADMIN)
		:Add(octologs.ply(ply, {'loc', 'wep', 'job', 'hp', 'ar'}), ' sent ')
		:Add(octologs.table('AdminTell', {time = time, title = title, msg = msg}, true), ' to ')
		:Add(IsValid(target) and octologs.ply(target) or octologs.string('everyone'))
	:Save()
end)

hook.Add('cats.created', 'octologs', function(senderID)
	local sender = player.GetBySteamID(senderID)
	octologs.createLog(octologs.CAT_ADMIN)
		:Add(IsValid(sender) and octologs.ply(sender, {'loc', 'wep', 'job', 'hp', 'ar'}) or octologs.string(senderID))
		:Add(' created a ticket')
	:Save()
end)

hook.Add('cats.message', 'octologs', function(senderID, ticketID, msg)
	local sender = player.GetBySteamID(senderID)
	local owner = player.GetBySteamID(ticketID)
	octologs.createLog(octologs.CAT_ADMIN)
		:Add(IsValid(sender) and octologs.ply(sender, {'loc', 'wep', 'job', 'hp', 'ar'}) or octologs.string(senderID), ' sent message to ')
		:Add(IsValid(owner) and octologs.ply(owner, {'loc', 'wep', 'job', 'hp', 'ar'}) or octologs.string(ticketID))
		:Add('\'s ticket: ', msg)
	:Save()
end)

hook.Add('cats.closed', 'octologs', function(senderID, ticketID)
	local sender = player.GetBySteamID(senderID)
	local owner = player.GetBySteamID(ticketID)
	octologs.createLog(octologs.CAT_ADMIN)
		:Add(IsValid(sender) and octologs.ply(sender, {'loc', 'wep', 'job', 'hp', 'ar'}) or octologs.string(senderID), ' closed ')
		:Add(IsValid(owner) and octologs.ply(owner, {'loc', 'wep', 'job', 'hp', 'ar'}) or octologs.string(ticketID), '\'s ticket')
	:Save()
end)

hook.Add('cats.claim', 'octologs', function(senderID, ticketID, doClaim)
	local sender = player.GetBySteamID(senderID)
	local owner = player.GetBySteamID(ticketID)
	octologs.createLog(octologs.CAT_ADMIN)
		:Add(IsValid(sender) and octologs.ply(sender, {'loc', 'wep', 'job', 'hp', 'ar'}) or octologs.string(senderID), doClaim and ' claimed ' or ' unclaimed ')
		:Add(IsValid(owner) and octologs.ply(owner, {'loc', 'wep', 'job', 'hp', 'ar'}) or octologs.string(ticketID), '\'s ticket')
	:Save()
end)

hook.Add('dbg-test.edit', 'octologs', function(ply)
	octologs.createLog(octologs.CAT_ADMIN)
		:Add(octologs.ply(ply, {'loc', 'wep', 'job', 'hp', 'ar'}), ' edited test')
	:Save()
end)
