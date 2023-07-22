local Log = {}
Log.__index = Log

function octologs.createLog(category)

	local log = {}
	log.parts = {}
	log.category = category
	return setmetatable(log, Log)

end

function Log:Add(...)

	local parts = self.parts
	for i, v in ipairs({...}) do
		parts[#parts + 1] = v
	end

	return self

end

function Log:Save()

	octologs.log(self.parts, self.category)

end
