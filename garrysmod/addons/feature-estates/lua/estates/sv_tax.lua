-- YOU CAN CHANGE THESE VALUES IF YOU WANT TO
local taxDelay = 600
local warnIn = 120

--[[
MIT License

Copyright (c) 2019-2020 Octothorp Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local payed = {}

local function updateTaxes(ply)
	if not octolib.string.isSteamID(ply) then return end
	ply = player.GetBySteamID(ply)
	if not IsValid(ply) then return end

	local taxes = octolib.table.reduce(ply:GetOwnedEstates(), function(a, v)
		local data = dbgEstates.getData(v)
		if data then
			a = a + (data.price or GAMEMODE.Config.doorcost) * (GAMEMODE.Config.propertytaxcoeff or 0.1)
		end
		return a
	end, 0)
	ply:SetNetVar('taxes', math.ceil(taxes))
end

hook.Add('dbg-estates.owned', 'dbg-estates.tax', updateTaxes)
hook.Add('dbg-estates.unowned', 'dbg-estates.tax', updateTaxes)
hook.Add('PlayerInitialSpawn', 'dbg-estates.tax', function(ply)

	updateTaxes(ply)

	if payed[ply:SteamID()] then
		ply:Notify(('Пока тебя не было, с твоего банковского счета было снято %s за аренду помещений'):format(DarkRP.formatMoney(payed[ply:SteamID()])))
		payed[ply:SteamID()] = nil
	end

end)

local function taxTick()
	for _,v in ipairs(player.GetAll()) do
		local tax = v:GetNetVar('taxes', 0)
		if tax > 0 then
			v:Notify(L.property_tax_warn:format(DarkRP.formatMoney(tax)))
		end
	end
	netvars.SetNetVar('pendingTax', true)

	timer.Simple(warnIn, function()
		local plyTaxes = {}
		for i,v in pairs(netvars.GetNetVar('dbg-estates') or {}) do
			for _,own in ipairs(v.owners or {}) do
				if octolib.string.isSteamID(own) then
					plyTaxes[own] = plyTaxes[own] or {}
					plyTaxes[own].tax = (plyTaxes[own].tax or 0) + (v.price or GAMEMODE.Config.doorcost)
					plyTaxes[own].ests = plyTaxes[own].ests or {}
					plyTaxes[own].ests[#plyTaxes[own].ests + 1] = i
				end
			end
		end

		for steamID,tax in pairs(plyTaxes) do
			local price = math.ceil(tax.tax * (GAMEMODE.Config.propertytaxcoeff or 0.1))
			local ply = player.GetBySteamID(steamID)
			BraxBank.PlayerMoneyAsync(steamID, function(bal)
				if bal <= price then
					for _,v in ipairs(tax.ests) do
						dbgEstates.removeOwner(v, steamID)
					end
					if IsValid(ply) then
						ply:Notify('warning', L.property_tax_cant_afford)
					end
					return
				end

				BraxBank.UpdateMoney(steamID, bal - price)
				if IsValid(ply) then
					ply:Notify(L.property_tax:format(DarkRP.formatMoney(price)))
				else
					payed[steamID] = (payed[steamID] or 0) + price
				end
			end)
		end
		netvars.SetNetVar('pendingTax')

		timer.Simple(taxDelay - warnIn, taxTick)
	end)
end
timer.Simple(taxDelay - warnIn, taxTick)
