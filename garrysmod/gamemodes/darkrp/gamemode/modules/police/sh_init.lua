local plyMeta = FindMetaTable("Player")

/*---------------------------------------------------------------------------
Interface functions
---------------------------------------------------------------------------*/
function plyMeta:isArrested()
	return self:GetNetVar("Arrested")
end

function plyMeta:isWanted()
	return tobool(self:GetNetVar("wanted"))
end

function plyMeta:getWantedReason()
	return self:GetNetVar("wanted")
end

function plyMeta:isCP()
	if not IsValid(self) then return false end
	local job = self:getJobTable()
	return job and job.police or false
end

local dpdChiefRanks = octolib.array.toKeys({'cap', 'com', 'asc', 'chi'})
function plyMeta:isChief()
	if self:getJobTable().chief then return true end
	if self.GetActiveRank then
		local rank = self:GetActiveRank('dpd')
		if rank and dpdChiefRanks[rank] then return true end
	end
	return false
end
function plyMeta:isMayor()
	return self:getJobTable().mayor and self:GetActiveRank('gov') ~= 'worker' or false
end

function player.GetPolice()
	return octolib.array.filter(player.GetAll(), plyMeta.isCP)
end

/*---------------------------------------------------------------------------
Hooks
---------------------------------------------------------------------------*/

hook.Add('dbg-travel.canTransfer', 'dbg-police.wanted', function(ply)
	if ply:GetNetVar('wanted') then return false, L.bus_you_wanted end
end)
