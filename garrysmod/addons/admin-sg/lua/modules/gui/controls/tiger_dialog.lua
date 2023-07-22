
surface.CreateFont("tiger.dialog.title", {
	font = "Roboto",
	weight = 100,
	size = ScreenScale(18)
})

surface.CreateFont("tiger.dialog.text", {
	font = "Roboto",
	weight = "100",
	size = ScreenScale(8)
});

local panel = {};

function panel:Init()
	self.buttons = {};
	self.dialogPanel = vgui.Create("tiger.panel", self);
	self.dialogPanel:DockPadding(ScrW() / 4, 4, ScrW() / 4, 4);

	function self.dialogPanel:Paint(width, height)
		surface.SetDrawColor(Color(255, 255, 255, 255));
		surface.DrawRect(0, 0, width, height);
	end;

	self.dialogPanel.titleLabel = self.dialogPanel:Add("DLabel");
	self.dialogPanel.titleLabel:SetFont("tiger.dialog.title");
	self.dialogPanel.titleLabel:SetColor(Color(151, 137, 133));
	self.dialogPanel.titleLabel:Dock(TOP);

	self.dialogPanel.textLabel = self.dialogPanel:Add("DLabel");
	self.dialogPanel.textLabel:SetFont("tiger.dialog.text");
	self.dialogPanel.textLabel:SetColor(Color(131, 107, 103));
	self.dialogPanel.textLabel:Dock(TOP);

	self.dialogPanel.buttonList = self.dialogPanel:Add("tiger.panel");
	self.dialogPanel.buttonList:Dock(TOP);
	self.dialogPanel.buttonList.Paint = function() end;

	self:SetAlpha(0);
end;

function panel:AddButton(text, callback)
	local realText = text;
	local button = self.dialogPanel.buttonList:Add("tiger.button");

	if (string.sub(text, 1, 1) == "&") then
		realText = string.sub(text, 2, string.len(text));
		button:SetBold(true);
	end;

	button:SetText(realText);
	button:SizeToContents();
	button:DockMargin(0, 0, 4, 0);
	button:Dock(RIGHT);
	button.DoClick = callback;

	table.insert(self.buttons, button);
end;

function panel:SetTitle(text)
	self.dialogPanel.titleLabel:SetText(text);
end;

function panel:SetText(text)
	self.dialogPanel.textLabel:SetText(text);
end;

function panel:Paint(width, height)
	surface.SetDrawColor(Color(0, 0, 0, self:GetAlpha()));
	surface.DrawRect(0, 0, width, height);
end;

function panel:SizeToContents()
	local buttonHeight = 0;

	for k, v in pairs(self.buttons) do
		if (v:GetTall() > buttonHeight) then
			buttonHeight = v:GetTall();
		end;
	end;

	self.dialogPanel.titleLabel:SizeToContents();
	self.dialogPanel.textLabel:SizeToContents();

	self:SetSize(ScrW(), ScrH());
	self.dialogPanel:SetSize(ScrW(), self.dialogPanel.titleLabel:GetTall() + self.dialogPanel.textLabel:GetTall() + buttonHeight + 16);
end;

function panel:Center()
	self:SetPos(0, 0);
	self.dialogPanel:Center();
end;

function panel:FadeIn(alpha, duration)
	self:AlphaTo(alpha or 250, duration or 0.5, 0, function() end);

	if (!self.dialogPanel.realHeight) then
		self.dialogPanel.realHeight = self.dialogPanel:GetTall();
	end;

	self.dialogPanel:SetTall(0);
	self.dialogPanel:SizeTo(self.dialogPanel:GetWide(), self.dialogPanel.realHeight, duration or 0.5, 0, 2, function() end);
end;

function panel:FadeOut(duration, callback)
	if (!callback) then
		callback = function() end;
	end;

	self:AlphaTo(0, duration or 0.5, 0, function() end);

	self.dialogPanel:SetTall(self.dialogPanel.realHeight);
	self.dialogPanel:SizeTo(self.dialogPanel:GetWide(), 0, duration or 0.5, 0, 2, callback);
end;

function panel:Close()
	self:FadeOut();
	self:SetMouseInputEnabled(false);
	self:SetKeyBoardInputEnabled(false);
end;

vgui.Register("tiger.dialog", panel, "DPanel");