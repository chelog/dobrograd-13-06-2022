CreateClientConVar('octolib_blur', '1', true, false)

if CFG.disabledModules.skin then return end

local surface = surface
local draw = draw
local Color = Color

CFG.skinColors = CFG.skinColors or {}
local cols = CFG.skinColors

cols.b = cols.b or Color(65,132,209, 255)
cols.y = cols.y or Color(240,202,77, 255)
cols.r = cols.r or Color(222,91,73, 255)
cols.g = cols.g or Color(102,170,170, 255)
cols.o = cols.o or Color(170,119,102, 255)

cols.bg = cols.bg or Color(85,68,85, 255)

cols.bg95 = cols.bg95 or Color(cols.bg.r, cols.bg.g, cols.bg.b, 241)
cols.bg60 = cols.bg60 or Color(cols.bg.r, cols.bg.g, cols.bg.b, 150)
cols.bg50 = cols.bg50 or Color(cols.bg.r / 2, cols.bg.g / 2, cols.bg.b / 2, 255)

cols.bg_d = cols.bg_d or Color(cols.bg.r * 0.75, cols.bg.g * 0.75, cols.bg.b * 0.75, 255)
cols.bg_l = cols.bg_l or Color(cols.bg.r * 1.25, cols.bg.g * 1.25, cols.bg.b * 1.25, 255)
cols.bg_grey = cols.bg_grey or Color(180,180,180, 255)
cols.g_d = cols.g_d or Color(cols.g.r * 0.75, cols.g.g * 0.75, cols.g.b * 0.75, 255)
cols.r_d = cols.r_d or Color(cols.r.r * 0.75, cols.r.g * 0.75, cols.r.b * 0.75, 255)

cols.hvr = cols.hvr or Color(0,0,0, 50)
cols.dsb = cols.dsb or Color(255,255,255, 50)

local toBg, toBgTime = cols.bg, 1
local toG, toGTime = cols.g, 1

local function updateColors()

	local colBg, colG = cols.bg, cols.g
	if colBg == toBg and colG == toG then
		return hook.Remove('Think', 'octolib.skinColors')
	end

	-- Update colBg
	local ft = FrameTime()
	colBg.r = octolib.math.lerp(colBg.r, toBg.r, ft / toBgTime, 0, 255)
	colBg.g = octolib.math.lerp(colBg.g, toBg.g, ft / toBgTime, 0, 255)
	colBg.b = octolib.math.lerp(colBg.b, toBg.b, ft / toBgTime, 0, 255)
	local r, g, b = colBg.r, colBg.g, colBg.b
	cols.bg = colBg
	cols.bg95 = ColorAlpha(colBg, 241)
	cols.bg60 = ColorAlpha(colBg, 150)
	cols.bg50 = Color(r / 2, g / 2, b / 2, 255)
	cols.bg_d = Color(r * 0.75, g * 0.75, b * 0.75, 255)
	cols.bg_l = Color(r * 1.25, g * 1.25, b * 1.25, 255)

	-- Update colG
	colG.r = octolib.math.lerp(colG.r, toG.r, ft / toGTime, 0, 255)
	colG.g = octolib.math.lerp(colG.g, toG.g, ft / toGTime, 0, 255)
	colG.b = octolib.math.lerp(colG.b, toG.b, ft / toGTime, 0, 255)
	r, g, b = colG.r, colG.g, colG.b
	cols.g = colG
	cols.g_d = Color(r * 0.75, g * 0.75, b * 0.75)
end

function octolib.changeSkinColor(bgColor, gColor, delta)
	if not IsColor(bgColor) and not IsColor(gColor) then return end

	delta = delta or 1
	toBg, toBgTime = bgColor or toBg, delta
	toG, toGTime = gColor or toG, delta
	hook.Add('Think', 'octolib.skinColors', updateColors)
end

surface.CreateFont('dbg-icons', {
	font = 'FontAwesome',
	extended = true,
	size = 13,
	weight = 400,
})

