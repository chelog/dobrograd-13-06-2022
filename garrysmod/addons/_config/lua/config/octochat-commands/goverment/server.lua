octochat.registerCommand('/gr', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, txt)

		if txt == '' then return 'Формат: /gr Текст сообщения' end

		local veh
		for _, ent in ipairs(ents.FindInSphere(ply:GetPos(), 100)) do
			if ent.IsSimfphyscar and not ent.preventEms then veh = ent break end
		end
		if not IsValid(veh) then
			return 'Рядом должен находиться служебный автомобиль'
		end

		octochat.talkToRange(ply, 1500, Color(13, 134, 255), L.megaphone, color_white, txt)
		veh:EmitSound('ambient/chatter/cb_radio_chatter_' .. math.random(1,3) .. '.wav', 130, 100, 1)

	end,
	check = DarkRP.isGov,
})

local leaveMeAloneID = 1
octochat.registerCommand('/panicbutton', {
	cooldown = 60,
	log = true,
	execute = function(ply)
        local job, jobname = ply:getJobTable()
        if job then jobname = job.name end
        local customJob = ply:GetNetVar('customJob')
        if customJob then jobname = unpack(customJob) end

		ply:DoEmote('{name} нажимает кнопку паники')

        local msg = ('%s %s передает свое местоположение, используя тревожную кнопку!'):format(jobname, ply:Name())
		local marker = {
			id = 'cpPanicBtn' .. leaveMeAloneID,
			group = 'cpPanicBtn',
			txt = 'Кнопка паники',
			pos = ply:GetPos() + Vector(0,0,40),
			col = Color(102,170,170),
			des = {'timedist', { 600, 300 }},
			icon = 'octoteam/icons-32/exclamation.png',
			size = 32,
		}
		for _,v in ipairs(player.GetAll()) do
			if v:isCP() then
				v:Notify('warning', msg)
				v:EmitSound('npc/attack_helicopter/aheli_damaged_alarm1.wav', 45, 100, 0.5)
				v:AddMarker(marker)
			end
		end
		leaveMeAloneID = leaveMeAloneID + 1

	end,
	check = DarkRP.isGov,
})