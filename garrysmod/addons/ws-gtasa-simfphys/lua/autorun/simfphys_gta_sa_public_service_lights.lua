local light_table = {
	L_HeadLampPos = Vector( 52.2, 22.6, 1.4 ),
	L_HeadLampAng = Angle(14,0,0),
	R_HeadLampPos = Vector( 52.2, -22.6, 1.4 ),
	R_HeadLampAng = Angle(14,0,0),
	
	L_RearLampPos = Vector(-40.7,25.5,3.9),
	L_RearLampAng = Angle(10,180,0),
	R_RearLampPos = Vector(-40.7,-25.5,3.9),
	R_RearLampAng = Angle(10,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 62.2, 22.6, 1.4 ),material = "sprites/light_ignorez",size = 25, color = Color( 255,230,230,120)},
		{pos = Vector( 62.2, -22.6, 1.4 ),material = "sprites/light_ignorez",size = 25, color = Color( 255,230,230,120)},
	},
	Headlamp_sprites = {
		{pos = Vector( 62.2, 22.6, 1.4 ),material = "sprites/light_ignorez",size = 30, color = Color( 255,235,220,220)},
		{pos = Vector( 62.2, -22.6, 1.4 ),material = "sprites/light_ignorez",size = 30, color = Color( 255,235,220,220)},
	},
	Rearlight_sprites = {
		{pos = Vector(-50.7,25.5,3.9),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  120)},
		{pos = Vector(-50.7,-25.5,3.9),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  120)},
	},
	Brakelight_sprites = {
		{pos = Vector(-50.7,25.5,3.9),material = "sprites/light_ignorez",size = 28,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-50.7,-25.5,3.9),material = "sprites/light_ignorez",size = 28,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-50.7,25.5,1.4),material = "sprites/light_ignorez",size = 20,color = Color( 255, 255, 255, 200)},
		{pos = Vector(-50.7,-25.5,1.4),material = "sprites/light_ignorez",size = 20,color = Color( 255, 255, 255, 200)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-50.7,25.5,1.4),
			Vector( 62.2, 22.3, 7.9),
		},
		Right = {
			Vector(-50.7,-25.5,1.4),
			Vector( 62.2, -22.3, 7.9),
		},
	}

}
list.Set( "simfphys_lights", "baggage", light_table)

local light_table = {
	L_HeadLampPos = Vector( 200.6, 35.2, -6.1),
	L_HeadLampAng = Angle(14,0,0),
	R_HeadLampPos = Vector( 200.6, -35.2, -6.1),
	R_HeadLampAng = Angle(14,0,0),
	
	L_RearLampPos = Vector(-198,30.2,-6.1),
	L_RearLampAng = Angle(10,180,0),
	R_RearLampPos = Vector(-198,-30.2,-6.1),
	R_RearLampAng = Angle(10,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 210.6, 35.2, -6.1),material = "sprites/light_ignorez",size = 25, color = Color( 255,230,230,120)},
		{pos = Vector( 210.6, -35.2, -6.1 ),material = "sprites/light_ignorez",size = 25, color = Color( 255,230,230,120)},
		{pos = Vector( 207, 37, 68.4),material = "sprites/light_ignorez",size = 17, color = Color( 255,125,45,120)},
		{pos = Vector( 207, -37, 68.4 ),material = "sprites/light_ignorez",size = 17, color = Color( 255,125,45,120)},
		{pos = Vector( 207, 0, 68.4 ),material = "sprites/light_ignorez",size = 17, color = Color( 255,125,45,120)},
	},
	Headlamp_sprites = {
		{pos = Vector( 210.6, 29.1, -6.1),material = "sprites/light_ignorez",size = 30, color = Color( 255,235,220,220)},
		{pos = Vector( 210.6, -29.1, -6.1),material = "sprites/light_ignorez",size = 30, color = Color( 255,235,220,220)},
	},
	Rearlight_sprites = {
		{pos = Vector(-208,30.2,-6.1),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  120)},
		{pos = Vector(-208,-30.2,-6.1),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  120)},
		{pos = Vector(-200.5,37.4,68.7),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
		{pos = Vector(-200.5,-37.4,68.7),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
		{pos = Vector(-200.5,0,68.7),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
	},
	Brakelight_sprites = {
		{pos = Vector(-208,30.2,0.7),material = "sprites/light_ignorez",size = 28,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-208,-30.2,0.7),material = "sprites/light_ignorez",size = 28,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-208,37.4,-6.1),material = "sprites/light_ignorez",size = 20,color = Color( 255, 255, 255, 200)},
		{pos = Vector(-208,-37.4,-6.1),material = "sprites/light_ignorez",size = 20,color = Color( 255, 255, 255, 200)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-208,37.4,0.7),
			Vector(-200.5,35.4,68.7),
			Vector( 211, 34.9, 15.8),
			Vector( 207, 35, 68.4),
			Vector( 0, 45.7, 68.7),
		},
		Right = {
			Vector(-208,-37.4,0.7),
			Vector(-200.5,-35.4,68.7),
			Vector( 211, -34.9, 15.8),
			Vector( 207, -35, 68.4),
			Vector( 0, -45.7, 68.7),
		},
	}

}
list.Set( "simfphys_lights", "bus", light_table)

