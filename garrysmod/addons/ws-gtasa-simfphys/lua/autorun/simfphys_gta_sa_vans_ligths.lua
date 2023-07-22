local light_table = {
	L_HeadLampPos = Vector( 78.45416, 24.702624,-5.332104),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 78.45416,-24.702624,-5.332104),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-93.42756, 31.397112,-3.328164),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-93.42756,-31.397112,-3.328164),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 88.45416, 24.702624,-5.332104),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
		{pos = Vector( 88.45416,-24.702624,-5.332104),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 88.45416, 24.702624,-5.332104),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 88.45416,-24.702624,-5.332104),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-93.42756, 31.397112,-3.328164),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-93.42756,-31.397112,-3.328164),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-93.42756, 31.397112,0),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-93.42756,-31.397112,0),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-93.42756, 31.397112,0),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-93.42756,-31.397112,0),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-93.42756, 31.397112,0),
			Vector( 86.76288, 32.127372,-12.112884),
			Vector( 86.76288, 32.127372,-6.415596),
		},
		Right = {
			Vector(-93.42756,-31.397112,0),
			Vector( 86.76288,-32.127372,-12.112884),
			Vector( 86.76288,-32.127372,-6.415596),
		},
	},
	ems_sounds = {"simulated_vehicles/police/siren_1.wav","simulated_vehicles/police/siren_2.wav"},
	ems_sprites = {
		{
			pos = Vector(36,-6.6,33.7),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(0,0,255,255),Color(255,0,0,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(36,7,33.6),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(255,0,0,255),Color(0,0,255,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(40,-18,33),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(255,0,0,255),Color(0,0,255,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(40,18,33),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(0,0,255,255),Color(255,0,0,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(-91,32.5,-1),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(255,0,0,255),Color(0,0,255,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(-91,-32.5,-1),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(0,0,255,255),Color(255,0,0,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(-86,18,26),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(0,0,255,255),Color(255,0,0,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(-86,-18,26),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(255,0,0,255),Color(0,0,255,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
	}

}
list.Set( "simfphys_lights", "burrito", light_table)

local light_table = {
	L_HeadLampPos = Vector( 78.45416, 24.702624,-5.332104),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 78.45416,-24.702624,-5.332104),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-93.42756, 31.397112,-3.328164),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-93.42756,-31.397112,-3.328164),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 88.45416, 24.702624,-5.332104),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
		{pos = Vector( 88.45416,-24.702624,-5.332104),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 88.45416, 24.702624,-5.332104),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 88.45416,-24.702624,-5.332104),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-93.42756, 31.397112,-3.328164),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-93.42756,-31.397112,-3.328164),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-93.42756, 31.397112,0),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-93.42756,-31.397112,0),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-93.42756, 31.397112,0),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-93.42756,-31.397112,0),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-93.42756, 31.397112,0),
			Vector( 86.76288, 32.127372,-12.112884),
			Vector( 86.76288, 32.127372,-6.415596),
		},
		Right = {
			Vector(-93.42756,-31.397112,0),
			Vector( 86.76288,-32.127372,-12.112884),
			Vector( 86.76288,-32.127372,-6.415596),
		},
	},
	ems_sprites = {
        {
            pos = Vector(46.0, 3.8, 24.6),
            material = "sprites/light_glow02_add_noz",
            size = 60,
            Colors = {Color(255,135,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255)},
            Speed = 0.15,
        }, {
            pos = Vector(46.0, -4.4, 24.6),
            material = "sprites/light_glow02_add_noz",
            size = 60,
            Colors = {Color(0,0,0,255),Color(0,0,0,255),Color(255,135,0,255),Color(0,0,0,255)},
            Speed = 0.15,
        }, {
            pos = Vector(44.8, -40.9, 11.6),
            material = "sprites/light_glow02_add_noz",
            size = 60,
            Colors = {Color(0,0,0,255),Color(0,0,0,255),Color(255,135,0,255),Color(0,0,0,255)},
            Speed = 0.15,
        }, {
            pos = Vector(44.8, 40.9, 11.6),
            material = "sprites/light_glow02_add_noz",
            size = 60,
            Colors = {Color(255,135,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255)},
            Speed = 0.15,
       }, {
            pos = Vector(-85.6, 16.4, 23.6),
            material = "sprites/light_glow02_add_noz",
            size = 60,
            Colors = {Color(255,135,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255)},
            Speed = 0.15,
       }, {
            pos = Vector(-85.6, 7.4, 23.6),
            material = "sprites/light_glow02_add_noz",
            size = 60,
            Colors = {Color(0,0,0,255),Color(0,0,0,255),Color(255,135,0,255),Color(0,0,0,255)},
            Speed = 0.15,
       }, {
            pos = Vector(-85.6, -17.5, 23.6),
            material = "sprites/light_glow02_add_noz",
            size = 60,
            Colors = {Color(255,135,0,255),Color(0,0,0,255),Color(0,0,0,255),Color(0,0,0,255)},
            Speed = 0.15,
       }, {
            pos = Vector(-85.6, -8.6, 23.6),
            material = "sprites/light_glow02_add_noz",
            size = 60,
            Colors = {Color(0,0,0,255),Color(0,0,0,255),Color(255,135,0,255),Color(0,0,0,255)},
            Speed = 0.15,
       },
	},
	ems_sounds = {"simulated_vehicles/police/siren_1.wav","simulated_vehicles/police/siren_2.wav"},

}
list.Set( "simfphys_lights", "burrito_crn", light_table)

