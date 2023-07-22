include('shared.lua')

-- CreateMaterial('dbg_jobs_door1', 'VertexLitGeneric', {
-- 	['$basetexture'] = 'models/props_wasteland/cargo_container02',
-- 	['$model'] = 1,
-- })
-- local matrix1 = Matrix()
-- matrix1:Scale(Vector(1 / 4.34, 1 / 2.19, 1))
-- matrix1:Translate(Vector(0.015, 1.17, 0))
-- Material('!dbg_jobs_door1'):SetMatrix('$basetexturetransform', matrix1)

-- CreateMaterial('dbg_jobs_door2', 'VertexLitGeneric', {
-- 	['$basetexture'] = 'models/props_wasteland/cargo_container02',
-- 	['$model'] = 1,
-- })
-- local matrix2 = Matrix()
-- matrix2:Scale(Vector(1 / 4.34, 1 / 2.19, 1))
-- matrix2:Translate(Vector(0, 1.17, 0))
-- Material('!dbg_jobs_door2'):SetMatrix('$basetexturetransform', matrix2)

-- local positions = {
-- 	open = Vector(0, -190.5, 120),
-- 	closed = Vector(0, -190.5, 3.2),
-- }

function ENT:Initialize()
	-- self:NetworkVarNotify('Open', self.OnOpenChanged)
end

function ENT:OnRemove()
	-- self:RemoveDoors()
end

function ENT:Draw()
	self:DrawModel()

	-- if self.doorAnim then
	-- 	local startTime, endTime, startPos, endPos = unpack(self.doorAnim)

	-- 	if not IsValid(self.door) then
	-- 		self.doorAnim = nil
	-- 		return
	-- 	end

	-- 	local ct = CurTime()
	-- 	if ct > endTime then
	-- 		self.door:SetLocalPos(endPos)
	-- 		self.doorAnim = nil
	-- 		return
	-- 	end

	-- 	local fraction = octolib.tween.easing.inOutQuad(math.TimeFraction(startTime, endTime, ct), 0, 1, 1)
	-- 	self.door:SetLocalPos(LerpVector(fraction, startPos, endPos))
	-- end
end

-- function ENT:OnOpenChanged(name, old, new)
-- 	print(name, old, new, IsValid(self.door))
-- 	if old == new or not IsValid(self.door) then return end
-- 	self.doorAnim = { CurTime(), CurTime() + 5, self.door:GetLocalPos(), new and positions.open or positions.closed }
-- 	PrintTable(self.doorAnim)
-- end

-- function ENT:CreateDoors()
-- 	if not IsValid(self.door) then self:RemoveDoors() end

-- 	local door = ClientsideModel('models/hunter/plates/plate1x1.mdl')
-- 	self.door = door
-- 	door:SetParent(self)
-- 	door:SetLocalPos(self:GetOpen() and positions.open or positions.closed)
-- 	door:SetLocalAngles(Angle(90, -90, 0))
-- 	door:SetSize(Vector(2.62, 1.34, 1.5))
-- 	door:SetMaterial('!dbg_jobs_door1')
-- end

-- function ENT:RemoveDoors()
-- 	if not IsValid(self.door) then return end
-- 	self.door:Remove()
-- end

-- hook.Add('NotifyShouldTransmit', 'dbg_jobs_drop', function(ent, state)
-- 	if ent:GetClass() ~= 'dbg_jobs_drop' then return end
-- 	if state then
-- 		timer.Simple(0, function()
-- 			ent:CreateDoors()
-- 		end)
-- 	else
-- 		ent:RemoveDoors()
-- 	end
-- end)
