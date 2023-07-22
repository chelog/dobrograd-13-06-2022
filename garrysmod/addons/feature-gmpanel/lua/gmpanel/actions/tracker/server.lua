gmpanel.registerAction('tracker', function(obj, ply)
	local msg = octolib.string.splitByUrl(tostring(obj.text or 'Уведомление'))
	if IsValid(ply) then ply:Notify(obj.channel or 'rp', unpack(msg)) end
end)
