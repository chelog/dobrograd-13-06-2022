AddCSLuaFile();

TOOL.Category = "Dobrograd"
TOOL.Name = "Advanced Material"
TOOL.ClientConVar["texture"] = "";
TOOL.ClientConVar["noisetexture"] = "concrete";
TOOL.ClientConVar["scalex"] = "1";
TOOL.ClientConVar["scaley"] = "1";
TOOL.ClientConVar["offsetx"] = "0";
TOOL.ClientConVar["offsety"] = "0";
TOOL.ClientConVar["usenoise"] = "0";
TOOL.ClientConVar["noisescalex"] = "1";
TOOL.ClientConVar["noisescaley"] = "1";
TOOL.ClientConVar["noiseoffsetx"] = "0";
TOOL.ClientConVar["noiseoffsety"] = "0";
TOOL.DetailWhitelist = {
	"concrete",
	"metal",
	"plaster",
	"rock"
};
TOOL.DetailTranslation = {
	concrete = "detail/noise_detail_01",
	rock = "detail/rock_detail_01",
	metal = "detail/metal_detail_01",
	plaster = "detail/plaster_detail_01"
};
TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"}
};

/*
	MATERIALIZE
*/

function TOOL:LeftClick(trace)
	if (!IsValid(trace.Entity)) then return false; end;
	if (trace.Entity:IsPlayer()) then return false; end;
	if (CLIENT) then return true; end;

	local texture = self:GetClientInfo("texture");
	local scalex = tonumber(self:GetClientInfo("scalex"));
	local scaley = tonumber(self:GetClientInfo("scaley"));
	local offsetx = tonumber(self:GetClientInfo("offsetx"));
	local offsety = tonumber(self:GetClientInfo("offsety"));
	local usenoise = tobool(self:GetClientInfo("usenoise"));
	local noisetexture = self.DetailTranslation[self:GetClientInfo("noisetexture")] or "detail/noise_detail_01";
	local noisescalex = tonumber(self:GetClientInfo("noisescalex"));
	local noisescaley = tonumber(self:GetClientInfo("noisescaley"));
	local noiseoffsetx = tonumber(self:GetClientInfo("noiseoffsetx"));
	local noiseoffsety = tonumber(self:GetClientInfo("noiseoffsety"));

	materials:Set(trace.Entity, string.Trim(texture):lower(), {
		ScaleX = scalex,
		ScaleY = scaley,
		OffsetX = offsetx,
		OffsetY = offsety,
		UseNoise = usenoise,
		NoiseTexture = noisetexture,
		NoiseScaleX = noisescalex,
		NoiseScaleY = noisescaley,
		NoiseOffsetX = noiseoffsetx,
		NoiseOffsetY = noiseoffsety
	});

	return true;
end;

function TOOL:RightClick(trace)
	if (trace.Entity:IsPlayer()) then return false; end;
	if (CLIENT) then return true; end;

	local bIsMat = false;

	if (IsValid(trace.Entity)) then
		if (trace.Entity:GetMaterial() != "") then
			if (trace.Entity:GetMaterial():sub(1, 1) != "!") then
				bIsMat = true;
			end;
		end;
	end;

	if (!bIsMat and trace.HitTexture[1] == "*" and !trace.Entity.MaterialData) then
		return false;
	end;

	local tempMat = Material(trace.HitTexture);
	local hitNoise = tempMat:GetString("$detail");
	local noiseTexture = false;

	for k, v in pairs(self.DetailTranslation) do
		if (v == hitNoise) then
			noiseTexture = k;
			break;
		end;
	end;

	local data = trace.Entity.MaterialData or {
		texture = bIsMat and trace.Entity:GetMaterial() or trace.HitTexture,
		scalex = 1,
		scaley = 1,
		offsetx = 0,
		offsety = 0,
		usenoise = noiseTexture and 1 or 0,
		noisetexture = noiseTexture
	};

	for k, v in pairs(data) do
		if (isbool(v)) then continue; end;

		self:GetOwner():ConCommand("advmat_" .. k:lower() .. " " .. v);
	end;

	return true;
end;

function TOOL:Reload(trace)
	if (!IsValid(trace.Entity)) then return false; end;
	if (CLIENT) then return true; end;

	materials:Set(trace.Entity, "", {});

	return true;
end;

// function TOOL:UpdateGhostMat(player, ent)
// 	if (!IsValid(ent)) then return; end;
// 	local trace = player:GetEyeTrace();

// 	if (!IsValid(trace.Entity)) then ent:SetNoDraw(true); return; end;

// 	ent:SetModel(trace.Entity:GetModel());
// 	ent:SetAngles(trace.Entity:GetAngles());

// 	ent:SetPos(trace.Entity:GetPos());
// 	ent:SetNoDraw(false);
// 	ent:SetColor(Color(255, 255, 255, 255));

// 	ent:SetMaterial("!AdvMatPreview");
// end;

