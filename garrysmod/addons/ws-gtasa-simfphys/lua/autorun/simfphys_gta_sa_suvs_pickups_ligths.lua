local light_table = {
	L_HeadLampPos = Vector( 80, 27, -1 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 80, -27, -1 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-80,34.5,2),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-80,-34,2),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 80, 27, -1 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,180,150)},
		{pos = Vector( 80, -27, -1 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,180,150)},
		
		
	},
	Headlamp_sprites = {
		{pos = Vector( 80, 27, -1 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 80, -27, -1 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-87,34,-3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-87,-34,-3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-87,34,-8),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-87,-34,-8),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-87,32,-8),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-87,-32,-8),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-14,0,26),material = "sprites/light_ignorez",size = 30,color = Color( 255, 255, 205, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-87,35,-3),
			Vector( 80, 28, -9 ),
			Vector( 54, 38, -2 ),
		},
		Right = {
			Vector(-87,-35,-3),
			Vector( 80, -28, -9 ),
			Vector( 54, -38, -2 ),
		},
	}

}
list.Set( "simfphys_lights", "bobcat", light_table)

local light_table = {
	L_HeadLampPos = Vector( 87, 31, 4 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 87, -31, 4 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-102,38,5),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-102,-38,5),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 87, 31, 4 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,230,210,150)},
		{pos = Vector( 87, -31, 4 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,230,210,150)},
		
		
	},
	Headlamp_sprites = {
		{pos = Vector( 87, 31, 4 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 87, -31, 4 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-102,38,5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-102,-38,5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-102,38,5),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-102,-38,5),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-102,38,2),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-102,-38,2),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-101,40,2),
			Vector( 85, 38, 4 ),
		},
		Right = {
			Vector(-101,-40,2),
			Vector( 85, -38, 4 ),
		},
	}

}
list.Set( "simfphys_lights", "huntley", light_table)

local light_table = {
	L_HeadLampPos = Vector( 75, 22, -2 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 75, -22, -2 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-83,34,-3),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-83,-34,-3),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 75, 22, -2 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,230,210,150)},
		{pos = Vector( 75, -22, -2 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,230,210,150)},
		
		
	},
	Headlamp_sprites = {
		{pos = Vector( 75, 22, -2 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 75, -22, -2 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-83,34,-3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-83,-34,-3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-83,34,-3),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-83,-34,-3),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-83,32,-3),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-83,-32,-3),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-83,34,-3),
			Vector( 74, 33, -2 ),
			Vector( 77, 25, -21 ),
		},
		Right = {
			Vector(-83,-34,-3),
			Vector( 74, -33, -2 ),
			Vector( 77, -25, -21 ),
		},
	}

}
list.Set( "simfphys_lights", "Landstalker", light_table)

local light_table = {
	L_HeadLampPos = Vector( 72, 16, 0 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 72, -16, 0 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-68,28,1),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-68,-28,1),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 72, 16, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
		{pos = Vector( 72, -16, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
		
		
	},
	Headlamp_sprites = {
		{pos = Vector( 72, 16, 0 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
		{pos = Vector( 72, -16, 0 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-70,28,1),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-70,-28,1),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-70,28,1),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-70,-28,1),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-70,28,1),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-70,-28,1),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-70,28,-2),
			Vector( 69, 33, -1 ),
			Vector( 76, 15, -8 ),
		},
		Right = {
			Vector(-70,-28,-2),
			Vector( 69, -33, -1 ),
			Vector( 76, -15, -8 ),
		},
	}

}
list.Set( "simfphys_lights", "mesa", light_table)

local light_table = {
	L_HeadLampPos = Vector( 100, 34, 25 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 100, -34, 25 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-111,42,28),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-111,-42,28),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 100, 34, 25 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
		{pos = Vector( 100, -34, 25 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
		
		
	},
	Headlamp_sprites = {
		{pos = Vector( 100, 34, 25 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
		{pos = Vector( 100, -34, 25 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-111,42,28),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-111,-42,28),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-111,42,28),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-111,-42,28),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-111,42,28),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-111,-42,28),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-111,42,23),
			Vector( 99, 41, 25 ),
		},
		Right = {
			Vector(-111,-42,23),
			Vector( 99, -41, 25 ),
		},
	}

}
list.Set( "simfphys_lights", "monster", light_table)

