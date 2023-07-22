surface.CreateFont('octoinv.normal', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
})

local changed, shopcache, presetcache, foldercache, returncache, preview = true

local w
local function openPreview(item)

	if not item.model then return end
	if IsValid(w) then w:Remove() end

	w = vgui.Create 'DFrame'
	preview = w

	w:SetSize(400, 400)
	w:SetSizable(true)
	w:Center()
	w:MakePopup()
	w:SetTitle(L.inspection_hint .. item.name)
	w:DockPadding(0,24,0,0)

	local m = w:Add 'DAdjustableModelPanel'
	m:Dock(FILL)
	m:SetModel(item.plyMat and LocalPlayer():GetModel() or item.model)
	m.LayoutEntity = octolib.func.zero

	local ent = m:GetEntity()
	local mins, maxs = ent:GetModelBounds()
	ent:SetSkin(item.skin or 0)
	m:SetCamPos(mins:Distance(maxs) * Vector(1, 0, 0))
	m:SetFOV(50)
	m.aLookAngle = Angle(0, 45, 0)
	m.vCamPos = m.Entity:OBBCenter() - m.aLookAngle:Forward() * m.vCamPos:Length()

	if item.plyMat then
		local pos = m.Entity:OBBCenter() - Vector(0, 0, -36)
		m.aLookAngle = Angle(0, 180, 0)
		m.vCamPos = pos - m.aLookAngle:Forward() * (pos - m.vCamPos):Length()
		for i, mat in ipairs(ent:GetMaterials()) do
			if string.match(mat, '.+/sheet_%d+') then
				ent:SetSubMaterial(i - 1, item.plyMat)
			end
		end
	end

	local h = m:Add 'DLabel'
	h:Dock(TOP)
	h:SetTall(30)
	h:SetContentAlignment(5)
	h:SetMouseInputEnabled(false)
	h:SetText(L.inspection_help)

end

local methods = {
	{ 0, unpack(L.methods[1]) },
	{ 0.05, unpack(L.methods[2]) },
	{ 0.2, unpack(L.methods[3]) },
}

