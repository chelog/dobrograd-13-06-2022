local PANEL = {}

function PANEL:Init()

	self:SetSize(250, 400)
	self:AlignRight(5)
	self:AlignTop(5)

	self.controls = {}
	local c = self.controls

	c.col = self:CreateRow('Properties', 'Color')
	c.col:Setup('VectorColor')
	c.col:SetValue(Vector(1,1,1))
	function c.col.DataChanged(p, strCol)
		if not IsValid(self.ent) then return end
		local vCol = Vector(strCol)
		self.VectorValue = vCol
		self.ent:SetColor(vCol:ToColor())
	end

end

function PANEL:SetEntity(ent)

	self.ent = ent

	local c = self.controls
	local col = ent:GetColor()
	c.col:SetValue(Vector(col.r / 255, col.g / 255, col.b / 255))

end

vgui.Register('fe_inspector', PANEL, 'DProperties')
