local light_table = {
	L_HeadLampPos = Vector( 75, 30, -0.5  ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 75, -30.5, -0.5),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-80,34.5,2),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-80,-34,2),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 75, 30, -0.5 ),material = "sprites/light_ignorez",size = 15, color = Color( 210,205,200,120)},
		{pos = Vector( 75, -30.5, -0.5 ),material = "sprites/light_ignorez",size = 15, color = Color( 210,205,200,120)},
		
		
	},
	Headlamp_sprites = {
		{pos = Vector( 73, 34.5, -0.5 ),material = "sprites/light_ignorez",size = 25, color = Color( 200,205,220,170)},
		{pos = Vector( 73, -36, -0.5 ),material = "sprites/light_ignorez",size = 25, color = Color( 200,205,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-87,34.5,2),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-87,-34,2),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-87,34.5,2),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-87,-34,2),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-87,34.5,2),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-87,-34,2),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-94,34,-10),
			Vector(87,29,-15),
			
		},
		Right = {
			Vector(-94,-32.5,-10),
			Vector(86.5,-30.5,-15),
			
		},
	}

}
list.Set( "simfphys_lights", "alpha", light_table)

local light_table = {
	L_HeadLampPos = Vector( 75, 28, 0  ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 75, -28, 0),
	R_HeadLampAng = Angle(00,0,0),
	
	L_RearLampPos = Vector(-88,26,0),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-88,-26,0),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 75, 28, 0 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},
		{pos = Vector( 75, -28, 0 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},
		
		
	},
	Headlamp_sprites = {
		{pos = Vector( 75, 28, 2 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,220)},
		{pos = Vector( 75, -28, 2 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,220)},
	},
	Rearlight_sprites = {
		{pos = Vector(-88,28,0),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-88,24,0),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},		
		{pos = Vector(-88,-28,0),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-88,-24,0),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-88,24,0),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  220)},
		{pos = Vector(-88,20,0),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  220)},	
		{pos = Vector(-88,-24,0),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  220)},
		{pos = Vector(-88,-20,0),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  220)},
	},
	Reverselight_sprites = {
		{pos = Vector(-88,19,-0.25),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-88,-19,-0.25),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-87,31,0),
			Vector(83,29,-10),
			
		},
		Right = {
			Vector(-87,-31,0),
			Vector(83,-29,-10),
			
		},
	}

}
list.Set( "simfphys_lights", "banshee", light_table)

local light_table = {
	L_HeadLampPos = Vector( 89, 30.5, 0  ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 89, -30.5, 0),
	R_HeadLampAng = Angle(00,0,0),
	
	L_RearLampPos = Vector(-88,26,0),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-88,-26,0),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 89, 30.5, -1.75 ),material = "sprites/light_ignorez",size = 8, color = Color( 210,205,200,255)},
		{pos = Vector( 90, 30.5, -1.75 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,180)},
		{pos = Vector( 89, -30.5, -1.75 ),material = "sprites/light_ignorez",size = 8, color = Color( 210,205,200,255)},
		{pos = Vector( 90, -30.5, -1.75 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 89, 23.5, -1.75 ),material = "sprites/light_ignorez",size = 10, color = Color( 210,210,210,255)},
		{pos = Vector( 90, 23.5, -1.75 ),material = "sprites/light_ignorez",size = 45, color = Color( 210,210,210,220)},
		{pos = Vector( 89, -23.5, -1.75 ),material = "sprites/light_ignorez",size = 10, color = Color( 210,210,210,255)},
		{pos = Vector( 90, -23.5, -1.75 ),material = "sprites/light_ignorez",size = 45, color = Color( 210,210,210,220)},
	},
	Rearlight_sprites = {
		{pos = Vector(-93,28,0),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-93,24,0),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-93,20,0),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},	
		{pos = Vector(-92,28,4),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-92,24,4),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-92,20,4),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},	
		{pos = Vector(-93,-28,0),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-93,-24,0),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-93,-20,0),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-92,-28,4),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-92,-24,4),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-92,-20,4),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-92,28,2),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-93,24,2),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-93,20,2),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-92,-26,2),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-93,-22,2),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-93,-20,2),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  255)},
	},
	Reverselight_sprites = {
		{pos = Vector(-95,17,4),material = "sprites/light_ignorez",size = 50,color = Color( 255, 255, 255, 255)},
		{pos = Vector(-95,17,0),material = "sprites/light_ignorez",size = 50,color = Color( 255, 255, 255, 255)},
		{pos = Vector(-95,-17,4),material = "sprites/light_ignorez",size = 50,color = Color( 255, 255, 255, 255)},
		{pos = Vector(-95,-17,0),material = "sprites/light_ignorez",size = 50,color = Color( 255, 255, 255, 255	)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-93,33,1),
			Vector(-92,33,3),
			Vector(90,23.5,-1.75),
			
		},
		Right = {
			Vector(-93,-33,1),
			Vector(-92,-33,3),
			Vector(90,-23.5,-1.75),
			
		},
	}

}
list.Set( "simfphys_lights", "buffalo", light_table)

