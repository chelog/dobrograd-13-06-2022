local PANEL = {}

-- drag'n'drop seems to reset this?
local function fixCursor()
	local x, y = gui.MousePos()
	timer.Simple(0, function()
		gui.EnableScreenClicker(true)
		gui.SetMousePos(x, y)
	end)
end

function PANEL:Init()

	self:SetSize(250, ScrH() - 62)
	self:AlignLeft(5)
	self:AlignTop(52)

	self.refs = {}

	local root = self:AddNode('Сцена', 'octoteam/icons-16/world.png')
	root:SetExpanded(true)
	self.root = root

	local function dropOnWorld(_, pnls, dropped, menuID, x, y)

		if not dropped then return end

		local pnl = pnls[1]
		if not IsValid(pnl) or pnl == root then return end

		local csent = pnl.movable and pnl.movable:GetCSEntity()
		if IsValid(csent) then csent:SetParent() end

		root:InsertNode(pnl)
		fixCursor()

	end
	self:Receiver('movable', dropOnWorld)
	root:Receiver('movable', dropOnWorld)

end

function PANEL:OnNodeSelected(node)

	local movable = node.movable
	if movable then
		self:MovableSelected(movable, node)
	end

end

function PANEL:DoRightClick(node)

	local options = octolib.flyEditor.options or {}
	local menuOpts = {
		{'Сменить имя', 'icon16/pencil.png', function()
			local movable = node.movable
			if movable then
				Derma_StringRequest('Сменить название', 'Укажи новое название', node.Label:GetText(), function(s)
					movable.name = s
					node:SetText(s)
				end)
			end
		end},
	}

	if not options.noCopy and not node.movable.static then
		table.insert(menuOpts, {'Клонировать', 'icon16/page_white_copy.png', function()
			local movable = node.movable
			if movable then
				local new = movable:Clone()
				self:SelectByMovable(new)
			end
		end})
	end

	if not options.noRemove and not node.movable.static then
		table.insert(menuOpts, {'Удалить', 'icon16/delete.png', function()
			local movable = node.movable
			if movable then
				movable:Remove()
			end
		end})
	end

	octolib.menu(menuOpts):Open()

end

local function onDropLine(self, pnls, dropped, menuID, x, y)

	if not dropped then return end

	local pnl = pnls[1]
	if not IsValid(pnl) or pnl == self then return end

	local our = self.movable and self.movable:GetCSEntity()
	local their = pnl.movable and pnl.movable:GetCSEntity()
	if IsValid(our) and IsValid(their) then
		their:SetParent(our)
		self:InsertNode(pnl)
	end

	fixCursor()

end

function PANEL:AddMovable(movable)

	local parentNode = self.root
	local parent = movable.csent:GetParent()
	if IsValid(parent) and parent.movable then
		local node = self.refs[parent.movable]
		if node then parentNode = node end
	end

	local node = parentNode:AddNode(
		movable.name or movable.csent:GetModel(),
		movable.icon or 'octoteam/icons-16/box_closed.png'
	)
	node:Droppable('movable')
	node:Receiver('movable', onDropLine)
	node:SetExpanded(true)

	node.movable = movable
	self.refs[movable] = node

	self:UpdateParents()

end

function PANEL:RemoveMovable(movable)

	local node = self.refs[movable]
	if node then
		node:Remove()
		self.refs[movable] = nil
	end

end

PANEL.UpdateParents = octolib.func.debounce(function(self)

	for movable, node in pairs(self.refs) do
		local parentNode = self.root
		local parent = movable.csent:GetParent()
		if IsValid(parent) and parent.movable then
			local node = self.refs[parent.movable]
			if node then parentNode = node end
		end

		if node:GetParentNode() ~= parentNode then
			parentNode:InsertNode(node)
		end
	end

end, 0)

function PANEL:SelectByMovable(movable)

	local node = self.refs[movable]
	if node then
		self:SetSelectedItem(node)
	end

end

function PANEL:MovableSelected(movable, node)

	local oldSelected = octolib.flyEditor.selected
	if oldSelected then oldSelected.selected = nil end

	movable.selected = true
	octolib.flyEditor.selected = movable
	octolib.flyEditor.pnlInspector:SetEntity(movable:GetCSEntity())

end

vgui.Register('fe_scene', PANEL, 'DTree')
