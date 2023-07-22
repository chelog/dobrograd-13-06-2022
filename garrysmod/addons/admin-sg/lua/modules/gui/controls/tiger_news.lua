
local panel = {};

serverguard.themes.CreateDefault("tiger_news_bg", Color(255, 255, 255), "tiger.news");
serverguard.themes.CreateDefault("tiger_news_title", Color(31, 153, 228), "tiger.news");
serverguard.themes.CreateDefault("tiger_news_content", Color(141, 127, 123), "tiger.news");

function panel:Init()
	self.HTML = self:Add("HTML");
	self.HTML:Dock(FILL);

	self.Template = [[
		<!DOCTYPE html>
		<html>
			<head>
				<style type="text/css">
					@import url(http://fonts.googleapis.com/css?family=Roboto:300);

					body {
						font-family: "Roboto", sans-serif;
						font-weight: 300;
						background: rgb({{tiger_news_bg}});
					}

					hr {
						height: 1px;
						border: 0;
						border-top: 1px solid rgb({{tiger_news_title}});
					}

					.title {
						font-size: 24px;
						color: rgb({{tiger_news_title}});
					}

					.date {
						font-size: 18px;
						color: rgb({{tiger_news_content}});
					}

					.content {
						font-size: 14px;
						color: rgb({{tiger_news_content}});
					}
				</style>
			</head>
			
			<body>
				<div class="title">{{title}}</div>
				<div class="date">{{date}}</div>
				<div class="content">{{stub}}</div>
				<hr />
				<div class="content">{{content}}</div>
			</body>
		</html>
	]];

	serverguard.themes.AddPanel(self, "tiger_news_bg");
end;

function panel:PopulateArticle(title, date, stub, content)
	local theme = serverguard.themes.GetCurrent();
	local backgroundColor = util.ColorLimit(theme.tiger_news_bg, 254, 254, 254, 255);
	local titleColor = theme.tiger_news_title;
	local contentColor = theme.tiger_news_content;
	local formatting = self.Template;

	self.Title = title;
	self.Date = date;
	self.Stub = stub;
	self.Content = content;

	-- Colours.
	formatting = string.gsub(
		formatting, "{{tiger_news_bg}}", util.ColorString(backgroundColor, true)
	);

	formatting = string.gsub(
		formatting, "{{tiger_news_title}}", util.ColorString(titleColor, true)
	);

	formatting = string.gsub(
		formatting, "{{tiger_news_content}}", util.ColorString(contentColor, true)
	);

	-- Content.
	formatting = string.gsub(
		formatting, "{{title}}", title
	);

	formatting = string.gsub(
		formatting, "{{date}}", date
	);

	formatting = string.gsub(
		formatting, "{{stub}}", stub
	);

	formatting = string.gsub(
		formatting, "{{content}}", content
	);

	self:SetHTML(formatting);
end;

function panel:RepopulateArticle()
	if (!self:IsPopulated()) then
		return;
	end;

	self:PopulateArticle(self.Title, self.Date, self.Stub, self.Content);
end;

function panel:IsPopulated()
	return (self.Title != nil and self.Date != nil and self.Stub != nil and self.Content != nil);
end;

function panel:SetHTML(html)
	self.HTML:SetHTML(html);
end;

function panel:Clear()
	self.HTML:SetHTML("");

	self.Title = nil;
	self.Date = nil;
	self.Stub = nil;
	self.Content = nil;
end;

function panel:Paint(width, height)
	local theme = serverguard.themes.GetCurrent();
	
	draw.RoundedBox(4, 0, 0, width, height, theme.tiger_divider_outline);
	draw.RoundedBox(2, 1, 1, width - 2, height - 2, theme.tiger_divider_bg);
end;

function panel:OnTigerThemeChanged()
	self:RepopulateArticle();
end;

vgui.Register("tiger.news", panel, "Panel");