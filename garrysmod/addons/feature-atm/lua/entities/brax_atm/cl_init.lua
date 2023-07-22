include('shared.lua')

-- store temporary variables
BraxATM = {}
BraxATM.UserMoney = 0
BraxATM.ReturnCode = 0

local sounds = {
	[3] = 'atm/withdraw.wav',
	[5] = 'atm/deposit.wav',
	[2] = 'buttons/button8.wav',
	[4] = 'buttons/button8.wav',
}

net.Receive( 'BraxAtmFetch', function( length, client )
	BraxATM.UserMoney = net.ReadInt(32)
end )

net.Receive( 'BraxAtmReturnCode', function( length, client )
	local ent = net.ReadEntity()
	BraxATM.ReturnCode = net.ReadInt(32)
	local sound = sounds[BraxATM.ReturnCode]
	if sound then
		ent:EmitSound(sound, 75)
	end
end )

--CreateClientConVar('brax_language', 'en', true, false)

-- english translation
language.Add('ATM_Deposit_Ok', L.atm_deposit_ok)
language.Add('ATM_Deposit_Fail', L.atm_deposit_fail )
language.Add('ATM_Withdraw_Ok', L.atm_withdraw_ok)
language.Add('ATM_Withdraw_Fail', L.atm_withdraw_fail)
language.Add('ATM_Deposit', L.atm_deposit)
language.Add('ATM_Withdraw', L.atm_withdraw)
language.Add('ATM_Del','←')
language.Add('ATM_Home', L.atm_home)
language.Add('ATM_Balance', L.atm_balance)
language.Add('ATM_Home1', L.atm_home1)
language.Add('ATM_Home2', L.atm_home2)
language.Add('ATM_Home3', L.atm_home3)
language.Add('ATM_Return_code','хуй хуй хуй')
language.Add('ATM_Transaction_Success', L.atm_transaction_success)
language.Add('ATM_Transaction_Failed', L.atm_transaction_failed)
language.Add('ATM_Transaction_Pending', 'Транзакция обрабатывается')

local RC = {'#ATM_Transaction_Pending','#ATM_Withdraw_Fail','#ATM_Withdraw_Ok','#ATM_Deposit_Fail','#ATM_Deposit_Ok'}

--[[
	Return codes!!
	1 = Pending
	2 = Deposit, bank does not have money
	3 = Deposit, ok
	4 = Insert, User does not have enough money
	5 = Insert, ok
]]--

surface.CreateFont( 'AtmFontTitle', {
	font = 'Impact',
	size = 50,
	weight = 400,
	blursize = 0,
	scanlines = 0,
	antialias = true
} )

surface.CreateFont( 'AtmFontButton', {
	font = 'Arial',
	size = 24,
	weight = 400,
	blursize = 0,
	scanlines = 0,
	antialias = true
} )

surface.CreateFont( 'AtmFontInput', {
	font = 'Lucida Console',
	size = 24,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true
} )

surface.CreateFont( 'AtmFontInfo', {
	font = 'Arial',
	size = 22,
	weight = 400,
	blursize = 0,
	scanlines = 0,
	antialias = true
} )

surface.CreateFont( 'AtmFontInfoBold', {
	font = 'Arial',
	size = 24,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true
} )

local function WorldToScreen(vWorldPos,vPos,vScale,aRot)
	local vWorldPos=vWorldPos-vPos;
	vWorldPos:Rotate(Angle(0,-aRot.y,0));
	vWorldPos:Rotate(Angle(-aRot.p,0,0));
	vWorldPos:Rotate(Angle(0,0,-aRot.r));
	return vWorldPos.x/vScale,(-vWorldPos.y)/vScale;
end

function ENT:Initialize()

	-- Reset all variables
	self.cursor = {y=0,x=0,click=false}
	self.Action = 0
	self.InputValue = 0
	self.UserMoney = 0
	self.ReturnCode = 0
	self.ScrPos = 0
	self.ScrOff = 0
	self.ScrAng = 0
	self.ScrScale = 0.025
	self.Title = L.octobank
	self.ScreenSize = {340,270}
	self.Ding = false

end

