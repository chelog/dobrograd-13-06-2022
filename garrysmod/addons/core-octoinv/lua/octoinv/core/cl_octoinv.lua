surface.CreateFont('octoinv.item', {
	font = 'Arial Bold',
	extended = true,
	size = 18,
	weight = 300,
	antialias = true,
})

surface.CreateFont('octoinv.item-sh', {
	font = 'Arial Bold',
	extended = true,
	size = 18,
	weight = 300,
	antialias = true,
	blursize = 5,
})

surface.CreateFont('octoinv.itemParam', {
	font = 'Arial Bold',
	extended = true,
	size = 13,
	weight = 300,
	antialias = true,
	underline = true,
})

surface.CreateFont('octoinv.small', {
	font = 'Arial',
	extended = true,
	size = 14,
	weight = 800,
	antialias = true,
})

surface.CreateFont('octoinv.footer', {
	font = 'Arial Bold',
	extended = true,
	size = 16,
	weight = 300,
	antialias = true,
})

surface.CreateFont('octoinv.footer-sh', {
	font = 'Arial Bold',
	extended = true,
	size = 16,
	weight = 300,
	blursize = 5,
	antialias = false,
})

surface.CreateFont('octoinv.title', {
	font = 'Calibri',
	extended = true,
	size = 42,
	weight = 350,
})

surface.CreateFont('octoinv.title-sh', {
	font = 'Calibri',
	extended = true,
	size = 42,
	weight = 350,
	blursize = 5,
	antialias = false,
})

surface.CreateFont('octoinv.subtitle', {
	font = 'Calibri',
	extended = true,
	size = 34,
	weight = 350,
})

