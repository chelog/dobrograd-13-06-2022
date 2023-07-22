function octochat.canExecuteCommand(ply, alias, args, txt)
	local data = octochat.commands[alias]
	if data == nil then
		return true
	end

	local can, why = true
	if istable(data) then
		if isstring(data.permission) then
			can, why = ply:query(data.permission)
		end
		if isfunction(data.check) then
			can, why = data.check(ply, txt, args, alias, data.name)
		end
		if can == false then return false, why or 'Ты не можешь выполнять эту команду' end
	end

	can, why = hook.Run('octochat.canExecute', ply, istable(data) and data.name or alias, txt, args, alias)
	if can == false then
		return false, why or 'Ты не можешь выполнять эту команду'
	end

	return true
end