surface.CreateFont('dbg-icons2', {
	font = 'FontAwesome',
	extended = true,
	size = 14,
	weight = 400,
})

surface.CreateFont('dbg-icons3', {
	font = 'FontAwesome',
	extended = true,
	size = 9,
	weight = 400,
})

local SKIN = {}
SKIN.PrintName = 'DBG Derma Skin'
SKIN.Author = 'chelog'

SKIN.fontFrame = 'DermaDefault'
SKIN.fontTab = 'DermaDefault'
SKIN.fontCategoryHeader = 'TabLarge'

SKIN.GwenTexture = Material('gwenskin/GModDefault.png')
SKIN.Shadow = GWEN.CreateTextureBorder(448, 0, 31, 31, 8, 8, 8, 8)
SKIN.colOcto = cols

SKIN.bg_color					= Color(101, 100, 105, 255)
SKIN.bg_color_sleep				= Color(70, 70, 70, 255)
SKIN.bg_color_dark				= Color(55, 57, 61, 255)
SKIN.bg_color_bright			= Color(220, 220, 220, 255)
SKIN.frame_border				= Color(50, 50, 50, 255)

SKIN.control_color				= Color(120, 120, 120, 255)
SKIN.control_color_highlight	= Color(150, 150, 150, 255)
SKIN.control_color_active		= Color(110, 150, 250, 255)
SKIN.control_color_bright		= Color(255, 200, 100, 255)
SKIN.control_color_dark			= Color(100, 100, 100, 255)

SKIN.bg_alt1					= Color(50, 50, 50, 255)
SKIN.bg_alt2					= Color(55, 55, 55, 255)

SKIN.listview_hover				= Color(70, 70, 70, 255)
SKIN.listview_selected			= Color(100, 170, 220, 255)
SKIN.combobox_selected			= SKIN.listview_selected

SKIN.text_bright				= Color(255, 255, 255, 255)
SKIN.text_normal				= Color(180, 180, 180, 255)
SKIN.text_dark					= Color(255, 255, 255, 255)
SKIN.text_highlight				= Color(255, 20, 20, 255)

SKIN.panel_transback			= Color(255, 255, 255, 50)
SKIN.tooltip					= Color(255, 245, 175, 255)
SKIN.colPropertySheet			= Color(170, 170, 170, 255)

SKIN.colTab						= SKIN.colPropertySheet
SKIN.colTabInactive				= Color(140, 140, 140, 255)
SKIN.colTabShadow				= Color(0, 0, 0, 170)
SKIN.colTabText					= Color(255, 255, 255, 255)
SKIN.colTabTextInactive			= Color(0, 0, 0, 200)

SKIN.colCollapsibleCategory		= Color(255, 255, 255, 20)

SKIN.colCategoryText			= Color(255, 255, 255, 255)
SKIN.colCategoryTextInactive	= Color(200, 200, 200, 255)

SKIN.colNumberWangBG			= Color(255, 240, 150, 255)
SKIN.colTextEntryBG				= cols.bg
SKIN.colTextEntryBorder			= Color(20, 20, 20, 255)
SKIN.colTextEntryText			= Color(30, 30, 30, 255)
SKIN.colTextEntryTextHighlight	= cols.o
SKIN.colTextEntryTextCursor		= Color(30, 30, 30, 255)
SKIN.colTextEntryTextPlaceholder= Color(100, 100, 100, 100)

SKIN.colMenuBG					= cols.bg
SKIN.colMenuBorder				= cols.o

SKIN.colButtonText				= Color(255, 255, 255, 255)
SKIN.colButtonTextDisabled		= Color(255, 255, 255, 55)
SKIN.colButtonBorder			= Color(20, 20, 20, 255)
SKIN.colButtonBorderHighlight	= Color(255, 255, 255, 50)
SKIN.colButtonBorderShadow		= Color(0, 0, 0, 100)

SKIN.Colours = {}

