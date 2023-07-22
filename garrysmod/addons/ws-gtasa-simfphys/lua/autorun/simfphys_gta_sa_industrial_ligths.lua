local light_table = {
	L_HeadLampPos = Vector( 90, 28, 1 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 90, -28, 1 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-124,41,7),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-124,-41,7),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 90, 28, 1 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
		{pos = Vector( 90, -28, 1 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 90, 28, 1 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 90, -28, 1 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-124,41,7),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-124,-41,7),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-124,41,7),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-124,-41,7),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-124,41,7),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-124,-41,7),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-124,41,2),
			Vector( 89, 26, -7 ),
			Vector( 89, 29, -7 ),
		},
		Right = {
			Vector(-124,-41,2),
			Vector( 89, -26, -7 ),
			Vector( 89, -29, -7 ),
		},
	}

}
list.Set( "simfphys_lights", "benson", light_table)

local light_table = {
	L_HeadLampPos = Vector( 110, 32, -3 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 110, -32, -3 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-110,32,7),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-110,-32,7),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 110, 32, -3 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,180)},
		{pos = Vector( 110, -32, -3 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 110, 32, -3 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 110, -32, -3 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-110,37,7),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-110,-37,7),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
	},
	Brakelight_sprites = {
		{pos = Vector(-110,32,7),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-110,-32,7),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-110,32,7),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-110,-32,7),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-110,37,13),
			Vector( 112, 33, 8 ),
			Vector( 112, 30, 8 ),
		},
		Right = {
			Vector(-110,-37,13),
			Vector( 112, -33, 8 ),
			Vector( 112, -30, 8 ),
		},
	}

}
list.Set( "simfphys_lights", "boxville", light_table)

local light_table = {
	L_HeadLampPos = Vector( 145, 40, -21 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 145, -40, -21 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-143,43,-39),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-143,-43,-39),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 145, 40, -21 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,180)},
		{pos = Vector( 145, -40, -21 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 145, 40, -21 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 145, -40, -21 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-142,43,-39),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-142,-43,-39),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
	},
	Brakelight_sprites = {
		{pos = Vector(-142,37,-39),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-142,-37,-39),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-142,37,-39),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-142,-37,-39),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-142,43,-39),
			Vector( 133, 34, -1 ),
		},
		Right = {
			Vector(-142,-43,-39),
			Vector( 133, -34, -1 ),
		},
	}

}
list.Set( "simfphys_lights", "cement", light_table)

local light_table = {
	L_HeadLampPos = Vector( 155, 65, 46 ),
	L_HeadLampAng = Angle(40,0,0),
	R_HeadLampPos = Vector( 145, -40, -21 ),
	R_HeadLampAng = Angle(10,0,0),
	
	L_RearLampPos = Vector(-10,43,-39),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-10,-43,-39),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 155, 65, 46 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,180)},
		{pos = Vector( 112, -52, 31 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 112, -52, 37 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {

	},
	Brakelight_sprites = {

	},
	Reverselight_sprites = {

	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector( 112, -52, 37 ),
		},
		Right = {
			Vector( 112, -52, 37 ),
		},
	}

}
list.Set( "simfphys_lights", "combine", light_table)

local light_table = {
	L_HeadLampPos = Vector( 158, 30, -16 ),
	L_HeadLampAng = Angle(15,0,0),
	R_HeadLampPos = Vector( 158, -30, -16 ),
	R_HeadLampAng = Angle(15,0,0),
	
	L_RearLampPos = Vector(-197,43,-18),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-197,-43,-18),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 158, 30, -16 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,180)},
		{pos = Vector( 158, -30, -16 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,180)},
		{pos = Vector( 158, 32, -32 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,180)},
		{pos = Vector( 158, -32, -32 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,180)},
		{pos = Vector( 159, 24, -32 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,180)},
		{pos = Vector( 159, -24, -32 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 158, 30, -16 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 158, -30, -16 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-197,43,-18),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-197,-43,-18),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
	},
	Brakelight_sprites = {
		{pos = Vector(-197,35,-18),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-197,-35,-18),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-197,35,-18),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-197,-35,-18),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-197,35,-18),
			Vector( 158, 43, -6 ),
		},
		Right = {
			Vector(-197,-35,-18),
			Vector( 158, -43, -6 ),
		},
	}

}
list.Set( "simfphys_lights", "dft30", light_table)

