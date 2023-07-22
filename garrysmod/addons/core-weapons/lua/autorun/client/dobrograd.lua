hook.Add('PlayerSwitchWeapon', 'dbg.weaponGroups', function()
	return true
end)

hook.Add('PlayerFinishedLoading', 'dbg.weapons', function()
	weapons.GetStored('gmod_tool').ShootSound = ''
end)
