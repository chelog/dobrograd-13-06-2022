surface.CreateFont('octolib.markers.normal', {
	font = 'Arial Bold',
	extended = true,
	size = 18,
	weight = 300,
	antialias = true,
})

surface.CreateFont('octolib.markers.normal-sh', {
	font = 'Arial Bold',
	extended = true,
	size = 18,
	weight = 300,
	blursize = 5,
	antialias = true,
})

local checks = {
	dist = function(v, data)
		local pos = IsValid(v.tgt) and v.tgt:LocalToWorld(v.pos) or v.pos
		local dist = data[1]
		return EyePos():DistToSqr(pos) < dist * dist
	end,
	time = function(v, data)
		return not data[1] or (CurTime() > v.tim + data[1])
	end,
	timedist = function(v, data)
		local pos = IsValid(v.tgt) and v.tgt:LocalToWorld(v.pos) or v.pos
		local time = data[1]
		local dist = data[2]
		return not time or (CurTime() > v.tim + time) or (EyePos():DistToSqr(pos) < dist * dist)
	end,
}

octolib.markers.cache = octolib.markers.cache or {
	-- {
	--	 txt = 'Доставка заказа',
	--	 tgt = ents.FindByClass('dbg_cont_mailbox')[1],
	--	 pos = Vector(0,0,40),
	--	 col = Color(102,170,170),
	--	 des = { 'dist', 100 },
	-- },
}

hook.Add('Think', 'octolib.markers', function()

	local cache = octolib.markers.cache
	for i = #cache, 1, -1 do
		local v = cache[i]
		local pos = IsValid(v.tgt) and v.tgt:LocalToWorld(v.pos) or v.pos
		local check = checks[v.des[1]]
		if isfunction(check) then
			if check(v, v.des[2]) then
				if v.mapMarker then v.mapMarker:Remove() end
				table.remove(cache, i)
			end
		end
	end

end)

hook.Add('HUDPaint', 'octolib.markers', function()

	if hook.Run('HUDShouldDraw', 'octolib.markers') == false then return end
	local cache = octolib.markers.cache
	for i, v in ipairs(cache) do
		local pos = IsValid(v.tgt) and v.tgt:LocalToWorld(v.pos) or v.pos
		local spos = pos:ToScreen()
		x, y = math.floor(spos.x), math.floor(spos.y)

		local anim = math.min(CurTime() % 1.5, 1)
		draw.NoTexture()
		surface.SetDrawColor(v.col.r, v.col.g, v.col.b, math.pow(1 - anim, 2) * 255)
		draw.Circle(x, y, math.pow(anim, 0.4) * 10 + (v.icn and 5 or 0), 18)

		if v.icn then
			surface.SetMaterial(v.icn)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(x-8, y-8, 16, 16)
		end

		if v.txt then
			local al = math.Clamp(350 - Vector(x,y,0):DistToSqr(Vector(ScrW()/2, ScrH()/2, 0)) / 100, 0, 255)
			if al > 0 then
				v.col.a = al
				local txt = (L.markers_format):format(v.txt, math.ceil(pos:Distance(EyePos()) / 40))

				draw.Text {
					text = txt,
					font = 'octolib.markers.normal-sh',
					pos = {x, y + 10},
					color = Color(0,0,0, v.col.a),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_TOP,
				}

				draw.Text {
					text = txt,
					font = 'octolib.markers.normal',
					pos = {x, y + 10},
					color = v.col,
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_TOP,
				}
			end
		end
	end

end)

function octolib.markers.add(t)
	if not t.pos then return end

	local hudMarker = {
		id = t.id,
		txt = t.txt,
		tgt = t.tgt,
		pos = t.pos,
		col = t.col or Color(255,255,255),
		des = t.des or {'dist', { 100 }},
		tim = t.tim or CurTime(),
		icn = t.icon and Material(t.icon) or nil,
	}

	local mapMarker = octomap.createMarker(t.id or ('marker_' .. tostring(hudMarker)))
	mapMarker:SetIcon(t.icon or 'octoteam/icons-16/location_pin_white.png')
	mapMarker:SetIconSize(t.size)
	mapMarker:SetColor(not t.icon and t.col)
	mapMarker:SetPos(t.pos)
	mapMarker.temp = true
	mapMarker.sort = 1500
	mapMarker:AddToSidebar(t.txt or 'Маркер', t.group)
	hudMarker.mapMarker = mapMarker

	table.insert(octolib.markers.cache, hudMarker)
end
netstream.Hook('octolib.markers.add', octolib.markers.add)

function octolib.markers.clear(id)
	local cache = octolib.markers.cache
	for i = #cache, 1, -1 do
		if not id or string.StartWith(cache[i].id, id) then
			if cache[i].mapMarker then cache[i].mapMarker:Remove() end
			table.remove(cache, i)
		end
	end
end
netstream.Hook('octolib.markers.clear', octolib.markers.clear)
