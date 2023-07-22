octogui.cmenu.registerItem('rp', 'sellall', {
	text = L.sell_doors,
	icon = octolib.icons.silk16('door_out'),
	action = octolib.fQuery(L.sell_doors_confirm, L.sell_doors, L.ok, function()
		netstream.Start('dbg-estates.sellAll')
	end, L.cancel),
})
