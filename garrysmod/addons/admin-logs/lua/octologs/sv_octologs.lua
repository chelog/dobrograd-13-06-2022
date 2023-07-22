octologs = octologs or {}
octologs.logsQueue = octologs.logsQueue or {}
octologs.logsFailed = {}
octologs.lastLogTime = 0

--------------------------
-- CATEGORY DEFINITIONS --
octologs.CAT_OTHER = 0
octologs.CAT_ADMIN = 1
octologs.CAT_DONATE = 2
octologs.CAT_BUILD = 3
octologs.CAT_DAMAGE = 4
octologs.CAT_INVENTORY = 5
octologs.CAT_SHOP = 6
octologs.CAT_POLICE = 7
octologs.CAT_PROPERTY = 8
octologs.CAT_LOCKPICK = 9
octologs.CAT_CUFF = 10
octologs.CAT_KARMA = 11
octologs.CAT_GMPANEL = 12
octologs.CAT_VEHICLE = 13
--------------------------

octologs.api = octolib.api({
	url = 'https://octothorp.team/logs/api',
	headers = { ['Authorization'] = CFG.keys.logs },
})

function octologs.log(message, category)

	category = category or octologs.CAT_OTHER
	local log = { os.time(), category, message }
	if CurTime() - octologs.lastLogTime < 0.2 and util.TableToJSON(octologs.lastLog) == util.TableToJSON(log) then return end

	octologs.logsQueue[#octologs.logsQueue + 1] = log
	octologs.lastLog = log
	octologs.lastLogTime = CurTime()

end

local failMode = false
function octologs.sendToApi()

	if #octologs.logsQueue < 1 then return end

	local toSend = octologs.logsQueue
	octologs.logsQueue = {}

	octologs.api:post('/logs', toSend)
		:Then(function(res)
			if failMode then
				failMode = false
				octolib.msg('Logs API connection restored')
			end
		end)
		:Catch(function(err)
			octolib.msg('Failed to send logs, trying to reconnect in 60 seconds')
			failMode = true

			for i, log in ipairs(octologs.logsQueue) do
				toSend[#toSend + 1] = log
			end
			octologs.logsQueue = toSend

			timer.Remove('octologs.sendToApi')
			timer.Simple(60, function()
				timer.Create('octologs.sendToApi', 5, 0, octologs.sendToApi)
			end)
		end)

end
timer.Create('octologs.sendToApi', 5, 0, octologs.sendToApi)