hook.Add('Think', '_octoinv', function()
hook.Remove('Think', '_octoinv')

local skinBG = CFG.skinColors.bg
local icons = {
	error = octolib.icons.color('error', ''),
	-- mass = octolib.icons.color('weight', ''),
	-- volume = octolib.icons.color('size', ''),
	craft = octolib.icons.color('hammer', ''),
	wait = octolib.icons.color('sandwatch', ''),
	actions = octolib.icons.color('hand_point', ''),
	gestures = octolib.icons.color('hand_peace', ''),
	moveAll = Material(octolib.icons.silk16('lorry_go')),
	search = Material(octolib.icons.silk16('zoom')),
	on = Material(octolib.icons.silk16('lightbulb')),
	off = Material(octolib.icons.silk16('lightbulb_off')),
}

octoinv.invs = octoinv.invs or {}
octoinv.guiCurInv = { pnls = {}, posCache = {} }
octoinv.guiCurInv.posCache[LocalPlayer():EntIndex()] = octolib.vars.get('octoinv.positions') or { }
local pendingCraftBut = nil
local notifyState, notifyTimeout = 0, 0
local lastOpen, hangOpen = 0, false

local function showWindow(w)
	local pos = { w:GetPos() }

	w:SetVisible(true)
	w:MoveToFront()
	w:MoveTo(pos[1], pos[2] - 20, 0.2, 0, 0.5)
	w:AlphaTo(255, 0.2, 0)
	timer.Simple(0.25, function()
		if not IsValid(w) then return end
		w:SetVisible(true)
		w:SetAlpha(255)
		w:SetPos(pos[1], pos[2] - 20)
	end)
end

local function hideWindow(w)
	local pos = { w:GetPos() }
	w:MoveTo(pos[1], pos[2] + 20, 0.2, 0, 2)
	w:AlphaTo(0, 0.2, 0)
	timer.Simple(0.25, function()
		if not IsValid(w) then return end
		w:Remove()
	end)
end

local function drawText(text, font, x, y, xal, yal, col, shCol)

	draw.Text {
		text = text,
		font = font .. '-sh',
		pos = {x, y+2},
		xalign = xal,
		yalign = yal,
		color = shCol,
	}

	draw.Text {
		text = text,
		font = font,
		pos = {x, y},
		xalign = xal,
		yalign = yal,
		color = col,
	}

end

hook.Add('VGUIMousePressed', 'octoinv', function(pnl, but)

	if not IsValid(octoinv.mainPnl) or not octoinv.mainPnl:IsVisible() then return end
	for p, v in pairs(octoinv.guiCurInv.pnls) do
		if IsValid(p) and (pnl == p or p:IsOurChild(pnl)) then p:MoveToFront() end
	end

end)

local cols = {
	black35 = Color(0,0,0, 35),
	black100 = Color(0,0,0, 100),
	black250 = Color(0,0,0, 250),
	white150 = Color(255,255,255, 150),
	greyDark = Color(50,50,50, 255),
	indicator = Color(255,255,255, 200),
	health = Color(170,119,102),
	armor = Color(170,187,187),
	hunger = Color(102,170,170),
	txt = Color(238,238,238, 255),
	txtSh = Color(0,0,0, 255),
}
local skinCols = CFG.skinColors

local paints = {
	invBut = function(self, w, h)
		local al = self:IsHovered() and 1 or 0.75
		if IsValid(self.window) then
			draw.RoundedBox(4, 16, -5, 32, 8, cols.indicator)
			al = 1
		end
		surface.SetMaterial(self.icon)
		surface.SetDrawColor(255,255,255, al * 255)
		surface.DrawTexturedRect((w - 64) / 2, (h - 64) / 2, 64, 64)
	end,
	actBut = function(self, w, h)
		local al = self:IsHovered() and 1 or 0.75
		surface.SetMaterial(self.icon)
		surface.SetDrawColor(255,255,255, al * 255)
		surface.DrawTexturedRect(5, 5, 16, 16)
	end,
	actButSmall = function(self, w, h)
		local al = self:IsHovered() and 1 or 0.75
		surface.SetMaterial(self.icon)
		surface.SetDrawColor(255,255,255, al * 255)
		surface.DrawTexturedRect((w - 32) / 2, (h - 32) / 2, 32, 32)
	end,
	invPnlBar = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, cols.black35)
	end,
	canvas = function(self, w, h)
		local al1 = math.Clamp(self.VBar:GetScroll() * 15, 0, 255)
		local al2 = math.Clamp((self.VBar.CanvasSize - self.VBar:GetScroll()) * 15, 0, 255)
		draw.RoundedBox(0, 0, 0, w - 13, 1, Color(50,50,50, al1))
		draw.RoundedBox(0, 0, h - 1, w - 13, 1, Color(50,50,50, al2))
	end,
	canvasOver = function(self, w, h)
		local pnls = dragndrop.GetDroppable('octoinv_items')
		if pnls and pnls[1] then
			for i, pnl in ipairs(pnls) do
				if pnl.invOwner == self.invPnl.invOwner and pnl.contID == self.invPnl.contID then return end
			end

			draw.RoundedBox(4, 0, 0, w, h, cols.black250)
			draw.RoundedBox(4, 1, 1, w-2, h-2, Color(skinBG.r, skinBG.g, skinBG.b, 150))
			draw.Text({
				text = L.move_there,
				font = 'octoinv.item',
				pos = { w / 2, h / 2 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				color = color_white
			})
		end
	end,
	item = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(238,238,238))

		surface.SetMaterial(self.icon)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(16, 12, 32, 32)

		local item, hint, hintW, hintH, replTable = self.item, self.hint, self.hintW, self.hintH, self.replTable
		draw.Text({
			text = self.nameOverride or (octoinv.getItemData(item, 'name') % replTable),
			pos = { 5, h - 10 },
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
			color = cols.greyDark
		})

		local left = octoinv.getItemUpperMO(item)
		if left then
			local w2 = 8 + left:GetWidth()
			draw.RoundedBoxEx(8, w - w2, 0, w2, 16, skinBG, false, false, true, false)
			left:Draw(w - w2 / 2 + 1, 7, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		elseif octoinv.getItemData(item, 'amount') ~= 1 then
			local amount = octoinv.getItemData(item, 'amount')
			local w2 = 16 + (string.len(amount) - 1) * 6
			draw.RoundedBoxEx(8, w - w2, 0, w2, 16, skinBG, false, false, true, false)
			draw.Text({
				text = amount,
				font = 'octoinv.small',
				pos = { w - w2 / 2 + 1, 7 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				color = color_white
			})
		end

		if self.animSt > 0 and hint then
			local al = 255 * self.animSt
			surface.DisableClipping(true)

			local bx, by, bw, bh = -hintW - 16, -(hintH - 64) / 2 - 4, hintW + 12, hintH + 8
			draw.RoundedBox(4, bx, by, bw, bh, Color(skinBG.r * 0.6, skinBG.g * 0.6, skinBG.b * 0.6, al))
			draw.NoTexture()
			surface.DrawPoly({
				{x = -4, y = 36},
				{x = -4, y = 28},
				{x = 0, y = 32},
			})
			draw.RoundedBox(4, bx + 1, by + 1, bw - 2, bh - 2, Color(skinBG.r, skinBG.g, skinBG.b, al))
			draw.NoTexture()
			surface.DrawPoly({
				{x = -5, y = 36},
				{x = -5, y = 28},
				{x = -1, y = 32},
			})
			hint:Draw(bx + 6, by + 4, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, al)

			surface.DisableClipping(false)
		end
	end,
}

local function createMainPanel()

	if IsValid(octoinv.mainPnl) then octoinv.mainPnl:Remove() end
	local p = vgui.Create 'DPanel'
	octoinv.mainPnl = p

	p:SetSize(ScrW(), ScrH())
	p:SetPos(0, 0)
	p:MakePopup()

	if IsValid(octoinv.guiInvList) then
		if octoinv.invs then
			octoinv.refresh()
		end
	else
		local pnl = p:Add 'DPanel'
		pnl:SetPos(0, 0)
		pnl:SetSize(500, 74)
		function pnl:Paint(w, h)
			local col = ColorAlpha(skinCols.bg50, 200)
			draw.RoundedBox(4, 0, 0, 34, h, col)
			draw.RoundedBox(4, 56, 0, w - 56, h, col)
		end
		pnl.invs = {}
		octoinv.guiInvList = pnl

		local but1 = pnl:Add 'DButton'
		but1:SetPos(0, 0)
		but1:SetSize(32, 37)
		but1:SetText('')
		but1.icon = icons.actions
		but1.barTxt = L.actions
		but1.Paint = paints.actButSmall
		but1.DoClick = function(self)
			local m = octogui.cmenu.create()
			local x, y = self:LocalToScreen(16 - m:GetWide() / 2, 15 - m:GetTall())
			m:Open(x, y)
			m:SetAlpha(0)
			showWindow(m)
		end

		local but2 = pnl:Add 'DButton'
		but2:SetPos(0, 37)
		but2:SetSize(32, 37)
		but2:SetText('')
		but2.icon = icons.gestures
		but2.barTxt = L.gestures
		but2.Paint = paints.actButSmall
		but2.DoClick = function(self)
			local menu = octolib.createAnimSelectMenu()
			menu:PerformLayout()

			local x, y = self:LocalToScreen(16 - menu:GetWide() / 2, 15 - menu:GetTall())
			menu:Open(x, y)
			menu:SetAlpha(0)
			showWindow(menu)
		end

		local barHealth = pnl:Add 'DPanel'
		barHealth:SetPos(36, 0)
		barHealth:SetSize(8, 74)
		barHealth.barTxt = L.health
		function barHealth:Paint(w, h)
			local ply = LocalPlayer()
			draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(skinCols.bg50, 200))

			local armor = math.floor(math.Clamp((ply:Armor() or 0) / 100, 0, 1) * (h - w))
			if armor > 0 then draw.RoundedBox(4, 0, h - armor - 8, w, armor + w, cols.armor) end
			local health = math.floor(math.Clamp((ply:Health() or 0) / ply:GetMaxHealth(), 0, 1) * (h - w - 2))
			if health > 0 then draw.RoundedBox(4, 1, h - health - 9, w - 2, health + w, cols.health) end
		end

		local barHunger = pnl:Add 'DPanel'
		barHunger:SetPos(46, 0)
		barHunger:SetSize(8, 74)
		barHunger.barTxt = L.barhunger
		function barHunger:Paint(w, h)
			local ply = LocalPlayer()
			draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(skinCols.bg50, 200))
			local hunger = math.floor(math.Clamp((ply:GetNetVar('Energy') or 0) / 100, 0, 1) * (h - w - 2))
			if hunger > 0 then draw.RoundedBox(4, 1, h - hunger - 9, w - 2, hunger + w, cols.hunger) end
		end
	end
	p:SetVisible(false)

	function p:Paint(w, h)

		local hvrPnl = vgui.GetHoveredPanel()
		local txt = IsValid(hvrPnl) and hvrPnl.barTxt
		if txt then
			drawText(txt, 'octoinv.title', (w + 54) / 2, h - 84, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, cols.txt, cols.txtSh)
		end

		hook.Run('octoinv.paintPnl', w, h)

	end

	function p:OnKeyCodeReleased(key)

		if input.LookupKeyBinding(key) == '+menu' then
			octoinv.show(false)
		end

	end

	p:Receiver('octoinv_items', function(self, pnls, drop, menuID, x, y)
		if drop then
			local pnl = pnls[1]
			if not pnl or pnl:GetParent():GetParent():GetParent() == self or not pnl.contID then return end -- omg

			local owner, contID2 = pnl.invOwner, pnl.contID
			if pnl.itemID then
				local function drop(amount)
					netstream.Start('octoinv.drop', owner, contID2, pnl.itemID, amount)
				end

				if not menuID or menuID == 1 then
					drop(pnl.amount)
				elseif menuID == 2 then
					local itemName = octoinv.getItemData(octoinv.invs[owner][contID2].items[pnl.itemID], 'name')
					local contName = octoinv.invs[owner][contID2].name
					Derma_StringRequest(L.drop_items, L.what_hint .. itemName .. L.where_octoinv  .. contName .. L.amount_octoinv, pnl.amount, function(s)
						local amount = tonumber(s)
						if amount and amount > 0 then drop(amount) end
					end, nil, L.drop, L.cancel)
				end
			else
				for i, item in ipairs(octoinv.invs[owner][contID2].items) do
					netstream.Start('octoinv.drop', owner, contID2, i, item.amount or 1)
				end
			end
		end
	end, {
		L.drop_all,
		L.drop_cost,
	})

