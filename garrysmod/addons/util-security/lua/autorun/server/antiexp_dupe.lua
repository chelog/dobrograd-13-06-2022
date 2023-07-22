timer.Simple(1,function()

	net.Receive('ArmDupe', function(len,ply)
		if CFG.webhooks.cheats then
			octoservices:post('/discord/webhook/' .. CFG.webhooks.cheats, {
				username = GetHostName(),
				embeds = {{
					title = 'Попытка использовать ArmDupe',
					fields = {{
						name = L.player,
						value = ply:GetName() .. '\n[' .. ply:SteamID() .. '](' .. 'https://steamcommunity.com/profiles/' .. ply:SteamID64() .. ')',
					}},
				}},
			})
		end

		ply:Kick('exploits')
	end)

end)
