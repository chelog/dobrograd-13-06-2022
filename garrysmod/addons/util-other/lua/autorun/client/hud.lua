local ply, W, H

local colors = {}
colors.black = Color(0, 0, 0, 255)
colors.blue = Color(0, 0, 255, 255)
colors.brightred = Color(200, 30, 30, 255)
colors.darkred = Color(0, 0, 70, 100)
colors.darkblack = Color(0, 0, 0, 200)
colors.gray1 = Color(0, 0, 0, 155)
colors.gray2 = Color(51, 58, 51,100)
colors.red = Color(255, 0, 0, 255)
colors.white = Color(255, 255, 255, 255)
colors.white1 = Color(255, 255, 255, 200)


-- VOICE TALK ICON
local vcTexture = Material('octoteam/icons-glyph/microphone.png')
local vcRangeColors = {
	[150000]  = { Color(1   * 255,  0.7 * 255,  0.4 * 255,  150), 64},
	[500000]  = { Color(1   * 255,  0.4 * 255,  0.4 * 255,  150), 76},
	[2250000] = { Color(0.5 * 255,  0.5 * 255,  1   * 255,  150), 80},
	[10000]   = { Color(0.5 * 255,  0.5 * 255,  1   * 255,  150), 48},
}
local function voiceChat()
	if not ply.DRPIsTalking then return end
	local data = vcRangeColors[ply:GetNetVar('TalkRange', 0)] or vcRangeColors[150000]
	surface.SetMaterial(vcTexture)
	surface.SetDrawColor(data[1])
	surface.DrawTexturedRectRotated(W / 2, H - 50, data[2], data[2], 0)
end

-- LOCKDOWN
surface.CreateFont('dbg.lockdown.normal', {
	font = 'Calibri',
	extended = true,
	size = 30,
	weight = 350,
})
surface.CreateFont('dbg.lockdown.normal-sh', {
	font = 'Calibri',
	extended = true,
	size = 30,
	weight = 350,
	blursize = 3,
})
local function lockdown()
	if not netvars.GetNetVar('lockdown') then return end
	local t = {
		text = L.lockdown_started,
		font = 'dbg.lockdown.normal-sh',
		pos = {ScrW() / 2, ScrH() - 25},
		color = color_black,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}
	local clr = 220 + 35 * math.sin(CurTime() * 3)
	draw.Text(t)
	t.color = Color(clr,clr,clr)
	t.font = 'dbg.lockdown.normal'
	draw.Text(t)
end

-- ARRESTED
local arrestedUntil
local function arrested()
	if not arrestedUntil then return end
	local ct = CurTime()
	if ct >= arrestedUntil or not ply:GetNetVar('Arrested') then
		arrestedUntil = nil
		return
	end

	draw.DrawNonParsedText(L.youre_arrested:format(octolib.time.formatIn(arrestedUntil - ct, true)), 'DarkRPHUD1', W / 2, H - H / 12, colors.white, 1)

end
net.Receive('gotArrested', function()
	arrestedUntil = CurTime() + net.ReadFloat()
end)

-- ADMINTELL
surface.CreateFont('admintell.title', {
	font = 'Calibri',
	extended = true,
	size = 72,
	weight = 350,
})

surface.CreateFont('admintell.text', {
	font = 'Calibri',
	extended = true,
	size = 28,
	weight = 350,
})

local adminTellStart, adminTellTime, adminTellTxt, adminTellW, adminTellH
octolib.notify.registerType('admin', function(time, title, msg)
	time, title, msg = time or 0, title or '', msg or ''
	if not (time > 0 and (title ~= '' or msg ~= '')) then
		adminTellTime = nil
		return
	end
	adminTellStart = CurTime()
	adminTellTime = time

	adminTellTxt = markup.Parse(('<font=admintell.title>%s</font>\n<font=admintell.text>%s</font>'):format(title or '', msg or ''), 750)
	adminTellW, adminTellH = adminTellTxt:Size()
	ply:EmitSound('weapons/fx/tink/shotgun_shell' .. math.random(1,3) .. '.wav', 75, 200)

end)
local function adminTell()
	if not adminTellTime then return end
	local ct = CurTime()
	if ct - adminTellStart > adminTellTime then
		adminTellTime = nil
		return
	end

	draw.RoundedBox(4, (W - adminTellW) / 2 - 15, 10, adminTellW + 30, adminTellH + 15, colors.darkblack)
	adminTellTxt:Draw(W / 2, 15, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

	local pr = (ct - adminTellStart) / adminTellTime
	draw.RoundedBoxEx(4, (W - adminTellW) / 2 - 15, adminTellH + 20, pr * (adminTellW + 30), 5, color_white, false, false, true)
end

local function run()
if not GAMEMODE then return end

GAMEMODE.DrawDeathNotice = octolib.func.zero

function GAMEMODE:HUDPaint()
	ply = ply and IsValid(ply) and ply or LocalPlayer()
	W, H = ScrW(), ScrH()

	voiceChat()
	lockdown()
	arrested()
	adminTell()
end
end
hook.Add('darkrp.loadModules', 'dbg-hud', run)
run()
