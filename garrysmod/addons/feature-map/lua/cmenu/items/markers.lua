local callsMarkers = { 'call', 'police', 'cpSupport', 'cpPanicBtn', 'camera' }
octogui.cmenu.registerItem('other', 'markers', {
	text = L.markers,
	icon = octolib.icons.silk16('map'),
	options = {
		{ text = L.markers_clear, icon = octolib.icons.silk16('map_delete'), action = function() octolib.markers.clear() end },
		{
			text = L.markers_clear_police,
			icon = octolib.icons.silk16('map_delete'),
			action = function()
				for _, id in ipairs(callsMarkers) do octolib.markers.clear(id) end
			end,
		},
	},
})
