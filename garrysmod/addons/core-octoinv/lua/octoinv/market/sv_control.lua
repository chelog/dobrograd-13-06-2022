octoinv.marketSubs = octoinv.marketSubs or {}

local function recursiveSet(itemID, ply, val)
	local iData = octoinv.marketItems[itemID]
	if not iData then return end

	if val then
		octoinv.marketSubs[itemID] = octoinv.marketSubs[itemID] or {}
		table.insert(octoinv.marketSubs[itemID], ply)
	elseif octoinv.marketSubs[itemID] then
		table.RemoveByValue(octoinv.marketSubs[itemID], ply)
		if #octoinv.marketSubs[itemID] < 1 then octoinv.marketSubs[itemID] = nil end
	end

	if iData.children then
		for _, itemID in ipairs(iData.children) do
			recursiveSet(itemID, ply, val)
		end
	end
end

local function subscribe(ply, itemID)
	local old = ply.marketSub
	if old then
		if old == itemID then return end
		recursiveSet(old, ply, false)
	end

	recursiveSet(itemID, ply, true)
	ply.marketSub = itemID
end

hook.Add('PlayerDisconnected', 'octoinv.marketSub', function(ply)
	for _, plys in pairs(octoinv.marketSubs) do
		table.RemoveByValue(plys, ply)
	end
end)

local function checkCanTrade(ply, ignoreLimit)
	return util.Promise(function(res, rej)
		-- if not ply:Alive() or ply:IsGhost() then
		-- 	return rej('Мертвые не могут торговать на рынке')
		-- end

		if not ply:HasMobilePhone() then
			return rej('Для этого нужен мобильный телефон')
		end

		for _, notif in ipairs(ply:GetDBVar('notifs') or {}) do
			if notif[1] == 'market' then
				return rej('Нужно закрыть все уведомления с рынка')
			end
		end

		if not ignoreLimit then
			octoinv.getPlayerOrders(ply):Then(function(orders)
				if #orders >= CFG.getMarketMaxOrders(ply) then
					return rej('Достигнут лимит активных заявок')
				end

				res()
			end)
		else
			res()
		end
	end)
end

local function checkCanTradeForChain(reply, ply, ignoreLimit)
	return function(done, ...)
		local args = {...}
		checkCanTrade(ply, ignoreLimit)
			:Then(function() done(unpack(args)) end)
			:Catch(function(msg) reply(msg) end)
	end
end

--
-- COMMON
--

netstream.Hook('octoinv.marketSummary', function(ply)
	if not ply:TriggerCooldown('marketSummary', 10) then return 'Слишком часто' end
	netstream.Start(ply, 'octoinv.marketSummary', nil, octoinv.marketSummary)
end)

netstream.Listen('octoinv.myOrders', function(reply, ply)
	if not ply:TriggerCooldown('marketMyOrders', 1) then return 'Слишком часто' end
	octoinv.getPlayerOrders(ply):Then(reply)
end)

netstream.Listen('octoinv.editOrder', function(reply, ply, mode, id, action)
	if not ply:TriggerCooldown('editOrder', 0.5) then return 'Слишком часто' end

	octolib.func.chain({
		checkCanTradeForChain(reply, ply, true),
		function()
			local sID = ply:SteamID()
			local lifeTime = CFG.getMarketOrderLifeTime(ply)
			if mode == 'stack' then
				octoinv.getStackOrder(id):Then(function(order)
					if order.steamID == sID then
						if action == 'cancel' then
							octoinv.deleteStackOrder(id)
							octoinv.refundStackOrder(order)
						elseif action == 'renew' then
							if order.expire < os.time() + 24 * 60 * 60 then
								octolib.db:PrepareQuery('update octoinv_orders_stack set expire = ? where id = ?', { os.time() + lifeTime, id })
							else
								return reply('Продлевать можно только заказы, у которых осталось менее 24 часов')
							end
						end
					end
					reply()
				end)
			elseif mode == 'nostack' then
				octoinv.getNoStackOrder(id):Then(function(order)
					if order.steamID == sID then
						if action == 'cancel' then
							octoinv.deleteNoStackOrder(id)
							octoinv.refundNoStackOrder(order)
						elseif action == 'renew' then
							if order.expire < os.time() + 24 * 60 * 60 then
								octolib.db:PrepareQuery('update octoinv_orders_nostack set expire = ? where id = ?', { os.time() + lifeTime, id })
							else
								return reply('Продлевать можно только заказы, у которых осталось менее 24 часов')
							end
						end
					end
					reply()
				end)
			end
		end,
	})
end)

