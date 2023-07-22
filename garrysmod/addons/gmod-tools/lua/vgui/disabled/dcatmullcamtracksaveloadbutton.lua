-- Based off of the Duplicator GUI

local PANEL = {}

function PANEL:Init()
	self.SelectButton = vgui.Create("DButton", self)
	
	self.DeleteButton = vgui.Create("DImageButton", self)
	self.DeleteButton:SetMaterial("gui/silkicons/camera_delete")
	self.DeleteButton:SetTooltip("Delete this track from your HDD.")
	--[[
	self.EditButton = vgui.Create("DImageButton", self)
	self.EditButton:SetMaterial("gui/silkicons/camera_edit")
	self.EditButton:SetTooltip("Edit this track's additional information.")
	--]]
end

function PANEL:SetFile(filename)
	self.File = filename
	
	self.SelectButton:SetText(string.Explode(".", self.File)[1])
end

function PANEL:Nothing()
end

function PANEL:Delete()
	file.Delete(CatmullRomCams.FilePath .. self.File)
	
	return self:GetParent():Populate()
end

function PANEL:SetID(id)
	function self.DeleteButton.DoClick()
		return Derma_Query("Are you sure you wish to delete this track?", "Confirm Command: Delete File",
						   "Confirm Deletion", function() return self:Delete() end,
						   "Cancel", self.Nothing)
	end
	
	function self.SelectButton.DoClick()
		return RunConsoleCommand("catmullrom_camera_save_load_file", self.File)
	end
end

function PANEL:PerformLayout()
	self.DeleteButton.y = 3
	self.DeleteButton:SizeToContents()
	self.DeleteButton:AlignRight(3)
	
	self.EditButton.y = 3
	self.EditButton:SizeToContents()
	self.EditButton:AlignRight(self.DeleteButton:GetWide() + 5)
	
	self:SetTall(self.DeleteButton:GetTall() + 6)
	
	self.SelectButton:StretchToParent(3, 3, 3, 3)
	self.SelectButton:StretchRightTo(self.EditButton, 3)
end

function PANEL:Paint()
	draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(0, 0, 0, 150))
	return false
end

derma.DefineControl("DCatmullCamTrackSaveLoadButton", "Its time to kick ass and chew bubble-gum, and I'm all outa' gum...", PANEL, "DPanel")
