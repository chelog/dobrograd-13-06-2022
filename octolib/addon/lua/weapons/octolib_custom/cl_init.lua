include 'shared.lua'

function SWEP:RemoveModel()
	if IsValid(self.csEnt) then self.csEnt:Remove() end
	octolib.manipulateBones(self:GetOwner(), nil, 0.4)
end

function SWEP:DrawWorldModel()

	self:SetHoldType(self.HoldType)

	local worldModel = self:GetNetVar('WorldModel')
	if worldModel and (self.lastMdl ~= worldModel or not IsValid(self.csEnt)) then
		self:RemoveModel()

		local ent = ClientsideModel(worldModel.model)
		local ply = self:GetOwner()
		ent:SetParent(ply, ply:LookupAttachment(worldModel.attachment or 'anim_attachment_rh'))
		ent:SetLocalPos(worldModel.pos or Vector())
		ent:SetLocalAngles(worldModel.ang or Angle())
		if worldModel.color then ent:SetColor(worldModel.color) end
		if worldModel.skin then ent:SetSkin(worldModel.skin) end
		if worldModel.material then ent:SetMaterial(worldModel.material) end
		if worldModel.scale then ent:SetModelScale(worldModel.scale) end
		if worldModel.bodyGroups then
			for k, v in pairs(worldModel.bodyGroups) do
				ent:SetBodygroup(k, v)
			end
		end

		self.csEnt = ent
		self.lastMdl = worldModel

		if worldModel.bones then
			octolib.manipulateBones(ply, worldModel.bones, 0.4)
		end
	end

end

function SWEP:Holster()

	self:RemoveModel()
	return true

end

SWEP.OwnerChanged = SWEP.RemoveModel
SWEP.OnRemove = SWEP.RemoveModel
