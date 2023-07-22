local light_table = {
	L_HeadLampPos = Vector( 68.4, 25.2, 1 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 68.4, -25.2, 1 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-68.1,27,2.5),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-68.1,-27,2.5),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 78.4, 25.2, 1 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 78.4, -25.2, 1 ),material = "sprites/light_ignorez",size = 38, color = Color( 255,230,230,100)},
		{pos = Vector( 83.8, 24.8, -5.4 ),material = "sprites/light_ignorez",size = 23, color = Color( 255,230,230,100)},
		{pos = Vector( 83.8, -24.8, -5.4 ),material = "sprites/light_ignorez",size = 23, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 78.4, 25.2, 1 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 78.4, -25.2, 1 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-78.1,27,2.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-78.1,-27,2.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-78.1,23,2.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-78.1,-23,2.5),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-78.1,19,2.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-78.1,-19,2.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-78.1,15,2.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-78.1,-15,2.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-78.1,11,2.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-78.1,-11,2.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-78.1,7,2.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-78.1,-7,2.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-78.1,4,2.5),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-78.1,-4,2.5),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-76,34,2.5),
			Vector( 79.5, 33.1, 1.4 ),
		},
		Right = {
			Vector(-76,-34,2.5),
			Vector( 79.5, -33.1, 1.4 ),
		},
	}

}
list.Set( "simfphys_lights", "blistac", light_table)

local light_table = {
	L_HeadLampPos = Vector( 84.6, 21, 1 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 84.6, -21, 1 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-75.3,29,0.3),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-75.3,-29,0.3),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 94.6, 21, 1 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
		{pos = Vector( 94.6, -21, 1 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
		{pos = Vector( 94.6, 26, 1 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
		{pos = Vector( 94.6, -26, 1 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 94.6, 24, 1 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 94.6, -24, 1 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-85.3,29,1),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-85.3,-29,1),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-85.3,24,1),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-85.3,-24,1),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-85.3,24,1),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-85.3,-24,1),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-85.3,20,1),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-85.3,-20,1),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-85.3,20,1),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-85.3,-20,1),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-84,34,1),
			Vector( 90, 36, 0.3 ),
		},
		Right = {
			Vector(-84,-34,1),
			Vector( 90, -36, 0.3 ),
		},
	}

}
list.Set( "simfphys_lights", "bravura", light_table)

local light_table = {
	L_HeadLampPos = Vector( 86.1, 29.8, -1.4 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 86.1, -29.8, -1.4 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-91.5,36.7,-0.3),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-91.5,-36.7,-0.3),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 96.1, 29.8, -1.4 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
		{pos = Vector( 96.1, -29.8, -1.4 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 96.1, 29.8, -1.4 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 96.1, -29.8, -1.4 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-101.5,36.7,-0.3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-101.5,-36.7,-0.3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-101.5,36.7,-7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-101.5,-36.7,-7.5),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-101.5,36.7,-5),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-101.5,-36.7,-5),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-101.5,36.7,-5),
			Vector( 96.1, 32.4, -4.3 ),
		},
		Right = {
			Vector(-101.5,-36.7,-5),
			Vector( 96.1, -32.4, -4.3 ),
		},
	}

}
list.Set( "simfphys_lights", "buccanee", light_table)

local light_table = {
	L_HeadLampPos = Vector( 82.8, 25.2, 0.7 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 82.8, -25.2, 0.7 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-76,25.2,5),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-76,-25.2,5),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 92.8, 25.2, 0.7 ),material = "sprites/light_ignorez",size = 47, color = Color( 255,230,230,100)},
		{pos = Vector( 92.8, -25.2, 0.7 ),material = "sprites/light_ignorez",size = 47, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 92.8, 25.2, 0.7 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 92.8, -25.2, 0.7 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-85,32,4),material = "sprites/light_ignorez",size = 38,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-85,-32,4),material = "sprites/light_ignorez",size = 38,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-86,25.2,3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-86,-25.2,3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-86,21,3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-86,-21,3),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-86,16,3),material = "sprites/light_ignorez",size = 33,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-86,-16,3),material = "sprites/light_ignorez",size = 33,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-86,11,3),material = "sprites/light_ignorez",size = 33,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-86,-11,3),material = "sprites/light_ignorez",size = 33,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-83.8,31.6,0.6),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-83.8,-31.6,0.6),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-85,32,4),
			Vector( 87.8, 32.7, 0.6 ),
		},
		Right = {
			Vector(-85,-32,4),
			Vector( 87.8, -32.7, 0.6 ),
		},
	}

}
list.Set( "simfphys_lights", "cadrona", light_table)

