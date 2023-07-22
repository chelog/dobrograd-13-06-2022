local rtl = function(self)
	self:SetFontInternal('DermaDefault')
	self:SetUnderlineFont('dbg_window_underline')
	local ct = CurTime()
	if ct < (self.nextLayout or 0) then return end
	self.nextLayout = ct + FrameTime()*2
	self:SetToFullHeight()
end
local omw = function(self, delta)
	self:GetParent():GetParent():OnMouseWheeled(delta)
	return true
end

surface.CreateFont('dbg_laws_title', {
	font = system.IsOSX() and 'Helvetica' or 'Tahoma',
	size = 18,
	antialias = true,
	extended = true,
})

local as = function(_, name, val)
	if name == 'TextClicked' then
		gui.ActivateGameUI()
		octoesc.OpenURL(val)
	end
end

local function showLaws()

	local f = vgui.Create 'DFrame'
	f:SetSize(300, 300)
	f:SetTitle('Законы города')
	f:SetSizable(true)
	f:SetMinWidth(300)
	f:AlignTop(5)
	f:AlignLeft(5)

	local scr = f:Add 'DScrollPanel'
	scr:Dock(FILL)

	local btn = scr:Add 'DButton'
	btn:Dock(TOP)
	btn:SetText('Основные законы города')
	btn:SetTall(36)
	function btn:DoClick()
		gui.ActivateGameUI()
		octoesc.OpenURL('https://wiki.octothorp.team/ru/dobrograd/legislation')
	end

	local title = scr:Add 'DLabel'
	title:Dock(TOP)
	title:DockMargin(0, 10, 0, 5)
	title:SetContentAlignment(5)
	title:SetFont('dbg_laws_title')
	title:SetText('Правки от мэра')

	for i, v in ipairs(DarkRP.getLaws()) do
		local splitter = scr:Add 'DPanel'
		splitter:Dock(TOP)
		splitter:DockMargin(0, 5, 0, 5)
		splitter:SetTall(1)

		local lbl = scr:Add 'RichText'
		lbl:Dock(TOP)
		v = octolib.string.splitByUrl(('10.%i. %s'):format(i, v))
		lbl:InsertColorChange(255, 255, 255, 255)
		for _, token in ipairs(v) do
			if istable(token) then
				lbl:InsertClickableTextStart(token[1])
				lbl:InsertColorChange(0, 130, 255, 255)
				lbl:AppendText(token[1])
				lbl:InsertColorChange(255, 255, 255, 255)
				lbl:InsertClickableTextEnd()
			else
				lbl:AppendText(token)
			end
		end
		lbl.PerformLayout = rtl
		lbl.ActionSignal = as
		lbl.OnMouseWheeled = omw
		lbl:SetVerticalScrollbarEnabled(false)
	end

end

octogui.cmenu.registerItem('mayor', 'laws_show', {
	text = L.show_laws,
	icon = octolib.icons.silk16('scripts_text'),
	action = showLaws,
})

octogui.cmenu.registerItem('mayor', 'mayor_actions', {
	text = L.mayor,
	check = DarkRP.isMayor,
	icon = octolib.icons.silk16('star'),
	options = {
		{
			text = 'Изменить законы',
			icon = octolib.icons.silk16('script_edit'),
			options = {
				{
					text = L.addlaw,
					icon = octolib.icons.silk16('script_add'),
					action = octolib.fStringRequest(L.addlaw, L.addlaw_hint, '', function(s)
						octochat.say('/addlaw', s)
					end, nil, L.ok, L.cancel),
				}, {
					text = L.removelaw,
					icon = octolib.icons.silk16('script_delete'),
					build = function(sm)
						for k,v in ipairs(DarkRP.getLaws()) do
							sm:AddOption(v, function()
								octochat.say('/removelaw', k)
							end)
						end
					end,
				}, {
					text = L.resetclaws,
					icon = octolib.icons.silk16('script_torn'),
					say = '/resetlaws',
				},
			}
		}, {
			text = L.rename_city,
			icon = octolib.icons.silk16('textfield_rename'),
			action = octolib.fStringRequest(L.rename_city, L.rename_city_hint, '', function(s)
				octochat.say('/renamecity', s)
			end, nil, L.ok, L.cancel),
		}, {
			text = function()
				return netvars.GetNetVar('lockdown') and L.c_language_unlockdown or L.c_language_lockdown
			end,
			icon = function()
				return octolib.icons.silk16(netvars.GetNetVar('lockdown') and 'bell_delete' or 'bell')
			end,
			action = function()
				if netvars.GetNetVar('lockdown') then
					return octochat.say('/unlockdown')
				end

				Derma_StringRequest(L.lockdown, L.lockdown_hint, '', function(s)
					octochat.say('/lockdown', string.Trim(s))
				end, nil, L.ok, L.cancel)
			end,
		}, {
			text = L.broadcast,
			icon = octolib.icons.silk16('radio_modern'),
			action = octolib.fStringRequest(L.broadcast_hint, L.broadcast_write_text, '', function(s)
				octochat.say('/broadcast', s)
			end, nil, L.ok, L.cancel)
		},
	},
})
