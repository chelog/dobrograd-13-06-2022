local light_table = {
	L_HeadLampPos = Vector( 87.2, 23, -2 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 87.2, -23, -2 ),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-82.8,19.1,2.3),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-82.8,-19.1,2.3),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 87.5, 18, -2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 87.5, -18, -2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 87.5, 22, -2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 87.5, -22, -2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 87.5, 25, -2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 87.5, -25, -2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 87.5, 22, -2 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 87.5, -22, -2 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-102.8,26.6,-2.3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-102.8,-26.6,-2.3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-102.8,19.1,-2.3),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-102.8,-19.1,-2.3),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-102.8,19.1,-2.3),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-102.8,-19.1,-2.3),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-102.8,34,-2.3),
			Vector( 86.5, 33, -2 ),
		},
		Right = {
			Vector(-102.8,-34,-2.3),
			Vector( 86.5, -33, -2 ),
		},
	}

}
list.Set( "simfphys_lights", "admiral", light_table)

local light_table = {
	L_HeadLampPos = Vector( 95.1, 28, -2 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 95.1, -28, -2 ),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-82.8,25.2,2.2),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-82.8,-25.2,2.2),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 95.1, 21, -2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 95.1, -21, -2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 95.1, 28, -2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 95.1, -28, -2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 95.1, 33, -2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 95.1, -33, -2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 95.1, 28, -2 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 95.1, -28, -2 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-109.1,33.1,-2.2),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-109.1,-33.1,-2.2),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-109.1,25.2,-2.2),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-109.1,-25.2,-2.2),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-109.1,24,-2.2),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-109.1,-24,-2.2),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-109.1,40,-2.2),
			Vector( 93, 39, -2 ),
		},
		Right = {
			Vector(-109.1,-40,-2.2),
			Vector( 93, -39, -2 ),
		},
	},

	ems_sounds = {"simulated_vehicles/police/siren_1.wav","simulated_vehicles/police/siren_2.wav"},
	ems_sprites = {
		{
			pos = Vector(98.6,-8,-1.1),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(0,0,255,255),Color(255,0,0,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(98.6,8,-1.1),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(255,0,0,255),Color(0,0,255,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(93.8,-37.8,-2),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(0,0,255,255),Color(255,0,0,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(93.8,37.8,-2),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(255,0,0,255),Color(0,0,255,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(-111,-12,-4),
			material = "sprites/light_glow02_add_noz",
			size = 34,
			Colors = {Color(255,0,0,255),Color(0,0,255,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(-111,12,-4),
			material = "sprites/light_glow02_add_noz",
			size = 34,
			Colors = {Color(0,0,255,255),Color(255,0,0,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(-60,5,13),
			material = "sprites/light_glow02_add_noz",
			size = 34,
			Colors = {Color(0,0,255,255),Color(255,0,0,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(-60,-5,13),
			material = "sprites/light_glow02_add_noz",
			size = 34,
			Colors = {Color(255,0,0,255),Color(0,0,255,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
	}

}
list.Set( "simfphys_lights", "elegant", light_table)

local light_table = {
	L_HeadLampPos = Vector( 95.1, 28, 4.6 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 95.1, -28, 4.6 ),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-107.6,33.8,7.5),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-107.6,-33.8,7.5),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 102.2, 21, 4.6 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 102.2, -21, 4.6 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 102.2, 24, 4.6 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 102.2, -24, 4.6 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 102.2, 30, 4.6 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 102.2, -30, 4.6 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 95.1, 28, -2 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 95.1, -28, -2 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-107.6,33.8,7.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-107.6,-33.8,7.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-109.5,2,7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-109.5,-2,7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-109.5,6,7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-109.5,-6,7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-109,10,7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-109,-10,7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-109,14,7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-109,-14,7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-108.5,18,7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-108.5,-18,7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-108.5,22,7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-108.5,-22,7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-107.6,26,7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-107.6,-26,7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-107.6,29,7.5),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-107.6,-29,7.5),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-107.6,29,7.5),
			Vector( 100, 35, 4.6 ),
		},
		Right = {
			Vector(-107.6,-29,7.5),
			Vector( 100, -35, 4.6 ),
		},
	}

}
list.Set( "simfphys_lights", "emperor", light_table)

local light_table = {
	L_HeadLampPos = Vector( 85.4, 33, 4.3),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 85.4, -33, 4.3),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-91,37.8,0.7),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-91,-37.8,0.7),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 95.4, 33, 4.3),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 95.4, -33, 4.3),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 95.4, 33, 4.3),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 95.4, -33, 4.3),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-101,37.8,0.7),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-101,-37.8,0.7),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-101,37.8,0.7),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-101,-37.8,0.7),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-101,37.8,0.7),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-101,-37.8,0.7),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-101,37.8,0.7),
			Vector( 95.4, 33, 4.3),
		},
		Right = {
			Vector(-101,-37.8,0.7),
			Vector( 95.4, -33, 4.3 ),
		},
	}

}
list.Set( "simfphys_lights", "glendale", light_table)

