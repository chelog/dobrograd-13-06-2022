local mayorData = {check = DarkRP.isMayor}
octochat.defineCommand('/broadcast', mayorData)
octochat.defineCommand('/addlaw', mayorData)
octochat.defineCommand('/removelaw', mayorData)
octochat.defineCommand('/resetlaws', mayorData)
octochat.defineCommand('/lockdown', mayorData)
octochat.defineCommand('/unlockdown', mayorData)
octochat.defineCommand('/renamecity', mayorData)
octochat.defineCommand('/resetcity', true)

local function updateGMFuncs()
	if not DarkRP then return end

	function DarkRP.getLaws()
		return netvars.GetNetVar('laws')
	end

end
hook.Add('darkrp.loadModules', 'dbg-commands.mayor', updateGMFuncs)
updateGMFuncs()
