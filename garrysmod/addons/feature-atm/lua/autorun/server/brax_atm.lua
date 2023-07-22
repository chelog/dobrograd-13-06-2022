BraxBank = {}

local startMoney = CreateConVar("braxnet_atm_startmoney", 0, {FCVAR_ARCHIVE, FCVAR_PROTECTED, FCVAR_SERVER_CAN_EXECUTE}, "User start money")
local salary = CreateConVar("braxnet_atm_salary", 0, {FCVAR_ARCHIVE, FCVAR_PROTECTED, FCVAR_SERVER_CAN_EXECUTE}, "Payday goes straight into bank account.")

-- Helper functions

local function notifyAboutBalanceUpdate(ply, delta)
	if not ply:HasPhone() then return end
	local msg
	if delta < 0 then
		msg = ('С твоего банковского счета списано %s.'):format(DarkRP.formatMoney(-delta))
	else
		msg = ('На твой банковский счет зачислено %s.'):format(DarkRP.formatMoney(delta))
	end
	msg = msg .. (' Баланс: %s'):format(DarkRP.formatMoney(BraxBank.PlayerMoney(ply)))
	ply:SendSMS(octochat.textColors.rp, 'Банк', L.owner_sms, Color(250,250,200), msg)
end

local function databaseInit()

	MySQLite.query([[
		CREATE TABLE IF NOT EXISTS dbg_atm (
			steamID VARCHAR(50) NOT NULL PRIMARY KEY,
			money INT(15)
		)
	]])

end
hook.Add("DarkRPDBInitialized", "dbg-atm", databaseInit)

function BraxBank.StartMoney()
	return startMoney:GetInt()
end

function BraxBank.InitPlayer(ply)

	MySQLite.query(string.format([[SELECT * FROM dbg_atm WHERE steamID = %s]], MySQLite.SQLStr(ply:SteamID())), function(res)

		res = res and res[1]
		if res then
			ply:SetLocalVar('BankMoney', res.money)
		else
			local startMoney = BraxBank.StartMoney()
			ply:SetLocalVar('BankMoney', startMoney)

			MySQLite.query(string.format(
				[[INSERT INTO dbg_atm (steamID, money)
				VALUES (%s, %d)]],
				MySQLite.SQLStr(ply:SteamID()),
				startMoney
			))

			print('[DBG-ATM] Adding bank for ' .. tostring(ply))
		end

	end)

end

function BraxBank.SavePlayer(ply)

	MySQLite.query(string.format([[UPDATE dbg_atm SET money = %d WHERE steamID = %s]],
		BraxBank.PlayerMoney(ply),
		MySQLite.SQLStr(ply:SteamID())
	))

end

function BraxBank.PlayerMoney(ply)

	return ply:GetNetVar('BankMoney', 0)

end

function BraxBank.PlayerMoneyAsync(ply, handler)

	if not isfunction(handler) then return end

	if isstring(ply) then
		local inst = player.GetBySteamID(ply)
		if IsValid(inst) then
			handler(BraxBank.PlayerMoney(inst))
			return
		end

		MySQLite.query(string.format([[SELECT money FROM dbg_atm WHERE steamID = %s]], MySQLite.SQLStr(ply)), function(res)
			res = res and res[1]
			handler(res and res.money or GetConVarNumber('braxnet_atm_startmoney'))
		end)
	else
		handler(BraxBank.PlayerMoney(ply))
	end

end

function BraxBank.UpdateMoney(ply, amount, doNotNotify)

	if isstring(ply) and not IsValid(player.GetBySteamID(ply)) then
		MySQLite.query(string.format([[UPDATE dbg_atm SET money = %d WHERE steamID = %s]],
			amount, MySQLite.SQLStr(ply)
		))
	else
		if isstring(ply) then ply = player.GetBySteamID(ply) end
		if not IsValid(ply) then return end

		local delta = amount - ply:GetLocalVar('BankMoney', 0)
		ply:SetLocalVar('BankMoney', amount)
		BraxBank.SavePlayer(ply)
		if not doNotNotify then notifyAboutBalanceUpdate(ply, delta) end
	end

end

function BraxBank.TakeAction(ply)

	ply:addExploitAttempt()

end

hook.Add("PlayerFinishedLoading", "dbg-atm", BraxBank.InitPlayer)
-- hook.Add("PlayerDisconnected", "dbg-atm", BraxBank.SavePlayer)

