local enabled = CreateClientConVar('dbg_voicemods', '1', true)

local ranges = { [10000] = 1, [150000] = 2, [500000] = 3, [2250000] = 4 }
local talking = false

local function setMode(vm)
	local curRange = LocalPlayer():GetNetVar('TalkRange')
	if not curRange or vm ~= (ranges[curRange] or 2) then
		netstream.Start('IWannaChangeVoiceMod', vm)
	end
end

hook.Add('PlayerStartVoice', 'VoiceMods', function(ply)
	if ply ~= LocalPlayer() or not enabled:GetBool() then return end
	talking = true

	local vm = 2
	if ply:KeyDown(IN_SPEED) then
		vm = 3
	elseif ply:KeyDown(IN_WALK) then
		vm = 1
	end

	setMode(vm)
end)

hook.Add('PlayerEndVoice', 'VoiceMods', function(ply)
	if ply ~= LocalPlayer() then return end
	talking = false
end)

hook.Add('KeyPress', 'VoiceMods', function(ply, key)

	if not talking or not IsFirstTimePredicted() then return end

	if key == IN_SPEED then
		setMode(3)
	elseif key == IN_WALK then
		setMode(1)
	end

end)

hook.Add('KeyRelease', 'VoiceMods', function(ply)

	if not talking or not IsFirstTimePredicted() then return end
	if not ply:KeyDown(IN_SPEED) or ply:KeyDown(IN_WALK) then
		setMode(2)
	end

end)

hook.Add('octochat.chatOpenText', 'dbg-stuff', function(bind)

	local ply = LocalPlayer()
	if bind == 'messagemode2' then
		return '/r '
	elseif ply:KeyDown(IN_SPEED) then
		return '/y '
	elseif ply:KeyDown(IN_WALK) then
		return '/w '
	end

end)
