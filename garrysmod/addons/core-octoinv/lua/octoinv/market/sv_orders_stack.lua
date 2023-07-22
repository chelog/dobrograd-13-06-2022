function octoinv.listStackOrders(item, type, includeSteamID)

	local fields = 'id, item, price, amount, expire'
	if includeSteamID then fields = fields .. ', steamID' end

	if type == octoinv.ORDER_BUY then
		query = 'SELECT ' .. fields .. ' FROM octoinv_orders_stack WHERE item IN (' .. octoinv.getMarketItemFamilySQL(item) .. ') AND type = ' ..  octoinv.ORDER_BUY .. ' AND expire > ' .. os.time() .. ' ORDER BY price DESC LIMIT 100'
	elseif type == octoinv.ORDER_SELL then
		query = 'SELECT ' .. fields .. ' FROM octoinv_orders_stack WHERE item IN (' .. octoinv.getMarketItemFamilySQL(item) .. ') AND type = ' ..  octoinv.ORDER_SELL .. ' AND expire > ' .. os.time() .. ' ORDER BY price ASC LIMIT 100'
	else
		query = 'SELECT ' .. fields .. ' FROM octoinv_orders_stack WHERE item IN (' .. octoinv.getMarketItemFamilySQL(item) .. ') AND expire > ' .. os.time() .. ' LIMIT 100'
	end

	return util.Promise(function(res, rej)
		octolib.db:RunQuery(query, function(q, ok, data)
			if ok and istable(data) then
				res(data)
			else
				rej(data)
			end
		end)
	end)

end

function octoinv.getStackOrdersSummary(item)

	return util.Promise(function(res, rej)
		local where = 'expire > ' .. os.time()
		if item then where = where .. ' AND item = ' .. SQLStr(item) end

		octolib.db:RunQuery([[
			WITH
				buy AS (
					SELECT
						item AS itemBuy,
						SUM(amount) AS totalBuy,
						MAX(price) AS maxBuy
					FROM octoinv_orders_stack
					WHERE ]] .. where .. [[ AND type = ]] .. octoinv.ORDER_BUY .. [[
					GROUP BY itemBuy
				),
				sell AS (
					SELECT
						item as itemSell,
						SUM(amount) AS totalSell,
						MIN(price) AS minSell
					FROM octoinv_orders_stack
					WHERE ]] .. where .. [[ AND type = ]] .. octoinv.ORDER_SELL .. [[
					GROUP BY itemSell
				)

			SELECT * FROM buy
				LEFT JOIN sell ON buy.itemBuy = sell.itemSell
			UNION
			SELECT * FROM buy
				RIGHT JOIN sell ON buy.itemBuy = sell.itemSell
		]], function(q, ok, data)
			if ok and istable(data) then
				local out = {}
				for _,v in ipairs(data) do
					v.item = v.itemBuy or v.itemSell -- it worked without this before, wtf?
					v.itemBuy, v.itemSell = nil
					if not v.item then continue end
					v.totalBuy = tonumber(v.totalBuy)
					v.totalSell = tonumber(v.totalSell)
					out[v.item] = v
					v.item = nil
				end
				if item then
					res(out[item] or {})
				else
					res(out)
				end
			else
				rej(data)
			end
		end)
	end)

end

function octoinv.getStackOrdersDOM(item, depth)

	depth = tonumber(depth) or 20

	return util.Promise(function(res, rej)
		if not item then return rej('Item class must be provided') end

		local time = os.time()
		octolib.db:PrepareQuery([[
			WITH
				sell AS (
					SELECT type, price, SUM(amount) AS orders
					FROM octoinv_orders_stack
					WHERE TYPE = ? AND expire > ? AND item = ?
					GROUP BY price
					ORDER BY price ASC
					LIMIT ]] .. depth .. [[
				),
				buy AS (
					SELECT type, price, SUM(amount) AS orders
					FROM octoinv_orders_stack
					WHERE TYPE = ? AND expire > ? AND item = ?
					GROUP BY price
					ORDER BY price DESC
					LIMIT ]] .. depth .. [[
				)
			SELECT * FROM buy UNION SELECT * FROM sell
			ORDER BY price DESC
		]], { octoinv.ORDER_SELL, time, item, octoinv.ORDER_BUY, time, item }, function(q, ok, data)
			if ok and istable(data) then
				local out = octolib.table.map(data, function(row) return { row.type, row.price, tonumber(row.orders) } end)
				res(out)
			else
				rej(data)
			end
		end)
	end)