function octoinv.createShop()

	if IsValid(octoinv.pnlShop) then octoinv.pnlShop:Remove() end
	local basket, method, receiver = {}, 1, nil
	local pendingUpdate, loadingTab, shopTab, presetTab
	if not file.Exists('octoinv/shop_presets.dat', 'DATA') then
		file.Write('octoinv/shop_presets.dat', '{}')
	end

	local colBG = CFG.skinColors.bg
	local f = vgui.Create 'DFrame'
	f:SetSize(450, 600)
	f:SetDraggable(false)
	f:SetTitle('')
	f:DockPadding(3, 3, 3, 3)
	f:Center()
	f.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 23, w, h-23, colBG)
	end
	function f:PerformLayout()
		self.lblTitle:SetPos(8, 2)
		self.lblTitle:SetSize(self:GetWide() - 25, 20)
	end

	local ps = f:Add 'DPropertySheet'
	ps:Dock(FILL)
	f.btnClose:SetParent(ps)
	f.btnMaxim:Remove()
	f.btnMinim:Remove()

	local rf = ps:Add 'DButton'
	rf:SetSize(70, 18)
	rf:SetText(L.refresh)
	function rf:DoClick()
		octoinv.requestUpdate()
	end

	local oldLayout = ps.PerformLayout
	function ps:PerformLayout()
		oldLayout(self)
		if IsValid(f.btnClose) then f.btnClose:SetPos(ps:GetWide() - 31, -3) end
		rf:SetPos(ps:GetWide() - 100)
	end


	-- basket
	local p_basket = ps:Add 'DPanel'
	p_basket:Dock(FILL)
	p_basket:SetPaintBackground(false)
	local bTab = ps:AddSheet(L.basket, p_basket, octolib.icons.silk16('cart'))

	-- info panel
	local drawer = f:Add 'DDrawer'
	drawer:SetOpenSize(117)
	drawer:SetOpenTime(0.2)
	drawer.ToggleButton:SetVisible(false)

	local info_p = drawer:Add 'DPanel'
	info_p:Dock(FILL)
	info_p:DockMargin(3,0,3,3)

	local info_name = info_p:Add 'DLabel'
	info_name:Dock(TOP)
	info_name:DockMargin(5, 5, 5, 0)
	info_name:SetTall(25)
	info_name:SetFont('octoinv.normal')
	info_name:SetText(L.item)

	local defaultDesc = L.defaultDesc
	local info_desc = info_p:Add 'DLabel'
	info_desc:Dock(FILL)
	info_desc:DockMargin(5, 5, 5, 5)
	info_desc:SetContentAlignment(7)
	info_desc:SetWrap(true)
	info_desc:SetText(defaultDesc)

	local info_buy = info_p:Add 'DButton'
	info_buy:SetText(L.in_basket)
	info_buy:SetTall(25)
	function info_buy:PerformLayout()
		self:SizeToContentsX(20)
		self:AlignTop(5)
		self:AlignRight(5)
	end

	local bp = p_basket:Add 'DPanel'
	bp:Dock(BOTTOM)
	bp:DockMargin(8,5,8,8)
	bp:SetTall(55)
	bp:SetPaintBackground(false)

	local bp1 = bp:Add 'DPanel'
	bp1:Dock(TOP)
	bp1:DockMargin(0,0,0,0)
	bp1:SetTall(25)
	bp1:SetPaintBackground(false)

	local bp2 = bp:Add 'DPanel'
	bp2:Dock(FILL)
	bp2:DockMargin(0,5,0,0)
	bp2:SetTall(25)
	bp2:SetPaintBackground(false)

	local butClear = bp2:Add 'DButton'
	butClear:Dock(LEFT)
	butClear:SetWide(80)
	butClear:SetText(L.clear)
	butClear.DoClick = function(self)
		basket = {}
		p_basket:UpdateData()
	end

	local butBuy = bp2:Add 'DButton'
	butBuy:Dock(RIGHT)
	butBuy:SetWide(80)
	butBuy:SetText(L.butbuy)
	function butBuy:PerformLayout()
		self:SizeToContentsX(20)
		self:AlignRight()
	end
	function butBuy:DoClick()
		if table.Count(basket) < 1 then return end

		local toSend = {}
		for k,v in pairs(basket) do toSend[k] = v[2] end
		netstream.Start('octoinv.shop', toSend, method, receiver)
	end

	local cbReceiver = bp1:Add 'DComboBox'
	cbReceiver:Dock(FILL)
	cbReceiver:SetSortItems(false)
	function cbReceiver:OnSelect(i, text, val) receiver = val end
	cbReceiver:SetTooltip(table.concat({
		L.only_specified,
		L.add_friend_tab,
	}, string.char(10)))

	local lv = p_basket:Add 'DListView'
	lv:Dock(FILL)
	lv:DockMargin(8,0,8,0)
	lv:SetMultiSelect(false)
	lv:AddColumn(L.title)
	lv:AddColumn(L.qty):SetFixedWidth(60)
	lv:AddColumn(L.price2):SetFixedWidth(80)
	function lv:OnRowRightClick(i, line)
		local menu = DermaMenu()

		menu:AddOption(L.quantity, function()
			local bitem = basket[line.itemID]
			Derma_StringRequest(L.set_quantity, L.set_quantity_hint, bitem[2], function(res)
				local amount = tonumber(res)
				if amount then
					bitem[2] = math.Clamp(amount, 0, 1000)
					if bitem[2] == 0 then basket[line.itemID] = nil end
				end
				p_basket:UpdateData()
			end)
		end):SetIcon('icon16/chart_bar.png')

		menu:AddOption(L.delete, function()
			basket[line.itemID] = nil
			p_basket:UpdateData()
		end):SetIcon('icon16/delete.png')

		menu:Open()
	end

	function p_basket:UpdateData()
		lv:Clear()

		local lp = LocalPlayer()
		local items, total = 0, 0
		for itemID, itemData in pairs(basket) do
			local price = itemData[1].price * itemData[2]
			total = total + price

			local line = lv:AddLine(itemData[1].name, itemData[2], DarkRP.formatMoney(price))
			line.Columns[2]:SetContentAlignment(5)
			line.Columns[3]:SetContentAlignment(6)
			line.itemID = itemID
			items = items + 1
		end

		local deliveryPrice = lp:GetNetVar('os_delivery') and 0 or math.ceil(total * methods[method][1])
		if items < 1 then
			lv:AddLine(L.basket_empty)
		elseif deliveryPrice > 0 then
			local line = lv:AddLine(L.delivery, '', DarkRP.formatMoney(deliveryPrice))
			line.Columns[3]:SetContentAlignment(6)
		end
		total = total + deliveryPrice

		if lp:BankHas(total) then
			butBuy:SetEnabled(true)
			butBuy:SetText(L.order_for .. DarkRP.formatMoney(total))
		else
			butBuy:SetEnabled(false)
			butBuy:SetText(L.lacks .. DarkRP.formatMoney(total - BraxBank.PlayerMoney(lp)))
		end

		cbReceiver:Clear()
		local resetReceiver = true
		for i, ply in ipairs(player.GetAll()) do
			if FPP.Buddies[ply:SteamID()] ~= nil and ply:Alive() and not ply:GetNetVar('Ghost') and ply ~= lp then
				cbReceiver:AddChoice(ply:Name(), ply, ply == receiver)
				if ply == receiver then resetReceiver = false end
			end
		end
		if resetReceiver then receiver = nil end
		cbReceiver:AddChoice(L.yourself, nil, resetReceiver)
	end
	p_basket:UpdateData()

	function info_p:UpdateData(itemID, item)
		if IsValid(info_p.preview) then info_p.preview:Remove() end
		local pr
		if item.model then
			info_name:DockMargin(125, 5, 5, 0)
			info_desc:DockMargin(125, 5, 5, 5)
			pr = info_p:Add 'DAdjustableModelPanel'
			pr:SetSize(117, 117)
			pr:SetPos(1, 1)
			pr:SetModel(item.model)
			function pr:LayoutEntity(ent) end

			local ent = pr:GetEntity()
			local mins, maxs = ent:GetModelBounds()
			ent:SetSkin(item.skin or 0)
			pr:SetCamPos(mins:Distance(maxs) * Vector(1, 0, 0))
			pr:SetFOV(50)
			pr.aLookAngle = Angle(0, 45, 0)
			pr.vCamPos = pr.Entity:OBBCenter() - pr.aLookAngle:Forward() * pr.vCamPos:Length()
		else
			info_name:DockMargin(80, 5, 5, 0)
			info_desc:DockMargin(80, 5, 5, 5)
			pr = info_p:Add 'DImage'
			pr:SetSize(64, 64)
			pr:SetPos(10, 10)
			pr:SetCursor('none')
			pr:SetImage(item.icon)
		end
		info_p.preview = pr
		info_name:SetText(item.name)
		info_desc:SetText(item.desc or defaultDesc)

		info_buy:SetText(not basket[itemID] and L.in_basket or L.alr_in_basket)
		info_buy:SetEnabled(not basket[itemID])
		info_buy.DoClick = function(self)
			self:SetEnabled(false)
			self:SetText(L.alr_in_basket)
			basket[itemID] = {item, 1}
			p_basket:UpdateData()
		end
	end

	local p_shop = ps:Add 'DPanel'
	p_shop:Dock(FILL)
	p_shop:SetPaintBackground(false)

	local shopTree = p_shop:Add 'DTree'
	shopTree:Dock(FILL)
	shopTree:DockMargin(8,0,8,8)
	function shopTree:OnNodeSelected(node)
		if node.itemID then
			info_p:UpdateData(node.itemID, node.item)
		else
			node:SetExpanded(not node.m_bExpanded)
		end
	end
	function shopTree:DoRightClick(node)
		if not node.itemID then return end

		local menu = DermaMenu()
		menu:AddOption(L.add_in_basket, function()
			Derma_StringRequest(L.add_in_basket, L.cost_product, 1, function(res)
				local amount = tonumber(res)
				if amount then
					basket[node.itemID] = {node.item, math.Clamp((basket[node.itemID] and basket[node.itemID][2] or 0) + amount, 0, 1000)}
					if amount == 0 then basket[node.itemID] = nil end
				end
				p_basket:UpdateData()
			end)
		end):SetIcon('icon16/add.png')

		if basket[node.itemID] then
			menu:AddOption(L.delete_from_basket, function()
				basket[node.itemID] = nil
				p_basket:UpdateData()
			end):SetIcon('icon16/delete.png')
		end

		if node.item.model then
			menu:AddOption(L.preview, function()
				openPreview(node.item)
			end):SetIcon('icon16/zoom.png')
		end

		menu:Open()
	end

	function shopTree:UpdateData(q)
		self:Clear()
		if not shopcache then
			local catNode = self:AddNode(L.loading)
			catNode:SetIcon('octoteam/icons/sandwatch.png')
			return
		end

		local data = shopcache
		if q and q ~= '' then
			data = table.Copy(data)
			for cat, items in pairs(data) do
				for itemID, item in pairs(items) do
					if not utf8.lower(item.name):find(utf8.lower(q)) then
						items[itemID] = nil
					end
				end
			end
		end

		local addedTotal = 0
		for cat, items in pairs(data) do
			local catData = octoinv.shopCats[cat]
			local catNode = self:AddNode(catData.name)
			catNode:SetIcon(catData.icon)

			local added = 0
			for itemID, item in SortedPairsByMemberValue(items, 'name') do
				local itemNode = catNode:AddNode(item.name .. ' - ' .. DarkRP.formatMoney(item.price))
				itemNode:SetIcon(item.icon)
				-- itemNode.Columns[2]:SetContentAlignment(6)
				itemNode.itemID = itemID
				itemNode.item = item
				added = added + 1
				addedTotal = addedTotal + 1
			end
			if added < 1 then
				catNode:Remove()
			elseif q and q ~= '' then
				catNode:SetExpanded(true, true)
			end
		end

		if addedTotal < 1 then
			local catNode = self:AddNode(L.not_found)
			catNode:SetIcon('octoteam/icons/error.png')
		end
	end

	local search = p_shop:Add 'DTextEntry'
	search:Dock(TOP)
	search:DockMargin(13,5,13,10)
	search:SetTall(15)
	search:SetTooltip(L.search_or_filter)
	search:SetUpdateOnType(true)
	search.PaintOffset = 5
	search:SetPlaceholderText(L.search_hint)
	function search:OnValueChange(val)
		shopTree:UpdateData(val)
	end
	shopTab = ps:AddSheet(L.shop, p_shop, 'octoteam/icons/shop.png')
	shopTab.Tab.Image:SetSize(16, 16)
	shopTab.Tab:InvalidateLayout()

	local p_preset = ps:Add 'DPanel'
	p_preset:Dock(FILL)
	p_preset:SetPaintBackground(false)

	local presetTree = p_preset:Add 'DTree'
	presetTree:Dock(FILL)
	presetTree:DockMargin(8,0,8,5)
	function presetTree:OnNodeSelected(node)
		if node.presetID then
			node:SetExpanded(not node.m_bExpanded)
		end
	end

	local function fldRename(old, new)
		for _, preset in ipairs(presetcache) do
			if (preset.folder or 'Несортированные') == old then
				preset.folder = new
				changed = true
			end
		end
		file.Write('octoinv/shop_presets.dat', pon.encode(presetcache))
		presetTree:UpdateData()
	end

	local function fldRemove(name)
		local toRem = {}
		for id,preset in ipairs(presetcache) do
			if (preset.folder or 'Несортированные') == name then toRem[#toRem+1] = id end
		end
		for i = #toRem, 1, -1 do
			table.remove(presetcache, toRem[i])
			changed = true
		end
		file.Write('octoinv/shop_presets.dat', pon.encode(presetcache))
		presetTree:UpdateData()
	end

	local function fldExport(name)
		local items = {}
		for _,preset in ipairs(presetcache) do
			if (preset.folder or 'Несортированные') == name then items[#items+1] = preset end
		end
		for _,item in ipairs(items) do item.folder = nil end
		local ans = {}
		ans.folder, ans.items = name, items
		SetClipboardText(pon.encode(ans))
		octolib.notify.show('hint', 'Папка скопирована, теперь ты можешь вставить ее куда-нибудь')
	end

	function presetTree:DoRightClick(node)
		if node.isFolder then
			local thisFld = node:GetText()

			local menu = DermaMenu()
			menu:AddOption('Переименовать', function()
				Derma_StringRequest('Переименование', 'Укажи новое название папки', thisFld, function(name)
					if (name == thisFld) or (name == '') then return end
					if foldercache[name] then
						Derma_Query('Папка с таким именем уже существует. Объединить содержимое?', 'Существующий каталог',
										'Да', function() fldRename(thisFld, name) end, 'Нет')
					else fldRename(thisFld, name) end
				end, nil, 'Переименовать', 'Отмена')
			end):SetIcon('icon16/pencil.png')

			if table.Count(foldercache) > 1 then
				local move, moveOpt = menu:AddSubMenu('Переместить содержимое')
				moveOpt:SetIcon('icon16/door_in.png')
				for fld in pairs(foldercache) do
					if fld ~= thisFld then move:AddOption(fld, function() fldRename(thisFld, fld) end):SetIcon('icon16/folder.png') end
				end
			end

			menu:AddOption('Экспорт папки', function() fldExport(thisFld) end):SetIcon('icon16/page_go.png')

			menu:AddOption('Удалить папку', function()
				Derma_Query('Точно хочешь удалить папку?\nЭто действие нельзя отменить', 'Удаление папки', 'Да', function() fldRemove(thisFld) end, 'Нет')
			end):SetIcon('icon16/delete.png')

			menu:Open()
		end
		if not node.presetID then return end

		local menu = DermaMenu()
		if not node.invalid then
			menu:AddOption(L.add_in_basket, function()
				Derma_StringRequest(L.add_in_basket, L.how_much_kits, 1, function(res)
					local pAmount = tonumber(res)
					if pAmount and shopcache then
						pAmount = math.Clamp(pAmount, 1, 100)

						local itemData = {}
						for cat, items in pairs(shopcache) do
							for itemID, item in pairs(items) do
								itemData[itemID] = item
							end
						end

						local preset = presetcache[node.presetID]
						for itemID, amount in pairs(preset.items) do
							local item = itemData[itemID]
							if item then
								if basket[itemID] then
									basket[itemID][2] = basket[itemID][2] + amount * pAmount
								else
									basket[itemID] = {item, amount * pAmount}
								end
							end
						end
					end
					p_basket:UpdateData()
				end)
			end):SetIcon('icon16/add.png')

		end

		local move,moveOpt = menu:AddSubMenu('Переместить')
		local curFld = presetcache[node.presetID].folder or 'Несортированные'
		moveOpt:SetIcon('icon16/door_in.png')
		move:AddOption('Новая папка', function()
			Derma_StringRequest('Создание новой папки', 'Укажи название папки', curFld, function(folder)
				if (folder == curFld) or (folder == '') then return end
				presetcache[node.presetID].folder = folder
				changed = true
				file.Write('octoinv/shop_presets.dat', pon.encode(presetcache))
				presetTree:UpdateData()
			end)
		end):SetIcon('icon16/folder_add.png')
		for fld in pairs(foldercache) do
			if fld ~= curFld then
				move:AddOption(fld, function()
					presetcache[node.presetID].folder = fld
					changed = true
					file.Write('octoinv/shop_presets.dat', pon.encode(presetcache))
					presetTree:UpdateData()
				end):SetIcon('icon16/folder.png')
			end
		end

		menu:AddOption(L.rename, function()
			Derma_StringRequest(L.rename, L.rename_kit, presetcache[node.presetID].name, function(name)
				if (name == presetcache[node.presetID].name) or (name == '') then return end
				presetcache[node.presetID].name = name
				changed = true
				file.Write('octoinv/shop_presets.dat', pon.encode(presetcache))
				presetTree:UpdateData()
			end, nil, L.rename, L.cancel)
		end):SetIcon('icon16/pencil.png')

		menu:AddOption(L.export_kit, function()
			SetClipboardText(pon.encode(presetcache[node.presetID]))
			octolib.notify.show('hint', L.export_kit_hint)
		end):SetIcon('icon16/page_go.png')

		menu:AddOption(L.delete_kit, function()
			table.remove(presetcache, node.presetID)
			changed = true
			file.Write('octoinv/shop_presets.dat', pon.encode(presetcache))

			presetTree:UpdateData()
		end):SetIcon('icon16/delete.png')

		menu:Open()
	end

	local function update(tree, presets, itemData)

		foldercache = {}
		for presetID, preset in ipairs(presets) do
			local folderName = preset.folder or 'Несортированные'
			local folder = nil
			if not foldercache[folderName] then
				folder = tree:AddNode(folderName)
				folder.isFolder = true
				foldercache[folderName] = folder
			else folder = foldercache[folderName] end
			local presetNode = folder:AddNode(preset.name)

			local price = 0
			for itemID, amount in pairs(preset.items) do
				local item = itemData[itemID]
				if not item then
					item = { name = L.unavailable_item, icon = 'octoteam/icons/error.png', price = 0 }
					presetNode.invalid = true
				end
				if amount <= 0 then
					presetNode.invalid = true
				end

				local itemNode = presetNode:AddNode(amount .. ' x ' .. item.name .. ' - ' .. DarkRP.formatMoney(item.price * amount))
				itemNode:SetIcon(item.icon)
				price = price + item.price * amount
			end

			if not presetNode.invalid then
				presetNode:SetText(preset.name .. ' - ' .. DarkRP.formatMoney(price))
				presetNode:SetIcon('octoteam/icons/blueprint.png')
			else
				presetNode:SetText(preset.name .. L.octoinv_unavailable)
				presetNode:SetIcon('octoteam/icons/error.png')
			end
			presetNode.presetID = presetID
		end

	end


	function presetTree:UpdateData()
		self:Clear()

		local data = shopcache
		if not data then
			local catNode = self:AddNode(L.loading)
			catNode:SetIcon('octoteam/icons/sandwatch.png')
			return
		end

		local presets
		pcall(function() presets = pon.decode(file.Read('octoinv/shop_presets.dat', 'DATA')) end)
		presetcache = presets or {}

		local itemData = {}
		for cat, items in pairs(data) do
			for itemID, item in pairs(items) do
				itemData[itemID] = item
			end
		end

		if changed then
			table.sort(presetcache, function(a, b)
				return (a.folder or 'Несортированные')..'/'..a.name < (b.folder or 'Несортированные')..'/'..b.name
			end)
			changed = false
		end
		update(self, presetcache, itemData)
	end

	local butPreset = bp2:Add 'DButton'
	butPreset:Dock(LEFT)
	butPreset:DockMargin(5,0,0,0)
	butPreset:SetWide(80)
	butPreset:SetText(L.in_kit)
	butPreset.DoClick = function(self)
		if table.Count(basket) < 1 then return end
		presetcache = presetcache or {}
		Derma_StringRequest(L.save_kit, L.give_title_kit, L.kit_hint .. #presetcache + 1, function(name)
			local items = {}
			for k,v in pairs(basket) do items[k] = v[2] end
			table.insert(presetcache, 1, {name = name, items = items})
			file.Write('octoinv/shop_presets.dat', pon.encode(presetcache))

			presetTree:UpdateData()
		end)
	end

	local tooltip = {}
	local cbMethod = bp1:Add 'DComboBox'
	cbMethod:Dock(LEFT)
	cbMethod:SetWide(170)
	cbMethod:DockMargin(0, 0, 5, 0)
	cbMethod:SetSortItems(false)
	for i, m in ipairs(methods) do
		cbMethod:AddChoice(m[2], i, i == 1)
		table.insert(tooltip, m[2] .. ': ' .. m[3])
	end
	function cbMethod:OnSelect(i, text, val)
		method = val
		p_basket:UpdateData()
	end
	cbMethod:SetTooltip(table.concat(tooltip, string.char(10)))

	local presetButs = p_preset:Add 'DPanel'
	presetButs:Dock(BOTTOM)
	presetButs:SetTall(25)
	presetButs:DockMargin(8, 0, 8, 8)
	presetButs:SetPaintBackground(false)

	local butImport = presetButs:Add 'DButton'
	butImport:Dock(RIGHT)
	butImport:SetWide(95)
	butImport:SetText(L.octoinv_import)
	function butImport:DoClick()
		Derma_StringRequest(L.octoinv_import, L.enter_code_export, '', function(s)
			local _, data = pcall(pon.decode, s)
			if not istable(data) then
				print('SHOP IMPORT ERROR:', data)
				return octolib.notify.show('warning', L.import_failure)
			end

			if data.folder then
				for _,item in ipairs(data.items) do
					item.folder = data.folder
					table.insert(presetcache, 1, item)
				end
			else table.insert(presetcache, 1, data) end
			file.Write('octoinv/shop_presets.dat', pon.encode(presetcache))
			presetTree:UpdateData()
			octolib.notify.show('hint', L.import_successful)
		end, nil, L.ok, L.cancel)
	end

	presetTab = ps:AddSheet(L.my_kits, p_preset, 'octoteam/icons/blueprint.png')
	presetTab.Tab.Image:SetSize(16, 16)
	presetTab.Tab:InvalidateLayout()

	function ps:OnActiveTabChanged(old, new)
		if new == shopTab.Tab then
			drawer:Open()
			ps:DockMargin(0,0,0,115)
		else
			drawer:Close()
			ps:DockMargin(0,0,0,0)
		end
	end

	local p_return = ps:Add 'DPanel'
	p_return:SetPaintBackground(false)

	local returnSelected = {}

	local sp = p_return:Add 'DScrollPanel'
	sp:Dock(FILL)

	local returnList = sp:Add 'DIconLayout'
	returnList:Dock(FILL)
	returnList:SetSpaceX(4)
	returnList:SetSpaceY(4)

	local but_return = p_return:Add 'DButton'
	but_return:SetSize(80, 25)
	but_return:AlignRight(0)
	but_return:AlignBottom(0)
	but_return:SetText('Отправить')
	but_return:SetEnabled(false)

	function but_return:DoClick()
		self:SetEnabled(false)
		netstream.Start('octoinv.return', table.GetKeys(returnSelected))
	end

	local function clickReturnItem(self)
		local enable = not returnSelected[self.itemID] or nil
		returnSelected[self.itemID] = enable
		but_return:SetEnabled(table.Count(returnSelected) > 0)
		self.selectedIcon:SetVisible(enable)
	end

	function returnList:UpdateData()
		self:Clear()

		for itemID, item in ipairs(returncache) do
			if not item.class then
				item.class = item[1]
				item.amount = isnumber(item[2]) and item[2] or 1
				if istable(item[2]) then
					for k, v in pairs(item[2]) do
						item[k] = v
					end
				end
				item[1], item[2] = nil, nil
			end
			local pnl = octoinv.createItemPanel(self, item)
			pnl.itemID = itemID
			pnl.DoClick = clickReturnItem

			local icon = pnl:Add 'DImage'
			icon:SetMouseInputEnabled(false)
			icon:SetImage('icon16/tick.png')
			icon:SetSize(16, 16)
			icon:AlignRight(4)
			icon:AlignTop(2)
			icon:SetVisible(false)
			pnl.selectedIcon = icon
		end

		self:InvalidateLayout()
		self:InvalidateParent()
		timer.Simple(0.2, function() if not IsValid(self) then return end self:InvalidateChildren() end)
	end

	function p_return:PerformLayout()
		but_return:AlignRight(0)
		but_return:AlignBottom(0)
	end

	ps:AddSheet('Возврат', p_return, octolib.icons.silk16('lorry'))

	f:SetDeleteOnClose(false)
	f:SetVisible(false)

	function octoinv.requestUpdate()

		local function doit()
			basket = {}
			search:SetValue('')
			p_basket:UpdateData()

			netstream.Start('octoinv.shoplist')
		end

		if table.Count(basket) > 0 then
			Derma_Query(L.basket_warning, L.refresh_shop, L.continue_hint, doit, L.cancel)
		else
			doit()
		end

	end

	function octoinv.updateShop()

		p_basket:UpdateData()
		if pendingUpdate then
			if table.Count(basket) > 0 then
				Derma_Query(L.something_change_shop,
					L.refresh_shop, L.refresh, octoinv.requestUpdate, L.cancel)
			else
				octoinv.requestUpdate()
			end
			pendingUpdate = false
		end

	end

	pendingUpdate = true
	function octoinv.openShop()

		f:SetVisible(true)
		f:MakePopup()
		octoinv.updateShop()

		return f

	end

	netstream.Hook('octoinv.shop', function()
		if octoinv.pnlShop:IsVisible() then
			basket = {}
			p_basket:UpdateData()
		else
			pendingUpdate = true
		end
	end)

	netstream.Hook('octoinv.shoplist', function(data)
		shopcache = data
		if not IsValid(ps) then return end
		shopTree:UpdateData()
		presetTree:UpdateData()
	end)

	netstream.Hook('octoinv.return', function(data)
		returncache = data or {}
		table.Empty(returnSelected)
		if not IsValid(ps) then return end
		returnList:UpdateData()
	end)

	octoinv.pnlShop = f

end

hook.Add('InitPostEntity', 'octoinv-shop.init', octoinv.createShop)