local light_table = {
	L_HeadLampPos = Vector( 88.6, 32.4, 1.4 ),
	L_HeadLampAng = Angle(14,0,0),
	R_HeadLampPos = Vector( 88.6, 32.4, 1.4 ),
	R_HeadLampAng = Angle(14,0,0),
	
	L_RearLampPos = Vector(-88.2,33.8,-8.6),
	L_RearLampAng = Angle(10,180,0),
	R_RearLampPos = Vector(-88.2,-33.8,-8.6),
	R_RearLampAng = Angle(10,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 98.6, 32.4, 1.4 ),material = "sprites/light_ignorez",size = 25, color = Color( 255,230,230,120)},
		{pos = Vector( 98.6, -32.4, 1.4 ),material = "sprites/light_ignorez",size = 25, color = Color( 255,230,230,120)},
	},
	Headlamp_sprites = {
		{pos = Vector( 98.6, 32.4, 1.4 ),material = "sprites/light_ignorez",size = 30, color = Color( 255,235,220,220)},
		{pos = Vector( 98.6, -32.4, 1.4 ),material = "sprites/light_ignorez",size = 30, color = Color( 255,235,220,220)},
	},
	Rearlight_sprites = {
		{pos = Vector(-98.2,33.8,-8.6),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  120)},
		{pos = Vector(-98.2,-33.8,-8.6),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  120)},
		{pos = Vector(-98.2,33.8,-12),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  120)},
		{pos = Vector(-98.2,-33.8,-12),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  120)},
	},
	Brakelight_sprites = {
		{pos = Vector(-97.2,33.8,0.3),material = "sprites/light_ignorez",size = 28,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-97.2,-33.8,0.3),material = "sprites/light_ignorez",size = 28,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-97.2,33.8,0.3),material = "sprites/light_ignorez",size = 20,color = Color( 255, 255, 255, 200)},
		{pos = Vector(-97.2,-33.8,0.3),material = "sprites/light_ignorez",size = 20,color = Color( 255, 255, 255, 200)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-97.2,33.8,0.3),
			Vector(-88.7,39.9,-10),
			Vector( 85.6, 39.6, -10),
		},
		Right = {
			Vector(-97.2,-33.8,0.3),
			Vector(-88.7,-39.9,-10),
			Vector( 85.6, -39.6, -10),
		},
	}

}
list.Set( "simfphys_lights", "cabbie", light_table)

