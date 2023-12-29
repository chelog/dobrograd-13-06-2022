local delays = {}

surface.CreateFont('octolib.use', {
	font = 'Calibri',
	extended = true,
	size = 82,
	weight = 350,
})

surface.CreateFont('octolib.use-sh', {
	font = 'Calibri',
	extended = true,
	size = 82,
	weight = 350,
	blursize = 5,
})

netstream.Hook('octolib.delay', function(id, active, text, time)

	local id = id
	local active = active

	if active then
		delays[id] = {
			text = text,
			start = CurTime(),
			time = time - CurTime(),
		}
	else
		delays[id] = nil
	end

end)

local cx, cy = 0, 0
local size = 40
local p1, p2 = {}, {}
for i = 1, 36 do
	local a1 = math.rad((i-1) * -10 + 180)
	local a2 = math.rad(i * -10 + 180)
	p1[i] = { x = cx + math.sin(a1) * size, y = cy + math.cos(a1) * size }
	p2[i] = {
		{ x = cx, y = cy },
		{ x = cx + math.sin(a1) * size, y = cy + math.cos(a1) * size },
		{ x = cx + math.sin(a2) * size, y = cy + math.cos(a2) * size },
	}
end

local override
hook.Add('dbg-view.chShouldDraw', 'octolib.delay', function()

	override = table.Count(delays) > 0
	if override then return true end

end)

hook.Add('dbg-view.chPaint', 'octolib.delay', function(tr, icon)

	for id, data in pairs(delays) do
		local segs = math.min(math.ceil((CurTime() - data.start) / data.time * 36), 36)
		local text = data.text .. ('.'):rep(math.floor(CurTime() * 2 % 4))
		draw.SimpleText(text, 'octolib.use-sh', 0 + 60, 0, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(text, 'octolib.use', 0 + 60, 0, Color(255,255,255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		draw.NoTexture()
		surface.SetDrawColor(255,255,255, 50)
		surface.DrawPoly(p1)

		surface.SetDrawColor(255,255,255, 150)
		for i = 1, segs do
			surface.DrawPoly(p2[i])
		end

		return true
	end

end)

hook.Add('dbg-view.chOverride', 'octolib.delay', function(tr, icon)

	local ply = LocalPlayer()
	if override and (not tr.Hit or tr.Fraction > 0.03) then
		local aim = (ply.viewAngs or ply:EyeAngles()):Forward()
		tr.HitPos = ply:GetShootPos() + aim * 60
		tr.HitNormal = -aim
		tr.Fraction = 0.03
	end

end)
