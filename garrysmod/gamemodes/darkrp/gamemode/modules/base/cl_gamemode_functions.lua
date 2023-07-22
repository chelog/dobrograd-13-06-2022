GUIToggled = false
local mouseX, mouseY = ScrW() / 2, ScrH() / 2
local anim = 0

function GM:ShowSpare1()
	GUIToggled = not GUIToggled

	if GUIToggled then
		gui.SetMousePos(mouseX, mouseY)
	else
		mouseX, mouseY = gui.MousePos()
	end
	gui.EnableScreenClicker(GUIToggled)
end

hook.Add( "HUDPaint", "dbg-clicker", function()

	anim = math.Approach( anim, GUIToggled and 1 or 0, FrameTime() * 3 )
	if anim ~= 0 and anim ~= 1 then
		local offset = 16 * math.pow( anim, 0.4 )

		local poly = {}
		for i = 1, 24 do
			poly[ i ] = { x = mouseX + math.cos( math.pi / 12 * i ) * offset, y = mouseY + math.sin( math.pi / 12 * i ) * offset }
		end

		draw.NoTexture()
		surface.SetDrawColor( 235,235,235, math.pow( 1 - anim, 2 ) * 255 )
		surface.DrawPoly( poly )
	end

end)

function GM:PlayerStartVoice(ply)
	if ply == LocalPlayer() then
		ply.DRPIsTalking = true
		return -- Not the original rectangle for yourself! ugh!
	end
	self.BaseClass:PlayerStartVoice(ply)
end

function GM:PlayerEndVoice(ply)
	if ply == LocalPlayer() then
		ply.DRPIsTalking = false
		return
	end

	self.BaseClass:PlayerEndVoice(ply)
end

function GM:OnPlayerChat()
end

local FKeyBinds = {
	["gm_showhelp"] = "ShowHelp",
	["gm_showteam"] = "ShowTeam",
	["gm_showspare1"] = "ShowSpare1",
	["gm_showspare2"] = "ShowSpare2"
}

function GM:PlayerBindPress(ply, bind, pressed)
	self.BaseClass:PlayerBindPress(ply, bind, pressed)

	local bnd = string.match(string.lower(bind), "gm_[a-z]+[12]?")
	if bnd and FKeyBinds[bnd] then
		hook.Call(FKeyBinds[bnd], GAMEMODE)
	end

	if not self.Config.deadvoice and not ply:Alive() and string.find(string.lower(bind), "voicerecord") then return true end
end

function GM:InitPostEntity()
	hook.Call("teamChanged", GAMEMODE, GAMEMODE.DefaultTeam, GAMEMODE.DefaultTeam)
end

function GM:teamChanged(before, after)
end

local function OnChangedTeam(len)
	local oldTeam, newTeam = net.ReadUInt(16), net.ReadUInt(16)
	hook.Call("teamChanged", GAMEMODE, oldTeam, newTeam) -- backwards compatibility
	hook.Call("OnPlayerChangedTeam", GAMEMODE, LocalPlayer(), oldTeam, newTeam)
end
net.Receive("OnChangedTeam", OnChangedTeam)

hook.Add("ChatText", "hide_joinleave", function(_, _, _, t)
	if t == "joinleave" then return true end
end)

timer.Simple(0, function() GAMEMODE.ShowTeam = DarkRP.openKeysMenu end)
