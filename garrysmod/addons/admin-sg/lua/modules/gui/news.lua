--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local category = {}

category.name = "News"
category.material = "serverguard/menuicons/icon_announcements.png"

local loadingTexture = Material("icon16/arrow_rotate_anticlockwise.png")

local function retrieveNews()
	local function resetPanels()
		category.panel.loadingPanel:SetVisible(false)
		category.panel.newsPanel:SetVisible(false)
		category.panel.divider:SetVisible(true)

		category.panel.refresh:SetVisible(true)
		category.panel.back:SetVisible(false)
	end

	http.Fetch(SERVERGUARD.ENDPOINT .. "get/news/top",
		function(body, length, headers, responseCode)
			local returnData = util.JSONToTable(body)

			if (returnData != nil && table.Count(returnData) > 0) then
				if (!returnData["success"]) then
					resetPanels()
					return;
				end

				category.panel.divider:Clear()

				for k, v in pairs(returnData["items"]) do
					local panel = category.panel.divider:AddRow(v["date"], v["title"])

					function panel:DoClick()
						category.panel.newsPanel:PopulateArticle(v["title"], v["date"], v["stub"], v["content"])

						category.panel.loadingPanel:SetVisible(false)
						category.panel.newsPanel:SetVisible(true)
						category.panel.divider:SetVisible(false)

						category.panel.refresh:SetVisible(false)
						category.panel.back:SetVisible(true)
					end
				end
			end

			resetPanels()
		end,

		function(error)
			resetPanels()
		end
	)
end

function category:Create(base)
	base.panel = base:Add("tiger.panel")
	base.panel:SetTitle("Latest news")
	base.panel:Dock(FILL)
	base.panel:DockPadding(24, 24, 24, 48)

	base.panel.newsPanel = base.panel:Add("tiger.news")
	base.panel.newsPanel:Dock(FILL)
	base.panel.newsPanel:DockPadding(1, 1, 1, 1)
	base.panel.newsPanel:SetVisible(false)

	base.panel.loadingPanel = base.panel:Add("tiger.panel")
	base.panel.loadingPanel:Dock(FILL)
	base.panel.loadingPanel:SetVisible(false)

	function base.panel.loadingPanel:Paint(width, height)
		if (!self.rotation) then
			self.rotation = 0
		end

		self.rotation = self.rotation + 140 * FrameTime()

		if (self.rotation > 360) then
			self.rotation = 0
		end

		draw.MaterialRotated(width / 2 - 8, height / 2 - 8, 16, 16, color_white, loadingTexture, self.rotation)
	end

	base.panel.divider = base.panel:Add("tiger.divider")
	base.panel.divider:Dock(FILL)

	base.panel.back = base.panel:Add("tiger.button")
	base.panel.back:SetPos(4, 4)
	base.panel.back:SetText("Back")
	base.panel.back:SizeToContents()
	base.panel.back:SetVisible(false)

	function base.panel.back:DoClick()
		category.panel.loadingPanel:SetVisible(false)
		category.panel.newsPanel:SetVisible(false)
		category.panel.divider:SetVisible(true)

		category.panel.refresh:SetVisible(true)
		category.panel.back:SetVisible(false)
	end

	base.panel.refresh = base.panel:Add("tiger.button")
	base.panel.refresh:SetPos(4, 4)
	base.panel.refresh:SetText("Refresh")
	base.panel.refresh:SizeToContents()

	function base.panel.refresh:DoClick()
		base.panel.loadingPanel:SetVisible(true)
		base.panel.newsPanel:SetVisible(false)
		base.panel.divider:SetVisible(false)

		base.panel.refresh:SetVisible(false)
		base.panel.back:SetVisible(false)

		retrieveNews()
	end

	function base.panel:PerformLayout()
		local width, height = self:GetSize()
		
		base.panel.refresh:SetPos(width - (base.panel.refresh:GetWide() + 24), height - (base.panel.refresh:GetTall() + 14))
		base.panel.back:SetPos(width - (base.panel.back:GetWide() + 24), height - (base.panel.back:GetTall() + 14))
	end

	category.panel = base.panel
end

function category:Update(base)
	retrieveNews();
end;

serverguard.menu.AddSubCategory("Information", category)