/*   _								
	()							   
   _| |   __   _ __   ___ ___	 _ _ 
 /'_` | /'__`\('__)/' _ ` _ `\ /'_`)
((_| |(___/| |   | () () |((_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DNumPad
	
	A loverly multi-use numpad. Now can remember more then once key!

*/
 
local KP_PERIOD = 10
local KP_ENTER  = 11
local KP_PLUS   = 12
local KP_MINUS  = 13
local KP_STAR   = 14
local KP_DIV	= 15

local PANEL = {}

function PANEL:Init()
	self.Buttons = {}
	
	for i = 0, 15 do
		self.Buttons[i] = vgui.Create("DButton", self)
		self.Buttons[i]:SetText(i)
		self.Buttons[i].DoClick = function(btn) self:OnButtonPressed(btn, i) end
		self.Buttons[i].LastToggle = 0
	end
	
	self.Buttons[KP_PERIOD]:SetText(".")
	self.Buttons[KP_ENTER]:SetText("")
	self.Buttons[KP_PLUS]:SetText("+")
	self.Buttons[KP_MINUS]:SetText("-")
	self.Buttons[KP_STAR]:SetText("*")
	self.Buttons[KP_DIV]:SetText("/")
	
	self.Buttons[0]:SetContentAlignment(4)
	self.Buttons[0]:SetTextInset(6,0)
	
	self.m_KeyFlags = 0
end

function PANEL:Thinkz()
	for k, v in ipairs(self.Buttons) do
		if v.Hovered then -- it's highlighted
			-- But don't bother because I'm chopping that feature (minor one) due to time restraints
		end
	end
end

function PANEL:OnButtonPressed(pButton, iButtonNumber)
	pButton.WasSelectedActive = not pButton.WasSelectedActive
	
	pButton:SetSelected(pButton.WasSelectedActive)
	
	local hackz = (pButton.WasSelectedActive and self:AddKeyFlag(iButtonNumber, pButton) or self:RemoveKeyFlag(iButtonNumber, pButton))
end

function PANEL:PerformLayout()
	local ButtonSize = 17
	local Padding = 4
	
	self:SetSize(ButtonSize * 4 + Padding * 2, ButtonSize * 5 + Padding * 2)
	
	self.Buttons[0]:SetSize(ButtonSize * 2, ButtonSize)
	self.Buttons[0]:AlignBottom(Padding)
	self.Buttons[0]:AlignLeft(Padding)
	self.Buttons[KP_PERIOD]:CopyBounds(self.Buttons[0])
	self.Buttons[KP_PERIOD]:SetSize(ButtonSize, ButtonSize)
	self.Buttons[KP_PERIOD]:MoveRightOf(self.Buttons[0])
	
	self.Buttons[1]:SetSize(ButtonSize, ButtonSize)	
	self.Buttons[1]:AlignLeft(Padding)
	self.Buttons[1]:MoveAbove(self.Buttons[ 0 ])
	self.Buttons[2]:CopyBounds(self.Buttons[1])
	self.Buttons[2]:MoveRightOf(self.Buttons[1])
	self.Buttons[3]:CopyBounds(self.Buttons[2])
	self.Buttons[3]:MoveRightOf(self.Buttons[2])
	
	self.Buttons[KP_ENTER]:SetSize(ButtonSize, ButtonSize*2)
	self.Buttons[KP_ENTER]:AlignBottom(Padding)
	self.Buttons[KP_ENTER]:AlignRight(Padding)

	self.Buttons[KP_PLUS]:CopyBounds(self.Buttons[KP_ENTER])
	self.Buttons[KP_PLUS]:MoveAbove(self.Buttons[KP_ENTER])
	
	self.Buttons[KP_MINUS]:CopyBounds(self.Buttons[KP_PLUS])
	self.Buttons[KP_MINUS]:SetSize(ButtonSize, ButtonSize)
	self.Buttons[KP_MINUS]:MoveAbove(self.Buttons[KP_PLUS])
	
	self.Buttons[KP_STAR]:CopyBounds(self.Buttons[KP_MINUS])
	self.Buttons[KP_STAR]:MoveLeftOf(self.Buttons[KP_MINUS])
	
	self.Buttons[KP_DIV]:CopyBounds(self.Buttons[KP_STAR])
	self.Buttons[KP_DIV]:MoveLeftOf(self.Buttons[KP_STAR])
	
	self.Buttons[4]:CopyBounds(self.Buttons[1])
	self.Buttons[4]:MoveAbove(self.Buttons[1])
	self.Buttons[5]:CopyBounds(self.Buttons[4])
	self.Buttons[5]:MoveRightOf(self.Buttons[4])
	self.Buttons[6]:CopyBounds(self.Buttons[5])
	self.Buttons[6]:MoveRightOf(self.Buttons[5])
	
	self.Buttons[7]:CopyBounds(self.Buttons[4])
	self.Buttons[7]:MoveAbove(self.Buttons[4])
	self.Buttons[8]:CopyBounds(self.Buttons[7])
	self.Buttons[8]:MoveRightOf(self.Buttons[7])
	self.Buttons[9]:CopyBounds(self.Buttons[8])
	self.Buttons[9]:MoveRightOf(self.Buttons[8])
end

function PANEL:AddKeyFlag(key_val, pButton)
	local bin_flag = 2 ^ key_val
	print("Add")
	print("Key: ", key_val, "; Flag: ", bin_flag)
	print(self.m_KeyFlags and bin_flag) 
	pButton.LastToggle = CurTime() + .1 -- hackz
	print("---")
	
	if (self.m_KeyFlags and bin_flag) ~= bin_flag then
		self.m_KeyFlags = self.m_KeyFlags + bin_flag
		
		self:UpdateConVar()
	end
end

function PANEL:RemoveKeyFlag(key_val, pButton)
	local bin_flag = 2 ^ key_val
	print(pButton.LastToggle)
	print(CurTime())
	if pButton.LastToggle > CurTime() then return end
	print("Remove")
	print("Key: ", key_val, "; Flag: ", bin_flag)
	print(self.m_KeyFlags and bin_flag)
	
	
	print("---")
	--debug.Trace()
	if (self.m_KeyFlags and bin_flag) == bin_flag then
		self.m_KeyFlags = self.m_KeyFlags - bin_flag
		
		self:UpdateConVar()
	end
end

function PANEL:SetConVar(cvar_name)
	self.m_CVarName = cvar_name
end

function PANEL:UpdateConVar()
	if self.m_CVarName then
		print("Update: ", self.m_KeyFlags)
		RunConsoleCommand(self.m_CVarName, self.m_KeyFlags)
		print("---")
	end
end

function PANEL:Clear()
	for i = 1, 15 do
		if self.Buttons[i].WasSelectedActive then
			self.Buttons[i]:DoClick()
		end
	end
end

function PANEL:SetupKeys(data)
	self:Clear()
	
	for k, _ in pairs(data) do
		self.Buttons[k]:DoClick() -- ?
		print("Setting ", k, "...\n")
	end
end

function PANEL:SetValue(iNumValue)
end

function PANEL:SetKeySlider(slider)
	-- Nevermind...
end

function PANEL:GetValue()
	return self.m_KeyFlags
end

vgui.Register("DNumPadMulti", PANEL, "DPanel")


