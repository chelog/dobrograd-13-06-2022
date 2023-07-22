local plugin = plugin
plugin:IncludeFile('shared.lua', SERVERGUARD.STATE.SHARED)

concommand.Add('sgs', function(pPlayer, command, arguments)
	if (arguments and arguments[1]) then
		local commandName = string.lower(arguments[1]);

		if commandName == 'cloak' or commandName == 'invisible' then
			if IsValid(pPlayer) then pPlayer:Say('/invisible') end
			return
		end

		local commandTable = serverguard.command:FindByID(commandName);

		table.remove(arguments, 1);

		if (commandTable) then
			serverguard.command.Run(pPlayer, commandTable.command, true, unpack(arguments));
		end;
	end;
end);

hook.Add('PlayerSwitchWeapon', 'sg-compat', function(ply)
	if ply:GetNoDraw() then
		timer.Simple(0, function()
			ply:DrawWorldModel(false)
		end)
	end
end)

hook.Add('octolib.event:sg', 'sg-compat', function(data)
	octolib.msg('DB ServerGuard command:')
	RunConsoleCommand('sg', unpack(data))
end)
