octolib.registerBindHandler('anim', {
	name = 'Запустить анимацию',
	run = function(data)
		if not istable(data) then return end

		local catID, animID = unpack(data)
		if catID == '_emotions' then
			local row = (octolib.vars.get('faceposes') or {})[animID]
			netstream.Start('player-flex', row and row.flexes or {})
		else
			netstream.Start('player-anim', catID, animID)
		end
	end,
	buildBinder = function(cont, bindID, bind)
		cont:SetTall(25)

		local but = octolib.button(cont, 'Неизвестная анимация', function(self)
			local opts = {}
			for catID, cat in SortedPairsByMemberValue(octolib.animations, 'order') do
				if not cat.hide then
					local catOpts = { cat.name, nil, {} }
					for animID, anim in ipairs(cat.anims) do
						table.insert(catOpts[3], { anim[1], nil, function()
							octolib.setBind(bindID, bind.button, bind.action, { catID, animID }, bind.on)
						end })
					end
					table.insert(opts, catOpts)
				end
			end

			local rows = octolib.table.mapSequential(octolib.vars.get('faceposes') or {}, function(v, i) return { name = v.name, id = i } end)
			table.insert(rows, 1, { name = 'Нейтральность', id = -1 })

			table.insert(opts, { 'Эмоции', nil, octolib.table.mapSequential(rows, function(row)
					return { row.name, nil, function()
						octolib.setBind(bindID, bind.button, bind.action, { '_emotions', row.id }, bind.on)
					end }
				end),
			})

			octolib.menu(opts):Open()
		end)


		local catID, animID = unpack(istable(bind.data) and bind.data or {})
		if catID == '_emotions' then
			if animID == -1 then
				but:SetText('Нейтральность')
			else
				local row = (octolib.vars.get('faceposes') or {})[animID]
				if row then but:SetText(row.name) end
			end
		else
			local anim = catID and animID and octolib.animations[catID] and octolib.animations[catID].anims[animID]
			if anim then but:SetText(anim[1]) end
		end
	end,
})

octolib.registerBindHandler('anim-cat', {
	name = 'Меню анимаций',
	run = function(data)
		if not data then return end

		local opts = {}
		if data == '_emotions' then
			table.insert(opts, { 'Нейтральность', nil, function() netstream.Start('player-flex', {}) end })
			for _, row in ipairs(octolib.vars.get('faceposes') or {}) do
				table.insert(opts, { row.name, nil, function()
					netstream.Start('player-flex', row.flexes)
				end })
			end
		else
			if not octolib.animations[data] then return end
			for animID, anim in ipairs(octolib.animations[data].anims) do
				table.insert(opts, { anim[1], nil, function()
					netstream.Start('player-anim', data, animID)
				end })
			end
		end

		octogui.circularMenu(opts)
	end,
	buildBinder = function(cont, bindID, bind)
		cont:SetTall(25)

		local but = octolib.button(cont, 'Неизвестная категория', function(self)
			local opts = {}
			for catID, cat in SortedPairsByMemberValue(octolib.animations, 'order') do
				if not cat.hide then
					table.insert(opts, { cat.name, nil, function()
						octolib.setBind(bindID, bind.button, bind.action, catID, bind.on)
					end })
				end
			end
			table.insert(opts, { 'Эмоции', nil, function()
				octolib.setBind(bindID, bind.button, bind.action, '_emotions', bind.on)
			end })
			octolib.menu(opts):Open()
		end)

		local cat = octolib.animations[bind.data]
		if cat then
			but:SetText(cat.name)
		elseif bind.data == '_emotions' then
			but:SetText('Эмоции')
		end
	end,
})