SKIN.Colours.Button = {}
SKIN.Colours.Button.Disabled = Color(0,0,0,100)
SKIN.Colours.Button.Down = Color(180,180,180,255)
SKIN.Colours.Button.Hover = Color(255,255,255,255)
SKIN.Colours.Button.Normal = Color(255,255,255,255)

SKIN.Colours.Category = {}
SKIN.Colours.Category.Header = Color(255,255,255,255)
SKIN.Colours.Category.Header_Closed = Color(255,255,255,150)
SKIN.Colours.Category.Line = {}
SKIN.Colours.Category.Line.Button = Color(255,255,255,0)
SKIN.Colours.Category.Line.Button_Hover = Color(0,0,0,8)
SKIN.Colours.Category.Line.Button_Selected = Color(255,216,0,255)
SKIN.Colours.Category.Line.Text = Color(200,200,200,255)
SKIN.Colours.Category.Line.Text_Hover = Color(255,255,255,255)
SKIN.Colours.Category.Line.Text_Selected = Color(255,255,255,255)
SKIN.Colours.Category.LineAlt = {}
SKIN.Colours.Category.LineAlt.Button = Color(0,0,0,26)
SKIN.Colours.Category.LineAlt.Button_Hover = Color(0,0,0,32)
SKIN.Colours.Category.LineAlt.Button_Selected = Color(255,216,0,255)
SKIN.Colours.Category.LineAlt.Text = Color(200,200,200,255)
SKIN.Colours.Category.LineAlt.Text_Hover = Color(255,255,255,255)
SKIN.Colours.Category.LineAlt.Text_Selected = Color(255,255,255,255)

SKIN.Colours.Label = {}
SKIN.Colours.Label.Bright = Color(255,255,255,255)
SKIN.Colours.Label.Dark = Color(255,255,255,255)
SKIN.Colours.Label.Default = Color(255,255,255,255)
SKIN.Colours.Label.Highlight = Color(255,0,0,255)

SKIN.Colours.Properties = {}
SKIN.Colours.Properties.Border = cols.bg
SKIN.Colours.Properties.Column_Hover = Color(118,199,255,59)
SKIN.Colours.Properties.Column_Normal = Color(255,255,255,0)
SKIN.Colours.Properties.Column_Selected = Color(118,199,255,255)
SKIN.Colours.Properties.Label_Hover = Color(50,50,50,255)
SKIN.Colours.Properties.Label_Normal = Color(0,0,0,255)
SKIN.Colours.Properties.Label_Selected = Color(0,0,0,255)
SKIN.Colours.Properties.Line_Hover = Color(156,156,156,255)
SKIN.Colours.Properties.Line_Normal = Color(156,156,156,255)
SKIN.Colours.Properties.Line_Selected = Color(156,156,156,255)
SKIN.Colours.Properties.Title = Color(255,255,255,255)

SKIN.Colours.Tab = {}
SKIN.Colours.Tab.Active = {}
SKIN.Colours.Tab.Active.Disabled = Color(233,233,233,204)
SKIN.Colours.Tab.Active.Down = Color(255,255,255,255)
SKIN.Colours.Tab.Active.Hover = Color(255,255,255,255)
SKIN.Colours.Tab.Active.Normal = Color(255,255,255,255)
SKIN.Colours.Tab.Inactive = {}
SKIN.Colours.Tab.Inactive.Disabled = Color(210,210,210,204)
SKIN.Colours.Tab.Inactive.Down = Color(255,255,255,255)
SKIN.Colours.Tab.Inactive.Hover = Color(249,249,249,153)
SKIN.Colours.Tab.Inactive.Normal = Color(255,255,255,102)

SKIN.Colours.TooltipText = Color(255,255,255,255)

SKIN.Colours.Tree = {}
SKIN.Colours.Tree.Hover = cols.g
SKIN.Colours.Tree.Normal = color_white
SKIN.Colours.Tree.Lines = Color(255,255,255, 35)
SKIN.Colours.Tree.Selected = color_white

