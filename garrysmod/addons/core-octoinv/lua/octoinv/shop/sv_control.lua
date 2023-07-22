netstream.Hook('octoinv.shoplist', octoinv.syncShop)

local orderID = 1
netstream.Hook('octoinv.shop', function(ply, basket, methodID, receiver)

	if not IsValid(receiver) then receiver = ply end

	local override, why = hook.Run('octoinv.shop.order-override', ply, basket, methodID, receiver)
	if override ~= nil then
		if istable(override) then
			if override.ply then ply = override.ply end
			if override.basket then basket = override.basket end
			if override.methodID then methodID = override.methodID end
			if override.receiver then receiver = override.receiver end
		else
			ply:Notify('warning', why or L.can_not_order)
			return
		end
	end

	local method = methodID and octoinv.deliveryMethods[methodID]
	if not method then return end

	local sID = receiver:SteamID()

	local totalVolume, totalPrice, totalCount = octoinv.calcOrderPriceAndVolume(ply, basket)
	if not totalVolume or totalPrice <= 0 then return ply:addExploitAttempt() end

	local deliveryPrice = ply:GetNetVar('os_delivery') and 0 or method.price
	totalPrice = math.ceil(totalPrice * (1 + deliveryPrice))

	if totalVolume > 250 or totalCount > 50 then return ply:Notify('warning', L.too_much_order) end
	if not ply:BankHas(totalPrice) then return ply:Notify('warning', L.order_not_enough_money) end

	ply:BankAdd(-totalPrice)
	ply:DoEmote(L.make_order_hint)

	local curOrderID = orderID
	orderID = orderID + 1
	netstream.Start(ply, 'octoinv.shop', true)
	if receiver == ply then
		ply:Notify(L.order_accepted:format(curOrderID))
	else
		ply:Notify(L.order_accepted2:format(curOrderID, receiver:Name()))
		receiver:Notify(L.order_accepted3:format(ply:Name(), curOrderID))
	end

	local itemsPretty = {}
	for itemID, amount in pairs(basket) do
		local item = octoinv.shopItems[itemID]
		local itemData = octoinv.items[item.item or itemID]
		table.insert(itemsPretty, ('%d x %s'):format(amount, item.name or itemData.name or 'Неизвестно'))
	end

	hook.Run('octoinv.shop.order', ply, receiver, itemsPretty, totalPrice, curOrderID)

	local time = method.time
	timer.Simple(math.random(unpack(time)), function()
		if not IsValid(receiver) then receiver = ply end

		local items = {}
		for itemID, amount in pairs(basket) do
			local item = octoinv.shopItems[itemID]
			local itemData = octoinv.items[item.item or itemID]

			if itemData.nostack then
				for _ = 1, amount do
					items[#items + 1] = { item.item or itemID, item.data }
				end
			else
				items[#items + 1] = { item.item or itemID, amount }
			end
		end

		local box = IsValid(receiver) and method.findBox(receiver) or NULL
		box = octoinv.sendToMailbox(receiver:SteamID(), items, box)
		if not IsValid(box) then
			if IsValid(ply) then
				ply:BankAdd(totalPrice)
				ply:Notify('warning', (L.order_wrong_money_back):format(curOrderID))
			end
			if receiver ~= ply and IsValid(receiver) then
				receiver:Notify('warning', (L.order_wrong_money_back2):format(curOrderID))
			end
			return
		end

		local boxpos = box:GetPos()
		local nearestEstate = dbgEstates.getNearest(boxpos)
		local address = nearestEstate and nearestEstate.name or '???'

		if ply ~= receiver then
			ply:Notify(L.order_went:format(curOrderID, address, receiver:Name()))
			ply:AddMarker {
				txt = (L.order_format):format(receiver:Name()),
				pos = boxpos + Vector(0,0,40),
				col = Color(255,92,38),
				des = {'timedist', { 600, 100 }},
				icon = 'octoteam/icons-16/lorry.png',
			}
		end

		receiver:Notify(L.order_went2:format(curOrderID, address))
		receiver:AddMarker {
			txt = L.delivery_order,
			pos = box:GetPos() + Vector(0,0,40),
			col = Color(255,92,38),
			des = {'dist', { 100 }},
			icon = 'octoteam/icons-16/lorry.png',
		}

		hook.Run('octoinv.shop.delivery', ply, receiver, curOrderID, box)

		timer.Create('octoinv.destroy' .. box:EntIndex() .. sID, 600, 1, function()
			if not IsValid(bot) then return end
			local inv = bot:GetInventory()
			if not inv then return end
			local cont = inv:GetContainer(sID)
			if cont then
				if cont:FreeSpace() ~= cont.volume then
					if IsValid(ply) then ply:Notify(('Заказ #%s никто не забрал, поэтому вещи были выброшены'):format(curOrderID)) end
					hook.Run('octoinv.shop.timeout', ply, receiver, curOrderID, box)
				end
				cont:Remove(true)
			end
		end)
	end)

end)

netstream.Hook('octoinv.return', function(ply, itemIDs)

	if not istable(itemIDs) then return end
	table.sort(itemIDs) -- to make remove loop safe

	local cache = ply:GetDBVar('return')
	if not cache then return end

	local toSend = {}
	for i = #itemIDs, 1, -1 do
		local id = itemIDs[i]
		if not cache[id] then continue end
		toSend[#toSend + 1] = cache[id]
		table.remove(cache, id)
	end

	if #toSend < 1 then return end

	if #ents.FindByClass('octoinv_mailbox') < 1 then
		return ply:Notify('На карте нет почтовых ящиков! Обратись к администрации')
	end

	ply:SetDBVar('return', #cache > 0 and cache or nil)
	octoinv.syncShop(ply)

	local itemsPretty = {}
	for _, item in pairs(toSend) do
		table.insert(itemsPretty, octoinv.itemStr(item))
	end
	hook.Run('octoinv.shop.order', ply, ply, itemsPretty, 0, 'return')

	ply:Notify('Вещи будут доставлены в течение нескольких минут')
	timer.Simple(math.random(60, 120), function()
		local box = octoinv.sendToMailbox(ply, toSend)
		ply:AddMarker({
			txt = 'Возврат вещей',
			pos = box:GetPos() + Vector(0,0,40),
			col = Color(255,92,38),
			des = {'timedist', { 600, 100 }},
			icon = 'octoteam/icons-16/lorry.png',
		})
		ply:Notify('Вещи со склада возврата прибыли в почтовый ящик')
	end)

end)
