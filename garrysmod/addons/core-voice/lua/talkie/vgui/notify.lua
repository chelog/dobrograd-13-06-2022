local PANEL = {}
local colors = CFG.skinColors

function PANEL:Init()

	self.name = self:Add('DLabel')
	self.name:SetFont('GModNotify')
	self.name:Dock(FILL)
	self.name:DockMargin(8, 0, 0, 0)
	self.name:SetTextColor(color_white)

	self:SetColor(colors.bg)
	self:SetSize(250, 32 + 8)
	self:DockPadding(4, 4, 4, 4)
	self:DockMargin(2, 2, 2, 2)
	self:Dock(BOTTOM)

end

function PANEL:Setup(ply)
	self.ply = ply
	self.name:SetText(ply:Nick())	
	self:InvalidateLayout()
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, self.col_d)
	draw.RoundedBox(4, 1, 1, w-2, h-2, self.col60)
end

function PANEL:SetColor(clr)
	self.col_d = Color(clr.r * 0.75, clr.g * 0.75, clr.b * 0.75)
	self.col60 = ColorAlpha(clr, 150)
end

local function remap(val, min, max)
	return min + val * (max - min)
end
function PANEL:Think()
	
	if IsValid(self.ply) then
		self.name:SetText(self.ply:Nick())
		local mul = self.ply:VoiceVolume()
		local col = colors.bg
		self:SetColor(Color(remap(mul, col.r, col.r * 2), remap(mul, col.g, col.g * 2), remap(mul, col.b, col.b * 2), 240))
	end

	if self.fadeAnim then
		self.fadeAnim:Run()
	end

end

function PANEL:FadeOut(anim, delta, data)
	
	if anim.Finished then
		if IsValid(talkie.voicePnls[self.ply]) then
			talkie.voicePnls[self.ply]:Remove()
			talkie.voicePnls[self.ply] = nil
		end
		return
	end
	self:SetAlpha(255 - (255 * delta))

end

vgui.Register('talkie_notify', PANEL, 'DPanel')

