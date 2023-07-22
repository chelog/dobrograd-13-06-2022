local light_table = {
	L_HeadLampPos = Vector( 90, 23, 0 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 90, -23, 0 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-82,30,5),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-82,-30,5),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 89, 18, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 89, -18, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 89, 22, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 89, -22, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 89, 25, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 89, -25, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 89, 23, 0 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 89, -23, 0 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-82,30,5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-82,-30,5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-82,23,4),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-82,-23,4),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-82,18,3),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-82,-18,3),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-82,23,4),
			Vector( 85, 33, 0 ),
		},
		Right = {
			Vector(-82,-23,4),
			Vector( 85, -33, 0 ),
		},
	}

}
list.Set( "simfphys_lights", "elegy", light_table)

local light_table = {
	L_HeadLampPos = Vector( 78, 23, 0 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 78, -23, 0 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-72,28,2),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-72,-28,2),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 78, 18, 1 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 78, -18, 1 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 78, 22, 1 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 78, -22, 1 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 78, 25, 1 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 78, -25, 1 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 78, 23, 0 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 78, -23, 0 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-72,28,2),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-72,-28,2),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-72,28,2),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-72,-28,2),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-72,25,2),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-72,-25,2),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-70,33,2),
			Vector( 75, 31, 1 ),
		},
		Right = {
			Vector(-70,-33,2),
			Vector( 75, -31, 1 ),
		},
	}

}
list.Set( "simfphys_lights", "flash", light_table)

local light_table = {
	L_HeadLampPos = Vector( 78, 23, 0 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 78, -23, 0 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-83,26,6),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-83,-26,6),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 89, 21, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 89, -21, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 89, 25, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 89, -25, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 89, 28, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 89, -28, 0 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 89, 25, 0 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 89, -25, 0 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-84,19,6),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-84,-19,6),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-83,26,6),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-83,-26,6),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-83,26,6),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-83,-26,6),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-82,31,7),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-82,-31,7),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-82,31,7),
			Vector( 85, 32, 0 ),
		},
		Right = {
			Vector(-82,-31,7),
			Vector( 85, -32, 0 ),
		},
	}

}
list.Set( "simfphys_lights", "jester", light_table)

local light_table = {
	L_HeadLampPos = Vector( 97, 18, -4 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 97, -18, -4 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-94,31,0),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-94,-31,0),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 97, 18, -4 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 97, -18, -4 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 97, 22, -4 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 97, -22, -4 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 97, 25, -4 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 97, -25, -4 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 97, 22, -4 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
		{pos = Vector( 97, -22, -4 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-94,31,0),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-94,-31,0),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-94,31,0),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-94,-31,0),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-94,31,0),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-94,-31,0),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-91,35,-2),
			Vector( 93, 33, -4 ),
		},
		Right = {
			Vector(-91,-35,-2),
			Vector( 93, -33, -4 ),
		},
	}

}
list.Set( "simfphys_lights", "stratum", light_table)

local light_table = {
	L_HeadLampPos = Vector( 92, 23, 2 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 92, -23, 2 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-86,25,7),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-86,-25,7),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 92, 23, 2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 92, -23, 2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 91, 26, 2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 91, -26, 2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 90, 29, 2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 90, -29, 2 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 93, 25, 2 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
		{pos = Vector( 93, -25, 2 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-86,25,7),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-86,-25,7),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-86,32,6),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-86,-32,6),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-86,24,4),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-86,-24,4),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-83,34,3),
			Vector( 85, 37, 2 ),
		},
		Right = {
			Vector(-83,-34,3),
			Vector( 85, -37, 2 ),
		},
	}

}
list.Set( "simfphys_lights", "sultan", light_table)

local light_table = {
	L_HeadLampPos = Vector( 83, 15, 2 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 83, -15, 2 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-89,27,10),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-89,-27,10),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 83, 15, 3 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 83, -15, 3 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 82, 18, 3 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 82, -18, 3 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 81, 21, 3 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 81, -21, 3 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 81, 24, 3 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 81, -24, 3 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 81, 27, 3 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 81, -27, 3 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 83, 23, 2 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
		{pos = Vector( 83, -23, 2 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
		{pos = Vector( 83, 17, 2 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
		{pos = Vector( 83, -17, 2 ),material = "sprites/light_ignorez",size = 45, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-89,27,10),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89,-27,10),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89,23,10),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89,-23,10),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89,19,10),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89,-19,10),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89,15,10),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89,-15,10),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-89,10,12),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-89,-10,12),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-89,8,12),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-89,-8,12),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-89,6,12),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-89,-6,12),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-89,4,12),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-89,-4,12),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-89,2,12),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-89,-2,12),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-89,0,12),material = "sprites/light_ignorez",size = 20,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-89,15,10),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-89,-15,10),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-87,33,10),
			Vector( 79, 33, 3 ),
		},
		Right = {
			Vector(-87,-33,10),
			Vector( 79, -33, 3 ),
		},
	}

}
list.Set( "simfphys_lights", "uranus", light_table)