end

local lastCursorPos = { ScrW() / 2, ScrH() / 2 }
function octoinv.show(show)

	if not IsValid(octoinv.mainPnl) then
		createMainPanel()
		return
	end

	local w = octoinv.mainPnl
	if show then
		w:SetVisible(true)
		w:MoveTo(0, 0, 0.2, 0, 2)
		w:AlphaTo(255, 0.2, 0)
		w:SetMouseInputEnabled(true)
		w:SetKeyboardInputEnabled(true)
		timer.Create('octoinv.toggle', 0.25, 1, function()
			w:SetPos(0, 0)
			w:SetAlpha(255)
			w:SetVisible(true)
		end)

		gui.SetMousePos(lastCursorPos[1], lastCursorPos[2])
	elseif not timer.Exists('octoinv.toggle') then
		lastCursorPos[1], lastCursorPos[2] = gui.MousePos()

		w:SetVisible(true)
		w:MoveTo(0, 20, 0.2, 0, 2)
		w:AlphaTo(0, 0.2, 0)
		w:SetMouseInputEnabled(false)
		w:SetKeyboardInputEnabled(false)
		timer.Create('octoinv.toggle', 0.25, 1, function()
			w:SetPos(0, 20)
			w:SetAlpha(0)
			w:SetVisible(false)
		end)
	end

end

function octoinv.refreshInv(owner, contID, open)

	for pnl, _ in pairs(octoinv.guiCurInv.pnls) do
		if IsValid(pnl) and pnl.invOwner == owner and pnl.contID == contID then
			if octoinv.invs[owner] and octoinv.invs[owner][contID] then
				pnl:Refresh()
			else
				hideWindow(pnl)
			end
			return
		end
	end

	if open then octoinv.openInv(owner, contID, ScrW() / 2) end

