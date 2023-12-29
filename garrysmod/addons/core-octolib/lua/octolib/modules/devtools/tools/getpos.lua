concommand.Add('octolib_tool_getpos', function(ply, cmd, args, argStr)
	local pos, ang = ply:GetPos(), ply:EyeAngles()
	local text = ('[%d %d %d]{%d %d %d}'):format(pos.x, pos.y, pos.z, ang.p, ang.y, ang.r)

	print(text)
	SetClipboardText(text)
	print('Copied to clipboard!')
end)
