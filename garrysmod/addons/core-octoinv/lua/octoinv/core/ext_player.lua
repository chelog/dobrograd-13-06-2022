local ply = FindMetaTable 'Player'

function ply:CanUseInventory(inv)

	if not IsValid(self) or not inv then return false end

	local pos = self:GetPos()
	local can = IsValid(self) and self:Alive() and not self:GetNetVar('Ghost')
	and IsValid(inv.owner) and inv.owner:NearestPoint(pos):DistToSqr(pos) < 7056

	return can

end

function ply:HasAccessToContainer(owner, contID)

	if not self:Alive() or self:GetNetVar('Ghost') then return false end

	local inv = owner:GetInventory()
	if not inv then return false end

	local cont = inv:GetContainer(contID)
	if not cont or (inv.owner ~= self and not cont.users[self]) then return false end

	return true, cont

end

function ply:OpenInventory(inv, conts)

	if not self:Alive() or self:GetNetVar('Ghost') then return false end
	if not inv then return end

	inv:AddUser(self, conts)

end

function ply:CloseInventory(inv, conts)

	if not inv then return end

	inv:RemoveUser(self, conts)

end

function ply:SyncOctoinv()

	local itemData = {}
	for itemID, item in pairs(octoinv.items) do
		itemData[itemID] = {
			name = item.name,
			icon = item.icon,
			desc = item.desc,
			status = item.status,
			mass = item.mass,
			model = item.model,
			volume = item.volume,
			class = item.class,
			nostack = item.nostack,
			leftField = item.leftField,
			leftMax = item.leftMax,
			leftMaxField = item.leftMaxField,
			canuse = item.use ~= nil,
		}
	end

	local shopCatData = {}
	for catID, cat in pairs(octoinv.shopCats) do
		shopCatData[catID] = {
			name = cat.name,
			icon = cat.icon,
		}
	end

	local craftData = {}
	for craftID, craft in pairs(octoinv.blueprints) do
		craftData[craftID] = {
			name = craft.name,
			desc = craft.desc,
			conts = craft.conts,
			jobs = craft.jobs,
			time = craft.time,
			tools = craft.tools,
			ings = craft.ings,
			finish = craft.finish,
			icon = craft.icon,
		}
	end

	local prodData = {}
	for prodID, prod in pairs(octoinv.prod) do
		prodData[prodID] = {
			name = prod.name,
			icon = prod.icon,
			fuel = prod.fuel,
			prod = prod.prod,
		}
	end

	local marketData = {}
	for itemID, item in pairs(octoinv.marketItems) do
		marketData[itemID] = {
			name = item.name,
			icon = item.icon,
			parent = item.parent,
			nostack = item.nostack,
		}
	end

	netstream.Heavy(self, 'octoinv.sendRegistered', {
		items = itemData,
		shopCats = shopCatData,
		shopItems = octoinv.shopItems,
		crafts = craftData,
		prods = prodData,
		market = marketData,
	})

end

function ply:SaveInventory(noMsg)

	if hook.Run('octoinv.overrideInventories') == false then return end

	local veh = carDealer.getCurVeh(self)
	if IsValid(veh) then carDealer.saveVeh(veh) end
	if IsValid(self.storage) then self.storage:Save() end

	local inv = self:ExportInventory()
	if not istable(inv) then return end

	local steamID = self:SteamID()
	octolib.db:PrepareQuery([[
		UPDATE inventory
			SET inv = ?
			WHERE steamID = ?
	]], { pon.encode(inv), steamID }, function(q, st, res)
		if not noMsg then
			octoinv.msg((st and 'Saved inventory for ' or 'Failed to save inventory for ') .. steamID)
			if not st then
				octoinv.msg(res)
			end
		end
	end)

end

-- NOTE: switching weapons in in dbg-weapons module
function ply:SetHandHold(val)

	self:SetNetVar('HandHold', val)
	self:MoveModifier('hand', val and {
		norun = true,
		nojump = true,
	} or nil)

	local wep = self:GetActiveWeapon()
	if IsValid(wep) then
		wep:SetHoldType(val and 'duel' or 'normal')
	end

end

function ply:BringEntity(ent, rotate)

	local dir = self:GetAimVector()
	dir.z = 0
	dir:Normalize()

	local ang = self:EyeAngles()
	ang.p = 0
	ang.r = 0
	ang.y = ang.y + 180 - (rotate or 0)

	local pos = self:GetShootPos() + dir * 25
	ent:SetPos(pos)
	ent:SetAngles(ang)
	pos = ent:NearestPoint(pos + dir * 512)

	ent:SetPos(pos)

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end

end

function ply:PickupItem(ent)

	if not IsValid(ent) then return end

	local entClass = ent:GetClass()
	local itemClass = octoinv.itemClasses[entClass]
	if itemClass then
		local inv = self:GetInventory()
		local cont = inv and inv:GetContainer('_hand')
		if cont then
			local pickup, data = octoinv.items[itemClass].pickup, ent.pickupItemData
			if pickup then
				local dataOverride = pickup(self, ent)
				if dataOverride == false then return end

				table.Merge(data, dataOverride or {})
			end

			local item, amount = octoinv.createItem(itemClass, cont, data)
			if item then
				self:DoAnimation(ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND)
				ent:Remove()
				hook.Run('octoinv.pickup', self, ent, item, amount)
			end
		else
			self:Notify('warning', L.onlyhandsitem)
		end
	end

end

function ply:LoadInventory()

	if hook.Run('octoinv.overrideInventories') == false then
		self.loadedInv = true
		return
	end

	local steamID = self:SteamID()
	octolib.db:PrepareQuery([[
		SELECT inv FROM inventory
			WHERE steamID = ?
	]], { steamID }, function(q, st, res)
		res = istable(res) and res[1]
		if res and res.inv then
			-- temp
			if not pcall(function()
				self:ImportInventory(pon.decode(res.inv))
				if not self.inv.conts.top.icon then
					self.inv.conts.top.icon = octolib.icons.color('clothes_jacket')
					self.inv.conts.bottom.icon = octolib.icons.color('clothes_jeans')
				end
			end) then
				self:Notify('warning', L.error_inventory)
				self:ImportInventory(octoinv.defaultInventory)
			end

			octoinv.msg('Loaded inventory for ' .. steamID)
		else
			self:ImportInventory(octoinv.defaultInventory)

			octoinv.msg('New inventory for ' .. steamID)
			octolib.db:PrepareQuery([[
				INSERT INTO inventory(steamID)
				VALUES (?)
			]], { steamID }, function(q, st, res)
				self:SaveInventory()
			end)
		end

		self.loadedInv = true
	end)

end
