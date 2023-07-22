--[[
	� 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
	
  _______ _				   _	_ _____ 
 |__   __(_)				 | |  | |_   _|
	| |   _  __ _  ___ _ __  | |  | | | |  
	| |  | |/ _` |/ _ \ '__| | |  | | | |  
	| |  | | (_| |  __/ |	| |__| |_| |_ 
	|_|  |_|\__, |\___|_|	 \____/|_____|
			 __/ |						 
			|___/	  
]]

local panel = {}

local SORT_ASCENDING = 1
local SORT_DESCENDING = 2

local sort_material_descending = Material("icon16/bullet_arrow_up.png")
local sort_material_ascending = Material("icon16/bullet_arrow_down.png")

surface.CreateFont("tiger.list.text", {font = "Arial", size = 14, weight = 400})
surface.CreateFont("tiger.list.column", {font = "Istok", size = 14, weight = 800})

AccessorFunc(panel, "m_iColumnHeight", "ColumnHeight")

-- List.
serverguard.themes.CreateDefault("tiger_list_bg", Color(255, 255, 255), "tiger.list")
serverguard.themes.CreateDefault("tiger_list_outline", Color(190, 190, 190), "tiger.list")

-- The labels on the panel.
serverguard.themes.CreateDefault("tiger_list_panel_label", Color(141, 127, 123), "tiger.list")
serverguard.themes.CreateDefault("tiger_list_panel_label_hover", Color(241, 242, 234), "tiger.list")

-- The panel in the list.
serverguard.themes.CreateDefault("tiger_list_panel_list_outline", Color(190, 190, 190), "tiger.list")
serverguard.themes.CreateDefault("tiger_list_panel_list_hover", Color(31, 153, 228), "tiger.list")
serverguard.themes.CreateDefault("tiger_list_panel_list_bg", Color(255, 255, 255), "tiger.list")
serverguard.themes.CreateDefault("tiger_list_panel_list_bg_dark", Color(246, 246, 246), "tiger.list")

-- Column.
serverguard.themes.CreateDefault("tiger_list_column_outline", Color(190, 190, 190), "tiger.list")
serverguard.themes.CreateDefault("tiger_list_column_label",Color(141, 142, 134), "tiger.list")

function panel:Init()
	self.sortType = SORT_ASCENDING
	self.sortColumn = 1
	
	self:DockPadding(1, 1, 1, 1)
	self:SetColumnHeight(30)
	
	self.list = self:Add("tiger.scrollpanel");
	self.list:Dock(FILL);
end

function panel:Clear()
	self.list:Clear()
end

function panel:AddColumn(name, width)
	local base = self
	
	self:DockPadding(1, 30, 1, 1)
	
	self.columns = self.columns or {}
	
	local column = self:Add("Panel")
	column:SetSize(width, self.m_iColumnHeight + 1)

	column.labels = {}

	function column:Paint(w, h)
		local theme = serverguard.themes.GetCurrent()
		
		surface.SetDrawColor(theme.tiger_list_column_outline)
		
		-- Bottom line.
		surface.DrawLine(0, h -1, w, h -1)
		
		if (!self.last) then
			-- Right line.
			surface.DrawLine(w -1, 0, w -1, h)
		end
		
		draw.SimpleText(name, "tiger.list.column", w /2, h /2, theme.tiger_list_column_label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		if (base.sortColumn == self.sortID and !self.disabled) then
			local width = util.GetTextSize("tiger.list.column", name)
			
			if (base.sortType == SORT_ASCENDING) then
				draw.Material(w /2 +width /2 +2, 6, 16, 16, color_white, sort_material_ascending)
			else
				draw.Material(w /2 +width /2 +2, 6, 16, 16, color_white, sort_material_descending)
			end
		end
	end
	
	function column:OnCursorEntered()
		if (!self.disabled) then
			self:SetCursor("hand")
		end
	end
	
	function column:OnCursorExited()
		if (!self.disabled) then
			self:SetCursor("arrow")
		end
	end
	
	function column.OnMousePressed(_self)
		if (!_self.disabled) then
			self.sortColumn = _self.sortID
			
			if (_self.sortType == SORT_ASCENDING) then
				_self.sortType = SORT_DESCENDING
			else
				_self.sortType = SORT_ASCENDING
			end
			
			self.sortType = _self.sortType
			
			self:OnSort()
		end
	end
	
	function column:SetDisabled(bool)
		self.disabled = bool
	end
	
	column.sortID = table.insert(self.columns, column)
	
	return column
end

function panel:GetColumn(id)
	return self.columns[id]
end

function panel:GetVBar()
	return self.list.VBar
end

function panel:AddPanel(panel)
	self.list:AddItem(panel)
end

function panel:AddItem(...)
	local scrollbar = self.list.VBar
	local theme = serverguard.themes.GetCurrent()
	
	local panel = vgui.Create("Panel")
	panel:SetTall(30)
	panel:Dock(TOP)
	panel:SetZPos(0)
	
	panel.number = 0
	panel.labels = {}
	panel.others = {}
	
	local data = {...}

	for i = 1, #data do
		local v = data[i]
		local child
		
		if (ispanel(v)) then
			child = v
			child:SetParent(panel)
			
			AccessorFunc(child, "m_SortData", "Sort")
			
			self.others[i] = child
		else
			child = panel:Add("DLabel")
			child:SetContentAlignment(5)
			child:SetFont("tiger.list.text")
			child:SetText(v)
			child:Dock(LEFT)
			child:SetColor(theme.tiger_list_panel_label)
			child.IsLabel = true
			
			AccessorFunc(child, "m_SortData", "Sort")
			
			child.oldColor = theme.tiger_list_panel_label
			
			serverguard.themes.AddPanel(child, "tiger_list_panel_label")
			
			function child:SetUpdate(func)
				function self:Think() func(self) end
			end
			
			panel.labels[i] = child
		end
		
		local column = self.columns[i]
	
		if (IsValid(column)) then
			child.column = column
			
			if (child.IsLabel) then
				child:SetWide(column:GetWide())
			end
			
			if (i == #data) then
				table.insert(column.labels, child)
			end
		end
	end
	
	function panel:Paint(w, h)
		local theme = serverguard.themes.GetCurrent()
		
		if (self.hovered) then
			draw.SimpleRect(0, 0, w, h, theme.tiger_list_panel_list_hover)
		else
			if (self.number % 2 == 1) then
				draw.SimpleRect(0, 0, w, h,theme.tiger_list_panel_list_bg_dark)
			else
				draw.SimpleRect(0, 0, w, h, theme.tiger_list_panel_list_bg)
			end
		end
		
		surface.SetDrawColor(theme.tiger_list_panel_list_outline)
		surface.DrawLine(0, 0, w, 0);
		
		if (self.last and !scrollbar:IsVisible()) then
			surface.DrawLine(0, h -1, w, h -1)
		end
	end
	
	function panel:OnCursorEntered()
		self:SetCursor("hand")

		self.hovered = true
		
		local theme = serverguard.themes.GetCurrent()
		
		for k, label in ipairs(self:GetChildren()) do
			if (label.IsLabel) then
				if (!label.oldColor) then
					label.oldColor = theme.tiger_list_panel_label
				end
				
				label:SetColor(theme.tiger_list_panel_label_hover)
				label:InvalidateLayout(true)
			end
		end
	end
	
	function panel:OnCursorExited()
		self:SetCursor("arrow")

		self.hovered = nil
		
		for k, label in ipairs(self:GetChildren()) do
			if (label.IsLabel) then
				label:SetColor(label.oldColor)
				label:InvalidateLayout(true)
			end
		end
	end
	
	function panel:GetLabel(index)
		return self.labels[index]
	end
	
	function panel:GetThing(index)
		return self.others[index]
	end
	
	function panel.AddItem(_self, ...)
		local info = {...}
		local dataIndex = #data +1
		
		--
		--table.remove(self.columns[#self.columns].labels, #self.columns)
		
		for i = 1, #info do
			local v = info[i]
			local child
			
			if (ispanel(v)) then
				child = v
				child:SetParent(_self)
				
				AccessorFunc(child, "m_SortData", "Sort")
				
				_self.others[dataIndex] = child
			else
				child = _self:Add("DLabel")
				child:SetContentAlignment(5)
				child:SetFont("tiger.list.text")
				child:SetText(v)
				child:Dock(LEFT)
				child:SetColor(_self.color_label)
				child.IsLabel = true
				
				AccessorFunc(child, "m_SortData", "Sort")
				
				child.oldColor = _self.color_label
				
				function child:SetUpdate(func)
					function self:Think() func(self) end
				end
				
				_self.labels[i] = child
			end
			
			local column = self.columns[dataIndex]
		
			if (IsValid(column)) then
				child.column = column
				
				if (child.IsLabel) then
					child:SetWide(column:GetWide())
				end
				
				if (i == #data) then
					table.insert(column.labels, child)
				end
			end
			
			dataIndex = dataIndex +1
		end
	end
	
	self.list:AddItem(panel)
	
	local children = self:GetCanvas():GetChildren()
	local len = #children
	
	if (len == 1) then
		local child = children[1]
		child.number = 1
		child.first = true
		child.last = true
	elseif (len ~= 0) then
		local child = children[1]
		child.number = 1
		child.first = true
		
		child = children[len]
		child.number = len
		child.last = true
		
		for i = 2, len - 1 do
			child.number = i
		end
	end
	
	timer.Simple(FrameTime() * 2, function() 
		if (self.OnSort) then
			self:OnSort()
		end
	end)
	
	return panel
end

function panel:GetCanvas()
	return self.list:GetCanvas()
end

function panel:OnSort()
	local sorted = {}
	-- FIXME: Sort in this loop
	for k, child in ipairs(self:GetCanvas():GetChildren()) do
		local label = child:GetLabel(self.sortColumn)
		local value = label:GetSort() or label:GetText()
		local isNumber = tonumber(value) and true
		
		table.insert(sorted, {number = isNumber, value = value, panel = child})
	end

	-- SORT_ASCENDING A-Z
	-- SORT_DESCENDING Z-A
	
	if (self.sortType == SORT_ASCENDING) then
		table.sort(sorted, function(a, b) if (a.number and b.number) then return tonumber(a.value) < tonumber(b.value) else return string.lower(a.value) < string.lower(b.value) end end)
	else
		table.sort(sorted, function(a, b) if (a.number and b.number) then return tonumber(a.value) > tonumber(b.value) else return string.lower(a.value) > string.lower(b.value) end end)
	end
	
	for k, data in ipairs(sorted) do
		data.panel:SetZPos(k)
		
		data.panel.number = k
		data.panel.first = k == 1
		data.panel.last = k == #sorted
	end
end

function panel:DisablePaint()
	function self:Paint(w, h) end
end

function panel:PerformLayout()
	local w, h = self:GetSize()
	
	if (self.columns) then
		local x = 0
	
		for i = 1, #self.columns do
			local column = self.columns[i]
			
			column:SetPos(x, 0)
			
			if (i == #self.columns) then
				column.last = true
				column:SetWide(self:GetWide() -x)
				
				for k, label in pairs(column.labels) do
					if (label.IsLabel) then
						label:SetWide(column:GetWide())
					end
				end
			end
			
			x = x +column:GetWide()
		end
	end
end

function panel:Paint(w, h)
	local theme = serverguard.themes.GetCurrent()
	
	draw.RoundedBox(4, 0, 0, w, h, theme.tiger_list_outline)
	draw.RoundedBox(2, 1, 1, w -2, h -2, theme.tiger_list_bg)
end

tiger_list = vgui.Register("tiger.list", panel, "Panel")