local light_table = {
	L_HeadLampPos = Vector( 80.3, 20.5, 2.8),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 80.3, -20.5, 2.8),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-92.2,26,0.35),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-92.2,-26,0.35),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 90.3, 28.8, 2.8),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 90.3, -28.8, 2.8),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 90.3, 20.5, 2.8),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 90.3, -20.5, 2.8),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-102.2,27,0.35),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-102.2,-27,0.35),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-102.2,23,0.35),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-102.2,-23,0.35),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-102.2,18,0.35),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-102.2,-18,0.35),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-102.2,18,0.35),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-102.2,-18,0.35),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-102.2,35,0.35),
			Vector( 90.3, 28.8, -1.8),
		},
		Right = {
			Vector(-102.2,-35,0.35),
			Vector( 90.3, -28.8, -1.8),
		},
	}

}
list.Set( "simfphys_lights", "greenwoo", light_table)

local light_table = {
	L_HeadLampPos = Vector( 80.3, 27.7, 0.3),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 80.3, -27.7, 0.3),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-80,33.1,3.2),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-80,-33.1,3.2),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 95.6, 29, 0.3),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 95.6, -29, 0.3),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 95.6, 25, 0.3),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 95.6, -25, 0.3),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 95.6, 27.7, 0.3),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 95.6, -27.7, 0.3),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-99.3,25,3.2),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-99.3,-25,3.2),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-99.3,29,3.2),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-99.3,-29,3.2),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-99.3,20,3.2),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-99.3,-20,3.2),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-99.3,20,3.2),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-99.3,-20,3.2),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-97,38,3.2),
			Vector(37.8,41,2.1),
			Vector( 95.6, 35, 0.3),
		},
		Right = {
			Vector(-97,-38,3.2),
			Vector(37.8,-41,2.1),
			Vector( 95.6, -35, 0.3),
		},
	}

}
list.Set( "simfphys_lights", "intruder", light_table)

local light_table = {
	L_HeadLampPos = Vector( 90, 22,6, 1,4),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 90, -22,6, 1,4),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-104,26,0.3),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-104,26,0.3),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 98, 29, -1,4),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 98, -29, -1,4),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 98, 22, -1,4),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 98, -22, -1,4),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-114,29,0.3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-114,-29,0.3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-114,25,0.3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-114,-25,0.3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-114,17,0.3),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-114,-17,0.3),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-114,16,0.3),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-114,-16,0.3),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-111,35,0.3),
			Vector( 93, 35, -1,4),
		},
		Right = {
			Vector(-111,-35,0.3),
			Vector( 93, -35, -1,4),
		},
	}

}
list.Set( "simfphys_lights", "merit", light_table)

local light_table = {
	L_HeadLampPos = Vector( 90, 24.3, -1),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 90, -24.3, -1),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-90,27.7,0.3),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-90,-27.7,0.3),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 99, 24.3, -1),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 99, -24.3, -1),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 99, 24.3, -1),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 99, -24.3, -1),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-104,27.7,0.3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-104,-27.7,0.3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-104,18,0.3),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-104,-18,0.3),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-104,18,0.3),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-104,-18,0.3),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-102,34,0.3),
			Vector( 93, 36, -1,4),
		},
		Right = {
			Vector(-102,-34,0.3),
			Vector( 93, -36, -1,4),
		},
	}

}
list.Set( "simfphys_lights", "nebula", light_table)

local light_table = {
	L_HeadLampPos = Vector( 82.2, 21.6, -4),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 82.2, -21.6, -4),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-89,33.8,4),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-89,-33.8,4),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 102.2, 21.6, -4),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 102.2, -21.6, -4),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 102.2, 12.6, -4),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 102.2, -12.6, -4),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-109,33.8,4),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-109,-33.8,4),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-109,33.8,0),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-109,-33.8,0),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-109,33.8,0),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-109,-33.8,0),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-109,33.8,0),
			Vector( 102.2, 21.6, -4),
		},
		Right = {
			Vector(-109,-33.8,0),
			Vector( 102.2, -21.6, -4),
		},
	}

}
list.Set( "simfphys_lights", "oceanic", light_table)

