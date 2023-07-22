matproxy.Add( {
	name = "ColorSlot1",
	--ran when a material with the proxy is spawned
	init = function( self, mat, values )
		self.Name = values.name
		self.Color = values.resultvar
		self.FColor = values.fcolor and util.StringToType(values.fcolor, "Vector")
	end,
	--ran every frame (not sure if it is the fastest way :<)
	bind = function( self, mat, ent )
		if (!IsValid( ent )) then return end
		if (!ent.ColorSlot1) then --only run once
			ent.ColorSlot1Name = self.Name
			ent.ColorSlot1 = self.FColor or Vector(1,1,1)
		end
		mat:SetVector(self.Color,ent.ColorSlot1)
	end
} )

matproxy.Add( {
	name = "ColorSlot2",
	init = function( self, mat, values )
		self.Name = values.name
		self.Color = values.resultvar
		self.FColor = values.fcolor and util.StringToType(values.fcolor, "Vector")
	end,
	bind = function( self, mat, ent )
		if (!IsValid( ent )) then return end
		if (!ent.ColorSlot2) then
			ent.ColorSlot2Name = self.Name
			ent.ColorSlot2 = self.FColor or Vector(1,1,1)
		end
		mat:SetVector(self.Color,ent.ColorSlot2)
	end
} )

matproxy.Add( {
	name = "ColorSlot3",
	init = function( self, mat, values )
		self.Name = values.name
		self.Color = values.resultvar
		self.FColor = values.fcolor and util.StringToType(values.fcolor, "Vector")
	end,
	bind = function( self, mat, ent )
		if (!IsValid( ent )) then return end
		if (!ent.ColorSlot3) then
			ent.ColorSlot3Name = self.Name
			ent.ColorSlot3 = self.FColor or Vector(1,1,1)
		end
		mat:SetVector(self.Color,ent.ColorSlot3)
	end
} )

matproxy.Add( {
	name = "ColorSlot4",
	init = function( self, mat, values )
		self.Name = values.name
		self.Color = values.resultvar
		self.FColor = values.fcolor and util.StringToType(values.fcolor, "Vector")
	end,
	bind = function( self, mat, ent )
		if (!IsValid( ent )) then return end
		if (!ent.ColorSlot4) then
			ent.ColorSlot4Name = self.Name
			ent.ColorSlot4 = self.FColor or Vector(1,1,1)
		end
		mat:SetVector(self.Color,ent.ColorSlot4)
	end
} )

matproxy.Add( {
	name = "ColorSlot5",
	init = function( self, mat, values )
		self.Name = values.name
		self.Color = values.resultvar
		self.FColor = values.fcolor and util.StringToType(values.fcolor, "Vector")
	end,
	bind = function( self, mat, ent )
		if (!IsValid( ent )) then return end
		if (!ent.ColorSlot5) then
			ent.ColorSlot5Name = self.Name
			ent.ColorSlot5 = self.FColor or Vector(1,1,1)
		end
		mat:SetVector(self.Color,ent.ColorSlot5)
	end
} )

matproxy.Add( {
	name = "ColorSlot6",
	init = function( self, mat, values )
		self.Name = values.name
		self.Color = values.resultvar
		self.FColor = values.fcolor and util.StringToType(values.fcolor, "Vector")
	end,
	bind = function( self, mat, ent )
		if (!IsValid( ent )) then return end
		if (!ent.ColorSlot6) then
			ent.ColorSlot6Name = self.Name
			ent.ColorSlot6 = self.FColor or Vector(1,1,1)
		end
		mat:SetVector(self.Color,ent.ColorSlot6)
	end
} )

matproxy.Add( {
	name = "ColorSlot7",
	init = function( self, mat, values )
		self.Name = values.name
		self.Color = values.resultvar
		self.FColor = values.fcolor and util.StringToType(values.fcolor, "Vector")
	end,
	bind = function( self, mat, ent )
		if (!IsValid( ent )) then return end
		if (!ent.ColorSlot7) then
			ent.ColorSlot7Name = self.Name
			ent.ColorSlot7 = self.FColor or Vector(1,1,1)
		end
		mat:SetVector(self.Color,ent.ColorSlot7)
	end
} )
