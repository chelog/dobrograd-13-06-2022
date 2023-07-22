local oldvguicreate = vgui.Create

function vgui.Create(...)
	print(arg[1])
	
	return oldvguicreate(unpack(arg))
end