dbgView = dbgView or {}
dbgView.look = dbgView.look or {
	enabled = false,
	state = 0,
	cache = {},
}

surface.CreateFont('dbg-hud.normal', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
	shadow = true,
})
surface.CreateFont('dbg-hud.normal-sh', {
	font = 'Calibri',
	extended = true,
	size = 27,
	blursize = 5,
	weight = 350,
})

surface.CreateFont('dbg-hud.small', {
	font = 'Roboto',
	extended = true,
	size = 17,
	weight = 350,
	shadow = true,
})
surface.CreateFont('dbg-hud.small-sh', {
	font = 'Roboto',
	extended = true,
	size = 17,
	blursize = 4,
	weight = 350,
})

surface.CreateFont('octoinv.3d', {
	font = 'Arial Bold',
	extended = true,
	size = 18,
	weight = 300,
	antialias = true,
})

surface.CreateFont('octoinv.3d-sh', {
	font = 'Arial Bold',
	extended = true,
	size = 18,
	weight = 300,
	blursize = 5,
	antialias = true,
})

local look = dbgView.look

local key_on = GetConVar('cl_dbg_key_look'):GetInt()
cvars.AddChangeCallback('cl_dbg_key_look', function(cv, old, new) key_on = tonumber(new) end)

hook.Add('PlayerBindPress', 'dbg-look', function(ply, bind) if bind == '+zoom' then return true end end)
hook.Add('PlayerButtonDown', 'dbg-look', function(ply, key) if key == key_on and IsFirstTimePredicted() then look.enable(true) end end)
hook.Add('PlayerButtonUp', 'dbg-look', function(ply, key) if key == key_on and IsFirstTimePredicted() then look.enable(false) end end)

function look.enable(val)

	if val then
		look.enabled = true
		netstream.Start('dbg-look.enable', true)

		timer.Create('dbg-look', 0.4, 0, look.update)
		look.update()
	else
		look.enabled = false
		netstream.Start('dbg-look.enable', false)

		timer.Remove('dbg-look')
		for _, cache in pairs(look.cache) do
			cache.killing = true
		end
	end

end

local function getPos(ent, data)

	local pos, ang = ent:WorldSpaceCenter(), ent:GetAngles()
	if data.bone then
		local bone = ent:LookupBone(data.bone)
		if bone then pos, ang = ent:GetBonePosition(bone) end
	end
	if data.posRel then pos = LocalToWorld(data.posRel, angle_zero, pos, ang) end
	if data.posAbs then pos:Add(data.posAbs) end

	return pos, ang

end

local corpseProps = { 'name', 'attacker', 'bullet', 'cause', 'weapon', 'time' }
local function getCorpse(ent)
	local result = {}
	for _, v in ipairs(corpseProps) do
		result[v] = ent:GetNetVar('Corpse.' .. v)
	end
	return result
end