local light_table = {
	L_HeadLampPos = Vector( 65, 26, 0  ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 65, -26, 0),
	R_HeadLampAng = Angle(00,0,0),
	
	L_RearLampPos = Vector(-78,28,0),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-78,-28,0),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 84, 21.5, -8 ),material = "sprites/light_ignorez",size = 5, color = Color( 210,205,200,190)},
		{pos = Vector( 84, 21.5, -8 ),material = "sprites/light_ignorez",size = 25, color = Color( 210,205,200,255)},
		{pos = Vector( 65, 31.5, 5 ),material = "sprites/light_ignorez",size = 5, color = Color( 210,205,200,190)},
		{pos = Vector( 65, 31.5, 5 ),material = "sprites/light_ignorez",size = 25, color = Color( 210,205,200,255)},
		{pos = Vector( 84, -21.5, -8 ),material = "sprites/light_ignorez",size = 5, color = Color( 210,205,200,190)},
		{pos = Vector( 84, -21.5, -8 ),material = "sprites/light_ignorez",size = 25, color = Color( 210,205,200,255)},
		{pos = Vector( 65, -31.5, 5 ),material = "sprites/light_ignorez",size = 5, color = Color( 210,205,200,190)},
		{pos = Vector( 65, -31.5, 5 ),material = "sprites/light_ignorez",size = 25, color = Color( 210,205,200,255)},
	},
	Headlamp_sprites = {
		{pos = Vector( 84, 21.5, -7 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
		{pos = Vector( 67, 26, 4 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
		{pos = Vector( 67, 26, 4 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
		{pos = Vector( 84, -21.5, -7 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
		{pos = Vector( 67, -26, 4 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},	
		{pos = Vector( 67, -26, 4 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},	
	},
	Rearlight_sprites = {
		{pos = Vector(-78,29,1),material = "sprites/light_ignorez",size = 15,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-78,28,0.5),material = "sprites/light_ignorez",size = 15,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-78,27,1),material = "sprites/light_ignorez",size = 15,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-78,-29,1),material = "sprites/light_ignorez",size = 15,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-78,-28,0.5),material = "sprites/light_ignorez",size = 15,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-78,-27,1),material = "sprites/light_ignorez",size = 15,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-78,29,5),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-78,27,5),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  255)},	
		{pos = Vector(-78,-29,5),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-78,-27,5),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  255)},
	},
	Reverselight_sprites = {
		{pos = Vector(-78,28,3.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-78,-28,3.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-78,30,3),
			Vector(67,26,7),
			Vector(83,25,-8),
			
		},
		Right = {
			Vector(-78,-30,3),
			Vector(67,-26,7),
			Vector(83,-25,-8),
			
		},
	}

}
list.Set( "simfphys_lights", "bullet", light_table)

