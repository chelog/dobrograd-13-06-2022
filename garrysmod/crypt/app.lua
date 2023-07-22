local gc = require('gmod-crypt')

if arg[1] == 'crypt' and arg[2] then
	print('-----------------------')

	local fList = io.open(arg[2], 'r')
	if fList then
		local pathList = {}
		for path in fList:lines() do
			if path:gsub(' ', '') ~= '' then
				pathList[#pathList + 1] = path
			end
		end
		fList:close()

		for i, path in ipairs(pathList) do
			io.write('-> Crypting ' .. path .. ': ')

			local fCode = io.open(path, 'r')
			if fCode then
				local content = fCode:read('*a')
				fCode:close()

				if content:sub(1, 6) ~= '♯[=[' then
					local ok, err = pcall(function()
						local crypted = gc.crypt(content)
						local fCode = io.open(path, 'w+')
						fCode:write('♯[=[' .. crypted .. ']=]')
						fCode:close()
					end)

					if ok then
						io.write('Done.\n')
					else
						io.write('Error: ' .. err .. '\n')
					end
				else
					io.write('Already crypted.\n')
				end
			else
				io.write('NOT FOUND.\n')
			end
		end
	end

	print('-----------------------')
end

if arg[1] == 'decrypt' and arg[2] then
	print('-----------------------')

	local fCode = io.open(arg[2], 'r')
	if fCode then
		local ok, err = pcall(function()
			local content = fCode:read('*a'):sub(7, -4)
			io.write(gc.decrypt(content) .. '\n')
		end)
		if not ok then
			print('ERR: ' .. err)
		end
	else
		print('File not found.')
	end

	print('-----------------------')
end