end

function octoinv.getStackOrder(id)

	return util.Promise(function(res, rej)
		octolib.db:PrepareQuery('select * from octoinv_orders_stack where id = ? limit 1', { id }, function(q, ok, data)
			if ok and istable(data) then
				if data[1] then
					res(data[1])
				else
					rej('Order not found')
				end
			else
				rej(data)
			end
		end)
	end)

end

function octoinv.createStackOrder(steamID, type, item, price, amount, expire)

	return util.Promise(function(res, rej)
		octoinv.marketQueue[#octoinv.marketQueue + 1] = {
			orderType = 'stack',
			res = res,
			rej = rej,
			steamID = steamID,
			type = type,
			item = item,
			price = price,
			amount = amount,
			expire = expire
		}

		if not octoinv.marketQueuePending then octoinv.nextMarketOrder() end
	end)

end

function octoinv.deleteStackOrder(id)

	return util.Promise(function(res, rej)
		octolib.db:PrepareQuery('select * from octoinv_orders_stack where id = ?', { id }, function(q, ok, rows)
			local row = istable(rows) and rows[1]
			if row then
				octolib.db:PrepareQuery('delete from octoinv_orders_stack where id = ?', { id }, function(q, ok, err)
					if ok then res() else rej(err) end
					octoinv.marketUpdateItem(row.item)
				end)
			else
				rej('Order does not exist')
			end
		end)
	end)

end

function octoinv.executeOrderFuncs.stack(order)

	order.price = order.price or 1
	order.amount = order.amount or 1
	order.expire = order.expire or (os.time() + CFG.getMarketOrderLifeTime())

	local itemData = octoinv.marketItems[order.item]
	if not itemData or itemData.children or itemData.nostack then
		order.rej('Unknown item class')
		return octoinv.nextMarketOrder()
	end

	if order.type == octoinv.ORDER_BUY then
		octolib.func.chain({
			function(done)
				octolib.db:PrepareQuery([[
					SELECT * FROM octoinv_orders_stack WHERE item = ? AND type = ? AND price <= ? AND expire > ?
				]], { order.item, octoinv.ORDER_SELL, order.price, os.time() }, done)
			end,
			function(done, q, ok, data)
				if not ok then return order.rej(data) end

				local deals = {}
				local excess = 0

				local left = order.amount
				for _, existing in ipairs(data) do
					local sold = math.min(existing.amount, left)
					left = left - sold
					excess = excess + sold * (order.price - existing.price)

					if existing.amount - sold <= 0 then
						octoinv.deleteStackOrder(existing.id)
					else
						octolib.db:PrepareQuery('UPDATE octoinv_orders_stack SET amount = amount - ? WHERE id = ?', { sold, existing.id })
					end

					if sold > 0 then
						local dealID = #deals + 1
						deals[dealID] = ('%s) %s по %s'):format(dealID, sold, DarkRP.formatMoney(existing.price))

						octoinv.finishStackSell(existing.steamID, order.item, sold, existing.price)
					end

					if left <= 0 then
						octoinv.marketUpdateItem(order.item)
						break
					end
				end

				local sold = order.amount - left
				if sold > 0 then
					octoinv.finishStackBuy(order.steamID, order.item, sold, order.price, deals, excess)
				end

				if left > 0 then
					octolib.db:PrepareQuery([[
						INSERT INTO octoinv_orders_stack(steamID, type, item, amount, price, expire) VALUES(?,?,?,?,?,?)
					]], { order.steamID, order.type, order.item, left, order.price, order.expire }, done)
				else
					order.res()
					return octoinv.nextMarketOrder()
				end
			end,
			function(done, q, ok, err)
				if ok then
					octoinv.marketUpdateItem(order.item)
					order.res({
						id = q:lastInsert(), steamID = order.steamID, item = order.item, type = order.type,
						amount = order.amount, price = order.price, expire = order.expire,
					})
				else
					order.rej(err)
				end
				return octoinv.nextMarketOrder()
			end,
		})
	elseif order.type == octoinv.ORDER_SELL then
		octolib.func.chain({
			function(done)
				octolib.db:PrepareQuery([[
					SELECT * FROM octoinv_orders_stack WHERE item = ? AND type = ? AND price >= ? AND expire > ?
				]], { order.item, octoinv.ORDER_BUY, order.price, os.time() }, done)
			end,
			function(done, q, ok, data)
				if not ok then return order.rej(data) end

				local deals = {}

				local left = order.amount
				for _, existing in ipairs(data) do
					local sold = math.min(existing.amount, left)
					left = left - sold
					local excess = sold * (existing.price - order.price)

					if existing.amount - sold <= 0 then
						octoinv.deleteStackOrder(existing.id)
					else
						octolib.db:PrepareQuery('UPDATE octoinv_orders_stack SET amount = amount - ? WHERE id = ?', { sold, existing.id })
					end

					if sold > 0 then
						local dealID = #deals + 1
						deals[dealID] = ('%s) %s по %s'):format(dealID, sold, DarkRP.formatMoney(existing.price))

						octoinv.finishStackBuy(existing.steamID, order.item, sold, existing.price, { ('1) %s по %s'):format(sold, DarkRP.formatMoney(existing.price)) }, excess)
					end

					if left <= 0 then
						octoinv.marketUpdateItem(order.item)
						break
					end
				end

				local sold = order.amount - left
				if sold > 0 then
					octoinv.finishStackSell(order.steamID, order.item, sold, order.price)
				end

				if left > 0 then
					octolib.db:PrepareQuery([[
						INSERT INTO octoinv_orders_stack(steamID, type, item, amount, price, expire) VALUES(?,?,?,?,?,?)
					]], { order.steamID, order.type, order.item, left, order.price, order.expire }, done)
				else
					order.res()
					return octoinv.nextMarketOrder()
				end
			end,
			function(done, q, ok, err)
				if ok then
					octoinv.marketUpdateItem(order.item)
					order.res({
						id = q:lastInsert(), steamID = order.steamID, item = order.item, type = order.type,
						amount = order.amount, price = order.price, expire = order.expire,
					})
				else
					order.rej(err)
				end
				return octoinv.nextMarketOrder()
			end,
		})
	else
		order.rej('Unknown order type')
		return octoinv.nextMarketOrder()
	end

