surface.CreateFont('octolib.timer.normal', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
})

surface.CreateFont('octolib.timer.normal-sh', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
	blursize = 3,
})

local message, timeFinish
netstream.Hook('octolib.timer', function(text, delay)
	message = text
	timeFinish = CurTime() + delay
end)

local function niceTime(time)

	local m, s
	m = math.floor(time / 60) % 60
	s = math.floor(time) % 60

	return string.format('%02i:%02i', m, s)

end

hook.Add('HUDPaint', 'octolib.timer', function()

	if not timeFinish then return end

	local timeLeft = timeFinish - CurTime()
	local text = message:format(niceTime(math.max(timeLeft, 0)))

	if timeLeft < 0 then
		surface.SetAlphaMultiplier(timeLeft + 1)
	end

	draw.DrawText(text, 'octolib.timer.normal-sh', 10, 5, color_black)
	draw.DrawText(text, 'octolib.timer.normal', 10, 5, color_white)

	surface.SetAlphaMultiplier(1)

	if timeLeft <= -1 then
		text, timeFinish = nil
	end

end)