local light_table = {
	L_HeadLampPos = Vector( 93, 22.5, 0  ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 93, -22.5, 0),
	R_HeadLampAng = Angle(00,0,0),
	
	L_RearLampPos = Vector(-88,26,0),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-88,-26,0),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 93, 24.5, -8 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},
		{pos = Vector( 93, 25, -8 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},
		{pos = Vector( 93, -24.5, -8),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},
		{pos = Vector( 93, -25, -8),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},
	},
	Headlamp_sprites = {
		{pos = Vector( 93, 21.5, -8	),material = "sprites/light_ignorez",size = 55, color = Color( 200,205,220,220)},
		{pos = Vector( 93, 22, -8	),material = "sprites/light_ignorez",size = 55, color = Color( 200,205,220,220)},
		{pos = Vector( 93, -21.5, -8),material = "sprites/light_ignorez",size = 55, color = Color( 200,205,220,220)},
		{pos = Vector( 93, -22, -8),material = "sprites/light_ignorez",size = 55, color = Color( 200,205,220,220)},
	},
	Rearlight_sprites = {
		{pos = Vector(-86,21.5,1.5),material = "sprites/light_ignorez",size = 15,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-86,15.5,1.5),material = "sprites/light_ignorez",size = 15,color = Color( 255, 0, 0,  150)},		
		{pos = Vector(-86,27.5,1.5),material = "sprites/light_ignorez",size = 15,color = Color( 255, 0, 0,  150)},		
		{pos = Vector(-86,-21.5,1.5),material = "sprites/light_ignorez",size = 15,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-86,-15.5,1.5),material = "sprites/light_ignorez",size = 15,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-86,-27.5,1.5),material = "sprites/light_ignorez",size = 15,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-86,21.5,1),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-86,15.5,1),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  255)},		
		{pos = Vector(-86,-21.5,1),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-86,-15.5,1),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  255)},
	},
	Reverselight_sprites = {
		{pos = Vector(-86,15.5,2.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-86,-15.5,2.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-85.5,27.5,2.5),
			Vector(-85.,27.5,3),
			Vector(90.5,31.5,-8),
			
		},
		Right = {
			Vector(-85.5,-27.5,2.5),
			Vector(-85.5,-27.5,3),
			Vector(90.5,-31.5,-8),
			
		},
	}

}
list.Set( "simfphys_lights", "cheetah", light_table)

local light_table = {
	L_HeadLampPos = Vector( 65.5, 28, 0  ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 65.5, -28, 0),
	R_HeadLampAng = Angle(00,0,0),
	
	L_RearLampPos = Vector(-85.5,26,0),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-85.5,-26,0),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 65.5, 30, 2 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},
		{pos = Vector( 65.5, -30, 2 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},		
	},
	Headlamp_sprites = {
		{pos = Vector( 65.5, 30, 0.5 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
		{pos = Vector( 65.5, -30, 0.5 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
	},
	Rearlight_sprites = {
		{pos = Vector(-86.5, 27,-5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-86.5, 24,-5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-87, 21,-5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-87, 18,-5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},		
		{pos = Vector(-86.5,-27,-5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-86.5,-24,-5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-87,-21,-5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-87,-18,-5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-85.5,28,-4),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  220)},
		{pos = Vector(-85.5,24,-4),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  220)},
		{pos = Vector(-85.5,20,-4),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  220)},	
		{pos = Vector(-85.5,-28,-4),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  220)},
		{pos = Vector(-85.5,-24,-4),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  220)},
		{pos = Vector(-85.5,-20,-4),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  220)},
	},
	Reverselight_sprites = {
		{pos = Vector(-85.5,14.5,-6),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-85.5,14.5,-4),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-85.5,-14.5,-6),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-85.5,-14.5,-4),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-85,32,-4),
			Vector(-84,32,-4),
			Vector(-85,32,-5),
			Vector(-84,32,-5),
			Vector(83,22,-15.5),
			Vector(83,21,-15.5),
			
		},
		Right = {
			Vector(-85,-32,-4),
			Vector(-84,-32,-4),
			Vector(-85,-32,-5),
			Vector(-84,-32,-5),
			Vector(83,-22,-15.5),
			Vector(83,-21,-15.5),			
		},
	}

}
list.Set( "simfphys_lights", "comet", light_table)

