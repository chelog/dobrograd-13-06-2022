octolib.meta = octolib.meta or {}
octolib.meta.stored = octolib.meta.stored or {}

function octolib.meta.getOrCreate(id)
	if octolib.meta.stored[id] then
		return octolib.meta.stored[id]
	end

	local meta = {}
	meta.__index = meta
	octolib.meta.stored[id] = meta

	return meta
end