local light_table = {
	L_HeadLampPos = Vector( 113.3216, 34.428024,15.056316),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 113.3216,-34.428024,15.056316),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-136.64744, 38.93472,-10.585656),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-136.64744,-38.93472,-10.585656),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 123.3216, 34.428024,15.056316),material = "sprites/light_ignorez",size = 50, color = Color( 255,230,230,180)},
		{pos = Vector( 123.3216,-34.428024,15.056316),material = "sprites/light_ignorez",size = 50, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 123.3216, 34.428024,15.056316),material = "sprites/light_ignorez",size = 55, color = Color( 255,235,220,170)},
		{pos = Vector( 123.3216,-34.428024,15.056316),material = "sprites/light_ignorez",size = 55, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-146.64744, 38.93472,-10.585656),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-146.64744,-38.93472,-10.585656),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-146.64744, 38.93472,-10.585656),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-146.64744,-38.93472,-10.585656),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-146.64744, 38.93472,-10.585656),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-146.64744,-38.93472,-10.585656),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-146.64744, 38.93472,-10.585656),
			Vector( 123.3216, 34.428024,12),
		},
		Right = {
			Vector(-146.64744,-38.93472,-10.585656),
			Vector( 123.3216,-34.428024,12),
		},
	}

}
list.Set( "simfphys_lights", "hotdog", light_table)

local light_table = {
	L_HeadLampPos = Vector( 76.87592, 28.032912,-7.113132),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 76.87592,-28.032912,-7.113132),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-79.7804, 36.34992,-11.73456),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-79.7804,-36.34992,-11.73456),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 86.87592, 28.032912,-7.113132),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
		{pos = Vector( 86.87592,-28.032912,-7.113132),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 86.87592, 28.032912,-7.113132),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 86.87592,-28.032912,-7.113132),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-89.7804, 36.34992,-11.73456),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7804,-36.34992,-11.73456),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-89.7804, 36.34992,-6),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-89.7804,-36.34992,-6),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-89.7804, 36.34992,-1),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-89.7804,-36.34992,-1),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-89.7804, 36.34992,-1),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-89.7804,-36.34992,-1),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-96.0462, 29.197188,-21.458736),
			Vector(-89.7804, 36.34992,2),
			Vector( 86.73696, 34.400844,-9.562788),
			Vector( 86.73696, 34.400844,-6),
		},
		Right = {
			Vector(-96.0462,-29.197188,-21.458736),
			Vector(-89.7804,-36.34992,2),
			Vector( 86.73696,-34.400844,-9.562788),
			Vector( 86.73696,-34.400844,-6),
		},
	}

}
list.Set( "simfphys_lights", "moonbeam", light_table)

local light_table = {
	L_HeadLampPos = Vector( 71.58608, 26.961624,-7.320996),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 71.58608,-26.961624,-7.320996),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-70.48232, 29.91456,5.970384),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-70.48232,-29.91456,5.970384),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 81.58608, 26.961624,-7.320996),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
		{pos = Vector( 81.58608,-26.961624,-7.320996),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 81.58608, 26.961624,-7.320996),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 81.58608,-26.961624,-7.320996),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-80.48232, 32.072364,5.970384),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-80.48232,-32.072364,5.970384),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-80.48232, 27.60606,5.970384),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-80.48232,-27.60606,5.970384),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-80.48232, 27.60606,5.970384),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-80.48232,-27.60606,5.970384),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-80.48232, 27.60606,0.752328),
			Vector(-80.48232, 32.072364,0.752328),
			Vector( 81.58608, 28.869876,1.836936),
			Vector( 81.58608, 25.990884,1.836936),
		},
		Right = {
			Vector(-80.48232,-27.60606,0.752328),
			Vector(-80.48232,-32.072364,0.752328),
			Vector( 81.58608,-28.869876,1.836936),
			Vector( 81.58608,-25.990884,1.836936),
		},
	},
	ems_sounds = {"dbg/cars/bank_073/sound_004.wav"}

}
list.Set( "simfphys_lights", "mrwhoop", light_table)

local light_table = {
	L_HeadLampPos = Vector( 81.2708, 25.698348,-2.158668),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 81.2708,-25.698348,-2.158668),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-114.506, 32.771628,3.5892),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-114.506,-32.771628,3.5892),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 91.2708, 25.698348,-2.158668),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
		{pos = Vector( 91.2708,-25.698348,-2.158668),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 91.2708, 25.698348,-2.158668),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 91.2708,-25.698348,-2.158668),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-124.506, 32.771628,3.5892),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-124.506,-32.771628,3.5892),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-124.506, 32.771628,6.987924),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-124.506,-32.771628,6.987924),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-124.506, 32.771628,6.987924),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-124.506,-32.771628,6.987924),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-124.506, 32.771628,6.987924),
			Vector( 90, 34.954992,-2.252448),
		},
		Right = {
			Vector(-124.506,-32.771628,6.987924),
			Vector( 90,-34.954992,-2.252448),
		},
	}

}
list.Set( "simfphys_lights", "newsvan", light_table)

