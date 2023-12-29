hook.Add('PlayerEnteredPVS', 'octolib-anim', function(tgt, ply)

	local catID, animID
	if istable(tgt.octolib_customAnim) then
		catID, animID = unpack(tgt.octolib_customAnim)
	end
	netstream.Start(ply, 'player-custom-anim', tgt, catID, animID)
	netstream.Start(ply, 'player-flex', tgt, tgt.octolib_flexes)

end)

local function stop(ply)
	octolib.stopAnimations(ply)
end
hook.Add('PlayerEnteredVehicle', 'octolib-anim', stop)
hook.Add('PlayerSwitchWeapon', 'octolib-anim', stop)
