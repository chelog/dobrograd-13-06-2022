local diet = require('diet')
local gc = {}

local keyFile = io.open('key.dat')
if not keyFile then
	error('Crypt key not found.')
	return
end

local key = keyFile:read('*all')
local keyLen = key:len()
keyFile:close()

local cursorPos = 0
local function nextOffset()
	cursorPos = cursorPos + 1
	if cursorPos > keyLen then cursorPos = 1 end

	return string.byte(key:sub(cursorPos, cursorPos)) % 32
end

function gc.crypt(content)

	cursorPos = 0

	local res = {}
	for c in string.gmatch(diet(content), '.') do
		local byte = string.byte(c) + nextOffset()
		if byte > 255 then byte = byte - 256 end
		res[#res + 1] = string.char(byte)
	end

	return table.concat(res)

end

function gc.decrypt(content)

	cursorPos = 0

	local res = {}
	for c in string.gmatch(content, '.') do
		local byte = string.byte(c) - nextOffset()
		if byte < 0 then byte = byte + 256 end
		res[#res + 1] = string.char(byte)
	end

	return table.concat(res)

end

return gc
