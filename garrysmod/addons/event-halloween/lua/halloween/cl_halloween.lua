local msg = [[  Раздача подарков за конфеты!

  В город приехал Джек, такой парнишка, который готов скупить все конфеты в этом городе. Он разместил свою лавку в самом сердце города и работает круглосуточно.

  Поспеши! 1 декабря Джек уже поедет обратно в свой родной Сент-Хеленс.]]

local cols = {
	bg = Color(52, 49, 52),
	g = Color(222, 132, 38),
	hvr = Color(0,0,0, 50),
}
cols.bg_d = Color(cols.bg.r * 0.75, cols.bg.g * 0.75, cols.bg.b * 0.75)
cols.g_d = Color(cols.g.r * 0.75, cols.g.g * 0.75, cols.g.b * 0.75)
cols.bg60 = ColorAlpha(cols.bg, 150)

local function paintPanel(_, w, h)

	surface.SetDrawColor(255, 255, 255, 75)

	local mat = octolib.getImgurMaterial('mI3Fq48.jpg')
	surface.SetMaterial(mat)
	local ww, hh = 64, 64
	if mat ~= octolib.loadingMat then
		ww, hh = w, h
	end

	surface.DrawTexturedRect((w - ww) / 2, (h - hh) / 2, ww, hh)

end

hook.Add('octogui.f4-tabs', 'halloween', function()

	octogui.addToF4({
		order = 0.1,
		id = 'halloween',
		name = 'Хэллоуин',
		icon = Material('octoteam/icons/jackolantern.png'),
		build = function(f)
			f:SetSize(500, 500)

			local pan = f:Add 'DPanel'
			pan.Paint = paintPanel
			pan:Dock(FILL)

			local lbl = octolib.label(pan, msg)
			lbl:DockMargin(10, 5, 10, 10)
			lbl:SetFont('f4.normal')
			lbl:SetMultiline(true)
			lbl:SetWrap(true)
			lbl:Dock(FILL)

		end,
		show = function()
			F4:SetCounter('halloween', 0)
			octolib.vars.set('hlw_sweets', true)
		end
	})
	if not octolib.vars.get('hlw_sweets') then
		F4:SetCounter('halloween', 1)
	end

end)

hook.Add('Think', 'dbg-halloween.sweetsCommand', function()
hook.Remove('Think', 'dbg-halloween.sweetsCommand')
octochat.defineCommand('!sweets', {
	aliases = {'~sweets'},
	check = DarkRP.isAdmin,
})
end)

hook.Add('octolib.netVarUpdate', 'dbg-halloween', function(_, varName, varVal)
	if varName == 'sweets' and varVal then F4:SetCounter('halloween', 1) end
end)

hook.Add('InitPostEntity', 'dbg-halloween', function()
	if game.GetMap() == 'rp_truenorth_v1a' then
		msg = [[  Раздача подарков за конфеты!

  В историческом и первом новом районах города можно найти Джека, такого парнишку, который готов скупить все конфеты в этом городе. Он разместил свою лавку в самом сердце города и работает круглосуточно.

  Поспеши! 1 декабря Джек уже поедет обратно в свой родной Сент-Хеленс.]]
	end
end)