local light_table = {
	L_HeadLampPos = Vector( 192.3, 35.2, -6.1),
	L_HeadLampAng = Angle(14,0,0),
	R_HeadLampPos = Vector( 192.3, -35.2, -6.1),
	R_HeadLampAng = Angle(14,0,0),
	
	L_RearLampPos = Vector(-183.3,42,16.2),
	L_RearLampAng = Angle(10,180,0),
	R_RearLampPos = Vector(-183.3,-42,16.2),
	R_RearLampAng = Angle(10,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 202.3, 35.2, -6.1),material = "sprites/light_ignorez",size = 25, color = Color( 255,230,230,120)},
		{pos = Vector( 202.3, -35.2, -6.1 ),material = "sprites/light_ignorez",size = 25, color = Color( 255,230,230,120)},
		{pos = Vector( 194.4, 34.2, 65.8),material = "sprites/light_ignorez",size = 17, color = Color( 255,125,45,120)},
		{pos = Vector( 194.4, -34.2, 65.8),material = "sprites/light_ignorez",size = 17, color = Color( 255,125,45,120)},
		{pos = Vector( 194.4, 0, 65.8),material = "sprites/light_ignorez",size = 17, color = Color( 255,125,45,120)},
	},
	Headlamp_sprites = {
		{pos = Vector( 202.3, 27.7, -6.1),material = "sprites/light_ignorez",size = 30, color = Color( 255,235,220,220)},
		{pos = Vector( 202.3, -27.7, -6.1),material = "sprites/light_ignorez",size = 30, color = Color( 255,235,220,220)},
	},
	Rearlight_sprites = {
		{pos = Vector(-193.3,42,16.2),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  120)},
		{pos = Vector(-193.3,-42,16.2),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  120)},
		{pos = Vector(-194.7,37.8,61.5),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
		{pos = Vector(-194.7,-37.8,61.5),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
		{pos = Vector(-194.7,0,61.5),material = "sprites/light_ignorez",size = 17,color = Color( 255,125,45,120)},
	},
	Brakelight_sprites = {
		{pos = Vector(-193.3,37,16.2),material = "sprites/light_ignorez",size = 28,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-193.3,-37,16.2),material = "sprites/light_ignorez",size = 28,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-191.5,42.8,45.7),material = "sprites/light_ignorez",size = 28,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-191.5,-42.8,45.7),material = "sprites/light_ignorez",size = 28,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-193.3,37,16.2),material = "sprites/light_ignorez",size = 20,color = Color( 255, 255, 255, 200)},
		{pos = Vector(-193.3,-37,16.2),material = "sprites/light_ignorez",size = 20,color = Color( 255, 255, 255, 200)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-193.3,37,16.2),
			Vector(-194.7,33,61.5),
			Vector( 202.3, 42.4, -6.1),
			Vector( 194.4, 30, 65.8),
			Vector( -175.3, 46.8, 66.9),
		},
		Right = {
			Vector(-193.3,-37,16.2),
			Vector(-194.7,-33,61.5),
			Vector( 202.3, -42.4, -6.1),
			Vector( 194.4, -30, 65.8),
			Vector( -175.3, -46.8, 66.9),
		},
	}

}
list.Set( "simfphys_lights", "coach", light_table)

local light_table = {
	L_HeadLampPos = Vector( 51.2, 17.2, 0.3 ),
	L_HeadLampAng = Angle(14,0,0),
	R_HeadLampPos = Vector( 51.2, -17.2, 0.3 ),
	R_HeadLampAng = Angle(14,0,0),
	
	L_RearLampPos = Vector(-34.2,19.4,-5.4),
	L_RearLampAng = Angle(10,180,0),
	R_RearLampPos = Vector(-34.2,-19.4,-5.4),
	R_RearLampAng = Angle(10,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 61.2, 17.2, 0.3 ),material = "sprites/light_ignorez",size = 28, color = Color( 255,230,230,120)},
		{pos = Vector( 61.2, -17.2, 0.3 ),material = "sprites/light_ignorez",size = 28, color = Color( 255,230,230,120)},
	},
	Headlamp_sprites = {
		{pos = Vector( 61.2, 17.2, 0.3 ),material = "sprites/light_ignorez",size = 30, color = Color( 255,235,220,220)},
		{pos = Vector( 61.2, -17.2, 0.3 ),material = "sprites/light_ignorez",size = 30, color = Color( 255,235,220,220)},
	},
	Rearlight_sprites = {
		{pos = Vector(-44.2,19.4,-5.4),material = "sprites/light_ignorez",size = 17,color = Color( 255, 0, 0,  120)},
		{pos = Vector(-44.2,-19.4,-5.4),material = "sprites/light_ignorez",size = 17,color = Color( 255, 0, 0,  120)},
	},
	Brakelight_sprites = {
		{pos = Vector(-44.2,16.5,-5.4),material = "sprites/light_ignorez",size = 17,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-44.2,-16.5,-5.4),material = "sprites/light_ignorez",size = 17,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-44.2,11.1,-5.4),material = "sprites/light_ignorez",size = 20,color = Color( 255, 255, 255, 200)},
		{pos = Vector(-44.2,-11.1,-5.4),material = "sprites/light_ignorez",size = 20,color = Color( 255, 255, 255, 200)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-44.2,14,-5.4),
			Vector( 62.6, 17.2, -7.5),
		},
		Right = {
			Vector(-44.2,-14,-5.4),
			Vector( 62.6, -17.2, -7.5),
		},
	},
	ems_sounds = {""},
	ems_sprites = {
		{
			pos = Vector(15.8,-14.4,51.1),
			material = "sprites/light_glow02_add_noz",
			size = 30,
			Colors = {Color(0,0,0,0),Color(255,0,0,255)}, -- the script will go from color to color
			Speed = 0.4, -- for how long each color will be drawn
		},
				{
			pos = Vector(15.8,14.4,51.1),
			material = "sprites/light_glow02_add_noz",
			size = 30,
			Colors = {Color(255,0,0,255),Color(0,0,0,0)}, -- the script will go from color to color
			Speed = 0.4, -- for how long each color will be drawn
		}
	}

}
list.Set( "simfphys_lights", "sweeper", light_table)

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
list.Set( "simfphys_lights", "taxi", light_table)

