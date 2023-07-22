octogui.cmenu.registerItem('inv', 'weapon', {
	text = L.weapons,
	icon = octolib.icons.silk16('gun'),
	options = {
		{text = L.drop, icon = octolib.icons.silk16('arrow_right'), say = '/dropweapon'},
		{text = L.holster, icon = octolib.icons.silk16('arrow_left'), say = '/holsterweapon'},
		{text = 'Проверить магазин', icon = octolib.icons.silk16('information'), say = '/ammo'},
	},
})