function ENT:ScreenTop() return -self.ScreenSize[2]/2 end
function ENT:ScreenLeft() return -self.ScreenSize[1]/2 end
function ENT:ScreenBottom() return self.ScreenSize[2]/2 end
function ENT:ScreenRight() return self.ScreenSize[1]/2 end

function ENT:AddToTotal(num)
	if self.InputValue > 10000000 then return end
	self.InputValue = self.InputValue * 10 + num
end

function ENT:ATMWithdraw(val)
	if val == 0 then
		self:EmitSound('atm/click.ogg', 75)
		return
	end
	net.Start( 'BraxAtmWithdraw' )
		net.WriteInt(val, 32)
	net.SendToServer()
	self.InputValue = 0
	self.Action = 3
end

function ENT:ATMDeposit(val)
	if val == 0 then
		self:EmitSound('atm/click.ogg', 75)
		return
	end
	net.Start( 'BraxAtmDeposit' )
		net.WriteInt(val, 32)
	net.SendToServer()
	self.InputValue = 0
	self.Action = 3
end

function ENT:AddButton(text, x, y, w, h, pos, func, icon)

	surface.SetDrawColor( 60, 80, 80, 255, 255 );

	if not pos then return end

	if pos.x > x and pos.x < x+w and pos.y > y and pos.y < y+h then

		surface.SetDrawColor( 80, 80, 80, 255 );

		-- Main key function

		local ply = LocalPlayer()

		if ply:KeyDown(IN_USE) and !self.cursor.click and not ply:GetNetVar('Ghost') then
			self.cursor.click = true
		elseif not ply:KeyDown(IN_USE) and self.cursor.click then
			self.cursor.click = false
			self:EmitSound('atm/click.ogg', 75)
			func()
		end

	end

	surface.DrawRect( x, y, w, h );

	draw.TexturedQuad
	{
		texture = surface.GetTextureID 'gui/gradient_up',
		color = Color(10, 10, 10, 180),
		x = x,
		y = y,
		w = w,
		h = h
	}

	surface.SetDrawColor( 25, 25, 25, 255, 255 );
	surface.DrawOutlinedRect( x, y, w, h );

	local tx = surface.GetTextSize('test')

	surface.SetFont('AtmFontButton')
	surface.SetTextColor(255,255,255,255)
	surface.SetTextPos(x+(icon and 32 or 4), y+4)
	surface.DrawText(text)

	if icon then
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material('icon16/'..icon..'.png'))
		surface.DrawTexturedRect( x+8, y+8, 16, 16 )
	end
end

function ENT:AddNumPad(cursor, x, y)
	local sz = 32
	self:AddButton('1',	x,		y,		sz,	sz,	cursor, function() self:AddToTotal(1) end)
	self:AddButton('2',	x+sz,	y,		sz,	sz,	cursor, function() self:AddToTotal(2) end)
	self:AddButton('3',	x+sz*2,	y,		sz,	sz,	cursor, function() self:AddToTotal(3) end)

	self:AddButton('4',	x,		y+sz,	sz,	sz,	cursor, function() self:AddToTotal(4) end)
	self:AddButton('5',	x+sz,	y+sz,	sz,	sz,	cursor, function() self:AddToTotal(5) end)
	self:AddButton('6',	x+sz*2,	y+sz,	sz,	sz,	cursor, function() self:AddToTotal(6) end)

	self:AddButton('7',	x,		y+sz*2,	sz,	sz,	cursor, function() self:AddToTotal(7) end)
	self:AddButton('8',	x+sz,	y+sz*2,	sz,	sz,	cursor, function() self:AddToTotal(8) end)
	self:AddButton('9',	x+sz*2,	y+sz*2,	sz,	sz,	cursor, function() self:AddToTotal(9) end)

	self:AddButton('0',	x+sz*2,	y+sz*3,	sz,	sz,	cursor, function() self:AddToTotal(0) end)
	self:AddButton('#ATM_Del',	x,	y+sz*3,	sz*2,	sz,	cursor, function() self.InputValue = math.floor(self.InputValue / 10) end)
end

