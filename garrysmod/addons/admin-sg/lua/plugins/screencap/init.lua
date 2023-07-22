serverguard.AddFolder('screencap');

local plugin = plugin;

plugin:IncludeFile('shared.lua', SERVERGUARD.STATE.SHARED);
plugin:IncludeFile('cl_panel.lua', SERVERGUARD.STATE.CLIENT);

netstream.Hook('sg.octolib-grab', function(ply, target)

	if not IsValid(target) or not target:IsPlayer() then return end

	local immAdmin, immTarget = serverguard.player:GetImmunity(ply), serverguard.player:GetImmunity(target)
	if immAdmin >= immTarget and serverguard.player:HasPermission(ply, 'Screencap') then
		octolib.grab.sendToImgur(target):Then(function(r)
			netstream.Start(ply, 'sg.octolib-grab', target, r)
		end):Catch(function(r)
			netstream.Start(ply, 'sg.octolib-grab', target, false)
		end)
	else
		netstream.Start(ply, 'sg.octolib-grab', target, false)
	end

end)
