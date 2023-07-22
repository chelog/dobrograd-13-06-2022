function REN.GTA4Flatbed(self, NMB)
	local skin = self:GetSkin()
	local prxyClr
		if (self.GetProxyColors) then
			prxyClr = self:GetProxyColors()
		end

	if NMB == 0 then return end

	if NMB == 1 then
		self.extramdl = ents.Create('prop_physics' )
		self.extramdl:SetModel('models/octoteam/vehicles/flatbed_extra1.mdl' )
		if (self.GetProxyColors) then self.extramdl:SetProxyColors(prxyClr) end
	elseif NMB == 2 then
		self.extramdl = ents.Create('prop_physics' )
		self.extramdl:SetModel('models/octoteam/vehicles/flatbed_extra2.mdl' )
		if (self.GetProxyColors) then self.extramdl:SetProxyColors(prxyClr) end
	end

	self.extramdl:SetSkin(skin )
	self.extramdl:SetPos(self:GetPos() )
	self.extramdl:SetAngles(self:GetAngles() )
	self.extramdl.DoNotDuplicate = true
	self.extramdl:Spawn()

	self.extraweld = constraint.Weld(self.extramdl, self, 0, 0, 0, 1, 1)

	self:CallOnRemove('RemoveBed',function(self)
	if self.destroyed then
		if NMB == 1 then
			self.extragib = ents.Create('gmod_sent_vehicle_fphysics_gib' )
			self.extragib:SetModel('models/octoteam/vehicles/flatbed_extra1.mdl' )
		elseif NMB == 2 then
			self.extragib = ents.Create('gmod_sent_vehicle_fphysics_gib' )
			self.extragib:SetModel('models/octoteam/vehicles/flatbed_extra2.mdl' )
		end

		self.extragib:SetSkin(skin )
		self.extragib.DoNotDuplicate = true
		self.extragib:SetPos(self:GetPos() )
		self.extragib:SetAngles(self:GetAngles() )

		self.Gib.extragib = self.extragib

		self.extragib:Spawn()

		self.Gib:CallOnRemove('RemoveBedGib',function(self)
			self.extragib:Remove()
		end)
	end
	end)
end