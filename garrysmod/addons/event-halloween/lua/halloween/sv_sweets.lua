local plyMeta = FindMetaTable 'Player'

function plyMeta:AddSweets(sweets, msg)
	self:SetDBVar('sweets', self:GetDBVar('sweets', 0) + sweets)
	self:SetNetVar('sweets', self:GetDBVar('sweets'))
	if sweets > 0 then
		msg = msg or 'Ты получил %s!'
		self:Notify('hint', msg:format(sweets .. ' ' .. octolib.string.formatCount(sweets, 'конфету', 'конфеты', 'конфет')))
	end
end

hook.Add('dbg-char.firstSpawn', 'dbg-halloween.sweets', function(ply)
	ply:SetNetVar('sweets', ply:GetDBVar('sweets'))
	if ply:GetDBVar('halloweenTheme') then -- !!!!!!!!!!
		ply:SetNetVar('halloweenTheme', true)
		ply:ConCommand('octogui_reloadf4')
	end
end)

netstream.Hook('dbg-halloween.themeToggle', function(ply, status)
	ply.halloweenTheme = tobool(status)
end)


do return end

-- LOGS
hook.Add('dbg-halloween.gotSweets', 'octologs', function(ply, amount, ent)
	local log = octologs.createLog()
		:Add(octologs.ply(ply, {'hp', 'ar', 'job', 'wep'}))
		:Add(' got ', octolib.string.separateDigits(amount), ' sweets')
	if IsValid(ent) then
		log = log:Add(' from ')
			:Add(ent:IsPlayer() and octologs.ply(ent, {'hp', 'ar', 'loc', 'job', 'wep'}) or octologs.ent(ent, {'mdl'}))
	end
	log:Save()
end)

-- COMMAND
hook.Add('Think', 'dbg-halloween.sweetsCommand', function()
hook.Remove('Think', 'dbg-halloween.sweetsCommand')

octochat.registerCommand('!sweets', {
	aliases = {'~sweets'},
	execute = function(ply, _, args)

		local target, txt = octochat.pickOutTarget(args)
		if not IsValid(target) then return txt or 'Формат: !sweets Игрок Количество' end
		local amount = tonumber(txt) or 0
		target:AddSweets(amount or 0)
		hook.Run('dbg-halloween.gotSweets', target, amount, ply)
		ply:Notify('rp', target:Name(), ' получает ', tostring(amount), ' ', octolib.string.formatCount(amount, 'конфету', 'конфеты', 'конфет'))

	end,
	check = DarkRP.isAdmin,
})

end)
