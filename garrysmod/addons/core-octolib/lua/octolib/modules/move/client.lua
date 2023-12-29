if CFG.disabledModules.move then return end

local cmds = {'duck', 'attack2'}

local last, is, cvar = {}, {}, {}
hook.Add('Think', 'octolib.move', function()
	hook.Remove('Think', 'octolib.move')
	timer.Simple(1, function()
		for i, cmd in ipairs(cmds) do cvar[cmd] = CreateClientConVar('cl_octolib_sticky_' .. cmd, '1') end
	end)
end)

hook.Add('PlayerBindPress', 'octolib.move', function(ply, bind, pressed)

	for i, cmd in ipairs(cmds) do
		if bind == '+' .. cmd and cvar[cmd] and cvar[cmd]:GetBool() then
			if is[cmd] then
				RunConsoleCommand('-' .. cmd)
				is[cmd] = false
			else
				if CurTime() - (last[cmd] or 0) < 0.3 then
					RunConsoleCommand('+' .. cmd)
					is[cmd] = true
				end
				last[cmd] = CurTime()
			end
		end
	end

end)
