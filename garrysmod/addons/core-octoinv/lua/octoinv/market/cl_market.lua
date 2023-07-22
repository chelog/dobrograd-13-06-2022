octoinv.marketSummary = octoinv.marketSummary or {}

local timeRules = {
	{1, 'секунда', 'секунды', 'секунд'},
	{60, 'минута', 'минуты', 'минут'},
	{60 * 60, 'час', 'часа', 'часов'},
}

local function handleReply(err)
	if err then
		Derma_Message(err, 'Ошибка', 'Понятно')
	end
end

local PANEL = {}

function PANEL:Init()

	self:Dock(FILL)
	self:SetPaintBackground(false)
	self:SetVisible(false)

	local treeCont = self:Add 'DPanel'
	treeCont:Dock(LEFT)
	treeCont:SetWide(363)
	treeCont:SetPaintBackground(false)

	local tree = treeCont:Add 'DTree'
	tree:Dock(FILL)
	tree.OnNodeSelected = function(tree, node)
		self:OpenItem(node.itemID)
	end
	self.tree = tree

	local upperCont = treeCont:Add 'DPanel'
	upperCont:SetPaintBackground(false)
	upperCont:Dock(TOP)
	upperCont:SetTall(25)
	upperCont:DockMargin(0,0,0,5)

	local srch = upperCont:Add 'DTextEntry'
	srch:DockMargin(5,5,5,5)
	srch:Dock(FILL)
	srch:SetTooltip(L.search_or_filter)
	srch:SetUpdateOnType(true)
	srch.PaintOffset = 5
	srch:SetPlaceholderText(L.search_hint)
	srch.OnValueChange = function(srch, val)
		self:FilterItems(val)
	end

	local butMy = upperCont:Add 'DButton'
	butMy:Dock(RIGHT)
	butMy:DockMargin(5,0,0,0)
	butMy:SetText('Мои заявки')
	butMy:SizeToContentsX(20)
	butMy.DoClick = function()
		self:OpenMyOrders()
	end
	self.butMy = butMy

	local form = self:Add 'DPanel'
	form:Dock(BOTTOM)
	form:DockMargin(5, 0, 0, 0)
	form:SetTall(0)
	self.form = form

	local view = self:Add 'DPanel'
	view:Dock(FILL)
	view:DockMargin(5, 0, 0, 0)
	view:SetPaintBackground(false)
	self.view = view

	self.nodes = {}
	self:BuildTree()

end

function PANEL:Think()

	if self.pendingUpdate then
		self.pendingUpdate = nil
		self:Update()
	end

end

function PANEL:OpenMyOrders()

	local p = octolib.overlay(self:GetParent(), 'DPanel')
	p:SetSize(400, 300)
	p:DockPadding(5, 5, 5, 5)

	local l = p:Add 'DListView'
	l:Dock(FILL)
	l:AddColumn('Тип'):SetFixedWidth(60)
	l:AddColumn('Предмет'):SetFixedWidth(150)
	l:AddColumn('К-во'):SetFixedWidth(35)
	l:AddColumn('Цена')
	l:AddColumn('Осталось')
	l:AddLine('Загрузка...')

	local function rebuildMyOrders()
		netstream.Request('octoinv.myOrders'):Then(function(orders)
			l:Clear()

			for _, order in ipairs(orders) do
				local line = l:AddLine(
					order.type == octoinv.ORDER_BUY and 'Покупка' or 'Продажа',
					octoinv.getItemData(order.data or { class = order.item }, 'name') or 'Неизвестно',
					order.amount or 1,
					DarkRP.formatMoney(order.price or 0),
					octolib.string.formatCountExt(math.max(order.expire - os.time(), 0), timeRules)
				)
				line.order = order
			end

			function l:Think()
				if CurTime() < (self.nextThink or 0) then return end
				self.nextThink = CurTime() + 1

				for _, line in ipairs(self:GetLines()) do
					if line.order then
						line:SetValue(5, octolib.string.formatCountExt(math.max(line.order.expire - os.time(), 0), timeRules))
					end
				end
			end

		end)
	end
	rebuildMyOrders()

	function l:OnRowRightClick(_, line)
		if not line.order then return end
		octolib.menu({
			{'Продлить', 'icon16/arrow_refresh.png', function()
				netstream.Request('octoinv.editOrder', line.order.mode, line.order.id, 'renew')
					:Then(handleReply)
					:Finally(rebuildMyOrders)
			end},
			{'Отменить', 'icon16/delete.png', function()
				netstream.Request('octoinv.editOrder', line.order.mode, line.order.id, 'cancel')
					:Then(handleReply)
					:Finally(rebuildMyOrders)
			end},
		}):Open()
	end