local light_table = {
	L_HeadLampPos = Vector( 87.6, 29.8, 12.9 ),
	L_HeadLampAng = Angle(14,0,0),
	R_HeadLampPos = Vector( 87.6, -29.8, 12.9 ),
	R_HeadLampAng = Angle(14,0,0),
	
	L_RearLampPos = Vector(-87.6,33.8,-5.4),
	L_RearLampAng = Angle(10,180,0),
	R_RearLampPos = Vector(-87.6,-33.8,-5.4),
	R_RearLampAng = Angle(10,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 107.6, 29.8, 12.9 ),material = "sprites/light_ignorez",size = 32, color = Color( 255,230,230,120)},
		{pos = Vector( 107.6, -29.8, 12.9 ),material = "sprites/light_ignorez",size = 32, color = Color( 255,230,230,120)},
		{pos = Vector( 20.8, 27.7, 48.6 ),material = "sprites/light_ignorez",size = 15, color = Color(255,125,45,180)},
		{pos = Vector( 20.8, -27.7, 48.6 ),material = "sprites/light_ignorez",size = 15, color = Color(255,125,45,180)},
		{pos = Vector( 20.8, 0, 48.6 ),material = "sprites/light_ignorez",size = 15, color = Color(255,125,45,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 107.6, 29.8, 12.9 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,235,220,220)},
		{pos = Vector( 107.6, -29.8, 12.9 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,235,220,220)},
	},
	Rearlight_sprites = {
		{pos = Vector(-107.6,33.8,-5.4),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  120)},
		{pos = Vector(-107.6,-33.8,-5.4),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  120)},
	},
	Brakelight_sprites = {
		{pos = Vector(-107.6,33.8,-5.4),material = "sprites/light_ignorez",size = 37,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-107.6,-33.8,-5.4),material = "sprites/light_ignorez",size = 37,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-28,33.8,39.2),material = "sprites/light_ignorez",size = 37,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-28,-33.8,39.2),material = "sprites/light_ignorez",size = 37,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-107.6,33.8,-5.4),material = "sprites/light_ignorez",size = 20,color = Color( 255, 255, 255, 200)},
		{pos = Vector(-107.6,-33.8,-5.4),material = "sprites/light_ignorez",size = 20,color = Color( 255, 255, 255, 200)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-107.6,33.8,-5.4),
			Vector(-28,33.8,39.2),
			Vector( 107.6, 29.8, 5.4),
		},
		Right = {
			Vector(-107.6,-33.8,-5.4),
			Vector(-28,-33.8,39.2),
			Vector( 107.6, -29.8, 5.4),
		},
	},
	ems_sounds = {""},
	ems_sprites = {
		{
			pos = Vector(-17.2,-24.4,55.8),
			material = "sprites/light_glow02_add_noz",
			size = 30,
			Colors = {Color(0,0,0,0),Color(255,0,0,255)}, -- the script will go from color to color
			Speed = 0.4, -- for how long each color will be drawn
		},
		{
			pos = Vector(-17.2,-20,55.8),
			material = "sprites/light_glow02_add_noz",
			size = 30,
			Colors = {Color(0,0,0,0),Color(255,0,0,255)}, -- the script will go from color to color
			Speed = 0.4, -- for how long each color will be drawn
		},
		{
			pos = Vector(-17.2,24.4,55.8),
			material = "sprites/light_glow02_add_noz",
			size = 30,
			Colors = {Color(255,0,0,255),Color(0,0,0,0)}, -- the script will go from color to color
			Speed = 0.4, -- for how long each color will be drawn
		},
		{
			pos = Vector(-17.2,20,55.8),
			material = "sprites/light_glow02_add_noz",
			size = 30,
			Colors = {Color(255,0,0,255),Color(0,0,0,0)}, -- the script will go from color to color
			Speed = 0.4, -- for how long each color will be drawn
		}
	}

}
list.Set( "simfphys_lights", "towtruck", light_table)

