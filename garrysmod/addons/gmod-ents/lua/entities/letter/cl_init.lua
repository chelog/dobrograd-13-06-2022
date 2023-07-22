include('shared.lua')

surface.CreateFont('dbg-write', {
	font = 'Cambria',
	extended = true,
	size = 20,
	weight = 500,
})

local frame, editFrame

function ENT:Draw()
	self:DrawModel()
end

netstream.Hook('dbg-write', function(letter, action, data)

	if action == 'use' then
		gui.EnableScreenClicker(true)

		local menu = DermaMenu()
		menu:AddOption(L.read, function()
			netstream.Start('dbg-write', letter, 'read', { false })
		end):SetImage(octolib.icons.silk16('report_magnify'))
		menu:AddOption(L.change, function()
			netstream.Start('dbg-write', letter, 'read', { true })
		end):SetImage(octolib.icons.silk16('report_edit'))

		local signed = letter:GetNetVar('Signed') == LocalPlayer()
		menu:AddOption(signed and L.remove_sign or L.add_sign, function()
			netstream.Start('dbg-write', letter, 'sign', { not signed })
		end):SetImage(octolib.icons.silk16('digital_signature_pen'))

		if data[1] then
			menu:AddOption(L.freeze, function()
				netstream.Start('dbg-write', letter, 'freeze', { false })
			end):SetImage(octolib.icons.silk16('arrow_down'))
		else
			menu:AddOption(L.unfreeze, function()
				netstream.Start('dbg-write', letter, 'freeze', { true })
			end):SetImage(octolib.icons.silk16('arrow_up'))
		end

		if not IsValid(letter:GetNetVar('IsFor')) then
			local plys = player.GetAll()
			table.sort(plys, function(a, b) return a:Name() < b:Name() end)

			if #plys > 1 then
				local sm, pmo = menu:AddSubMenu(L.write_give)
				for _, ply in ipairs(plys) do
					if ply ~= LocalPlayer() then
						sm:AddOption(ply:Name(), function()
							netstream.Start('dbg-write', letter, 'give', { ply })
						end)
					end
				end
				pmo:SetImage(octolib.icons.silk16('report_go'))
			end
		else
			menu:AddOption(L.cancel_give, function()
				netstream.Start('dbg-write', letter, 'give', {})
			end):SetImage(octolib.icons.silk16('report_delete'))
		end

		menu:AddOption(L.write_destroy, function()
			netstream.Start('dbg-write', letter, 'destroy')
		end):SetImage(octolib.icons.silk16('bin'))

		menu:Center()
		menu:Open()

		gui.EnableScreenClicker(false)
	elseif action == 'read' then
		local letterMsg = data[1] or ''
		if data[2] then
			if IsValid(editFrame) then editFrame:Remove() end

			editFrame = vgui.Create 'DFrame'
			editFrame:SetSize(600,600)
			editFrame:SetTitle(L.change_letter)
			editFrame:Center()
			editFrame:MakePopup()

			local b = editFrame:Add 'DButton'
			b:SetText(L.save)
			b:Dock(BOTTOM)
			b:SetTall(30)

			local e = editFrame:Add 'DTextEntry'
			e:Dock(FILL)
			e:SetMultiline(true)
			e:SetContentAlignment(7)
			e:SetValue(letterMsg)

			function b:DoClick()
				editFrame:Remove()
				netstream.Start('dbg-write', letter, 'edit', { e:GetValue() })
			end
		else
			if IsValid(frame) then frame:Remove() end

			frame = vgui.Create('DPanel')
			frame:SetPaintBackground(false)
			frame.letter = letter
			frame:Dock(FILL)
			frame:MakePopup()

			local killBut = vgui.Create('DButton', frame)
			killBut:SetText(L.close)
			killBut:SetPos((ScrW() - 256) / 2, 15)
			killBut:SetSize(256, 64)
			function killBut:DoClick()
				frame:Remove()
			end

			local scrPan = frame:Add('DScrollPanel')
			scrPan:SetPos(ScrW() * .2, ScrH() * 0.3)
			scrPan:SetSize(ScrW() * .6, ScrH() * 0.84)

			local textWrap = scrPan:Add('DPanel')
			textWrap:Dock(TOP)

			local ltr = markup.Parse('<font=dbg-write><color=0,0,0>' .. letterMsg .. '</color></font>', ScrW() * .6 - 100)
			local textH = ltr:GetHeight()
			textWrap:SetTall(math.max(ScrH() * 0.84, textH + 200))

			function textWrap:Paint(w, h)
				draw.RoundedBox(8, 0, 0, w, h, color_white)
				local x, y = self:GetPos()
				ltr:Draw(x + 50, y + 50, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

				local signed = letter:GetNetVar('Signed')
				if IsValid(signed) then
					local name
					local customJob = signed:GetNetVar('customJob')
					if customJob then
						name = customJob[1]
					else
						local job = DarkRP.getJobByCommand(signed:GetNetVar('dbg-police.job', '')) or signed:getJobTable()
						name = job.name
					end
					draw.DrawNonParsedText(
						L.write_sign .. name .. ', ' .. signed:Name(),
						'dbg-write',
						w * .5 + 50,
						textH + 100,
						Color(0, 0, 0),
						0
					)
				end
			end

			scrPan:SetAlpha(0)
			scrPan:AlphaTo(255, 0.5, 0)
			scrPan:MoveBy(0, -ScrH() * .15, 0.5, 0)

		end
	end

end)
