octolib.restart = octolib.restart or {}

function octolib.restart.trigger()
	RunConsoleCommand('sv_hibernate_think', '1')

	hook.Add('CheckPassword', 'octolib.restart', function(sid, ip, sv, cl, name)
		return false, 'Идет перезагрузка, подожди пару минут...'
	end)

	timer.Simple(5, function()
		RunConsoleCommand('_restart')
	end)

	for _, ply in ipairs(player.GetAll()) do
		ply:Kick('Перезагружаемся, присоединяйся через пару минут...')
	end
end

function octolib.restart.schedule(time)
	timer.Create('octolib.restart', time, 1, octolib.restart.trigger)
	netstream.Start(nil, 'octolib.restart', time)

	local startTime = CurTime()
	hook.Add('PlayerFinishedLoading', 'octolib.restart', function(ply)
		local timePassed = CurTime() - startTime
		netstream.Start(ply, 'octolib.restart', time - timePassed)
	end)
end

function octolib.restart.cancel()
	timer.Remove('octolib.restart')
	hook.Remove('PlayerFinishedLoading', 'octolib.restart')
	hook.Remove('CheckPassword', 'octolib.restart')
	netstream.Start(nil, 'octolib.restart', false)
end

concommand.Add('octolib_restart', function(ply, cmd, args)
	if IsValid(ply) and not ply:IsSuperAdmin() then return end

	local time = tonumber(args[1])
	if not time then return end

	octolib.restart.schedule(time)
end)

concommand.Add('octolib_restart_cancel', function(ply, cmd, args)
	if IsValid(ply) and not ply:IsSuperAdmin() then return end

	octolib.restart.cancel()
end)
