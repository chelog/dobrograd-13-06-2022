local PANEL = {}

function PANEL:Init()

	self.label = ''
	self.font = 'DermaDefault'
	self.BasePaint = vgui.GetControlTable('DProgress').Paint

end

function PANEL:SetText(txt)

	self.label = tostring(txt)

end

function PANEL:SetFont(txt)

	self.font = tostring(txt)

end

function PANEL:AttachToEdge(detach)
	self.edge = not detach
end

function PANEL:Paint(w, h)
	self:BasePaint(w, h)
	if string.Trim(self.label) == '' then return end
	local x, align
	if not self.edge then
		x, align = w / 2, TEXT_ALIGN_CENTER
	else
		x, align = w * self:GetFraction() - 5, TEXT_ALIGN_RIGHT
		surface.SetFont(self.font)
		local tw = surface.GetTextSize(self.label)
		x = math.max(x, tw + 7)
	end
	draw.SimpleText(self.label, self.font, x, h / 2, color_white, align, TEXT_ALIGN_CENTER)
end

vgui.Register('DProgressLabel', PANEL, 'DProgress')
