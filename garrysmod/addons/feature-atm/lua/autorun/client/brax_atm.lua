BraxBank = BraxBank or {}

function BraxBank.PlayerMoney(ply)

	return ply:GetNetVar('BankMoney', 0)

end

local ply = FindMetaTable 'Player'

function ply:BankHas(val)

	if val < 0 then return false end
	return BraxBank.PlayerMoney(self) >= val

end