--
-- STACK ORDERS
--

netstream.Hook('octoinv.getStackOrdersDOM', function(ply, itemID)
	if not ply:TriggerCooldown('marketItem', 0.5) then return 'Слишком часто' end
	subscribe(ply, itemID)
	octoinv.getStackOrdersDOM(itemID):Then(function(data)
		netstream.Start(ply, 'octoinv.getStackOrdersDOM', itemID, data)
	end)
end)

netstream.Listen('octoinv.createStackOrder', function(reply, ply, type, itemID, price, amount)
	local iData = octoinv.marketItems[itemID]
	if not iData then return reply('Тип предмета не найден в базе данных') end
	if not isnumber(price) or price <= 0 or not isnumber(amount) or amount <= 0 then return reply('Некорректные параметры') end

	if type == octoinv.ORDER_SELL and iData.canSell then
		local can, why = iData.canSell(ply, price, amount)
		if not can then return reply(why or 'Ты не можешь продать этот товар') end
	elseif type == octoinv.ORDER_BUY and iData.canBuy then
		local can, why = iData.canBuy(ply, price, amount)
		if not can then return reply(why or 'Ты не можешь купить этот товар') end
	end

	local sendCont
	octolib.func.chain({
		checkCanTradeForChain(reply, ply),
		function(done)
			if type == octoinv.ORDER_SELL then
				local fee = math.ceil(CFG.getMarketFee(ply) * price * amount)
				if not ply:BankHas(fee) then
					return reply('На счете в банке должно быть ' .. DarkRP.formatMoney(fee) .. ' для оплаты комиссии')
				end

				local box, distSqr = octoinv.getNearestMailbox(ply)
				if distSqr > 10000 then return reply('Для продажи надо доставить подходящие предметы в любой почтовый ящик') end

				sendCont = box.inv.conts.send
				if sendCont:HasItem(itemID) < amount then return reply('В почтовом ящике нет достаточного количества подходящих предметов') end

				sendCont:TakeItem(itemID, amount)
				ply:BankAdd(-fee)
				done()
			elseif type == octoinv.ORDER_BUY then
				if not ply:BankHas(price * amount) then
					return reply('На твоем счете недостаточно средств')
				end
				ply:BankAdd(-price * amount)
				done()
			end
		end,
		function(done)
			octoinv.createStackOrder(ply:SteamID(), type, itemID, price, amount, os.time() + CFG.getMarketOrderLifeTime(ply))
				:Then(done)
				:Catch(function()
					reply('Что-то пошло не так при создании лота')
				end)
		end,
		function()
			ply:Notify(('Заявка на %s создана: %s за %s'):format(
				type == octoinv.ORDER_SELL and 'продажу' or 'покупку',
				octoinv.itemStr({ itemID, amount }),
				DarkRP.formatMoney(price)
			))
			reply()
		end,
	})
end)

--
-- NOSTACK ORDERS
--

netstream.Hook('octoinv.listNoStackOrders', function(ply, itemID)
	if not ply:TriggerCooldown('marketItem', 0.5) then return 'Слишком часто' end
	subscribe(ply, itemID)
	octoinv.listNoStackOrders(itemID):Then(function(data)
		netstream.Start(ply, 'octoinv.listNoStackOrders', itemID, data)
	end)
end)