end

function octoinv.refresh()

	if not IsValid(octoinv.guiInvList) then createMainPanel() end

	local pnl = octoinv.guiInvList
	pnl.invs = pnl.invs or {}

	for owner, invs in pairs(octoinv.invs) do
		if not owner then
			octoinv.invs[owner] = nil
		end
	end

	for owner, invs in pairs(pnl.invs) do
		for contID, but in pairs(invs) do
			if not octoinv.invs[but.invOwner] or not octoinv.invs[but.invOwner][but.contID] then
				but:Remove()
				pnl.invs[owner][contID] = nil
				if table.Count(pnl.invs[owner]) < 1 then
					pnl.invs[owner] = nil
				end
			end
		end
	end

	local totalW = 62
	local function processOwner(ent)
		local invs = octoinv.invs[ent]
		if not invs then return end

		for contID, inv in SortedPairs(invs, true) do
			pnl.invs[ent] = pnl.invs[ent] or {}

			local but = pnl.invs[ent][contID]
			if not IsValid(but) then
				but = vgui.Create('DButton', pnl)
				but.invOwner = ent
				but.contID = contID
			end
			but:SetPos(totalW, 0)
			but:SetSize(64, 74)
			but:SetText('')
			but.icon = inv.icon or icons.error
			but.barTxt = inv.name or L.container
			but.Paint = paints.invBut
			but.DoClick = function(self)
				local arrowX, _ = self:LocalToScreen(32, 0)
				self.window = octoinv.openInv(ent, contID, arrowX)
			end

			pnl.invs[ent][contID] = but

			totalW = totalW + 70
		end
	end
	totalW = totalW + 2

	if octoinv.invs[LocalPlayer():EntIndex()] then
		processOwner(LocalPlayer():EntIndex())
	end

	for owner, invs in pairs(octoinv.invs) do
		if owner ~= LocalPlayer():EntIndex() then
			processOwner(owner)
		end
	end

	pnl:SetWide(totalW)

	pnl:AlignBottom(5)
	pnl:CenterHorizontal()

end

local function interpDesc(item)
	return octoinv.getItemData(item, 'desc'):gsub('{(.-)}', function(key)
		local replace = octoinv.getItemData(item, key)
		if replace then
			return '<font=octoinv.itemParam>' .. replace .. '</font>'
		end
	end)
end

