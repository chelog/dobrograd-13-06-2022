--[[
	Namespace: octolib

	Group: poly
		Polygon helper functions
]]
octolib.poly = octolib.poly or {}

--[[
	Function: polyRotate
		Destructively rotates polygon structure around (0,0) point

	Arguments:
		<table> poly - Polygon structure to rotate, will be changed in place
		<float> ang - Angle in degrees clockwise

	Returns:
		<table> - Input _poly_, with rotated points
]]
function octolib.poly.rotate(poly, ang)
	if ang == 0 then return poly end

	local deg = math.rad(ang)
	local sin, cos = math.sin(deg), math.cos(deg)

	for _, vert in ipairs(poly) do
		local x, y = vert.x, vert.y

		local xn = x * cos - y * sin
		local yn = x * sin + y * cos

		vert.x, vert.y = xn, yn
	end

	return poly
end

--[[
	Function: polyTranslate
		Destructively move polygon structure

	Arguments:
		<table> poly - Polygon structure to move, will be changed in place
		<float> dx - Distance to translate along X axis
		<float> dy - Distance to translate along Y axis

	Returns:
		<table> - Input _poly_, with trnaslated points
]]
function octolib.poly.translate(poly, dx, dy)
	for _, vert in ipairs(poly) do
		vert.x, vert.y = vert.x + dx, vert.y + dy
	end
end