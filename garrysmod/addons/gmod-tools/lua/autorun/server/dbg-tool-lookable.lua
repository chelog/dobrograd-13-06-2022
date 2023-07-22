hook.Add('KeyRelease', 'dbg-tools.lookable', function(ply, key)

	if key ~= IN_USE then return end
	local ent = octolib.use.getTrace(ply).Entity
	if not IsValid(ent) then return end

	local data = ent.lookableData
	if not data then return end

	netstream.Start(ply, 'tools.lookable', data)

	if data.sound then
		local soundData = table.Copy(data.sound)
		soundData.ent = ent
		soundData.pos = soundData.pos or Vector()
		octolib.audio.play(soundData)
	end

end)

duplicator.RegisterEntityModifier('lookable', function(ply, ent, data)
	local override = hook.Run('CanTool', ply, { Entity = ent }, 'lookable')
	if override == false then return end
	ent.lookableData = data
end)
