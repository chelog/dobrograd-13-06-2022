local PANEL = {}

AccessorFunc(PANEL, 'menuList', 'MenuList')
AccessorFunc(PANEL, 'scr', 'Canvas')

function PANEL:Init()

	self:SetPaintBackground(false)
	self.menuList = self:Add 'DListView'
	self.menuList:Dock(LEFT)
	self.menuList:SetWide(150)
	self.menuList:AddColumn('Icon'):SetFixedWidth(48)
	self.menuList:AddColumn('Name')
	self.menuList:SetHideHeaders(true)
	self.menuList:SetDataHeight(42)
	self.menuList:DockMargin(2, 7, 0, 3)
	self.menuList:SetMultiSelect(false)

	self.menuList.OnRowSelected = function(_, _, row)
		if IsValid(self.scr) then self.scr:Remove() end
		self.scr = self:Add 'DScrollPanel'
		self.scr:Dock(FILL)
		self.scr:DockMargin(5, 3, 5, 0)
		self.scr.pnlCanvas:DockPadding(20, 5, 25, 20)

		local container = row.build(self.scr)
		if IsValid(container) then
			self.scr:Remove()
			container:SetParent(self)
			container:Dock(FILL)
			container:DockMargin(15, 5, 5, 5)
			self.scr = container
		end
	end

	self.RecalcWidth = octolib.func.debounce(function()
		local maxWidth = 0
		surface.SetFont('DermaDefault')
		local iconWidth = self.menuList:ColumnWidth(1)
		for _, row in ipairs(self.menuList:GetLines()) do
			maxWidth = math.max(maxWidth, iconWidth + select(1, surface.GetTextSize(row:GetValue(2))))
		end
		self.menuList:SetWide(maxWidth + 25)
	end, 0)

end

local function paintIconInCenter(self, w, h)
	local mat = self:GetMaterial()
	local matW, matH = math.min(mat:Width(), 32), math.min(mat:Height(), 32)
	surface.SetMaterial(mat)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect((w-matW) / 2, (h-matH) / 2, matW, matH)
end
function PANEL:AddTab(name, icon, build)
	local iconPnl = vgui.Create 'DImage'
	iconPnl:SetImage(icon:find('/') and icon or octolib.icons.silk32(icon))

	iconPnl.Paint = paintIconInCenter
	local line = self.menuList:AddLine(iconPnl, name)
	line.build = build
	self:RecalcWidth()
	return line
end

function PANEL:SelectFirstTab()
	self.menuList:SelectFirstItem()
end

function PANEL:SelectTab(index)
	self.menuList:SelectItem(self.menuList:GetLine(index))
end

function PANEL:Clear()
	self.menuList:Clear()
	if IsValid(self.scr) then self.scr:Remove() end
end

vgui.Register('DTabsList', PANEL, 'DPanel')
