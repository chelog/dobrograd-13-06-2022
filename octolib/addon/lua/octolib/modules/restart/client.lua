surface.CreateFont('octolib.restart.normal', {
	font = 'Calibri',
	extended = true,
	size = 36,
	weight = 350,
})

surface.CreateFont('octolib.restart.normal-sh', {
	font = 'Calibri',
	extended = true,
	size = 36,
	weight = 350,
	blursize = 3,
})

local function niceTime(time)

	local m, s
	m = math.floor(time / 60) % 60
	s = math.floor(time) % 60

	return string.format('Рестарт через %02i:%02i', m, s)

end

local restartTime = 0
local function drawOverlay()

	if hook.Run('HUDShouldDraw', 'octolib.restart') == false then return end
	local x, y = ScrW() / 2, ScrH() - 25
	local timeLeft = restartTime - CurTime()
	local text = niceTime(math.max(timeLeft, 0))

	if timeLeft % 30 <= 1 then
		x = x + math.sin(timeLeft * math.pi * 10) * 10
	end

	local t = {
		text = text,
		font = 'octolib.restart.normal-sh',
		pos = { x, y },
		color = color_black,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}

	draw.Text(t)
	t.color = color_white
	t.font = 'octolib.restart.normal'
	draw.Text(t)

end

netstream.Hook('octolib.restart', function(delay)

	if delay then
		restartTime = CurTime() + delay
		hook.Add('HUDPaint', 'octolib.restart', drawOverlay)
	else
		hook.Remove('HUDPaint', 'octolib.restart')
	end

end)