end

function PANEL:BuildTree()

	local tr = self.tree

	local items = octolib.table.toKeyVal(octoinv.marketItems)
	table.sort(items, function(a, b) return octoinv.marketItemName(a[1]) < octoinv.marketItemName(b[1]) end)

	for _, itemData in ipairs(items) do
		local itemID, item = unpack(itemData)

		local node = tr:AddNode(octoinv.marketItemName(itemID), octoinv.marketItemIcon(itemID))
		local info = node.Label:Add 'DLabel'
		info:Dock(FILL)
		info:DockMargin(0, 0, 5, 0)
		info:SetContentAlignment(6)
		info:SetText('загрузка...')
		info:SetAlpha(110)
		node.info = info

		item.node = node
		node.itemID = itemID
		self.nodes[itemID] = node
	end

	for _, itemData in ipairs(items) do
		local itemID = itemData[1]
		local node = self.nodes[itemID]

		local parentID = octoinv.marketItems[itemID].parent
		local parentNode = octoinv.marketItems[parentID] and octoinv.marketItems[parentID].node
		if IsValid(parentNode) then
			parentNode:InsertNode(node)
			node:SetDrawLines(true)
		end
	end

	netstream.Start('octoinv.marketSummary')

end

local function okVal(val)
	return val ~= 0 and val ~= math.huge
end

