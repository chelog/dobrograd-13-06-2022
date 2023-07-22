octoinv.registerCollector('pickaxe', {
	name = 'Кирка',
	icon = octolib.icons.color('crowbar'),
	hold = 'melee2',
	interval = 1.5,
	delay = 0.15,
	power = 10,
	health = 500,
	sounds = {
		{'physics/concrete/concrete_impact_hard1.wav', 75},
		{'physics/concrete/concrete_impact_hard2.wav', 75},
		{'physics/concrete/concrete_impact_hard3.wav', 75},
	},
	worldModel = {
		model = 'models/weapons/hl2meleepack/w_pickaxe.mdl',
		pos = Vector(-1.9, -0.6, -0.7),
		ang = Angle(168.6, -100.5, -4),
		scale = 0.8
	},
})

octoinv.registerCollectable('stone', {
	name = 'Камень',
	collectors = {'pickaxe'},
	period = {10, 90},
	max = 25,
	health = 50,
	effects = {
		hit = 'StunstickImpact',
		hitSounds = {'Rock.ImpactSoft'},
		collect = 'GlassImpact',
		collectSounds = {'Boulder.ImpactHard'},
	},
	models = {
		'models/props_lab/bigrock.mdl',
		'models/props_wasteland/rockgranite02a.mdl',
		'models/props_wasteland/rockgranite02b.mdl',
		'models/props_wasteland/rockgranite02c.mdl',
		'models/props_wasteland/rockgranite03b.mdl',
		'models/props_wasteland/rockgranite03c.mdl',
		'models/props/cs_militia/militiarock05.mdl',
	},
	dropsAmount = 3,
	drops = {
		{1, {'stone', 1}},
		{0.1, {'craft_coal', 1}},
		{0.14, {'ore_iron', 1}},
		{0.14, {'ore_steel', 1}},
		-- {0.05, {'ore_copper', 1}},
		-- {0.04, {'ore_bronze', 1}},
		{0.03, {'ore_gold', 1}},
		{0.01, {'ore_silver', 1}},
		{0.0015, {'jewelry_diamond', 1}},
		{0.0015, {'jewelry_ruby', 1}},
		{0.0015, {'jewelry_sapphire', 1}},
		{0.0015, {'jewelry_topaz', 1}},
		{0.0015, {'jewelry_emerald', 1}},
	},
})

octoinv.registerCraft('collector_pickaxe', {
	name = 'Кирка',
	icon = octolib.icons.color('crowbar'),
	conts = {'workbench'},
	soundTime = 2,
	time = 30,
	tools = {
		{'tool_saw', 1},
		{'tool_hammer', 1},
		{'tool_screwer', 1},
	},
	ings = {
		{'craft_stick', 2},
		{'ingot_iron', 5},
		{'craft_nail', 2},
		{'craft_screw', 4},
	},
	finish = {
		{'collector', {
			name = 'Кирка',
			icon = octolib.icons.color('crowbar'),
			collector = 'pickaxe',
			maxhealth = 500,
			health = 500,
		}},
	},
})
