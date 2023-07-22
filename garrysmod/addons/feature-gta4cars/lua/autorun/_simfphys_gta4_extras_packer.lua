function REN.GTA4Packer(self, NMB)
	local tankgone = 0
	local skin = self:GetSkin()
	local prxyClr
		if (self.GetProxyColors) then
			prxyClr = self:GetProxyColors()
		end

	if NMB == 0 then return end

	if NMB == 1 then
		self.extramdl = ents.Create('prop_physics' )
		self.extramdl:SetModel('models/octoteam/vehicles/packer_extra1.mdl' )
	elseif NMB == 2 then
		self.extramdl = ents.Create('prop_physics' )
		self.extramdl:SetModel('models/octoteam/vehicles/packer_extra3.mdl' )
	end

	self.extramdl:SetSkin(skin )
	self.extramdl:SetPos(self:GetPos() )
	self.extramdl:SetAngles(self:GetAngles() )
	self.extramdl.DoNotDuplicate = true
	self.extramdl:Spawn()

	self.extraweld = constraint.Weld(self.extramdl, self, 0, 0, 0, 1, 1)

	if NMB == 1 then
		self.extramdl:CallOnRemove('TankGone',function(self) tankgone = 1 end )
	end

	self:CallOnRemove('RemoveBed',function(self)
		if tankgone == 1 then return end

		if self.destroyed then
			if NMB == 1 then
				self.extragib = ents.Create('gmod_sent_vehicle_fphysics_gib' )
				self.extragib:SetModel('models/octoteam/vehicles/packer_extra1.mdl' )
			elseif NMB == 2 then
				self.extragib = ents.Create('gmod_sent_vehicle_fphysics_gib' )
				self.extragib:SetModel('models/octoteam/vehicles/packer_extra3.mdl' )
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