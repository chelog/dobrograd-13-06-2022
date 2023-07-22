octogui.cmenu.registerItem('rp', 'look', {
	check = function()
		return not LocalPlayer():GetNetVar('dragger') and dbgView.active
	end,
	text = 'Взглянуть на себя',
	icon = octolib.icons.silk16('magnifier'),
	netstream = 'dbg-quickLook',
})