end

function octoinv.finishStackSell(steamID, item, amount, price)

	if not steamID then return end

	local notifText = ('Сделка завершена: продажа %sx %s'):format(amount, octoinv.getItemData('name', item))
	local notifData = {
		text = notifText .. (' по %s (итого %s)'):format(DarkRP.formatMoney(price), DarkRP.formatMoney(price * amount)),
		money = price * amount,
	}

	octolib.notify.send(steamID, 'market', notifText, notifData)

end

function octoinv.finishStackBuy(steamID, item, amount, price, deals, excess)

	if not steamID then return end

	local notifText = ('Сделка завершена: покупка %sx %s'):format(amount, octoinv.getItemData('name', item))
	local notifData = {
		text = notifText .. ' по ' .. DarkRP.formatMoney(price),
		item = { item, amount },
	}

	if deals then
		notifData.text = notifData.text .. '\n' .. table.concat(deals, '\n')
	end

	if excess and excess > 0 then
		notifData.text = notifData.text .. '\nСдача: ' .. DarkRP.formatMoney(excess)
		notifData.money = excess
	end

	octolib.notify.send(steamID, 'market', notifText, notifData)

end

function octoinv.refundStackOrder(order)

	if not order.steamID then return end

	if order.type == octoinv.ORDER_SELL then
		local text = ('Заявка отменена: продажа %sx %s по %s'):format(order.amount, octoinv.getItemData('name', order.item), DarkRP.formatMoney(order.price))
		octolib.notify.send(order.steamID, 'market', text, { item = { order.item, order.amount }})
	elseif order.type == octoinv.ORDER_BUY then
		local text = ('Заявка отменена: покупка %sx %s по %s'):format(order.amount, octoinv.getItemData('name', order.item), DarkRP.formatMoney(order.price))
		octolib.notify.send(order.steamID, 'market', text, { money = order.price * order.amount })
	end

end
