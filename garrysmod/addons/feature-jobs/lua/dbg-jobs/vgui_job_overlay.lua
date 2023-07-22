local PANEL = {}

function PANEL:Init()
	self:SetSize(350, 300)
	self:DockPadding(5, 5, 5, 5)

	self.title = self:Add 'DLabel'
	self.title:Dock(TOP)
	self.title:SetTall(40)
	self.title:SetContentAlignment(5)
	self.title:SetFont('dbg-jobs.title')
	self.title:SetText('...')

	self.desc = self:Add 'DMarkup'
	self.desc:Dock(TOP)
	self.desc:DockMargin(5, 0, 5, 0)
	self.desc:SetText('...')

	self.accept = octolib.button(self, 'Принять заказ', function()
		self:AcceptJob()
	end)
	self.accept:Dock(BOTTOM)
	self.accept:SetTall(30)
end

function PANEL:SetJob(mainPanel, publishData, startData)
	self.mainPanel = mainPanel
	self.publishData = publishData
	self.startData = startData

	self.title:SetText(publishData.name)

	local desc = publishData.desc .. '\n'
	if publishData.timeout then desc = desc .. '\nОграничение по времени: ' .. math.floor(publishData.timeout / 60) .. ' мин' end
	if publishData.deposit then
		desc = desc .. '\nЗалог за взятие заказа: ' .. DarkRP.formatMoney(publishData.deposit)
	end

	if startData and startData.ply == LocalPlayer() then
		self.accept:SetText('Отказаться')
	elseif publishData.deposit then
		self.accept:SetText(('Принять заказ (%s)'):format(DarkRP.formatMoney(publishData.deposit)))
	else
		self.accept:SetText('Принять заказ')
	end
	desc = desc .. '\nПлата за выполнение: ' .. publishData.reward

	self.desc:SetText(desc)
end

function PANEL:AcceptJob()
	if not self.publishData then return end

	if self.startData and self.startData.ply == LocalPlayer() then
		Derma_Query('Ты хочешь отказаться от выполнения?\nЗалог не будет возвращен', 'Отмена заказа', 'Да', function()
			netstream.Start('dbg-jobs.cancel', self.publishData.id)
			self.mainPanel.overlay:Remove()
		end, 'Отмена')
	else
		Derma_Query('Ты хочешь принять этот заказ?\nПри его невыполнении залог не будет возвращен', 'Принятие заказа', 'Да', function()
			self.accept:SetEnabled(false)
			self.accept:SetText('Загрузка...')

			netstream.Request('dbg-jobs.take', self.publishData.id):Then(function(err)
				if not err then
					self.mainPanel:SwitchToName('Принятые')
					self.mainPanel.overlay:Remove()
				else
					Derma_Message(err, 'Ошибка', 'Понятно')
					self.accept:SetEnabled(true)
					self:SetJob(self.mainPanel, self.publishData, self.startData)
				end
			end)
		end, 'Отмена')
	end
end

vgui.Register('dbg_jobs_overlay', PANEL, 'DPanel')
