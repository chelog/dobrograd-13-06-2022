/*---------------------------------------------------------
 Database initialize
 ---------------------------------------------------------*/
function DarkRP.initDatabase()
	hook.Call('DarkRPDBInitialized') -- we don't need anything from DarkRP anymore, hurray
end

/*---------------------------------------------------------
Players
 ---------------------------------------------------------*/
local ply = FindMetaTable 'Player'
function ply:Salary()
	return self:GetNetVar('salary', GAMEMODE.Config.normalsalary)
end
function ply:SetSalary(amount)
	if not amount then
		return self:SetLocalVar('salary', nil)
	end
	amount = tonumber(amount)
	if not amount or amount < 0 then return end
	if amount == GAMEMODE.Config.normalsalary then
		self:SetLocalVar('salary', nil)
	else
		self:SetLocalVar('salary', amount)
	end
end
