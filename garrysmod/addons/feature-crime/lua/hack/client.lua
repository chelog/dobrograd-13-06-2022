surface.CreateFont('hacker', {
	font = 'Consolas',
	size = 16,
	weight = 700,
	antialias = true,
	extended = true,
})
local color_hacker = Color(32, 194, 14)
local introText = 'Keypad Cracker v1.0.1\n(c) ' .. os.date('%Y', os.time()) .. ' Octothorp Team. All rights reserved.\n\nConnecting to keypad'

local terminal, log

local function print(txt, append)
	if not IsValid(log) then return netstream.Start('dbg-hack.cancel') end
	if not append then log:AppendText('\n') end
	log:AppendText(txt or '')
end

local function lock(locked)
	if not IsValid(log) then return netstream.Start('dbg-hack.cancel') end
	log:LockInput(locked)
end

local function reqInput()
	if not IsValid(log) then return netstream.Start('dbg-hack.cancel') end
	log.req = true
end

local function createTerminal()

	terminal = vgui.Create('DFrame')
	terminal:SetSize(700, 585)
	terminal:SetTitle('Terminal')
	terminal:Center()
	terminal:MakePopup()
	terminal:SetSizable(true)
	terminal:SetMinWidth(400)
	terminal:SetMinHeight(300)
	function terminal:Paint(w, h)
		draw.RoundedBox(4, 0, 0, w, h, color_black)
	end
	function terminal:OnClose()
		netstream.Start('dbg-hack.cancel')
	end

	log = terminal:Add('RichText')
	log:Dock(FILL)
	log:InsertColorChange(32, 194, 14, 255)
	function log:PerformLayout()
		self:SetFontInternal('hacker')
	end
	print(introText)

	local cmd = terminal:Add('DPanel')
	cmd:SetPaintBackground(false)
	cmd:Dock(BOTTOM)
	cmd:SetTall(20)
	cmd:DockMargin(5, 0, 5, 0)

	local dlr = cmd:Add('DLabel')
	dlr:Dock(LEFT)
	dlr:SetFont('hacker')
	dlr:SetTextColor(color_hacker)
	dlr:SetText('>')
	dlr:SetWide(15)

	local entry = cmd:Add('DTextEntry')
	entry:Dock(FILL)
	entry:SetTextColor(color_hacker)
	entry:SetFont('hacker')
	entry:SetPaintBackground(false)

	local history, point = {}, 1
	function entry:OnKeyCodeTyped(key)
		if not self:IsEnabled() then return end
		if key == KEY_ENTER then
			if not log.req then
				print('> ' .. self:GetValue())
				history[#history + 1] = self:GetValue()
				point = #history + 1
			else
				print(self:GetValue(), true)
				log.req = nil
			end
			netstream.Start('dbg-hack.input', self:GetValue())
			self:SetText('')
			return true
		elseif key == KEY_UP then
			if point == 1 then return end
			point = point - 1
			self:SetText(history[point])
			self:SetCaretPos(#self:GetText())
			return true
		elseif key == KEY_DOWN then
			if point > #history then return end
			point = point + 1
			self:SetText(history[point] or '')
			self:SetCaretPos(#self:GetText())
			return true
		end
	end

	function log:LockInput(locked)
		entry:SetEnabled(locked ~= true)
		if locked ~= true then
			entry:RequestFocus()
		end
		dlr:SetVisible(locked ~= true)
	end
	log:LockInput(true)

	timer.Create('kpad.load', 0.5, 0, function()
		print('.', true)
	end)

end

netstream.Hook('dbg-hack.cancel', function()
	if IsValid(terminal) then terminal:Close() end
end)
netstream.Hook('dbg-hack.loaded', function()
	timer.Remove('kpad.load')
	print('Welcome to OctoOS 20.04.03 LTS (GNU/Linux 4.15.0-29-generic x86_64)\n')
	print('* Documentation:  https://octothorp.team/help')
	print('* Management:     https://octothorp.team/landscape')
	print('* Support:        https://octothorp.team/advantage\n')
	print('97 packages can be updated.\n12 updates are security updates.')
end)

netstream.Hook('dbg-hack.print', print)
netstream.Hook('dbg-hack.start', createTerminal)
netstream.Hook('dbg-hack.requestInput', reqInput)
netstream.Hook('dbg-hack.updateLockStatus', lock)