local light_table = {
	L_HeadLampPos = Vector( 84.3, 28.8, -1.8 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 84.3, -28.8, -1.8 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-97.2,21.2,-2.6),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-97.2,-21.2,-2.6),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 94.3, 28.8, -1.8 ),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
		{pos = Vector( 94.3, -28.8, -1.8 ),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 94.3, 22.6, -1.8 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 94.3, -22.6, -1.8 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-107.2,27.7,-2.6),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-107.2,-27.7,-2.6),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-107.2,21.2,-2.6),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-107.2,-21.2,-2.6),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-107.2,21.2,-2.6),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-107.2,-21.2,-2.6),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-107.2,21.2,-2.6),
			Vector( 95, 34.9, -1.4 ),
		},
		Right = {
			Vector(-107.2,-21.2,-2.6),
			Vector( 95, -34.9, -1.4 ),
		},
	}

}
list.Set( "simfphys_lights", "clover", light_table)

local light_table = {
	L_HeadLampPos = Vector( 76.64, 28.41, 6.57 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 76.64, -28.41, 6.57 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-72.23,28.88,13.86),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-72.23,-28.88,13.86),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 86.64, 28.41, 6.57 ),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
		{pos = Vector( 86.64, -28.41, 6.57 ),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 86.64, 19.82, 6.57 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 86.64, -19.82, 6.57 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-82.23,28.88,13.86),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
		{pos = Vector(-82.23,-28.88,13.86),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  190)},
	},
	Brakelight_sprites = {
		{pos = Vector(-82.23,27,12),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  210)},
		{pos = Vector(-82.23,-27,12),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  210)},
	},
	Reverselight_sprites = {
		{pos = Vector(-82.23,27,12),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-82.23,-27,12),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-81.64,33.54,15.96),
			Vector(-81.64,33.87,13.78),
			Vector(-81.64,33.87,11.70),
			Vector( 86.64, 28.41, 6.57 ),
		},
		Right = {
			Vector(-81.64,-33.54,15.96),
			Vector(-81.64,-33.87,13.78),
			Vector(-81.64,-33.87,11.70),
			Vector( 86.64, -28.41, 6.57 ),
		},
	}

}
list.Set( "simfphys_lights", "club", light_table)

local light_table = {
	L_HeadLampPos = Vector( 80.27936, 24.567768, -4.836492 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 80.27936, -24.567768, -4.836492 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-93.33152,28.699272,-5.175216),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-93.33152,-28.699272,-5.175216),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 90.27936, 24.567768, -4.836492 ),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,180)},
		{pos = Vector( 90.27936, -24.567768, -4.836492 ),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,180)},
	},
	Headlamp_sprites = {
		{pos = Vector( 90.27936, 24.567768, -4.836492 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 90.27936, -24.567768, -4.836492 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-103.33152,28.699272,-5.175216),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-103.33152,-28.699272,-5.175216),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-103.33152,24.699272,-5.175216),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-103.33152,-24.699272,-5.175216),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-109.25244,34.989012,-9.121932),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-109.25244,-34.989012,-9.121932),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-103.33152,20,-5.175216),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-103.33152,-20,-5.175216),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-103.33152,16,-5.175216),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-103.33152,-16,-5.175216),material = "sprites/light_ignorez",size = 32,color = Color( 255, 0, 0,  150)},
	},
	Reverselight_sprites = {
		{pos = Vector(-103.33152,15,-5.175216),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-103.33152,-15,-5.175216),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-109.25244,34.989012,-13.325112),
			Vector( 93.63564, 27, -15.04476 ),
			Vector( 93.63564, 24, -15.04476 ),
			Vector( 85.78584, 39.57336, -6.5),
		},
		Right = {
			Vector(-109.25244,-34.989012,-13.325112),
			Vector( 93.63564, -27, -15.04476 ),
			Vector( 93.63564, -24, -15.04476 ),			
			Vector( 85.78584, -39.57336, -6.5),			
		},
	}

}
list.Set( "simfphys_lights", "esperant", light_table)

local light_table = {
	L_HeadLampPos = Vector( 77.471, 28.250244, 1.111356 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 77.471, -28.250244, 1.111356 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-83.04308,29.155104,0.666),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-83.04308,-29.155104,0.666),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 87.471, 28.250244, 1.111356 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
		{pos = Vector( 87.471, -28.250244, 1.111356 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 87.471, 28.250244, 1.111356 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 87.471, -28.250244, 1.111356 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-93.04308,29.155104,0.666),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-93.04308,-29.155104,0.666),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-93.04308,24.040224,0.666),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-93.04308,-24.040224,0.666),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-93.04308,24.040224,0.666),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-93.04308,-24.040224,0.666),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-92.05128,34.302132,0.666),
			Vector( 85.86756, 35.76312, 1.019808 ),
		},
		Right = {
			Vector(-92.05128,-34.302132,0.666),
			Vector( 85.86756, -35.76312, 1.019808 ),
		},
	}

}
list.Set( "simfphys_lights", "feltzer", light_table)