local light_table = {
	L_HeadLampPos = Vector( 69.5, 25.5, 6.8),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 69.5, -25.5, 6.8),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-88,28.4,6),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-88,28.4,6),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 79.5, 25.5, 6.8),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 79.5, -25.5, 6.8),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 79.5, 25.5, 6.8),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 79.5, -25.5, 6.8),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-98,28.4,6),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-98,-28.4,6),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-98,28.4,-1),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-98,-28.4,-1),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-98,28.4,-1),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-98,-28.4,-1),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-98,28.4,-1),
			Vector( 79.5, 25.5, -1),
		},
		Right = {
			Vector(-98,-28.4,-1),
			Vector( 79.5, -25.5, -1),
		},
	}

}
list.Set( "simfphys_lights", "peren", light_table)

local light_table = {
	L_HeadLampPos = Vector( 75.3, 27.3, -0.7 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 75.3, -27.3, -0.7 ),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-87.9,24,1),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-87.9,-24,1),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 85.3, 27.3, -0.7 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 85.3, -27.3, -0.7 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 85.3, 27.3, -0.7 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 85.3, -27.3, -0.7 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-97.9,30,1),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-97.9,-30,1),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-97.9,23,1),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-97.9,-23,1),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-97.9,23,1),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-97.9,-23,1),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-97,36,1),
			Vector( 83, 35, -0.7 ),
		},
		Right = {
			Vector(-97,-36,1),
			Vector( 83, -35, -0.7 ),
		},
	}

}
list.Set( "simfphys_lights", "premier", light_table)

local light_table = {
	L_HeadLampPos = Vector( 85.4, 24.1, 1 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 85.4, -24.1, 1 ),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-87.9,24,1),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-87.9,-24,1),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 95.4, 24.1, 1 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 95.4, -24.1, 1 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 95.4, 24.1, 1 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 95.4, -24.1, 1 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-98,29,2),material = "sprites/light_ignorez",size = 38,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-98,-29,2),material = "sprites/light_ignorez",size = 38,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-98,23,2),material = "sprites/light_ignorez",size = 38,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-98,-23,2),material = "sprites/light_ignorez",size = 38,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-98,16,2),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-98,-16,2),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-98,16,2),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-98,-16,2),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-96,34,2),
			Vector( 89, 35, 1 ),
		},
		Right = {
			Vector(-96,-34,2),
			Vector( 89, -35, 1 ),
		},
	}

}
list.Set( "simfphys_lights", "primo", light_table)

local light_table = {
	L_HeadLampPos = Vector( 80, 26.6, 1 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 80, -26.6, 1 ),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-89,34.9,-2.5),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-89,-34.9,-2.5),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 90, 26.6, 1 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
		{pos = Vector( 90, -26.6, 1 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 90, 26.6, 1 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 90, -26.6, 1 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-99,34.9,-2.5),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-99,-34.9,-2.5),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-99,34.9,1.8),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-99,-34.9,1.8),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-99,34.9,1.8),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-99,-34.9,1.8),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-99,34.9,1.8),
			Vector( 90, 35, 1 ),
		},
		Right = {
			Vector(-99,-34.9,1.8),
			Vector( 90, -35, 1 ),
		},
	}

}
list.Set( "simfphys_lights", "regina", light_table)

local light_table = {
	L_HeadLampPos = Vector( 89.7, 27.3, -6.8 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 89.7, -27.3, -6.8 ),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-100.9,36.3,0.3),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-100.9,-36.3,0.3),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 99.7, 27.3, -6.8 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
		{pos = Vector( 99.7, -27.3, -6.8 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 99.7, 27.3, -6.8 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 99.7, -27.3, -6.8 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-111.9,36.3,0.3),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-111.9,-36.3,0.3),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-111.9,36.3,-4.3),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-111.9,-36.3,-4.3),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-111.9,36.3,-4.3),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-111.9,-36.3,-4.3),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-111.9,36.3,-4.3),
			Vector( 101, 36, -6.8 ),
		},
		Right = {
			Vector(-111.9,-36.3,-4.3),
			Vector( 101, -36, -6.8 ),
		},
	}

}
list.Set( "simfphys_lights", "romero", light_table)

