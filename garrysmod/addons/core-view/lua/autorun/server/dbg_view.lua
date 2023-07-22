local pmeta = FindMetaTable('Player')
local setFov = pmeta.SetFOV
function pmeta:SetFOV(fov, time, requester)
	if setFov then setFov(self, fov, time, requester) end
	netstream.Start(self, 'dbg-view.setFov', fov, time or 0)
end

netstream.Hook('dbg-look.enable', function(ply, enable)

	if enable then
		local increaseDist, changeFov = hook.Run('closelook.canZoom', ply)
		if increaseDist then ply:SetLocalVar('closelookZoom', true) end
		if changeFov then ply:SetFOV(50, 1) end
	elseif ply:GetNetVar('closelookZoom') then
		ply:SetLocalVar('closelookZoom', nil)

		local _, changeFov = hook.Run('closelook.canZoom', ply)
		if changeFov then ply:SetFOV(0, 0.5) end
	end

end)

netstream.Hook('dbg-quickLook', function(ply)
	if ply:IsFrozen() then return end

	local doFreeze = not ply:GetNetVar('dragger')

	netstream.Start(ply, 'dbg-quickLook')
	if doFreeze then ply:Freeze(true) end

	timer.Simple(3.8, function()
		if not IsValid(ply) then return end
		if doFreeze then ply:Freeze(false) end
	end)
end)