local light_table = {
	L_HeadLampPos = Vector( 71, 28, 0  ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 71, -28, 0),
	R_HeadLampAng = Angle(00,0,0),
	
	L_RearLampPos = Vector(-93,26,0),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-93,-26,0),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 71, 28, 2 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},
		{pos = Vector( 71, 19.5, 2 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},	
		{pos = Vector( 71, -28, 2 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},
		{pos = Vector( 71, -19.5, 2 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},		
	},
	Headlamp_sprites = {
		{pos = Vector( 71, 19.5, 2 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
		{pos = Vector( 71, 28, 2 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
				{pos = Vector( 80, 31, -10 ),material = "sprites/light_ignorez",size = 35, color = Color( 200,205,220,255)},
		{pos = Vector( 71, -19.5, 2 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
		{pos = Vector( 71, -28, 2 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
				{pos = Vector( 80, -31, -10 ),material = "sprites/light_ignorez",size = 35, color = Color( 200,205,220,255)},	
	},
	Rearlight_sprites = {
		{pos = Vector(-93,   32,4.5),material = "sprites/light_ignorez",size = 45,color = Color( 255, 0, 0,  140)},
		{pos = Vector(-93,   28,4.5),material = "sprites/light_ignorez",size = 45,color = Color( 255, 0, 0,  140)},
		{pos = Vector(-93,   24,4.5),material = "sprites/light_ignorez",size = 45,color = Color( 255, 0, 0,  140)},	
		{pos = Vector(-93,  -32,4.5),material = "sprites/light_ignorez",size = 45,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-93,  -28,4.5),material = "sprites/light_ignorez",size = 45,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-93,  -24,4.5),material = "sprites/light_ignorez",size = 45,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-93,  27,4.5),material = "sprites/light_ignorez",size = 80,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-93,  23,4.5),material = "sprites/light_ignorez",size = 80,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-93,  19,4.5),material = "sprites/light_ignorez",size = 80,color = Color( 255, 0, 0,  255)},	
		{pos = Vector(-93, -27,4.5),material = "sprites/light_ignorez",size = 80,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-93, -23,4.5),material = "sprites/light_ignorez",size = 80,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-93, -19,4.5),material = "sprites/light_ignorez",size = 80,color = Color( 255, 0, 0,  255)},
	},
	Reverselight_sprites = {
		{pos = Vector(-93, 18,5  ),material = "sprites/light_ignorez",size = 45,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-93, 18,3.5),material = "sprites/light_ignorez",size = 45,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-93,-18,5  ),material = "sprites/light_ignorez",size = 45,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-93,-18,3.5),material = "sprites/light_ignorez",size = 45,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-89,38.5,5),
			Vector(-89,38.5,4),
			Vector(-89,38.5,3),
			Vector(80, 	36,-10),			
			Vector(80, 36,-10),					
		},
		Right = {
			Vector(-89,-38.5,5),
			Vector(-89,-38.5,4),
			Vector(-89,-38.5,3),
			Vector(80,-36,-10),			
			Vector(80,-36,-10),			
		},
	}

}
list.Set( "simfphys_lights", "euros", light_table)

local light_table = {
	L_HeadLampPos = Vector( 69.5, 21.5, 0  ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 69.5, -21.5, 0),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-88,26,0),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-88,-26,0),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 69.5, 21.5, -3.5 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},
		{pos = Vector( 69.5, -21.5, -3.5 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},		
	},
	Headlamp_sprites = {
		{pos = Vector( 70.5, 21.5, -5.5 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
		{pos = Vector( 70.5, -21.5, -5.5 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
	},
	Rearlight_sprites = {
		{pos = Vector(-71.5, 17.5,-2.5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-71.5,-17.5,-2.5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-71.5,17.5,-2.5),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  220)},
		{pos = Vector(-71.5,-17.5,-2.5),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  220)},
	},
	Reverselight_sprites = {
		{pos = Vector(-68,7.5,-12),material = "sprites/light_ignorez",size = 35,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-68,-7.5,-12),material = "sprites/light_ignorez",size = 35,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-71.5,18.5,-2.5),
			Vector(70.5,23.5,-3.5),
			
		},
		Right = {
			Vector(-71.5,-18.5,-2.5),
			Vector(70.5,-23.5,-3.5),
		},
	}

}
list.Set( "simfphys_lights", "hotknife", light_table)