local light_table = {
	L_HeadLampPos = Vector( 74.9, 17, -2.1 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 74.9, -17, -2.1 ),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-87.9,26,-1.8),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-87.9,-26,-1.8),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 84.9, 17, -2.1 ),material = "sprites/light_ignorez",size = 34, color = Color( 255,230,230,100)},
		{pos = Vector( 84.9, -17, -2.1 ),material = "sprites/light_ignorez",size = 34, color = Color( 255,230,230,100)},
		{pos = Vector( 84.9, 23, -2.1 ),material = "sprites/light_ignorez",size = 34, color = Color( 255,230,230,100)},
		{pos = Vector( 84.9, -23, -2.1 ),material = "sprites/light_ignorez",size = 34, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 84.9, 20, -2.1 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 84.9, -20, -2.1 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-97.9,26,-1.8),material = "sprites/light_ignorez",size = 38,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-97.9,-26,-1.8),material = "sprites/light_ignorez",size = 38,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-97.9,20,-1.8),material = "sprites/light_ignorez",size = 38,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-97.9,-20,-1.8),material = "sprites/light_ignorez",size = 38,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-97.9,14,-1.8),material = "sprites/light_ignorez",size = 38,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-97.9,-14,-1.8),material = "sprites/light_ignorez",size = 38,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-97.9,8,-1.8),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-97.9,-8,-1.8),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-97.9,8,-1.8),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-97.9,-8,-1.8),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-96,32,-1.8),
			Vector( 82, 31, -2.1 ),
		},
		Right = {
			Vector(-96,-32,-1.8),
			Vector( 82, -31, -2.1 ),
		},
	}

}
list.Set( "simfphys_lights", "sentinel", light_table)

local light_table = {
	L_HeadLampPos = Vector( 82.1, 19, -4.3 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 82.1, -19, -4.3 ),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-91.1,34.9,-5),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-91.1,-34.9,-5),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 92.1, 19, -4.3 ),material = "sprites/light_ignorez",size = 34, color = Color( 255,230,230,100)},
		{pos = Vector( 92.1, -19, -4.3 ),material = "sprites/light_ignorez",size = 34, color = Color( 255,230,230,100)},
		{pos = Vector( 92.1, 25, -4.3 ),material = "sprites/light_ignorez",size = 34, color = Color( 255,230,230,100)},
		{pos = Vector( 92.1, -25, -4.3 ),material = "sprites/light_ignorez",size = 34, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 92.1, 23, -4.3 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 92.1, -23, -4.3 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-101.1,34.9,-5),material = "sprites/light_ignorez",size = 34,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-101.1,-34.9,-5),material = "sprites/light_ignorez",size = 34,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-101.1,34.9,1),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-101.1,-34.9,1),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-101.1,34.9,1),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-101.1,-34.9,1),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-101.1,34.9,1),
			Vector( 87, 34, -4.3 ),
		},
		Right = {
			Vector(-101.1,-34.9,1),
			Vector( 87, -34, -4.3 ),
		},
	}

}
list.Set( "simfphys_lights", "solair", light_table)

local light_table = {
	L_HeadLampPos = Vector( 84.3, 28, 0 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 84.3, -28, 0 ),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-82.2,39.4,2),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-82.2,39.4,2),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 94.3, 28, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 94.3, -28, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 94.3, 28, 0 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 94.3, -28, 0 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-102.2,39.4,2),material = "sprites/light_ignorez",size = 22,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-102.2,-39.4,2),material = "sprites/light_ignorez",size = 22,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-102.2,39.4,-2),material = "sprites/light_ignorez",size = 18,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-102.2,-39.4,-2),material = "sprites/light_ignorez",size = 18,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-102.2,39.4,-2),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-102.2,-39.4,-2),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-102.2,39.4,-2),
			Vector( 94.3, 28, -8 ),
		},
		Right = {
			Vector(-102.2,-39.4,-2),
			Vector( 94.3, -28, -8 ),
		},
	}

}
list.Set( "simfphys_lights", "stafford", light_table)

