netstream.Hook('6ylc0mkzd5ZhwPkcf2f9or7gi1WnLx', function(ply)

	if GetConVar('sv_cheats'):GetBool() ~= false or GetConVar('sv_allowcslua'):GetBool() ~= false then return end

	if CFG.webhooks.cheats then
		octoservices:post('/discord/webhook/' .. CFG.webhooks.cheats, {
			username = GetHostName(),
			embeds = {{
				title = 'Попытка использовать клиентские скрипты',
				fields = {{
					name = L.player,
					value = ply:GetName() .. '\n[' .. ply:SteamID() .. '](' .. 'https://steamcommunity.com/profiles/' .. ply:SteamID64() .. ')',
				}},
			}},
		})
	end

	ply:Kick('exploits')

end)
