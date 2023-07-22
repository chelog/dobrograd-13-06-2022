local pMeta = FindMetaTable("Player")

function pMeta:canAfford(amount)
	if not amount or amount < 0 then return false end

	local curMoney = self:GetNetVar("money") or 0
	if curMoney < 0 then return false end

	return curMoney >= math.floor(amount)
end
