octolib.vars = octolib.vars or {}

local fname = 'octolib_vars.dat'
local function load()
	local txt = file.Read(fname, 'DATA') or '[}'
	octolib.vars = pon.decode(txt) or {}
end
pcall(load)

local function save()
	file.Write(fname, pon.encode(octolib.vars))
end
local saveDebounced = octolib.func.debounce(save, 1)

function octolib.vars.set(var, val, saveNow)

	if not istable(val) and octolib.vars[var] == val then return end
	octolib.vars[var] = val
	if saveNow then
		save()
	else
		saveDebounced()
	end

	hook.Run('octolib.setVar', var, val)

end

function octolib.vars.init(var, val)

	if octolib.vars[var] ~= nil then return end
	octolib.vars.set(var, val)

end

function octolib.vars.get(var)

	return octolib.vars[var]

end