local light_table = {
	L_HeadLampPos = Vector( 97, 26, 0  ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 97, -26, 0),
	R_HeadLampAng = Angle(00,0,0),
	
	L_RearLampPos = Vector(-93,26,0),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-93,-26,0),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 97, 30, -6.5 ),material = "sprites/light_ignorez",size = 25, color = Color( 210,205,200,190)},
		{pos = Vector( 97, 28, -6.5 ),material = "sprites/light_ignorez",size = 25, color = Color( 210,205,200,190)},	
		{pos = Vector( 97, 26, -6.5 ),material = "sprites/light_ignorez",size = 25, color = Color( 210,205,200,190)},	
		{pos = Vector( 97, -30, -6.5 ),material = "sprites/light_ignorez",size = 25, color = Color( 210,205,200,190)},
		{pos = Vector( 97, -28, -6.5 ),material = "sprites/light_ignorez",size = 25, color = Color( 210,205,200,190)},		
		{pos = Vector( 97, -26, -6.5 ),material = "sprites/light_ignorez",size = 25, color = Color( 210,205,200,190)},		
	},
	Headlamp_sprites = {
		{pos = Vector( 97, 24,-6.5 ),material = "sprites/light_ignorez",size = 35, color = Color( 200,205,220,255)},
		{pos = Vector( 97, 22,-6.5 ),material = "sprites/light_ignorez",size = 35, color = Color( 200,205,220,255)},
		{pos = Vector( 95.5, 23,-17.5),material = "sprites/light_ignorez",size = 15, color = Color( 200,205,220,255)},	
		{pos = Vector( 95.5, 23,-17.5),material = "sprites/light_ignorez",size = 35, color = Color( 200,205,220,255)},	
		{pos = Vector( 97,-24,-6.5 ),material = "sprites/light_ignorez",size = 35, color = Color( 200,205,220,255)},
		{pos = Vector( 97,-22,-6.5 ),material = "sprites/light_ignorez",size = 35, color = Color( 200,205,220,255)},
		{pos = Vector( 95.5,-23,-17.5),material = "sprites/light_ignorez",size = 15, color = Color( 200,205,220,255)},	
		{pos = Vector( 95.5,-23,-17.5),material = "sprites/light_ignorez",size = 35, color = Color( 200,205,220,255)},	
	},
	Rearlight_sprites = {
		{pos = Vector(-88.0,  30,2.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  140)},
		{pos = Vector(-88.0,  26,2.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  140)},
		{pos = Vector(-88.0,  22,2.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  140)},	
		{pos = Vector(-88.0,  18,2.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  140)},	
		{pos = Vector(-87.0, -30,2.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-87.0, -26,2.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-87.0, -22,2.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-87.0, -18,2.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-86.0,  34,2.5),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-86.0,  32,2.5),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-86.0, -34,2.5),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-86.0, -32,2.5),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  255)},
	},
	Reverselight_sprites = {
		{pos = Vector(-86.5, 16,2.5),material = "sprites/light_ignorez",size = 45,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-87.5, 16,2.5),material = "sprites/light_ignorez",size = 45,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-87.5,-16,2.5),material = "sprites/light_ignorez",size = 45,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-87.5,-16,2.5),material = "sprites/light_ignorez",size = 45,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-86,30.5,9.0),
			Vector(-86,31.0,8.5),
			Vector(93, 35,-6.5),			
			Vector(92, 35.5,-6.5),					
			Vector(91, 36,-6.5),					
			Vector(90, 36.5,-6.5),					
		},
		Right = {
			Vector(-86,-30.5,9.0),
			Vector(-86,-31.0,8.5),
			Vector(93,-35,-6.5),			
			Vector(92,-35.5,-6.5),					
			Vector(91,-36,-6.5),					
			Vector(90,-36.5,-6.5),				
		},
	}

}
list.Set( "simfphys_lights", "infernus", light_table)

