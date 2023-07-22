include('shared.lua')

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.RenderGroup 		= RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()
	render.DrawBubble(self, Vector(8.6, 0, 24.5), Angle(0, 90, 90), L.equipment, 200, 200)
end

local skins = {
	medcop = 0,
	cop = 0,
	cop2 = 1,
	chief = 2,
}

net.Receive('dbg-police.equip', function(len)

	local ply = LocalPlayer()

	local ent = net.ReadEntity()
	local equip = net.ReadBool()
	local job = ply:GetNetVar('dbg-police.job', '')

	if equip then
		local mdls = net.ReadTable()
		local f = vgui.Create 'DFrame'
		f:SetSize(260, 520)
		f:SetTitle(L.equipment)
		f:DockPadding(8,30,8,8)
		f:Center()
		f:MakePopup()

		local p = vgui.Create 'DPanel'
		p:SetParent(f)
		p:Dock(TOP)
		p:SetTall(350)
		if job == 'mayor' then
			p.model = ply:GetModel()
			p.skin = ply:GetSkin()
			p.choice = 1
			p.hat = true
		else
			p.model = mdls[1][1]
			p.skin = mdls[1][2]
			p.choice = 1
			p.hat = true
		end

		local m = vgui.Create 'DModelPanel'
		m:SetParent(p)
		m:Dock(FILL)
		m:SetCamPos(Vector(55,0,66))
		m:SetLookAng(Angle(10,180,0))
		m:SetFOV(25)
		m:SetCursor('none')
		function m:LayoutEntity( mdl )
			mdl:SetAngles( Angle( 0, 15, 0) )
			mdl.GetPlayerColor = function() return ply:GetPlayerColor() end
			return
		end
		function m:UpdateData()
			self:SetModel(p.model)
			if job ~= 'mayor' then
				self.Entity:SetSkin(skins[job])
				self.Entity:SetBodygroup(4, p.hat and (job == 'chief' and 2 or 1) or 0)
			else
				self.Entity:SetSkin(p.skin)
			end
		end
		m:UpdateData()

		local p2 = vgui.Create 'DPanel'
		p2:SetParent(f)
		p2:Dock(FILL)
		p2:DockMargin(0,5,0,0)
		p2:SetPaintBackground(false)

		local l = vgui.Create 'DLabel'
		l:SetParent(p2)
		l:Dock(TOP)
		l:DockMargin(5,0,5,0)
		l:SetTall(30)
		l:SetText(L.appearance)
		l:SetFont('f4.normal')

		local h = p2:Add 'DCheckBoxLabel'
		h:Dock(TOP)
		h:DockMargin(0,5,0,5)
		h:SetText(L.hat)
		h:SetValue(1)
		function h:OnChange(val)
			if val then
				p.hat = true
				m.Entity:SetBodygroup(4, job == 'chief' and 2 or 1)
			else
				p.hat = false
				m.Entity:SetBodygroup(4, 0)
			end
		end

		local c = vgui.Create 'DComboBox'
		c:SetParent(p2)
		c:Dock(TOP)
		c:DockMargin(0,0,0,5)
		c:SetTall(30)
		c:SetSortItems(false)

		if job == 'mayor' then
			c:SetEnabled(false)
		else
			function c:OnSelect(i, v, data)
				p.model = data[1]
				p.skin = data[2]
				p.choice = i
				m:UpdateData()
			end
		end

		for i, v in ipairs(mdls) do
			c:AddChoice(L.appearance2 .. i, v, i == 1)
		end

		local b = vgui.Create 'DButton'
		b:SetParent(p2)
		b:Dock(TOP)
		b:DockMargin(0,5,0,0)
		b:SetTall(30)
		b:SetText(L.get_equipment)
		function b:DoClick()
			net.Start('dbg-police.equip')
				net.WriteEntity(ent)
				net.WriteBool(true)
				net.WriteUInt(p.choice, 8)
				net.WriteBool(p.hat)
			net.SendToServer()
			f:Remove()
		end
	else
		local f = vgui.Create 'DFrame'
		f:SetSize(260, 465)
		f:SetTitle(L.equipment)
		f:DockPadding(8,30,8,8)
		f:Center()
		f:MakePopup()

		local p = vgui.Create 'DPanel'
		p:SetParent(f)
		p:Dock(TOP)
		p:SetTall(350)
		p.model = ply:GetModel()
		p.skin = ply:GetSkin()
		p.bg = ply:GetBodygroup(4)

		local m = vgui.Create 'DModelPanel'
		m:SetParent(p)
		m:Dock(FILL)
		m:SetCamPos(Vector(55,0,66))
		m:SetLookAng(Angle(10,180,0))
		m:SetFOV(25)
		m:SetCursor('none')
		m:SetModel(ply:GetModel())
		m.Entity:SetSkin(ply:GetSkin())
		timer.Simple(0, function() m.Entity:SetBodygroup(4, p.bg) end)

		function m:LayoutEntity( mdl )
			mdl:SetAngles( Angle( 0, 15, 0) )
			mdl.GetPlayerColor = function() return ply:GetPlayerColor() end
			return
		end

		local p2 = vgui.Create 'DPanel'
		p2:SetParent(f)
		p2:Dock(FILL)
		p2:DockMargin(0,5,0,0)
		p2:SetPaintBackground(false)

		local b1 = vgui.Create 'DButton'
		b1:SetParent(p2)
		b1:Dock(TOP)
		b1:DockMargin(0,5,0,0)
		b1:SetTall(30)
		b1:SetText(L.get_ammo)
		function b1:DoClick()
			net.Start('dbg-police.equip')
				net.WriteEntity(ent)
				net.WriteBool(true)
			net.SendToServer()
			f:Remove()
		end

		local b2 = vgui.Create 'DButton'
		b2:SetParent(p2)
		b2:Dock(TOP)
		b2:DockMargin(0,5,0,0)
		b2:SetTall(30)
		b2:SetText(L.hand_over_equipment)
		function b2:DoClick()
			net.Start('dbg-police.equip')
				net.WriteEntity(ent)
				net.WriteBool(false)
			net.SendToServer()
			f:Remove()
		end
	end

end)
