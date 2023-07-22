util.AddNetworkString 'octoshop.rBalance'
util.AddNetworkString 'octoshop.rInventory'
util.AddNetworkString 'octoshop.rShop'
util.AddNetworkString 'octoshop.useCoupon'

local meta = FindMetaTable 'Player'

function meta:osCooldown(delay, ignoreCheck)

	local canDo = ignoreCheck or not self.osNextAction or CurTime() > self.osNextAction
	if not canDo then
		octoshop.notify(self, 'warning', L.too_fast)
	else
		self.osNextAction = CurTime() + delay
	end

	return canDo

end

function meta:osSyncPlayerData()

	octolib.db:PrepareQuery([[
		SELECT id, balance FROM ]] .. CFG.db.shop .. [[.octoshop_users
			WHERE steamID = ?
	]], {
		self:SteamID()
	}, function(q, st, data)
		if not IsValid(self) then return end

		data = istable(data) and data[1]
		if data then
			-- load data
			self.osID = data.id
			self.osBalance = data.balance
			self:osSyncItems()
		else
			-- new player
			octoshop.msg('New player: ' .. tostring(self))
			octolib.db:PrepareQuery([[
				INSERT INTO ]] .. CFG.db.shop .. [[.octoshop_users (steamID, steamID64, balance, totalTopup, totalSpent, totalPurchases)
				VALUES (?, ?, 0, 0, 0, 0)
			]], {
				self:SteamID(),
				self:SteamID64(),
			}, function(q, st, data)
				if not IsValid(self) then return end

				if st then
					self:osSyncPlayerData()
				else
					octoshop.msg('ERROR: Could not initialize player: ' .. tostring(self))
					-- ply:Kick('Мы не смогли загрузить твои данные из магазина. Похоже на хакерские проделки, дружище')
				end
			end)
		end
	end)

end
hook.Add('PlayerFinishedLoading', 'octoshop', meta.osSyncPlayerData)

function meta:osGetMoney()

	self.osBalance = self.osBalance or 0
	return self.osBalance

end

function meta:osHasMoney(val)

	return self:osGetMoney() >= val

end

function meta:osAddMoney(val)

	if not self.osID then return false end
	if not self:osHasMoney(-val) then return false end

	self.osBalance = self.osBalance + val
	octolib.db:PrepareQuery([[
		UPDATE ]] .. CFG.db.shop .. [[.octoshop_users
			SET balance = balance + ?
			WHERE id = ?
	]], { val, self.osID }, function(q, st, data)
		if not IsValid(self) then return end
		if st then
			self:osSyncBalance()
		else
			octoshop.msg('Failed to update balance for ' .. tostring(self))
		end
	end)

	return true

end

function meta:osSyncBalance()

	if not self.osID then return false end

	octolib.db:PrepareQuery([[
		SELECT id, balance FROM ]] .. CFG.db.shop .. [[.octoshop_users
		WHERE id = ?
	]], { self.osID }, function(q, st, data)
		if not IsValid(self) then return end
		data = istable(data) and data[1]
		if data then
			if self.osBalance and self.osBalance < data.balance then
				octoshop.notify(self, 'ooc', L.octoshop_update_balance .. octoshop.formatMoney(data.balance - self.osBalance))
			end

			self.osBalance = data.balance
			self:osNetBalance()
			octoshop.debugmsg('Updated balance for ' .. tostring(self) .. ': ' .. octoshop.formatMoney(self.osBalance))
		else
			octoshop.msg('Failed to update balance for ' .. tostring(self))
		end
	end)

end

function meta:osNetBalance()

	net.Start('octoshop.rBalance')
		net.WriteUInt(self.osBalance or 0, 32)
	net.Send(self)

end

function meta:osNetInv()

	local toSend = {}
	for itemID, item in pairs(self:osGetItems()) do
		table.insert(toSend, {
			id = itemID,
			class = item.class,
			name = item.name,
			canUse = item:CanUse(),
			canEquip = item:CanEquip(),
			canUnequip = item:CanUnequip(),
			canTrade = item:CanTrade(),
			equipped = item:IsEquipped(),
			expire = item:GetExpire(),
			active = item:GetData('active'),
			data = item.data,
		})
	end

	net.Start('octoshop.rInventory')
		net.WriteTable(toSend)
	net.Send(self)

end

function meta:osNetShop()

	local toSend = {}
	for class, item in pairs(octoshop.items) do
		local canBuy = item.CanBuy
		table.insert(toSend, {
			class = class,
			name = item.name,
			cat = item.cat,
			desc = item.desc,
			price = item.price,
			order = item.order,
			icon = item.icon,
			hidden = item.hidden,
			attributes = item.attributes,
			canBuy = isfunction(canBuy) and canBuy(self) or canBuy,
		})
	end

	net.Start('octoshop.rShop')
		net.WriteTable(toSend)
	net.Send(self)

