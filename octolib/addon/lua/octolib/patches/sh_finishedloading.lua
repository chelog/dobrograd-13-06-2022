if CLIENT then
	hook.Add('Think', 'octolib.finishedLoading', function()
		hook.Remove('Think', 'octolib.finishedLoading')

		netstream.Start('octolib.finishedLoading')
		hook.Run('PlayerFinishedLoading')
	end)
end

if SERVER then
	local playersFinished = {}

	netstream.Hook('octolib.finishedLoading', function(ply)
		if playersFinished[ply] then return end

		hook.Run('PlayerFinishedLoading', ply)
		playersFinished[ply] = true
	end)

	hook.Add('PlayerDisconnected', 'octolib.finishedLoading', function(ply)
		playersFinished[ply] = nil
	end)

	-- simulate hook for bots (mainly for automated tests)
	hook.Add('PlayerInitialSpawn', 'octolib.finishedLoading', function(ply)
		if ply:IsBot() then
			timer.Simple(1, function()
				hook.Run('PlayerFinishedLoading', ply)
				ply.FinishedLoading = true
			end)
		end
	end)
end
