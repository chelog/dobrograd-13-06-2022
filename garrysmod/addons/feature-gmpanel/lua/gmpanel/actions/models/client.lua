local function updatePreview(preview)
	local mn, mx = preview.Entity:GetRenderBounds()
	local size = 0
	size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
	size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
	size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

	preview:SetFOV(22)
	preview:SetCamPos(Vector(size, size, size + 15))
	preview:SetLookAt((mn + mx) * 0.5)
end

local function dragMousePress(self)
	self.pressX = gui.MousePos()
	self.pressed = true
	self.dnr = true
end

local function dragMouseRelease(self) self.pressed = false end

local function layoutEntity(self, ent)
	if (self.pressed) then
		local mx = gui.MousePos()
		self.angles = self.angles - Angle(0, (self.pressX or mx) - mx, 0)
		self.pressX = gui.MousePos()
	elseif not self.dnr then
		self.angles = self.angles - Angle(0, 0.3, 0)
	end

	ent:SetAngles(self.angles)
end

gmpanel.actions.registerAction('models', {
	name = 'Модели',
	icon = 'octoteam/icons/man_m.png',
	openSettings = function(panel, data)

		local ply = LocalPlayer()

		local model = octolib.textEntry(panel, 'Модель:')
		model:SetText(data.model or ply:GetModel())
		model:SetUpdateOnType(true)
		panel.model = model

		local ext = panel:Add('DPanel')
		ext:Dock(TOP)
		ext:SetPaintBackground(false)
		ext:SetTall(300)

		local mdlBack = ext:Add('DPanel')
		mdlBack:Dock(LEFT)
		mdlBack:SetWide(175)

		local preview = mdlBack:Add('DModelPanel')
		preview:Dock(FILL)
		preview:SetAnimated(true)

		local sk, bg = data.skin or ply:GetSkin(), data.bodygroups
		if not bg then
			bg = {}
			for _,v in ipairs(ply:GetBodyGroups()) do
				bg[v.id] = ply:GetBodygroup(v.id)
			end
		end

		-- Hold to rotate
		preview.angles = Angle(0, 0, 0)
		preview.LayoutEntity = layoutEntity
		preview.DragMousePress = dragMousePress
		preview.DragMouseRelease = dragMouseRelease

		function preview:Refresh()
			self:SetModel(model:GetText())
			self.Entity:SetSkin(sk)
			for k,v in pairs(bg) do
				self.Entity:SetBodygroup(k, v)
			end
			updatePreview(preview)
		end
		preview:Refresh()

		local bgEdit = ext:Add('DScrollPanel')
		bgEdit:Dock(FILL)
		bgEdit:DockMargin(2, 0, 0, 0)
		function bgEdit:Refresh()

			self:Clear()

			local max = NumModelSkins(model:GetText()) - 1
			local sl = octolib.slider(self, 'Скин', 0, max, 0)
			function sl:OnValueChanged(v)
				sk = math.Round(v)
				preview:Refresh()
			end
			sl:SetValue(sk <= max and sk or preview.Entity:GetSkin())
			panel.skin = sl

			local curBgs = {}
			for _,v in ipairs(preview.Entity:GetBodyGroups()) do
				if v.num > 1 then
					curBgs[#curBgs + 1] = v.id
				end
			end

			if table.Count(octolib.table.diff(table.GetKeys(bg), curBgs)) > 0 then
				bg = {}
			else preview:Refresh() end

			panel.bodygroups = {}

			for _,v in ipairs(preview.Entity:GetBodyGroups()) do
				if v.num > 1 then
					local sl = octolib.slider(self, 'Аксессуар ' .. v.id, 0, v.num - 1, 0)
					sl:SetValue(bg[v.id] or preview.Entity:GetBodygroup(v.id))
					bg[v.id] = sl:GetValue()
					function sl:OnValueChanged(val)
						val = math.Round(val)
						if bg[v.id] ~= val then
							bg[v.id] = val
							preview:Refresh()
						end
					end
					panel.bodygroups[v.id] = sl
				end
			end
		end
		bgEdit:Refresh()

		function model:OnValueChange()
			bgEdit:Refresh()
		end

	end,
	getData = function(panel)
		return {
			model = panel.model:GetText(),
			skin = panel.skin:GetValue(),
			bodygroups = octolib.table.map(panel.bodygroups, function(bg) return bg:GetValue() end),
		}
	end,
})
