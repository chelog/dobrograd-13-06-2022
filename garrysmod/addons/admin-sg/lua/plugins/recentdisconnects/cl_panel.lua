--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local category = {};

category.name = "Recent disconnects";
category.material = "serverguard/menuicons/icon_disconnects.png";
category.permissions = "View Disconnects";

function category:Create(base)
	base.panel = base:Add("tiger.panel")
	base.panel:SetTitle("View recently disconnected players")
	base.panel:Dock(FILL)
	base.panel:DockPadding(24, 24, 24, 48)
	
	base.panel.list = base.panel:Add("tiger.list")
	base.panel.list:Dock(FILL)
	base.panel.list.sortColumn = 3
	
	base.panel.list:AddColumn("PLAYER", 250)
	base.panel.list:AddColumn("STEAMID", 250)
	base.panel.list:AddColumn("RANK", 75)
	
	local refresh = base.panel:Add("tiger.button")
	refresh:SetPos(4, 4)
	refresh:SetText("Refresh")
	refresh:SizeToContents()
	
	function refresh:DoClick()
		base.panel.list:Clear()
		
		serverguard.netstream.Start("sgRequestDisconnects", true);
	end
	
	function base.panel.list:Think()
		if (self.nextUpdate and self.nextUpdate <= CurTime()) then
			refresh:DoClick()
			
			self.nextUpdate = nil
		end
	end
	
	function base.panel:PerformLayout()
		local w, h = self:GetSize()
		
		refresh:SetPos(w -(refresh:GetWide() +24), h -(refresh:GetTall() +14))
	end
	
	category.list = base.panel.list
end;

function category:ClearDisconnects()
	self.list:Clear();
	self.list.list:PerformLayout();
end

function category:Update(base)
	self:ClearDisconnects();
	
	serverguard.netstream.Start("sgRequestDisconnects", true);
end;

function category:UpdateDisconnects(data)
	local steamid = data[1];
	local rank = data[2];
	local name = data[3];

	if (rank and rank == "user") then return; end;

	local rankData = serverguard.ranks:GetRank(rank);
	
	local rankName = "";
	
	if (!rankData) then
		rankName = "Unknown rank (REMOVED)";
	else
		rankName = rankData.name;
	end;
	
	local panel = category.list:AddItem(name, steamid, rankName);
	panel.steamid = steamid;
	
	function panel:OnMousePressed()
		if !serverguard.player:HasPermission(LocalPlayer(), "Ban") and serverguard.player:GetBanLimit(admin) != 0 then return end;
		local menu = DermaMenu();
			menu:SetSkin("serverguard");
			
			local banMenu, menuOption = menu:AddSubMenu("Ban");
			
			banMenu:SetSkin("serverguard");
			menuOption:SetImage("icon16/delete.png");
			
			for k, v in pairs(serverguard.banLengths) do
				local option = banMenu:AddOption(v[1], function()
					Derma_StringRequest("Ban Reason", "Specify ban reason.", "", function(text)
						serverguard.command.Run("ban", false, steamid, v[2], text);
					end, function(text) end, "Accept", "Cancel");
				end);
				
				option:SetImage("icon16/clock.png");
			end;
				
		menu:Open();
	end;
	
	if (rankData) then
		local rankLabel = panel:GetLabel(3);
			rankLabel:SetColor(rankData.color);
			rankLabel:SetSort(rankData.immunity);
		rankLabel.oldColor = rankData.color;
	end;
end;

plugin:AddSubCategory("Intelligence", category);

serverguard.netstream.Hook("sgGetDisconnects", function(data)
	category:UpdateDisconnects(data);
end);