local plyMeta = FindMetaTable("Player")

-- Assert function, asserts a property and returns the error if false.
-- Allows f to override err and hints by simply returning them
local ass = function(f, err, hints) return function(...)
	local res = {f(...)}
	table.insert(res, err)
	table.insert(res, hints)

	return unpack(res)
end end

-- Returns whether a value is nil
local isnil = fn.Curry(fn.Eq, 2)(nil)
-- Optional value, when filled in it must meet the conditions
local optional = function(...) return fn.FOr{isnil, ...} end
-- Check the correctness of a model
local checkModel = isstring

-- A table of which each element must meet condition f
local tableOf = function(f) return function(tbl)
	if not istable(tbl) then return false end
	for k,v in pairs(tbl) do if not f(v) then return false end end
	return true
end end

-- A table that is nonempty, wrap around tableOf
local nonempty = function(f) return function(tbl) return istable(tbl) and #tbl > 0 and f(tbl) end end

local uniqueJob = function(v, tbl)
	local job = DarkRP.getJobByCommand(v)
	if job then return false, "This job does not have a unique command.", {"There must be some other job that has the same command.", "Fix this by changing the 'command' of your job to something else."} end
	return true
end

-- Template for a correct job
local requiredTeamItems = {
	color	   = ass(tableOf(isnumber), "The color must be a Color value.", {"Color values look like this: Color(r, g, b, a), where r, g, b and a are numbers between 0 and 255."}),
	weapons	 = ass(optional(istable), "The weapons must be a valid table of strings.", {"Example: weapons = {\"med_kit\", \"weapon_bugbait\"},"}),
	command	 = ass(fn.FAnd{isstring, uniqueJob}, "The command must be a string."),
	max		 = ass(fn.FAnd{isnumber, fp{fn.Lte, 0}}, "The max must be a number greater than or equal to zero.", {"Zero means infinite.", "A decimal between 0 and 1 is seen as a percentage."}),
	salary	  = ass(fn.FAnd{isnumber, fp{fn.Lte, 0}}, "The salary must be a number greater than zero."),
	admin	   = ass(fn.FAnd{isnumber, fp{fn.Lte, 0}, fp{fn.Gte, 2}}, "The admin value must be a number greater than or equal to zero and smaller than three."),

	-- Optional advanced stuff
	category			  = ass(optional(isstring), "The category must be the name of an existing category!"),
	sortOrder			 = ass(optional(isnumber), "The sortOrder must be a number."),
	buttonColor		   = ass(optional(tableOf(isnumber)), "The buttonColor must be a Color value."),
	label				 = ass(optional(isstring), "The label must be a valid string."),
	ammo				  = ass(optional(tableOf(isnumber)), "The ammo must be a table containing numbers.", {"See example on http://wiki.darkrp.com/index.php/DarkRP:CustomJobFields"}),
	hasLicense			= ass(optional(isbool), "The hasLicense must be either true or false."),
	NeedToChangeFrom	  = ass(optional(tableOf(isnumber), isnumber), "The NeedToChangeFrom must be either an existing team or a table of existing teams", {"Is there a job here that doesn't exist (anymore)?"}),
	customCheck		   = ass(optional(isfunction), "The customCheck must be a function."),
	CustomCheckFailMsg	= ass(optional(isstring, isfunction), "The CustomCheckFailMsg must be either a string or a function."),
	modelScale			= ass(optional(isnumber), "The modelScale must be a number."),
	maxpocket			 = ass(optional(isnumber), "The maxPocket must be a number."),
	maps				  = ass(optional(tableOf(isstring)), "The maps value must be a table of valid map names."),
	candemote			 = ass(optional(isbool), "The candemote value must be either true or false."),
	mayor				 = ass(optional(isbool), "The mayor value must be either true or false."),
	chief				 = ass(optional(isbool), "The chief value must be either true or false."),
	medic				 = ass(optional(isbool), "The medic value must be either true or false."),
	cook				  = ass(optional(isbool), "The cook value must be either true or false."),
	hobo				  = ass(optional(isbool), "The hobo value must be either true or false."),
	playerClass		   = ass(optional(isstring), "The playerClass must be a valid string."),
	CanPlayerSuicide	  = ass(optional(isfunction), "The CanPlayerSuicide must be a function."),
	PlayerCanPickupWeapon = ass(optional(isfunction), "The PlayerCanPickupWeapon must be a function."),
	PlayerDeath		   = ass(optional(isfunction), "The PlayerDeath must be a function."),
	PlayerLoadout		 = ass(optional(isfunction), "The PlayerLoadout must be a function."),
	PlayerSelectSpawn	 = ass(optional(isfunction), "The PlayerSelectSpawn must be a function."),
	PlayerSetModel		= ass(optional(isfunction), "The PlayerSetModel must be a function."),
	PlayerSpawn		   = ass(optional(isfunction), "The PlayerSpawn must be a function."),
	PlayerSpawnProp	   = ass(optional(isfunction), "The PlayerSpawnProp must be a function."),
	RequiresVote		  = ass(optional(isfunction), "The RequiresVote must be a function."),
	ShowSpare1			= ass(optional(isfunction), "The ShowSpare1 must be a function."),
	ShowSpare2			= ass(optional(isfunction), "The ShowSpare2 must be a function."),
	canStartVote		  = ass(optional(isfunction), "The canStartVote must be a function."),
	canStartVoteReason	= ass(optional(isstring, isfunction), "The canStartVoteReason must be either a string or a function."),
}

