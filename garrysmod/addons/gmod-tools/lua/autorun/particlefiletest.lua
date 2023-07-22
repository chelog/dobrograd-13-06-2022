AddCSLuaFile()
//MsgN("Added concommand for particle read test!")



function ParticleControl_FileReadTest()

	MsgN("")
	MsgN("")
	MsgN("")
	MsgN("")
	MsgN("")
	MsgN("=====================================================")
	MsgN("STEP 1: Reading the file")
	MsgN("=====================================================")
	MsgN("")

	local filestr = file.Read("particlelists/particlefiletest.lua","LUA")
	if !filestr then
		MsgN("FAILURE! We tried to read the file (particlelists/particlefiletest.lua) and didn't get anything. The file can't be found, or it isn't readable, or something, which doesn't make any sense, since the actual tool got farther than this.")
		return
	end

	if type(filestr) != "string" then
		MsgN("FAILURE! We read the file but we got back a " .. type(filestr) .. "instead of a string. What!? Here's what we got:")
		MsgN("")
		MsgN(filestr)
		return
	end

	MsgN("SUCCESS! We read the file and got back a string. Here's its contents:")
	MsgN("")
	MsgN(filestr)


	MsgN("")
	MsgN("")
	MsgN("")
	MsgN("")
	MsgN("")
	MsgN("=====================================================")
	MsgN("STEP 2: Converting it to a table")
	MsgN("=====================================================")
	MsgN("")

	local keyvalues = util.KeyValuesToTable( filestr, false, true )
	if !keyvalues then
		MsgN("FAILURE! We tried to convert it to a table, but we didn't get anything.")
		return
	end
	if (table.Count(keyvalues) == 0) then
		MsgN("FAILURE! We tried to convert it, but we got an empty table. Here's its contents, by which I mean a blank space unless something's weird here:")
		MsgN("")
		PrintTable(keyvalues)
		return
	end

	MsgN("SUCCESS! We converted it and got a table of stuff. Here's its contents:")
	MsgN("")
	PrintTable(keyvalues)


	MsgN("")
	MsgN("")
	MsgN("")
	MsgN("")
	MsgN("")
	MsgN("=====================================================")
	MsgN("STEP 3: Reading the table")
	MsgN("=====================================================")
	MsgN("")

	if !keyvalues.Info then
		MsgN("FAILURE! We couldn't find a key called \"Info\" inside the table. Is something wrong with the table we got? Like some blank spaces in the key name, or weird capitalization, or something like that which means it's technically not called \"Info\"? Or is the table's formatting messed up? Here's all of the keys we COULD find inside the table, with and without quotes just in case there's weird spaces:")
		MsgN("")
		for k, v in pairs (keyvalues) do
			MsgN("\"" .. k .. "\"")
		end
		MsgN("")
		for k, v in pairs (keyvalues) do
			MsgN(k)
		end
		return
	end

	if type(keyvalues.Info) != "table" then
		MsgN("FAILURE! The key called \"Info\" inside the table was something other than a sub-table. It was a " .. type(keyvalues.Info) .. " instead. Something's wrong with the table we got. Here's what \"Info\" is:")
		MsgN("")
		MsgN(keyvalues.Info)
		return
	end

	MsgN("Found the sub-table called \"Info\" inside the table...")
	MsgN("")

	if !keyvalues.Info.CategoryName then
		MsgN("FAILURE! We couldn't find the \"CategoryName\" inside the \"Info\" subtable. Something's wrong with the table we got. Here's \"Info\"'s contents:")
		MsgN("")
		PrintTable(keyvalues.Info)
		return
	end

	if type(keyvalues.Info.CategoryName) != "string" then
		MsgN("FAILURE! The \"CategoryName\" inside the \"Info\" subtable was something other than a string. Something's wrong with the table we got. Here's \"Info\"'s contents:")
		MsgN("")
		PrintTable(keyvalues.Info)
		return
	end

	MsgN("SUCCESS! We read the table. It's for a category called " .. keyvalues.Info.CategoryName .. ", and everything else should be there too. The table contents are back up there in Step 2 and they should look normal. Congratulations, everything's working fine! If we were doing this same stuff in the actual tool, it'd use the table to make a list of particle effects. But if the tool was working perfectly for you, then you wouldn't be running this debug thing, now would you? Looks like we're back to square one here.")

end



if SERVER then
	concommand.Add("particlereadtest_server", function()
		MsgN("Beginning SERVERSIDE particle file read test!")
		ParticleControl_FileReadTest()
	end)
end

if CLIENT then
	concommand.Add("particlereadtest_client", function()
		MsgN("Beginning CLIENTSIDE particle file read test!")
		ParticleControl_FileReadTest()
	end)
end