local light_table = {
	L_HeadLampPos = Vector( 95, 35, 25 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 95, -35, 25 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-107,40,28),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-107,-40,28),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 95, 35, 25 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
		{pos = Vector( 95, -35, 25 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
		
		
	},
	Headlamp_sprites = {
		{pos = Vector( 95, 35, 25 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
		{pos = Vector( 95, -35, 25 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-107,40,28),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-107,-40,28),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-107,40,28),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-107,-40,28),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-107,40,28),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-107,-40,28),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-107,40,23),
			Vector( 95, 35, 19 ),
		},
		Right = {
			Vector(-107,-40,23),
			Vector( 95, -35, 19 ),
		},
	}

}
list.Set( "simfphys_lights", "monstera", light_table)


local light_table = {
	L_HeadLampPos = Vector( 92, 34, 26 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 92, -34, 26 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-101,42,28),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-101,-42,28),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 92, 34, 26 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
		{pos = Vector( 92, -34, 26 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
		{pos = Vector( 92, 26, 26 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
		{pos = Vector( 92, -26, 26 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
		
	},
	Headlamp_sprites = {
		{pos = Vector( 14, 25, 62 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
		{pos = Vector( 14, -25, 62 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
		{pos = Vector( 14, 8, 62 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
		{pos = Vector( 14, -8, 62 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-101,42,28),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-101,-42,28),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-101,42,28),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-101,-42,28),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-101,42,28),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-101,-42,28),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-101,42,23),
			Vector( 90, 42, 26 ),
		},
		Right = {
			Vector(-101,-42,23),
			Vector( 90, -42, 26 ),
		},
	}

}
list.Set( "simfphys_lights", "monsterb", light_table)


local light_table = {
	L_HeadLampPos = Vector( 78, 30, 9 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 78, -30, 9 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-90,30,6),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-90,-30,6),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 78, 30, 9 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
		{pos = Vector( 78, -30, 9 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
	},
	Headlamp_sprites = {
		{pos = Vector( 78, 30, 9 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
		{pos = Vector( 78, -30, 9 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-90,30,6),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-90,-30,6),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-95,28,-9),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-95,-28,-9),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-95,21,-9),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-95,-21,-9),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-96,37,-7),
			Vector(-94,37,4),
			Vector(-86,41,2),
			Vector( 74, 41, 9 ),
			Vector( 79, 37, 7 ),
		},
		Right = {
			Vector(-96,-37,-7),
			Vector(-94,-37,4),
			Vector(-86,-41,2),
			Vector( 74, -41, 9 ),
			Vector( 79, -37, 7 ),
		},
	}

}
list.Set( "simfphys_lights", "patriot", light_table)

local light_table = {
	L_HeadLampPos = Vector( 96, 30, -1 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 96, -30, -1 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-97,36,3),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-68,-28,1),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 96, 30, -1 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
		{pos = Vector( 96, -30, -1 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
		
		
	},
	Headlamp_sprites = {
		{pos = Vector( 96, 30, -1 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
		{pos = Vector( 96, -30, -1 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-97,36,3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-97,-36,3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-97,36,3),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-97,-36,3),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-97,36,-1),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-97,-36,-1),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-97,36,-1),
			Vector( 100, 30, -9 ),
		},
		Right = {
			Vector(-97,-36,-1),
			Vector( 100, -30, -9 ),
		},
	}

}
list.Set( "simfphys_lights", "picador", light_table)

local light_table = {
	L_HeadLampPos = Vector( 93, 30, 1 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 93, -30, 1 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-96,41,-3),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-96,-41,-3),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 93, 30, 1 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,230,210,150)},
		{pos = Vector( 93, -30, 1 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,230,210,150)},
	},
	Headlamp_sprites = {
		{pos = Vector( 93, 30, 1 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
		{pos = Vector( 93, -30, 1 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-96,41,-3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-96,-41,-3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-96,41,-3),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-96,-41,-3),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-96,41,-3),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-96,-41,-3),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			{pos = Vector(-96,41,5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 205, 50, 250)},
			Vector( 99, 31, -16 ),
			{pos = Vector( 92, 40, -4 ),material = "sprites/light_ignorez",size = 15,color = Color( 255, 205, 50, 250)},
			{pos = Vector( 92, 40, -1 ),material = "sprites/light_ignorez",size = 15,color = Color( 255, 205, 50, 250)},
			{pos = Vector( 92, 40, 2 ),material = "sprites/light_ignorez",size = 15,color = Color( 255, 205, 50, 250)},
			{pos = Vector( 92, 40, 5 ),material = "sprites/light_ignorez",size = 15,color = Color( 255, 205, 50, 250)},
			
		},
		Right = {
			{pos = Vector(-96,-41,5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 205, 50, 250)},
			Vector( 99, -31, -16 ),
			{pos = Vector( 92, -40, -4 ),material = "sprites/light_ignorez",size = 15,color = Color( 255, 205, 50, 250)},
			{pos = Vector( 92, -40, -1 ),material = "sprites/light_ignorez",size = 15,color = Color( 255, 205, 50, 250)},
			{pos = Vector( 92, -40, 2 ),material = "sprites/light_ignorez",size = 15,color = Color( 255, 205, 50, 250)},
			{pos = Vector( 92, -40, 5 ),material = "sprites/light_ignorez",size = 15,color = Color( 255, 205, 50, 250)},
			
		},
	}

}
list.Set( "simfphys_lights", "rancher", light_table)