local validAgenda = {
	Title = ass(isstring, "The title must be a string."),
	Manager = ass(fn.FOr{isnumber, nonempty(tableOf(isnumber))}, "The Manager must either be a single team or a non-empty table of existing teams.", {"Is there a job here that doesn't exist (anymore)?"}),
	Listeners = ass(nonempty(tableOf(isnumber)), "The Listeners must be a non-empty table of existing teams.",
		{
			"Is there a job here that doesn't exist (anymore)?",
			"Are you trying to have multiple manager jobs in this agenda? In that case you must put the list of manager jobs in curly braces.",
			[[Like so: DarkRP.createAgenda("Some agenda", {TEAM_MANAGER1, TEAM_MANAGER2}, {TEAM_LISTENER1, TEAM_LISTENER2})]]
		})
}

-- Check template against actual implementation
local env = {} -- environment used to be check propositions between multiple tables
local function checkValid(tbl, requiredItems, oEnv) -- Allow override environment
	for k,v in pairs(requiredItems) do
		local correct, err, hints = tbl[v] ~= nil
		if isfunction(v) then correct, err, hints = v(tbl[k], tbl, oEnv or env) end
		err = err or string.format("Element '%s' is corrupt!", k)
		if not correct then return correct, err, hints end
	end

	return true
end

-----------------------------------------------------------
-- Job commands --
-----------------------------------------------------------

RPExtraTeams = {}
local jobByCmd = {}
DarkRP.getJobByCommand = function(cmd)
	if not jobByCmd[cmd] then return nil, nil end
	return RPExtraTeams[jobByCmd[cmd]], jobByCmd[cmd]