local noBump = Material("debug/debugdrawflat"):GetTexture("$bumpmap");
function TOOL:Think()
	if (CLIENT) then
		local texture = self:GetClientInfo("texture");
		local scalex = self:GetClientNumber("scalex", 1);
		local scaley = self:GetClientNumber("scaley", 1);
		local offsetx = self:GetClientNumber("offsetx");
		local offsety = self:GetClientNumber("offsety");

		local bUseNoise = tobool(self:GetClientInfo("usenoise"));
		local noisescalex = self:GetClientNumber("noisescalex", 1);
		local noisescaley = self:GetClientNumber("noisescaley", 1);
		local noiseoffsetx = self:GetClientNumber("noiseoffsetx", 0);
		local noiseoffsety = self:GetClientNumber("noiseoffsety", 0);

		if (texture == "") then
			return;
		end;

		if (!self.PreviewMat or !self.PreviewMatNoise) then
			self.PreviewMat = CreateMaterial("AdvMatPreview", "VertexLitGeneric", {
				["$basetexture"] = texture,
				["$basetexturetransform"] = "center .5 .5 scale " .. (1 / scalex) .. " " .. (1 / scaley) .. " rotate 0 translate " .. offsetx .. " " .. offsety,
				["$vertexcolor"] = 1,
				["$vertexalpha"] = 0
			});

			self.PreviewMatNoise = {
				concrete = CreateMaterial("AdvMatPreviewNoiseConcrete", "VertexLitGeneric", {
					["$basetexture"] = texture,
					["$basetexturetransform"] = "center .5 .5 scale " .. (1 / noisescalex) .. " " .. (1 / noisescaley) .. " rotate 0 translate " .. noiseoffsetx .. " " .. noiseoffsety,
					["$vertexcolor"] = 1,
					["$vertexalpha"] = 0,
					["$detail"] = "detail/noise_detail_01",
					["$detailtexturetransform"] = "center .5 .5 scale 1 1 rotate 0 translate 0 0",
					["$detailblendmode"] = 0,
				}),

				rock = CreateMaterial("AdvMatPreviewNoiseRock", "VertexLitGeneric", {
					["$basetexture"] = texture,
					["$basetexturetransform"] = "center .5 .5 scale " .. (1 / noisescalex) .. " " .. (1 / noisescaley) .. " rotate 0 translate " .. noiseoffsetx .. " " .. noiseoffsety,
					["$vertexcolor"] = 1,
					["$vertexalpha"] = 0,
					["$detail"] = "detail/rock_detail_01",
					["$detailtexturetransform"] = "center .5 .5 scale 1 1 rotate 0 translate 0 0",
					["$detailblendmode"] = 0,
				}),

				metal = CreateMaterial("AdvMatPreviewNoiseMetal", "VertexLitGeneric", {
					["$basetexture"] = texture,
					["$basetexturetransform"] = "center .5 .5 scale " .. (1 / noisescalex) .. " " .. (1 / noisescaley) .. " rotate 0 translate " .. noiseoffsetx .. " " .. noiseoffsety,
					["$vertexcolor"] = 1,
					["$vertexalpha"] = 0,
					["$detail"] = "detail/metal_detail_01",
					["$detailtexturetransform"] = "center .5 .5 scale 1 1 rotate 0 translate 0 0",
					["$detailblendmode"] = 0,
				}),

				plaster = CreateMaterial("AdvMatPreviewNoisePlaster", "VertexLitGeneric", {
					["$basetexture"] = texture,
					["$basetexturetransform"] = "center .5 .5 scale " .. (1 / noisescalex) .. " " .. (1 / noisescaley) .. " rotate 0 translate " .. noiseoffsetx .. " " .. noiseoffsety,
					["$vertexcolor"] = 1,
					["$vertexalpha"] = 0,
					["$detail"] = "detail/plaster_detail_01",
					["$detailtexturetransform"] = "center .5 .5 scale 1 1 rotate 0 translate 0 0",
					["$detailblendmode"] = 0,
				}),

			};
		end;

		if (bUseNoise) then
			local noiseMatrix = Matrix();
			noiseMatrix:Scale(Vector(1 / noisescalex, 1 / noisescaley, 1));
			noiseMatrix:Translate(Vector(noiseoffsetx, noiseoffsety, 0));

			local noiseTexture = self:GetClientInfo("noisetexture");

			if (!table.HasValue(self.DetailWhitelist, noiseTexture:lower())) then
				noiseTexture = "concrete";
			end;

			self.PreviewMatNoise[noiseTexture]:SetMatrix("$detailtexturetransform", noiseMatrix);

			if (self.noise != self:GetClientInfo("noisetexture")) then
				self.noise = noiseTexture;

				self.Preview = self.PreviewMatNoise[noiseTexture]
			end;
		end;

		local mat = bUseNoise and self.Preview or self.PreviewMat;

		local matrix = Matrix();
		matrix:Scale(Vector(1 / scalex, 1 / scaley, 1));
		matrix:Translate(Vector(offsetx, offsety, 0));

		if (mat:GetString("$basetexture") != texture) then
			mat:SetTexture("$basetexture", Material(texture):GetTexture("$basetexture"));
		end;

		mat:SetMatrix("$basetexturetransform", matrix);
	end;
end;

