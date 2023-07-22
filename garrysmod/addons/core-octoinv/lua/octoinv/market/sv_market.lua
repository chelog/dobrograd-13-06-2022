octoinv.marketQueue = {}
octoinv.marketQueuePending = false
octoinv.executeOrderFuncs = octoinv.executeOrderFuncs or {}

hook.Add('octolib.db.init', 'octoinv.market', function()

	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS octoinv_orders_stack (
			id INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
			steamID VARCHAR(30),
			type TINYINT(1) UNSIGNED NOT NULL,
			item VARCHAR(30) NOT NULL,
			price INT(10) UNSIGNED NOT NULL,
			amount INT(6) UNSIGNED NOT NULL,
			expire INT(10) UNSIGNED,
				PRIMARY KEY (id)
		) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci
	]])

	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS octoinv_orders_nostack (
			id INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
			steamID VARCHAR(30),
			type TINYINT(1) UNSIGNED NOT NULL,
			item VARCHAR(30) NOT NULL,
			price INT(10) UNSIGNED NOT NULL,
			data TEXT,
			expire INT(10) UNSIGNED,
				PRIMARY KEY (id)
		) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci
	]])

	octoinv.refreshMarketSummary()

	timer.Create('octoinv.marketCheckExpired', 60, 0, function()
		octolib.db:PrepareQuery('select * from octoinv_orders_stack where expire < ?', { os.time() }, function(q, st, rows)
			for _, order in ipairs(rows) do
				octoinv.refundStackOrder(order)
				octoinv.marketUpdateItem(order.item)
			end
		end)
		octolib.db:PrepareQuery('delete from octoinv_orders_stack where expire < ?', { os.time() })

		octolib.db:PrepareQuery('select * from octoinv_orders_nostack where expire < ?', { os.time() }, function(q, st, rows)
			for _, order in ipairs(rows) do
				octoinv.refundNoStackOrder(order)
				octoinv.marketUpdateItem(order.item)
			end
		end)
		octolib.db:PrepareQuery('delete from octoinv_orders_nostack where expire < ?', { os.time() })
	end)

end)

function octoinv.refreshMarketSummary()

	octolib.func.parallel({
		stack = function(done) octoinv.getStackOrdersSummary():Then(done) end,
		noStack = function(done) octoinv.getNoStackOrdersSummary():Then(done) end,
	}):Then(function(data)
		local out = {}
		table.Merge(out, data.stack)
		table.Merge(out, data.noStack)
		octoinv.marketSummary = out
		netstream.Start(nil, 'octoinv.marketSummary', nil, out)
	end)

end

function octoinv.getMarketItemFamily(item)

	local out = { item }
	if octoinv.marketItems[item] and octoinv.marketItems[item].children then
		for _, childID in pairs(octoinv.marketItems[item].children) do
			for _, itemID in ipairs(octoinv.getMarketItemFamily(childID)) do
				out[#out + 1] = itemID
			end
		end
	end

	return out

end

function octoinv.getMarketItemFamilySQL(item)

	return table.concat(octolib.table.map(octoinv.getMarketItemFamily(item), function(item) return sql.SQLStr(item) end), ',')

end

function octoinv.marketDataFromItem(item)

	local class = istable(item) and item.class or item

	local iData = octoinv.marketItems[class]
	if iData and not iData.matches then
		return iData, class
	end

	for itemID, iData in pairs(octoinv.marketItems) do
		if iData.matches and iData.matches(item) then
			return iData, itemID
		end
	end

end

function octoinv.findMatchingMarketItems(cont, itemID)

	local out = {}

	local iData = octoinv.marketItems[itemID]
	if not iData then return out end

	if iData.matches then
		for i, item in ipairs(cont.items) do
			if iData.matches(item) then
				out[i] = item
			end
		end
	else
		for i, item in ipairs(cont.items) do
			if item.class == itemID then
				out[i] = item
			end
		end
	end

	return out

end

function octoinv.nextMarketOrder()

	local order = table.remove(octoinv.marketQueue, 1)
	if not order then
		octoinv.marketQueuePending = false
		return
	else
		octoinv.marketQueuePending = true
	end

	local func = octoinv.executeOrderFuncs[order.orderType or '']
	if func then func(order) end

end

function octoinv.getPlayerOrders(ply)

	return util.Promise(function(res, rej)
		local sID = ply:SteamID()
		return octolib.func.parallel({
			stack = function(done)
				octolib.db:PrepareQuery('select * from octoinv_orders_stack where steamID = ? and expire > ?', { sID, os.time() }, function(q, st, rows)
					if not st then return rej(rows) end
					done(octolib.table.mapSequential(rows, function(row)
						row.mode = 'stack'
						return row
					end))
				end)
			end,
			nostack = function(done)
				octolib.db:PrepareQuery('select * from octoinv_orders_nostack where steamID = ? and expire > ?', { sID, os.time() }, function(q, st, rows)
					if not st then return rej(rows) end
					done(octolib.table.mapSequential(rows, function(row)
						row.mode = 'nostack'
						row.data = pon.decode(row.data)
						return row
					end))
				end)
			end,
		}):Then(function(data)
			local out = {}
			table.Add(out, data.stack)
			table.Add(out, data.nostack)
			res(out)
		end)
	end)

end

local syncQueue = {}
hook.Add('Think', 'octoinv.marketSync', function()

	for itemID, _ in pairs(syncQueue) do
		local item = octoinv.marketItems[itemID]
		syncQueue[itemID] = nil
		if not item then continue end

		if item.nostack then
			octoinv.getNoStackOrdersSummary(itemID):Then(function(data)
				octoinv.marketSummary[itemID] = data
				netstream.Start(nil, 'octoinv.marketSummary', itemID, data)

				for _, ply in ipairs(octoinv.marketSubs[itemID] or {}) do
					local itemID = ply.marketSub
					if not itemID then continue end

					octoinv.listNoStackOrders(itemID):Then(function(data)
						netstream.Start(ply, 'octoinv.listNoStackOrders', itemID, data)
					end)
				end
			end)
		else
			octoinv.getStackOrdersSummary(itemID):Then(function(data)
				octoinv.marketSummary[itemID] = data
				netstream.Start(nil, 'octoinv.marketSummary', itemID, data)

				for _, ply in ipairs(octoinv.marketSubs[itemID] or {}) do
					local itemID = ply.marketSub
					if not itemID then continue end

					octoinv.getStackOrdersDOM(itemID):Then(function(data)
						netstream.Start(ply, 'octoinv.getStackOrdersDOM', itemID, data)
					end)
				end
			end)
		end
	end

end)

function octoinv.marketUpdateItem(itemID, dontSendCmd)

	syncQueue[itemID] = true

	if not dontSendCmd then
		octolib.sendCmdToOthers('marketUpdateItem', { itemID = itemID })
	end

end

hook.Add('octolib.event:marketUpdateItem', 'octoinv.market', function(data)
	octoinv.marketUpdateItem(data.itemID, true)
end)
