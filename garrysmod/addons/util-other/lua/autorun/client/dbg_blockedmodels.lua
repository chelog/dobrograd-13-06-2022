local frame
concommand.Add('dbg_blockedmodels', function()
	if not LocalPlayer():query('DBG: Редактировать blacklist пропов') then return end
	if IsValid(frame) then return frame:Remove() end

	local isBusy = false

	frame = vgui.Create 'DFrame'
	frame:SetSize(800, 800)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle('Список заблокированных моделей')

	local icons = frame:Add('DIconLayout')
	icons:Dock(FILL)

	local entry = octolib.textEntry(frame)
	entry:Dock(TOP)
	entry:DockMargin(5,5,5,10)
	entry:SetTall(20)
	entry:SetDrawLanguageID(false)
	entry:SetValue('')
	entry:SetPlaceholderText('Заблокировать модель')
	entry.PaintOffset = 5

	local iconRightClick
	local function updateData()
		netstream.Request('blockedModels.get'):Then(function(models)
			icons:Clear()
			for _, model in ipairs(models) do
				local icon = icons:Add('SpawnIcon')
				icon:SetSize(64, 64)
				icon:SetModel(model)
				icon.DoRightClick = iconRightClick
			end
		end)
	end

	iconRightClick = function(self)
		octolib.menu({
			{'Удалить', 'icon16/delete.png', function()
				if isBusy then return end

				isBusy = true
				netstream.Request('blockedModels.edit', self:GetModelName(), false):Then(function()
					isBusy = false
					updateData()
				end)
			end}
		}):Open()
	end

	function entry:OnEnter()
		if isBusy then return end

		isBusy = true
		netstream.Request('blockedModels.edit', entry:GetValue(), true):Then(function()
			isBusy = false
			updateData()
			self:SetValue('')
		end)
	end

	updateData()

end)
