surface.CreateFont('dbg-lockpick.normal', {
	font = 'Calibri',
	extended = true,
	size = 24,
	weight = 350,
})

local txtHint = ([[Подними все пины[n]и поверни цилиндр[n][n]Мышь - двигать отмычку[n]ЛКМ - повернуть цилиндр[n]ПКМ - отменить взлом]]):gsub('%[n%]', string.char(10))

local colBarrelBG, colBarrelFG = Color(150,150,150), Color(50,50,50)
local colors = CFG.skinColors
netstream.Hook('dbg-lockpick', function(ent, key, data)

	local function clear()
		hook.Remove('HUDPaint', 'dbg-lockpick')
		hook.Remove('Think', 'dbg-lockpick')
		hook.Remove('RenderScreenspaceEffects', 'dbg-lockpick')
		hook.Remove('InputMouseApply', 'dbg-lockpick')
		hook.Remove('CreateMove', 'dbg-lockpick')
		hook.Remove('dbg-view.chPaint', 'dbg-lockpick')
		timer.Remove('dbg-lockpick')
	end

	if ent then
		local bNum, bTime, bWidth, bSpace = data.num or 5, data.time or 0.75, data.width or 25, data.space or 40
		local x, nextPush = 0, RealTime()
		local lmbReleased = false
		local xmax = bNum * bSpace / 2
		local xmin = -xmax

		local barrels = {}
		for i = 1, bNum do
			local bxmin = xmin + (i - 1) * bSpace + (bSpace - bWidth) / 2
			barrels[i] = {
				xmin = bxmin,
				xmax = bxmin + bWidth,
				time = i * bTime,
				st = 0,
			}
		end

		-- make barrels shuffle specific to this entity
		math.randomseed(ent:EntIndex())
		for i = 1, bNum do
			local b1, b2 = barrels[i], barrels[math.random(bNum)]
			b1.time, b2.time = b2.time, b1.time
		end
		math.randomseed(CurTime())

		local function succ()
			local resp = ''
			for c in string.gmatch(key, '.') do
				resp = resp .. string.char(string.byte(c) + 8)
			end

			netstream.Start('dbg-lockpick', ent, resp)
		end

		local function fail()
			netstream.Start('dbg-lockpick', ent, '')
		end

		local function drawPick(x, y)

			x, y = math.floor(x), math.floor(y)
			draw.NoTexture()
			surface.SetDrawColor(150, 150, 150)
			surface.DrawRect(x - 1, y, 4, 8)
			surface.DrawPoly({
				{ x = x - 1, y = y + 10 },
				{ x = x - 1, y = y + 6 },
				{ x = x + 201, y = y + 4 },
				{ x = x + 201, y = y + 12 },
			})
			surface.DrawRect(x + 200, y, 100, 16)

		end

		local totalW = bNum * bSpace
		local colBG, bgX, bgY, bgW, bgH = Color(255,255,255, 10), (ScrW() - totalW) / 2 - 5, ScrH() / 2 - 110, totalW + 10, 190
		hook.Add('HUDPaint', 'dbg-lockpick', function()

			draw.RoundedBox(8, bgX, bgY, bgW, bgH, colBG)

			local cx, cy = ScrW() / 2, ScrH() / 2
			for i = 1, bNum do
				local b = barrels[i]
				draw.RoundedBox(4, cx + b.xmin, cy - 100, bWidth, 150, colBarrelBG)
				draw.RoundedBox(2, cx + b.xmin + 1, cy - b.st * 98 - 1, bWidth - 2, 50, colBarrelFG)
			end

			local y = cy + 60
			if RealTime() < nextPush then
				y = y - (nextPush - RealTime()) / 0.3 * 16
			end
			drawPick(cx + x, y)

			draw.DrawText(txtHint, 'dbg-lockpick.normal', cx + totalW / 2 + 20, cy - 95, color_white, TEXT_ALIGN_LEFT)

		end)
		local lastTime = nil
		hook.Add('Think', 'dbg-lockpick', function()

			for i = 1, bNum do
				local b = barrels[i]
				if b.st > 0 then
					local delta = CurTime() - (lastTime or CurTime()) -- a fix timescale exploit
					b.st = math.Approach(b.st, 0, delta / b.time)
				end
			end
			lastTime = CurTime()

		end)

		local suspicion = 0
		local xSum, ySum = 0, 0
		timer.Create('dbg-lockpick', 0.5, 0, function()
			if (xSum ~= 0 and ySum == 0) or (xSum == 0 and ySum ~= 0) then
				suspicion = suspicion + 1
			elseif xSum ~= 0 or ySum ~= 0 then
				suspicion = math.max(suspicion - 1, 0)
			end

			if suspicion > 3 then
				clear()
				netstream.Start('dbg-lockpick.exploit')
			end

			xSum, ySum = 0, 0
		end)

		local sens = GetConVar('sensitivity'):GetFloat()
		hook.Add('InputMouseApply', 'dbg-lockpick', function(cmd, _x, _y)

			local pushed = false
			if RealTime() > nextPush and lmbReleased then
				local clamp = FrameTime() * 7500
				_x = math.Clamp(_x, -clamp, clamp)
				x = math.Clamp(x + _x * sens / 50, xmin, xmax)
				if -_y / FrameTime() > 3000 then
					local b
					for i = 1, bNum do
						local _b = barrels[i]
						if x > _b.xmin and x < _b.xmax then b = _b break end
					end
					if not b then
						fail()
					else
						b.st = 1
					end

					netstream.Start('dbg-lockpick.push')
					nextPush = RealTime() + 0.3
					pushed = true
				end
			end

			if math.abs(_x) > 0.0001 then xSum = xSum + _x end
			if math.abs(_y) > 0.0001 and not pushed then ySum = ySum + _y end

			cmd:SetMouseX(0)
			cmd:SetMouseY(0)

			return true

		end)

		hook.Add('CreateMove', 'dbg-lockpick', function(cmd)

			if not cmd:KeyDown(IN_ATTACK) then
				lmbReleased = true
			end
			if cmd:KeyDown(IN_ATTACK) and RealTime() > nextPush and lmbReleased then
				local ok = true
				for i = 1, bNum do
					local b = barrels[i]
					if b.st <= 0 then ok = false break end
				end
				if ok then
					succ()
					hook.Remove('Think', 'dbg-lockpick')
					hook.Remove('InputMouseApply', 'dbg-lockpick')
					hook.Remove('CreateMove', 'dbg-lockpick')
					timer.Remove('dbg-lockpick')
				else
					fail()
				end
				nextPush = RealTime() + 0.3
			end

			if cmd:KeyDown(IN_ATTACK2) then
				netstream.Start('dbg-lockpick', nil)
			end

			cmd:RemoveKey(IN_ATTACK)
			cmd:RemoveKey(IN_ATTACK2)
			cmd:ClearMovement()

		end)

		local blur = Material('pp/blurscreen')
		hook.Add('RenderScreenspaceEffects', 'dbg-lockpick', function()

			local a = 1
			if a > 0 then
				local colMod = {
					['$pp_colour_addr'] = 0,
					['$pp_colour_addg'] = 0,
					['$pp_colour_addb'] = 0,
					['$pp_colour_mulr'] = 0,
					['$pp_colour_mulg'] = 0,
					['$pp_colour_mulb'] = 0,
					['$pp_colour_brightness'] = -a * 0.2,
					['$pp_colour_contrast'] = 1 + 0.5 * a,
					['$pp_colour_colour'] = 1 - a,
				}

				if GetConVar('octolib_blur'):GetBool() then
					DrawColorModify(colMod)

					surface.SetDrawColor(255, 255, 255, a * 255)
					surface.SetMaterial(blur)

					for i = 1, 3 do
						blur:SetFloat('$blur', a * i * 2)
						blur:Recompute()

						render.UpdateScreenEffectTexture()
						surface.DrawTexturedRect(-1, -1, ScrW() + 2, ScrH() + 2)
					end
				else
					colMod['$pp_colour_brightness'] = -0.4 * a
					colMod['$pp_colour_contrast'] = 1 + 0.2 * a
					DrawColorModify(colMod)
				end

				local col = colors.bg
				draw.NoTexture()
				surface.SetDrawColor(col.r, col.g, col.b, a * 100)
				surface.DrawRect(-1, -1, ScrW() + 1, ScrH() + 1)
			end

		end)
	else
		clear()
	end

end)