local light_table = {
	L_HeadLampPos = Vector( 83.78612, 26.29422,-3.8115),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 83.78612,-26.29422,-3.8115),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-85.01516, 32.667876,-2.251728),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-85.01516,-32.667876,-2.251728),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 93.78612, 26.29422,-3.8115),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
		{pos = Vector( 93.78612,-26.29422,-3.8115),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 93.78612, 26.29422,-3.8115),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 93.78612,-26.29422,-3.8115),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-95.01516, 32.667876,-2),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-95.01516,-32.667876,-2),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-95.01516, 32.667876,1),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-95.01516,-32.667876,1),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-95.01516, 32.667876,4),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-95.01516,-32.667876,4),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-95.01516, 32.667876,7),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-95.01516,-32.667876,7),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-95.01516, 32.667876,10),
			Vector( 92.96568, 34.536024,-3.8115),
		},
		Right = {
			Vector(-95.01516,-32.667876,10),
			Vector( 92.96568,-34.536024,-3.8115),
		},
	}
}
list.Set( "simfphys_lights", "pony", light_table)

local light_table = {
	L_HeadLampPos = Vector( 81.90116, 26.212428,-10.466172),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 81.90116,-26.212428,-10.466172),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-84.61268, 32.662224,-8.523648),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-84.61268,-32.662224,-8.523648),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 91.90116, 26.212428,-10.466172),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
		{pos = Vector( 91.90116,-26.212428,-10.466172),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 91.90116, 26.212428,-10.466172),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 91.90116,-26.212428,-10.466172),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-94.61268, 32.662224,-8.523648),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-94.61268,-32.662224,-8.523648),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-94.61268, 32.662224,-5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-94.61268,-32.662224,-5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-94.61268, 32.662224,-5),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-94.61268,-32.662224,-5),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-94.61268, 32.662224,0),
			Vector(-94.61268, 32.662224,3),
			Vector( 92.1952, 34.4475,-10.185),
			Vector( 64.3992, 37.0586,-7.55955),
		},
		Right = {
			Vector(-94.61268,-32.662224,0),
			Vector(-94.61268,-32.662224,3),
			Vector( 92.1952,-34.4475,-10.185),
			Vector( 64.3992,-37.0586,-7.55955),
		},
	}
}
list.Set( "simfphys_lights", "rumpo", light_table)

local light_table = {
	L_HeadLampPos = Vector( 84.60044, 32.841036,-6.39432),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 84.60044,-32.841036,-6.39432),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-97.16048, 32.400864,-2.824416),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-97.16048,-32.400864,-2.824416),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 94.60044, 32.841036,-6.39432),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
		{pos = Vector( 94.60044,-32.841036,-6.39432),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
		{pos = Vector( 46.1159, 36.1729,42.7482),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
		{pos = Vector( 46.1159,-36.1729,42.7482),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
		{pos = Vector( 46.1159,0       ,42.7482),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
		{pos = Vector( 40.7732, 43.8052,42.7482),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
		{pos = Vector( 40.7732,-43.8052,42.7482),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
	},
	Headlamp_sprites = {
		{pos = Vector( 94.60044, 32.841036,-6.39432),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 94.60044,-32.841036,-6.39432),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-107.16048, 32.400864,-2.824416),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-107.16048,-32.400864,-2.824416),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-107.16048, 32.400864,45.17928),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-107.16048,-32.400864,45.17928),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-107.985, 36.2285,52.3392),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
		{pos = Vector(-107.985,-36.2285,52.3392),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
		{pos = Vector(-107.985,0       ,52.3392),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
		{pos = Vector(-98.2851, 43.8052,52.3392),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
		{pos = Vector(-98.2851,-43.8052,52.3392),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
	},
	Brakelight_sprites = {
		{pos = Vector(-107.16048, 32.400864,-2.824416),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-107.16048,-32.400864,-2.824416),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-107.16048, 32.400864,6.739056),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-107.16048,-32.400864,6.739056),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-107.16048, 32.400864,6.739056),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-107.16048,-32.400864,6.739056),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-107.16048, 32.400864,6.739056),
			Vector(-98.2851, 43.8052,52.3392),
			Vector( 40.7732, 43.8052,42.7482),
			Vector( 90.1875, 32.9693,6.43389),
		},
		Right = {
			Vector(-107.16048,-32.400864,6.739056),
			Vector(-98.2851,-43.8052,52.3392),
			Vector( 40.7732,-43.8052,42.7482),
			Vector( 90.1875,-32.9693,6.43389),
		},
	}
}
list.Set( "simfphys_lights", "securica", light_table)
