concommand.Add('octologs_display', function(ply, cmd, args, argStr)

	local cache = {}

	local w = vgui.Create 'DFrame'
	w:SetTitle('Octologs Display')
	w:SetSize(200, 400)
	w:AlignBottom(10)
	w:AlignLeft(10)

	local l = w:Add 'DListView'
	l:Dock(FILL)
	l:AddColumn(L.title)
	l:AddColumn(L.position)
	l:AddColumn(L.angle)

	function l:Rebuild()
		self:Clear()
		for i, data in ipairs(cache) do
			local title, pos, ang = unpack(data)
			local line = self:AddLine(
				title,
				('[%s %s %s]'):format(pos.x, pos.y, pos.z),
				('{%s %s %s}'):format(ang.p, ang.y, ang.r)
			)

			line.id = i
		end
	end

	function l:OnRowRightClick(i, line)
		local m = DermaMenu()
		m:AddOption(L.teleport, function()
			local data = cache[line.id]
			netstream.Start('octologs.goto', data[2], data[3])
		end)
		m:AddOption(L.delete, function()
			local data = cache[line.id]
			if data then
				local mdl = data[4]
				if IsValid(mdl) then mdl:Remove() end
				table.remove(cache, line.id)
				l:Rebuild()
			end
		end)
		m:Open()
	end

	local b = w:Add 'DButton'
	b:Dock(BOTTOM)
	b:SetTall(20)
	b:SetText(L.add)
	function b:DoClick()
		octolib.request.open({{
			required = true,
			type = 'strShort',
			name = 'Название',
			default = 'Позиция ' .. #cache + 1,
		}, {
			required = true,
			type = 'strShort',
			name = 'Локация',
			default = '[0 0 0]{0 0 0}',
		}}, function(data)
			if not data then return end
			local posStr = data[2]:gmatch('%[(.-)%]')()
			local angStr = data[2]:gmatch('%{(.-)%}')()
			if not posStr or not angStr then return end

			local pos = Vector(posStr)
			local ang = Angle(angStr)
			if not isvector(pos) or not isangle(ang) then return end

			local mdl = octolib.createDummy('models/dav0r/camera.mdl')
			mdl:SetPos(pos)
			mdl:SetAngles(ang)

			cache[#cache + 1] = { data[1], pos, ang, mdl }
			l:Rebuild()
		end)
	end

	hook.Add('HUDPaint', 'draw-positions', function()
		for i, data in ipairs(cache) do
			local pos = data[2]:ToScreen()
			local x, y = pos.x, pos.y
			draw.RoundedBox(0, x - 3, y - 3, 6, 6, color_black)
			draw.RoundedBox(0, x - 2, y - 2, 4, 4, color_white)
			draw.SimpleText(data[1], 'DermaDefault', x, y + 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
	end)

	function w:OnClose()
		for i, data in ipairs(cache) do
			local mdl = data[4]
			if IsValid(mdl) then mdl:Remove() end
		end

		cache = nil
		hook.Remove('HUDPaint', 'draw-positions')
	end

end)