local startmoney = 300
hook.Add('dbg-char.spawn', 'dbg-atm', function(ply)

	if hook.Run('octoinv.overrideInventories') == false then return end

	local money = BraxBank.PlayerMoney(ply)
	if not ply:IsGhost() and ply.inv and not ply:canAfford(startmoney) and money >= startmoney then
		BraxBank.UpdateMoney(ply, money - startmoney)
		ply:addMoney(startmoney)
		ply:Notify('ooc', L.brax_atm_hint, DarkRP.formatMoney(startmoney), L.from_bank)
	end

end)

--[[
	Return codes!!
	1 = NULL
	2 = Deposit, bank does not have money
	3 = Deposit, ok
	4 = Insert, User does not have enough money
	5 = Insert, ok
]]--

util.AddNetworkString( "BraxAtmWithdraw" )
net.Receive( "BraxAtmWithdraw", function( length, client )

	local WithdrawValue = net.ReadInt(32)
	local UserMoney = BraxBank.PlayerMoney(client)

	local atm
	for _,v in pairs(ents.FindByClass("brax_atm")) do
		if IsValid(v) and v:GetClass() == "brax_atm" and v:GetPos():Distance(client:GetShootPos()) < 256 then atm = v end
	end
	if atmcheck == false then BraxBank.TakeAction(client) return end
	if WithdrawValue <= 0 then BraxBank.TakeAction(client) return end

	if not client:BankHas(WithdrawValue) then
		BraxBankAtmReturnCode(atm, 2, client)
		return
	end

	local NewVal = UserMoney - WithdrawValue
	if NewVal < 0 then BraxBank.TakeAction(client) return end

	BraxBank.UpdateMoney(client, NewVal)
	client:addMoney(WithdrawValue)
	hook.Run('atm.withdraw', client, WithdrawValue)

	BraxBankAtmReturnCode(atm, 3, client)

end)

-- INSERT MONEY
util.AddNetworkString( "BraxAtmDeposit" )
net.Receive( "BraxAtmDeposit", function( length, client )

	local DepositValue = net.ReadInt(32)
	local UserMoney = BraxBank.PlayerMoney(client)

	-- do some simple cheat checks
	local atm
	for _,v in pairs(ents.FindByClass("brax_atm")) do
		if IsValid(v) and v:GetClass() == "brax_atm" and v:GetPos():Distance(client:GetShootPos()) < 256 then atm = v end
	end
	if atmcheck == false then BraxBank.TakeAction(client) return end
	if DepositValue <= 0 then BraxBank.TakeAction(client) return end

	if not client:canAfford(DepositValue) then
		BraxBankAtmReturnCode(atm, 4, client)
		return
	end

	local NewVal = UserMoney + DepositValue
	if NewVal < 0 then BraxBank.TakeAction(client) return end

	BraxBank.UpdateMoney(client, NewVal)
	client:addMoney(-DepositValue)
	hook.Run('atm.deposit', client, DepositValue)
	BraxBankAtmReturnCode(atm, 5, client)

end)

function BraxBankAtmUpdate(client)

	local m = BraxBank.PlayerMoney(client)
	net.Start( "BraxAtmFetch" )
		net.WriteInt(m, 32)
	net.Send(client)

end

util.AddNetworkString( "BraxAtmReturnCode" )
function BraxBankAtmReturnCode(ent, code, client)

	net.Start( "BraxAtmReturnCode" )
		net.WriteEntity(ent)
		net.WriteInt(code, 32)
	net.Send(client)

end

concommand.Add("brax_atm_update", function(p, c, a)

	BraxBankAtmUpdate(p)

end)

util.AddNetworkString( "BraxAtmFetch" )

hook.Add("playerGetSalary","BraxAtmSalary", function(ply, amount)
	if salary:GetInt() > 0 then
		local money = BraxBank.PlayerMoney(ply)
		BraxBank.UpdateMoney(ply, money+amount)
		return false, L.brax_atm_salary .. DarkRP.formatMoney(amount), 0
	end
end)

--
-- META
--

local ply = FindMetaTable 'Player'

function ply:BankAdd(val, doNotNotify)

	BraxBank.UpdateMoney(self, BraxBank.PlayerMoney(self) + val, true)
	if not doNotNotify then notifyAboutBalanceUpdate(self, val) end

end

function ply:BankHas(val)

	if val < 0 then return false end

	local balance = BraxBank.PlayerMoney(self)
	if balance < 0 then return false end

	return balance >= val

end