end
net.Receive('octoshop.rShop', function(len, ply)

	local cd = ply:osCooldown(3)
	if not cd then return end

	ply:osNetShop()

end)

net.Receive('octoshop.rInventory', function(len, ply)

	local cd = ply:osCooldown(3)
	if not cd then return end

	ply:osSyncBalance()
	ply:osNetInv()

end)

local couponSymbols = {
	'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r',
	's','t','u','v','w','x','y','z','1','2','3','4','5','6','7','8','9','0',
}
local rewardTypes = {
	balance = function(ply, data)
		local amount = tonumber(data)
		if not amount then
			octoshop.notify(ply, 'warning', L.wrong_money)
			return
		end

		ply:osAddMoney(amount)
		octoshop.notify(ply, 'ooc', L.coupon_content .. octoshop.formatMoney(amount))
		return true
	end
}

function octoshop.createCoupon(rewardType, rewardData, ply)

	if not rewardTypes[rewardType] then
		if IsValid(ply) then
			octoshop.notify(ply, 'warning', L.type_bonus_wrong)
		end
		octoshop.msg('Error creating coupon ' .. code .. ': No such reward type')
	end

	local code = ''
	for i = 1, octoshop.couponLength or 64 do
		code = code .. couponSymbols[math.random(#couponSymbols)]
	end

	local data = rewardType .. ':' .. rewardData
	octolib.db:PrepareQuery([[
		INSERT INTO ]] .. CFG.db.shop .. [[.coupons_]] .. octoshop.server_id .. [[(code, reward)
		VALUES(?, ?)
	]], { code, data }, function(q, st, data)
		if st then
			if IsValid(ply) then
				octoshop.notify(ply, L.create_coupon_hint .. code)
			end
			octoshop.msg('Created coupon: ' .. code)
		else
		end
	end)

end

function octoshop.removeCoupon(code)

	octolib.db:PrepareQuery([[
		DELETE FROM ]] .. CFG.db.shop .. [[.coupons_]] .. octoshop.server_id .. [[
		WHERE code = ?
	]], { code })

end

function octoshop.useCoupon(ply, code)

	octolib.db:PrepareQuery([[
		SELECT code, reward FROM ]] .. CFG.db.shop .. [[.coupons_]] .. octoshop.server_id .. [[
		WHERE code = ? AND timeUsed IS NULL
	]], { code }, function(q, st, data)
		if not IsValid(ply) then return end
		data = istable(data) and data[1]
		if data then
			local scp = data.reward:find(':')
			if not scp then
				octoshop.notify(ply, 'warning', L.reward_failed)
				return
			end

			local rewardType = data.reward:sub(1, scp - 1)
			local rewardData = data.reward:sub(scp + 1)
			if isfunction(rewardTypes[rewardType]) then
				if rewardTypes[rewardType](ply, rewardData) then
					octoshop.notify(ply, L.use_coupon_hint)
					octolib.db:PrepareQuery([[
						UPDATE ]] .. CFG.db.shop .. [[.coupons_]] .. octoshop.server_id .. [[
						SET userID = ?, timeUsed = ?
						WHERE code = ?
					]], { ply.osID, os.time(), code }, function(q, st, data)
						if st then
							octoshop.msg(tostring(ply) .. ' used coupon ' .. code)
						else
							octoshop.msg('Error updating coupon ' .. code .. ': ' .. data)
						end
					end)
					ply.nextCoupon = CurTime() + (octoshop.couponUseDelay or 30)
				else
					octoshop.notify(ply, 'warning', L.use_coupon_fail)
				end
			else
				octoshop.notify(ply, 'warning', L.coupon_not_exist)
				octoshop.msg('Error using coupon ' .. code .. ': Reward type is not registered!')
				octoshop.removeCoupon(code)
				return
			end
		else
			octoshop.notify(ply, 'warning', L.coupon_not_exist)
		end
	end)

end

net.Receive('octoshop.useCoupon', function(len, ply)

	if (ply.nextCoupon or 0) > CurTime() then
		octoshop.notify(ply, 'warning', L.octoshop_wait .. math.ceil(ply.nextCoupon - CurTime()) .. 'с...')
		return
	end

	local code = net.ReadString()
	ply.nextCoupon = CurTime() + 2

	octoshop.useCoupon(ply, code)

end)

concommand.Add('octoshop_coupon_create', function(ply, cmd, args, argStr)

	if not octoshop.checkOwner(ply) then
		octoshop.notify(ply, 'warning', L.only_owner)
		return
	end

	octoshop.createCoupon(args[1], args[2], ply)

end)