local function recalcRecursive(node)
	if node.totalSell then
		return node.minSell, node.maxBuy, node.totalSell, node.totalBuy
	end

	local itemID = node.itemID
	local iData = itemID and octoinv.marketItems[itemID]
	if not iData then return end

	local cache = octoinv.marketSummary[itemID] or {}
	local minSell, maxBuy, totalSell, totalBuy =
		cache.minSell or math.huge,
		cache.maxBuy or 0,
		cache.totalSell or 0,
		cache.totalBuy or 0

	if IsValid(node.ChildNodes) then
		for _, child in ipairs(node.ChildNodes:GetChildren()) do
			local _minSell, _maxBuy, _totalSell, _totalBuy = recalcRecursive(child, child.itemID)
			minSell = math.min(minSell, _minSell or math.huge)
			maxBuy = math.max(maxBuy, _maxBuy or 0)
			totalSell = totalSell + (_totalSell or 0)
			totalBuy = totalBuy + (_totalBuy or 0)
		end
	end

	if iData.nostack then
		local info = {}
		if okVal(totalSell) or okVal(minSell) then
			info[#info + 1] = totalSell .. ' от ' .. DarkRP.formatMoney(minSell)
		end
		node.info:SetText(#info > 0 and table.concat(info, ', ') or '—')

		node.minSell, node.totalSell = minSell, totalSell
	else
		local info = {}
		if okVal(totalSell) or okVal(minSell) then
			info[#info + 1] = totalSell .. ' от ' .. DarkRP.formatMoney(minSell)
		end
		-- if okVal(totalBuy) or okVal(maxBuy) then
		-- 	info[#info + 1] = totalBuy .. ' до ' .. DarkRP.formatMoney(maxBuy)
		-- end
		node.info:SetText(#info > 0 and table.concat(info, ', ') or '—')

		node.minSell, node.maxBuy, node.totalSell, node.totalBuy = minSell, maxBuy, totalSell, totalBuy
	end

	return minSell, maxBuy, totalSell, totalBuy

end

function PANEL:Update()

	for _, node in pairs(self.nodes) do
		node.minSell, node.totalSell, node.maxBuy, node.totalBuy = nil
	end

	for _, node in pairs(self.nodes) do
		recalcRecursive(node)
	end

end

local function recursiveShow(node)
	node:SetVisible(true)
	if node.SetExpanded then node:SetExpanded(true, true) end

	local parent = node:GetParent()
	if parent.ClassName == 'DTree' then return end

	recursiveShow(parent)
end

function PANEL:FilterItems(val)

	if val == '' then
		-- show all
		for _, node in pairs(self.nodes) do
			node:SetVisible(true)
			if node.SetExpanded then node:SetExpanded(false, true) end
		end
	else
		-- hide all
		for _, node in pairs(self.nodes) do
			node:SetVisible(false)
		end

		-- show matched
		for itemID, node in pairs(self.nodes) do
			if utf8.lower(octoinv.marketItemName(itemID)):find(utf8.lower(val), 1, true) then
				recursiveShow(node)
			end
		end
	end

	self.tree:InvalidateLayout()

end

function PANEL:OpenItem(itemID)

	local iData = octoinv.marketItems[itemID or '']
	if not iData or (iData.children and not iData.nostack) then return end

	local node = iData.node
	if not IsValid(node) then return end

	local view = self.view
	local form = self.form
	view:Clear()

	local icon = view:Add 'DImage'
	icon:SetSize(64, 64)
	icon:SetImage('octoteam/icons/clock.png')
	icon:Center()
	function icon:Think()
		self:SetAlpha(octolib.math.remap(math.sin(CurTime() * 5), -1, 1, 50, 255))
	end

	if iData.nostack then
		netstream.Hook('octoinv.listNoStackOrders', function(_itemID, data)
			if not IsValid(self) or _itemID ~= itemID then return end
			view:Clear()
			form:Clear()
			form:SetTall(0)
			form.lastItemID = itemID

			local cont = view:Add 'DScrollPanel'
			cont:Dock(FILL)
			cont:DockMargin(5, 0, 0, 0)
			cont.selected = {}

			local title = octolib.label(cont, 'Продают')
			title:SetTall(30)
			title:SetContentAlignment(5)
			title:SetFont('octoinv.subtitle')
			local totalSell = node.totalSell or 0
			local info = octolib.label(cont, totalSell .. ' предложени' .. octolib.string.formatCount(totalSell, 'е', 'я', 'й'))
			info:SetContentAlignment(5)

			local icons = cont:Add 'DIconLayout'
			icons:Dock(FILL)
			icons:DockMargin(12, 5, 0, 0)
			icons:SetSpaceX(4)
			icons:SetSpaceY(6)

			if not iData.children then
				local sell = octolib.button(cont, 'Продать', function()
					netstream.Request('octoinv.createNoStackOrder', itemID):Then(handleReply)
				end)
				sell:SetTall(30)
				sell:DockMargin(0, 5, 0, 5)
			else
				local l = octolib.label(cont, 'Для продажи выбери отдельный предмет слева')
				l:DockMargin(0, 5, 0, 5)
				l:SetContentAlignment(5)
			end

			local buy = octolib.button(form, 'Купить', function(self)
				for _, id in ipairs(table.GetKeys(cont.selected)) do
					netstream.Request('octoinv.buyNoStackOrder', id):Then(handleReply)
					cont.selected[id] = nil
				end
				self:Update()
			end)
			buy:Dock(FILL)
			buy:SetTall(0)
			function buy:Update()
				form:SizeTo(form:GetWide(), #table.GetKeys(cont.selected) > 0 and 30 or 0, 0.2, 0, -1)
			end

			local function clickItem(pnl)
				if IsValid(pnl.selectedIcon) then
					pnl.selectedIcon:Remove()
					cont.selected[pnl.orderID] = nil
					buy:Update()
				else
					local icon = pnl:Add 'DImage'
					icon:SetMouseInputEnabled(false)
					icon:SetImage('icon16/tick.png')
					icon:SetSize(16, 16)
					icon:AlignLeft(4)
					icon:AlignTop(2)
					pnl.selectedIcon = icon
					cont.selected[pnl.orderID] = true
					buy:Update()
				end
			end

			for _, order in ipairs(data) do
				local p = icons:Add 'DPanel'
				p:SetPaintBackground(false)
				p:SetSize(64, 80)

				local i = octoinv.createItemPanel(p, order.data)
				i.orderID = order.id
				i.DoClick = clickItem

				local l = p:Add 'DLabel'
				l:Dock(BOTTOM)
				l:SetTall(16)
				l:SetContentAlignment(5)
				l:SetTextColor(color_white)
				l:SetText(DarkRP.formatMoney(order.price))
			end

			if #data >= 50 then
				local l = icons:Add 'DLabel'
				l:SetSize(340, 30)
				l:SetContentAlignment(5)
				l:SetText('Показаны только первые 50 предложений')
				l.OwnLine = true
			end
		end)
		netstream.Start('octoinv.listNoStackOrders', itemID)
	else
		netstream.Hook('octoinv.getStackOrdersDOM', function(_itemID, data)
			if not IsValid(self) or _itemID ~= itemID then return end
			view:Clear()

			if form.lastItemID ~= itemID then
				form:Clear()
				form:SetTall(30)

				local orderType = octolib.comboBox(form, nil, {
					{'Хочу продать', octoinv.ORDER_SELL, true},
					{'Хочу купить', octoinv.ORDER_BUY},
				})
				orderType:Dock(LEFT)
				orderType:DockMargin(3,3,3,3)
				orderType:SetWide(100)
				form.orderType = orderType

				local amount = octolib.textEntry(form)
				amount:Dock(LEFT)
				amount:DockMargin(5,8,8,8)
				amount:SetWide(50)
				amount:SetPlaceholderText('Кол-во')
				amount:SetNumeric(true)
				amount:SetDrawLanguageID(false)
				amount.PaintOffset = 5
				form.amount = amount

				local l1 = octolib.label(form, 'шт по')
				l1:Dock(LEFT)
				l1:DockMargin(0,5,3,5)
				l1:SetWide(30)
				l1:SetContentAlignment(5)

				local price = octolib.textEntry(form)
				price:Dock(LEFT)
				price:DockMargin(5,8,8,8)
				price:SetWide(65)
				price:SetPlaceholderText('Цена')
				price:SetNumeric(true)
				price:SetDrawLanguageID(false)
				price.PaintOffset = 5
				form.price = price

				local l2 = octolib.label(form, 'Р')
				l2:Dock(LEFT)
				l2:SetWide(8)
				l2:DockMargin(0,3,10,3)
				l2:SetContentAlignment(5)

				local place = octolib.button(form, 'Отправить', function()
					local _, t = orderType:GetSelected()
					local price, amount = tonumber(price:GetValue()), tonumber(amount:GetValue())
					if not price or not amount then return end

					if t == octoinv.ORDER_SELL then
						local fee = math.ceil(CFG.getMarketFee(LocalPlayer()) * price * amount)
						if fee < 0 then return end
						Derma_Query('Комиссия за создание лота составит ' .. DarkRP.formatMoney(fee) .. '\nПри своевременном обновлении она не списывается вновь. Продолжить?', 'Продажа предмета', 'Отправить', function()
							netstream.Request('octoinv.createStackOrder', t, itemID, price, amount):Then(handleReply)
						end, 'Отмена')
					else
						if price * amount < 0 then return end
						netstream.Request('octoinv.createStackOrder', t, itemID, price, amount):Then(handleReply)
					end
				end)
				place:Dock(FILL)
				place:DockMargin(0, 3, 3, 3)

				form.lastItemID = itemID
			end

			local contSell = view:Add 'DPanel'
			contSell:Dock(LEFT)
			contSell:SetWide(view:GetWide() / 2 - 2)
			contSell:SetPaintBackground(false)

			local titleSell = octolib.label(contSell, 'Продают')
			titleSell:SetTall(30)
			titleSell:SetContentAlignment(5)
			titleSell:SetFont('octoinv.subtitle')
			local totalSell = node.totalSell or 0
			local infoSell = octolib.label(contSell, totalSell .. ' предложени' .. octolib.string.formatCount(totalSell, 'е', 'я', 'й'))
			infoSell:SetContentAlignment(5)

			local listSell = contSell:Add 'DListView'
			listSell:Dock(FILL)
			listSell:DockMargin(0, 5, 0, 5)
			listSell:SetHideHeaders(true)
			listSell:AddColumn('Количество')
			listSell:AddColumn('Цена')

			local contBuy = view:Add 'DPanel'
			contBuy:Dock(FILL)
			contBuy:DockMargin(4, 0, 0, 0)
			contBuy:SetPaintBackground(false)

			local titleBuy = octolib.label(contBuy, 'Покупают')
			titleBuy:SetTall(30)
			titleBuy:SetContentAlignment(5)
			titleBuy:SetFont('octoinv.subtitle')
			titleBuy:SetText('Покупают')
			local totalBuy = node.totalBuy or 0
			local infoBuy = octolib.label(contBuy, totalBuy .. ' предложени' .. octolib.string.formatCount(totalBuy, 'е', 'я', 'й'))
			infoBuy:SetContentAlignment(5)

			local listBuy = contBuy:Add 'DListView'
			listBuy:Dock(FILL)
			listBuy:DockMargin(0, 5, 0, 5)
			listBuy:SetHideHeaders(true)
			listBuy:AddColumn('Количество')
			listBuy:AddColumn('Цена')

			function listSell:OnRowSelected(i, line)
				listBuy:ClearSelection()
				form.orderType:ChooseOptionID(2)
				form.amount:SetValue(line.amount)
				form.price:SetValue(line.price)
			end

			function listBuy:OnRowSelected(i, line)
				listSell:ClearSelection()
				form.orderType:ChooseOptionID(1)
				form.amount:SetValue(line.amount)
				form.price:SetValue(line.price)
			end

			for _, order in ipairs(octolib.array.filter(table.Reverse(data), function(v) return v[1] == 0 end)) do
				local _, price, amount = unpack(order)
				local line = listSell:AddLine(amount .. ' шт', 'по ' .. DarkRP.formatMoney(price))
				line.price, line.amount = price, amount
				line.Columns[1]:SetContentAlignment(6)
			end

			for _, order in ipairs(octolib.array.filter(data, function(v) return v[1] == 1 end)) do
				local _, price, amount = unpack(order)
				local line = listBuy:AddLine(amount .. ' шт', 'по ' .. DarkRP.formatMoney(price))
				line.price, line.amount = price, amount
				line.Columns[1]:SetContentAlignment(6)
			end
		end)
		netstream.Start('octoinv.getStackOrdersDOM', itemID)
	end

end

vgui.Register('octoinv_market', PANEL, 'DPanel')

hook.Add('octogui.f4-tabs', 'octoinv.market', function()

	octogui.addToF4({
		id = 'market',
		name = L.market,
		order = 12.2,
		icon = Material('octoteam/icons/chart_lines.png'),
		build = function(f)
			if not IsValid(octoinv.pnlMarket) then
				octoinv.pnlMarket = vgui.Create 'octoinv_market'
			end
			f:SetSize(750, 550)
			f:Add(octoinv.pnlMarket)
			octoinv.pnlMarket:SetVisible(true)
		end,
		show = function(f, st)
			if st then octoinv.pnlMarket:Update() end
			octoinv.pnlMarket:SetVisible(st)
		end,
	})

end)

netstream.Hook('octoinv.marketSummary', function(itemID, data)

	if itemID then
		octoinv.marketSummary[itemID] = data
	else
		octoinv.marketSummary = data
	end

	if IsValid(octoinv.pnlMarket) then
		octoinv.pnlMarket.pendingUpdate = true
	end

end)