local light_table = {
	L_HeadLampPos = Vector( 85, 28, 0  ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 85, -28, 0),
	R_HeadLampAng = Angle(00,0,0),
	
	L_RearLampPos = Vector(-93,26,0),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-93,-26,0),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 93, 30, -4 ),material = "sprites/light_ignorez",size = 45, color = Color( 210,205,200,190)},
		{pos = Vector( 93, 22, -4 ),material = "sprites/light_ignorez",size = 25, color = Color( 210,205,200,190)},	
		{pos = Vector( 93, -30, -4 ),material = "sprites/light_ignorez",size = 45, color = Color( 210,205,200,190)},
		{pos = Vector( 93, -22, -4 ),material = "sprites/light_ignorez",size = 25, color = Color( 210,205,200,190)},		
	},
	Headlamp_sprites = {
		{pos = Vector( 93, 30, -4 ),material = "sprites/light_ignorez",size = 35, color = Color( 200,205,220,255)},
		{pos = Vector( 93, 22, -4),material = "sprites/light_ignorez",size = 55, color = Color( 200,205,220,255)},
		{pos = Vector( 93, -30, -4 ),material = "sprites/light_ignorez",size = 35, color = Color( 200,205,220,255)},
		{pos = Vector( 93, -22, -4 ),material = "sprites/light_ignorez",size = 55, color = Color( 200,205,220,255)},	
	},
	Rearlight_sprites = {
		{pos = Vector(-94.5,   30.5,-3.5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  140)},
		{pos = Vector(-94.5,   21.5,-3.5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  140)},
		{pos = Vector(-94.5,  -30.5,-3.5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-94.5,  -21.5,-3.5),material = "sprites/light_ignorez",size = 25,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-94,  21.5,-3.5),material = "sprites/light_ignorez",size = 80,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-94, -21.5,-3.5),material = "sprites/light_ignorez",size = 80,color = Color( 255, 0, 0,  255)},
	},
	Reverselight_sprites = {
		{pos = Vector(-94, 21.5,-3),material = "sprites/light_ignorez",size = 45,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-94, 21.5,-4),material = "sprites/light_ignorez",size = 45,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-94,-21.5,-3),material = "sprites/light_ignorez",size = 45,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-94,-21.5,-4),material = "sprites/light_ignorez",size = 45,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-94.5,30.5,-2.5),
			Vector(-94.5,30.5,-3),
			Vector(93,32,-4),			
			Vector(93,32,-4)					
		},
		Right = {
			Vector(-94.5,-30.5,-2.5),
			Vector(-94.5,-30.5,-3),
			Vector(93,-32,-4),			
			Vector(93,-32,-4)		
		},
	}

}
list.Set( "simfphys_lights", "phoenix", light_table)

