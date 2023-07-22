AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

ENT.Model = 'models/props_street/mail_dropbox.mdl'
ENT.CollisionGroup = COLLISION_GROUP_NONE
ENT.Physics = true

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self.inv:AddContainer('send', {
		name = 'Отправка',
		icon = octolib.icons.color('mailbox'),
		volume = 1000,
	})

	self.deliveryContainers = {}
	self.jobContainers = {}
end

function ENT:Use(ply, caller)
	if not ply:IsPlayer() then return end
	if not ply:CanUseInventory(self.inv) then return end

	ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
	timer.Simple(0.5, function()
		if not IsValid(self) then return end
		ply:OpenInventory(self.inv, { 'send', ply:SteamID() })
	end)
end

function ENT:Deliver(contID, items)
	local cont = self.inv:GetContainer(contID)
	if not cont then
		cont = self.inv:AddContainer(contID, {
			name = 'Получение',
			icon = octolib.icons.color('mailbox'),
			volume = 250,
		})

		self.deliveryContainers[contID] = cont
	end

	for _, item in pairs(items) do
		cont:AddItem(unpack(item))
	end
end

function ENT:Think()
	for contID, cont in pairs(self.deliveryContainers) do
		if not cont.items[1] then
			cont:Remove()
			self.deliveryContainers[contID] = nil
		end
	end

	local sendCont = self.inv:GetContainer('send')
	if sendCont.items[1] then
		if table.IsEmpty(sendCont.users) then
			for i = #sendCont.items, 1, -1 do
				sendCont.items[i]:Drop(nil, nil, self:LocalToWorld(Vector(15, 0, 35)), AngleRand(), (self:GetForward() + VectorRand() * 0.2) * 100)
			end
		else
			for ply in pairs(sendCont.users) do
				if not IsValid(ply) or not ply.pendingShipments then continue end
				for shipmentID, check in pairs(ply.pendingShipments) do
					if check(sendCont, ply) then
						octoinv.removeShipment(ply, shipmentID)
					end
				end
			end
		end
	end

	self:NextThink(CurTime() + 2)
	return true
end
