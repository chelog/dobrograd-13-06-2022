octogui.cmenu.registerItem('rp', 'chance', {
	text = L.chance,
	icon = octolib.icons.silk16('dice'),
	options = {
		{text = L.pull_card, icon = octolib.icons.silk16('bullet_green'), say = '/card'},
		{text = L.roll_the_dice, icon = octolib.icons.silk16('bullet_yellow'), say = '/dice'},
		{text = L.get_chance, icon = octolib.icons.silk16('bullet_blue'), say = '/roll'},
		{text = L.rock_paper_scissors, icon = octolib.icons.silk16('bullet_red'), say = '/rockpaperscissors'},
		{text = 'Подбросить монетку', icon = octolib.icons.silk16('bullet_purple'), say = '/coin'},
	},
})
