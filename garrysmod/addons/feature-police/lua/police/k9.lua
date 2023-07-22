local k9Whitelist = octolib.array.toKeys { '/me', '/it', '/pit', '/looc', '/ooc', '/pm', '//it', '/roll', '!invisible', '/spawn', '/spectate', '/admintell', '/admintellall' }

hook.Add('octochat.canExecute', 'dbg-police.k9', function(ply, cmd)
	if not k9Whitelist[cmd] and ply:getJobTable().notHuman then return false, 'Ты не человек...' end
end)

hook.Add('PlayerSay', 'dbg-police.k9', function(ply)
	if ply:getJobTable().notHuman then
		ply:Notify('warning', 'Ты не человек...')
		return ''
	end
end, 1)

hook.Add('octolib.shouldOpenMenu', 'dbg-police.k9', function()
	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) and wep:GetClass() == 'dbg_dog' then return false end
end)
