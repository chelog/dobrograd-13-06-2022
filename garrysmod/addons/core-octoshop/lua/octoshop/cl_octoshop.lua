octoshop.items = {}

surface.CreateFont('octoshop.xtitle', {
	font = 'Calibri',
	extended = true,
	size = 29,
	weight = 350,
})

surface.CreateFont('octoshop.title', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
})

surface.CreateFont('octoshop.name', {
	font = 'Arial Bold',
	extended = true,
	size = 17,
	weight = 350,
})

surface.CreateFont('octoshop.xprice', {
	font = 'Calibri',
	extended = true,
	size = 32,
	weight = 500,
})

surface.CreateFont('octoshop.price', {
	font = 'Arial',
	extended = true,
	size = 14,
	weight = 350,
})

local function ease( t, b, c, d )

	t = t / d;
	return -c * t * (t - 2) + b

end

--
-- PANEL EXTENSION
--

surface.CreateFont('dbg-util.tag', {
	font = 'Calibri',
	extended = true,
	size = 18,
	weight = 350,
})

surface.CreateFont('dbg-util.tag-sh', {
	font = 'Calibri',
	extended = true,
	size = 40,
	weight = 350,
	blursize = 10,
})

local meta = FindMetaTable 'Panel'

local function paintHint(self, w, h)

	surface.DisableClipping(true)

	local al = self.anim
	surface.SetFont('dbg-util.tag')
	local tw, th = surface.GetTextSize(self.hint)
	local x, y = w / 2, -16

	self.shText = self.shText or ('|'):rep(math.floor((tw+30)/15))
	draw.SimpleText(self.shText, 'dbg-util.tag-sh', x, y, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	draw.RoundedBox(4, (w-tw-14) / 2, y - 10, tw + 14, 22, Color(170,119,102, al*255))
	draw.SimpleText(self.hint, 'dbg-util.tag', x, y, Color(255,255,255, al*255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText('u', 'marlett', x, y + 6, Color(170,119,102, al*255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

	surface.DisableClipping(false)

end

local function thinkHint(self)

	self.anim = math.Approach( self.anim, self.Hovered and 1 or 0, FrameTime() / 0.1 )

end

function meta:AddOctoHint(text)

	self.realPaint = self.realPaint or self.Paint or function() end
	self.realThink = self.realThink or self.Think or function() end
	self.realOnCursorEntered = self.realOnCursorEntered or self.OnCursorEntered or function() end
	self.realOnCursorExited = self.realOnCursorExited or self.OnCursorExited or function() end

	self.anim = 0
	self.hint = text or 'Hint text'

	self.Paint = function(self, w, h)
		if self.anim > 0 then paintHint(self, w, h) end
		self:realPaint(w, h)
	end

	self.Think = function(self)
		self:realThink()
		thinkHint(self)
	end

	self.OnCursorEntered = function(self)
		self:realOnCursorEntered()
		self:SetDrawOnTop(true)
	end
	self.OnCursorExited = function(self)
		self:realOnCursorExited()
		self:SetDrawOnTop(false)
	end

end

--
-- MENU CODE
--

local icons = {
	active = Material(octolib.icons.silk16('tick')),
	equipped = Material(octolib.icons.silk16('lightbulb')),
	unequipped = Material(octolib.icons.silk16('lightbulb_off')),
	expire = Material(octolib.icons.silk16('hourglass')),
}

local function paintIcon(self, w, h)

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(self.icon)
	surface.DrawTexturedRect(w/2 - 8, h/2 - 8, 16, 16)

end

local function paintInvItem(self, w, h)

	local strokeCol = self.Hovered and self.col or Color(220,220,220)
	draw.RoundedBox(4, 0, 0, w, h, strokeCol)

	local bgCol = self.Depressed and Color(238,238,238) or color_white
	draw.RoundedBox(4, 1, 1, w-2, h-2, bgCol)

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(self.icon)
	surface.DrawTexturedRect(w/2 - 32, 26, 64, 64)

	surface.SetFont('octoshop.name')
	local tw, th = surface.GetTextSize(self.name)
	local x = 0
	if tw > w-16 and self.Hovered then
		x = (-math.cos((CurTime() - self.animStart) * 1.5) + 1) / 2 * (w-16 - tw)
	end
	draw.DrawText(self.name, 'octoshop.name', x + 8, h-23, Color(80,80,80), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.RoundedBox(0, w-1, h-25, 1, 20, strokeCol)
	draw.RoundedBox(0, 0, h-25, 1, 20, strokeCol)
	draw.RoundedBox(0, w-2, h-25, 1, 20, bgCol)
	draw.RoundedBox(0, 1, h-25, 1, 20, bgCol)

end

local function paintShopItem(self, w, h)

	local strokeCol = self.Hovered and self.col or Color(220,220,220)
	draw.RoundedBox(4, 0, 0, w, h, strokeCol)

	local bgCol = self.Depressed and Color(238,238,238) or color_white
	draw.RoundedBox(4, 1, 1, w-2, h-2, bgCol)
	draw.RoundedBox(0, 1, h-51, w-2, 1, Color(220,220,220))

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(self.icon)
	surface.DrawTexturedRect(w/2 - 32, 26, 64, 64)

	draw.DrawText(octoshop.formatMoney(self.price), 'octoshop.price', w-8, h-21, Color(30,30,30), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	surface.SetFont('octoshop.name')
	local tw, th = surface.GetTextSize(self.name)
	local x = 0
	if tw > w-16 and self.Hovered then
		x = (-math.cos((CurTime() - self.animStart) * 1.5) + 1) / 2 * (w-16 - tw)
	end
	draw.DrawText(self.name, 'octoshop.name', x + 8, h-45, Color(80,80,80), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.RoundedBox(0, w-1, h-50, 1, 45, strokeCol)
	draw.RoundedBox(0, 0, h-50, 1, 45, strokeCol)
	draw.RoundedBox(0, w-2, h-50, 1, 45, bgCol)
	draw.RoundedBox(0, 1, h-50, 1, 45, bgCol)

end

local function createPanel()

if IsValid(octoshop.pnl) then octoshop.pnl:Remove() end
local p = vgui.Create 'DPropertySheet'
octoshop.pnl = p

p:SetSize(400,600)
p:Center()
p:SetSkin('Default')

local moneyMat = Material(octolib.icons.silk16('coins'))
p.balance = p:Add 'DLabel'
p.balance:SetSize(24,20)
p.balance:SetText(L.loading)
p.balance:SetTextColor(Color(255,255,255))
p.balance:SizeToContentsX(0)
p.balance:AlignRight(85)
p.balance:AlignTop(1)
p.balance.Paint = function(self,w,h)
	surface.DisableClipping(true)
	draw.RoundedBoxEx(4, -25,0, w+45,h, Color(59,59,59), true, false, false, false)
	draw.RoundedBoxEx(4, -24,1, w+43,h, Color(156,160,164), true, false, false, false)

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(moneyMat)
	surface.DrawTexturedRect(-20,3,16,16)

	surface.DisableClipping(false)
end

p.rf = p:Add 'DButton'
p.rf:SetSize(55,20)
p.rf:SetText(L.menu)
p.rf:AlignRight(24)
p.rf:AlignTop(1)
p.rf.DoClick = function(self)
	local m = DermaMenu()

	m:AddOption(L.top_up_balance, function()
		if isfunction(octoshop.openTopup) then
			octoshop.openTopup(self, p)
		else
			gui.OpenURL('https://octothorp.team/shop/chips?steamid=' .. LocalPlayer():SteamID())
		end
	end):SetIcon('icon16/money_add.png')

	m:AddOption(L.apply_coupon, function()
		Derma_StringRequest(L.apply_coupon, L.write_coupon, '', function(s)
			net.Start('octoshop.useCoupon')
				net.WriteString(s)
			net.SendToServer()
		end, function() end, L.apply, L.cancel)
	end):SetIcon('icon16/tag_green.png')

	m:AddOption(L.refresh_shop, function()
		net.Start('octoshop.rInventory') net.SendToServer()
	end):SetIcon('icon16/arrow_rotate_clockwise.png')

	if octoshop.checkOwner(LocalPlayer()) then
		m:AddSpacer()

		m:AddOption(L.create_coupon, function()
			Derma_StringRequest(L.create_coupon, L.create_hint, '', function(s)
				RunConsoleCommand('octoshop_coupon_create', 'balance', s)
			end, function() end, L.create, L.cancel)
		end):SetIcon('icon16/tag_blue_add.png')
	end

	m:Open()
end

p.cl = p:Add 'DButton'
p.cl:SetSize(24,20)
p.cl:AlignRight(4)
p.cl:AlignTop(1)
p.cl:SetText('')
p.cl:SetImage('icon16/cross.png')
function p.cl:DoClick()
	p:Hide()
end

local tShop = vgui.Create 'DPanel'
tShop:Dock(FILL)
tShop:DockMargin(8, 0, 8, 8)
p:AddSheet(L.shop, tShop, octolib.icons.silk16('cart'))
p.shop = tShop

local tInv = vgui.Create 'DPanel'
tInv:Dock(FILL)
tInv:DockMargin(8, 0, 8, 8)
p:AddSheet(L.inventory, tInv, octolib.icons.silk16('box_front_open'))
p.inv = tInv

function p:Show(closeCallback)

	net.Start('octoshop.rInventory') net.SendToServer()

	if isfunction(closeCallback) then self.closeCallback = closeCallback end
	self:SetVisible(true)
	self:MakePopup()

end

function p:Hide()

	self:SetVisible(false)
	if isfunction(self.closeCallback) then
		self:closeCallback()
		self.closeCallback = nil
	end

end

local textEmpty = L.textEmpty

local catCol = Color(0,0,0, 80)
local function paintCategory(self, w, h)

	draw.RoundedBox(0, 0, 0, w, 30, catCol)

end

function p:UpdateInventory(data)

	local t = p.inv
	t:Clear()

	if not istable(data) or #data < 1 then
		local lbl = t:Add 'DLabel'
		lbl:Dock(FILL)
		lbl:SetContentAlignment(5)
		lbl:SetTextColor(Color(120,120,120))
		lbl:SetFont('octoshop.title')
		lbl:SetText(textEmpty[math.random(#textEmpty)])
	else
		local sp = t:Add 'DScrollPanel'
		sp:Dock(FILL)

		local cats = {}
		for i, item in ipairs(data) do
			local class = octoshop.getClassTable(item.class)

			local cat = octoshop.getClassTable(item.class).cat or L.other
			local l = cats[cat]
			if not l then
				local c = sp:Add 'DCollapsibleCategory'
				c:SetWide(400)
				c:Dock(TOP)
				c:SetLabel(cat)
				c:SetExpanded(true)
				c.Header:SetFont('octoshop.title')
				c.Header:SetTall(30)
				c.Paint = paintCategory

				l = vgui.Create 'DIconLayout'
				l:DockMargin(5,5,5,5)
				l:DockPadding(0,0,0,10)
				l:SetSpaceX(5)
				l:SetSpaceY(5)

				c:SetContents(l)
				local oldLayout = c.PerformLayout
				function c:PerformLayout()
					if not self.manualLayout then
						for k, v in pairs(cats) do
							v.manualLayout = true
							v:InvalidateLayout()
						end
					else
						v.manualLayout = nil
					end

					oldLayout(self)
					l:InvalidateLayout(true)
					for i, v in ipairs(l:GetChildren()) do
						v:InvalidateLayout()
					end
				end

				cats[cat] = l
			end

			local ip = l:Add 'DButton'
			ip:SetSize(116, 135)
			ip:SetText('')
			ip.icon = item.data and item.data.icon or class.icon
			ip.name = item.data and item.data.name or class.name
			ip.col = class.color
			ip.Paint = paintInvItem
			function ip:PerformLayout()
				self:SetWide((sp.pnlCanvas:GetWide() - 20)/3)
			end
			function ip:OnCursorEntered()
				self.animStart = CurTime()
			end
			function ip:DoClick()
				local m = DermaMenu()
				if item.canUse then
					m:AddOption(L.active, function()
						net.Start('octoshop.action' )
							net.WriteUInt(item.id, 32)
							net.WriteString('use')
						net.SendToServer()
					end):SetIcon(octolib.icons.silk16('box_open'))
				end
				if item.canEquip then
					m:AddOption(L.equip, function()
						net.Start('octoshop.action' )
							net.WriteUInt(item.id, 32)
							net.WriteString('equip')
						net.SendToServer()
					end):SetIcon('icon16/lightbulb.png')
				end
				if item.canUnequip then
					m:AddOption(L.unequip, function()
						net.Start('octoshop.action' )
							net.WriteUInt(item.id, 32)
							net.WriteString('unequip')
						net.SendToServer()
					end):SetIcon('icon16/lightbulb_off.png')
				end
				if item.canTrade then
					local plys = player.GetAll()
					table.sort(plys, function(a, b)
						return a:Name() < b:Name()
					end)

					local sm, pm = m:AddSubMenu(L.write_give)
					pm:SetIcon(octolib.icons.silk16('arrow_right'))

					for i, ply in ipairs(plys) do
						if ply ~= LocalPlayer() then
							sm:AddOption(ply:Name(), function()
								net.Start('octoshop.action' )
									net.WriteUInt(item.id, 32)
									net.WriteString('trade')
									net.WriteEntity(ply)
								net.SendToServer()
							end)
						end
					end
				end
				if item.canSell then
					m:AddSpacer()
					m:AddOption(L.sell, function()
						net.Start('octoshop.action' )
							net.WriteUInt(item.id, 32)
							net.WriteString('sell')
						net.SendToServer()
					end):SetIcon('icon16/money_delete.png')
				end
				m:Open()
			end

			local iconNum = 0
			if item.active then
				local sip = vgui.Create 'DPanel'
				sip:SetParent(ip)
				sip:SetSize(20,20)
				sip:AlignTop(4)
				sip:AlignRight(20 * iconNum)
				sip.icon = icons.active
				sip.Paint = paintIcon
				sip:AddOctoHint(L.actived)

				iconNum = iconNum + 1
			end

			if item.canEquip and not item.equipped then
				local sip = vgui.Create 'DPanel'
				sip:SetParent(ip)
				sip:SetSize(20,20)
				sip:AlignTop(4)
				sip:AlignRight(20 * iconNum)
				sip.icon = icons.unequipped
				sip.Paint = paintIcon
				sip:AddOctoHint(L.not_using)

				iconNum = iconNum + 1
			elseif item.equipped then
				local sip = vgui.Create 'DPanel'
				sip:SetParent(ip)
				sip:SetSize(20,20)
				sip:AlignTop(4)
				sip:AlignRight(20 * iconNum)
				sip.icon = icons.equipped
				sip.Paint = paintIcon
				sip:AddOctoHint(L.using)

				iconNum = iconNum + 1
			end

			if item.expire then
				local sip = vgui.Create 'DPanel'
				sip:SetParent(ip)
				sip:SetSize(20,20)
				sip:AlignTop(4)
				sip:AlignRight(20 * iconNum)
				sip.icon = icons.expire
				sip.Paint = paintIcon
				sip:AddOctoHint(os.date(L.expire, item.expire))

				iconNum = iconNum + 1
			end
		end
	end

end

function p:UpdateShop()

	local t = p.shop
	t:Clear()

	local sp = t:Add 'DScrollPanel'
	sp:Dock(FILL)

	local data = {}
	for class, item in pairs(octoshop.items) do
		local i = table.Copy(item)
		i.class = class
		table.insert(data, i)
	end

	table.sort(data, function(a, b)
		if a.order and b.order and a.order ~= b.order then
			return a.order < b.order
		else
			return a.price < b.price
		end
	end)

	local cats = {}
	for i, item in ipairs(data) do
		if not item.hidden then
			local cat = octoshop.getClassTable(item.class).cat or L.other
			local l = cats[cat]
			if not l then
				local c = sp:Add 'DCollapsibleCategory'
				c:SetWide(400)
				c:Dock(TOP)
				c:SetLabel(cat)
				c:SetExpanded(true)
				c.Header:SetFont('octoshop.title')
				c.Header:SetTall(30)
				c.Paint = paintCategory

				l = vgui.Create 'DIconLayout'
				l:DockMargin(5,5,5,5)
				l:DockPadding(0,0,0,10)
				l:SetSpaceX(5)
				l:SetSpaceY(5)

				c:SetContents(l)
				local oldLayout = c.PerformLayout
				function c:PerformLayout()
					if not self.manualLayout then
						for k, v in pairs(cats) do
							v.manualLayout = true
							v:InvalidateLayout()
						end
					else
						v.manualLayout = nil
					end

					oldLayout(self)
					l:InvalidateLayout(true)
					for i, v in ipairs(l:GetChildren()) do
						v:InvalidateLayout()
					end
				end

				cats[cat] = l
			end

			local ip = l:Add 'DButton'
			ip:SetSize(116, 170)
			ip:SetText('')
			ip.icon = item.icon
			ip.name = item.name
			ip.col = item.color
			ip.price = item.price
			ip.Paint = paintShopItem
			function ip:PerformLayout()
				self:SetWide((sp.pnlCanvas:GetWide() - 20)/3)
			end
			function ip:OnCursorEntered()
				self.animStart = CurTime()
			end
			function ip:DoClick()
				octoshop.openShopItem(item.class)
			end
		end
	end

end

p:Hide()
net.Start('octoshop.rShop') net.SendToServer()

hook.Remove('Think', 'octoshop.init')
end

function octoshop.init()

	hook.Add('Think', 'octoshop.init', createPanel)
	octoshop.msg('Initialized.')

end

net.Receive('octoshop.rBalance', function(len, ply)

	octoshop.balance = net.ReadUInt(32) or 0
	octoshop.pnl.balance:SetText(octoshop.formatMoney(octoshop.balance))
	octoshop.pnl.balance:SizeToContentsX(0)
	octoshop.pnl.balance:AlignRight(85)

end)

net.Receive('octoshop.rInventory', function(len)

	local data = net.ReadTable()
	for i, item in ipairs(data) do
		if item.data and item.data.icon then
			item.data.icon = Material(item.data.icon)
		end
	end

	octoshop.pnl:UpdateInventory(data)

end)

function octoshop.getClassTable(class)

	return octoshop.items[class] or {
		name = L.what_it,
		cat = L.octoshop_break,
		desc = L.octoshop_break_hint,
		price = 0,
		order = 999,
		attributes = {},
		icon = Material('icon16/help.png', ''),
		color = Color(102,170,170),
		canBuy = false,
	}

end

local colors = CFG.skinColors
function octoshop.openShopItem(class)

	local classT = octoshop.getClassTable(class)

	local f = vgui.Create 'DButton'
	f:SetSize(ScrW(), ScrH())
	f:MakePopup()
	f:SetText('')
	function f:Paint(w, h)
		draw.RoundedBox(0, -1, -1, w+2, h+2, Color(0,0,0, 180))
	end
	function f:DoClick()
		self:Remove()
	end

	local p = f:Add 'DPanel'
	p:DockPadding(10,10,10,10)
	p:SetSize(500, 500)
	p:Center()
	p:SetSkin('Default')

	local p_h = p:Add 'DPanel'
	p_h:Dock(TOP)
	p_h:SetTall(120)
	function p_h:Paint(w, h)
		surface.SetDrawColor(255,255,255, 255)
		surface.SetMaterial(classT.icon)
		surface.DrawTexturedRect(40, 28, 64, 64)

		draw.SimpleText(classT.name, 'octoshop.xtitle', 150, 30, Color(30,30,30), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	local txt = classT.canBuy and L.buy_for .. octoshop.formatMoney(classT.price) or L.unavailable
	surface.SetFont('octoshop.xprice')
	local tw, th = surface.GetTextSize(txt)

	p_h.b = p_h:Add 'DButton'
	p_h.b:SetText('')
	p_h.b:SetSize(tw + 20, 40)
	p_h.b:SetPos(150, 55)
	function p_h.b:Paint(w, h)
		if classT.canBuy then
			draw.RoundedBox(4, 0, 0, w, h, colors.g)
			if self.Hovered then draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255, 20)) end
			draw.SimpleText(txt, 'octoshop.xprice', w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.RoundedBox(4, 0, 0, w, h, Color(220,220,220))
			draw.RoundedBox(4, 1, 1, w-2, h-2, Color(238,238,238))
			draw.SimpleText(txt, 'octoshop.xprice', w/2, h/2, Color(120,120,120), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	function p_h.b:DoClick()
		if classT.canBuy then
			net.Start('octoshop.purchase')
				net.WriteString(class)
			net.SendToServer()

			f:Remove()
		end
	end

	local p_f = p:Add 'DLabel'
	p_f:Dock(BOTTOM)
	p_f:SetTall(15)
	p_f:SetText(L.tap_anywhere)
	p_f:SetTextColor(Color(120,120,120))
	p_f:SetContentAlignment(5)

	if #classT.attributes > 0 then
		local p_m = p:Add 'DPanel'
		p_m:Dock(LEFT)
		p_m:SetWide(150)
		p_m:SetPaintBackground(false)
		for i, att in ipairs(classT.attributes) do
			local a = p_m:Add 'DPanel'
			a:Dock(TOP)
			a:SetTall(24)
			a:DockMargin(0,0,0,5)
			a:SetPaintBackground(false)

			local i = a:Add 'DPanel'
			i:Dock(LEFT)
			i:SetWide(24)
			i.icon = Material(att[2], '')
			function i:Paint(w, h)
				surface.SetDrawColor(255,255,255, 255)
				surface.SetMaterial(self.icon)
				surface.DrawTexturedRect(4, 4, 16, 16)
			end
			i:AddOctoHint(att[1])

			local l = a:Add 'DLabel'
			l:Dock(FILL)
			l:DockMargin(5,0,0,0)
			l:SetText(att[3])
			l:SetTextColor(Color(30,30,30))
		end
	end

	local p_d = p:Add 'DLabel'
	p_d:Dock(TOP)
	p_d:DockMargin(0,0,8,0)
	p_d:SetWrap(true)
	p_d:SetTextColor(Color(30,30,30))
	p_d:SetText(classT.desc)
	p_d:SetContentAlignment(7)
	p_d:SetTextInset(8, 5)
	function p_d:Paint(w, h)
		surface.DisableClipping(true)
		draw.RoundedBox(4, 0, 0, w+8, h+5, Color(220,220,220))
		draw.RoundedBox(4, 1, 1, w+6, h+3, Color(255,255,255))
		surface.DisableClipping(false)
	end
	function p_d:PerformLayout()
		self:SizeToContentsY()
	end

end

net.Receive('octoshop.rShop', function(len)

	local data = net.ReadTable()
	for i, item in ipairs(data) do
		octoshop.items[item.class] = {
			name = item.name or L.what_it,
			cat = item.cat or L.other,
			desc = item.desc or L.temporary_not_desc,
			price = item.price or 0,
			order = item.order or 999,
			icon = Material(item.icon or 'icon16/help.png', ''),
			color = item.col or Color(102,170,170),
			hidden = item.hidden,
			attributes = item.attributes or {},
			canBuy = item.canBuy,
		}
	end

	octoshop.pnl:UpdateShop()

end)

octoshop.init()
