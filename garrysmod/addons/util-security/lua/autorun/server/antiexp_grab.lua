local fileFind = file.Find
file.CreateDir('grab')

local data = {
	'gmcl_emNIMVSySHNCPFzvYhHDKw',
	'gmsv_gPEPNffjUHzwyPpMmsvLkqG',
	'gmsv_qlWjUXBjyFlihmwycxklrbhOlmZ',
	'88_full_1',
	'IdiotBox',
	'Inj3MENU',
	'Jesus.lua',
	'TeamOrbit',
	'Toxic.pro',
	'eni.lua',
	'htx.lua',
	'noclip.lua',
	'MemeSmasher',
	'legitbot',
	'Kiox',
	'execc',
	'ttt hack',
	'shitcheat',
	'SmegHack',
}

local caught = {}

hook.Add('PlayerSwitchWeapon', 'antiexp-grab.scare', function(ply, old, new)
	if not (ply.weaponReady and IsValid(new) and string.StartWith(new:GetClass(), 'weapon_octo_')) then return end
	local sid = ply:SteamID()
	if caught[sid] then
		caught[sid] = nil
		RunConsoleCommand('sg', 'ban', sid, '0', 'cheats')
	end
end, -10)

hook.Add('PlayerDisconnected', 'antiexp-grab.quit', function(ply)
	local sid = ply:SteamID()
	if caught[sid] then
		ply:SetDBVar('hasCheats', true)
		caught[sid] = nil
	end
end)

hook.Add('antiexp.grab', 'discord', function(ply, files)

	if not CFG.webhooks.cheats or #files == 0 then return end
	local sid = ply:SteamID()

	local filesName, found = '', false
	if ply:GetDBVar('hasCheats') then
		caught[sid], found = true, true
	end
	for _, f in ipairs(files) do
		filesName = filesName .. '`' .. f[1] .. '`\n'
		if not found then
			for _, check in ipairs(data) do
				if utf8.find(f[1], check) then
					caught[sid] = true
					found = true
					break
				end
			end
		end
	end

	octoservices:post('/discord/webhook/' .. CFG.webhooks.cheats, {
		username = GetHostName(),
		embeds = {
			{
				title = L.potential_cheats,
				fields = {
					{
						name = L.player,
						value = ply:GetName() .. '\n[' .. sid .. '](' .. "https://steamcommunity.com/profiles/" .. ply:SteamID64() .. ')',
						inline = true
					},
					{
						name = L.files,
						value = filesName,
						inline = true,
					},
				},
			}
		},
	})

end)

local files = {}
netstream.Hook('antiexp-grab', function(ply, files)

	if ply.fileGrabReceived then return end
	ply.fileGrabReceived = true

	if not pcall(function()
		files = pon.decode(util.Decompress(files))
	end) then
		octolib.msg('Error getting grab from %s (%s)', ply:Name(), ply:SteamID())
		return
	end

	if #files < 1 then return end

	local dir = 'grab/' .. ply:SteamID():gsub(':','_'):lower()
	if not file.Exists(dir, 'DATA') then file.CreateDir(dir) end
	for i, v in ipairs(files) do
		-- octolib.msg('[# GRAB] %s: %s', ply:Name(), v[1])
		local fpath = v[1]:gsub('/', '+'):gsub('%.lua','.txt')
		file.Write(dir .. '/' .. fpath, v[2])
	end

	hook.Run('antiexp.grab', ply, files)
	octolib.msg('[# GRAB] %s (%s) has %s illegal files', ply:Name(), ply:SteamID(), #files)

end)
