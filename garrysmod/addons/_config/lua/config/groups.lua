simpleOrgs.orgs = simpleOrgs.orgs or {}

local reloadUpstream = octolib.func.debounce(function()
	hook.Run('octolib.event:reloadOrgs')
	hook.Run('dbg-orgs.listLoaded')
end, 1)

function simpleOrgs.addOrg(id, data)

	simpleOrgs.orgs[id] = data
	data.members = {}
	data.owners = {}
	data.flyer = data.flyer or ''
	data.url = ''

	dbgDoorGroups.registerGroup(id, data.name or utf8.upper(id))
	if data.rankOrder then
		local dict = {}
		for i, v in ipairs(data.rankOrder) do
			dict[v] = i
		end
		data._rankOrder = dict
	end
	
	reloadUpstream()
end

local files, folders = file.Find('config/groups/*', 'LUA')
for _, v in ipairs(files) do
	octolib.shared('config/groups/' .. string.StripExtension(v))
end
for _, v in ipairs(folders) do
	local cats = file.Find('config/groups/' .. v .. '/cmenu/categories/*.lua', 'LUA')
	for _, cat in ipairs(cats) do
		octolib.client('config/groups/' .. v .. '/cmenu/categories/' .. cat:StripExtension())
	end
	local items = file.Find('config/groups/' .. v .. '/cmenu/items/*.lua', 'LUA')
	for _, item in ipairs(items) do
		octolib.client('config/groups/' .. v .. '/cmenu/items/' .. item:StripExtension())
	end
	octolib.shared('config/groups/' .. v .. '/init')
end
hook.Run('simple-orgs.load')

for _, org in pairs(simpleOrgs.orgs) do
	org.members = {}
	org.flyer = org.flyer or ''
	org.url = ''
end
reloadUpstream()
