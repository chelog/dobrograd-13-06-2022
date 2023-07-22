local plugin = plugin;

plugin.name = 'Dobrograd';
plugin.author = 'chelog';
plugin.version = '1.0';
plugin.description = L.description_permissions;
plugin.gamemodes = {'darkrp'};
plugin.permissions = {
	L.permissions_admin_request,
	L.permissions_admin_commands,
	L.permissions_superadmin_commands,
	L.permissions_edit_inventory,
	L.permissions_spawn_sent,
	L.permissions_spawn_swep,
	L.permissions_spawn_npc,
	L.permissions_spawn_vehicle,
	L.permissions_spawn_ragdoll,
	'DBG: SpawnSimfphys',
	L.permissions_trigger_url,
	L.permissions_create_prop_inventory,
	L.permissions_permaprops,
	L.permissions_edit_karma,
	'DBG: Панель ивентов',
	'DBG: Расширенный доступ к панели ивентов',
	'DBG: Изменять автомобили',
	'DBG: Эвакуировать автомобили',
	'DBG: Телепорт по команде',
	'DBG: Применять тулы на игроках',
	'DBG: Глобальный IT',
	'DBG: Большие пропы',
	'DBG: Изменять голод',
	'DBG: Расширенный 3D2D Textscreen',
	'DBG: Открывать Fading Door с помощью кнопки',
	'DBG: Пропы из blacklist',
	'DBG: Редактировать blacklist пропов',
	'Get play time',
	'DBG: Сбрасывать номера',
	'DBG: Изменять звук обыска',
	'DBG: Расширенный Image Screen',
	'DBG: Редактировать тест',
	'DBG: Редактировать организации',
	'Go Incognito',
	'Set Player Name',
	'Make Animatable',
	'Unban permanently banned players',
	'StormFox Settings',
	'StormFox WeatherEdit',
};

hook.Add('CAMI.OnPrivilegeRegistered', 'dbg-admin.privileges', function(priv)
	serverguard.permission:Add(priv)
end)

local meta = FindMetaTable 'Player'

function meta:CheckCrimeDenied()
	local ct = CurTime()
	local time = self:GetNetVar('nocrime')
	if not time then return false end
	if time == true then return true end
	if time <= ct then
		if SERVER then
			self:SetDBVar('nocrime', nil)
			self:SetNetVar('nocrime', nil)
		end
		return false
	end
	return time - ct
end

function meta:CheckPoliceDenied()
	local ct = CurTime()
	local time = self:GetNetVar('nopolice')
	if not time then return false end
	if time == true then return true end
	if time <= ct then
		if SERVER then
			self:SetDBVar('nopolice', nil)
			self:SetNetVar('nopolice', nil)
		end
		return false
	end
	return time - ct
end
