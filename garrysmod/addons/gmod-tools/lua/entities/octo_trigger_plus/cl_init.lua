include 'shared.lua'

function ENT:Initialize()

	local size = self:GetNetVar('size') or Vector(1,1,1)
	local side = Vector(size.x / 2, size.y / 2, size.z / 2)
	self:SetRenderBounds(-side, side)

end

function ENT:Draw()
	if not octolib.vars.get('tools.trigger+.draw') then return end
	local wepclass = LocalPlayer():GetActiveWeaponClass()
	if wepclass ~= "gmod_tool" then return end
	local ang = Angle()

	cam.Start3D()
		local tpos = self:GetPos()
		local size = (self:GetNetVar('size') or Vector(1,1,1)) / 2
		render.DrawWireframeBox(tpos, ang, -size, size, color_white, false)
		local owner = self:CPPIGetOwner()
		if not IsValid(owner) then return end
		cam.Start2D()
			local spos = tpos:ToScreen()
			local x, y = math.ceil(spos.x), math.ceil(spos.y)
			surface.SetDrawColor(255, 255, 255, 55)
			surface.DrawRect(x - 15, y - 10, 25, 25)
			local title, text = owner:Name(), owner:SteamID()
			draw.SimpleText(title, 'DermaDefault', x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(text, 'DermaDefault', x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		cam.End2D()
	cam.End3D()
end

netstream.Hook('gmpanel.executeObject', function(data, players)
	if data.type == 'action' then

		local action = gmpanel.actions.available[data.obj.id]
		local func = action.execute or gmpanel.actions.defaultExecute
		func(data.obj, players)

	elseif data.type == 'scenario' then
		gmpanel.scenarios.execute(data.obj, players)
	end
end)
