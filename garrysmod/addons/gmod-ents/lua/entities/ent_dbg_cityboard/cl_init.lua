include 'shared.lua'

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.RenderGroup 		= RENDERGROUP_BOTH

ENT.DPU = 10
ENT.DrawShared = true
ENT.DrawPos = Vector(2.65, -35, 22.5)
ENT.DrawAng = Angle(0, 90, 90)

surface.CreateFont('city-board.title', {
	font = 'Calibri',
	extended = true,
	size = 48,
	weight = 350,
})

local colors = CFG.skinColors
function ENT:InitPanel(pnl)

	pnl:SetSize(700, 450)
	function pnl:Paint(w, h)
		draw.RoundedBox(8, 0, 0, w, h, colors.bg)
	end

	local t1 = octolib.label(pnl, 'Доброград сегодня')
	t1:SetFont('city-board.title')
	t1:SetContentAlignment(5)
	t1:SetTall(50)

	local b1 = octolib.button(pnl, 'Тест', octolib.fQuery('Круто?', 'Тест', 'Да', function()
		octolib.notify.show('hint', 'Тест!')
	end, 'Нет'))

end
