hook.Add('dbg-char.spawn', 'octolib.backup', function(ply)

	if ply.restoringBackup then return end
	ply.restoringBackup = true
	timer.Simple(4, function()
		if IsValid(ply) then
			octolib.restoreBackup(ply)
			ply.restoringBackup = nil
		end
	end)

end)