local light_table = {
	L_HeadLampPos = Vector( 55, 25, 38 ),
	L_HeadLampAng = Angle(13,0,0),
	R_HeadLampPos = Vector( 55, -25, 38 ),
	R_HeadLampAng = Angle(13,0,0),
	
	L_RearLampPos = Vector(-118,21,34),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-118,-21,34),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 55, 25, 38 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,180)},
		{pos = Vector( 55, -25, 38 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,180)},
		{pos = Vector( 55, 33, 38 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,120)},
		{pos = Vector( 55, -33, 38 ),material = "sprites/light_ignorez",size = 49, color = Color( 255,230,230,120)},
	},
	Headlamp_sprites = {
		{pos = Vector( 55, 25, 38 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 55, -25, 38 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-118,21,34),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-118,-21,34),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  190)},
	},
	Brakelight_sprites = {
		{pos = Vector(-118,21,34),material = "sprites/light_ignorez",size = 37,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-118,-21,34),material = "sprites/light_ignorez",size = 37,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-118,21,41),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-118,-21,41),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-118,21,41),
			Vector( 55, 33, 38 ),
		},
		Right = {
			Vector(-118,-21,41),
			Vector( 55, -33, 38 ),
		},
	}

}
list.Set( "simfphys_lights", "dozer", light_table)

local light_table = {
	L_HeadLampPos = Vector( 194, 36, 0 ),
	L_HeadLampAng = Angle(20,0,0),
	R_HeadLampPos = Vector( 194, -36, 0 ),
	R_HeadLampAng = Angle(20,0,0),
	
	L_RearLampPos = Vector(-99,16,-18),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-99,-16,-18),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 194, 36, -12 ),material = "sprites/light_ignorez",size = 55, color = Color( 255,230,230,180)},
		{pos = Vector( 194, -36, -12 ),material = "sprites/light_ignorez",size = 55, color = Color( 255,230,230,180)},
		{pos = Vector( 194, 36, 0 ),material = "sprites/light_ignorez",size = 55, color = Color( 255,230,230,180)},
		{pos = Vector( 194, -36, 0 ),material = "sprites/light_ignorez",size = 55, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 194, 36, 0 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 194, -36, 0 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-99,24,-18),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-99,-24,-18),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-184,80,17),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-184,-80,17),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
	},
	Brakelight_sprites = {
		{pos = Vector(-99,16,-18),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-99,-16,-18),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-99,16,-18),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-99,-16,-18),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-184,80,17),
			Vector(42,80,5),
			Vector( 179, 80, -1 ),
		},
		Right = {
			Vector(-184,-80,17),
			Vector(42,-80,5),
			Vector( 179, -68, -1 ),
		},
	}

}
list.Set( "simfphys_lights", "dumper", light_table)

local light_table = {
	L_HeadLampPos = Vector( 134, 45, -3 ),
	L_HeadLampAng = Angle(10,0,0),
	R_HeadLampPos = Vector( 134, -45, -3 ),
	R_HeadLampAng = Angle(10,0,0),
	
	L_RearLampPos = Vector(-165,40,-27),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-165,-40,-27),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 134, 45, -3 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,230,230,180)},
		{pos = Vector( 134, -45, -3 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 145, 26, -5 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 145, -26, -5 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-171,40,-3.5),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-171,-40,-3.5),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-171,49,-3.5),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-171,-49,-3.5),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  190)},
	},
	Brakelight_sprites = {
		{pos = Vector(-165,40,-27),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-165,-40,-27),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-165,40,-27),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-165,-40,-27),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-163,50,-27),
			Vector( 145, 29, -7 ),
		},
		Right = {
			Vector(-163,-50,-27),
			Vector( 145, -29, -7 ),
		},
	}

}
list.Set( "simfphys_lights", "flatbed", light_table)

local light_table = {
	L_HeadLampPos = Vector( 14, 18, 44 ),
	L_HeadLampAng = Angle(20,0,0),
	R_HeadLampPos = Vector( 14, -18, 44 ),
	R_HeadLampAng = Angle(20,0,0),
	
	L_RearLampPos = Vector(-34,18,32),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-34,-18,32),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 14, 18, 44 ),material = "sprites/light_ignorez",size = 22, color = Color( 255,230,230,180)},
		{pos = Vector( 14, -18, 44 ),material = "sprites/light_ignorez",size = 22, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 14, 18, 44 ),material = "sprites/light_ignorez",size = 30, color = Color( 255,235,220,170)},
		{pos = Vector( 14, -18, 44 ),material = "sprites/light_ignorez",size = 30, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-34,18,32),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-34,-18,32),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  190)},
	},
	Brakelight_sprites = {
		{pos = Vector(-34,18,32),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-34,-18,32),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-28,14,51),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-34,18,32),
			Vector( 14, 18, 44 ),
		},
		Right = {
			Vector(-34,-18,32),
			Vector( 14, -18, 44 ),
		},
	}

}
list.Set( "simfphys_lights", "forklift", light_table)

