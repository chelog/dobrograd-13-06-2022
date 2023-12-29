octolib.questions.active = octolib.questions.active or {}

local function createQuestionBase(uid, text, time, sound)
	local fr = vgui.Create 'DFrame'
	fr:SetSize(300, 24)
	fr:CenterVertical(0.4)
	fr:ShowCloseButton(false)
	fr:SetTitle('')
	fr:SetDraggable(false)
	fr:SetVisible(false)
	fr.uid = uid
	octolib.questions.active[#octolib.questions.active + 1] = fr

	local createTime = CurTime()
	local progress = fr:Add 'DProgress'
	progress:SetPos(4, 9)
	progress:SetSize(292, 6)
	function progress:Think()
		self:SetFraction((CurTime() - createTime) / time)
	end
	fr.progress = progress

	if sound then
		LocalPlayer():EmitSound(sound, 100, 100)
	end

	local lbl = fr:Add 'DLabel'
	lbl:SetPos(5, 29)
	lbl:SetWide(290)
	lbl:SetMultiline(true)
	lbl:SetWrap(true)
	lbl:SetText(text)

	local h = markup.Parse('<font=Default>' .. text:gsub('<', '\\<'):gsub('>', '\\>') .. '</font>', 290):GetHeight()
	lbl:SetTall(h)
	fr:SetTall(fr:GetTall() + h + 10)

	local superRemove = fr.Remove
	function fr:Remove()
		local idx = table.RemoveByValue(octolib.questions.active, self)
		if not idx then return end
		local tall = self:GetTall() + 10
		self:SlideUp(0.3)
		timer.Simple(0.3, function()
			superRemove(self)
		end)
		timer.Simple(0.5, function()
			for i = 1, idx-1 do
				octolib.questions.active[i]:MoveBy(0, -tall, 0.3, 0, 0.3)
			end
		end)
	end

	timer.Simple(0, function()
		local tall = fr:GetTall() + 10
		for _,v in ipairs(octolib.questions.active) do
			if v ~= fr then v:MoveBy(0, tall, 0.3, 0, 0.3) end
		end
		timer.Simple(0.3, function()
			if IsValid(fr) then fr:SlideDown(0.3) end
		end)
	end)

	return fr

end

local function findQuestion(uid)
	for _,v in ipairs(octolib.questions.active) do
		if v.uid == uid then return v end
	end
end

netstream.Hook('octolib.question.start', function(uid, text, left, right, time, sound)

	if IsValid(findQuestion(uid)) then return end

	local fr = createQuestionBase(uid, text, time, sound)
	fr.recipient = true
	surface.SetFont('DermaDefault')

	local rgtBtn = fr:Add('DButton')
	local rWide = surface.GetTextSize(right)
	rWide = math.max(75, rWide + 10)
	rgtBtn:SetPos(fr:GetWide() - (rWide + 8), fr:GetTall() + 10)
	rgtBtn:SetText(right)

	rgtBtn:SetWide(rWide)
	function rgtBtn:DoClick()
		netstream.Start('octolib.question.reply', uid, false)
		fr:Remove()
	end

	local lftBtn = fr:Add 'DButton'
	local lWide = surface.GetTextSize(left)
	lWide = math.max(75, lWide + 10)
	lftBtn:SetPos(fr:GetWide() - (rWide + 8 + lWide + 5), fr:GetTall() + 10)
	lftBtn:SetText(left)
	lftBtn:SetWide(lWide)
	function lftBtn:DoClick()
		netstream.Start('octolib.question.reply', uid, true)
		fr:Remove()
	end

	fr:SetTall(fr:GetTall() + rgtBtn:GetTall() + 18)

	timer.Simple(time, function()
		if IsValid(fr) then
			fr:SetEnabled(false)
		end
	end)
end)

netstream.Hook('octolib.question.finish', function(uid)
	local fr = findQuestion(uid)
	if IsValid(fr) and fr.recipient then fr:Remove() end
end)

local function lerpFractionThink(pan)
	function pan:Think()
		if self.tgtFr then
			local st = math.Clamp(math.TimeFraction(self.startLerp, self.endLerp, CurTime()), 0, 1)
			local frac = octolib.tween.easing.inOutQuad(st, 0, 1, 1)
			if frac > 0 then
				self:SetFraction(Lerp(frac, self.srcFr, self.tgtFr))
			elseif frac == 1 then
				self.srcFr, self.tgtFr, self.startLerp, self.endLerp = nil
			end
		end
	end

	function pan:LerpFractionTo(fr)
		self.srcFr = self:GetFraction()
		self.tgtFr = fr
		self.startLerp = CurTime()
		self.endLerp = self.startLerp + 0.3
	end
end

netstream.Hook('octolib.question.spectateStart', function(uid, text, left, right, time, sound)
	if IsValid(findQuestion(uid)) then return end

	local fr = createQuestionBase(uid, text, time, sound)
	fr.recipient = false

	local leftOpt = fr:Add 'DProgressLabel'
	leftOpt:SetPos(5, fr:GetTall() + 10)
	leftOpt:SetWide(290)
	leftOpt:SetText(left .. ': 0')
	leftOpt:AttachToEdge()
	lerpFractionThink(leftOpt)
	leftOpt.text = left
	fr:SetTall(fr:GetTall() + leftOpt:GetTall() + 15)

	local rightOpt = fr:Add 'DProgressLabel'
	rightOpt:SetPos(5, fr:GetTall())
	rightOpt:SetWide(290)
	rightOpt:SetText(right .. ': 0')
	rightOpt:AttachToEdge()
	lerpFractionThink(rightOpt)
	rightOpt.text = right
	fr:SetTall(fr:GetTall() + rightOpt:GetTall() + 5)

	fr.left, fr.right = leftOpt, rightOpt
end)

netstream.Hook('octolib.question.spectateUpdate', function(uid, left, right)
	local fr = findQuestion(uid)
	if not IsValid(fr) then return end
	local sum = left + right
	fr.left:LerpFractionTo(left / sum)
	fr.right:LerpFractionTo(right / sum)
	fr.left:SetText(fr.left.text .. ': ' .. left)
	fr.right:SetText(fr.right.text .. ': ' .. right)
end)

netstream.Hook('octolib.question.spectateFinish', function(uid)
	local fr = findQuestion(uid)
	if not IsValid(fr) or fr.recipient then return end
	fr.progress:AlphaTo(0, 1, 0)
	timer.Simple(5, function()
		fr:Remove()
	end)
end)
