octogui.cmenu.registerItem('inv', 'money', {
	text = L.money,
	icon = octolib.icons.silk16('money'),
	options = {
		{
			text = L.drop,
			icon = octolib.icons.silk16('arrow_right'),
			action = octolib.fStringRequest(L.drop, L.enter_amount_money, '', function(s) octochat.say('/dropmoney', s) end, nil, L.ok, L.cancel),
		}, {
			text = L.put,
			icon = octolib.icons.silk16('arrow_down'),
			action = octolib.fStringRequest(L.put, L.enter_amount_money, '', function(s) octochat.say('/putmoney', s) end, nil, L.ok, L.cancel),
		},
	},
})