local light_table = {
	L_HeadLampPos = Vector( 153, 40, -9 ),
	L_HeadLampAng = Angle(10,0,0),
	R_HeadLampPos = Vector( 153, -40, -9 ),
	R_HeadLampAng = Angle(10,0,0),
	
	L_RearLampPos = Vector(-149,14,-34),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-149,-14,-34),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 153, 40, -9 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,180)},
		{pos = Vector( 153, -40, -9 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,180)},
		{pos = Vector( 153, 32, -9 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,180)},
		{pos = Vector( 153, -32, -9 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 153, 40, -9 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 153, -40, -9 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 153, 32, -9 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 153, -32, -9 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-149,14,-34),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-149,-14,-34),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  190)},
	},
	Brakelight_sprites = {
		{pos = Vector(-149,10,-34),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-149,-10,-34),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-149,12,-28),material = "sprites/light_ignorez",size = 27,color = Color( 255, 255, 255, 200)},
		{pos = Vector(-149,-12,-28),material = "sprites/light_ignorez",size = 27,color = Color( 255, 255, 255, 200)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-149,12,-28),
			Vector( 158, 34, -29 ),
			Vector( 158, 37, -29 ),
			Vector( 150, 51, -18 ),
			Vector( 129, 51, -7 ),
			Vector( 107, 51, -18 ),
			Vector( 81, 24, 53 ),
			Vector( 0, 43, 65 ),
			Vector( -34, 43, 65 ),
		},
		Right = {
			Vector(-149,-12,-28),
			Vector( 158, -34, -29 ),
			Vector( 158, -37, -29 ),
			Vector( 150, -51, -18 ),
			Vector( 129, -51, -7 ),
			Vector( 107, -51, -18 ),
			Vector( 81, -24, 53 ),
			Vector( 0, -43, 65 ),
			Vector( -34, -43, 65 ),
		},
	}

}
list.Set( "simfphys_lights", "linerun", light_table)

local light_table = {
	L_HeadLampPos = Vector( 100, 25, 4 ),
	L_HeadLampAng = Angle(8,0,0),
	R_HeadLampPos = Vector( 100, -25, 4 ),
	R_HeadLampAng = Angle(8,0,0),
	
	L_RearLampPos = Vector(-123.2,39,7),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-123.2,-39,7),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 100, 25, 4 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
		{pos = Vector( 100, -25, 4 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 100, 25, 4 ),material = "sprites/light_ignorez",size = 48, color = Color( 255,235,220,170)},
		{pos = Vector( 100, -25, 4 ),material = "sprites/light_ignorez",size = 48, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-123.2,39,2),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-123.2,-39,2),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-123.2,39,7),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-123.2,-39,7),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-123.2,39,15),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-123.2,-39,15),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-123.2,39,15),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-123.2,-39,15),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-123.2,39,15),
			Vector(-123.2,39,75),
			Vector(-123.2,39,72),
			Vector( 100, 24, -3 ),
			Vector( 100, 27, -3 ),
		},
		Right = {
			Vector(-123.2,-39,15),
			Vector(-123.2,-39,75),
			Vector(-123.2,-39,72),
			Vector( 100, -24, -3 ),
			Vector( 100, -27, -3 ),
		},
	}

}
list.Set( "simfphys_lights", "mule", light_table)

