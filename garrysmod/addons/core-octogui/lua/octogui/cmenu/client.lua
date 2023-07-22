octogui.cmenu = octogui.cmenu or {}
octogui.cmenu.categories = octogui.cmenu.categories or {}
local categories = octogui.cmenu.categories

function octogui.cmenu.registerCategory(id, data)
	if not (isstring(id)) then return end

	data = istable(data) and data or {}
	if not isnumber(data.order) then
		data.order = table.Count(categories) + 1
	end

	local items = categories[id] and categories[id].items or {}
	data.items = items
	categories[id] = data
end

function octogui.cmenu.registerItem(category, id, data)
	if not (isstring(id) and isstring(category) and istable(data)) then return end

	if not categories[category] then
		octogui.cmenu.registerCategory(category)
	end

	if not isnumber(data.order) then data.order = table.Count(categories[category].items) + 1 end
	categories[category].items[id] = data
end

--
-- UTILITY STUFF
--
surface.CreateFont('dbg_window_underline', {
	font = system.IsOSX() and 'Helvetica' or 'Tahoma',
	size = 13,
	antialias = true,
	extended = true,
	underline = true,
})

local rtl = function(self)
	self:SetFontInternal('DermaDefault')
	self:SetUnderlineFont('dbg_window_underline')
end

local as = function(_, name, val)
	if name == 'TextClicked' then
		gui.ActivateGameUI()
		octoesc.OpenURL(val)
	end
end

function octogui.cmenu.window(title, txt)

	local f = vgui.Create 'DFrame'
	f:SetSize(300, 300)
	f:SetTitle(title or L.information)
	f:SetSizable(true)
	f:SetMinWidth(300)
	f:AlignTop(5)
	f:AlignLeft(5)

	local lbl = f:Add('RichText')
	lbl:Dock(FILL)
	txt = octolib.string.splitByUrl(txt)
	lbl:InsertColorChange(255, 255, 255, 255)
	for _,v in ipairs(txt) do
		if istable(v) then
			lbl:InsertClickableTextStart(v[1])
			lbl:InsertColorChange(0, 130, 255, 255)
			lbl:AppendText(v[1])
			lbl:InsertColorChange(255, 255, 255, 255)
			lbl:InsertClickableTextEnd()
		else
			lbl:AppendText(v)
		end
	end
	lbl.PerformLayout = rtl
	lbl.ActionSignal = as
	lbl:SetToFullHeight()

end

---
--- GMOD INTEGRATION
---

function octogui.cmenu.create()

	local m = vgui.Create 'DMenu'
	local ply = LocalPlayer()

	local function handleItem(item, m)
		if item.spacer then m:AddSpacer() return end
		local text
		if isfunction(item.text) then text = item.text(ply)
		elseif item.text then text = item.text end
		text = text or L.action
		local icon
		if isfunction(item.icon) then icon = item.icon(ply)
		elseif item.icon then icon = item.icon end
		local subMenu, option
		if item.build then
			subMenu, option = m:AddSubMenu(text)
			item.build(subMenu, option)
		elseif item.options then
			subMenu, option = m:AddSubMenu(text)
			for _, subOption in ipairs(item.options) do
				if not subOption.check or subOption.check(ply) then handleItem(subOption, subMenu) end
			end
		else
			local action = item.action
			if not action then
				if item.say then
					action = function() octochat.say(item.say) end
				end

				if item.cmd then
					action = function() RunConsoleCommand(unpack(item.cmd)) end
				end

				if item.url then
					action = function() octoesc.OpenURL(item.url) end
				end

				if istable(item.netstream) then
					action = function() netstream.Start(unpack(item.netstream)) end
				elseif item.netstream then
					action = function() netstream.Start(item.netstream) end
				end
			end

			option = m:AddOption(text, action)
		end

		if icon then option:SetImage(icon) end
		if item.enable then
			local enable = item.enable(ply)
			option:SetEnabled(enable)
			if not enable then option:SetAlpha(100) end
		end
	end

	local shouldAddSpacer = false -- each category has to add spacer before it's elements, except the first one
	for catID, cat in SortedPairsByMemberValue(categories, 'order') do
		if not cat.check or cat.check(ply) then
			local empty = true -- means that this category has no elements
			for itemID, item in SortedPairsByMemberValue(cat.items, 'order') do
				if not item.check or item.check(ply) then
					if shouldAddSpacer and empty then m:AddSpacer()
					else shouldAddSpacer = true end
					empty = false
					handleItem(item, m)
				end
			end
		end
	end
	m:PerformLayout()

	return m

end

local cmenu
hook.Add('OnContextMenuOpen', 'CMenuOnContextMenuOpen', function()

	if not IsValid(g_ContextMenu) then return end

	if not g_ContextMenu:IsVisible() then
		local orig = g_ContextMenu.Open
		g_ContextMenu.Open = function(self, ...)
			self.Open = orig
			orig(self, ...)

			cmenu = octogui.cmenu.create()
			cmenu:Open()
			cmenu:CenterVertical()
			cmenu:SetX(-cmenu:GetWide())
			cmenu:MoveTo(8, cmenu:GetY(), .1, 0)
		end
	end

end)

hook.Add('OnContextMenuClose', 'CMenuOnContextMenuClose', function()
	if IsValid(cmenu) then cmenu:Remove() end
end)
