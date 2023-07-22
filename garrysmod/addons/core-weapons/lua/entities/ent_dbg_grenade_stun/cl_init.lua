include('shared.lua')

local effectLen = 2
local start, endd, alpha, len = -1, -1, -1, -1
local xRand, yRand = 0, 0

local function createFlash(ent)
	ent = IsValid(ent) and ent or LocalPlayer()
	local flash = DynamicLight(ent:EntIndex())
	if flash then
		flash.pos = ent:GetPos() + Vector(0,0,10)
		flash.r = 255
		flash.g = 255
		flash.b = 255
		flash.brightness = 2
		flash.decay = 2000
		flash.size = 2048
		flash.dietime = CurTime() + 1.5
	end
end

netstream.Hook('dbg-grenades.shock', function(en, rAlpha, rLen)
	start = CurTime()
	endd = start + en
	alpha = rAlpha
	len = rLen
	xRand, yRand = math.Rand(2, 4), math.Rand(2, 4)
	createFlash(LocalPlayer())
end)
netstream.Hook('dbg-grenades.flash', createFlash)

hook.Add('HUDPaint', 'dbg-grenades.shock', function()
	if endd < CurTime() then return end
	local val
	if endd - CurTime() > len then
		val = alpha
	else
		val = alpha * (endd - CurTime()) / len
	end

	surface.SetDrawColor(255, 255, 255, math.Round(val))
	surface.DrawRect(0, 0, surface.ScreenWidth(), surface.ScreenHeight())
	--draw.DrawText(tostring(val), 'DermaLarge', 10, 10, color_black)
end)

hook.Add('RenderScreenspaceEffects', 'dbg-grenades.shock', function()
	local e = endd + effectLen
	local ct = CurTime()
	if e <= ct then return end
	local l = len + effectLen
	local val = (e - ct) / l
	DrawMotionBlur(1 - val, 1, 0)
	DrawBloom(3, 1/(val*alpha), 6, 6, 12, 0, 255, 255, 255)

	local off = 20 * val
	dbgView.lookOff.p = math.sin(ct * yRand) * off
	dbgView.lookOff.y = math.sin(ct * xRand) * off
end)