local light_table = {
	L_HeadLampPos = Vector( 71, 28, 0  ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 71, -28, 0),
	R_HeadLampAng = Angle(00,0,0),
	
	L_RearLampPos = Vector(-93,26,0),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-93,-26,0),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 64, 28, 1 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,220)},
		{pos = Vector( 65, 21, 1 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,220)},
		{pos = Vector( 64, -28, 1 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,220)},
		{pos = Vector( 65, -21, 1 ),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,220)},
	},
	Headlamp_sprites = {
		{pos = Vector( 64, 28, 1 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
		{pos = Vector( 65, 21, 1 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
		{pos = Vector( 64, -28, 1 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
		{pos = Vector( 65, -21, 1 ),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
	},
	Rearlight_sprites = {
		{pos = Vector(-86,   22,0),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  140)},
		{pos = Vector(-86,   27,0),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  140)},
		{pos = Vector(-86,   -22,0),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  140)},
		{pos = Vector(-86,  -27,0),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-86,  18,0),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-86,  -18,0),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  255)},
	},
	Reverselight_sprites = {
		{pos = Vector(-85, 31,0),material = "sprites/light_ignorez",size = 35,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-85, -31,0),material = "sprites/light_ignorez",size = 35,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-85, 32,0),
			Vector( 81, 29, -11 ),
		},
		Right = {
			Vector(-85, -32,0),
			Vector( 81, -29, -11 ),
		},
	}

}
list.Set( "simfphys_lights", "supergt", light_table)

local light_table = {
	L_HeadLampPos = Vector( 64.74428, 23.72472,-2.56302),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 64.74428,-23.72472,-2.56302),
	R_HeadLampAng = Angle(00,0,0),
	
	L_RearLampPos = Vector(-78.75116, 29.196756,-0.422532),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-78.75116,-29.196756,-0.422532),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 74.74428, 30.242988,-2.56302),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},
		{pos = Vector( 74.74428,-30.242988,-2.56302),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},	
		{pos = Vector( 74.74428, 23.72472,-2.56302),material = "sprites/light_ignorez",size = 22, color = Color( 210,205,200,110)},
		{pos = Vector( 74.74428,-23.72472,-2.56302),material = "sprites/light_ignorez",size = 22, color = Color( 210,205,200,110)},	
	},
	Headlamp_sprites = {
		{pos = Vector( 74.74428, 23.72472,-2.56302),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
		{pos = Vector( 74.74428,-23.72472,-2.56302),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
	},
	Rearlight_sprites = {
		{pos = Vector(-88.75116, 29.196756,-0.422532),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  140)},
		{pos = Vector(-88.75116,-29.196756,-0.422532),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  140)},
		{pos = Vector(-88.75116, 25,-0.422532),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  140)},	
		{pos = Vector(-88.75116,-25,-0.422532),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-88.75116, 21,-0.422532),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-88.75116,-21,-0.422532),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-88.75116, 16,-0.422532),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  255)},	
		{pos = Vector(-88.75116,-16,-0.422532),material = "sprites/light_ignorez",size = 40,color = Color( 255, 0, 0,  255)},
	},
	Reverselight_sprites = {
		{pos = Vector(-88.75116, 16,-0.422532),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-88.75116,-16,-0.422532),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-88.75116, 33,-0.422532),
			Vector( 74.74428, 26.8,-2),
			Vector( 70.8912, 36.3715,-4.47503),
		},
		Right = {
			Vector(-88.75116,-33,-0.422532),
			Vector( 74.74428,-26.8,-2),
			Vector( 70.8912,-36.3715,-4.47503),
		},
	}

}
list.Set( "simfphys_lights", "turismo", light_table)