netstream.Listen('octoinv.createNoStackOrder', function(reply, ply, itemID)
	local sendCont, requestData, item
	octolib.func.chain({
		checkCanTradeForChain(reply, ply),
		function(done)
			local box, distSqr = octoinv.getNearestMailbox(ply)
			if distSqr > 10000 then return reply('Для продажи надо доставить подходящие предметы в любой почтовый ящик') end

			sendCont = box.inv.conts.send
			local items = octoinv.findMatchingMarketItems(sendCont, itemID)
			if table.Count(items) < 1 then return reply('В почтовом ящике нет подходящих предметов') end

			local startPrice = octoinv.marketSummary[itemID] and octoinv.marketSummary[itemID].minSell or nil
			local fee = CFG.getMarketFee(ply) * 100
			octolib.request.send(ply, {
				item = {
					name = 'Предмет',
					type = 'item',
					items = items,
					single = true,
					required = true,
				},
				price = {
					name = 'Стоимость',
					desc = 'Цена, которую заплатит покупатель. Тебе нужно заплатить ' .. fee .. '% от этой суммы для создания лота',
					type = 'strShort',
					numeric = true,
					default = startPrice,
					required = true,
				},
			}, done)
		end,
		checkCanTradeForChain(reply, ply), -- check one more time if something happened during request
		function(done, data)
			requestData = data
			requestData.price = tonumber(requestData.price or '')

			item = sendCont.items[requestData.item]
			if not item then return reply('Предмет не найден') end
			if not isnumber(requestData.price) or requestData.price <= 0 then return reply('Некорректные параметры') end

			local iData, _itemID = octoinv.marketDataFromItem(item)
			if itemID ~= _itemID then return reply('Предмет не найден') end

			if iData.canSell then
				local can, why = iData.canSell(ply, price, amount)
				if not can then return reply(why or 'Ты не можешь продать этот товар') end
			end

			requestData.price = math.floor(requestData.price)
			local fee = math.ceil(CFG.getMarketFee(ply) * requestData.price)
			if not ply:BankHas(fee) then
				return reply('На счете в банке должно быть ' .. DarkRP.formatMoney(fee) .. ' для оплаты комиссии')
			end

			ply:BankAdd(-fee)
			item:Remove()

			octoinv.createNoStackOrder(ply:SteamID(), octoinv.ORDER_SELL, itemID, requestData.price, item:Export(), os.time() + CFG.getMarketOrderLifeTime(ply))
				:Then(done)
				:Catch(function()
					reply('Что-то пошло не так при создании лота')
				end)
		end,
		function()
			ply:Notify(('Заявка на продажу создана: %s за %s'):format(octoinv.itemStr({ item.class, item.data }), DarkRP.formatMoney(requestData.price)))
			reply()
		end,
	})
end)

netstream.Listen('octoinv.buyNoStackOrder', function(reply, ply, id)
	local buyer, order = ply:SteamID()
	octolib.func.chain({
		checkCanTradeForChain(reply, ply, true),
		function(done)
			octoinv.getNoStackOrder(id):Then(done)
		end,
		function(done, _order)
			order = _order
			if not order then return reply('Лота не существует. Возможно, его уже купили') end

			local iData = octoinv.marketItems[order.item]
			if not iData then return reply('Тип предмета не найден в базе данных') end

			if iData.canBuy then
				local can, why = iData.canBuy(ply, order)
				if not can then return reply(why or 'Ты не можешь купить этот товар') end
			end

			if not ply:BankHas(order.price) then
				return reply('У тебя недостаточно денег на счету')
			end

			ply:BankAdd(-order.price)
			octoinv.deleteNoStackOrder(order.id):Then(done)
		end,
		function()
			octoinv.finishNoStackSell(order.steamID, order.item, order.price, order.data)
			octoinv.finishNoStackBuy(buyer, order.item, order.price, order.data)
			reply()
		end,
	})
end)

octolib.notify.registerActions('market', {
	function(ply, data)
		if not data.money and not data.item then return end
		return 'Получить', function(ply, data)
			if not ply:HasMobilePhone() then
				ply:Notify('warning', 'Для этого нужен мобильный телефон')
				return
			end

			if data.money then
				ply:BankAdd(data.money)
			end

			if data.item then
				local box = octoinv.sendToMailbox(ply, { data.item })
				if not box then return end

				ply:AddMarker {
					txt = 'Вещи с рынка',
					pos = box:GetPos() + Vector(0,0,40),
					col = Color(255,92,38),
					des = {'dist', { 100 }},
					icon = 'octoteam/icons-16/lorry.png',
				}

				ply:Notify('Вещи, купленные на рынке, отправлены в почтовый ящик')
			end

			return true
		end
	end,
})
