if CFG.disabledModules.launcher then return end

util.AddNetworkString 'octolib.launcher.rkey'

local pending = {}
net.Receive('octolib.launcher.rkey', function()
	local reqID = net.ReadString()
	if not reqID then return end

	local func = pending[reqID]
	if not func then return end

	local len = net.ReadUInt(16)
	local key = net.ReadData(len)

	timer.Remove('launcher.validate:' .. reqID)
	pending[reqID] = nil
	func(key)
end)

local function updatePlayerAccess(ply, validationData)
	local ok = not validationData.error
	if ply.launcherValidated == ok then return end

	if CFG.requireLauncher and ply.launcherValidated == nil and not ok then
		netstream.Start(ply, 'launcher.notFound', true)
	end

	hook.Run('octolib.launcherValidationUpdate', ply, ok, validationData.error)
	ply.launcherValidated = ok

	local hwidsString = table.concat(validationData.hwids or {}, ',')
	if ok and not ply:IsBot() and ply.storedHwids ~= hwidsString then
		netstream.Start(ply, 'launcher.notFound', false)
		octolib.family.storeHwids(validationData.steamID, validationData.hwids, function()
			if not IsValid(ply) then return end
			ply.storedHwids = hwidsString
		end)
	end
end

local function validatePlayer(ply, callback)
	if ply:IsBot() then
		return callback({
			steamID = ply:SteamID(),
			hwids = {},
		})
	end

	local steamID64 = ply:SteamID64()
	octolib.func.chain({
		function(done)
			local reqID = octolib.string.uuid()
			pending[reqID] = done

			-- timeout
			local attemptLeft = 6
			timer.Create('launcher.validate:' .. reqID, 15, 8, function()
				attemptLeft = attemptLeft - 1
				if attemptLeft > 0 then return end

				if not IsValid(ply) then pending[reqID] = nil end
				if not pending[reqID] then return end
				pending[reqID] = nil
				updatePlayerAccess(ply, { error = 'In-game rkey request timed out' })
			end)

			net.Start('octolib.launcher.rkey')
				net.WriteString(reqID)
			net.Send(ply)
		end,
		function(done, key)
			if key == '' then
				callback({ error = 'No rkey found on client' })
				return
			end

			octoservices:post('/auth/validate', {
				steamID = steamID64,
				key = key,
			})
				:Then(done)
				:Catch(function(err)
					print('Failed to validate ' .. steamID64 .. ': ' .. err)
				end)
		end,
		function(done, response)
			callback(response.data)
		end,
	})
end

hook.Add('PlayerFinishedLoading', 'octolib.launcher', function(ply)
	if not CFG.requireLauncher then
		ply.launcherValidated = true
		hook.Run('octolib.launcherValidationUpdate', ply, true)
		return
	end

	validatePlayer(ply, function(data)
		updatePlayerAccess(ply, data)
	end)
end)

local curPlayerIndex = 0
timer.Create('octolib.launcher.validate', 2, 0, function()
	if not CFG.requireLauncher then return end

	local playerCount = player.GetCount()
	if playerCount < 1 then return end

	curPlayerIndex = curPlayerIndex + 1
	if curPlayerIndex > playerCount then
		curPlayerIndex = 1
	end

	local ply = player.GetAll()[curPlayerIndex]
	validatePlayer(ply, function(data)
		updatePlayerAccess(ply, data)
	end)
end)

octolib.family.statusUpdateCounts = {}

hook.Add('octolib.launcherValidationUpdate', 'octolib.debug', function(ply, ok, reason)
	reason = ok and 'OK' or reason or 'Unknown failure'
	octolib.family.statusUpdateCounts[reason] = (octolib.family.statusUpdateCounts[reason] or 0) + 1

	print(('[LAUNCHER] Player verification updated: %s (%s) - %s'):format(ply:Name(), ply:SteamID64(), reason))
end)
