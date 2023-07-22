AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

local storageVolume = 225
local storageVolumePlus = 350

ENT.Model = 'models/props/cs_militia/footlocker01_closed.mdl'
ENT.ModelOpen = 'models/props/cs_militia/footlocker01_open.mdl'
ENT.CollisionGroup = COLLISION_GROUP_NONE
ENT.Physics = true

function ENT:Initialize()

	-- self:SetModel(self.Model)
	self:SetLocked(true)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(self.CollisionGroup)

	self:LoadInv()

	if self.Physics then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetMass(math.min(phys:GetMass(), 1000))
		end

		self.baseMass = phys:GetMass()
		self.invMassMultiplier = 5
	end

	self.lockNum = 6

	self:SetUseType(SIMPLE_USE)
	self:Activate()
	self.spawned = true

	self:SetNetVar('dbgLook', {
		name = '',
		desc = L.can_open,
		time = 1,
	})

end

function ENT:LoadInv()

	if not self.steamID then
		return self:Remove()
	end

	-- prevent duplicating (just in case)
	for i, ent in ipairs(ents.FindByClass('octoinv_storage')) do
		if ent ~= self and ent.steamID == self.steamID then
			return self:Remove()
		end
	end

	local ply = player.GetBySteamID(self.steamID)
	if not IsValid(ply) or IsValid(ply.storage) then
		return self:Remove()
	end

	self.ply = ply
	ply.storage = self
	local volume = ply:GetDBVar('storageVol') or (ply:GetNetVar('os_storage') and storageVolumePlus) or storageVolume
	self:SetNetVar('owner', ply)

	octolib.db:PrepareQuery([[
		SELECT storage FROM inventory
			WHERE steamID = ?
	]], { self.steamID }, function(q, st, res)
		res = istable(res) and res[1]
		if res and res.storage then
			local data
			if not pcall(function()
				data = pon.decode(res.storage)
			end) then
				ply:Notify('warning', L.error_storage)
			end

			if data and data.storage then
				data.storage.name = L.storage_hint .. ply:Name()
				data.storage.volume = volume
				data.storage.icon = octolib.icons.color('case_travel')
				self:ImportInventory(data)
				local cont = self.inv:GetContainer('storage')
				cont:Hook('canMoveIn', 'noZips', function(cont, ply, item)
					if item and item.class == 'zip' then
						return false, 'Это запрещено перемещать в хранилище'
					end
				end)
				octoinv.msg('Loaded storage for ' .. self.steamID)
				return
			end
		end

		self:ImportInventory({
			storage = {
				name = L.storage_hint .. ply:Name(),
				volume = volume,
				icon = octolib.icons.color('case_travel'),
				items = {},
			},
		})

		octoinv.msg('New storage for ' .. self.steamID)
		self:Save()
	end)

end

function ENT:Save(callback)

	if not self.inv then
		timer.Simple(1, function()
			if not IsValid(self) or not self.Save then return end
			self:Save(callback)
		end)
		return
	end

	local inv = self:ExportInventory()
	inv.storage.name = nil
	inv.storage.volume = nil
	inv.storage.icon = nil

	local steamID = self.steamID
	octolib.db:PrepareQuery([[
		UPDATE inventory
			SET storage = ?
			WHERE steamID = ?
	]], { pon.encode(inv), steamID }, function(q, st, res)
		-- octoinv.msg((st and 'Saved storage for ' or 'Failed to save storage for ') .. steamID)
		if not st then
			octoinv.msg(res)
		end
		if callback then callback() end
	end)

end

function ENT:Use(ply, caller)

	if not ply:IsPlayer() then return end
	if not ply:CanUseInventory(self.inv) then return end

	ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
	timer.Simple(0.5, function()
		if not IsValid(self) then return end
		if self.locked then
			self:EmitSound('doors/latchlocked2.wav', 60)
			if IsValid(ply) then ply:Notify(L.item_closed) end
		else
			local owner = player.GetBySteamID(self.steamID)
			if ply:Team() == TEAM_ADMIN or IsValid(owner) and (owner == ply or (owner.Buddies and owner.Buddies[ply] and table.HasValue(owner.Buddies[ply], true))) then
				ply:OpenInventory(self.inv)
			else
				ply:Notify(L.you_not_friend)
			end
		end
	end)

end

function ENT:SetLocked(val)

	self.locked = val
	self:SetModel(not val and self.ModelOpen or self.Model)
	self:EmitSound('doors/door_latch' .. (val and 1 or 3) .. '.wav', 55)

end

