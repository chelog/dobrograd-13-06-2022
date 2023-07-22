hook.Add('octolib.canUse', 'dobrograd', function(ply)
	if not ply:Alive() or ply:IsGhost() or ply:IsHandcuffed() then
		return false
	end
end)
