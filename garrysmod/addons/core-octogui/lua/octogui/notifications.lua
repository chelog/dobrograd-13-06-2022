local noMessages = {
	'И рассказать-то нечего...',
	'Ты в курсе всех событий!',
	'Пока что ничего не происходило',
	'Здесь мы расскажем о важных событиях',
	'Пустовато в твоей ленте...',
}

local container
hook.Add('octogui.f4-tabs', 'octogui.notifications', function()

	octogui.addToF4({
		order = 0,
		id = 'notifications',
		name = 'Уведомления',
		icon = Material('octoteam/icons/megaphone.png'),
		build = function(f)
			f:SetSize(300, 500)
			f:SetSizable(true)
			f:SetMinWidth(300)
			f:SetMinHeight(200)

			local sp = f:Add 'DScrollPanel'
			sp:Dock(FILL)
			container = sp
			container.pendingUpdate = true

			local function lock(doLock)
				for _, but in ipairs(container.actButtons) do
					if IsValid(but) then but:SetEnabled(not doLock) end
				end
			end

			local function actionClick(but)
				lock(true)

				netstream.Request('octolib-notify.read', but.notifID, but.actID):Then(function(remove)
					if remove then
						table.remove(octolib.notify.cache, but.notifID)
						F4:SetCounter('notifications', #octolib.notify.cache)
						container.pendingUpdate = true
					end
				end):Finally(function()
					lock(false)
				end)
			end

			function container:Think()
				if not container.pendingUpdate then return end
				container.pendingUpdate = nil

				container:Clear()
				container.actButtons = {}

				if #octolib.notify.cache > 0 then
					container.Paint = octolib.func.zero
					for notifID, notif in ipairs(octolib.notify.cache) do
						local text, date, buttons = unpack(notif)
						if not buttons or #buttons < 1 then
							buttons = { 'Понятно' }
						end

						local p = self:Add 'DPanel'
						p:Dock(TOP)
						p:DockMargin(0, 0, 0, 5)
						p:DockPadding(5, 5, 5, 5)

						local l = p:Add 'DMarkup'
						l:Dock(TOP)
						l:SetText(text)

						local bp = p:Add 'DPanel'
						bp:Dock(BOTTOM)
						bp:SetTall(20)
						bp:SetPaintBackground(false)

						if date then
							local d = bp:Add 'DLabel'
							d:Dock(LEFT)
							d:SetText(os.date('%d %b, %H:%M', date))
							d:SizeToContentsX()
							d:SetContentAlignment(3)
							d:SetAlpha(75)
						end

						local sorted = octolib.table.toKeyVal(buttons)
						table.sort(sorted, function(a, b) return a[1] > b[1] end)

						for _, data in ipairs(sorted) do
							local but = bp:Add 'DButton'
							but:Dock(RIGHT)
							but:DockMargin(5, 0, 0, 0)
							but:SetText(data[2])
							but:SizeToContentsX(14)
							but.notifID = notifID
							but.actID = data[1]
							but.DoClick = actionClick
							container.actButtons[#container.actButtons + 1] = but
						end

						function p:PerformLayout()
							self:SetTall(l:GetTall() + 35)
						end
					end
				else
					container.text = table.Random(noMessages)
					function container:Paint(w, h)
						draw.Text {
							text = self.text,
							pos = { w / 2, h / 2 },
							xalign = TEXT_ALIGN_CENTER,
							yalign = TEXT_ALIGN_CENTER,
						}
					end
				end
			end
		end,
		show = function(f, st)
			if st then f:AlignBottom(70) end
		end,
	})

	F4:SetCounter('notifications', #octolib.notify.cache)

end)

hook.Add('octolib.notify.cacheUpdate', 'octogui.notifications', function()

	F4:SetCounter('notifications', #octolib.notify.cache)

	if IsValid(container) then
		container.pendingUpdate = true
	end

end)
