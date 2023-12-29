concommand.Add('octolib_tool_poslist', function(ply, cmd, args, argStr)
	if not CFG.dev and not LocalPlayer():IsSuperAdmin() then return end

	local cache = {}

	local w = vgui.Create 'DFrame'
	w:SetSize(200, 400)
	w:AlignBottom(10)
	w:AlignLeft(10)
	w:SetTitle('Редактор позиций')

	local l = w:Add 'DListView'
	l:Dock(FILL)
	l:AddColumn('ID'):SetFixedWidth(20)
	l:AddColumn(L.position)
	function l:Rebuild()
		self:Clear()
		for i, v in ipairs(cache) do
			local line = self:AddLine(i, ('X:%s Y:%s Y:%s'):format(v.x, v.y, v.z))
			line.id = i
		end
	end
	function l:OnRowRightClick(i, line)
		local m = DermaMenu()
		m:AddOption(L.delete, function()
			table.remove(cache, line.id)
			l:Rebuild()
		end)
		m:Open()
	end

	local function roundVector(pos)

		pos.x = math.Round(pos.x)
		pos.y = math.Round(pos.y)
		pos.z = math.Round(pos.z)

		return pos

	end

	local b = w:Add 'DButton'
	b:Dock(BOTTOM)
	b:SetTall(20)
	b:SetText(L.menu)
	function b:DoClick()
		octolib.menu({
			{'Экспорт', nil, function()
				local res = ''
				for i, v in ipairs(cache) do
					res = res .. ('Vector(%s, %s, %s),\n'):format(v.x, v.y, v.z)
				end
				SetClipboardText(res)
			end},
			{'Импорт', nil, octolib.fStringRequest('Импорт позиций', 'Вставь текст, полученный при экспорте', '', function(text)
				for s in string.gmatch(text, 'Vector%((.-)%)') do
					table.insert(cache, roundVector(Vector(s:gsub(',', ''))))
				end
				l:Rebuild()
			end)},
			{'Очистить', nil, function()
				table.Empty(cache)
				l:Rebuild()
			end},
		}):Open()
	end

	local b = w:Add 'DButton'
	b:Dock(BOTTOM)
	b:SetTall(20)
	b:SetText(L.position_camera)
	function b:DoClick()
		table.insert(cache, roundVector(EyePos()))
		l:Rebuild()
	end

	local b = w:Add 'DButton'
	b:Dock(BOTTOM)
	b:SetTall(20)
	b:SetText(L.position_player)
	function b:DoClick()
		table.insert(cache, roundVector(LocalPlayer():GetPos()))
		l:Rebuild()
	end

	hook.Add('HUDPaint', 'draw-positions', function()
		for i, v in ipairs(cache) do
			local pos = v:ToScreen()
			local x, y = pos.x, pos.y
			draw.RoundedBox(0, x - 3, y - 3, 6, 6, color_black)
			draw.RoundedBox(0, x - 2, y - 2, 4, 4, color_white)
			draw.SimpleText(i, 'DermaDefault', x, y + 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
	end)

	function w:OnClose()
		cache = nil
		hook.Remove('HUDPaint', 'draw-positions')
	end
end)