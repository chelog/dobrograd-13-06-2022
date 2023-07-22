local PANEL = {}

function PANEL:Init()

	self:SetText('<color=255,100,100>Hello</color> World!')

end

function PANEL:SetText(text)

	self.oldW = self:GetWide()
	self.markupContent = text

	self:UpdateMarkup()

end

function PANEL:PerformLayout(w, h)

	if w == self.oldW then return end
	self.oldW = w

	self:UpdateMarkup()

end

function PANEL:UpdateMarkup()

	self.markup = markup.Parse(self.markupContent, self:GetWide())
	self:SetTall(self.markup:GetHeight())

end

function PANEL:Paint(w, h)

	self.markup:Draw(0, 0, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

end

vgui.Register('DMarkup', PANEL, 'DPanel')
