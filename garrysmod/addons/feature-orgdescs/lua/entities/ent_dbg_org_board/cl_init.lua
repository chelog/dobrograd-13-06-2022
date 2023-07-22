include 'shared.lua'

netstream.Hook('simple-orgs.guest', function(id, url, flyer)

	local org = simpleOrgs.orgs[id]
	if not org then return end

	local fr = vgui.Create('DFrame')
	fr:SetSize(500, 64)
	fr:SetTitle(org.title)
	fr:SetPos((ScrW() - 500) / 2, (ScrH() - 575) / 2)
	fr:MakePopup()
	fr:SetAlpha(0)
	fr:SizeTo(500, 575, 2, 0, 0.3)
	fr:AlphaTo(255, 1, 0)

	local scrollPan = fr:Add('DScrollPanel')
	scrollPan:Dock(FILL)
	local presenation = scrollPan:Add('DImage')
	presenation:Dock(TOP)
	presenation:SetKeepAspect(true)
	octolib.getImgurMaterial(flyer, function(mat)
		if not IsValid(presenation) then return end
		presenation:SetMaterial(mat)
		presenation:SetTall(mat:Height())
	end, true)

	local btn = fr:Add('DButton')
	btn:Dock(BOTTOM)
	btn:DockMargin(0, 5, 15, 0)
	btn:SetFont('f4.normal')
	btn:SetTall(30)
	btn:SetText(url and url ~= '' and 'Подать заявку' or 'Заявки временно не принимаются')
	btn:SetEnabled(url and url ~= '')
	if btn:IsEnabled() then
		function btn:DoClick()
			octoesc.OpenURL(url)
		end
	end
end)

local function chooseByData(combo, data)
	for k, v in pairs(combo.Data) do
		if v == data then
			combo:ChooseOptionID(k)
			return true
		end
	end
	return false
end

local function synchronizeOption(customizer, val)
	if not customizer then return false end
	if customizer[1] then return chooseByData(customizer[2], val)
	elseif val == 0 or val == customizer[2].okVal then
		customizer[2]:SetValue(val ~= 0)
		return true
	else return false end
end

netstream.Hook('simple-orgs.activeWindow', function(ent, mdlData)

	local ply = LocalPlayer()

	local pnl = octolib.models.selector({mdlData}, function(index, skin, bgs, mats)
		if not index then return end
		netstream.Start('simple-orgs.getAmmo', ent, skin, bgs, mats)
	end)
	pnl.layoutPan:Remove()
	pnl.submitBtn:SetText('Переодеться и пополнить боезапас')

	local handOverBtn = octolib.button(pnl.mpWrap, 'Сдать экипировку', function()
		netstream.Start('simple-orgs.handOver', ent)
		pnl:Close()
	end)
	handOverBtn:Dock(BOTTOM)
	handOverBtn:DockMargin(0, 2, 0, 0)
	handOverBtn:SetTall(25)

	pnl.submitBtn:SetParent()
	pnl.submitBtn:SetParent(pnl.mpWrap)

	local params = pnl.params
	params:ChangeModel(1, mdlData)
	if params.skinCustomizer then
		chooseByData(params.skinCustomizer, ply:GetSkin())
	end

	local modelEnt = pnl.modelPreview.Entity

	local bgCustomizers = params.bgCustomizers
	for _, v in ipairs(ply:GetBodyGroups()) do
		local id, val = v.id, ply:GetBodygroup(v.id)
		if not synchronizeOption(bgCustomizers[id], val) then modelEnt:SetBodygroup(id, val) end
	end

	local matCustomizers = params.matCustomizers
	for id in ipairs(ply:GetMaterials()) do
		local val = ply:GetSubMaterial(id)
		if not synchronizeOption(matCustomizers[id], val) then modelEnt:SetSubMaterial(id, val) end
	end

end)

function ENT:Draw()
	self:DrawModel()
	local title = self:GetNetVar('title')
	if not title then return end
	render.DrawBubble(self, Vector(0, 0.45, 8), Angle(0, 180, 90), title, 200, 200)
end
