dbgCerts = dbgCerts or {}
include('config/certificates.lua')

function dbgCerts.give(ply, id, title, add, em, pos, iss, vthru)
	ply:SetDBVar('cert', {
		id = id,
		titl = title,
		add = add,
		em = em,
		pos = pos,
		iss = iss,
		vthru = vthru,
	})
	ply:Notify('Тебе выдали ' .. title .. '! Чтобы показать его, в "круговом меню" взаимодействия с другим игроком выбери "Показать удостоверение."')
	return true
end

local nextShow = {}

timer.Create('dbg-idcards.clear', 60, 0, function()
	for shower,showeees in pairs(nextShow) do
		for showeee,nextTime in pairs(showeees) do
			if nextTime <= CurTime() then
				nextShow[shower][showeee] = nil
			end
		end
		if #showeees == 0 then nextShow[shower] = nil end
	end
end)

local function read(ply, cert)
	octochat.talkTo(ply, octochat.textColors.rp, '====================')
	octochat.talkTo(ply, octochat.textColors.rp, dbgCerts.certTitles[cert.id])
	if cert.add then
		octochat.talkTo(ply, octochat.textColors.rp, cert.add)
	end
	if cert.em then
		octochat.talkTo(ply, octochat.textColors.rp, 'Выдано ', cert.em)
	end
	if cert.pos then
		octochat.talkTo(ply, octochat.textColors.rp, 'На должности ', cert.pos)
	end
	if cert.iss then
		octochat.talkTo(ply, octochat.textColors.rp, 'Дата выдачи: ', os.date('%d.%m.%Y', cert.iss))
	end
	octochat.talkTo(ply, octochat.textColors.rp, 'Действует до: ', os.date('%d.%m.%Y', cert.vthru))
	octochat.talkTo(ply, octochat.textColors.rp, '====================')
end

function dbgCerts.show(shower, showee, noTimer, noEmote)
	local cert = shower:GetDBVar('cert')
	if not cert then return false, 'У тебя нет действительного удостоверения' end
	if not dbgCerts.certTitles[cert.id] or cert.vthru < os.time() then
		shower:SetDBVar('cert', nil)
		return false, 'У тебя нет действительного удостоверения'
	end
	local sid, tid = shower:SteamID(), showee:SteamID()
	if not noTimer then
		if not nextShow[sid] then nextShow[sid] = {} end
		if (nextShow[sid][tid] or CurTime()) > CurTime() then
			return false, 'Этот игрок уже недавно видел твое удостоверение'
		end
		nextShow[sid][tid] = CurTime() + 120
	end
	if not noEmote then shower:DoEmote('{name} показывает удостоверение') end
	timer.Simple(1, function()
		if IsValid(showee) then read(showee, cert) end
	end)
	return true
end