local light_table = {
	L_HeadLampPos = Vector( 70.99532, 26.73342, 0.85698),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 70.99532,-26.73342, 0.85698),
	R_HeadLampAng = Angle(00,0,0),
	
	L_RearLampPos = Vector(-78.4268, 25.406244,-3.921696),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-78.4268,-25.406244,-3.921696),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 80.99532, 26.73342, 0.85698),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},
		{pos = Vector( 80.99532,-26.73342, 0.85698),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},	
	},
	Headlamp_sprites = {
		{pos = Vector( 80.99532, 26.73342, 0.85698),material = "sprites/light_ignorez",size = 45, color = Color( 210,205,200,190)},
		{pos = Vector( 80.99532,-26.73342, 0.85698),material = "sprites/light_ignorez",size = 45, color = Color( 210,205,200,190)},
	},
	Rearlight_sprites = {
		{pos = Vector(-88.4268, 25.406244,-3.921696),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  140)},
		{pos = Vector(-88.4268,-25.406244,-3.921696),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  140)},
		{pos = Vector(-89, 22.406244,-3.921696),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  140)},	
		{pos = Vector(-89,-22.406244,-3.921696),material = "sprites/light_ignorez",size = 30,color = Color( 255, 0, 0,  140)},
	},
	Brakelight_sprites = {
		{pos = Vector(-89.41464, 18.897912,-3.921696),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-89.41464,-18.897912,-3.921696),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  255)},
		{pos = Vector(-89, 22.406244,-3.921696),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  255)},	
		{pos = Vector(-89,-22.406244,-3.921696),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  255)},
	},
	Reverselight_sprites = {
		{pos = Vector(-89.41464, 18.897912,-3.921696),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-89.41464,-18.897912,-3.921696),material = "sprites/light_ignorez",size = 25,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-87.90804, 26.81748,-3.921696),
			Vector( 40.0868, 34.2895,-0.685242),					
		},
		Right = {
			Vector(-87.90804,-26.81748,-3.921696),
			Vector( 40.0868,-34.2895,-0.685242),			
		},
	}

}
list.Set( "simfphys_lights", "windsor", light_table)

local light_table = {
	L_HeadLampPos = Vector( 76.91696, 25.551144, 5.716836),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 76.91696,-25.551144, 5.716836),
	R_HeadLampAng = Angle(00,0,0),
	
	L_RearLampPos = Vector(-89.22788, 33,3.793788),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-89.22788,-33,3.793788),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 86.91696, 25.551144, 5.716836),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},
		{pos = Vector( 86.91696,-25.551144, 5.716836),material = "sprites/light_ignorez",size = 35, color = Color( 210,205,200,190)},	
		{pos = Vector( 98.6798,  23.4417,-7.14418),material = "sprites/light_ignorez",size = 20, color = Color( 210,205,200,190)},
		{pos = Vector( 98.6798, -23.4417,-7.14418),material = "sprites/light_ignorez",size = 20, color = Color( 210,205,200,190)},		
	},
	Headlamp_sprites = {
		{pos = Vector( 86.91696, 25.551144, 5.716836),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
		{pos = Vector( 86.91696,-25.551144, 5.716836),material = "sprites/light_ignorez",size = 45, color = Color( 200,205,220,255)},
	},
	Rearlight_sprites = {
		{pos = Vector(-99.22788, 33,3.793788),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-99.22788,-33,3.793788),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-99.22788, 28,3.793788),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-99.22788,-28,3.793788),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-99.22788, 23,3.793788),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-99.22788,-23,3.793788),material = "sprites/light_ignorez",size = 50,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-99.22788, 23,3.793788),material = "sprites/light_ignorez",size = 55,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-99.22788,-23,3.793788),material = "sprites/light_ignorez",size = 55,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-99.22788, 18,3.793788),material = "sprites/light_ignorez",size = 55,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-99.22788,-18,3.793788),material = "sprites/light_ignorez",size = 55,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-99.22788, 13,3.793788),material = "sprites/light_ignorez",size = 55,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-99.22788,-13,3.793788),material = "sprites/light_ignorez",size = 55,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-99.22788,  8,3.793788),material = "sprites/light_ignorez",size = 55,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-99.22788, -8,3.793788),material = "sprites/light_ignorez",size = 55,color = Color( 255, 0, 0,  190)},
	},
	Reverselight_sprites = {
		{pos = Vector(-99.22788, 13,3.793788),material = "sprites/light_ignorez",size = 45,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-99.22788,-13,3.793788),material = "sprites/light_ignorez",size = 45,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	BodyGroups = {
		On = {1,1},
		Off = {1,0}
	},
	
	Turnsignal_sprites = {
		Left = {
			Vector(-93, 39,3.793788),
			Vector(97.0367, 29.8017,-7.02415),					
		},
		Right = {
			Vector(-93,-39,3.793788),
			Vector(97.0367,-29.8017,-7.02415),			
		},
	}

}
list.Set( "simfphys_lights", "zr350", light_table)