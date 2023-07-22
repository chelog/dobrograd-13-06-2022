hook.Add('octolib.launcherValidationUpdate', 'antiexp.launcher', function(ply, ok, errMsg)
	if not CFG.requireLauncher then return end

	local timerName = 'antiexp.launcher.kick' .. ply:SteamID64()
	if ok then
		if not ply:GetNetVar('launcherActivated') then
			ply:SetGhost(false)

			-- undo ghost look
			ply:GodDisable()
			ply:SetColor(Color(255, 255, 255, 255))
			ply:SetRenderMode(RENDERMODE_NORMAL)
			ply:SetCustomCollisionCheck(false)
			ply:CollisionRulesChanged()
			ply:DrawShadow(true)
			ply:SetMaterial('')
			ply:SetBloodColor(BLOOD_COLOR_RED)
			ply:SetAvoidPlayers(false)

			ply:SetNetVar('launcherActivated', true)
			ply.passedTest = nil
			dbgTest.spawned(ply)

			timer.Simple(1, function()
				netstream.Start(nil, 'dbg-score.update')
			end)
		elseif timer.Exists(timerName) then
			timer.Remove(timerName)
			ply:Notify('hint', 'Соединение с лаунчером восстановлено')
		end
	else
		if ply.launcherValidated == nil then
			ply:SetModel('models/humans/octo/male_01_01.mdl')
			ply:SetGhost(true)
			ply:Spawn()
			ply:StripWeapons()
			ply:Give('dbg_hands')
		end

		if ply:GetNetVar('launcherActivated') and not timer.Exists(timerName) then
			ply:Notify('warning', 'Мы потеряли соединение с твоим лаунчером. Включи его в течение 3 минут или тебя отсоединит от сервера')
			timer.Create(timerName, 180, 1, function()
				if not IsValid(ply) then return end
				ply:Kick('Истекло время ожидания ответа от лаунчера')
			end)
		end
	end
end)

hook.Add('PlayerSay', 'antiexp.launcher', function(ply, text)
	if text:sub(1, 1) ~= '@' and not ply:GetNetVar('launcherActivated') then
		ply:Notify('warning', 'Без лаунчера можно только открыть жалобу, начав сообщение со знака @')
		return ''
	end
end, -7)

hook.Add('PlayerCanHearPlayersVoice', 'antiexp.launcher', function(listener, talker)
	if not talker:GetNetVar('launcherActivated') then
		return false
	end
end)

hook.Add('PlayerInitialSpawn', 'antiexp.launcher', function(ply)
	if ply.launcherValidated ~= nil then return end

	ply:SetGhost(true)
	ply:Spawn()
	ply:StripWeapons()
	ply:Give('dbg_hands')
end)