local light_table = {
	L_HeadLampPos = Vector( 157.8, 33.8, -13.6 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 157.8, -33.8, -13.6 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-127.6,30.6,-16.9),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-127.6,-30.6,-16.9),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 177.8, 33.8, -13.6 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 177.8, -33.8, -13.6 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 177.8, 33.8, -13.6 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 177.8, -33.8, -13.6 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-111.6,24.6,51.2),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-111.6,-24.6,51.2),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-147.6,30.6,-16.9),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-147.6,-30.6,-16.9),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-111.6,24.6,57.2),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-111.6,-24.6,57.2),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-147.6,30.6,-16.9),
			Vector(-111,18.7,62.6),
			Vector( 174.9, 33.8, -5.4 ),
		},
		Right = {
			Vector(-147.6,-30.6,-16.9),
			Vector(-111,-18.7,62.6),
			Vector( 174.9, -33.8, -5.4 ),
		},
	}

}
list.Set( "simfphys_lights", "trash", light_table)

local light_table = {
	L_HeadLampPos = Vector( 41.8, 23, 11.1),
	L_HeadLampAng = Angle(14,0,0),
	R_HeadLampPos = Vector( 41.8, -23, 11.1),
	R_HeadLampAng = Angle(14,0,0),
	
	L_RearLampPos = Vector(-48.6,18.3,12.6),
	L_RearLampAng = Angle(10,180,0),
	R_RearLampPos = Vector(-48.6,-18.3,12.6),
	R_RearLampAng = Angle(10,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 51.8, 23, 11.1),material = "sprites/light_ignorez",size = 25, color = Color( 255,230,230,120)},
		{pos = Vector( 51.8, -23, 11.1),material = "sprites/light_ignorez",size = 25, color = Color( 255,230,230,120)},
	},
	Headlamp_sprites = {
		{pos = Vector( 51.8, 23, 11.1),material = "sprites/light_ignorez",size = 30, color = Color( 255,235,220,220)},
		{pos = Vector( 51.8, -23, 11.1),material = "sprites/light_ignorez",size = 30, color = Color( 255,235,220,220)},
	},
	Rearlight_sprites = {
		{pos = Vector(-58.6,18.3,12.6),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  120)},
		{pos = Vector(-58.6,-18.3,12.6),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  120)},
	},
	Brakelight_sprites = {
		{pos = Vector(-58.6,18.3,12.6),material = "sprites/light_ignorez",size = 28,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-58.6,-18.3,12.6),material = "sprites/light_ignorez",size = 28,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-58.6,0,12),material = "sprites/light_ignorez",size = 20,color = Color( 255, 255, 255, 200)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-49,18.7,50.4),
			Vector( -3.2, 18.7, 51.4),
		},
		Right = {
			Vector(-49.6,-19.8,25.2),
			Vector( -3.2, -18.7, 51.4),
		},
	}

}
list.Set( "simfphys_lights", "tug", light_table)

local light_table = {
	L_HeadLampPos = Vector( 102.6, 31.6, 13.6 ),
	L_HeadLampAng = Angle(14,0,0),
	R_HeadLampPos = Vector( 102.6, -31.6, 13.6 ),
	R_HeadLampAng = Angle(14,0,0),
	
	L_RearLampPos = Vector(-90.4,36,29.5),
	L_RearLampAng = Angle(10,180,0),
	R_RearLampPos = Vector(-90.4,-36,29.5),
	R_RearLampAng = Angle(10,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 112.6, 31.6, 13.6 ),material = "sprites/light_ignorez",size = 36, color = Color( 255,230,230,120)},
		{pos = Vector( 112.6, -31.6, 13.6 ),material = "sprites/light_ignorez",size = 36, color = Color( 255,230,230,120)},
	},
	Headlamp_sprites = {
		{pos = Vector( 112.6, 31.6, 13.6 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,235,220,220)},
		{pos = Vector( 112.6, -31.6, 13.6 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,235,220,220)},
	},
	Rearlight_sprites = {
		{pos = Vector(-109.4,36,29.5),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  120)},
		{pos = Vector(-109.4,-36,29.5),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  120)},
	},
	Brakelight_sprites = {
		{pos = Vector(-109.4,36,29.5),material = "sprites/light_ignorez",size = 37,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-109.4,-36,29.5),material = "sprites/light_ignorez",size = 37,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-109.4,36,21.9),material = "sprites/light_ignorez",size = 20,color = Color( 255, 255, 255, 200)},
		{pos = Vector(-109.4,-36,21.9),material = "sprites/light_ignorez",size = 20,color = Color( 255, 255, 255, 200)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-109.4,36,21.9),
			Vector(110.5,38.5,13.6),
		},
		Right = {
			Vector(-109.4,-36,21.9),
			Vector(110.5,-38.5,13.6),
		},
	}

}
list.Set( "simfphys_lights", "utility", light_table)