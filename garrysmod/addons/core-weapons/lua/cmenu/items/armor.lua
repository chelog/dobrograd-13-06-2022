octogui.cmenu.registerItem('inv', 'armor', {
	check = function(ply)
		return ply:Alive() and ply:Armor() > 0 and ply:GetNetVar('armor') == ply:Armor()
	end,
	text = 'Снять бронежилет',
	icon = octolib.icons.silk16('shield_delete'),
	action = function()
		netstream.Start('dbg-armor.unwear')
	end,
})