SKIN.Colours.Window = {}
SKIN.Colours.Window.TitleActive = Color(255,255,255,204)
SKIN.Colours.Window.TitleInactive = Color(255,255,255,92)

SKIN.Colours.TooltipText = Color(255,255,255,255)

local function shadow(x, y, w, h)

	SKIN.Shadow(x, y, w, h)

end

function SKIN:PaintPanel(pnl, w, h)

	if not pnl.m_bBackground then return end

	draw.RoundedBox(4, 0, 0, w, h, cols.bg_d)
	draw.RoundedBox(4, 1, 1, w-2, h-2, cols.bg60)

end

function SKIN:PaintFrame(pnl, w, h)

	-- if pnl.m_bPaintShadow then
		DisableClipping( true )
		shadow( -4, -4, w+10, h+10 )
		DisableClipping( false )
	-- end

	draw.RoundedBox(4, 0, 0, w, h, cols.bg)
	draw.RoundedBoxEx(4, 0, 0, w, 24, Color(0,0,0, 80), true, true, false, false)

end

function SKIN:PaintTextEntry(pnl, w, h)

	if pnl.m_bBackground then
		if pnl.PaintOffset then
			surface.DisableClipping(true)
			if pnl:GetDisabled() then
				draw.RoundedBox(4, -pnl.PaintOffset, -pnl.PaintOffset, w + pnl.PaintOffset*2, h + pnl.PaintOffset*2, Color(255,255,255, 100))
			elseif pnl:HasFocus() then
				draw.RoundedBox(4, -pnl.PaintOffset, -pnl.PaintOffset, w + pnl.PaintOffset*2, h + pnl.PaintOffset*2, cols.y)
			else
				draw.RoundedBox(4, -pnl.PaintOffset, -pnl.PaintOffset, w + pnl.PaintOffset*2, h + pnl.PaintOffset*2, color_white)
			end
			surface.DisableClipping(false)
		else
			if pnl:GetDisabled() then
				draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255, 100))
			elseif pnl:HasFocus() then
				draw.RoundedBox(4, 0, 0, w, h, cols.y)
			else
				draw.RoundedBox(4, 0, 0, w, h, color_white)
			end
		end
	end

	if (pnl.GetPlaceholderText and pnl.GetPlaceholderColor and pnl:GetPlaceholderText() and pnl:GetPlaceholderText():Trim() ~= "" and pnl:GetPlaceholderColor() and (not pnl:GetText() or pnl:GetText() == "")) then
		local oldText = pnl:GetText()
		local str = pnl:GetPlaceholderText()
		if str:StartWith("#") then str = language.GetPhrase(str:sub(2)) end

		pnl:SetText(str)
		pnl:DrawTextEntryText(pnl:GetPlaceholderColor(), pnl:GetHighlightColor(), pnl:GetCursorColor())
		pnl:SetText(oldText)

		return
	end

	pnl:DrawTextEntryText(pnl:GetTextColor(), pnl:GetHighlightColor(), pnl:GetCursorColor())

end

function SKIN:PaintButton(pnl, w, h)

	if not pnl.m_bBackground then return end

	local off = h > 20 and 2 or 1
	if pnl.Depressed then
		draw.RoundedBox(4, 0, off, w, h-off, cols.g)
		draw.RoundedBox(4, 0, off, w, h-off, cols.hvr)
	else
		draw.RoundedBox(4, 0, 0, w, h, cols.g_d)
		draw.RoundedBox(4, 0, 0, w, h-off, cols.g)
		if pnl.Disabled then
			draw.RoundedBox(4, 0, 0, w, h, cols.dsb)
		elseif pnl.Hovered then
			draw.RoundedBox(4, 0, 0, w, h, cols.hvr)
		end
	end

end

function SKIN:PaintTree( pnl, w, h )

	if not pnl.m_bBackground then return end

	draw.RoundedBox(4, 0, 0, w, h, Color(0,0,0, 80))
	draw.RoundedBox(4, 1, 1, w-2, h-2, cols.bg60)