if (CLIENT) then
	function TOOL:DrawHUD()

	end;

	hook.Add("PostDrawOpaqueRenderables", "AdvMatPreview", function()
		local player = LocalPlayer();

		if (!IsValid(player)) then return; end;

		if (IsValid(player:GetActiveWeapon()) and player:GetActiveWeapon():GetClass() == "gmod_tool") then
			local toolObj = player:GetTool();

			if (!toolObj) then return; end;

			if (toolObj.Name != "Advanced Material") then return; end;

			local ent = player:GetEyeTrace().Entity;

			if (IsValid(ent)) then
				local mat = tobool(toolObj:GetClientInfo("usenoise")) and toolObj.Preview or toolObj.PreviewMat;

				render.MaterialOverride(mat);
				ent:DrawModel();
				render.MaterialOverride();
			end;
		end;
	end);
end;

/*
	Holster
	Clear stored objects and reset state
*/

function TOOL:Holster()
	self:ClearObjects();
	self:SetStage(0);
	self:ReleaseGhostEntity();
end;

/*
	Control Panel
*/
do
	local transformData = {
		scalex = 1,
		scaley = 1,
		offsetx = 0,
		offsety = 0
	};

	local ConVarsDefault = TOOL:BuildConVarList()
	function TOOL.BuildCPanel(CPanel)
		CPanel:AddControl("Header", {
			Description = "#tool.advmat.desc"
		});

		CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "advmat", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )
		CPanel:TextEntry("#tool.advmat.texture", "advmat_texture");

		CPanel:NumSlider("#tool.advmat.scalex", "advmat_scalex", 0.01, 5, 2);
		CPanel:NumSlider("#tool.advmat.scaley", "advmat_scaley", 0.01, 5, 2);
		CPanel:NumSlider("#tool.advmat.offsetx", "advmat_offsetx", 0, 5, 2);
		CPanel:NumSlider("#tool.advmat.offsety", "advmat_offsety", 0, 5, 2);

		local baseTextureReset = CPanel:Button("#tool.advmat.reset.base");

		function baseTextureReset:DoClick()
			for k, v in pairs(transformData) do
				LocalPlayer():ConCommand("advmat_" .. k:lower() .. " " .. v);
			end;
		end;

		CPanel:CheckBox("#tool.advmat.usenoise", "advmat_usenoise");
		CPanel:ControlHelp("If this box is checked, your material will be sharpened using an HD detail texture, controlled by the settings below.");

		CPanel:AddControl("ComboBox", {
			Label = "#tool.advmat.noisetexture",
			Options = list.Get("tool.advmat.details")
		});

		CPanel:NumSlider("#tool.advmat.scalex", "advmat_noisescalex", 0.01, 5, 2);
		CPanel:NumSlider("#tool.advmat.scaley", "advmat_noisescaley", 0.01, 5, 2);
		CPanel:NumSlider("#tool.advmat.offsetx", "advmat_noiseoffsetx", 0, 5, 2);
		CPanel:NumSlider("#tool.advmat.offsety", "advmat_noiseoffsety", 0, 5, 2);

		local noiseTextureReset = CPanel:Button("#tool.advmat.reset.noise");

		function noiseTextureReset:DoClick()
			for k, v in pairs(transformData) do
				LocalPlayer():ConCommand("advmat_noise" .. k:lower() .. " " .. v);
			end;
		end;
	end;
end;
/*
	Language strings
*/

if (CLIENT) then
	language.Add("tool.advmat.name", "Advanced Material");
	language.Add("tool.advmat.left", "Set material");
	language.Add("tool.advmat.right", "Copy material");
	language.Add("tool.advmat.reload", "Remove material");
	language.Add("tool.advmat.desc", "Use any material on any prop, with the ability to copy materials from the map.");
	language.Add("tool.advmat.texture", "Material to use");
	language.Add("tool.advmat.scalex", "Width Magnification");
	language.Add("tool.advmat.scaley", "Height Magnification");
	language.Add("tool.advmat.offsetx", "Horizontal Translation");
	language.Add("tool.advmat.offsety", "Vertical Translation");
	language.Add("tool.advmat.usenoise", "Use noise texture");

	language.Add("tool.advmat.noisetexture", "Detail type");

	language.Add("tool.advmat.reset.base", "Reset Texture Transformations");
	language.Add("tool.advmat.reset.noise", "Reset Noise Transformations");

	language.Add("tool.advmat.details.concrete", "Concrete");
	language.Add("tool.advmat.details.metal", "Metal");
	language.Add("tool.advmat.details.plaster", "Plaster");
	language.Add("tool.advmat.details.rock", "Rock");

	list.Set("tool.advmat.details", "#tool.advmat.details.concrete", {advmat_noisetexture = "concrete"});
	list.Set("tool.advmat.details", "#tool.advmat.details.metal", {advmat_noisetexture = "metal"});
	list.Set("tool.advmat.details", "#tool.advmat.details.plaster", {advmat_noisetexture = "plaster"});
	list.Set("tool.advmat.details", "#tool.advmat.details.rock", {advmat_noisetexture = "rock"});
end;