function ENT:OnRemove()

	if self.spawned then
		self:Save()

		local ply = player.GetBySteamID(self.steamID or '')
		if IsValid(ply) then ply:SetDBVar('nextStorage', nil) end
	end

end

function octoinv.getStorageData(ply)
	return util.Promise(function(res, rej)

		if IsValid(ply.storage) then
			res(ply.storage.inv.conts.storage:Export())
		else
			octolib.db:PrepareQuery('select storage from inventory where steamID = ?', { ply:SteamID() }, function(q, st, rows)
				if not rows[1] or not rows[1].storage then return res({}) end
				res(pon.decode(rows[1].storage).storage)
			end)
		end

	end)
end

function octoinv.takeItemFromStorage(ply, classOrID, amountOrData)
	return util.Promise(function(res, rej)

		octoinv.getStorageData(ply):Then(function(storage)
			if isnumber(classOrID) then
				-- it's non-stackable item with data to validate
				local item = storage.items[classOrID]
				if not item or (amountOrData and table.Count(octolib.table.diff(item, amountOrData)) > 0) then
					return rej('cannot find matching item in storage')
				end

				if IsValid(ply.storage) then
					ply.storage.inv.conts.storage.items[classOrID]:Remove()
					res()
				else
					table.remove(storage.items, classOrID)
					octolib.db:PrepareQuery('update inventory set storage = ? where steamID = ?', { pon.encode({ storage = storage }), ply:SteamID() })
					res()
				end
			else
				-- it's stackable item with amount to validate
				local item, id
				for _id, _item in ipairs(storage.items) do
					if _item.class == classOrID then
						item = _item
						id = _id
						break
					end
				end

				local amount = amountOrData or 1
				if not item or item.amount < amount then
					return rej('cannot found enough items of this class')
				end

				if IsValid(ply.storage) then
					local taken = ply.storage.inv.conts.storage:TakeItem(classOrID, amount)
					if taken < amount then return rej('cannot found enough items of this class') end -- just in case
					res()
				else
					item.amount = item.amount - amount
					if item.amount <= 0 then table.remove(storage.items, id) end
					octolib.db:PrepareQuery('update inventory set storage = ? where steamID = ?', { pon.encode({ storage = storage }), ply:SteamID() })
					res()
				end
			end
		end)

	end)
end

hook.Add('PlayerInitialSpawn', 'octoinv.storage', function(ply)

	-- for i, ent in ipairs(ents.FindByClass('octoinv_storage')) do
	--	 if ent.steamID == ply:SteamID() then
	--		 ent:LoadInv()
	--	 end
	-- end

end)

hook.Add('PlayerDisconnected', 'octoinv.storage', function(ply)

	local has = false
	for i, ent in ipairs(ents.FindByClass('octoinv_storage')) do
		if ent.steamID == ply:SteamID() then
			ply:SetDBVar('nextStorage', os.time() + 630)
			ent:Save()
			has = true
		end
	end

	if not has and ply:GetDBVar('nextStorage', 0) < os.time() then
		ply:SetDBVar('nextStorage', nil)
	end

end)

hook.Add('octoinv.canLock', 'octoinv.storage', function(ply, ent)
	if ent:GetNetVar('owner') == ply then
		return true
	end
end)

hook.Add('octoinv.canUnlock', 'octoinv.storage', function(ply, ent)
	if ent:GetNetVar('owner') == ply then
		return true
	end
end)

concommand.Add('dbg_storage', function(ply)

	if ply.restoringBackup then
		ply:Notify('warning', 'Подожди, загружаем твои данные...')
		return
	end

	if hook.Run('octoinv.overrideStorages', ply) == false then
		ply:Notify('warning', 'Хранилища отключены на время ивента')
		return
	end

	if IsValid(ply.storage) or ply:GetDBVar('nextStorage', 0) > os.time() then
		ply:Notify('warning', L.you_already_have_storage)
		return
	end

	if not ply:Alive() or ply:IsGhost() then
		ply:Notify('warning', L.dead_cant_do_this)
		return
	end

	if ply:IsHandcuffed() then
		ply:Notify('warning', L.error_cuffs)
		return
	end

	if ply:isArrested() then
		ply:Notify('warning', L.you_arrested)
		return
	end

	local ent = ents.Create 'octoinv_storage'
	ent.dt = ent.dt or {}
	ent.dt.owning_ent = ply

	ent.SID = ply.SID
	ent.steamID = ply:SteamID()
	ent:Spawn()

	ply:BringEntity(ent)
	ent:LinkPlayer(ply)

	hook.Run('octoinv.storageSpawned', ply, ent)

end)
