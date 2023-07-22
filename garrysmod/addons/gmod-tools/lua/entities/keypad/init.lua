AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'cl_maths.lua'
AddCSLuaFile 'cl_panel.lua'
AddCSLuaFile 'sh_init.lua'

include 'sh_init.lua'

util.AddNetworkString('Keypad')


net.Receive('Keypad', function(_, ply)
	if ply:GetNetVar( 'Ghost' ) then return end

	local ent = net.ReadEntity()

	if not IsValid(ply) or not IsValid(ent) or ent:GetClass():lower() ~= 'keypad' then
		return
	end

	if ent:GetStatus() ~= ent.Status_None then
		return
	end

	if ply:EyePos():Distance(ent:GetPos()) >= 120 then
		return
	end

	local command = net.ReadUInt(4)

	if command == ent.Command_Enter then
		local val = tonumber(ent:GetValue() .. net.ReadUInt(8))

		if val and val > 0 and val <= 9999 then
			ent:SetValue(tostring(val))
			ent:EmitSound('buttons/button15.wav')
		end
	elseif command == ent.Command_Abort then
		ent:SetValue('')
	elseif command == ent.Command_Accept and not ply.hacking then
		if ent:GetValue() == ent:GetPassword() then
			ent:Process(true)
		else
			ent:Process(false)
		end
	end
end)

math.randomseed(os.time())
local secret = math.random(10000)

function ENT:SetValue(val)
	self.Value = val

	if self:GetSecure() then
		self:SetText(string.rep('*', #val))
	else
		self:SetText(val)
	end
end

function ENT:GetValue()
	return self.Value
end

function ENT:Process(granted)
	local length, repeats, delay, initdelay, owner, key

	if granted then
		self:SetStatus(self.Status_Granted)

		length = self.KeypadData.LengthGranted
		repeats = math.min(self.KeypadData.RepeatsGranted, 50)
		delay = self.KeypadData.DelayGranted
		initdelay = self.KeypadData.InitDelayGranted
		owner = self.KeypadData.Owner
		key = tonumber(self.KeypadData.KeyGranted) or 0
	else
		self:SetStatus(self.Status_Denied)

		length = self.KeypadData.LengthDenied
		repeats = math.min(self.KeypadData.RepeatsDenied, 50)
		delay = self.KeypadData.DelayDenied
		initdelay = self.KeypadData.InitDelayDenied
		owner = self.KeypadData.Owner
		key = tonumber(self.KeypadData.KeyDenied) or 0
	end

	timer.Simple(math.max(initdelay + length * (repeats + 1) + delay * repeats + 0.25, 2), function() -- 0.25 after last timer
		if IsValid(self) then
			self:Reset()
		end
	end)

	timer.Simple(initdelay, function()
		if IsValid(self) then
			for i = 0, repeats do
				timer.Simple(length * i + delay * i, function()
					if IsValid(self) then
						numpad.Activate(owner, key, true)
					end
				end)

				timer.Simple(length * (i + 1) + delay * i, function()
					if IsValid(self) then
						numpad.Deactivate(owner, key, true)
					end
				end)
			end
		end
	end)

	if granted then
		self:EmitSound('buttons/button9.wav')
	else
		self:EmitSound('buttons/button11.wav')
	end
end

function ENT:SetPassword(pass)
	self.pass = tostring(pass) or '1337'
	self.problem = nil
	self:GenerateProblem()
end

function ENT:GetPassword()
	return self.pass or '1337'
end

function ENT:SetData(data)
	self.KeypadData = data

	self:SetPassword(data.Password or '1337')
	self:Reset()
end

function ENT:GetData()
	return self.KeypadData
end

local function randomIp()
	return string.format('%s.%s.%s.%s', math.random(10, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
end

local alphabet = '1234567890abcdef'
local function generateHash(len, range)
	range = math.min(range or #alphabet, #alphabet)
	len = math.max(len or 8, 1)
	local str = ''
	for i = 1, len do
		str = str .. alphabet[math.random(range)]
	end
	return str
end

function ENT:GenerateProblem(complex, vars)

	if self.problem then return end

	math.randomseed(CurTime())
	complex = math.max(complex or 6, 4)
	vars = math.max(vars or 5, 1)

	math.randomseed(self:GetPassword() + secret)
	self.problem = generateHash()
	math.randomseed(CurTime())
	self.pwdserver = randomIp()
	self.passs = {}
	for i = 1, vars-1 do
		self.passs[i] = generateHash(#self:GetPassword(), 9)
	end
	self.passs[vars] = tonumber(self:GetPassword())
	octolib.array.shuffle(self.passs)

	local path = {}
	path[1] = '192.168.1.' .. math.random(20)
	for i = 2, complex-1 do
		path[i] = randomIp()
	end
	path[complex] = self.pwdserver
	self.traceroute = path

	local pts = {}
	for i = 1, 4 do
		pts[i] = i
	end
	for i = 5, complex do
		pts[i] = math.random(4)
	end
	octolib.array.shuffle(pts)
	self.hashpts = pts

end

function ENT:Reset()
	self:SetValue('')
	self:SetStatus(self.Status_None)
	self:SetSecure(self.KeypadData.Secure)
end

duplicator.RegisterEntityClass('keypad', function(ply, data)

	if IsValid(ply) and not ply:CheckLimit('keypads') then return false end

	if not data.KeypadData then
		data.KeypadData = {
			DelayDenied = 0,
			DelayGranted = 0,
			InitDelayDenied = 0,
			InitDelayGranted = 0,
			KeyDenied = 0,
			KeyGranted = 0,
			LengthDenied = 0.1,
			LengthGranted = 0,
			Password = 1234,
			RepeatsDenied = 0,
			RepeatsGranted = 0,
			Secure = false,
		}
		if IsValid(ply) then
			ply.oldKeypads = true
		end
	end

	local ent = duplicator.GenericDuplicatorFunction(ply, data)
	if IsValid(ply) then
		data.KeypadData.Owner = ply:SteamID()
		ply:AddCount('keypads', ent)
		ply:AddCleanup('keypads', ent)
	end
	ent:SetData(data.KeypadData)

	return ent

end, 'Data', 'KeypadData', 'pass')