local light_table = {
	L_HeadLampPos = Vector( 207, 42, -13 ),
	L_HeadLampAng = Angle(11,0,0),
	R_HeadLampPos = Vector( 207, -42, -13 ),
	R_HeadLampAng = Angle(11,0,0),
	
	L_RearLampPos = Vector(-260,50,-32),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-260,-50,-32),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 207, 42, -13 ),material = "sprites/light_ignorez",size = 43, color = Color( 255,230,230,180)},
		{pos = Vector( 207, -42, -13 ),material = "sprites/light_ignorez",size = 43, color = Color( 255,230,230,180)},
		{pos = Vector( 207, 32, -13 ),material = "sprites/light_ignorez",size = 43, color = Color( 255,230,230,180)},
		{pos = Vector( 207, -32, -13 ),material = "sprites/light_ignorez",size = 43, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 207, 42, -13 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 207, -42, -13 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 207, 32, -13 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 207, -32, -13 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-260,50,-32),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-260,-50,-32),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  190)},
	},
	Brakelight_sprites = {
		{pos = Vector(-260,50,-28),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-260,-50,-28),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-260,50,-28),material = "sprites/light_ignorez",size = 27,color = Color( 255, 255, 255, 200)},
		{pos = Vector(-260,-50,-28),material = "sprites/light_ignorez",size = 27,color = Color( 255, 255, 255, 200)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-260,50,-28),
			Vector(-247,54,-26),
			Vector(-126, 54, -7 ),
			Vector(-108.5, 54, -36.5 ),
			Vector(-15, 54, -8 ),
			Vector(62, 54, -7 ),
			Vector(-15, 54, -36 ),
			Vector(211, 38, -36 ),
			Vector(210, 40, -36 ),
		},
		Right = {
			Vector(-260,-50,-28),
			Vector(-247,-54,-26),
			Vector(-126, -54, -7 ),
			Vector(-108.5, -54, -36.5 ),
			Vector(-15, -54, -8 ),
			Vector(62, -54, -7 ),
			Vector(-15, -54, -36 ),
			Vector(211, -38, -36 ),
			Vector(210, -40, -36 ),
		},
	}

}
list.Set( "simfphys_lights", "packer", light_table)

local light_table = {
	L_HeadLampPos = Vector( 165, 44, -28 ),
	L_HeadLampAng = Angle(14,0,0),
	R_HeadLampPos = Vector( 165, -44, -28 ),
	R_HeadLampAng = Angle(14,0,0),
	
	L_RearLampPos = Vector(-183,48,-40),
	L_RearLampAng = Angle(10,180,0),
	R_RearLampPos = Vector(-183,-48,-40),
	R_RearLampAng = Angle(10,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 165, 52, -28 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,230,230,180)},
		{pos = Vector( 165, -52, -28 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,230,230,180)},
		{pos = Vector( 165, 44, -28 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,230,230,180)},
		{pos = Vector( 165, -44, -28 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,230,230,180)},
		{pos = Vector( 161, 47, -16 ),material = "sprites/light_ignorez",size = 53, color = Color( 255,230,230,180)},
		{pos = Vector( 161, -47, -16 ),material = "sprites/light_ignorez",size = 53, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 161, 47, -16 ),material = "sprites/light_ignorez",size = 58, color = Color( 255,235,220,170)},
		{pos = Vector( 161, -47, -16 ),material = "sprites/light_ignorez",size = 58, color = Color( 255,235,220,170)},
		{pos = Vector( 80, 26, 46 ),material = "sprites/light_ignorez",size = 60, color = Color( 255,235,220,220)},
		{pos = Vector( 80, -26, 46 ),material = "sprites/light_ignorez",size = 60, color = Color( 255,235,220,220)},
		{pos = Vector( 80, 0, 47 ),material = "sprites/light_ignorez",size = 60, color = Color( 255,235,220,220)},
	},
	Rearlight_sprites = {
		{pos = Vector(-183,48,-40),material = "sprites/light_ignorez",size = 42,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-183,-48,-40),material = "sprites/light_ignorez",size = 42,color = Color( 255, 0, 0,  190)},
	},
	Brakelight_sprites = {
		{pos = Vector(-183,38,-40),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-183,-38,-40),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-183,38,-40),material = "sprites/light_ignorez",size = 30,color = Color( 255, 255, 255, 200)},
		{pos = Vector(-183,-38,-40),material = "sprites/light_ignorez",size = 30,color = Color( 255, 255, 255, 200)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-183,38,-40),
			Vector( 169, 37, -39 ),
		},
		Right = {
			Vector(-183,-38,-40),
			Vector( 169, -37, -39 ),
		},
	}

}
list.Set( "simfphys_lights", "rdtrain", light_table)