local light_table = {
	L_HeadLampPos = Vector( 77.94512, 22.157532, -4.598064 ),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 77.94512, -22.157532, -4.598064 ),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-74.97044,16.719012,-1.06974),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-74.97044,16.719012,-1.06974),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 87.94512, 22.157532, -4.598064 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
		{pos = Vector( 87.94512, -22.157532, -4.598064 ),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 87.94512, 22.157532, -4.598064 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 87.94512, -22.157532, -4.598064 ),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-84.97044,27.048708,-1.06974),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-84.97044,-27.048708,-1.06974),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-84.97044,22,-1.06974),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-84.97044,-22,-1.06974),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-84.97044,16.719012,-1.06974),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-84.97044,-16.719012,-1.06974),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-84.97044,11,-1.06974),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-84.97044,-11,-1.06974),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-84.97044,10,-1.2),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-84.97044,-10,-1.2),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-83.59236,32.987664,-1.2),
			Vector( 83.57832, 34.311996, -4.598064 ),
		},
		Right = {
			Vector(-83.59236,-32.987664,-1.2),
			Vector( 83.57832, -34.311996, -4.598064 ),
		},
	}

}
list.Set( "simfphys_lights", "fortune", light_table)

local light_table = {
	L_HeadLampPos = Vector(86.67836, 32.260608, 0),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector(86.67836, -32.260608, 0),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-90.20852,36.00504,-7.33392),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-90.20852,-36.00504,-7.33392),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector(96.67836, 32.260608, 0),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
		{pos = Vector(96.67836, -32.260608, 0),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector(96.67836, 32.260608, 0),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector(96.67836, -32.260608, 0),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-100.20852,36.00504,-7.33392),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-100.20852,-36.00504,-7.33392),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-100.20852,36.00504,-1.78164),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-100.20852,-36.00504,-1.78164),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-100.20852,34,-7.33392),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-100.20852,-34,-7.33392),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-98.50356,37.71684,-7.33392),
			Vector(96.67836, 33, 0),
		},
		Right = {
			Vector(-98.50356,-37.71684,-7.33392),
			Vector(96.67836, -33, 0),
		},
	}

}
list.Set( "simfphys_lights", "hermes", light_table)

local light_table = {
	L_HeadLampPos = Vector(52.76744, 17.626284, 1.723536),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector(52.76744, -17.626284, 1.723536),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-66.09284,29.937996,-9.19008),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-66.09284,29.937996,-9.19008),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector(62.76744, 17.626284, 1.723536),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
		{pos = Vector(62.76744, -17.626284, 1.723536),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector(62.76744, 17.626284, 1.723536),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector(62.76744, -17.626284, 1.723536),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-76.09284,29.937996,-9.19008),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-76.09284,-29.937996,-9.19008),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-76.09284,29.937996,-9.19008),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-76.09284,-29.937996,-9.19008),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-76.09284,29.937996,-9.19008),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-76.09284,-29.937996,-9.19008),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-76.09284,29.937996,-9.19008),
			Vector(62.76744, 19, 1.723536),
		},
		Right = {
			Vector(-76.09284,-29.937996,-9.19008),
			Vector(62.76744, -19, 1.723536),
		},
	}

}
list.Set( "simfphys_lights", "hustler", light_table)

local light_table = {
	L_HeadLampPos = Vector(92.26772, 24.361056, -1.812204),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector(92.26772, -24.361056, -1.812204),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-90,24,-3.878496),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-90,-24,-3.878496),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector(102.26772, 24.361056, -1.812204),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
		{pos = Vector(102.26772, -24.361056, -1.812204),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector(102.26772, 24.361056, -1.812204),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector(102.26772, -24.361056, -1.812204),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-100.98612,30.204144,-3.878496),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-100.98612,-30.204144,-3.878496),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-100.98612,24,-3.878496),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-100.98612,-24,-3.878496),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-100.98612,18,-3.878496),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-100.98612,-18,-3.878496),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-100.98612,12,-3.878496),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-100.98612,-12,-3.878496),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-100.98612,12,-3.878496),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-100.98612,-12,-3.878496),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-98,36.57852,-3.878496),
			Vector(99, 33.800904, -1.812204),
		},
		Right = {
			Vector(-98,-36.57852,-3.878496),
			Vector(99, -33.800904, -1.812204),
		},
	}

}
list.Set( "simfphys_lights", "majestic", light_table)

