octolib.dataEditor = octolib.dataEditor or {}

octolib.dataEditor.registered = octolib.dataEditor.registered or {}

-- TODO: optimize saving by updating single row?
function octolib.dataEditor.register(id, data)
	octolib.dataEditor.registered[id] = data
end

function octolib.dataEditor.open(dataOrID)
	local editor = istable(dataOrID) and dataOrID or octolib.dataEditor.registered[dataOrID or '']
	if not editor then return end
	override = istable(override) and override or {}

	local cache = {}

	local f = vgui.Create 'DFrame'
	f:SetSize(350, 500)
	f:Center()
	f:MakePopup()
	f:SetTitle(override.name or editor.name or 'Редактирование данных')

	local mp = f:Add 'DPanel'
	mp:Dock(FILL)
	mp:DockMargin(0, 0, 0, 0)
	mp:DockPadding(0, 0, 0, 0)
	mp:SetPaintBackground(false)

	local l = mp:Add 'DListView'
	l:Dock(FILL)
	local columns = override.columns or editor.columns or {{ field = '_id', name = 'ID' }}
	for _, col in ipairs(columns) do
		local c = l:AddColumn(col.name)
		if col.width then c:SetFixedWidth(col.width) end
	end

	local function updateList()
		l:Clear()
		for id, row in ipairs(cache) do
			local data = octolib.table.mapSequential(columns, function(v) return row[v.field] end)
			local line = l:AddLine(unpack(data))
			line.rowID = id
			line.row = row
		end
	end

	local loadFunc = override.load or editor.load
	local function load()
		loadFunc(function(rows)
			cache = rows
			updateList()
		end)
	end

	l:AddLine('Загрузка...')
	load()

	local editFunc = override.edit or editor.edit
	local saveFunc = override.save or editor.save
	local function edit(row, id)
		editFunc(row, function(data)
			if data then
				cache[id] = data
			else
				table.remove(cache, id)
			end

			saveFunc(cache)
			updateList()
		end)
	end

	function l:DoDoubleClick(i, line)
		edit(line.row, line.rowID)
	end

	function l:OnRowRightClick(i, line)
		octolib.menu({
			{'Изменить', 'icon16/pencil.png', function()
				edit(line.row, line.rowID)
			end},
			{'Экспорт', 'icon16/page_go.png', function()
				SetClipboardText(pon.encode(line.row))
				Derma_Message('Код скопирован, теперь ты можешь его куда-нибудь вставить', 'Успех', 'Понятно')
			end},
			{'Удалить', 'icon16/delete.png', function()
				table.remove(cache, line.rowID)
				saveFunc(cache)
				updateList()
			end},
		}):Open()
	end

	local bp = mp:Add 'DPanel'
	bp:Dock(TOP)
	bp:DockMargin(0, 0, 0, 5)
	bp:SetTall(25)
	bp:SetPaintBackground(false)

	local newFunc = override.new or editor.new
	local bNew = octolib.button(bp, 'Создать', function()
		newFunc(function(data)
			if not data then return end

			table.insert(cache, data)

			saveFunc(cache)
			updateList()
		end)
	end)
	bNew:Dock(RIGHT)
	bNew:DockMargin(5, 0, 0, 0)
	bNew:SizeToContentsX(20)

	local validateFunc = override.validate or editor.validate
	local bImport = octolib.button(bp, 'Импорт', octolib.fStringRequest('Импорт данных', 'Вставь код, полученный при экспорте', '', function(s)
		local ok, data = pcall(pon.decode, s)
		if ok and (not validateFunc or validateFunc(data)) then
			table.insert(cache, data)
			saveFunc(cache)
			updateList()
		else
			Derma_Message('Не получилось расшифровать код, проверь, правильно ли ты его скопировал', 'Ошибка', 'Понятно')
		end
	end))
	bImport:Dock(RIGHT)
	bImport:DockMargin(5, 0, 0, 0)
	bImport:SizeToContentsX(20)

	local bRefresh = octolib.button(bp, 'Обновить', load)
	bRefresh:Dock(LEFT)
	bRefresh:DockMargin(0, 0, 5, 0)
	bRefresh:SizeToContentsX(20)

	return {
		frame = f,
		panel = mp,
		getCache = function()
			return cache
		end,
	}
end

-- debug
-- concommand.Add('octolib_data', function(ply, cmd, args, argStr)
-- 	local editor = octolib.dataEditor.registered[argStr or '']
-- 	if not editor then return print('Такого редактора не существует') end

-- 	octolib.dataEditor.open(argStr)
-- end, function(cmd, argStr)
-- 	return octolib.table.mapSequential(table.GetKeys(octolib.dataEditor.registered), function(key)
-- 		return key:find(argStr:Trim()) and ('octolib_data ' .. key) or nil
-- 	end)
-- end)
