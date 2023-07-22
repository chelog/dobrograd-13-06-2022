local props = file.Find('cmenu/properties/*.lua', 'LUA')
for _, v in ipairs(props) do
	octolib.shared('cmenu/properties/' .. v:StripExtension())
end

local cats = file.Find('cmenu/categories/*.lua', 'LUA')
for _, v in ipairs(cats) do
	octolib.client('cmenu/categories/' .. v:StripExtension())
end

local items = file.Find('cmenu/items/*.lua', 'LUA')
for _, v in ipairs(items) do
	octolib.client('cmenu/items/' .. v:StripExtension())
end
