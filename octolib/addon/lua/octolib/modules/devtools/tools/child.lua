concommand.Add('octolib_tool_child', function(ply, cmd, args, argStr)

	if not CFG.dev and not LocalPlayer():IsSuperAdmin() then return end

	local parent = LocalPlayer():GetEyeTrace().Entity
	if not IsValid(parent) then parent = LocalPlayer() end

	if not args or not args[1] or IsUselessModel(args[1]) then
		print(L.format_command)
		print(L.model_space)
		return
	end

	local csEnt = octolib.createDummy(args[1])
	if not IsValid(csEnt) then
		print(L.failure_create_object)
		return
	end

	local data = octolib.devtools.positions(Vector(0, 0, 0), Angle(0, 0, 0), 1)
	function data.updatePos(pos) csEnt:SetLocalPos(data.pos) end
	function data.updateAng(ang) csEnt:SetLocalAngles(data.ang) end
	function data.updateScale(scale) csEnt:SetModelScale(data.scale) end
	function data.onClose() csEnt:Remove() end

	csEnt:SetParent(parent, tonumber(args[2]) or 1)
	csEnt:SetLocalPos(data.pos)
	csEnt:SetLocalAngles(data.ang)
	csEnt:SetModelScale(data.scale)

end)