local cos = math.cos(math.rad(40))
function look.update()

	local ply, found = LocalPlayer(), {}
	local ep = ply:EyePos()
	for _, ent in pairs(ents.FindInCone(ep, ply:GetAimVector(), ply:GetNetVar('closelookZoom') and 1200 or 300, cos)) do
		local data = ent.GetNetVar and ent:GetNetVar('dbgLook')
		if data and not ent:GetNoDraw() then
			local pos = getPos(ent, data)
			local filter = { ply }
			if ply:InVehicle() then
				local veh = ply:GetVehicle()
				filter[#filter + 1] = veh
				filter[#filter + 1] = veh:GetParent()
			end
			if ent:IsPlayer() and ent:InVehicle() then
				local veh = ent:GetVehicle()
				filter[#filter + 1] = veh
				filter[#filter + 1] = veh:GetParent()
			end
			local tr = util.TraceLine({ start = ep, endpos = pos, filter = filter })
			if not tr.Hit or tr.Entity == ent then
				found[ent] = true
				if not look.cache[ent] then
					look.cache[ent] = {
						data = data,
						al = 0,
						rot = 0,
						descAl = 0,
						h = 0,
					}
				end
			end
		end
	end

	for ent, cache in pairs(look.cache) do
		cache.killing = not found[ent]
	end

end

hook.Add('EntityRemoved', 'dbg-look', function(ent)

	look.cache[ent] = nil

end)

local icon = Material('octoteam/icons/percent_inactive_white.png')
local st, mat = 0, Material('overlays/vignette01')
local colSh, colName = Color(0,0,0), Color(255,255,255)
local colors = CFG.skinColors
local lp, job, efwd, alive, ghost, seesGhosts, medic, seesCaliber, admin, priest
hook.Add('Think', 'dbg-look', function()

	if not look.enabled and st == 0 then return end
	st = math.Approach(st, look.enabled and 1 or 0, FrameTime() * 1.5)

	look.state = octolib.tween.easing.outQuad(st, 0, 1, 1)

	lp = LocalPlayer()
	efwd, job = lp:GetAimVector(), lp:getJobTable()
	alive, ghost, seesGhosts, medic, seesCaliber, seesName, seesTime, police, admin, priest =
		lp:Alive(),
		lp:GetNetVar('Ghost'),
		job.seesGhosts,
		job.medic,
		job.seesCaliber,
		job.seesName,
		job.seesTime,
		job.police,
		lp:Team() == TEAM_ADMIN,
		lp:Team() == TEAM_PRIEST

	efwd.z = 0
	efwd:Normalize()

end)

hook.Add('HUDPaint', 'dbg-look', function()

	if st == 0 then return end
	if hook.Run('HUDShouldDraw', 'dbg-look') == false then return end

	mat:SetFloat('$alpha', look.state)
	render.SetMaterial(mat)
	render.DrawScreenQuad()

	local ft, cx, cy = FrameTime(), ScrW() / 2, ScrH() / 2
	for ent, cache in pairs(look.cache) do
		if not IsValid(ent) or (cache.al <= 0 and cache.killing) then
			look.cache[ent] = nil
		else
			cache.al = math.Approach(cache.al, cache.killing and 0 or 1, ft * 3)
			local al = octolib.tween.easing.outQuad(cache.al, 0, 1, 1)
			surface.SetAlphaMultiplier(al)

			local pos = getPos(ent, cache.data)
			pos = pos:ToScreen()

			local x, y = math.floor(pos.x), math.floor(pos.y)
			local spos = Vector(x, y, 0)
			if cache.data.lookOff then
				local off = cache.data.lookOff
				spos.x = spos.x - off.x
				spos.y = spos.y - off.y
			end
			local tAl = al * math.Clamp(220 - Vector(x, y, 0):DistToSqr(Vector(cx, cy, 0)) / 200, 0, 200) / 200
			local name, desc = cache.data.name, cache.data.desc

			local run, descAl, descOn = tAl == 1, cache.descAl, cache.descOn
			local descAlSm = descAl
			if desc and desc ~= '' then
				if descOn then
					local func = cache.data.descRender and look.render[desc]
					descAl = math.Approach(descAl, 1, ft * 1.5)
					descAlSm = al * octolib.tween.easing.outQuad(descAl, 0, 1, 1)
					if isfunction(func) then
						func(ent, cache, x, y, al, descAlSm)
					else
						cache.mu = cache.mu or markup.Parse(('<font=dbg-hud.small>%s</font>'):format(desc), 250)
						cache.h = cache.mu:GetHeight() / 2
						local my = y + 5 * descAlSm
						cache.mu:Draw(x, my, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 255 * descAl)
					end
				elseif run and descAl == 1 then
					descAl = 0
					descOn = true
					cache.lookTime = 0
				else
					descAl = math.Approach(descAl, run and 1 or 0, admin and ft * 5 or ft / (cache.data.time or 3))
				end
				cache.descAl = descAl
				cache.descOn = descOn

				local func = cache.data.checkLoader and look.render[cache.data.checkLoader]
				if not isfunction(func) or func(ent, cache) then
					if descOn then tAl = math.max(tAl - descAlSm, 0) end
					if tAl > 0 then
						local rot = (cache.rot - ft * (run and 240 or 90 * tAl)) % 360
						cache.rot = rot

						local iSize = descOn and (36 + 16 * descAlSm) or (36 * tAl)
						surface.SetMaterial(icon)
						surface.SetDrawColor(38, 166, 154, tAl * 255)
						surface.DrawTexturedRectRotated(x, y, iSize, iSize, rot)
					end
				end
			end

			local func = cache.data.nameRender and look.render[name]
			if isfunction(func) then
				func(ent, cache, x, y, al, descAlSm, descOn)
			else
				local ty = descOn and y - descAlSm * (cache.h + 5) or y
				draw.Text {
					text = name,
					font = 'dbg-hud.normal-sh',
					pos = {x, ty - 3},
					color = colSh,
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}
				draw.Text {
					text = name,
					font = 'dbg-hud.normal',
					pos = {x, ty - 3},
					color = colName,
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}
			end
		end
	end

	surface.SetAlphaMultiplier(1)

end)

hook.Add('PlayerFinishedLoading', 'dbg-hud', function()

	hook.Remove('PreDrawHalos', 'PropertiesHover')

end)

look.render = {
	playerLoader = function(ply)
		return ply.showInfo
	end,
	playerName = function(ply, data, x, y, al1, al2, on)
		ply.showInfo = ply ~= lp and (ghost or seesGhosts or ply:GetRenderMode() ~= RENDERMODE_TRANSALPHA)
		if not ply.showInfo then return end

		local mask = ply:GetNetVar('hMask')
		if not admin and mask and CFG.masks[mask] and CFG.masks[mask].hideName then return end

		local ang2 = ply:GetAimVector()
		ang2.z = 0
		ang2:Normalize()

		local al = math.Clamp(1 - efwd:Dot(ang2) * 3, 0, 1)
		if al > 0 then
			surface.SetAlphaMultiplier(al * al1)

			local ty = on and y - al2 * (data.h + 5) or y
			local action = ply:GetNetVar('currentAction')
			if action then
				local y2 = ty - 22
				action = action .. ('.'):rep(math.floor(CurTime() * 5) % 4)
				draw.SimpleText(action, 'dbg-hud.small-sh', x, y2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(action, 'dbg-hud.small', x, y2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			local name = ply:Name()
			draw.Text {
				text = name,
				font = 'dbg-hud.normal-sh',
				pos = {x, ty - 3},
				color = colSh,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}
			draw.Text {
				text = name,
				font = 'dbg-hud.normal',
				pos = {x, ty - 3},
				color = colName,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}
		end
		data.nameAl = al
	end,
	playerDesc = function(ply, data, x, y, al1, al2)
		if not ply.showInfo then return end

		surface.SetAlphaMultiplier(al2)

		if data.mu then
			data.h = data.mu:GetHeight() / 2
			local my = y + 5 * al2
			data.mu:Draw(x, my, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 255 * al2)
		else
			local health, temp = ply:Health(), {}
			if health < 25 then
				temp[#temp + 1] = L.desc_nearly_dead
			elseif health < 60 then
				temp[#temp + 1] = L.desc_unhealthy_look
			end

			local time = ply:GetTimeTotal()
			if time < 18000 then
				temp[#temp + 1] = L.desc_newbie
			end

			if ply:GetNetVar('ScareState', 0) > 0.6 then
				temp[#temp + 1] = L.desc_scared
			end

			if ply:GetNetVar('Drunk') then
				temp[#temp + 1] = L.desc_drunk
			end

			if ply:GetNetVar('belted') then
				temp[#temp + 1] = '- Пристегнут'
			end

			local karma = ply:GetNetVar('dbg.karma', 0)
			if priest or admin then
				temp[#temp + 1] = L.desc_karma:format(karma)
			else
				if karma > 200 then
					temp[#temp + 1] = L.desc_has_to_itself
				elseif karma < -100 then
					temp[#temp + 1] = L.desc_looks_suspicious
				end
			end

			if admin then
				local note = ply:GetNetVar('watchList')
				if note then
					temp[#temp + 1] = L.desc_watchlist:format(note)
				end

				local time = ply:CheckCrimeDenied()
				if time == true then
					temp[#temp + 1] = L.desc_nocrime_perm
				elseif time then
					temp[#temp + 1] = L.desc_nocrime:format(octolib.time.formatIn(time))
				end
				local time = ply:CheckPoliceDenied()
				if time == true then
					temp[#temp + 1] = L.desc_nopolice_perm
				elseif time then
					temp[#temp + 1] = L.desc_nopolice:format(octolib.time.formatIn(time))
				end
			end

			local desc = ply:GetNetVar('dbgDesc')
			if desc and desc ~= '' then
				temp[#temp + 1] = '- ' .. desc
			elseif #temp == 0 then
				temp[#temp + 1] = L.desc_usual
			end

			data.mu = markup.Parse('<font=dbg-hud.small>' .. table.concat(temp, '\n') .. '</font>', 300)
		end
	end,
	corpseDesc = function(ent, data, x, y, al1, al2)
		surface.SetAlphaMultiplier(al2)

		if data.mu then
			data.h = data.mu:GetHeight() / 2
			local my = y + 5 * al2
			data.mu:Draw(x, my, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 255 * al2)
		else
			local temp, corpse = {}, getCorpse(ent)
			if not next(corpse) then return end

			if corpse.cause then
				temp[#temp + 1] = '- ' .. corpse.cause
			end

			if seesCaliber or admin then
				if corpse.bullet and corpse.weapon then
					temp[#temp + 1] = L.desc_caliber:format(corpse.weapon)
				end

			end

			if seesTime or admin then
				if corpse.time then
					temp[#temp + 1] = L.desc_time_death:format(corpse.time)
				end
			end

			if (seesName or admin) and corpse.name then
				temp[#temp + 1] = L.desc_its:format(corpse.name)
			end

			if admin and corpse.attacker then
				temp[#temp + 1] = L.desc_murderer:format(corpse.attacker)
			end

			data.mu = markup.Parse(('<font=dbg-hud.small>%s</font>'):format(table.concat(temp, '\n')), 250)
		end
	end,
	octoinv_item = function(ent, data, x, y, al1, al2)
		surface.SetAlphaMultiplier(al2)

		local data = ent:GetNetVar('Item')
		local isTable = istable(data[2])
		if (not ent.icon or not ent.name or not ent.amount) and data then
			ent.name = (isTable and data[2].name or octoinv.items[data[1]].name or L.unknown) % octoinv.getReplacementTable(data[2], data[1])
			ent.icon = isTable and data[2].icon and Material(data[2].icon) or octoinv.items[data[1]].icon or Material('octoteam/icons/error.png')
			ent.amount = isTable and data[2].amount or isnumber(data[2]) and data[2] or 1
		end

		draw.RoundedBox(4, x - 20, y - 20, 40, 40, colors.bg)
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(ent.icon)
		surface.DrawTexturedRect(x - 16, y - 16, 32, 32)

		-- local tAl = math.Clamp(350  - Vector(x,y,0):DistToSqr(Vector(ScrW()/2, ScrH()/2, 0)) / 100, 0, 255)
		draw.Text {
			text = ent.name,
			font = 'octoinv.3d-sh',
			pos = {x, y + 20},
			color = Color(0,0,0),
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_TOP,
		}
		draw.Text {
			text = ent.name,
			font = 'octoinv.3d',
			pos = {x, y + 20},
			color = Color(255,255,255),
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_TOP,
		}

		local left
		if isTable then
			data[2].class = data[1]
			left = octoinv.getItemUpperMO(data[2])
		end

		if left then
			local w = 10 + left:GetWidth()
			draw.RoundedBox(8, x + 18 - w / 2, y - 26, w, 16, Color(85,68,85))
			left:Draw(x + 20, y - 18, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		elseif ent.amount ~= 1 then
			local w = 16 + (string.len(ent.amount) - 1) * 6
			draw.RoundedBox(8, x + 18 - w / 2, y - 26, w, 16, colors.bg)
			draw.Text({
				text = ent.amount,
				font = 'octoinv.small',
				pos = { x + 18, y - 18 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				color = Color(255,255,255),
			})
		end

		surface.SetAlphaMultiplier(1 - al2)
	end,
}
