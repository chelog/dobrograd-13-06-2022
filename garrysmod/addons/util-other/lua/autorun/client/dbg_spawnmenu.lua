local function clearTabs()

	if not IsValid(g_SpawnMenu) then return end

	local ply = LocalPlayer()
	for k, v in pairs(g_SpawnMenu.CreateMenu.Items) do
		if
			v.Tab:GetText() == language.GetPhrase('spawnmenu.category.npcs') and not serverguard.player:HasPermission(ply, 'DBG: SpawnNPC') or
			v.Tab:GetText() == language.GetPhrase('spawnmenu.category.entities') and not serverguard.player:HasPermission(ply, 'DBG: SpawnSENT') or
			v.Tab:GetText() == language.GetPhrase('spawnmenu.category.weapons') and not serverguard.player:HasPermission(ply, 'DBG: SpawnSWEP') or
			v.Tab:GetText() == language.GetPhrase('spawnmenu.category.vehicles') and not (serverguard.player:HasPermission(ply, 'DBG: SpawnVehicle') or temp[ply:SteamID()]) or
			v.Tab:GetText() == 'simfphys' and not serverguard.player:HasPermission(ply, 'DBG: SpawnSimfphys') or
			v.Tab:GetText() == language.GetPhrase('spawnmenu.category.dupes') or
			v.Tab:GetText() == language.GetPhrase('spawnmenu.category.saves')
		then
			g_SpawnMenu.CreateMenu:CloseTab(v.Tab, true)
			clearTabs()
		end
	end

end
hook.Add('SpawnMenuOpen', 'dbg-spawnmenu', clearTabs)