local light_table = {
	L_HeadLampPos = Vector( 82, 28, 3 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 82, -28, 3 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-95,36,-5),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-95,-36,-5),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 82, 28, 3 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
		{pos = Vector( 82, -28, 3 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,210,150)},
		
		
	},
	Headlamp_sprites = {
		{pos = Vector( 82, 28, 3 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,235,220,170)},
		{pos = Vector( 82, -28, 3 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-95,36,-5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-95,-36,-5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-95,36,-5),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-95,-36,-5),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-95,36,-5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-95,-36,-5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-95,36,0),
		},
		Right = {
			Vector(-95,-36,0),
		},
	}

}
list.Set( "simfphys_lights", "sadler", light_table)

local light_table = {
	L_HeadLampPos = Vector( 89, 30, 0 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 89, -30, 0 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-82,37,-1),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-95,-36,-5),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 89, 30, 0 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,230,210,150)},
		{pos = Vector( 89, -30, 0 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,230,210,150)},
		{pos = Vector( 90, 30, -20 ),material = "sprites/light_ignorez",size = 26, color = Color( 255,230,210,150)},
		{pos = Vector( 90, -30, -20 ),material = "sprites/light_ignorez",size = 26, color = Color( 255,230,210,150)},
	},
	Headlamp_sprites = {
		{pos = Vector( 89, 30, 0 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,235,220,170)},
		{pos = Vector( 89, -30, 0 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-82,37,-1),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-82,-37,-1),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-82,37,-1),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-82,-37,-1),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-82,37,-1),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-82,-37,-1),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-78,42,-1),
			Vector( 86, 40, 0 ),
		},
		Right = {
			Vector(-78,-42,-1),
			Vector( 86, -40, 0 ),
		},
	}

}
list.Set( "simfphys_lights", "sandking", light_table)

local light_table = {
	L_HeadLampPos = Vector( 78, 32, 2 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 78, -32, 2 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-92,38,-10),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-92,-38,-10),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 78, 32, 2 ),material = "sprites/light_ignorez",size = 36, color = Color( 255,230,210,150)},
		{pos = Vector( 78, -32, 2 ),material = "sprites/light_ignorez",size = 36, color = Color( 255,230,210,150)},
	},
	Headlamp_sprites = {
		{pos = Vector( 78, 32, 2 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,235,220,170)},
		{pos = Vector( 78, -32, 2 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-92,38,-10),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-92,-38,-10),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-92,38,-10),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-92,-38,-10),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-92,-31,-10),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-92,38,-10),
			Vector( 72, 40, 3 ),
		},
		Right = {
			Vector(-92,-38,-10),
			Vector( 72, -40, 3 ),
		},
	}

}
list.Set( "simfphys_lights", "walton", light_table)


local light_table = {
	L_HeadLampPos = Vector( 93, 34, 4 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 93, -34, 4 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-104,42,5),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-104,-42,5),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 93, 34, 4 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,230,210,150)},
		{pos = Vector( 93, -34, 4 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,230,210,150)},

	},
	Headlamp_sprites = {
		{pos = Vector( 93, 24, 4 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,235,220,170)},
		{pos = Vector( 93, -24, 4 ),material = "sprites/light_ignorez",size = 42, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-104,42,5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-104,-42,5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-104,42,5),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-104,-42,5),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-104,42,0),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-104,-42,0),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.01,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-104,42,0),
			Vector( 90, 42, 4 ),
		},
		Right = {
			Vector(-104,-42,0),
			Vector( 90, -42, 4 ),
		},
	}

}
list.Set( "simfphys_lights", "yosemite", light_table)