local light_table = {
	L_HeadLampPos = Vector(79.13592, 21.622212, 2.367828),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector(79.13592, -21.622212, 2.367828),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-71.46332,26.653104,3.749976),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-71.46332,-26.653104,3.749976),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector(79.13592, 21.622212, 2.367828),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
		{pos = Vector(79.13592, -21.622212, 2.367828),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector(79.13592, 21.622212, 2.367828),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector(79.13592, -21.622212, 2.367828),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-81.46332,27,3.749976),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-81.46332,-27,3.749976),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-81.46332,22,3.749976),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-81.46332,-22,3.749976),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-81.46332,18,3.749976),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-81.46332,-18,3.749976),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-81.46332,13,3.749976),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
		{pos = Vector(-81.46332,-13,3.749976),material = "sprites/light_ignorez",size = 27,color = Color( 255, 0, 0,  180)},
	},
	Reverselight_sprites = {
		{pos = Vector(-81.46332,13,3.749976),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-81.46332,-13,3.749976),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-78,31.944564,3.749976),
			Vector(76.09392, 30.558996, 2.367828),
		},
		Right = {
			Vector(-78,-31.944564,3.749976),
			Vector(76.09392, -30.558996, 2.367828),
		},
	}

}
list.Set( "simfphys_lights", "manana", light_table)

local light_table = {
	L_HeadLampPos = Vector(73.61684, 20.204532, 0),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector(73.61684, -20.204532, 0),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-71.46332,26.653104,3.749976),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-71.46332,-26.653104,3.749976),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector(83.61684, 20.204532, 0),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
		{pos = Vector(83.61684, -20.204532, 0),material = "sprites/light_ignorez",size = 40, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector(83.61684, 20.204532, 0),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector(83.61684, -20.204532, 0),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-89.7102,32.5,-0.64224),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,-32.5,-0.64224),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,27,4.117752),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,-27,4.117752),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,22,4.117752),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,-22,4.117752),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,17,4.117752),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,-17,4.117752),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-89.7102,27,-0.64224),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,-27,-0.64224),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,22,-0.64224),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,-22,-0.64224),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,17,-0.64224),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,-17,-0.64224),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,12,-0.64224),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,-12,-0.64224),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,7,-0.64224),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,-7,-0.64224),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,2,-0.64224),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-89.7102,-2,-0.64224),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Reverselight_sprites = {
		{pos = Vector(-89.7102,9,-0.64224),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-89.7102,-9,-0.64224),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-89.60112,32.562072,4.117752),
			Vector(80.62884, 30.828312, 0),
		},
		Right = {
			Vector(-89.60112,-32.562072,4.117752),
			Vector(80.62884, -30.828312, 0),
		},
	}

}
list.Set( "simfphys_lights", "previon", light_table)

local light_table = {
	L_HeadLampPos = Vector( 80.30132, 31.027716, -2.968632),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 80.30132, -31.027716, -2.968632),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-87.93008,30.84318,-10.708416),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-87.93008,-30.84318,-10.708416),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 90.30132, 31.027716, -2.968632),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
		{pos = Vector( 90.30132, -31.027716, -2.968632),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 90.30132, 23.944752, -2.968632),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 90.30132, -23.944752, -2.968632),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-97.93008,30.84318,-10.708416),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-97.93008,-30.84318,-10.708416),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-97.93008,30.84318,-7.285536),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-97.93008,-30.84318,-7.285536),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-97.93008,25.39656,-10.708416),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-97.93008,-25.39656,-10.708416),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-97.93008,25.39656,-7.285536),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-97.93008,-25.39656,-7.285536),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Reverselight_sprites = {
		{pos = Vector(-97.93008,25.39656,-7.285536),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-97.93008,-25.39656,-7.285536),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-97.93008,25.39656,-7.285536),
			Vector( 88.54092, 31.773024, -11.627964 ),
		},
		Right = {
			Vector(-97.93008,-25.39656,-7.285536),
			Vector( 88.54092, -31.773024, -11.627964 ),
		},
	}

}
list.Set( "simfphys_lights", "sabre", light_table)