local light_table = {
	L_HeadLampPos = Vector( 110, 24.2, 0.7 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 110, -24.2, 0.7 ),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-120,32.4,-3.6),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-120,-32.4,-3.6),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 130, 24.2, 0.7 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 130, -24.2, 0.7 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 129, 31, 0.7 ),material = "sprites/light_ignorez",size = 26, color = Color( 255,230,230,100)},
		{pos = Vector( 129, -31, 0.7 ),material = "sprites/light_ignorez",size = 26, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 130, 24.2, 0.7 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 130, -24.2, 0.7 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-140,32.4,-3.6),material = "sprites/light_ignorez",size = 22,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-140,-32.4,-3.6),material = "sprites/light_ignorez",size = 22,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-140,32.4,3.6),material = "sprites/light_ignorez",size = 18,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-140,-32.4,3.6),material = "sprites/light_ignorez",size = 18,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-140,32.4,3.6),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-140,-32.4,3.6),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-140,32.4,3.6),
			Vector( 123, 34.5, 0.7 ),
		},
		Right = {
			Vector(-140,-32.4,3.6),
			Vector( 123, -34.5, 0.7 ),
		},
	}

}
list.Set( "simfphys_lights", "stretch", light_table)

local light_table = {
	L_HeadLampPos = Vector( 89, 20, -6.2 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 89, 20, -6.2 ),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-89.3,28,-4.3),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-89.3,-28,-4.3),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 99, 25, -6.2 ),material = "sprites/light_ignorez",size = 34, color = Color( 255,230,230,100)},
		{pos = Vector( 99, -25, -6.2 ),material = "sprites/light_ignorez",size = 34, color = Color( 255,230,230,100)},
		{pos = Vector( 99, 20, -6.2 ),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
		{pos = Vector( 99, -20, -6.2 ),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
		{pos = Vector( 99, 30, -6.2 ),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
		{pos = Vector( 99, -30, -6.2 ),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 99, 25, -6.2 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 99, -25, -6.2 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-99.3,28,-4.3),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-99.3,-28,-4.3),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-99.3,21,-5),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-99.3,-21,-5),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-99.3,21,-5),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-99.3,-21,-5),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-97,36,-5),
			Vector( 94, 37, -6.2 ),
		},
		Right = {
			Vector(-97,-36,-5),
			Vector( 94, -37, -6.2 ),
		},
	}

}
list.Set( "simfphys_lights", "sunrise", light_table)

local light_table = {
	L_HeadLampPos = Vector( 85, 29.8, -3.2 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 85, -29.8, -3.2 ),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-80.4,33,-1.8),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-80.4,-33,-1.8),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 95, 29.8, -3.2 ),material = "sprites/light_ignorez",size = 36, color = Color( 255,230,230,100)},
		{pos = Vector( 95, -29.8, -3.2 ),material = "sprites/light_ignorez",size = 36, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 95, 20.5, -3.2 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 95, -20.5, -3.2 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-100.4,33,-1.8),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-100.4,-33,-1.8),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-100.4,25,-1.8),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-100.4,-25,-1.8),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-100.4,25,-1.8),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-100.4,-25,-1.8),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-99,38,-1.8),
			Vector( 93, 36, -3.2 ),
			Vector( 41.4, 41, -3 ),
		},
		Right = {
			Vector(-99,-38,-1.8),
			Vector( 93, -36, -3.2 ),
			Vector( 41.4, -41, -3 ),
		},
	},

	ems_sounds = {"simulated_vehicles/police/siren_1.wav","simulated_vehicles/police/siren_2.wav"},
	ems_sprites = {
		{
			pos = Vector(95.5,12.9,-2.6),
			material = "sprites/light_glow02_add_noz",
			size = 34,
			Colors = {Color(0,0,255,255),Color(0,0,0,0)},
			Speed = 0.15,
		}, {
			pos = Vector(95.5,-12.9,-2.6),
			material = "sprites/light_glow02_add_noz",
			size = 34,
			Colors = {Color(0,0,0,0),Color(0,0,255,255)},
			Speed = 0.15,
		}, {
			pos = Vector(5,22,27),
			material = "sprites/light_glow02_add_noz",
			size = 34,
			Colors = {Color(0,0,255,255),Color(0,0,0,0)},
			Speed = 0.075,
		}, {
			pos = Vector(-53.5,28,20),
			material = "sprites/light_glow02_add_noz",
			size = 34,
			Colors = {Color(0,0,255,255),Color(0,0,0,0)},
			Speed = 0.2,
		}, {
			pos = Vector(-53.5,-28,20),
			material = "sprites/light_glow02_add_noz",
			size = 34,
			Colors = {Color(0,0,0,0),Color(0,0,255,255)},
			Speed = 0.2,
		}, {
			pos = Vector(22.7,-47.1,4.5),
			material = "sprites/light_glow02_add_noz",
			size = 34,
			Colors = {Color(0,0,0,0),Color(0,0,255,255)},
			Speed = 0.15,
		}, {
			pos = Vector(22.7,47.1,4.5),
			material = "sprites/light_glow02_add_noz",
			size = 34,
			Colors = {Color(0,0,255,255),Color(0,0,0,0)},
			Speed = 0.15,
		},
	},

}
list.Set( "simfphys_lights", "vincent", light_table)

