
hook.Add('PlayerBindPress', 'Keypad', function(ply, bind, pressed)
	if not pressed then
		return
	end

	local tr = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:GetAimVector() * 65,
		filter = ply
	})

	local ent = tr.Entity

	if not IsValid(ent) or not ent.IsKeypad then
		return
	end

	if string.find(bind, '+use', nil, true) then
		local element = ent:GetHoveredElement()
		if not element then return end
		if element.number then
			return octolib.notify.show('warning', 'Используй для этого кнопки с цифрами на клавиатуре')
		end
		if not element.click then
			return
		end
		element.click(ent)
	end

	if string.find(bind, 'slot') then
		return true
	end

end)


local physical_keypad_commands = {

	[KEY_ENTER] = function(self)
		self:SendCommand(self.Command_Accept)
	end,

	[KEY_PAD_ENTER] = function(self)
		self:SendCommand(self.Command_Accept)
	end,

	[KEY_MINUS] = function(self)
		self:SendCommand(self.Command_Abort)
	end,

	[KEY_PAD_MINUS] = function(self)
		self:SendCommand(self.Command_Abort)
	end,

}

for i = KEY_PAD_1, KEY_PAD_9 do
	physical_keypad_commands[i] = function(self)
		self:SendCommand(self.Command_Enter, i - KEY_PAD_1 + 1)
	end
end

for i = KEY_1, KEY_9 do
	physical_keypad_commands[i] = function(self)
		self:SendCommand(self.Command_Enter, i - KEY_1 + 1)
	end
end

local last_press = 0

local enter_strict = CreateConVar('keypad_willox_enter_strict', '0', FCVAR_ARCHIVE, 'Only allow the numpad\'s enter key to be used to accept keypads\' input')

hook.Add('CreateMove', 'Keypad', function(cmd)

	if RealTime() - 0.1 < last_press then
		return
	end

	for key, handler in pairs(physical_keypad_commands) do
		if input.WasKeyPressed(key) then

			if enter_strict:GetBool() and key == KEY_ENTER then
				continue
			end

			local ply = LocalPlayer()

			local tr = util.TraceLine({
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:GetAimVector() * 65,
				filter = ply
			})

			local ent = tr.Entity

			if not IsValid(ent) or not ent.IsKeypad then
				return
			end

			last_press = RealTime()

			handler(ent)

			return

		end
	end

end)
