local running = {}
hook.Add('Think', 'octolib-anim.flexUpdate', function()

	local ct = CurTime()
	for ply, data in pairs(running) do
		if IsValid(ply) then
			local frac = math.EaseInOut(math.Clamp(math.TimeFraction(data.start, data.finish, ct), 0, 1), 0.7, 0.7)
			for flexID, weight in pairs(data.tgt) do
				local curWeight = Lerp(frac, data.old[flexID] or 0, weight)
				ply:SetFlexWeight(flexID, curWeight)
			end
			if ct > data.finish then running[ply] = nil end
		else
			running[ply] = nil
		end
	end

end)

local ply = FindMetaTable 'Player'

function ply:ApplyFlex(flexes, time)

	local old = {}
	local tgt = {}

	for i = 0, self:GetFlexNum() - 1 do
		old[i] = self:GetFlexWeight(i) or 0
		tgt[i] = 0
	end

	for flexID, weight in pairs(flexes or {}) do
		tgt[flexID] = weight
	end

	for flexID, weight in pairs(tgt) do
		if old[flexID] == weight then
			old[flexID] = nil
			tgt[flexID] = nil
		end
	end

	self.octolib_flexes = tgt

	running[self] = {
		old = old,
		tgt = tgt,
		start = CurTime(),
		finish = CurTime() + (time or 0),
	}

end

netstream.Hook('player-flex', function(ply, flexes)

	if not IsValid(ply) then return end
	ply:ApplyFlex(flexes, 0.4)

end)

local defaultEmotions = {
	{
		name = 'Улыбка',
		flexes = { [10] = 0.81, [11] = 0.8, [12] = 0.53, [13] = 0.53, [16] = 0.6, [17] = 0.7, [18] = 1.0, [19] = 0.22, [22] = 0.84, [23] = 0.61, [33] = 0.66, [34] = 0.67, [37] = 0.54 },
	}, {
		name = 'Удивление',
		flexes = { [10] = 1.0, [11] = 1.0, [19] = 0.41, [27] = 0.15, [28] = 0.15, [33] = 0.01, [37] = 0.24, [39] = 0.28, [40] = 0.16, [41] = 0.17 },
	}, {
		name = 'Грусть',
		flexes = { [10] = 0.84, [11] = 0.85, [16] = 1.0, [17] = 1.0, [18] = 0.98, [19] = 0.38, [24] = 0.39, [25] = 0.42, [26] = 1.0 },
	}, {
		name = 'Недоверие',
		flexes = { [11] = 0.07, [12] = 0.01, [13] = 1.0, [14] = 1.0, [16] = 0.6, [18] = 0.59, [19] = 0.14, [20] = 0.6, [24] = 0.47, [26] = 0.63, [33] = 1.0, [37] = 0.28, [38] = 0.63 },
	}, {
		name = 'Угрюмость',
		flexes = { [14] = 1.0, [15] = 1.0, [19] = 0.53, [26] = 0.75, [37] = 0.48, [38] = 0.6 },
	}, {
		name = 'Злость',
		flexes = { [14] = 1.0, [15] = 1.0, [18] = 0.99, [20] = 0.3, [21] = 0.3, [24] = 0.95, [25] = 0.97, [26] = 0.85, [27] = 0.05 },
	}
}

octolib.vars.init('faceposes', defaultEmotions)

local function openEditor(save, data)

	local f = vgui.Create 'DFrame'
	f:SetSize(600, 600)
	f:Center()
	f:MakePopup()
	f:SetTitle('Редактирование эмоции')

	local poser = f:Add 'octolib_faceposer'
	poser:CopyEntity(LocalPlayer())
	if data then poser:Import(data.flexes) end

	local name = octolib.textEntry(f)
	name:DockMargin(5, 5, 5, 10)
	name:SetTall(15)
	name:SetPlaceholderText('Название')
	name.PaintOffset = 5
	if data then name:SetValue(data.name) end

	if save then
		local bp = f:Add 'DPanel'
		bp:Dock(BOTTOM)
		bp:DockMargin(0, 5, 0, 0)
		bp:SetTall(25)
		bp:SetPaintBackground(false)

		local bSave = octolib.button(bp, 'Сохранить', function()
			save({
				name = name:GetValue(),
				flexes = poser:Export(),
			})
			f:Close()
		end)
		bSave:Dock(RIGHT)
		bSave:DockMargin(5, 0, 0, 0)
		bSave:SizeToContentsX(20)

		local bPresets = octolib.button(bp, 'Шаблоны', function()
			octolib.menu(octolib.table.mapSequential(defaultEmotions, function(row) return {
				row.name, nil, function() poser:Import(row.flexes) end,
			} end)):Open()
		end)
		bPresets:Dock(RIGHT)
		bPresets:DockMargin(5, 0, 0, 0)
		bPresets:SizeToContentsX(20)

		local bDelete = octolib.button(bp, 'Удалить', function()
			save(nil)
			f:Close()
		end)
		bDelete:Dock(LEFT)
		bDelete:DockMargin(0, 0, 5, 0)
		bDelete:SizeToContentsX(20)
	end

end

octolib.dataEditor.register('faceposes', {
	name = 'Эмоции',
	columns = {
		{ field = 'name', name = 'Название' },
	},
	load = function(load)
		load(octolib.vars.get('faceposes') or defaultEmotions)
	end,
	save = function(rows)
		octolib.vars.set('faceposes', rows)
	end,
	new = function(save)
		openEditor(save)
	end,
	edit = function(row, save)
		openEditor(save, row)
	end,
	validate = function(row)
		return isstring(row.name) and string.Trim(row.name) ~= '' and istable(row.flexes)
	end,
})