local light_table = {
	L_HeadLampPos = Vector( 84, 22.6, -4.3 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 84, -22.6, -4.3 ),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-80,30.9,0),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-80,-30.9,0),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 94, 22.6, -4.3 ),material = "sprites/light_ignorez",size = 36, color = Color( 255,230,230,100)},
		{pos = Vector( 94, -22.6, -4.3 ),material = "sprites/light_ignorez",size = 36, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 94, 22.6, -4.3 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 94, -22.6, -4.3 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-100,30.9,0),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-100,-30.9,0),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-105.4,11.8,-6.8),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-105.4,-11.8,-6.8),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-105.4,17,-6.8),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-105.4,-17,-6.8),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-105.4,23,-6.8),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-105.4,-23,-6.8),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-105.4,11.8,-6.8),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-105.4,-11.8,-6.8),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-104,33,-6.8),
			Vector( 90, 33, -5 ),
		},
		Right = {
			Vector(-104,-33,-6.8),
			Vector( 90, -33, -5 ),
		},
	},

	ems_sounds = {"simulated_vehicles/police/siren_1.wav","simulated_vehicles/police/siren_2.wav"},
	ems_sprites = {
		{
			pos = Vector(91,-28.7,-6),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(0,0,255,255),Color(255,0,0,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(91,28.7,-6),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(255,0,0,255),Color(0,0,255,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(94,-8,-7),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(0,0,255,255),Color(255,0,0,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(94,8,-7),
			material = "sprites/light_glow02_add_noz",
			size = 38,
			Colors = {Color(255,0,0,255),Color(0,0,255,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(-98,30.1,-1),
			material = "sprites/light_glow02_add_noz",
			size = 34,
			Colors = {Color(255,0,0,255),Color(0,0,255,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(-98,-30.1,-1),
			material = "sprites/light_glow02_add_noz",
			size = 34,
			Colors = {Color(0,0,255,255),Color(255,0,0,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(-60,13,13),
			material = "sprites/light_glow02_add_noz",
			size = 34,
			Colors = {Color(0,0,255,255),Color(255,0,0,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
		{
			pos = Vector(-60,-13,13),
			material = "sprites/light_glow02_add_noz",
			size = 34,
			Colors = {Color(255,0,0,255),Color(0,0,255,255)}, -- the script will go from color to color
			Speed = 0.3, -- for how long each color will be drawn
		},
	}

}
list.Set( "simfphys_lights", "washing", light_table)

local light_table = {
	L_HeadLampPos = Vector( 82.1, 26, 2.5 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 82.1, -26, 2.5 ),
	R_HeadLampAng = Angle(0,0,0),

	L_RearLampPos = Vector(-80,30.9,0),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-80,-30.9,0),
	R_RearLampAng = Angle(0,180,0),

	Headlight_sprites = {
		{pos = Vector( 92.1, 25, 2.5 ),material = "sprites/light_ignorez",size = 36, color = Color( 255,230,230,100)},
		{pos = Vector( 92.1, -25, 2.5 ),material = "sprites/light_ignorez",size = 36, color = Color( 255,230,230,100)},
		{pos = Vector( 92.1, 30, 2.5 ),material = "sprites/light_ignorez",size = 36, color = Color( 255,230,230,100)},
		{pos = Vector( 92.1, -30, 2.5 ),material = "sprites/light_ignorez",size = 36, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 92.1, 28, 2.5 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 92.1, -28, 2.5 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-93.2,30.9,6.6),material = "sprites/light_ignorez",size = 33,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-93.2,-30.9,6.6),material = "sprites/light_ignorez",size = 33,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-93.2,24,6.6),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-93.2,-24,6.6),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-93.2,19,6.6),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-93.2,-19,6.6),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-93.2,19,6.6),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-93.2,-19,6.6),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},

	DelayOn = 0.1,
	DelayOff = 0.1,

	Turnsignal_sprites = {
		Left = {
			Vector(-92,37,6.6),
			Vector( 91, 36, 2.5 ),
		},
		Right = {
			Vector(-92,-37,6.6),
			Vector( 91, -36, 2.5 ),
		},
	}

}
list.Set( "simfphys_lights", "willard", light_table)
