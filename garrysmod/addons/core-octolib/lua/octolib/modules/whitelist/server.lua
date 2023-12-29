local cache = {}

local function load()

	local f = file.Read 'dbg-whitelist.dat'
	if not f then return end

	cache = pon.decode(f) or cache

end

local function save()

	file.Write('dbg-whitelist.dat', pon.encode(cache))

end

local function send(ply)

	netstream.Start(ply, 'whitelist.get', cache)

end

local function output(user, msg)
	if user:IsPlayer() then
		user:ChatPrint(msg)
	else
		print(msg)
	end
end

local function add(id, ply, reason)

	if ply:IsPlayer() and not ply:IsSuperAdmin() then return end
	if id:find('STEAM_') then id = util.SteamIDTo64(id) end
	if id:len() ~= 17 then return end

	if string.Trim(reason or '') == '' then
		return output(ply, 'Укажи причину добавления в вайтлист: dbg_wl_add ' .. id .. ' "причина"')
	end

	if not cache[id] then
		output(ply, util.SteamIDFrom64(id) .. L.add_whitelist_hint .. ': ' .. reason)
	end

	cache[id] = reason
	save()
	send(ply)

end

local function remove(id, ply)

	if ply:IsPlayer() and not ply:IsSuperAdmin() then return end
	if id:find('STEAM_') then id = util.SteamIDTo64(id) end
	if id:len() ~= 17 then return end

	cache[id] = nil
	save()
	send(ply)

	output(ply, util.SteamIDFrom64(id) .. L.remove_whitelist_hint)

end

local function clear(ply)
	if ply:IsPlayer() then return end
	table.Empty(cache)
	save()
	print('Вайтлист очищен. Добавь сюда кого-нибудь, чтобы на сервер не могли зайти')
end

local function sendList(ply)
	if ply:IsPlayer() then return end
	print('===')
	for sid64, reason in pairs(cache) do
		print(sid64, reason)
	end
	print('===')
end

hook.Add('Initialize', 'dbg-whitelist', function()

	load()

end)
load()

hook.Add('CheckPassword', 'dbg-whitelist', function(sid)

	if table.Count(cache) > 0 and not cache[sid] then
		print('Denied whitelist for ' .. sid)
		return false, L.denied_whitelist_hint
	end

end)

netstream.Hook('whitelist.get', function(ply) send(ply) end)
netstream.Hook('whitelist.add', function(ply, id, reason) add(id, ply, reason) end)
netstream.Hook('whitelist.remove', function(ply, id) remove(id, ply) end)
concommand.Add('dbg_wl_add', function(ply, cmd, args) add(args[1], ply, args[2]) end)
concommand.Add('dbg_wl_edit', function(ply, cmd, args) add(args[1], ply, args[2]) end)
concommand.Add('dbg_wl_list', function(ply, cmd, args) sendList(ply) end)
concommand.Add('dbg_wl_remove', function(ply, cmd, args) remove(args[1], ply) end)
concommand.Add('dbg_wl_clear', function(ply, cmd, args) clear(ply) end)