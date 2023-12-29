-- used to declare types for docs generator

--[[
	Type: any

	Type: vararg

	Type: bool

	Type: int

	Type: float

	Type: string

	Type: function

	Type: table

	Class: Player
		Extension of <Garry's Mod's Player: https://wiki.facepunch.com/gmod/Player> class

	Class: Entity
		Extension of <Garry's Mod's Entity: https://wiki.facepunch.com/gmod/Entity> class

	Class: Panel
		Extension of <Garry's Mod's Panel: https://wiki.facepunch.com/gmod/Panel> class
]]

--[[
	Type: Poly
		Sequential table of <polygon vertexes: https://wiki.facepunch.com/gmod/Structures/PolygonVertex>
]]
--[[
	Type: ContextMenuItem
		Element representing single context menu entry. Used in <octolib.menu>

	Properties:
		<string> 1 - Menu item's text
		<string> 2='' - Menu item's icon, optional
		<any> 3 - In case of <function> defines entry's click behaviour,
			if <table> of <ContextMenuItem> is passed, builds submenu recursively

	Notes:
		Pass <string> 'spacer' instead of <ContextMenuItem> to create a separator
]]
