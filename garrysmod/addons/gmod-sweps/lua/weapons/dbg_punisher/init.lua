AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'
include 'shared.lua'

netstream.Hook('dbg-punisher.kick', function(ply, target)
	if not (ply:IsAdmin() and IsValid(target) and target:IsPlayer()) then return end
	serverguard.command.Run(ply, 'kick', true, target:SteamID(), 'Нарушение атмосферы')
end)

netstream.Hook('dbg-punisher.mute', function(ply, target)
	if not (ply:IsAdmin() and IsValid(target) and target:IsPlayer()) then return end
	if not target:GetDBVar('sgMuted') then
		serverguard.command.Run(ply, 'mute', true, target:SteamID(), 15)
		serverguard.command.Run(ply, 'gag', true, target:SteamID(), 15)
		ply:Notify('ooc', L.gag_and_mute:format(target:Name()))
		target:Notify('ooc', ply:Name() .. L.gag_and_mute2)
	else
		serverguard.command.Run(ply, 'unmute', true, target:SteamID())
		serverguard.command.Run(ply, 'ungag', true, target:SteamID())
		ply:Notify('ooc', L.ungag_and_unmute:format(target:Name()))
		target:Notify('ooc', ply:Name() .. L.ungag_and_unmute2)
	end
end)
