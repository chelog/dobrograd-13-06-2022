og.tabBuilds['settings'] = function(ps, g)

	local gID = g.id
	if not og.hasPerm(gID, 'setSetting') then return end

	local p = vgui.Create 'DScrollPanel'
	ps:AddSheet('Настройки', p, 'icon16/cog.png')

end
