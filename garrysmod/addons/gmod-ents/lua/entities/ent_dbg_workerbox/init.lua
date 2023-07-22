AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

ENT.Model = 'models/props/cs_militia/crate_stackmill.mdl'
ENT.CollisionGroup = COLLISION_GROUP_NONE
ENT.Physics = true

function ENT:Use(ply, caller)

	if not ply:IsPlayer() then return end

	local sid = ply:SteamID()
	if self.finishTrash and self.finishTrash[sid] then
		local item = ply.inv:FindItem({ class = 'souvenir', name = 'Мусор' })
		if not item then return end
		ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
		timer.Simple(0.5, function()
			if item:GetParent():TakeItem(item) == 1 then
				self.finishTrash[sid](ply)
				self.finishTrash[sid] = nil
				ply:ClearMarkers('work2')
			end
		end)
		return
	end

	if not ply:CanUseInventory(self.inv) then return end

	local cont = self.inv:GetContainer(sid)
	if not cont then return end

	ply:ClearMarkers('work1')
	ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
	timer.Simple(0.5, function()
		if not IsValid(self) then return end
		ply:OpenInventory(self.inv, { sid })
	end)

end

function ENT:Think()

	for contID, cont in pairs(self.inv.conts) do
		if cont.volume == cont:FreeSpace() then
			cont:Remove()
		end
	end

	self:NextThink(CurTime() + 1)
	return true

end
