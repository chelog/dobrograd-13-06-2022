--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local category = {};

category.name = "Sandbox settings";
category.material = "serverguard/menuicons/icon_sandbox.png";
category.permissions = "Sandbox settings";

function category:Create(base)
	base.panel = base:Add("tiger.panel");
	base.panel:SetTitle("Change sandbox variables");
	base.panel:Dock(FILL);
  
	base.panel.list = base.panel:Add("tiger.list");
	base.panel.list:Dock(FILL);
	
	for k, v in ipairs(plugin.convars) do
		local convar = GetConVar(v);

		if (convar) then
			local panel = vgui.Create("tiger.numslider");
			panel:SetText(v);
			panel:SetMinMax(0, 2048);
			panel:SetValue(convar:GetInt());
			panel:Dock(TOP);
			panel.created = true;
			panel.oldThink = panel.Think
			
			function panel:ValueChanged(value)
				if (!self.created) then
					self.nextUpdate = CurTime();
				end;
				
				self.created = nil;
			end;
			
			function panel:Think()
				self:oldThink();
				
				if (self.nextUpdate and self.nextUpdate +0.4 < CurTime()) then
					serverguard.netstream.Start("sgSandboxChangeSetting", {
						k, self:GetValue()
					});
					
					self.nextUpdate = nil;
				end;
			end;
			
			base.panel.list:AddPanel(panel);
		elseif (SG_DEBUG or SG_UI_DEBUG) then
			ErrorNoHalt("The '"..v.."' does not exist!\n"..debug.traceback().."\n");
		end;
	end;
end;

plugin:AddSubCategory("Server settings", category);