end
plyMeta.getJobTable = fn.FOr{fn.Compose{fn.Curry(fn.Flip(fn.GetValue), 2)(RPExtraTeams), plyMeta.Team}, fn.Curry(fn.Id, 2)({})}
local jobCount = 0
function DarkRP.createJob(Name, colorOrTable, Weapons, command, maximum_amount_of_this_class, Salary, admin, Haslicense, NeedToChangeFrom, CustomCheck)
	local tableSyntaxUsed = not IsColor(colorOrTable)

	local CustomTeam = tableSyntaxUsed and colorOrTable or
		{color = colorOrTable, weapons = Weapons, command = command,
			max = maximum_amount_of_this_class, salary = Salary, admin = admin or 0, hasLicense = Haslicense,
			NeedToChangeFrom = NeedToChangeFrom, customCheck = CustomCheck
		}
	CustomTeam.name = Name
	CustomTeam.default = DarkRP.DARKRP_LOADING

	local valid, err, hints = checkValid(CustomTeam, requiredTeamItems)
	if not valid then DarkRP.error(string.format("Corrupt team: %s!\n%s", CustomTeam.name or "", err), 3, hints) end

	jobCount = jobCount + 1
	CustomTeam.team = jobCount

	CustomTeam.salary = math.floor(CustomTeam.salary)

	CustomTeam.customCheck		   = CustomTeam.customCheck		   and fp{DarkRP.simplerrRun, CustomTeam.customCheck}
	CustomTeam.CustomCheckFailMsg = isfunction(CustomTeam.CustomCheckFailMsg) and fp{DarkRP.simplerrRun, CustomTeam.CustomCheckFailMsg} or CustomTeam.CustomCheckFailMsg
	CustomTeam.CanPlayerSuicide	  = CustomTeam.CanPlayerSuicide	  and fp{DarkRP.simplerrRun, CustomTeam.CanPlayerSuicide}
	CustomTeam.PlayerCanPickupWeapon = CustomTeam.PlayerCanPickupWeapon and fp{DarkRP.simplerrRun, CustomTeam.PlayerCanPickupWeapon}
	CustomTeam.PlayerDeath		   = CustomTeam.PlayerDeath		   and fp{DarkRP.simplerrRun, CustomTeam.PlayerDeath}
	CustomTeam.PlayerLoadout		 = CustomTeam.PlayerLoadout		 and fp{DarkRP.simplerrRun, CustomTeam.PlayerLoadout}
	CustomTeam.PlayerSelectSpawn	 = CustomTeam.PlayerSelectSpawn	 and fp{DarkRP.simplerrRun, CustomTeam.PlayerSelectSpawn}
	CustomTeam.PlayerSetModel		= CustomTeam.PlayerSetModel		and fp{DarkRP.simplerrRun, CustomTeam.PlayerSetModel}
	CustomTeam.PlayerSpawn		   = CustomTeam.PlayerSpawn		   and fp{DarkRP.simplerrRun, CustomTeam.PlayerSpawn}
	CustomTeam.PlayerSpawnProp	   = CustomTeam.PlayerSpawnProp	   and fp{DarkRP.simplerrRun, CustomTeam.PlayerSpawnProp}
	CustomTeam.RequiresVote		  = CustomTeam.RequiresVote		  and fp{DarkRP.simplerrRun, CustomTeam.RequiresVote}
	CustomTeam.ShowSpare1			= CustomTeam.ShowSpare1			and fp{DarkRP.simplerrRun, CustomTeam.ShowSpare1}
	CustomTeam.ShowSpare2			= CustomTeam.ShowSpare2			and fp{DarkRP.simplerrRun, CustomTeam.ShowSpare2}
	CustomTeam.canStartVote		  = CustomTeam.canStartVote		  and fp{DarkRP.simplerrRun, CustomTeam.canStartVote}

	jobByCmd[CustomTeam.command] = table.insert(RPExtraTeams, CustomTeam)
	team.SetUp(#RPExtraTeams, Name, CustomTeam.color)
	local Team = #RPExtraTeams

	return Team
end
AddExtraTeam = DarkRP.createJob

local function removeCustomItem(tbl, hookName, i)
	local item = tbl[i]
	tbl[i] = nil
	hook.Run(hookName, i, item)
end

function DarkRP.removeJob(i)
	local job = RPExtraTeams[i]
	jobByCmd[job.command] = nil
	jobCount = jobCount - 1

	removeCustomItem(RPExtraTeams, "onJobRemoved", i)
end

/*---------------------------------------------------------------------------
Decides whether a custom job or shipmet or whatever can be used in a certain map
---------------------------------------------------------------------------*/
function GM:CustomObjFitsMap(obj)
	if not obj or not obj.maps then return true end

	local map = string.lower(game.GetMap())
	for k,v in pairs(obj.maps) do
		if string.lower(v) == map then return true end
	end
	return false
end

-- here for backwards compatibility
DarkRPAgendas = {}

local agendas = {}
-- Returns the agenda managed by the player
plyMeta.getAgenda = fn.Compose{fn.Curry(fn.Flip(fn.GetValue), 2)(DarkRPAgendas), plyMeta.Team}

-- Returns the agenda this player is member of
function plyMeta:getAgendaTable()
	return agendas[self:Team()]
end

DarkRP.getAgendas = fp{fn.Id, agendas}

function DarkRP.createAgenda(Title, Manager, Listeners)
	if DarkRP.DARKRP_LOADING and DarkRP.disabledDefaults["agendas"][Title] then return end

	local agenda = {Manager = Manager, Title = Title, Listeners = Listeners, ManagersByKey = {}}
	agenda.default = DarkRP.DARKRP_LOADING

	local valid, err, hints = checkValid(agenda, validAgenda)
	if not valid then DarkRP.error(string.format("Corrupt agenda: %s!\n%s", agenda.Title or "", err), 2, hints) end

	for k,v in pairs(Listeners) do
		agendas[v] = agenda
	end

	for k,v in pairs(istable(Manager) and Manager or {Manager}) do
		agendas[v] = agenda
		DarkRPAgendas[v] = agenda -- backwards compat
		agenda.ManagersByKey[v] = true
	end

	if SERVER then
		timer.Simple(0, function()
			-- Run after scripts have loaded
			agenda.text = hook.Run("agendaUpdated", nil, agenda, "")
		end)
	end
end
AddAgenda = DarkRP.createAgenda

function DarkRP.removeAgenda(title)
	local agenda
	for k,v in pairs(agendas) do
		if v.Title == title then
			agenda = v
			agendas[k] = nil
		end
	end

	for k,v in pairs(DarkRPAgendas) do
		if v.Title == title then agendas[k] = nil end
	end
	hook.Run("onAgendaRemoved", title, agenda)
end
