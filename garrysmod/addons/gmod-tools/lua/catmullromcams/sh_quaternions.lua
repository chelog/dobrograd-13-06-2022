local function RoundTo(val, num_decimal_points)
	local pow = 1

	for i = 1, num_decimal_points do
		pow = pow * 10
	end
	
	return (math.Round(val * pow) / pow)
end


local AngMeta = FindMetaTable("Angle")

function AngMeta:ToDeg()
	self.p = math.deg(self.p)
	self.y = math.deg(self.y)
	self.r = math.deg(self.r)
end

function AngMeta:ToRad()
	self.p = math.rad(self.p)
	self.y = math.rad(self.y)
	self.r = math.rad(self.r)
end

function AngMeta:Quaternion(quaternion_output)
	local ang = self * 1
	ang:ToRad()
	
	local cp = math.cos(ang.p * .5)
	local cy = math.cos(ang.y * .5)
	local cr = math.cos(ang.r * .5)
	
	local sp = math.sin(ang.p * .5)
	local sy = math.sin(ang.y * .5)
	local sr = math.sin(ang.r * .5)
	
	local cpcy = cp * cy;
	local spsy = sp * sy;
	
	if not quaternion_output then return Quaternion(Vector(sr * cpcy - cr * spsy,
														   cr * sp * cy + sr * cp * sy,
														   cr * cp * sy - sr * sp * cy),
													cr * cpcy + sr * spsy) end
	
	quaternion_output.Vec.x = sr * cpcy - cr * spsy
	quaternion_output.Vec.y = cr * sp * cy + sr * cp * sy
	quaternion_output.Vec.z = cr * cp * sy - sr * sp * cy
	
	quaternion_output.Rotation = cr * cpcy + sr * spsy
end

local callmeta = {}

function callmeta:__call(vec, rot)
	return Quaternion:New(vec, rot)
end

Quaternion = {}
setmetatable(Quaternion, callmeta)

local opsmeta = {}
opsmeta.__index = Quaternion

function Quaternion:New(vec, rot)
	local obj = {}
	--obj.__index = Quaternion
	setmetatable(obj, opsmeta)
	
	obj.Vec = vec or Vector(0, 0, 0)
	obj.Rotation = math.rad(rot) or 1
	
	return obj
end

function Quaternion:Reset(make_into_identity)
	self.Vec.x = 0
	self.Vec.y = 0
	self.Vec.z = 0
	
	self.Rotation = 1
end

function Quaternion:IsIdentity()
	return tobool((self.Vec.x == 0) and
				  (self.Vec.y == 0) and
				  (self.Vec.z == 0) and
				  (self.Rotation == 1))
end

function opsmeta:__eq(quaternion, epsilon)
	if not epsilon then
		return tobool((self.Vec.x == quaternion.Vec.x) and
					  (self.Vec.y == quaternion.Vec.y) and
					  (self.Vec.z == quaternion.Vec.z) and
					  (self.Rotation == quaternion.Rotation))
	end
	
	return tobool((math.abs(self.Vec.x - quaternion.Vec.x) < epsilon) and
				  (math.abs(self.Vec.y - quaternion.Vec.y) < epsilon) and
				  (math.abs(self.Vec.z - quaternion.Vec.z) < epsilon) and
				  (math.abs(self.Rotation - quaternion.Rotation) < epsilon))
end

function opsmeta:__add(quaternion)
	return Quaternion(Vector(self.Vec.x + quaternion.Vec.x, self.Vec.y + quaternion.Vec.y, self.Vec.z + quaternion.Vec.z), self.Rotation + quaternion.Rotation)
end

function opsmeta:__unm()
	self.Vec = self.Vec * -1
end

function opsmeta:__mul(inval)
	return ((type(inval) == "number") and self:MultiplyScalar(inval) or self:MultiplyQuaternion(inval))
end

function Quaternion:MultiplyQuaternion(quaternion)
	local vec = Vector(self.Rotation * quaternion.Vec.x + self.Vec.x * quaternion.Rotation  +  self.Vec.y * quaternion.Vec.z  -  self.Vec.z * quaternion.Vec.y,
					   self.Rotation * quaternion.Vec.y + self.Vec.y * quaternion.Rotation  +  self.Vec.z * quaternion.Vec.x  -  self.Vec.x * quaternion.Vec.z,
					   self.Rotation * quaternion.Vec.z + self.Vec.z * quaternion.Rotation  +  self.Vec.x * quaternion.Vec.y  -  self.Vec.y * quaternion.Vec.x)
	
	local rot = self.Rotation * quaternion.Rotation - self.Vec.x * quaternion.Vec.x  -  self.Vec.y * quaternion.Vec.y  -  self.Vec.z * quaternion.Vec.z
	
	return Quaternion(vec, rot)
