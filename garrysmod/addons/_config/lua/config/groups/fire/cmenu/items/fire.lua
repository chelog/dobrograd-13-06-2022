local function checkUniform(ply)
	if not ply:GetModel():find('models/gta5/fire') then return end
	local bgs = {}
	for i, v in ipairs(ply:GetBodyGroups()) do
		local id = v.id
		bgs[id] = ply:GetBodygroup(id)
	end
	return bgs[2] == 1
end

octogui.cmenu.registerItem('fire', 'lightbulb', {
	icon = octolib.icons.silk16('lightbulb'),
	text = function(ply)
		local mask = ply:GetNetVar('fire.flashlight')
		return ('%s фонарик'):format(mask and 'Выключить' or 'Включить')
	end,
	check = function(ply)
		return ply:Team() == TEAM_FIREFIGHTER and checkUniform(ply)
	end,
	action = function()
		netstream.Start('fire.flashlight', LocalPlayer())
	end,
})

octogui.cmenu.registerItem('fire', 'scba', {
	icon = octolib.icons.silk16('cancel'),
	text = function(ply)
		local mask = ply:GetNetVar('fire.scba')
		return ('%s кнопку тревоги'):format(mask and 'Выключить' or 'Включить')
	end,
	check = function(ply)
		return ply:Team() == TEAM_FIREFIGHTER and checkUniform(ply)
	end,
	action = function()
		netstream.Start('fire.scba', LocalPlayer())
	end,
})