--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local category = {}

category.name = "Manage players"
category.material = "serverguard/menuicons/icon_mange_players.png"
category.permissions = "Manage Players"

function category:Create(base)
	base.panel = base:Add("tiger.panel")
	base.panel:SetTitle("Manage players")
	base.panel:Dock(FILL)
  
	base.panel.list = base.panel:Add("tiger.list")
	base.panel.list:Dock(FILL)
	base.panel.list.sortColumn = 3
	
	local column = base.panel.list:AddColumn("#", 25)
	column:SetDisabled(true)
	
	base.panel.list:AddColumn("PLAYER", 230)
	base.panel.list:AddColumn("RANK", 130)
	base.panel.list:AddColumn("STEAMID", 150)
	base.panel.list:AddColumn("PING", 75)
	
	hook.Call("serverguard.panel.PlayerManageList", nil, base.panel.list)
	
	function base.panel.list:Think()
		local players = player.GetSortedPlayers();
		
		for i = 1, #players do
			local pPlayer = players[i]
			
			if (!IsValid(pPlayer.managePanel)) then
				local rankData = serverguard.ranks:FindByID(
					serverguard.player:GetRank(pPlayer)
				);

				if (!rankData) then
					rankData = serverguard.ranks:GetRank("user");
				end;

				local steamID = pPlayer:SteamID();

				if (pPlayer:IsBot()) then
					steamID = "BOT";
				end;

				local panel = self:AddItem(i, serverguard.player:GetName(pPlayer), rankData.name, steamID, pPlayer:Ping())
				
				panel.player = pPlayer
				
				hook.Call("serverguard.PlayerManage", nil, panel)
				
				function panel:OnMousePressed(code)
					local rankData = serverguard.ranks:GetRank(serverguard.player:GetRank(LocalPlayer()))
					local commands = serverguard.command:GetTable()
					
					local bNoAccess = true
					
					local menu = DermaMenu();
						menu:SetSkin("serverguard");

						menu:AddOption("Copy Steam ID", function()
							if (IsValid(self) and IsValid(self.player)) then
								SetClipboardText(self.player:SteamID());
							end
						end):SetIcon("icon16/page_copy.png");
						
						for unique, data in pairs(commands) do
							if (data.ContextMenu and (!data.permissions or serverguard.player:HasPermission(LocalPlayer(), data.permissions))) then
								data:ContextMenu(self.player, menu, rankData); bNoAccess = false;
							end;
						end;
					menu:Open();
					
					if (bNoAccess) then
						menu:Remove();
					end;
				end
				
				function panel:Think()
					if (!IsValid(self.player)) then
						self:Remove()
						
						base.panel.list:GetCanvas():InvalidateLayout()
		
						timer.Simple(FrameTime() *2, function()
							base.panel.list:OnSort()
						end)
					end
				end
				
				local numberLabel = panel:GetLabel(1)
				
				numberLabel:SetUpdate(function(self)
					local parent = self:GetParent()
					
					if (parent.number and tonumber(self:GetText()) != parent.number) then
						self:SetText(parent.number)
					end
				end)
				
				local nameLabel = panel:GetLabel(2)
				
				nameLabel:SetUpdate(function(self)
					if (IsValid(pPlayer)) then
						if (self:GetText() != serverguard.player:GetName(pPlayer)) then
							self:SetText(serverguard.player:GetName(pPlayer))
						end
					end
				end)
				
				local rankLabel = panel:GetLabel(3)
				rankLabel:SetColor(rankData.color)
				rankLabel:SetSort(rankData.immunity)
				
				rankLabel.rank = rankData.unique
				rankLabel.oldColor = rankData.color

				rankLabel:SetUpdate(function(self)
					if (IsValid(pPlayer)) then
						local rankData = serverguard.ranks:GetRank(serverguard.player:GetRank(pPlayer))
						
						if (self.rank != rankData.unique) then
							self:SetText(rankData.name)
							self:SetColor(rankData.color)
							self:SetSort(rankData.immunity)
							
							self.rank = rankData.unique
							self.oldColor = rankData.color
							
							base.panel.list:OnSort()
						end
					end
				end)
				
				local pingLabel = panel:GetLabel(5)
				
				pingLabel:SetUpdate(function(self)
					if (IsValid(pPlayer)) then
						self:SetText(pPlayer:Ping())
					end
				end)
				
				pPlayer.managePanel = panel
			end
		end
	end
end

function category:Update(base)
end

serverguard.menu.AddCategory(category)