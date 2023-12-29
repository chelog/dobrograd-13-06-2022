function octolib.devtools.bones(ent, bones)

	if not CFG.dev and not LocalPlayer():IsSuperAdmin() then return end

	if not bones then return end

	local w = vgui.Create 'DFrame'
	w:SetSize(300, 500)
	w:AlignBottom(10)
	w:AlignLeft(10)

	local prop = w:Add 'DProperties'
	prop:Dock(FILL)

	local rowLabelW = 25
	local function rowLayout(self)
		self:SetTall(20)
		self.Label:SetWide(rowLabelW)
	end

	local function setupRow(cat, name, change, decimals)
		local r = prop:CreateRow(cat, name)
		r:Setup('Float', { min = -180, max = 180 })
		r:SetValue(0)
		r.PerformLayout = rowLayout
		r.Paint = nil

		local l = r:GetChild(1):GetChild(0)
		l.Paint = function() end
		l:GetChild(0):SetDecimals(decimals or 1)
		function r:DataChanged(v) change(v) end

		return r
	end

	for boneID, ang in pairs(bones) do
		local function updateAng(ang)
			ent:ManipulateBoneAngles(boneID, ang)
		end

		local boneName = ent:GetBoneName(boneID)
		setupRow(boneName, 'P', function(v) ang.p = math.Round(v, 1) updateAng(ang) end):SetValue(ang.p)
		setupRow(boneName, 'Y', function(v) ang.y = math.Round(v, 1) updateAng(ang) end):SetValue(ang.y)
		setupRow(boneName, 'R', function(v) ang.r = math.Round(v, 1) updateAng(ang) end):SetValue(ang.r)
	end

	for name, pnl in pairs(prop.Categories) do
		pnl.Container.Paint = octolib.func.zero
		pnl.Expand:DoClick()
	end

	local b = w:Add 'DButton'
	b:Dock(BOTTOM)
	b:SetTall(20)
	b:SetText(L.copy)
	function b:DoClick()
		local parts = {}
		for k, v in pairs(bones) do
			if v.p ~= 0 or v.y ~= 0 or v.r ~= 0 then
				table.insert(parts, ('[\'%s\'] = Angle(%.1f, %.1f, %.1f),'):format(ent:GetBoneName(k), math.Round(v.p, 1), math.Round(v.y, 1), math.Round(v.r, 1)))
			end
		end
		SetClipboardText(table.concat(parts, '\n'))
	end

	function w:OnClose()
		for i = 0, ent:GetBoneCount() - 1 do
			ent:ManipulateBoneAngles(i, Angle())
		end
	end

	return w

end

concommand.Add('octolib_tool_bones', function(ply)

	local ent = LocalPlayer():GetEyeTrace().Entity
	if not IsValid(ent) then ent = LocalPlayer() end

	local bones = {}
	for i = 0, ent:GetBoneCount() - 1 do
		bones[i] = ent:GetManipulateBoneAngles(i) or Angle()
	end

	octolib.devtools.bones(ent, bones)

end)