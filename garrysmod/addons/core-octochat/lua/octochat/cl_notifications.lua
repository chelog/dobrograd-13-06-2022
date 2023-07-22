for k, v in pairs(octochat.notifyColors) do

	octolib.notify.registerType(k, function(...)
		surface.PlaySound('buttons/lightswitch2.wav')
		octochat.msg(v, '[#] ', Color(250, 250, 200), ...)
	end)

end
octolib.notify.types._generic = octolib.notify.types.rp
