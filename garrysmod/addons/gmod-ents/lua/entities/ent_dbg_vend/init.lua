AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"

include "shared.lua"

function ENT:Initialize()

	self:SetModel('models/props/cs_office/vending_machine.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self.bottlesLeft = 5

end

function ENT:Use(ply)

	if IsValid(self.pendingWorker) then
		if self.pendingWorker ~= ply then ply:Notify(L.automatic_service) end

		local item, itemID
		if ply.inv and ply.inv.conts._hand then
			for i, v in ipairs(ply.inv.conts._hand:GetItems()) do
				if v:GetData('name') == L.soda_block then
					item, itemID = v, i
					break
				end
			end
		end

		if not item then
			ply:Notify('warning', L.where_soda)
			return
		end

		ply:ClearMarkers('work2')
		ply:DelayedAction('work', L.load_soda, {
			time = 20,
			check = function() return octolib.use.check(ply, self) and ply.inv and ply.inv.conts._hand and ply.inv.conts._hand:GetItem(itemID) == item end,
			succ = function()
				self.bottlesLeft = 15
				item:Remove()
				self.finish(ply)
			end,
		}, {
			time = 1.5,
			inst = true,
			action = function()
				ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
				self:EmitSound('physics/cardboard/cardboard_box_strain'..math.random(1,3)..'.wav', 60, 100, 0.75)
			end,
		})
	else
		if IsValid(ply) then ply:Notify('ooc', L.to_buy_soda) end
	end

end

local cost = 200
function ENT:StartTouch(ent)

	if not IsValid(ent) or ent:GetClass() ~= 'octoinv_item' or not ent:GetNetVar('Item') or ent.aquired then return end
	local ply = ent.droppedBy

	if self.bottlesLeft <= 0 then
		if IsValid(ply) then ply:Notify('warning', L.run_out_of_bottles) end
		return
	end

	if ent:GetNetVar('Item')[2] ~= cost then
		if IsValid(ply) then ply:Notify('warning', L.only_200) end
		return
	end

	ent.aquired = true
	ent:Remove()

	local pos, ang = LocalToWorld(Vector(0,-20,16), Angle(-90,0,0), self:GetPos(), self:GetAngles())
	local ent = ents.Create 'octoinv_item'
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent.Model = 'models/props/cs_office/water_bottle.mdl'

	ent:SetData('food', {
		name = L.soda,
		model = 'models/props/cs_office/water_bottle.mdl',
		icon = 'octoteam/icons/bottle.png',
		energy = 15,
		maxenergy = 35,
		drink = true,
	})

	self.bottlesLeft = self.bottlesLeft - 1

	ent:Spawn()
	ent:Activate()

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end

end

-- function ENT:Think()

--	 self:NextThink(CurTime() + 60)
--	 self.bottlesLeft = math.min(self.bottlesLeft + 1, 15)

--	 return true

-- end
