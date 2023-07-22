octoinv.marketRetainItems = octoinv.marketRetainItems or {}

function octoinv.marketRetainUpdate()

	local expire = os.time() + octolib.time.toSeconds(6, 'hours')
	for itemID, retain in pairs(octoinv.marketRetainItems) do
		local marketData = octoinv.marketItems[itemID]
		if not marketData then
			octoinv.marketRetainItems[itemID] = nil
			continue
		end

		local summary = octoinv.marketSummary[itemID]

		local retainSell = retain.sell
		if retainSell then
			local amount = summary and summary.totalSell or 0
			local price = summary and summary.minSell or 0
			if amount < retainSell.amount or price > retainSell.price then
				if marketData.nostack then
					for _ = 1, retainSell.amount do
						local price, data = retainSell.getOrderInfo()
						if not price then return end

						octoinv.createNoStackOrder(nil, octoinv.ORDER_SELL, itemID, price, data, expire)
					end
				else
					local currentAmount = 0
					while currentAmount < retainSell.amount do
						local price, amount = retainSell.getOrderInfo()
						if not price or amount < 1 then return end

						octoinv.createStackOrder(nil, octoinv.ORDER_SELL, itemID, price, amount, expire)
						currentAmount = currentAmount + amount
					end
				end
			end
		end

		local retainBuy = retain.buy
		if retainBuy then
			local amount = summary and summary.totalBuy or 0
			local price = summary and summary.maxBuy or 0
			if amount < retainBuy.amount or price < retainBuy.price then
				if marketData.nostack then
					-- for _ = 1, retainBuy.amount do
					-- 	local price, data = retainBuy.getOrderInfo()
					-- 	if not price then return end

					-- 	octoinv.createNoStackOrder(nil, octoinv.ORDER_BUY, itemID, price, data, expire)
					-- end
					octoinv.msg('Cannot create buy nostack order: not implemented')
				else
					local currentAmount = 0
					while currentAmount < retainBuy.amount do
						local price, amount = retainBuy.getOrderInfo()
						if not price or amount < 1 then return end

						octoinv.createStackOrder(nil, octoinv.ORDER_BUY, itemID, price, amount, expire)
						currentAmount = currentAmount + amount
					end
				end
			end
		end
	end

end

local retainInterval = octolib.time.toSeconds(1, 'hour')
local function tryRetainUpdate()

	-- use dbvars so that all servers won't try it at once
	octolib.getDBVar('octoinv', 'nextRetainUpdate'):Then(function(updateAt)
		if os.time() >= updateAt then
			octolib.setDBVar('octoinv', 'nextRetainUpdate', os.time() + retainInterval)
			octoinv.marketRetainUpdate()
		end
	end):Catch(function(err)
		octolib.setDBVar('octoinv', 'nextRetainUpdate', os.time() + retainInterval)
	end)

end
tryRetainUpdate()
timer.Create('octoinv.market.retain', retainInterval, 0, tryRetainUpdate)