end

function SKIN:PaintSelection( pnl, w, h )

	draw.RoundedBox(4, 0, 0, w, h, cols.o)

end

function SKIN:PaintTreeNodeButton( pnl, w, h )

	if not pnl.m_bSelected then return end

	local w, _ = pnl:GetTextSize()
	draw.RoundedBox(4, 38, 2, w + 6, h-3, cols.o)

end

function SKIN:PaintTreeNode( pnl, w, h )

	if not pnl.m_bDrawLines then return end

	surface.SetDrawColor( self.Colours.Tree.Lines )
	if ( pnl.m_bLastChild ) then
		surface.DrawRect( 9, 0, 1, 8 )
		surface.DrawRect( 10, 7, 8, 1 )
	else
		surface.DrawRect( 9, 0, 1, h )
		surface.DrawRect( 10, 7, 8, 1 )
	end

end

function SKIN:PaintListViewLine( pnl, w, h )

	if ( pnl:IsSelected() ) then
		draw.RoundedBox(4, 0, 0, w, h, cols.o)
	elseif ( pnl.Hovered ) then
		draw.RoundedBox(4, 0, 0, w, h, cols.hvr)
	elseif ( pnl.m_bAlt ) then
		draw.RoundedBox(4, 0, 0, w, h, Color(0,0,0, 35))
	end

end

function SKIN:PaintListView( pnl, w, h )

	if not pnl.m_bBackground then return end
	-- draw.RoundedBox(4, 0, 0, w, h, cols.hvr)

end

function SKIN:PaintCategoryList( panel, w, h )

	-- self.tex.CategoryList.Outer( 0, 0, w, h )

end

function SKIN:PaintCategoryButton( panel, w, h )

	if ( panel.AltLine ) then

		if ( panel.Depressed or panel.m_bSelected ) then draw.RoundedBox(4, 0, 0, w, h, cols.o)
		elseif ( panel.Hovered ) then draw.RoundedBox(4, 0, 0, w, h, cols.hvr)
		else draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255, 1)) end

	else

		if ( panel.Depressed or panel.m_bSelected ) then draw.RoundedBox(4, 0, 0, w, h, cols.o)
		elseif ( panel.Hovered ) then draw.RoundedBox(4, 0, 0, w, h, cols.hvr)
		end

	end

end

