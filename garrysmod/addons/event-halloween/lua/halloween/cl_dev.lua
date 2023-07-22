local dist, distFade = 2000 * 2000, 300 * 300
local image = {
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	url = 'BBZ7st2.png',
	w = 284,
	h = 633,
}

local function drawImage()

	local myPos = EyePos()
	local al = math.Clamp(1 - (image.pos:DistToSqr(myPos) - distFade) / dist, 0, 1)
	if al <= 0 then return end
	local mat = octolib.getImgurMaterial(image.url)
	if mat == octolib.loadingMat then return end

	cam.Start3D2D(image.pos, image.ang, 0.1)
		surface.SetDrawColor(255, 165, 0)
		surface.DrawRect(0, 0, image.w, image.h)
		surface.SetDrawColor(0, 0, 0)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(0, 0, image.w, image.h)
	cam.End3D2D()
end

local fr

concommand.Add('halloween_imgs', function()

	if IsValid(fr) then fr:Remove() end
	fr = vgui.Create 'DFrame'
	fr:SetSize(300, 300)
	fr:AlignBottom(10)
	fr:AlignLeft(10)

	local tr = LocalPlayer():GetEyeTrace()
	local pos, ang = tr.HitPos, tr.HitNormal:Angle()
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	local prop = fr:Add 'DProperties'
	prop:Dock(FILL)

	local function slider(cat, name, min, max, change, decimals)
		local r = prop:CreateRow(cat, name)
		r:Setup('Float', {min = min, max = max})
		r:SetValue(0)

		local l = r:GetChild(1):GetChild(0)
		l.Paint = function() end
		l:GetChild(0):SetDecimals(decimals or 2)
		function r:DataChanged(v) change(v) end

		return r
	end

	local cPos, cAng = Vector(0, 0, 0.25), Angle(0, 0, 0)
	slider('Позиция', 'X', -10, 10, function(val)
		cPos.x = val
		image.pos, image.ang = LocalToWorld(cPos, cAng, pos, ang)
	end):SetValue(0)
	slider('Позиция', 'Y', -10, 10, function(val)
		cPos.y = val
		image.pos, image.ang = LocalToWorld(cPos, cAng, pos, ang)
	end):SetValue(0)
	slider('Позиция', 'Z', -10, 10, function(val)
		cPos.z = val
		image.pos, image.ang = LocalToWorld(cPos, cAng, pos, ang)
	end):SetValue(0.5)

	slider('Угол', 'P', -180, 180, function(val)
		cAng.p = val
		image.pos, image.ang = LocalToWorld(cPos, cAng, pos, ang)
	end):SetValue(ang.p)
	slider('Угол', 'Y', -180, 180, function(val)
		cAng.y = val
		image.pos, image.ang = LocalToWorld(cPos, cAng, pos, ang)
	end):SetValue(ang.y)
	slider('Угол', 'R', -180, 180, function(val)
		cAng.r = val
		image.pos, image.ang = LocalToWorld(cPos, cAng, pos, ang)
	end):SetValue(ang.r)

	image.pos, image.ang = LocalToWorld(cPos, cAng, pos, ang)

	slider('Размеры', 'W', 1, 1000, function(val)
		image.w = val
	end):SetValue(image.w)
	slider('Размеры', 'H', 1, 1000, function(val)
		image.h = val
	end):SetValue(image.h)

	hook.Add('PostDrawOpaqueRenderables', 'dbg-halloween.images.dev', drawImage)

	for _, pnl in pairs(prop.Categories) do
		pnl.Container.Paint = octolib.func.zero
	end

	octolib.button(fr, 'Скопировать', function()
		SetClipboardText(('{ Vector(%.1f,%.1f,%.1f), Angle(%.1f,%.1f,%.1f), %.1f, %.1f },'):format(
			image.pos.x, image.pos.y, image.pos.z,
			image.ang.p, image.ang.y, image.ang.r,
			image.w, image.h):gsub('-0.0', '0'):gsub('%.0', ''))
	end)

	function fr:OnRemove()
		hook.Remove('PostDrawOpaqueRenderables', 'dbg-halloween.images.dev')
	end

end)

local bounds = Vector(10,10,10)
local offset = Vector(0,0,10)
local lootboxFr
concommand.Add('halloween_lootbox', function()
	local ply = LocalPlayer()
	if IsValid(lootboxFr) then lootboxFr:Remove() end

	hook.Add('PostDrawTranslucentRenderables', 'dbg-halloween.lootbox.dev', function()
		local tr = ply:GetEyeTrace()
		local pos = tr.HitPos + offset
		local col = util.TraceHull({
			mins = -bounds,
			maxs = bounds,
			start = pos,
			endpos = pos,
			ignoreworld = true,
		}).Hit and color_red or color_green
		render.DrawWireframeBox(pos, Angle(0,0,0), -bounds, bounds, col, true)
	end)
	lootboxFr = vgui.Create 'DFrame'
	lootboxFr:SetSize(300, 100)
	lootboxFr:AlignBottom(10)
	lootboxFr:AlignLeft(10)

	local btn = lootboxFr:Add('DButton')
	btn:Dock(FILL)
	btn:SetText('Скопировать')
	function btn:DoClick()
		local pos = ply:GetEyeTrace().HitPos + offset
		SetClipboardText('Vector(' .. math.Round(pos.x, 1) .. ', ' .. math.Round(pos.y, 1) .. ', ' .. math.Round(pos.z, 1) .. '),')
	end

	function lootboxFr:OnRemove()
		hook.Remove('PostDrawTranslucentRenderables', 'dbg-halloween.lootbox.dev')
	end

end)
