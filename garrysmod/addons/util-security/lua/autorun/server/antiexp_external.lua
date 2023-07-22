util.AddNetworkString('wdKrFhq54FGBAZThSRYvdcSBQmGk1f')
net.Receive('wdKrFhq54FGBAZThSRYvdcSBQmGk1f', function (len, ply)

	if CFG.webhooks.cheats then
		octoservices:post('/discord/webhook/' .. CFG.webhooks.cheats, {
			username = GetHostName(),
			embeds = {{
				title = 'Попытка инжекта',
				fields = {{
					name = L.player,
					value = ply:GetName() .. '\n[' .. ply:SteamID() .. '](' .. 'https://steamcommunity.com/profiles/' .. ply:SteamID64() .. ')',
				}},
			}},
		})
	end

	ply:Kick('exploits')

end)
