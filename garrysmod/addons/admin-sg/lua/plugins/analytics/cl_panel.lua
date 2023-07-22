--[[
	© 2017 Thriving Ventures Limited do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin.stored = plugin.stored or {};

local months = {
	"January",
	"February",
	"March",
	"April",
	"May",
	"June",
	"July",
	"August",
	"September",
	"October",
	"November",
	"December"
}

local chartHTML = [[
<html>
	<head>
		<style type="text/css">
			#chart {
				position: absolute;
				top: 0;
				left: 0;
			}
		</style>
		<script type="text/javascript" src="https://www.google.com/jsapi"></script>
		<script type="text/javascript">
			var background_color = "rgb(255,255,255)";
			var text_color = "rgb(0,0,0)";

			var months = [
				"",
				"January",
				"February",
				"March",
				"April",
				"May",
				"June",
				"July",
				"August",
				"September",
				"October",
				"November",
				"December"
			];

			var analyticsData = [
				["Month", "Total visits", "Unique visits"],
				["January", 0, 0],
				["February", 0, 0],
				["March", 0, 0],
				["April", 0, 0],
				["May", 0, 0],
				["June", 0, 0],
				["July", 0, 0],
				["August", 0, 0],
				["September", 0, 0],
				["October", 0, 0],
				["November", 0, 0],
				["December", 0, 0]
			];

			// make a copy so we can reset it to default later
			var defaultAnalyticsData = analyticsData.slice(0);

			function clearAnalyticsData()
			{
				analyticsData = defaultAnalyticsData;	
			}

			function setAnalyticsData(month, total, unique)
			{
				if (months.indexOf(month) > -1)
				{
					var index = months.indexOf(month);

					analyticsData[index] = [months[index], total, unique];
				}
			}

			google.load("visualization", "1", {packages:["corechart"]});
			google.setOnLoadCallback(drawChart);

			function drawChart()
			{
				var chartElement = document.getElementById("chart");

				if (chartElement !== null)
				{
					chartElement.style.width = window.innerWidth;
					chartElement.style.height = window.innerHeight;

					var data = google.visualization.arrayToDataTable(analyticsData);
					var options = {
						backgroundColor: background_color,
						chartArea: {
							left: "10%",
							top: "5%",
							width: "75%",
							height: "85%"
						},
						legend: {
							textStyle: {
								color: text_color
							}
						},
						vAxis: {
							minValue: 0,
							textStyle: {
								color: text_color
							},
							gridlines: {
								color: text_color
							}
						},
						hAxis: {
							textStyle: {
								color: text_color
							},
							gridlines: {
								color: text_color
							}
						}
					};

					var chart = new google.visualization.AreaChart(chartElement);
					chart.draw(data, options);
				}
			}
		</script>
	</head>

	<body style="overflow: hidden;">
		<div id="chart"></div>
	</body>
</html>
]];

local category = {};

category.name = "Analytics";
category.material = "serverguard/menuicons/icon_analytics.png";
category.permissions = "Analytics";

function category:Create(base)
	self.stepping = 10;
	
	base.panel = base:Add("tiger.panel");
	base.panel:DockPadding(4, 4, 4, 4);
	base.panel:Dock(FILL);
	
	category.chart = base.panel:Add("DHTML");
	category.chart:SetHTML(chartHTML);
	category.chart:Dock(FILL);

	function category.chart:ClearData() -- sometimes these are called at weird times
		self:RunJavascript("if (typeof clearAnalyticsData === \"function\"){ clearAnalyticsData(); }");
	end;

	function category.chart:SetData(month, total, unique)
		self:RunJavascript("if (typeof setAnalyticsData === \"function\"){ setAnalyticsData('" .. month .. "', " .. total .. ", " .. unique .. "); }");
	end;

	function category.chart:Refresh()
		local theme = serverguard.themes.GetCurrent();

		self:RunJavascript([[
			if (typeof drawChart === "function")
			{
				background_color = "rgb(]] .. util.ColorString(theme.tiger_panel_bg, true) .. [[)";
				text_color = "rgb(]] .. util.ColorString(theme.tiger_panel_label, true) .. [[)";

				drawChart();
			}
		]]);
	end;

	function category.chart:OnTigerThemeChanged()
		self:Refresh();
	end;

	serverguard.themes.AddPanel(category.chart, "tiger_panel_bg");
end;

function category:Update(base)
	if (serverguard.player:HasPermission(LocalPlayer(), "Analytics")) then
		serverguard.netstream.Start("sgRequestAnalytics", true);
	end;
end;

plugin:AddSubCategory("Information", category);

serverguard.netstream.Hook("sgSendAnalytics", function(data)
	if (category and category.chart) then
		category.chart:ClearData();

		for k, v in pairs(data) do
			if (months[k]) then
				category.chart:SetData(months[util.ToNumber(k)], util.ToNumber(v.total or 0), util.ToNumber(v.uniques or 0));
			end;
		end;

		category.chart:Refresh();
	end;
end);