function ENT:Draw()

	self:DrawModel()

	local player = LocalPlayer()
	local dist = (player:GetShootPos() - self:GetPos()):LengthSqr()
	if (dist > 6400) then
		self.Action = 0
		self.InputValue = 0
		self.Title = L.octobank
		return
	end

	self.ScrScale = 0.035

	self.ScrPos = self:GetPos()
	self.ScrAng = self:GetAngles() + Angle(75,0,0)
	self.ScrOff = self:GetUp() * 51.5 + self:GetForward()*8.5 + self:GetRight()*8.1

	self.ScrAng:RotateAroundAxis(self.ScrAng:Up(), 90)

	cam.Start3D2D(self.ScrPos + self.ScrOff, self.ScrAng, self.ScrScale )

		self.cursor.lx = self.cursor.x
		self.cursor.ly = self.cursor.y

		-- Set cursor pos, important
		self.cursor.x, self.cursor.y = WorldToScreen(LocalPlayer():GetEyeTrace().HitPos,self.ScrPos+self.ScrOff,self.ScrScale*0.9,self.ScrAng)

		self.cursor.x = self.cursor.x + 15
		self.cursor.y = self.cursor.y - 50

		surface.SetDrawColor(155,155,155,255)
		surface.SetMaterial(Material('newcity/atm.png'))
		surface.DrawTexturedRect( -self.ScreenSize[1]/2, -self.ScreenSize[2]/2, self.ScreenSize[1], self.ScreenSize[2] )

		-- Bottom bar
		surface.SetDrawColor(60,60,60, 255 )
		surface.DrawRect(self:ScreenLeft(), self:ScreenBottom()-32,self.ScreenSize[1],32)

		-- Main menu navigation
		if self.Action == 0 then

			draw.SimpleText('#ATM_Home1', 'AtmFontInfoBold', 0, -60, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText('#ATM_Home2', 'AtmFontInfo', 0, -35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			if netvars.GetNetVar('pendingTax') and player:GetNetVar('taxes', 0) > 0 then
				local txt = L.atm_home_taxes:format(DarkRP.formatMoney(player:GetNetVar('taxes')))
				draw.SimpleText(txt, 'AtmFontInfo', 0, -10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			draw.SimpleText('#ATM_Home3', 'AtmFontInfo', 0, 60, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			self:AddButton('#ATM_Withdraw', self:ScreenLeft(), self:ScreenBottom()-32, 150, 32, self.cursor, function()
				self.Action = 1
				self.InputValue = 0
				RunConsoleCommand('brax_atm_update')
				self.Title = '#ATM_Withdraw'
			end,'arrow_down')

			self:AddButton('#ATM_Deposit', self:ScreenRight()-150, self:ScreenBottom()-32, 150, 32, self.cursor, function()
				self.Action = 2
				self.InputValue = 0
				RunConsoleCommand('brax_atm_update')
				self.Title = '#ATM_Deposit'
			end,'arrow_up')
		end

		if self.Action == 1 or self.Action == 2 then

			-- color if not valid
			local BalanceColor = Color(0,0,0,255)
			if self.InputValue > BraxATM.UserMoney and self.Action == 1 then BalanceColor = Color(255,0,0,255) end
			if self.InputValue > LocalPlayer():GetNetVar('money', 0) and self.Action == 2 then BalanceColor = Color(255,0,0,255) end

			-- Input value
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawRect(-155,-55,190,32)
			draw.SimpleText(DarkRP.formatMoney(self.InputValue), 'AtmFontInput', 30, -49, BalanceColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)

			-- Balance
			draw.SimpleText('#ATM_Balance', 'AtmFontInfoBold', 35, -20, Color(0,0,0,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
			draw.SimpleText(DarkRP.formatMoney(BraxATM.UserMoney), 'AtmFontInfo', 35, 4, Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)

			self:AddNumPad(self.cursor, 40,-55)

		end


		-- Deposit start screen
		-- PUT MONEY
		if self.Action == 2 then
			self:AddButton('#ATM_Deposit', self:ScreenRight()-150, self:ScreenBottom()-32, 150, 32,	self.cursor, function()
				BraxATM.ReturnCode = 1
				self:ATMDeposit(self.InputValue)
			end, 'arrow_up')
		end

		-- Withdraw start screen
		-- TAKE MONEY
		if self.Action == 1 then
			self:AddButton('#ATM_Withdraw', self:ScreenRight()-150, self:ScreenBottom()-32, 150, 32,	self.cursor, function()
				BraxATM.ReturnCode = 1
				self:ATMWithdraw(self.InputValue)
			end,'arrow_down')
		end

		-- End screen
		if self.Action == 3 then
			local ding, icon, msg
			if BraxATM.ReturnCode == 1 then
				-- Transaction pending
				icon, msg = 'octoteam/icons/clock.png', 'Подождите...'
			elseif BraxATM.ReturnCode == 2 or BraxATM.ReturnCode == 4 then
				-- Transaction fail
				ding, icon, msg = 'buttons/button8.wav', 'octoteam/icons/cross.png', '#ATM_Transaction_Failed'
			else
				-- Transaction success
				ding, icon, msg = 'buttons/bell1.wav', 'octoteam/icons/check.png', '#ATM_Transaction_Success'
			end
			if ding and not self.Ding then
				surface.PlaySound(ding)
				self.Ding = true
			end
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(Material(icon))
			surface.DrawTexturedRect(-32, -72, 64, 64)
			draw.SimpleText(msg, 'AtmFontInfoBold', 0, 25, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			draw.SimpleText(language.GetPhrase(RC[BraxATM.ReturnCode] or ''), 'AtmFontInfo', 0, 45, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			--draw.SimpleText(language.GetPhrase('#ATM_Return_code')..' '..BraxATM.ReturnCode, 'AtmFontInfo', 0, 77, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		-- Home button
		if self.Action > 0 then
			self:AddButton('#ATM_Home',self:ScreenLeft(),self:ScreenBottom()-32,	150,	32,	self.cursor, function()
				self.Action = 0
				self.Title = L.octobank
				self.Ding = false
			end,'house')
		end

		-- Top bar and title
		surface.SetDrawColor(43,86,167, 255 )
		surface.DrawRect(self:ScreenLeft(), self:ScreenTop(),self.ScreenSize[1],self.ScreenSize[2]/6)
		draw.SimpleText(self.Title, 'AtmFontTitle', self:ScreenLeft()+4, self:ScreenTop()+22, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		surface.SetDrawColor(255,255,255,255 )

		-- nice math
		for i=1,6 do
			local x = math.sin( CurTime() * 2+i ) * 12 + self:ScreenRight()-25
			local y = math.cos( CurTime() * 3+i ) * 12 + self:ScreenTop()+20
			surface.DrawRect(x,y,3,3)
		end

		-- Cursor
		if self.cursor.x > self:ScreenLeft() and self.cursor.x < self:ScreenRight() and self.cursor.y > self:ScreenTop() and self.cursor.y < self:ScreenBottom() then
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(Material('icon16/cursor.png')) --'icon32/hand_point_090.png'
			surface.DrawTexturedRect(self.cursor.x-3, self.cursor.y, 16, 16)
			--surface.DrawRect(self.cursor.x, self.cursor.y,1,1) -- debug test
		end

	cam.End3D2D()
end

local function CanUseBraxATM(entity)
	return	IsValid(entity) and
			entity:GetClass() == 'brax_atm' and
			LocalPlayer():GetShootPos():DistToSqr(entity:GetPos()) <= 6400
end
hook.Add('PlayerButtonDown', 'brax_atm.input', function(player, button)

	local entity = player:GetEyeTrace().Entity
	if	not CanUseBraxATM(entity) or
		not IsFirstTimePredicted()
	then
		return
	end

	if button == KEY_BACKSPACE then
		entity.InputValue = input.IsShiftDown()
			and 0
			or math.floor(entity.InputValue / 10)
	elseif button >= KEY_PAD_0 and button <= KEY_PAD_9 then
		entity:AddToTotal(button - KEY_PAD_0)
	elseif button >= KEY_0 and button <= KEY_9 then
		entity:AddToTotal(button - KEY_0)
	end

end)
hook.Add('PlayerBindPress', 'brax_atm.block', function(player, bind, pressed, code)

	if CanUseBraxATM(player:GetEyeTrace().Entity) and code >= KEY_0 and code <= KEY_9 then
		return true
	end

end)
