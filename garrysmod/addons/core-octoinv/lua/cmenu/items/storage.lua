octogui.cmenu.registerItem('inv', 'storage', {
	text = L.place_storage,
	icon = octolib.icons.silk16('add_package'),
	action = octolib.fQuery(L.place_storage_confirm, L.place_storage, L.ok, function()
		RunConsoleCommand('dbg_storage', '')
	end, L.cancel),
})
