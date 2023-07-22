local jailPos = {}
local nextJail = 0

local function refreshJails()

	octolib.getDBVar('jailpos', game.GetMap(), {}):Then(function(data)
		jailPos = data
	end)

end

hook.Add('octolib.db.init', 'dbg-police.jailPos', function()
	timer.Simple(5, refreshJails)
end)

hook.Add('octolib.event:dbg-police.refreshJails', 'dbg-police.refreshJails', function(data)
	if data[1] == game.GetMap() then refreshJails() end
end)

local function save()
	octolib.setDBVar('jailpos', game.GetMap(), jailPos):Then(function()
		octolib.sendCmdToOthers('dbg-police.refreshJails', {game.GetMap()})
	end)
end

function dbgPolice.addJailPos(pos)
	if not isvector(pos) then return end
	jailPos[#jailPos + 1] = {pos.x, pos.y, pos.z}
	save()
end

function dbgPolice.clearJailPos()
	jailPos = {}
	save()
end

function dbgPolice.nextJailPos()
	nextJail = nextJail + 1
	if nextJail > #jailPos then nextJail = 1 end
	local pos = jailPos[nextJail]
	if not pos then return end
	return Vector(pos[1], pos[2], pos[3])
end

function dbgPolice.haveJailPos()
	return jailPos[1] ~= nil
end
