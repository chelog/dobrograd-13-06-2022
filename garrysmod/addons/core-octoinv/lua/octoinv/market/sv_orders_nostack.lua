function octoinv.createNoStackOrder(steamID, type, item, price, data, expire)

	return util.Promise(function(res, rej)
		octoinv.marketQueue[#octoinv.marketQueue + 1] = {
			orderType = 'nostack',
			res = res,
			rej = rej,
			steamID = steamID,
			type = type,
			item = item,
			price = price,
			data = data,
			expire = expire,
		}

		if not octoinv.marketQueuePending then octoinv.nextMarketOrder() end
	end)

end

function octoinv.getNoStackOrder(id)

	return util.Promise(function(res, rej)
		octolib.db:PrepareQuery('select * from octoinv_orders_nostack where id = ? limit 1', { id }, function(q, ok, data)
			if ok and istable(data) then
				if data[1] then
					data[1].data = pon.decode(data[1].data)
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

function octoinv.listNoStackOrders(item, limit, includeSteamID)

	local fields = 'id, item, price, data'
	if includeSteamID then fields = fields .. ', steamID' end

	limit = tonumber(limit) or 50

	return util.Promise(function(res, rej)
		if not item then return rej('Item class must be provided') end

		octolib.db:PrepareQuery([[
			SELECT ]] .. fields ..  [[ FROM octoinv_orders_nostack
			WHERE item IN (]] .. octoinv.getMarketItemFamilySQL(item) .. [[) AND expire > ?
			ORDER BY price ASC
			LIMIT ]] .. limit
		, { os.time(),  }, function(q, ok, data)
			if ok and istable(data) then
				for _, row in ipairs(data) do
					if not row.data then continue end
					row.data = pon.decode(row.data)
				end
				res(data)
			else
				rej(data)
			end
		end)
	end)

end

function octoinv.getNoStackOrdersSummary(item)

	return util.Promise(function(res, rej)
		local where = 'expire > ' .. os.time()
		if item then where = where .. ' AND item = ' .. SQLStr(item) end

		octolib.db:RunQuery([[
			SELECT
				item,
				COUNT(id) AS totalSell,
				MIN(price) AS minSell
			FROM octoinv_orders_nostack
			WHERE ]] .. where .. [[
			GROUP BY item
		]], function(q, ok, data)
			if ok and istable(data) then
				local out = {}
				for _,v in ipairs(data) do
					if not v.item then continue end
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

function octoinv.deleteNoStackOrder(id)

	return util.Promise(function(res, rej)
		octolib.db:PrepareQuery('select * from octoinv_orders_nostack where id = ?', { id }, function(q, ok, rows)
			local row = istable(rows) and rows[1]
			if row then
				octolib.db:PrepareQuery('delete from octoinv_orders_nostack where id = ?', { id }, function(q, ok, err)
					if ok then
						if q:affectedRows() > 0 then
							res()
							octoinv.marketUpdateItem(row.item)
						else
							rej('order not found')
						end
					else
						rej(err)
					end
				end)
			else
				rej('Order does not exist')
			end
		end)
	end)

end

function octoinv.executeOrderFuncs.nostack(order)

	order.price = order.price or 1
	order.data = order.data or {}
	order.expire = order.expire or (os.time() + CFG.getMarketOrderLifeTime())

	if order.type == octoinv.ORDER_SELL then
		local itemData = octoinv.marketItems[order.item]
		if not itemData or itemData.children or not itemData.nostack then
			order.rej('Unknown item class')
			return octoinv.nextMarketOrder()
		end

		octolib.db:PrepareQuery([[
			INSERT INTO octoinv_orders_nostack(steamID, type, item, data, price, expire) VALUES(?,?,?,?,?,?)
		]], { order.steamID, order.type, order.item, pon.encode(order.data), order.price, order.expire }, function(q, ok, err)
			if ok then
				octoinv.marketUpdateItem(order.item)
				order.res({
					id = q:lastInsert(), steamID = order.steamID, item = order.item, type = order.type,
					data = order.data, price = order.price, expire = order.expire,
				})
			else
				order.rej(err)
			end
			return octoinv.nextMarketOrder()
		end)
	else
		order.rej('Unknown order type')
		return octoinv.nextMarketOrder()
	end

end

function octoinv.finishNoStackSell(seller, itemID, price, data)

	if not seller then return end

	local itemStr = octoinv.itemStr({ data.class, data })
	octoinv.marketUpdateItem(itemID)

	local sellerText = ('Заявка исполнена: продажа %s за %s'):format(itemStr, DarkRP.formatMoney(price))
	octolib.notify.send(seller, 'market', sellerText, {
		text = sellerText,
		money = price,
	})

end

function octoinv.finishNoStackBuy(buyer, itemID, price, data)

	if not buyer then return end

	local item = { data.class or itemID, data }
	octoinv.marketUpdateItem(itemID)

	local buyerText = ('Заявка исполнена: покупка %s за %s'):format(octoinv.itemStr(item), DarkRP.formatMoney(price))
	octolib.notify.send(buyer, 'market', buyerText, { item = item	})

end

function octoinv.refundNoStackOrder(order)

	if not order.steamID then return end

	if not istable(order.data) then
		order.data = pon.decode(order.data)
	end

	local item = { order.data.class or order.item, order.data }
	local text = ('Заявка отменена: продажа %s за %s'):format(octoinv.itemStr(item), DarkRP.formatMoney(order.price))
	octolib.notify.send(order.steamID, 'market', text, { item = item })

end