function SKIN:PaintSliderKnob( pnl, w, h )

	if pnl:GetDisabled() then
		return draw.SimpleText(utf8.char(0xf111), 'dbg-icons', w/2, h/2, cols.dsb, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	elseif pnl.Depressed or pnl.Hovered then
		return draw.SimpleText(utf8.char(0xf111), 'dbg-icons', w/2, h/2, cols.g, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText(utf8.char(0xf111), 'dbg-icons', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

end

function SKIN:PaintNumSlider( pnl, w, h )

	draw.RoundedBox(1, 8, h/2-1, w-15, 2, Color(255,255,255, 25))
	if not pnl.m_TextColorSet then
		if pnl:GetParent().TextArea then
			pnl:GetParent().TextArea:SetTextColor(Color(255,255,255))
		end
		pnl.m_TextColorSet = true
	end

end

function SKIN:PaintTab(pnl, w, h)

	if pnl:IsActive() then
		draw.RoundedBoxEx(4, 2, 0, w-5, h, cols.bg, true, true, false, false)
	else
		-- draw.RoundedBoxEx(4, 2, 0, w-5, h, cols.bg, true, true, false, false)
	end

end

function SKIN:PaintPropertySheet(pnl, w, h)

	draw.RoundedBox(4, 0, 2, w, h-2, cols.bg)
	draw.RoundedBoxEx(4, 0, 2, w, 18, Color(0,0,0, 220), true, true, false, false)

end

function SKIN:PaintCollapsibleCategory(pnl, w, h)

	draw.RoundedBox(4, 0, 5, w, h-5, cols.bg)
	draw.RoundedBox(4, 0, 0, w, 20, cols.g)

end

function SKIN:PaintWindowCloseButton(pnl, w, h)

	if pnl.Disabled then return end

	if pnl.Depressed then
		draw.RoundedBox(8, w/2-8, h/2-7, 16, 16, cols.r)
		if pnl.Hovered then
			draw.SimpleText(utf8.char(0xf00d), 'dbg-icons', w / 2, h / 2, Color(0,0,0, 120), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	else
		draw.RoundedBox(8, w/2-8, h/2-7, 16, 16, cols.r_d)
		draw.RoundedBox(8, w/2-8, h/2-8, 16, 16, cols.r)
		if pnl.Hovered then
			draw.SimpleText(utf8.char(0xf00d), 'dbg-icons', w / 2, h / 2-1, Color(0,0,0, 120), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

end

function SKIN:PaintTooltip( pnl, w, h )

	surface.DisableClipping(true)

	shadow(-7, -4, w + 14, h + 8)
	draw.RoundedBox(4, -3, 0, w + 6, h, cols.o)
	draw.NoTexture()
	surface.DrawPoly({
		{x = w/2 - 5, y = h},
		{x = w/2 + 5, y = h},
		{x = w/2, y = h + 5},
	})

	surface.DisableClipping(false)

end

function SKIN:PaintVScrollBar( panel, w, h )

	draw.RoundedBox(4, w/2-2, w+3, 4, h-6 - w*2, Color(255,255,255, 25))

end

function SKIN:PaintScrollBarGrip( panel, w, h )

	draw.RoundedBox(4, w/2-4, 0, 8, h, cols.g)

	if ( panel:GetDisabled() ) then
		return draw.RoundedBox(4, w/2-4, 0, 8, h, cols.dsb)
	end

	if ( panel.Depressed ) then
		return draw.RoundedBox(4, w/2-4, 0, 8, h, cols.hvr)
	end

	if ( panel.Hovered ) then
		return draw.RoundedBox(4, w/2-4, 0, 8, h, cols.hvr)
	end

end

function SKIN:PaintButtonDown( pnl, w, h )

	if not pnl.m_bBackground or pnl:GetDisabled() then return end

	local col = Color(255,255,255, 25)
	if pnl.Hovered or pnl.Depressed or pnl:IsSelected() then
		col.a = 255
	end

	draw.SimpleText(utf8.char(0xf078), 'dbg-icons2', w/2, h/2-1, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

function SKIN:PaintButtonUp( pnl, w, h )

	if not pnl.m_bBackground or pnl:GetDisabled() then return end

	local col = Color(255,255,255, 25)
	if pnl.Hovered or pnl.Depressed or pnl:IsSelected() then
		col.a = 255
	end

	draw.SimpleText(utf8.char(0xf077), 'dbg-icons2', w/2, h/2-1, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

function SKIN:PaintButtonLeft( pnl, w, h )

	if not pnl.m_bBackground or pnl:GetDisabled() then return end

	local col = Color(255,255,255, 25)
	if pnl.Hovered or pnl.Depressed or pnl:IsSelected() then
		col.a = 255
	end

	draw.SimpleText(utf8.char(0xf053), 'dbg-icons2', w/2, h/2-1, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

function SKIN:PaintButtonRight( pnl, w, h )

	if not pnl.m_bBackground or pnl:GetDisabled() then return end

	local col = Color(255,255,255, 25)
	if pnl.Hovered or pnl.Depressed or pnl:IsSelected() then
		col.a = 255
	end

	draw.SimpleText(utf8.char(0xf054), 'dbg-icons2', w/2, h/2-1, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

function SKIN:PaintMenu( pnl, w, h )

	surface.DisableClipping(true)
	shadow(-5, -5, w + 10, h + 10)
	surface.DisableClipping(false)

	draw.RoundedBox(4, 0, 0, w, h, cols.bg_l)
	draw.RoundedBox(4, 1, 1, w-2, h-2, cols.bg)

end

function SKIN:PaintMenuSpacer( pnl, w, h )

	surface.SetDrawColor(cols.bg_l)
	surface.DrawRect(0, 0, w, h)

end

function SKIN:PaintMenuOption( pnl, w, h )

	if pnl.m_bBackground and (pnl.Hovered or pnl.Highlight) then
		draw.RoundedBox(4, 0, 0, w, h, cols.o)
	end

	if pnl:GetChecked() then
		draw.SimpleText(utf8.char(0xf00c), 'dbg-icons2', 16, h/2, Color(255,255,255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		-- draw.RoundedBox(4, 0, 0, w, h, cols.o)
	end

	if not pnl.m_TextColorSet then
		pnl:SetTextColor(Color(255,255,255))
		pnl.m_TextColorSet = true
	end

end

function SKIN:PaintMenuRightArrow( pnl, w, h )

	draw.SimpleText(utf8.char(0xf054), 'dbg-icons3', w-5, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

function SKIN:PaintMenuBar( pnl, w, h )

	draw.RoundedBox(0, 0, 0, w, h, cols.bg)

end

function SKIN:PaintExpandButton( pnl, w, h )

	if pnl:GetExpanded() then
		draw.SimpleText(utf8.char(0xf111), 'dbg-icons', w/2, h/2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(utf8.char(0xf056), 'dbg-icons', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText(utf8.char(0xf111), 'dbg-icons', w/2, h/2, cols.bg, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(utf8.char(0xf055), 'dbg-icons', w/2, h/2, Color(255,255,255, 80), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

end

function SKIN:PaintComboDownArrow( pnl, w, h )

	draw.SimpleText(utf8.char(0xf078), 'dbg-icons', w/2, h/2, Color(0,0,0, 120), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

function SKIN:PaintComboBox( pnl, w, h )

	if pnl:GetDisabled() then
		draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255, 100))
	elseif pnl:HasFocus() then
		draw.RoundedBox(4, 0, 0, w, h, cols.y)
	elseif pnl.Depressed or pnl:IsMenuOpen() then
		draw.RoundedBox(4, 0, 0, w, h, cols.y)
	else
		draw.RoundedBox(4, 0, 0, w, h, color_white)
	end

	if not pnl.m_TextColorSet then
		pnl:SetTextColor(Color(30,30,30))
		pnl.m_TextColorSet = true
	end

end

function SKIN:PaintCheckBox( pnl, w, h )

	local col = Color(255,255,255, 255)
	if pnl:GetDisabled() then
		col.a = 100
	end

	if pnl:GetChecked() then
		draw.SimpleText(utf8.char(0xf14a), 'dbg-icons2', w/2, h/2-1, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText(utf8.char(0xf0c8), 'dbg-icons2', w/2, h/2-1, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

end

function SKIN:PaintNumberUp( pnl, w, h )

	draw.SimpleText(utf8.char(0xf077), 'dbg-icons3', w/2, h/2, Color(30,30,30), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

function SKIN:PaintNumberDown( pnl, w, h )

	draw.SimpleText(utf8.char(0xf078), 'dbg-icons3', w/2, h/2, Color(30,30,30), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

function SKIN:PaintWindowMaximizeButton(pnl, w, h) end
function SKIN:PaintWindowMinimizeButton(pnl, w, h) end

function SKIN:PaintProgress(pnl, w, h)

	local y = h / 2 - 9
	draw.RoundedBox(8, 0, y, w, 18, Color(0,0,0, 65))
	local fr = pnl:GetFraction()
	if fr > 0 then
		draw.RoundedBox(8, 1, y + 1, (w-18) * fr + 16, 16, cols.g)
	end

end

local skin = derma.GetNamedSkin('octolib')
if skin then
	for k, v in pairs(SKIN) do skin[k] = v end
else
	derma.DefineSkin('octolib', 'DBG skin', SKIN)
end

hook.Add('ForceDermaSkin', 'dbg-skin', function()

	return 'octolib'

end)