end

function Quaternion:MultiplyScalar(val)
	return Quaternion(self.Vec * val, self.Rotation * val)
end

function Quaternion:SetAxis(vec, deg_rotation)
	return self:SetAxisRad(vec, math.rad(deg_rotation))
end

function Quaternion:SetAxisRad(vec, rad_rotation)
	self.Vec = self.Vec * math.sin(rad_rotation)
	self.Rotation = math.cos(rad_rotation)
end

function Quaternion:Dot(quaternion)
	return ((self.Vec.x * quaternion.Vec.x) + (self.Vec.y * quaternion.Vec.y) + (self.Vec.z * quaternion.Vec.z) + (self.Rotation * quaternion.Rotation))
end

function Quaternion:FromAngle(angle)
	angle = angle * 1
	angle:ToRad()
	
	local cp = math.cos(angle.p * .5)
	local cy = math.cos(angle.y * .5)
	local cr = math.cos(angle.r * .5)
	
	local sp = math.sin(angle.p * .5)
	local sy = math.sin(angle.y * .5)
	local sr = math.sin(angle.r * .5)
	
	local cpcy = cp * cy;
	local spsy = sp * sy;
	
	self.Vec = Vector(sr * cpcy - cr * spsy,
					  cr * sp * cy + sr * cp * sy,
					  cr * cp * sy - sr * sp * cy)
	
	self.Rotation = cr * cpcy + sr * spsy
end

function Quaternion:ToAngle(angle)
	angle = angle or Angle()
	
	local singularity_checks = (self.Vec.y * self.Vec.z) + (self.Vec.x * self.Rotation)
	
	if singularity_checks > 0.499 then -- singularity at north pole
		angle.p = math.pi * .5
		angle.y = 2 * math.atan2(self.Vec.y, self.Rotation)
		angle.r = 0
	elseif singularity_checks < -0.499 then -- singularity at south pole
		angle.p = math.pi * -.5
		angle.y = -2 * math.atan2(self.Vec.y, self.Rotation)
		angle.r = 0
	else
		local x_2 = 1 - (2 * self.Vec.x^2)
		
		angle.p = math.asin(  2 * singularity_checks)
		angle.y = math.atan2((2 * self.Vec.z * self.Rotation) - (2 * self.Vec.y * self.Vec.x), (x_2 - (2 * self.Vec.z^2)))
		angle.r = math.atan2((2 * self.Vec.y * self.Rotation) - (2 * self.Vec.z * self.Vec.x), (x_2 - (2 * self.Vec.y^2)))
	end
	
	angle:ToDeg()
	print(angle)
	return angle
end

function Quaternion:Normalize()
	local scale = (self.Vec.x ^ 2) + (self.Vec.y ^ 2) + (self.Vec.z ^ 2) + (self.Rotation ^ 2)
	
	if (scale == 0) or (scale == 1.0) then return (scale == 1.0) end -- Because it might be a normalized already!
	
	scale = 1 / math.sqrt(scale)
	
	self.Vec.x = self.Vec.x * scale
	self.Vec.y = self.Vec.y * scale
	self.Vec.z = self.Vec.z * scale
	
	self.Rotation = self.Rotation * scale
	
	return true
end

function Quaternion:AimZAxis(point_a, point_b)
	local vAim = (point_b - point_a):Normalize()
	
	self.Vec.x	=  vAim.y
	self.Vec.y	= -vAim.x
	self.Vec.z	= 0
	self.Rotation = 1 + vAim.z

	if (self.Vec.x == 0) and (self.Vec.y == 0) and (self.Vec.z == 0) and (self.Rotation == 0) then -- can't norm this
		return self:Reset()
	else
		return self:Normalize()
	end
end

-- Creates a value from spherical linear interpolation
function QuaternionSlerp(start_quat, end_quat, perc) -- THIS IS SLOWER THEN NLERP!!!
	if start_quat == end_quat then return start_quat end
	
	local perc_a = 1 - perc
	local perc_b = perc
	
	local theta	 = math.acos(a.Dot(b));
	local sin_theta = math.sin(theta);

	if sin_theta > 0.001 then
		perc_a = math.sin((1 - perc) * theta ) / sin_theta
		perc_b = math.sin(perc * theta) / sin_theta
	end
	
	return ((a * perc_a) + (b * perc_b))
end

-- Unlike spherical interpolation, this does not rotate at a constant velocity, and it's faster to do
function QuaternionNLerp(start_quat, end_quat, perc)
	if start_quat == end_quat then return start_quat end
	
	local new_quat = (start_quat * 1) + (end_quat * perc)
	new_quat:Normalize()
	
	return new_quat
end