function octoinv.createItemPanel(list, item, constExpire)

	local itemPnl = list:Add 'DButton'
	itemPnl:SetSize(64, 64)
	itemPnl:SetText('')

	itemPnl.animSt = 0
	local icon = octoinv.getItemData(item, 'icon')
	itemPnl.icon = isstring(icon) and Material(icon) or icon
	itemPnl.item = item

	local amount = octoinv.getItemData(item, 'amount')
	local vol, mass = octoinv.getItemData(item, 'volume'), octoinv.getItemData(item, 'mass')
	local replTable = octoinv.getReplacementTable(item)
	local text = {
		'<font=octoinv.item>', octoinv.getItemData(item, 'name') % replTable, '</font>\n',
		octoinv.getItemData(item, 'desc') % replTable, '\n\n',
		vol, ' x ', amount, ' = ', math.Round(vol * amount, 3), 'л\n',
		mass, ' x ', amount, ' = ', math.Round(mass * amount, 3), 'кг',
	}

	if item.expire then
		local timeLeft = item.expire
		if not constExpire then timeLeft = timeLeft - os.time() end
		text[#text + 1] = '\n'
		if timeLeft <= 0 then
			text[#text + 1] = 'Срок действия закончился'
		elseif timeLeft >= 60 then
			text[#text + 1] = 'Осталось: ' .. octolib.time.formatDuration(timeLeft)
		else
			text[#text + 1] = 'Осталось: меньше минуты'
		end
	end

	itemPnl.hint = markup.Parse(table.concat(text), 200)
	itemPnl.replTable = replTable

	itemPnl.hintW, itemPnl.hintH = itemPnl.hint:Size()
	itemPnl.Paint = paints.item
	itemPnl.Think = function(self)
		local tgt = (self:IsHovered() or self:IsChildHovered()) and 1 or 0
		self.animSt = math.Approach(self.animSt, tgt, FrameTime() * 5)

		if not self.hint and self:IsHovered() then
			local amount = octoinv.getItemData(item, 'amount')
			local vol, mass = octoinv.getItemData(item, 'volume'), octoinv.getItemData(item, 'mass')
			local text = {
				'<font=octoinv.item>', octoinv.getItemData(item, 'name'), '</font=octoinv.itemParam>\n',
				interpDesc(item), '\n\n',
				vol, ' x ', amount, ' = ', (vol * amount), 'л\n',
				mass, ' x ', amount, ' = ', (mass * amount), 'кг',
			}

			if item.expire then
				local timeLeft = item.expire
				if not constExpire then timeLeft = timeLeft - os.time() end
				text[#text + 1] = '\n'
				if timeLeft <= 0 then
					text[#text + 1] = 'Срок действия закончился'
				elseif timeLeft >= 60 then
					text[#text + 1] = 'Осталось: ' .. octolib.time.formatDuration(timeLeft)
				else
					text[#text + 1] = 'Осталось: меньше минуты'
				end
			end

			itemPnl.hint = markup.Parse(table.concat(text), 200)
			itemPnl.hintW, itemPnl.hintH = itemPnl.hint:Size()
		end
	end
	itemPnl.OnCursorEntered = function(self) self:SetDrawOnTop(true) end
	itemPnl.OnCursorExited = function(self) self:SetDrawOnTop(false) end

	itemPnl.amount = amount

	return itemPnl

end

function octoinv.openInv(ent, contID, arrowX, but)

	for pnl, _ in pairs(octoinv.guiCurInv.pnls) do
		if not IsValid(pnl) then
			octoinv.guiCurInv.pnls[pnl] = nil
		else
			local owner, id = pnl.invOwner, pnl.contID
			if owner == ent and id == contID then
				hideWindow(pnl)
				return
			end
		end
	end

	if not octoinv.invs[ent] or not octoinv.invs[ent][contID] then return end

	local inv = octoinv.invs[ent][contID]
	local items = inv.items
	local rh = 101 + 68 * math.max(math.ceil(table.Count(items) / 4), 1)
	local w, h = 300, math.min(rh, 380)
	local x = arrowX - 150

	local closePanel = false
	if not octoinv.mainPnl:IsVisible() then
		-- hacky thing against dframe not being able to receive input
		octoinv.show(true, false)
		closePanel = true
	end

	local pnl = octoinv.mainPnl:Add 'DFrame'
	pnl:SetSize(w, h - 30)
	pnl:DockPadding(0, 24, 0, 0)
	if octoinv.guiCurInv.posCache[ent] and octoinv.guiCurInv.posCache[ent][contID] then
		local x, y = unpack(octoinv.guiCurInv.posCache[ent][contID][1])
		x = math.Clamp(x, 0, ScrW() - 50)
		y = math.Clamp(y, 0, ScrH() - 50)
		pnl:SetPos(x, y)
		if octoinv.guiCurInv.posCache[ent][contID][2][2] % 68 ~= 3 then -- if it isn't a size set automatically
			pnl:SetSize(unpack(octoinv.guiCurInv.posCache[ent][contID][2]))
		end

		pnl:InvalidateLayout()
		timer.Simple(0.2, function() if not IsValid(pnl) then return end pnl:InvalidateChildren(true) end)
	else
		pnl:SetPos(x, ScrH() - h - 50)
	end

	pnl:SetAlpha(0)
	showWindow(pnl)
	function pnl.btnClose:DoClick()
		hideWindow(pnl)
	end

	pnl:SetTitle(inv.name)
	pnl:SetSizable(true)
	pnl:SetMinWidth(300)
	pnl:SetMinHeight(140)
	function pnl:PerformLayout()
		self.btnClose:SetPos( self:GetWide() - 28, 0 )
		self.btnClose:SetSize( 24, 24 )
		self.lblTitle:SetPos( 8, 2 )
		self.lblTitle:SetSize( self:GetWide() - 56, 20 )
	end
	pnl.btnMaxim:Remove()
	pnl.btnMinim:Remove()
	function pnl.OnRemove(self)
		if not octoinv.guiCurInv.posCache[ent] then octoinv.guiCurInv.posCache[ent] = {} end
		octoinv.guiCurInv.posCache[ent][contID] = { {self:GetPos()}, {self:GetSize()} }
	end

	pnl.invOwner = ent
	pnl.contID = contID

	local canvas = vgui.Create('DScrollPanel', pnl)
	-- canvas:SetSize(w, h - 65)
	canvas:Dock(FILL)
	canvas:DockMargin(5, 6, 5, 6)
	canvas.invPnl = pnl
	canvas.Paint = paints.canvas
	canvas.PaintOver = paints.canvasOver
	canvas:Receiver('octoinv_items', function(self, pnls, drop, menuID, x, y)
		if drop then
			local pnl = pnls[1]
			if not pnl or pnl:GetParent():GetParent():GetParent() == self or not pnl.contID then return end -- omg

			local owner, contID2 = pnl.invOwner, pnl.contID
			if pnl.itemID then
				local function move(amount)
					netstream.Start('octoinv.move', {[owner] = {[contID2] = {[pnl.itemID] = amount}}}, ent, contID)
				end

				if not menuID or menuID == 1 then
					move(pnl.amount or 1)
				elseif menuID == 2 then
					local itemName = octoinv.getItemData(octoinv.invs[owner][contID2].items[pnl.itemID], 'name')
					local contName = inv.name
					Derma_StringRequest(L.move_items, L.what_hint  .. itemName .. L.where2_octoinv .. contName .. L.amount_octoinv, pnl.amount, function(s)
						local amount = tonumber(s)
						if amount and amount > 0 then move(amount) end
					end, nil, L.move, L.cancel)
				end
			elseif pnl.items then
				local items = {}
				for i, item in pairs(pnl.items) do
					items[i] = item.amount or 1
				end
				netstream.Start('octoinv.move', {[owner] = {[contID2] = items}}, ent, contID)
			else
				local items = {}
				for i, item in ipairs(octoinv.invs[owner][contID2].items) do
					items[i] = item.amount or 1
				end
				netstream.Start('octoinv.move', {[owner] = {[contID2] = items}}, ent, contID)
			end
		end
	end, {
		L.move_all,
		L.move_cost,
	})

	canvas:Receiver('octoinv_give', function(self, pnls, drop, menuID, x, y)
		local item = drop and pnls[1] and pnls[1].item
		if not item then return end
		if item.icon then item.icon = isstring(item.icon) and item.icon or (item.icon:GetName() .. '.png') end
		netstream.Start('octoinv.create', ent, contID, item)
	end)

	local list = canvas:Add 'DIconLayout'
	list:Dock(FILL)
	list:DockMargin(5, 0, 0, 0)
	list:SetSpaceX(4)
	list:SetSpaceY(4)

	local bar = pnl:Add 'DPanel'
	bar:Dock(TOP)
	bar:SetTall(35)
	bar:DockPadding(5,5,5,5)
	bar.Paint = paints.invPnlBar

	local pr = bar:Add 'DProgress'
	pr:Dock(FILL)
	pr:SetFraction(0)

	local prl = pr:Add 'DLabel'
	prl:Dock(FILL)
	prl:SetContentAlignment(5)
	prl:SetText('')

	local moveAll, searchBut, toggleBut, craftBut
	pnl.Refresh = function(self, search)
		list:Clear()
		if IsValid(moveAll) then moveAll:Remove() end
		if IsValid(searchBut) then searchBut:Remove() end
		if IsValid(toggleBut) then toggleBut:Remove() end
		if IsValid(craftBut) then craftBut:Remove() end

		local inv = octoinv.invs[ent][contID]
		local items = inv.items
		local free = octoinv.calcFreeSpace(inv)

		if search then
			search = utf8.lower(search)
			items = table.Copy(items)
			for k, v in pairs(items) do
				if not utf8.lower(octoinv.getItemData(v, 'name')):find(search) then
					items[k] = nil
				end
			end
		end

		prl:SetText(string.format(L.octoinv_free, free))
		local from, to, start = pr:GetFraction(), 1 - free / inv.volume, CurTime()
		local delta = to - from
		pr.Think = function(self)
			local newVal = from + delta * octolib.tween.easing.outQuad(math.min(CurTime() - start, 0.5) / 0.5, 0, 1, 1)
			self:SetFraction(newVal)
			if newVal == to then self.Think = function() end end
		end

		-- move all and search buts
		if free ~= inv.volume then
			moveAll = bar:Add 'DButton'
			moveAll:Dock(LEFT)
			moveAll:SetWide(25)
			moveAll:SetText('')
			moveAll:Droppable('octoinv_items')
			moveAll.items = items
			moveAll.invOwner = ent
			moveAll.contID = contID
			moveAll.icon = icons.moveAll
			moveAll:SetToolTip(L.move_all)
			moveAll.Paint = paints.actBut

			searchBut = bar:Add 'DButton'
			searchBut:Dock(LEFT)
			searchBut:SetWide(25)
			searchBut:SetText('')
			searchBut.icon = icons.search
			searchBut.Paint = paints.actBut
			searchBut.DoClick = function(self)
				Derma_StringRequest(L.search_container, L.write_part_name, '', function(q)
					pnl:Refresh(q ~= '' and q)
				end)
			end
			searchBut:SetToolTip(L.search_or_filter)
		end

		-- toggle but
		if inv.prod then
			-- place here but
			toggleBut = bar:Add 'DButton'
			toggleBut:Dock(RIGHT)
			toggleBut:SetWide(25)
			toggleBut:SetText('')
			toggleBut.icon = inv.on and icons.on or icons.off
			toggleBut.Paint = paints.actBut
			toggleBut.DoClick = function(self)
				netstream.Start('octoinv.toggle', ent, contID)
			end
			toggleBut:SetToolTip(L.enable_or_disable)
		end

		-- craft but
		if inv.craft then
			craftBut = bar:Add 'DButton'
			craftBut:Dock(RIGHT)
			craftBut:SetWide(25)
			craftBut:SetText('')
			craftBut.icon = icons.craft
			craftBut.invOwner = ent
			craftBut.contID = contID
			craftBut.Paint = paints.actBut
			craftBut.DoClick = function(self)
				pendingCraftBut = self
				self.icon = icons.wait
				netstream.Start('octoinv.craftlist', ent, contID)
			end
			craftBut:SetToolTip(L.craft)
		end

		if table.Count(items) > 0 then
			local i = 0
			for itemID, item in pairs(items) do
				local itemPnl = octoinv.createItemPanel(list, item)
				itemPnl.itemID = itemID
				itemPnl.invOwner = pnl.invOwner
				itemPnl.contID = pnl.contID
				itemPnl:Droppable('octoinv_items')
				itemPnl.DoRightClick = function(self)
					local m = DermaMenu()

					local s, o = m:AddSubMenu(L.drop)
					o:SetIcon('octoteam/icons/box3_drop.png')
					o.m_Image:SetSize(16,16)
					local function drop(amount)
						netstream.Start('octoinv.drop', ent, contID, itemID, amount)
					end

					local o = s:AddOption(L.all, function() drop(octoinv.getItemData(item, 'amount')) end)
					local o = s:AddOption(L.cost, function()
						local itemName = octoinv.getItemData(octoinv.invs[ent][contID].items[itemID], 'name')
						local contName = octoinv.invs[ent][contID].name
						Derma_StringRequest(L.drop_items, L.what_hint .. itemName .. L.where_octoinv .. contName .. L.amount_octoinv, octoinv.getItemData(item, 'amount'), function(s)
							local amount = tonumber(s)
							if amount and amount > 0 then drop(amount) end
						end, nil, L.drop, L.cancel)
					end)

					if octoinv.getItemData(item, 'canuse') then
						local o = m:AddOption(L.octoinv_use, function()
							octoinv.pendingUse = { ent, contID, itemID }
							netstream.Start('octoinv.uselist', ent, contID, itemID)
						end)
						o:SetIcon('octoteam/icons/hand_point.png')
						o.m_Image:SetSize(16,16)
					end

					m:Open()
				end
				if octoinv.getItemData(item, 'canuse') then
					itemPnl.DoClick = function(self)
						octoinv.pendingUse = { ent, contID, itemID }
						netstream.Start('octoinv.uselist', ent, contID, itemID)
					end
				end

				i = i + 1
			end

			-- if it isn't a size set automatically, adjust
			if octoinv.guiCurInv.posCache[ent] and octoinv.guiCurInv.posCache[ent][contID] and octoinv.guiCurInv.posCache[ent][contID][2][2] % 68 == 3 then
				local rh = 101 + 68 * math.ceil(math.max(i / 4), 1)
				pnl:SetSize(300, math.min(rh, 380) - 30)
			end

			list:InvalidateLayout(true)
			timer.Simple(0.2, function() if not IsValid(list) then return end list:InvalidateChildren(true) end)
		else
			local label = list:Add 'DLabel'
			label:SetSize(w - 15, 64)
			label:SetFont('octoinv.item')
			label:SetContentAlignment(5)
			label:SetTextColor(cols.white150)
			label:SetText(search and L.not_found or table.Random({
				L.octoinv_empty,
				L.octoinv_empty2,
				L.octoinv_empty3,
			}))
		end
	end
	pnl:Refresh()

	if closePanel then octoinv.show(false) end

	octoinv.guiCurInv.pnls[pnl] = true
	return pnl

end

local defaultData = {
	amount = 1,
	volume = 0,
	mass = 0,
	name = L.unknown,
	desc = L.not_desc,
	icon = 'icon16/exclamation.png',
}

function octoinv.getItemData(item, field)

	local data = octoinv.items[item.class]
	return item[field] or (data and data[field]) or defaultData[field]

end


function octoinv.getReplacementTable(item, class)

	local isTable = istable(item)
	if not isTable and not class then return {} end
	if not class and not item.class then return {} end

	local out = table.Copy(octoinv.items[isTable and item.class or class])
	if isTable then
		for k, v in pairs(item) do
			out[k] = v
		end
	end

	return out

end

function octoinv.getItemUpperMO(item)

	if item._mo then return item._mo end

	local status = octoinv.getItemData(item, 'status')
	if status then
		item._mo = markup.Parse(('<font=octoinv.small><color=255,255,255>%s</color></font>'):format(status))
		return item._mo
	end

	local leftMaxField = octoinv.getItemData(item, 'leftMaxField')
	local leftMax = octoinv.getItemData(item, 'leftMax') or leftMaxField and octoinv.getItemData(item, leftMaxField)
	if not leftMax then return end

	-- leftField is the key of table field to display "remaining" value from
	local left = octoinv.getItemData(item, 'leftVal') or octoinv.getItemData(item, octoinv.getItemData(item, 'leftField')) or 0
	local gbMul = octolib.math.remap(left / leftMax, 0, 0.4, 0.3, 1, true)
	local col = Color(255,255 * gbMul,255 * gbMul)
	item._mo = markup.Parse(('<font=octoinv.small><color=%d,%d,%d>%s</color><color=135,135,135>/%s</color></font>'):format(col.r, col.g, col.b, left, leftMax))
	return item._mo

end

function octoinv.calcFreeSpace(inv)

	local space = inv.volume
	for id, item in pairs(inv.items) do
		space = space - octoinv.getItemData(item, 'volume') * octoinv.getItemData(item, 'amount')
	end

	return math.Round(space, 4)

end

function octoinv.putItems(tgt, contID)

	netstream.Start('octoinv.move', octoinv.queue, tgt, contID)

end

function octoinv.notifyChange()

	if IsValid(octoinv.mainPnl) and octoinv.mainPnl:IsVisible() then return end
	notifyTimeout = CurTime() + 5

end

local notifyIcon = Material('octoteam/icons/arrow_down.png')
hook.Add('HUDPaint', 'octoinv.notify', function()

	if hook.Run('HUDShouldDraw', 'octoinv.notify') == false then return end
	notifyState = math.Approach(notifyState, CurTime() >= notifyTimeout and 0 or 1, FrameTime() * 3)
	if notifyState > 0 then
		local st = octolib.tween.easing.outQuad(notifyState, 0, 1, 1)
		local x, y = math.floor((ScrW() - 130) / 2), math.floor(ScrH() - 50 * st)
		draw.SimpleText(L.something_in_inventory, 'octoinv.item-sh', x + 5, y, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(L.something_in_inventory, 'octoinv.item', x + 5, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(L.press_q, 'octoinv.footer-sh', x + 5, y + 18, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(L.press_q, 'octoinv.footer', x + 5, y + 18, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		surface.SetDrawColor(255,255,255, 255)
		surface.SetMaterial(notifyIcon)
		surface.DrawTexturedRect(x - 37, y, 32, 32)
	end

end)

hook.Add('ShutDown', 'octoinv.save', function()

	local positions = table.Copy(octoinv.guiCurInv.posCache[LocalPlayer():EntIndex()] or { })

	for containerPanel, _ in pairs(octoinv.guiCurInv.pnls) do
		if IsValid(containerPanel) then
			positions[containerPanel.contID] = {
				{ containerPanel:GetPos() },
				{ containerPanel:GetSize() }
			}
		end
	end

	octolib.vars.set('octoinv.positions', positions, true)

end)

netstream.Hook('octoinv.sync', function(owner, id, cont)

	local open = false
	if owner then
		if (not octoinv.invs[owner] and owner ~= LocalPlayer():EntIndex()) or (id == '_hand' and cont.items[1]) then
			octoinv.notifyChange()
		end

		octoinv.invs[owner] = octoinv.invs[owner] or {}
		local ownerEnt = Entity(owner)
		if ownerEnt:IsPlayer() and ownerEnt ~= LocalPlayer() then cont.name = ownerEnt:Name() .. ' - ' .. cont.name end
		octoinv.invs[owner][id] = cont
		if isstring(cont.icon) then cont.icon = Material(cont.icon) end
	end

	octoinv.refreshInv(owner, id, open)
	octoinv.refresh()

end)

netstream.Hook('octoinv.forget', function(owner, id)

	if not octoinv.invs[owner] then return end
	octoinv.invs[owner][id] = nil
	if table.Count(octoinv.invs[owner]) < 1 then
		octoinv.invs[owner] = nil
	end

	octoinv.refresh()
	octoinv.refreshInv(owner, id)

end)

netstream.Hook('octoinv.sendRegistered', function(data)

	octoinv.items = data.items
	octoinv.shopCats = data.shopCats
	octoinv.shopItems = data.shopItems
	octoinv.crafts = data.crafts
	octoinv.prods = data.prods

	for itemID, item in pairs(data.market) do
		octoinv.registerMarketItem(itemID, item)
	end

	for itemID, item in pairs(octoinv.items) do
		item.icon = Material(item.icon)
	end

end)

netstream.Hook('octoinv.craftlist', function(data)

	local pnl = pendingCraftBut
	if not IsValid(pnl) then return end

	local m = DermaMenu()

	local added = 0
	for craftID, craft in SortedPairs(data) do
		local item = octoinv.items[craft.class]
		local icon = craft.icon or (item and item.icon and (item.icon:GetName() .. '.png')) or 'octoteam/icons/error.png'
		local o = m:AddOption(craft.name or item.name, function()
			netstream.Start('octoinv.craft', pnl.invOwner, pnl.contID, craftID)
		end)
		o:SetIcon(icon)
		o.m_Image:SetSize(16,16)
		o:InvalidateLayout()
		o:SetToolTip(craft.desc or (item and interpDesc(item)) or L.not_desc)

		added = added + 1
	end

	if added < 1 then
		local o = m:AddOption(L.nothing_do_this)
		o:SetIcon('octoteam/icons/emote_question.png')
		o.m_Image:SetSize(16,16)
		o:InvalidateLayout()
	end

	m:Open(pendingCraftBut:LocalToScreen(26, 0))
	pendingCraftBut.icon = icons.craft

end)

netstream.Hook('octoinv.uselist', function(data)

	local cache = octoinv.pendingUse
	if not cache[1] then return end

	local m = DermaMenu()

	local added = 0
	if data then
		for i, useData in pairs(data) do
			if useData[2] then
				local o = m:AddOption(useData[2], function()
					netstream.Start('octoinv.use', cache[1], cache[2], cache[3], useData[1])
				end)
				o:SetIcon(useData[3] or 'octoteam/icons/error.png')
				o.m_Image:SetSize(16,16)
				o:InvalidateLayout()
			else
				local o = m:AddOption(useData[3] or L.action_unavailable)
				o:SetIcon('icon16/error.png')
				o:SetDisabled(true)
				o:SetAlpha(100)
			end

			added = added + 1
		end
	end

	if added < 1 then
		local o = m:AddOption(L.nothing_do_this)
		o:SetIcon('octoteam/icons/emote_question.png')
		o.m_Image:SetSize(16,16)
		o:InvalidateLayout()
	end

	m:Open()

end)

local smWeps = {
	weapon_physgun = true,
	gmod_tool = true,
	gmod_camera = true,
	octo_camera = true,
}
local noInvWeps = {
	dbg_dog = true,
}

concommand.Add('+menu', function()

	if hook.Run('octolib.shouldOpenMenu') == false then return end

	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) and smWeps[wep:GetClass()] then
		hook.Call( "OnSpawnMenuOpen", GAMEMODE )
	else
		octoinv.show(true)

		if CurTime() - lastOpen < 0.3 then hangOpen = true end
		lastOpen = CurTime()

		notifyTimeout = CurTime()
		octoinv.refresh()
	end

end)

concommand.Add('-menu', function()

	if not input.IsKeyTrapping() then hook.Call( "OnSpawnMenuClose", GAMEMODE ) end

	local wep = LocalPlayer():GetActiveWeapon()
	if not IsValid(wep) or not smWeps[wep:GetClass()] then
		if hangOpen then hangOpen = false return end
		octoinv.show(false)
	end

end)

end)

local meta = FindMetaTable 'Player'
function meta:HasItem(class)
	local index = self:EntIndex()
	local inv = octoinv.invs and octoinv.invs[index]
	if not inv then return false end
	for _, v in pairs(inv) do
		for _, item in ipairs(v.items) do
			if item.class == class then
				return true
			end
		end
	end
	return false
end