local light_table = {
	L_HeadLampPos = Vector( 154, 40, -10 ),
	L_HeadLampAng = Angle(14,0,0),
	R_HeadLampPos = Vector( 154, -40, -10 ),
	R_HeadLampAng = Angle(14,0,0),
	
	L_RearLampPos = Vector(-184,15,-13),
	L_RearLampAng = Angle(10,180,0),
	R_RearLampPos = Vector(-184,-15,-13),
	R_RearLampAng = Angle(10,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 154, 40, -10 ),material = "sprites/light_ignorez",size = 53, color = Color( 255,230,230,180)},
		{pos = Vector( 154, -40, -10 ),material = "sprites/light_ignorez",size = 53, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 154, 40, -10 ),material = "sprites/light_ignorez",size = 60, color = Color( 255,235,220,220)},
		{pos = Vector( 154, -40, -10 ),material = "sprites/light_ignorez",size = 60, color = Color( 255,235,220,220)},
	},
	Rearlight_sprites = {
		{pos = Vector(-184,15,-13),material = "sprites/light_ignorez",size = 33,color = Color( 255, 0, 0,  120)},
		{pos = Vector(-184,-15,-13),material = "sprites/light_ignorez",size = 33,color = Color( 255, 0, 0,  120)},
	},
	Brakelight_sprites = {
		{pos = Vector(-184,15,-13),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-184,-15,-13),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-186,15,-21),material = "sprites/light_ignorez",size = 32,color = Color( 255, 255, 255, 200)},
		{pos = Vector(-186,-15,-21),material = "sprites/light_ignorez",size = 32,color = Color( 255, 255, 255, 200)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-186,15,-21),
			Vector( 153, 45, 3 ),
		},
		Right = {
			Vector(-186,-15,-21),
			Vector( 153, -45, 3 ),
		},
	}

}
list.Set( "simfphys_lights", "petro", light_table)

local light_table = {
	L_HeadLampPos = Vector( 55, 8, -5 ),
	L_HeadLampAng = Angle(14,0,0),
	R_HeadLampPos = Vector( 55, -8, -5 ),
	R_HeadLampAng = Angle(14,0,0),
	
	L_RearLampPos = Vector(-50,0,-1),
	L_RearLampAng = Angle(10,180,0),
	R_RearLampPos = Vector(-50,0,-1),
	R_RearLampAng = Angle(10,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 55, 8, -5 ),material = "sprites/light_ignorez",size = 53, color = Color( 255,230,230,180)},
		{pos = Vector( 55, -8, -5 ),material = "sprites/light_ignorez",size = 53, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 55, 8, -5 ),material = "sprites/light_ignorez",size = 60, color = Color( 255,235,220,220)},
		{pos = Vector( 55, -8, -5 ),material = "sprites/light_ignorez",size = 60, color = Color( 255,235,220,220)},
	},
	Rearlight_sprites = {
		{pos = Vector(-50,0,-1),material = "sprites/light_ignorez",size = 33,color = Color( 255, 0, 0,  120)},
	},
	Brakelight_sprites = {
		{pos = Vector(-50,0,-1),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-50,0,-1),material = "sprites/light_ignorez",size = 32,color = Color( 255, 255, 255, 200)},
	},
	
	DelayOn = 0,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-50,0,-1),
			Vector( 55, 8, -5 ),
		},
		Right = {
			Vector(-50,0,-1),
			Vector( 55, -8, -5 ),
		},
	}

}
list.Set( "simfphys_lights", "tractor", light_table)

local light_table = {
	L_HeadLampPos = Vector( 120, 34, -2 ),
	L_HeadLampAng = Angle(10,0,0),
	R_HeadLampPos = Vector( 120, -34, -2 ),
	R_HeadLampAng = Angle(10,0,0),
	
	L_RearLampPos = Vector(-124,41,7),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-124,-41,7),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 120, 34, -2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
		{pos = Vector( 120, -34, -2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 120, 34, -2 ),material = "sprites/light_ignorez",size = 48, color = Color( 255,235,220,170)},
		{pos = Vector( 120, -34, -2 ),material = "sprites/light_ignorez",size = 48, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-168,47,7),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-168,-47,7),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-168,47,12),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-168,-47,12),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-168,47,17),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-168,-47,17),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-166,34,-18),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-166,-34,-18),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-166,29,-18),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-166,-29,-18),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-166,29,-18),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-166,-29,-18),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-166,45,-23),
			Vector( 119, 35, -4 ),
		},
		Right = {
			Vector(-166,-45,-23),
			Vector( 119, -35, -4 ),
		},
	}

}
list.Set( "simfphys_lights", "yankee", light_table)