local light_table = {
	L_HeadLampPos = Vector( 74.29472, 30.011472, -5.10588),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector( 74.29472, 30.011472, -5.10588),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-87.60356,30.0465,-4.005324),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-87.60356,-30.0465,-4.005324),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector( 84.29472, 30.011472, -5.10588),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
		{pos = Vector( 84.29472, -30.011472, -5.10588),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector( 84.29472, 30.011472, -5.10588),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector( 84.29472, -30.011472, -5.10588),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-97.60356,30.0465,-4.005324),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-97.60356,-30.0465,-4.005324),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-97.60356,28,-4.005324),material = "sprites/light_ignorez",size = 42,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-97.60356,-28,-4.005324),material = "sprites/light_ignorez",size = 42,color = Color( 255, 0, 0,  150)},
	},
	Reverselight_sprites = {
		{pos = Vector(-97.60356,28,-4.005324),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-97.60356,-28,-4.005324),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-97.60356,28,-4.005324),
			Vector(84.9582, 29.163924, -17.018604),
		},
		Right = {
			Vector(-97.60356,-28,-4.005324),
			Vector(84.9582, -29.163924, -17.018604),
		},
	}

}
list.Set( "simfphys_lights", "stallion", light_table)

local light_table = {
	L_HeadLampPos = Vector(80.5364, 32.606964, 0.439776),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector(80.5364, -32.606964, 0.439776),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-92.48148,32.653224,2.132856),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-92.48148,-32.653224,2.132856),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector(90.5364, 32.606964, 0.439776),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
		{pos = Vector(90.5364, -32.606964, 0.439776),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector(90.5364, 26.464212, 0.439776),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector(90.5364, -26.464212, 0.439776),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-92.48148,32.653224,2.132856),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-92.48148,-32.653224,2.132856),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-92.48148,24.9264,2.132856),material = "sprites/light_ignorez",size = 42,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-92.48148,-24.9264,2.132856),material = "sprites/light_ignorez",size = 42,color = Color( 255, 0, 0,  150)},
	},
	Reverselight_sprites = {
		{pos = Vector(-92.48148,24.9264,2.132856),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-92.48148,-24.9264,2.132856),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-92.48148,24.9264,2.132856),
			Vector(90.5364, 34, 0.439776),
		},
		Right = {
			Vector(-92.48148,-24.9264,2.132856),
			Vector(90.5364, -34, 0.439776),
		},
	}

}
list.Set( "simfphys_lights", "tampa", light_table)

local light_table = {
	L_HeadLampPos = Vector(79.2224, 23.643612, -2.901636),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector(79.2224, -23.643612, -2.901636),
	R_HeadLampAng = Angle(0,0,0),
	
	L_RearLampPos = Vector(-91,31.1778,-4.078548),
	L_RearLampAng = Angle(0,180,0),
	R_RearLampPos = Vector(-91,-31.1778,-4.078548),
	R_RearLampAng = Angle(0,180,0),
	
	Headlight_sprites = {
		{pos = Vector(89.2224, 23.643612, -2.901636),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
		{pos = Vector(89.2224, -23.643612, -2.901636),material = "sprites/light_ignorez",size = 37, color = Color( 255,230,230,100)},
	},
	Headlamp_sprites = {
		{pos = Vector(89.2224, 16.543944, -2.901636),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
		{pos = Vector(89.2224, -16.543944, -2.901636),material = "sprites/light_ignorez",size = 50, color = Color( 255,235,220,170)},
	},
	Rearlight_sprites = {
		{pos = Vector(-101,31.1778,-4.078548),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-101,-31.1778,-4.078548),material = "sprites/light_ignorez",size = 35,color = Color( 255, 0, 0,  150)},
	},
	Brakelight_sprites = {
		{pos = Vector(-99.48492,31.1778,0),material = "sprites/light_ignorez",size = 42,color = Color( 255, 0, 0,  150)},
		{pos = Vector(-99.48492,-31.1778,0),material = "sprites/light_ignorez",size = 42,color = Color( 255, 0, 0,  150)},
	},
	Reverselight_sprites = {
		{pos = Vector(-99.48492,31.1778,0),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
		{pos = Vector(-99.48492,-31.1778,0),material = "sprites/light_ignorez",size = 17,color = Color( 255, 255, 255, 250)},
	},
	
	DelayOn = 0.1,
	DelayOff = 0.1,
	
	Turnsignal_sprites = {
		Left = {
			Vector(-99.48492,31.1778,0),
			Vector(91.2978, 30.77712, -2.901636),
		},
		Right = {
			Vector(-99.48492,-31.1778,0),
			Vector(91.2978, -30.77712, -2.901636),
		},
	}

}
list.Set( "simfphys_lights", "virgo", light_table)