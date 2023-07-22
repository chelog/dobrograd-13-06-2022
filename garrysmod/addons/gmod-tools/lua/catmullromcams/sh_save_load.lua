-- I REALLLY don't feel like working through this mess of networking
-- so saving/loading in multiplayer is only possible if you're the listen host.

CatmullRomCams.SH.SaveLoad = {}

function CatmullRomCams.SH.SaveLoad.RequestSpawn(filename)
	if (not filename) or SERVER or (LocalPlayer() ~= player.GetByID(1)) then return end
	
	return RunConsoleCommand("~CatmullRomCams_RequestSpawn", filename)
end

function CatmullRomCams.SH.SaveLoad.Spawn_CCmd(ply, cmd, args)
	local filename = args[1] or ""
	
	if not file.Exists(CatmullRomCams.FilePath .. filename) then return ErrorNoHalt("Attempted to load non-existant track named '", filename, "'\n") end
	
	local data = util.KeyValuesToTable(file.Read(CatmullRomCams.FilePath .. filename) or "") or {}
	
	if not data[1] then return ErrorNoHalt("Invalid load track table given.\n") end
	
	for k, v in ipairs(data[1]) do
		
	end
end
concommand.Add("~CatmullRomCams_RequestSpawn", CatmullRomCams.SH.SaveLoad.Spawn_CCmd)

