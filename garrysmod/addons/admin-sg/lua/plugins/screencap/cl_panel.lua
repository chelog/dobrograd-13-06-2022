--[[
	� 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local category = {};

category.name = "Screen capture";
category.material = "serverguard/menuicons/icon_camera.png";
category.permissions = "Screencap";

local pending = {}
netstream.Hook('sg.octolib-grab', function(ply, r)
	local act = pending[ply]
	if not act then return end

	act(r)
end)

function category:Create(base)
	base.panel = base:Add("tiger.panel");
	base.panel:SetTitle("Screen capture");
	base.panel:Dock(FILL);
  
	base.panel.list = base.panel:Add("tiger.list");
	base.panel.list:Dock(FILL);

	base.panel.list:AddColumn("PLAYER", 320);
	base.panel.list:AddColumn("STEAMID", 200);
	base.panel.list:AddColumn("VIEW & CAPTURE", 100):SetDisabled(true);
	
	function base.panel.list:Think()
		local players = player.GetHumans();
		
		for i = 1, #players do
			local pPlayer = players[i];
			
			if (!IsValid(pPlayer.screenPanel)) then
				local panel = base.panel.list:AddItem(serverguard.player:GetName(pPlayer), pPlayer:SteamID());
				
				panel.player = pPlayer;
				panel.unique = pPlayer:UniqueID();
				
				function panel:OnMousePressed(code)
				end;
				
				function panel:Think()
					if (!IsValid(self.player)) then
						self:Remove();
						
						base.panel.list:GetCanvas():InvalidateLayout();
		
						timer.Simple(FrameTime() *2, function()
							base.panel.list:OnSort();
						end);
					end;
				end;
				
				local nameLabel = panel:GetLabel(1);
				
				nameLabel:SetUpdate(function(self)
					if (IsValid(pPlayer)) then
						if (self:GetText() != serverguard.player:GetName(pPlayer)) then
							self:SetText(serverguard.player:GetName(pPlayer));
						end;
					end;
				end);
				
				local lastBase = vgui.Create("Panel");
				lastBase.rotate = 0;
				lastBase.progress = 0;
				lastBase.SizeToColumn = true;
				
				lastBase.capture = lastBase:Add("DImageButton");
				lastBase.capture:SetSize(16, 16);
				lastBase.capture:SetImage("icon16/film_add.png");
				lastBase.capture:SetToolTipSG("Capture Screen");
				local immAdmin, immTarget = serverguard.player:GetImmunity(LocalPlayer()), serverguard.player:GetImmunity(pPlayer)
				lastBase.capture:SetVisible(immAdmin >= immTarget)
				
				lastBase.view = lastBase:Add("DImageButton");
				lastBase.view:SetSize(16, 16);
				lastBase.view:SetImage("icon16/film_go.png");
				lastBase.view:SetToolTipSG("View Image");
				lastBase.view:SetVisible(false);
				
				function lastBase.view:DoClick()										
					octoesc.OpenURL(self.link)
				end;
				
				function lastBase.capture:DoClick()
					lastBase.ready = false
					lastBase.capture:SetVisible(false)
					lastBase.view:SetVisible(false)

					timer.Create('screenCapTimeout' .. tostring(panel.player), 30, 1, function()
						if not IsValid(lastBase) then return end
						lastBase.capture:SetVisible(true)
					end)
					
					pending[panel.player] = function(r)
						if not IsValid(lastBase) or not IsValid(lastBase.view) then return end
						if r then
							lastBase.view.link = 'https://imgur.com/' .. r.data.id
						end
						lastBase.view:SetVisible(true)
						lastBase.capture:SetVisible(true)
					end
					netstream.Start('sg.octolib-grab', panel.player)
				end;
				
				function lastBase:Paint(w, h) end
				function lastBase:PerformLayout()
					local w, h = self:GetSize();
					
					if (self.view:IsVisible()) then
						self.capture:SetPos(w / 2 + 12, h / 2 - 8);
						self.view:SetPos(w /2 - 12,  h / 2 - 8);
					else
						self.capture:SetPos(w /2 -8, h /2 -8);
					end;
					
					local column = panel:GetThing(3).column;
					local x = column:GetPos();
					
					self:SetPos(x, 0);
				end;
				
				panel:AddItem(lastBase);
				
				timer.Simple(FrameTime() *2, function()
					local column = panel:GetThing(3).column;
				
					lastBase:SetSize(column:GetWide() -1, 30);
					lastBase:InvalidateLayout();
				end);
				
				pPlayer.screenPanel = panel;
			end;
		end;
	end;
end;

plugin:AddSubCategory("Intelligence", category);