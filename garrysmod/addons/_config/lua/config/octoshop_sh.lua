--
-- SALARY
--

octoshop.salaryAFKTime = 45 -- seconds
octoshop.salaryPeriod = 60 -- minutes

--
-- MISC FUNCTIONS
--

octoshop.openTopup = function(but, pnl)

	F4:Hide()
	gui.ActivateGameUI()
	octoesc.OpenURL('https://octothorp.team/shop/chips?steamid=' .. LocalPlayer():SteamID())

end

local owners = {
	['STEAM_0:0:20521653'] = true, -- chelog
	-- ['STEAM_0:0:65232888'] = true, -- quillin
	-- ['STEAM_0:1:45099154'] = true, -- Sighty
	-- ['STEAM_0:1:97137915'] = true, -- Arthas
	-- ['STEAM_0:0:80902445'] = true, -- Tawi
	-- ['STEAM_0:1:127790060'] = true, -- /null.
	-- ['STEAM_0:0:56250978'] = true, -- inquizzy
	-- ['STEAM_0:1:46891732'] = true, -- doctor
	-- ['STEAM_0:1:50315838'] = true, -- kilo-7
}

octoshop.checkOwner = function(ply)

	return owners[ply:SteamID()]

end
