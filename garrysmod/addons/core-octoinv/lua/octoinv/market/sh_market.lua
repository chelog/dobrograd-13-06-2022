function CFG.getMarketOrderLifeTime(ply)
	return (IsValid(ply) and ply:GetNetVar('os_trader') and 7 or 3) * 24 * 60 * 60
end

function CFG.getMarketFee(ply)
	return IsValid(ply) and ply:GetNetVar('os_trader') and 0.05 or 0.1
end

function CFG.getMarketMaxOrders(ply)
	return IsValid(ply) and ply:GetNetVar('os_trader') and 20 or 10
end

octoinv.marketItems = octoinv.marketItems or {}

octoinv.ORDER_SELL = 0
octoinv.ORDER_BUY = 1

local recalcChildren = octolib.func.debounce(function()
	for itemID, item in pairs(octoinv.marketItems) do
		local parentItem = octoinv.marketItems[item.parent or '']
		if parentItem then
			parentItem.children = parentItem.children or {}
			parentItem.children[#parentItem.children + 1] = itemID
		end
	end
end, 0)

function octoinv.registerMarketItem(id, data)

	if not isstring(id) or not istable(data) then return end

	octoinv.marketItems[id] = data

	if octoinv.marketRetainItems then
		octoinv.marketRetainItems[id] = data.retain
	end

	recalcChildren()

end

function octoinv.registerMarketCatFromShop(id, overrides)

	local cat = octoinv.shopCats[id or '']
	if not cat then return end

	local catID = 'cat_' .. id
	local data = overrides and table.Copy(overrides) or {}
	data.name = cat.name
	data.icon = cat.icon
	octoinv.registerMarketItem(catID, data)

	for itemID, item in pairs(octoinv.shopItems) do
		if item.cat ~= id or item.data then continue end

		local itemData = octoinv.items[itemID]
		if not itemData then continue end

		octoinv.registerMarketItem(itemID, {
			parent = catID,
			name = item.name,
			icon = item.icon,
			nostack = itemData.nostack,
		})
	end

end

function octoinv.marketItemName(id, data)

	local iData = octoinv.marketItems[id]
	if not iData then return 'Предмет' end
	if isstring(iData.name) then return iData.name end
	if isfunction(iData.name) then return iData.name(data) end

	if octoinv.items[id] then
		return SERVER and octoinv.getItemData('name', id) or octoinv.getItemData({ class = id }, 'name')
	end

	return iData.parent and octoinv.marketItemName(iData.parent, data) or 'Предмет'

end

function octoinv.marketItemIcon(id, data)

	local iData = octoinv.marketItems[id]
	if not iData then return 'octoteam/icons/missingno.png' end
	if isstring(iData.icon) then return iData.icon end
	if isfunction(iData.icon) then return iData.icon(data) end

	if octoinv.items[id] then
		if SERVER then
			return octoinv.getItemData('icon', id)
		else
			local icon = octoinv.getItemData({ class = id }, 'icon')
			if not isstring(icon) then icon = icon:GetName() .. '.png' end
			return icon
		end
	end

	local icon = iData.parent and octoinv.marketItemIcon(iData.parent, data) or 'octoteam/icons/missingno.png'
	return icon

end
