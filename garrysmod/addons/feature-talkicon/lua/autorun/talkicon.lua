
CreateConVar('talkicon_computablecolor', 1, FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE, 'Compute color from location brightness.')
CreateConVar('talkicon_showtextchat', 1, FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE, 'Show icon on using text chat.')
CreateConVar('talkicon_ignoreteamchat', 1, FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE, 'Disable over-head icon on using team chat.')

local rangeStyle = {
	-- r, g, b, size
	[2250000] = {127, 127, 255, 8},
	[150000] = {255, 178, 102, 4},
	[500000] = {255, 102, 102, 6},
	[10000] = {130, 130, 130, 3},
}

local textColors = {}
for cmds, col in pairs({
	[{'/it ', '//it ', '/me ', '/toit ', '/pit '}] = Color(255, 178, 102),
	[{'/yell ', '/y ', '/yr ', '/yradio '}] = Color(255, 102, 102, 150),
	[{'/whisper ', '/w ', '/wr', '/wradio '}] = Color(130, 130, 130),
	[{'/ ', '// ', '/pm ', '/looc ', '/ooc ', '/lradio ', '/lr '}] = Color(43, 123, 167),
}) do
	for _, cmd in ipairs(cmds) do
		textColors[cmd] = col
	end
end

if (SERVER) then

	RunConsoleCommand('mp_show_voice_icons', '0')

	netstream.Hook('TalkIconColor', function(ply, col)
		ply:SetNetVar('TalkIcon', col)
	end)

elseif (CLIENT) then

	hook.Add('ChatTextChanged', 'talkicon', function(txt)
		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		if txt == '' then netstream.Start('TalkIconColor', color_white) end
		for cmd in pairs(textColors) do
			if txt:StartWith(cmd) then
				if cmd == LocalPlayer():GetNetVar('TalkIcon') then return end
				netstream.Start('TalkIconColor', cmd)
			end
		end
	end)

	local voice_mat = Material('octoteam/icons-glyph/sound3.png')
	local text_mat = Material('octoteam/icons-glyph/bubble_typing.png')

	hook.Add('PostPlayerDraw', 'TalkIcon', function(ply)
		if ply == LocalPlayer() and GetViewEntity() == LocalPlayer() then return end
		if not ply:Alive() then return end
		if not ply:IsSpeaking() and not ply:IsTyping() then return end

		local pos = ply:GetPos() + Vector(0, 0, ply:GetModelRadius() + 7)

		local attachment = ply:GetAttachment(ply:LookupAttachment('eyes'))
		if attachment then
			pos = ply:GetAttachment(ply:LookupAttachment('eyes')).Pos + Vector(0, 0, 7)
		end


		local color_var = 1
		local computed_color = render.ComputeLighting(ply:GetPos(), Vector(0, 0, 1))
		local max = math.max(computed_color.x, computed_color.y, computed_color.z)
		color_var = math.Clamp(max * 1.11, 0, 1)

		if ply:IsSpeaking() then
			if GetConVar('cl_dbg_voiceicon'):GetInt() == '1' then
				local r, g, b, size = unpack(rangeStyle[ply:GetNetVar('TalkRange', 0)] or rangeStyle[150000])
				render.SetMaterial(voice_mat)
				local size = size + ply:VoiceVolume() * 2
				render.DrawSprite(pos, size, size, Color(color_var * r, color_var * g, color_var * b, 150))
			end
		else
			local col = textColors[ply:GetNetVar('TalkIcon') or ''] or color_white
			render.SetMaterial(text_mat)
			render.DrawSprite(pos, 4, 4, col)
		end
	end)

	hook.Add('InitPostEntity', 'RemoveChatBubble', function()
		hook.Remove('StartChat', 'StartChatIndicator')
		hook.Remove('FinishChat', 'EndChatIndicator')
	end)

end
