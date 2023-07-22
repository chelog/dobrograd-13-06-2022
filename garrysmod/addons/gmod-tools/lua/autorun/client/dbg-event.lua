netstream.Hook('dbg-event.askForRefugee', function(mdlData)

	local pnl = octolib.models.selector({mdlData}, function(_, skin, bgs)
		netstream.Start('dbg-event.askForRefugee', skin, bgs)
	end)
	pnl.layoutPan:Remove()
	pnl.params:ChangeModel(1, mdlData)

end)
