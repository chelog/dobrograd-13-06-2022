--
-- I'm sorry, guys, but I really need this
-- will redo at some point later
--

local next = next
local pairs = pairs
local unpack = unpack
local pcall = pcall

local temp = {}

local functions = {}
function temp.TimedpairsGetTable()
	return functions
end

function temp.TimedpairsStop(name)
	functions[name] = nil
end

local function copy( t ) -- custom table copy function to convert to numerically indexed table
	local ret = {}
	for k,v in pairs( t ) do
		ret[#ret+1] = { key = k, value = v }
	end
	return ret
end

local function Timedpairs()
	if not next(functions) then return end

	local toremove = {}

	for name, data in pairs( functions ) do
		for i=1,data.step do
			data.currentindex = data.currentindex + 1 -- increment index counter
			local lookup = data.lookup or {}
			if data.currentindex <= #lookup then -- If there are any more values..
				local kv = lookup[data.currentindex] or {} -- Get the current key and value
				local ok, err = xpcall( data.callback, debug.traceback, kv.key, kv.value, unpack(data.args) ) -- DO EET

				if not ok then -- oh noes
					temp.ErrorNoHalt( "Error in Timedpairs '" .. name .. "': " .. err )
					toremove[#toremove+1] = name
					break
				elseif err == false then -- They returned false inside the function
					toremove[#toremove+1] = name
					break
				end
			else -- Out of keys. Entire table looped
				if data.endcallback then -- If we had any end callback function
					local kv = lookup[data.currentindex-1] or {} -- get previous key & value
					local ok, err = xpcall( data.endcallback, debug.traceback, kv.key, kv.value, unpack(data.args) )

					if not ok then
						temp.ErrorNoHalt( "Error in Timedpairs '" .. name .. "' (in end function): " .. err )
					end
				end
				toremove[#toremove+1] = name
				break
			end
		end
	end

	for i=1,#toremove do -- Remove all that were flagged for removal
		functions[toremove[i]] = nil
	end
end
if (CLIENT) then
	hook.Add("PostRenderVGUI", "temp_Timedpairs", Timedpairs) // Doesn't get paused in single player. Can be important for vguis.
else
	hook.Add("Think", "temp_Timedpairs", Timedpairs) // Servers still uses Think.
end

function temp.Timedpairs(name,tab,step,callback,endcallback,...)
	functions[name] = { lookup = copy(tab), step = step, currentindex = 0, callback = callback, endcallback = endcallback, args = {...} }
end

function temp.Timedcall(callback,...) // calls the given function like simple timer, but isn't affected by game pausing.
	local dummytab = {true}
	temp.Timedpairs("Timedcall_"..tostring(dummytab),dummytab,1,function(k, v, ...) callback(...) end,nil,...)
end

local PANEL = {}

local invalid_filename_chars = {
	["*"] = "",
	["?"] = "",
	[">"] = "",
	["<"] = "",
	["|"] = "",
	["\\"] = "",
	['"'] = "",
	[" "] = "_",
}

local function GetFileName(name)
	local name = string.Replace(name, ".txt", "")
	return string.Replace(name, "/", "")
end

local function InternalDoClick(self)
	self:GetRoot():SetSelectedItem(self)
	if (self:DoClick()) then return end
	if (self:GetRoot():DoClick(self)) then return end
end

local function InternalDoRightClick(self)
	self:GetRoot():SetSelectedItem(self)
	if (self:DoRightClick()) then return end
	if (self:GetRoot():DoRightClick(self)) then return end
end

local function fileName(filepath)
	return string.match(filepath, "[/\\]?([^/\\]*)$")
end

local string_find = string.find
local string_lower = string.lower
function PANEL:Search( str, foldername, fullpath, parentfullpath, first_recursion )
	if not self.SearchFolders[fullpath] then
		self.SearchFolders[fullpath] = (self.SearchFolders[parentfullpath] or self.Folders):AddNode( foldername )

		local files, folders = file.Find( fullpath .. "/*", "DATA" )

		local node = self.SearchFolders[fullpath]
		if fullpath == self.startfolder then self.Root = node end -- get root
		node.Icon:SetImage( "icon16/arrow_refresh.png" )
		node:SetExpanded( true )

		local myresults = 0
		for i=1,#files do
			if string_find( string_lower( files[i] ), str, 1, true ) ~= nil then
				local filenode = node:AddNode( files[i], "icon16/page_white.png" )
				filenode:SetFileName( fullpath .. "/" .. files[i] )
				myresults = myresults + 1
			end

			coroutine.yield()
		end

		if #folders == 0 then
			if myresults == 0 then
				if node ~= self.Root then node:Remove() end
				if first_recursion then
					coroutine.yield( false, myresults )
				else
					return false, myresults
				end
			end

			node.Icon:SetImage( "icon16/folder.png" )
			if first_recursion then
				coroutine.yield( true, myresults )
			else
				return true, myresults
			end
		else
			for i=1,#folders do
				local b, res = self:Search( str, folders[i], fullpath .. "/" .. folders[i], fullpath )
				if b then
					myresults = myresults + res
				end

				coroutine.yield()
			end


			if myresults > 0 then
				node.Icon:SetImage( "icon16/folder.png" )
				if first_recursion then
					coroutine.yield( true, myresults )
				else
					return true, myresults
				end
			else
				if node ~= self.Root then node:Remove() end
				if first_recursion then
					coroutine.yield( false, myresults )
				else
					return false, myresults
				end
			end
		end
	end

	if first_recursion then
		coroutine.yield( false, 0 )
	else
		return false, 0
	end
end

function PANEL:CheckSearchResults( status, bool, count )
	if bool ~= nil and count ~= nil then -- we're done searching
		if count == 0 then
			local node = self.Root:AddNode( "No results" )
			node.Icon:SetImage( "icon16/exclamation.png" )
			self.Root.Icon:SetImage( "icon16/folder.png" )
		end
		timer.Remove( "wire_expression2_search" )
		return true
	elseif not status then -- something went wrong, abort
		timer.Remove( "wire_expression2_search" )
		return true
	end
end

function PANEL:StartSearch( str )
	self:UpdateFolders( true )

	self.SearchFolders = {}

	local crt = coroutine.create( self.Search )
	local status, bool, count = coroutine.resume( crt, self, str, self.startfolder, self.startfolder, "", true )
	self:CheckSearchResults( status, bool, count )

	timer.Create( "wire_expression2_search", 0, 0, function()
		for i=1,100 do -- Load loads of files/folders at a time
			local status, bool, count = coroutine.resume( crt )

			if self:CheckSearchResults( status, bool, count ) then
				return -- exit loop etc
			end
		end
	end )
end

function PANEL:Init()
	self:SetDrawBackground(false)

	self.SearchBox = vgui.Create( "DTextEntry", self )
	self.SearchBox:Dock( TOP )
	self.SearchBox:DockMargin( 0,0,0,0 )
	self.SearchBox:SetValue( "Search..." )

	local clearsearch = vgui.Create( "DImageButton", self.SearchBox )
	clearsearch:SetMaterial( "icon16/cross.png" )
	local src = self.SearchBox
	function clearsearch:DoClick()
		src:SetValue( "" )
		src:OnEnter()
		src:SetValue( "Search..." )
	end
	clearsearch:DockMargin( 2,2,4,2 )
	clearsearch:Dock( RIGHT )
	clearsearch:SetSize( 14, 10 )
	clearsearch:SetVisible( false )


	local old = self.SearchBox.OnGetFocus
	function self.SearchBox:OnGetFocus()
		if self:GetValue() == "Search..." then -- If "Search...", erase it
			self:SetValue( "" )
		end
		old( self )
	end

	-- On lose focus
	local old = self.SearchBox.OnLoseFocus
	function self.SearchBox:OnLoseFocus()
		if self:GetValue() == "" then -- if empty, reset "Search..." text
			timer.Simple( 0, function() self:SetValue( "Search..." ) end )
		end
		old( self )
	end

	function self.SearchBox.OnEnter()
		local str = self.SearchBox:GetValue()

		if str ~= "" then
			self:StartSearch( string.Replace( string.lower( str ), " ", "_" ) )

			clearsearch:SetVisible( true )
		else
			timer.Remove( "wire_expression2_search" )
			self:UpdateFolders()
			clearsearch:SetVisible( false )
		end
	end

	self.Update = vgui.Create("DButton", self)
	self.Update:SetTall(20)
	self.Update:Dock(BOTTOM)
	self.Update:DockMargin(0, 0, 0, 0)
	self.Update:SetText("Update")
	self.Update.DoClick = function(button)
		self:UpdateFolders()
	end

	self.Folders = vgui.Create("DTree", self)
	self.Folders:Dock(FILL)
	self.Folders:DockMargin(0, 0, 0, 0)

	self.panelmenu = {}
	self.filemenu = {}
	self.foldermenu = {}
	self.lastClick = CurTime()

	self:AddRightClick(self.filemenu, nil, "Open", function()
		self:OnFileOpen(self.File:GetFileName(), false)
	end)
	self:AddRightClick(self.filemenu, nil, "Open in New Tab", function()
		self:OnFileOpen(self.File:GetFileName(), true)
	end)
	self:AddRightClick(self.filemenu, nil, "*SPACER*")
	self:AddRightClick(self.filemenu, nil, "Rename to..", function()
		local fname = string.StripExtension(fileName(self.File:GetFileName()))
		Derma_StringRequestNoBlur("Rename File \"" .. fname .. "\"", "Rename file " .. fname, fname,
			function(strTextOut)
			-- Renaming starts in the garrysmod folder now, in comparison to other commands that start in the data folder.
				strTextOut = string.gsub(strTextOut, ".", invalid_filename_chars) .. ".txt"
				local newFileName = string.GetPathFromFilename(self.File:GetFileName()) .. "/" .. strTextOut
				if file.Exists(newFileName, "DATA") then
					WireLib.AddNotify("File already exists (" .. strTextOut .. ")", NOTIFY_ERROR, 7, NOTIFYSOUND_ERROR1)
				elseif not file.Rename(self.File:GetFileName(), newFileName) then
					WireLib.AddNotify("Rename was not successful", NOTIFY_ERROR, 7, NOTIFYSOUND_ERROR1)
				end
				self:UpdateFolders()
			end)
	end)
	self:AddRightClick(self.filemenu, nil, "Copy to..", function()
		local fname = string.StripExtension(fileName(self.File:GetFileName()))
		Derma_StringRequestNoBlur("Copy File \"" .. fname .. "\"", "Copy File to...", fname,
			function(strTextOut)
				strTextOut = string.gsub(strTextOut, ".", invalid_filename_chars)
				file.Write(string.GetPathFromFilename(self.File:GetFileName()) .. "/" .. strTextOut .. ".txt", file.Read(self.File:GetFileName()))
				self:UpdateFolders()
			end)
	end)
	self:AddRightClick(self.filemenu, nil, "*SPACER*")
	self:AddRightClick(self.filemenu, nil, "New File", function()
		Derma_StringRequestNoBlur("New File in \"" .. string.GetPathFromFilename(self.File:GetFileName()) .. "\"", "Create new file", "",
			function(strTextOut)
				strTextOut = string.gsub(strTextOut, ".", invalid_filename_chars)
				file.Write(string.GetPathFromFilename(self.File:GetFileName()) .. "/" .. strTextOut .. ".txt", "")
				self:UpdateFolders()
			end)
	end)
	self:AddRightClick(self.filemenu, nil, "Delete", function()
		Derma_Query("Delete this file?", "Delete",
			"Delete", function()
				if (file.Exists(self.File:GetFileName(), "DATA")) then
					file.Delete(self.File:GetFileName())
					self:UpdateFolders()
				end
			end,
			"Cancel")
	end)

	self:AddRightClick(self.foldermenu, nil, "New File..", function()
		Derma_StringRequestNoBlur("New File in \"" .. self.File:GetFolder() .. "\"", "Create new file", "",
			function(strTextOut)
				strTextOut = string.gsub(strTextOut, ".", invalid_filename_chars)
				file.Write(self.File:GetFolder() .. "/" .. strTextOut .. ".txt", "")
				self:UpdateFolders()
			end)
	end)
	self:AddRightClick(self.foldermenu, nil, "New Folder..", function()
		Derma_StringRequestNoBlur("new folder in \"" .. self.File:GetFolder() .. "\"", "Create new folder", "",
			function(strTextOut)
				strTextOut = string.gsub(strTextOut, ".", invalid_filename_chars)
				file.CreateDir(self.File:GetFolder() .. "/" .. strTextOut)
				self:UpdateFolders()
			end)
	end)
	self:AddRightClick(self.panelmenu, nil, "New File..", function()
		Derma_StringRequestNoBlur("New File in \"" .. self.File:GetFolder() .. "\"", "Create new file", "",
			function(strTextOut)
				strTextOut = string.gsub(strTextOut, ".", invalid_filename_chars)
				file.Write(self.File:GetFolder() .. "/" .. strTextOut .. ".txt", "")
				self:UpdateFolders()
			end)
	end)
	self:AddRightClick(self.panelmenu, nil, "New Folder..", function()
		Derma_StringRequestNoBlur("new folder in \"" .. self.File:GetFolder() .. "\"", "Create new folder", "",
			function(strTextOut)
				strTextOut = string.gsub(strTextOut, ".", invalid_filename_chars)
				file.CreateDir(self.File:GetFolder() .. "/" .. strTextOut)
				self:UpdateFolders()
			end)
	end)
end

function PANEL:OnFileOpen(filepath, newtab)
	error("Please override wire_expression2_browser:OnFileOpen(filepath, newtab)", 0)
end

function PANEL:UpdateFolders( empty )
	self.Folders:Clear(true)
	if IsValid(self.Root) then
		self.Root:Remove()
	end

	if not empty then
		self.Root = self.Folders.RootNode:AddFolder(self.startfolder, self.startfolder, "DATA", true)
		self.Root:SetExpanded(true)
	end

	self.Folders.DoClick = function(tree, node)
		if self.File == node and CurTime() <= self.lastClick + 0.5 then
			self:OnFileOpen(node:GetFileName())
		elseif self.OpenOnSingleClick then
			self.OpenOnSingleClick:LoadFile(node:GetFileName())
		end
		self.File = node
		self.lastClick = CurTime()
		return true
	end
	self.Folders.DoRightClick = function(tree, node)
		self.File = node
		if node:GetFileName() then
			self:OpenMenu(self.filemenu)
		else
			self:OpenMenu(self.foldermenu)
		end
		return true
	end

	self:OnFolderUpdate(self.startfolder)
end

function PANEL:GetFileName()
	if not IsValid(self.File) then return end

	return self.File:GetFileName()
end

function PANEL:GetFileNode()
	return self.File
end

function PANEL:OpenMenu(menu)
	if not menu or not IsValid(self.Folders) then return end
	if #menu < 1 then return end

	self.Menu = vgui.Create("DMenu", self.Folders)
	for k, v in pairs(menu) do
		local name, option = v[1], v[2]
		if (name == "*SPACER*") then
			self.Menu:AddSpacer()
		else
			self.Menu:AddOption(name, option)
		end
	end
	self.Menu:Open()
end

function PANEL:AddRightClick(menu, pos, name, option)
	if not menu then menu = {} end
	if not pos then pos = #menu + 1 end

	if menu[pos] then
		table.insert(menu, pos, { name, option })
		return
	end

	menu[pos] = { name, option }
end

function PANEL:RemoveRightClick(name)
	for k, v in pairs(self.filemenu) do
		if (v[1] == name) then
			self.filemenu[k] = nil
			break
		end
	end
end


function PANEL:Setup(folder)
	self.startfolder = folder
	self:UpdateFolders()
end

function PANEL:OnFolderUpdate(folder)
	-- override
end

PANEL.Refresh = PANEL.UpdateFolders -- self:Refresh() is common

vgui.Register("wire_expression2_browser", PANEL, "DPanel")

local PANEL = {}

AccessorFunc( PANEL, "m_strRootName", 			"RootName" ) // name of the root Root
AccessorFunc( PANEL, "m_strRootPath", 			"RootPath" ) // path of the root Root
AccessorFunc( PANEL, "m_strWildCard", 			"WildCard" ) // "GAME", "DATA" etc.
AccessorFunc( PANEL, "m_tFilter", 				"FileTyps" ) // "*.wav", "*.mdl", {"*.vmt", "*.vtf"} etc.

AccessorFunc( PANEL, "m_strOpenPath", 			"OpenPath" ) // open path
AccessorFunc( PANEL, "m_strOpenFile", 			"OpenFile" ) // open path+file
AccessorFunc( PANEL, "m_strOpenFilename", 		"OpenFilename" ) // open file

AccessorFunc( PANEL, "m_nListSpeed", 			"ListSpeed" ) // how many items to list an once
AccessorFunc( PANEL, "m_nMaxItemsPerPage",		"MaxItemsPerPage" ) // how may items per page
AccessorFunc( PANEL, "m_nPage", 				"Page" ) // Page to show

local invalid_chars = {
	["\n"] = "",
	["\r"] = "",
	["\\"] = "/",
	["//"] = "/",
	//["/.svn"] = "", // Disallow access to .svn folders. (Not needed.)
	//["/.git"] = "", // Disallow access to .git folders. (Not needed.)
}

local function ConnectPathes(path1, path2)
	local path = ""

	if (isstring(path1) and path1 ~= "") then
		path = path1
		if (isstring(path2) and path2 ~= "") then
			path = path1.."/"..path2
		end
	else
		if (isstring(path2) and path2 ~= "") then
			path = path2
		end
	end

	return path
end

local function PathFilter(Folder, TxtPanel, Root)
	if (!isstring(Folder) or Folder == "") then return end

	local ValidFolder = Folder

	//local ValidFolder = string.lower(Folder) // for .svn and .git filters.
	for k, v in pairs(invalid_chars) do
		for i = 1, #string.Explode(k, ValidFolder) do
			if (!string.match(ValidFolder, k)) then break end

			ValidFolder = string.gsub(ValidFolder, k, v)
		end
	end

	ValidFolder = string.Trim(ValidFolder)
	/*if (string.sub(ValidFolder, 0, 4) == ".svn") then // Disallow access to .svn folders. (Not needed.)
		ValidFolder = string.sub(ValidFolder, -4)
		if (ValidFolder == ".svn") then
			ValidFolder = ""
		end
	end*/

	/*if (string.sub(ValidFolder, 0, 4) == ".git") then // Disallow access to .git folders. (Not needed.)
		ValidFolder = string.sub(ValidFolder, -4)
		if (ValidFolder == ".git") then
			ValidFolder = ""
		end
	end*/

	ValidFolder = string.Trim(ValidFolder, "/")

	if (IsValid(TxtPanel)) then
		TxtPanel:SetText(ValidFolder)
	end

	local Dirs = #string.Explode("/", ValidFolder)
	for i = 1, Dirs do
		if (!file.IsDir(ConnectPathes(Root, ValidFolder), "GAME")) then
			ValidFolder = string.GetPathFromFilename(ValidFolder)
			ValidFolder = string.Trim(ValidFolder, "/")
		end
	end

	ValidFolder = string.Trim(ValidFolder, "/")

	if (ValidFolder == "") then return end
	return ValidFolder
end

local function EnableButton(button, bool)
	button:SetEnabled(bool)
	button:SetMouseInputEnabled(bool)
end

local function BuildFileList(path, filter, wildcard)
	local files = {}

	if (istable(filter)) then
		for k, v in ipairs(filter) do
			table.Add(files, file.Find(ConnectPathes(path, v), wildcard or "GAME"))
		end
	else
		table.Add(files, file.Find(ConnectPathes(path, tostring(filter)), wildcard or "GAME"))
	end

	table.sort(files)

	return files
end

local function NavigateToFolder(self, path)
	if (!IsValid(self)) then return end

	path = ConnectPathes(self.m_strRootPath, path)

	local root = self.Tree:Root()
	if (!IsValid(root)) then return end
	if (!IsValid(root.ChildNodes)) then return end

	local nodes = root.ChildNodes:GetChildren()
	local lastnode = nil

	local nodename = ""

	self.NotUserPressed = true
	local dirs = string.Explode("/", path)
	for k, v in ipairs(dirs) do
		if (nodename == "") then
			nodename = string.lower(v)
		else
			nodename = nodename .. "/" .. string.lower(v)
			if (!IsValid(lastnode)) then continue end
			if (!IsValid(lastnode.ChildNodes)) then continue end

			nodes = lastnode.ChildNodes:GetChildren()
		end

		local found = false
		for _, node in pairs(nodes) do
			if (!IsValid(node)) then continue end

			local path = string.lower(node.m_strFolder)
			if ( nodename == "" ) then break end

			if ( path ~= nodename or found) then
				node:SetExpanded(false)
				continue
			end

			if (k == #dirs) then // just select the last one
				self.Tree:SetSelectedItem(node)
			end

			node:SetExpanded(true)
			lastnode = node
			found = true
		end
	end

	self.NotUserPressed = false
end

local function ShowFolder(self, path)
	if (!IsValid(self)) then return end

	self.m_strOpenPath = path
	path = ConnectPathes(self.m_strRootPath, path)
	self.oldpage = nil

	self.Files = BuildFileList(path, self.m_tFilter, self.m_strWildCard)

	self.m_nPage = 0
	self.m_nPageCount = math.ceil(#self.Files / self.m_nMaxItemsPerPage)

	self.PageMode = self.m_nPageCount > 1
	self.PageChoosePanel:SetVisible(self.PageMode)

	if (self.m_nPageCount <= 0 or !self.PageMode) then
		self.m_nPageCount = 1
		self:SetPage(1)
		return
	end

	self.PageChooseNumbers:Clear(true)
	self.PageChooseNumbers.Buttons = {}

	for i=1, self.m_nPageCount do
		self.PageChooseNumbers.Buttons[i] = self.PageChooseNumbers:Add("DButton")
		local button = self.PageChooseNumbers.Buttons[i]

		button:SetWide(self.PageButtonSize)
		button:Dock(LEFT)
		button:SetText(tostring(i))
		button:SetVisible(false)
		button:SetToolTip("Page " .. i .. " of " .. self.m_nPageCount)

		button.DoClick = function(panel)
			self:SetPage(i)
			self:LayoutPages(true)
		end
	end

	self:SetPage(1)
end

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()
	self.TimedpairsName = "wire_filebrowser_items_" .. tostring({})

	self.PageButtonSize = 20

	self:SetListSpeed(6)
	self:SetMaxItemsPerPage(200)

	self.m_nPageCount = 1

	self.m_strOpenPath = nil
	self.m_strOpenFile = nil
	self.m_strOpenFilename = nil

	self:SetDrawBackground(false)

	self.FolderPathPanel = self:Add("DPanel")
	self.FolderPathPanel:DockMargin(0, 0, 0, 3)
	self.FolderPathPanel:SetTall(20)
	self.FolderPathPanel:Dock(TOP)
	self.FolderPathPanel:SetDrawBackground(false)

	self.FolderPathText = self.FolderPathPanel:Add("DTextEntry")
	self.FolderPathText:DockMargin(0, 0, 3, 0)
	self.FolderPathText:Dock(FILL)
	self.FolderPathText.OnEnter = function(panel)
		self:SetOpenPath(panel:GetValue())
	end

	self.RefreshIcon = self.FolderPathPanel:Add("DImageButton") // The Folder Button.
	self.RefreshIcon:SetImage("icon16/arrow_refresh.png")
	self.RefreshIcon:SetWide(20)
	self.RefreshIcon:Dock(RIGHT)
	self.RefreshIcon:SetToolTip("Refresh")
	self.RefreshIcon:SetStretchToFit(false)
	self.RefreshIcon.DoClick = function()
		self:Refresh()
	end

	self.FolderPathIcon = self.FolderPathPanel:Add("DImageButton") // The Folder Button.
	self.FolderPathIcon:SetImage("icon16/folder_explore.png")
	self.FolderPathIcon:SetWide(20)
	self.FolderPathIcon:Dock(RIGHT)
	self.FolderPathIcon:SetToolTip("Open Folder")
	self.FolderPathIcon:SetStretchToFit(false)

	self.FolderPathIcon.DoClick = function()
		self.FolderPathText:OnEnter()
	end

	self.NotUserPressed = false
	self.Tree = vgui.Create( "DTree" )
	self.Tree:SetClickOnDragHover(false)
	self.Tree.OnNodeSelected = function( parent, node )
		local path = node.m_strFolder

		if ( !path ) then return end
		path = string.sub(path, #self.m_strRootPath+1)
		path = string.Trim(path, "/")

		if (!self.NotUserPressed) then
			self.FolderPathText:SetText(path)
		end

		if (self.m_strOpenPath == path) then return end
		ShowFolder(self, path)
	end

	self.PagePanel = vgui.Create("DPanel")
	self.PagePanel:SetDrawBackground(false)

	self.PageChoosePanel = self.PagePanel:Add("DPanel")
	self.PageChoosePanel:DockMargin(0, 0, 0, 0)
	self.PageChoosePanel:SetTall(self.PageButtonSize)
	self.PageChoosePanel:Dock(BOTTOM)
	self.PageChoosePanel:SetDrawBackground(false)
	self.PageChoosePanel:SetVisible(false)

	self.PageLastLeftButton = self.PageChoosePanel:Add("DButton")
	self.PageLastLeftButton:SetWide(self.PageButtonSize)
	self.PageLastLeftButton:Dock(LEFT)
	self.PageLastLeftButton:SetText("<<")
	self.PageLastLeftButton.DoClick = function(panel)
		self:SetPage(1)
	end

	self.PageLastRightButton = self.PageChoosePanel:Add("DButton")
	self.PageLastRightButton:SetWide(self.PageButtonSize)
	self.PageLastRightButton:Dock(RIGHT)
	self.PageLastRightButton:SetText(">>")
	self.PageLastRightButton.DoClick = function(panel)
		self:SetPage(self.m_nPageCount)
	end

	self.PageLeftButton = self.PageChoosePanel:Add("DButton")
	self.PageLeftButton:SetWide(self.PageButtonSize)
	self.PageLeftButton:Dock(LEFT)
	self.PageLeftButton:SetText("<")
	self.PageLeftButton.DoClick = function(panel)
		if (self.m_nPage <= 1 or !self.PageMode) then
			self.m_nPage = 1
			return
		end

		self:SetPage(self.m_nPage - 1)
	end

	self.PageRightButton = self.PageChoosePanel:Add("DButton")
	self.PageRightButton:SetWide(self.PageButtonSize)
	self.PageRightButton:Dock(RIGHT)
	self.PageRightButton:SetText(">")
	self.PageRightButton.DoClick = function(panel)
		if (self.m_nPage >= self.m_nPageCount or !self.PageMode) then
			self.m_nPage = self.m_nPageCount
			return
		end

		self:SetPage(self.m_nPage + 1)
	end

	self.PageChooseNumbers = self.PageChoosePanel:Add("DPanel")
	self.PageChooseNumbers:DockMargin(0, 0, 0, 0)
	self.PageChooseNumbers:SetSize(self.PageChoosePanel:GetWide()-60, self.PageChoosePanel:GetTall())
	self.PageChooseNumbers:Center()
	self.PageChooseNumbers:SetDrawBackground(false)

	self.PageLoadingProgress = self.PagePanel:Add("DProgress")
	self.PageLoadingProgress:DockMargin(0, 0, 0, 0)
	self.PageLoadingProgress:SetTall(self.PageButtonSize)
	self.PageLoadingProgress:Dock(BOTTOM)
	self.PageLoadingProgress:SetVisible(false)

	self.PageLoadingLabel = self.PageLoadingProgress:Add("DLabel")
	self.PageLoadingLabel:SizeToContents()
	self.PageLoadingLabel:Center()
	self.PageLoadingLabel:SetText("")
	self.PageLoadingLabel:SetPaintBackground(false)
	self.PageLoadingLabel:SetDark(true)


	self.List = self.PagePanel:Add( "DListView" )
	self.List:Dock( FILL )
	self.List:SetMultiSelect(false)
	local Column = self.List:AddColumn("Name")
	Column:SetMinWidth(150)
	Column:SetWide(200)

	self.List.OnRowSelected = function(parent, id, line)
		local name = line.m_strFilename
		local path = line.m_strPath
		local file = line.m_strFile
		self.m_strOpenFilename = name
		self.m_strOpenFile = file

		self:DoClick(file, path, name, parent, line)
	end

	self.List.DoDoubleClick = function(parent, id, line)
		local name = line.m_strFilename
		local path = line.m_strPath
		local file = line.m_strFile
		self.m_strOpenFilename = name
		self.m_strOpenFile = file

		self:DoDoubleClick(file, path, name, parent, line)
	end

	self.List.OnRowRightClick = function(parent, id, line)
		local name = line.m_strFilename
		local path = line.m_strPath
		local file = line.m_strFile
		self.m_strOpenFilename = name
		self.m_strOpenFile = file

		self:DoRightClick(file, path, name, parent, line)
	end

	self.SplitPanel = self:Add( "DHorizontalDivider" )
	self.SplitPanel:Dock( FILL )
	self.SplitPanel:SetLeft(self.Tree)
	self.SplitPanel:SetRight(self.PagePanel)
	self.SplitPanel:SetLeftWidth(200)
	self.SplitPanel:SetLeftMin(150)
	self.SplitPanel:SetRightMin(300)
	self.SplitPanel:SetDividerWidth(3)
end

function PANEL:Refresh()
	local file = self:GetOpenFile()
	local page = self:GetPage()

	self.bSetup = self:Setup()

	self:SetOpenFile(file)
	self:SetPage(page)
end


function PANEL:UpdatePageToolTips()
	self.PageLeftButton:SetToolTip("Previous Page (" .. self.m_nPage - 1 .. " of " .. self.m_nPageCount .. ")")
	self.PageRightButton:SetToolTip("Next Page (" .. self.m_nPage + 1 .. " of " .. self.m_nPageCount .. ")")

	self.PageLastRightButton:SetToolTip("Last Page (" .. self.m_nPageCount .. " of " .. self.m_nPageCount .. ")")
	self.PageLastLeftButton:SetToolTip("First Page (1 of " .. self.m_nPageCount .. ")")
end

function PANEL:LayoutPages(forcelayout)
	if (!self.PageChoosePanel:IsVisible()) then
		self.oldpage = nil
		return
	end

	local x, y = self.PageRightButton:GetPos()
	local Wide = x - self.PageLeftButton:GetWide()-40
	if (Wide <= 0 or forcelayout) then
		self.oldpage = nil
		self:InvalidateLayout()
		return
	end
	if (self.oldpage == self.m_nPage and self.oldpage and self.m_nPage) then return end
	self.oldpage = self.m_nPage

	if (self.m_nPage >= self.m_nPageCount) then
		EnableButton(self.PageLeftButton, true)
		EnableButton(self.PageRightButton, false)
		EnableButton(self.PageLastLeftButton, true)
		EnableButton(self.PageLastRightButton, false)
	elseif (self.m_nPage <= 1) then
		EnableButton(self.PageLeftButton, false)
		EnableButton(self.PageRightButton, true)
		EnableButton(self.PageLastLeftButton, false)
		EnableButton(self.PageLastRightButton, true)
	else
		EnableButton(self.PageLeftButton, true)
		EnableButton(self.PageRightButton, true)
		EnableButton(self.PageLastLeftButton, true)
		EnableButton(self.PageLastRightButton, true)
	end

	local ButtonCount = math.ceil(math.floor(Wide/self.PageButtonSize)/2)
	local pagepos = math.Clamp(self.m_nPage, ButtonCount, self.m_nPageCount-ButtonCount+1)

	local VisibleButtons = 0
	for i=1, self.m_nPageCount do
		local button = self.PageChooseNumbers.Buttons[i]
		if (!IsValid(button)) then continue end

		if (pagepos < i+ButtonCount and pagepos >= i-ButtonCount+1) then
			button:SetVisible(true)
			EnableButton(button, true)
			VisibleButtons = VisibleButtons + 1
		else
			button:SetVisible(false)
			EnableButton(button, false)
		end

		button.Depressed = false
	end

	local SelectButton = self.PageChooseNumbers.Buttons[self.m_nPage]
	if (IsValid(SelectButton)) then
		SelectButton.Depressed = true
		SelectButton:SetMouseInputEnabled(false)
	end

	self.PageChooseNumbers:SetWide(VisibleButtons*self.PageButtonSize)
	self.PageChooseNumbers:Center()
end

function PANEL:AddColumns(...)
	local Column = {}
	for k, v in ipairs({...}) do
		Column[k] = self.List:AddColumn(v)
	end
	return Column
end

function PANEL:Think()
	if (self.SplitPanel:GetDragging()) then
		self.oldpage = nil
		self:InvalidateLayout()
	end

	if ( !self.bSetup ) then
		self.bSetup = self:Setup()
	end
end

function PANEL:PerformLayout()
	self:LayoutPages()
	self.Tree:InvalidateLayout()
	self.List:InvalidateLayout()

	local minw = self:GetWide() - self.SplitPanel:GetRightMin() - self.SplitPanel:GetDividerWidth()
	local oldminw = self.SplitPanel:GetLeftWidth(minw)

	if (oldminw > minw) then
		self.SplitPanel:SetLeftWidth(minw)
	end


	//Fixes scrollbar glitches on resize
	self.Tree:OnMouseWheeled(0)
	self.List:OnMouseWheeled(0)

	if (!self.PageLoadingProgress:IsVisible()) then return end

	self.PageLoadingLabel:SizeToContents()
	self.PageLoadingLabel:Center()
end

function PANEL:Setup()
	if (!self.m_strRootName) then return false end
	if (!self.m_strRootPath) then return false end

	temp.TimedpairsStop(self.TimedpairsName)

	self.m_strOpenPath = nil
	self.m_strOpenFile = nil
	self.m_strOpenFilename = nil
	self.oldpage = nil

	self.Tree:Clear(true)
	if (IsValid(self.Root)) then
		self.Root:Remove()
	end
	self.Root = self.Tree.RootNode:AddFolder( self.m_strRootName, self.m_strRootPath, self.m_strWildCard or "GAME", false)

	return true
end

function PANEL:SetOpenFilename(filename)
	if(!isstring(filename)) then filename = "" end

	self.m_strOpenFilename = filename
	self.m_strOpenFile = ConnectPathes(self.m_strOpenPath, self.m_strOpenFilename)
end

function PANEL:SetOpenPath(path)
	self.Root:SetExpanded(true)

	path = PathFilter(path, self.FolderPathText, self.m_strRootPath) or ""
	if (self.m_strOpenPath == path) then return end
	self.oldpage = nil

	NavigateToFolder(self, path)
	self.m_strOpenPath = path
	self.m_strOpenFile = ConnectPathes(self.m_strOpenPath, self.m_strOpenFilename)
end

function PANEL:SetOpenFile(file)
	if(!isstring(file)) then file = "" end

	self:SetOpenPath(string.GetPathFromFilename(file))
	self:SetOpenFilename(string.GetFileFromFilename("/" .. file))
end

function PANEL:SetPage(page)
	if (page < 1) then return end
	if (page > self.m_nPageCount) then return end
	if (page == self.m_nPage) then return end

	temp.TimedpairsStop(self.TimedpairsName)
	self.List:Clear(true)

	self.m_nPage = page
	self:UpdatePageToolTips()

	local filepage
	if(self.PageMode) then
		filepage = {}
		for i=1, self.m_nMaxItemsPerPage do
			local index = i + self.m_nMaxItemsPerPage * (page - 1)
			local value = self.Files[index]
			if (!value) then break end
			filepage[i] = value
		end
	else
		filepage = self.Files
	end

	local Fraction = 0
	local FileCount = #filepage
	local ShowProgress = (FileCount > self.m_nListSpeed * 5)

	self.PageLoadingProgress:SetVisible(ShowProgress)
	if (FileCount <= 0) then
		self.PageLoadingProgress:SetVisible(false)

		return
	end

	self.PageLoadingProgress:SetFraction(Fraction)
	self.PageLoadingLabel:SetText("0 of " .. FileCount .. " files found.")
	self.PageLoadingLabel:SizeToContents()
	self.PageLoadingLabel:Center()

	self:InvalidateLayout()

	temp.Timedpairs(self.TimedpairsName, filepage, self.m_nListSpeed, function(id, name, self)
		if (!IsValid(self)) then return false end
		if (!IsValid(self.List)) then return false end

		local file = ConnectPathes(self.m_strOpenPath, name)
		local args, bcontinue, bbreak = self:LineData(id, file, self.m_strOpenPath, name)

		if (bcontinue) then return end // continue
		if (bbreak) then return false end // break

		local line = self.List:AddLine(name, unpack(args or {}))
		if (!IsValid(line)) then return end

		line.m_strPath = self.m_strOpenPath
		line.m_strFilename = name
		line.m_strFile = file

		if (self.m_strOpenFile == file) then
			self.List:SelectItem(line)
		end

		self:OnLineAdded(id, line, file, self.m_strOpenPath, name)

		Fraction = id / FileCount

		if (!IsValid(self.PageLoadingProgress)) then return end
		if (!ShowProgress) then return end

		self.PageLoadingProgress:SetFraction(Fraction)

		self.PageLoadingLabel:SetText(id .. " of " .. FileCount .. " files found.")
		self.PageLoadingLabel:SizeToContents()
		self.PageLoadingLabel:Center()
	end, function(id, name, self)
		if (!IsValid(self)) then return end
		Fraction = 1

		if (!IsValid(self.PageLoadingProgress)) then return end
		if (!ShowProgress) then return end

		self.PageLoadingProgress:SetFraction(Fraction)
		self.PageLoadingLabel:SetText(id .. " of " .. FileCount .. " files found.")
		self.PageLoadingLabel:SizeToContents()
		self.PageLoadingLabel:Center()

		self.PageLoadingProgress:SetVisible(false)
		self:InvalidateLayout()
	end, self)
end

function PANEL:DoClick(file, path, name)
	-- Override
end
function PANEL:DoDoubleClick(file, path, name)
	-- Override
end
function PANEL:DoRightClick(file, path, name)
	-- Override
end

function PANEL:LineData(id, file, path, name)
	return // to override
end

function PANEL:OnLineAdded(id, line, file, path, name)
	return // to override
end

vgui.Register("wire_filebrowser", PANEL, "DPanel")

// A sound property browsner. It helps to find all sounds which are defined in sound scripts or by sound.Add().
// Made by Grocel.

local PANEL = {}

local max_char_count = 200 //Name length limit

AccessorFunc( PANEL, "m_strSearchPattern", 		"SearchPattern" ) // Pattern to search for.
AccessorFunc( PANEL, "m_strSelectedSound", 		"SelectedSound" ) // Pattern to search for.
AccessorFunc( PANEL, "m_nListSpeed", 			"ListSpeed" ) // how many items to list an once
AccessorFunc( PANEL, "m_nMaxItems",				"MaxItems" ) // how may items at maximum

local function IsInString(strSource, strPattern)
	if (!strPattern) then return true end
	if (strPattern == "") then return true end

	strSource = string.lower(strSource)
	strPattern = string.lower(strPattern)

	if string.find(strSource, strPattern, 0, true) then return true end

	return false
end

local function GenerateList(self, strPattern)
	if (!IsValid(self)) then return end
	self:ClearList()

	local soundtable = sound.GetTable() or {}
	local soundcount = #soundtable
	self.SearchProgress:SetVisible(true)
	if (soundcount <= 0) then
		self.SearchProgress:SetVisible(false)

		return
	end

	self.SearchProgress:SetFraction(0)
	self.SearchProgressLabel:SetText("Searching... (0 %)")
	self.SearchProgressLabel:SizeToContents()
	self.SearchProgressLabel:Center()

	temp.Timedpairs(self.TimedpairsName, soundtable, self.m_nListSpeed, function(k, v, self)
		if (!IsValid(self)) then return false end
		if (!IsValid(self.SoundProperties)) then return false end
		if (!IsValid(self.SearchProgress)) then return false end

		self.SearchProgress:SetFraction(k / soundcount)
		self.SearchProgressLabel:SetText("Searching... ("..math.Round(k / soundcount * 100).." %)")
		self.SearchProgressLabel:SizeToContents()
		self.SearchProgressLabel:Center()

		if (self.TabfileCount >= self.m_nMaxItems) then
			self.SearchProgress:SetFraction(1)

			self.SearchProgressLabel:SetText("Searching... (100 %)")
			self.SearchProgressLabel:SizeToContents()
			self.SearchProgressLabel:Center()

			self.SearchProgress:SetVisible(false)
			self:InvalidateLayout()

			return false
		end

		if (!IsInString(v, strPattern)) then return end

		self:AddItem(k, v)

	end, function(k, v, self)
		if (!IsValid(self)) then return end
		if (!IsValid(self.SoundProperties)) then return end
		if (!IsValid(self.SearchProgress)) then return end

		self.SearchProgress:SetFraction(1)

		self.SearchProgressLabel:SetText("Searching... (100 %)")
		self.SearchProgressLabel:SizeToContents()
		self.SearchProgressLabel:Center()

		self.SearchProgress:SetVisible(false)
		self:InvalidateLayout()
	end, self)
end

function PANEL:Init()
	self.TimedpairsName = "wire_soundpropertylist_items_" .. tostring({})

	self:SetDrawBackground(false)
	self:SetListSpeed(100)
	self:SetMaxItems(400)

	self.SearchPanel = self:Add("DPanel")
	self.SearchPanel:DockMargin(0, 0, 0, 3)
	self.SearchPanel:SetTall(20)
	self.SearchPanel:Dock(TOP)
	self.SearchPanel:SetDrawBackground(false)

	self.SearchText = self.SearchPanel:Add("DTextEntry")
	self.SearchText:DockMargin(0, 0, 3, 0)
	self.SearchText:Dock(FILL)
	self.SearchText.OnChange = function(panel)
		self:SetSearchPattern(panel:GetValue())
	end

	self.RefreshIcon = self.SearchPanel:Add("DImageButton") // The Folder Button.
	self.RefreshIcon:SetImage("icon16/arrow_refresh.png")
	self.RefreshIcon:SetWide(20)
	self.RefreshIcon:Dock(RIGHT)
	self.RefreshIcon:SetToolTip("Refresh")
	self.RefreshIcon:SetStretchToFit(false)
	self.RefreshIcon.DoClick = function()
		self:Refresh()
	end

	self.SearchProgress = self:Add("DProgress")
	self.SearchProgress:DockMargin(0, 0, 0, 0)
	self.SearchProgress:SetTall(20)
	self.SearchProgress:Dock(BOTTOM)
	self.SearchProgress:SetVisible(false)

	self.SearchProgressLabel = self.SearchProgress:Add("DLabel")
	self.SearchProgressLabel:SizeToContents()
	self.SearchProgressLabel:Center()
	self.SearchProgressLabel:SetText("")
	self.SearchProgressLabel:SetPaintBackground(false)
	self.SearchProgressLabel:SetDark(true)


	self.SoundProperties = self:Add("DListView")
	self.SoundProperties:SetMultiSelect(false)
	self.SoundProperties:Dock(FILL)

	local Column = self.SoundProperties:AddColumn("No.")
	Column:SetFixedWidth(30)
	Column:SetWide(30)

	local Column = self.SoundProperties:AddColumn("ID")
	Column:SetFixedWidth(40)
	Column:SetWide(40)

	self.SoundProperties:AddColumn("Name")

	self.SoundProperties.OnRowSelected = function(parent, id, line)
		local name = line.m_strSoundname
		local data = line.m_tabData
		self.m_strSelectedSound = name

		self:DoClick(name, data, parent, line)
	end

	self.SoundProperties.DoDoubleClick = function(parent, id, line)
		local name = line.m_strSoundname
		local data = line.m_tabData
		self.m_strSelectedSound = name

		self:DoDoubleClick(name, data, parent, line)
	end

	self.SoundProperties.OnRowRightClick = function(parent, id, line)
		local name = line.m_strSoundname
		local data = line.m_tabData
		self.m_strSelectedSound = name

		self:DoRightClick(name, data, parent, line)
	end

	self:Refresh()
end

function PANEL:PerformLayout()
	if (!self.SearchProgress:IsVisible()) then return end

	self.SearchProgressLabel:SizeToContents()
	self.SearchProgressLabel:Center()
end

function PANEL:ClearList()
	temp.TimedpairsStop(self.TimedpairsName)
	self.SoundProperties:Clear(true)

	self.TabfileCount = 0
end

function PANEL:AddItem(...)
	local itemtable = {...}
	local item = itemtable[2]

	if (!isstring(item) or item == "") then return end
	if (self.TabfileCount > self.m_nMaxItems) then return end
	if (#item > max_char_count) then return end

	local itemargs = {}
	local i = 0

	for k, v in ipairs(itemtable) do
		if (k == 2) then continue end

		i = i + 1
		itemargs[i] = v
	end

	local line = self.SoundProperties:AddLine(self.TabfileCount + 1, ...)
	line.m_strSoundname = item
	line.m_tabData = itemargs

	if (self.m_strSelectedSound == item) then
		self.SoundProperties:SelectItem(line)
	end

	self.TabfileCount = self.TabfileCount + 1
	return line
end

function PANEL:SetSearchPattern(strPattern)
	self.m_strSearchPattern = strPattern or ""
	self:Refresh()
end

function PANEL:SetSelectedSound(strSelectedSound)
	self.m_strSelectedSound = strSelectedSound or ""
	self:Refresh()
end

function PANEL:Refresh()
	GenerateList(self, self.m_strSearchPattern)
end

function PANEL:DoClick(name, data, parent, line)
	-- Override
end
function PANEL:DoDoubleClick(name, data, parent, line)
	-- Override
end
function PANEL:DoRightClick(name, data, parent, line)
	-- Override
end

vgui.Register("wire_soundpropertylist", PANEL, "DPanel")

// A list editor. It allows reading editing and saving lists as *.txt files.
// It uses wire_expression2_browser for it's file browser.
// The files have an easy structure for easy editing. Rows are separated by '\n' and columns by '|'.
// Made by Grocel.

local PANEL = {}

AccessorFunc( PANEL, "m_strRootPath", 		"RootPath" ) // path of the root Root
AccessorFunc( PANEL, "m_strList", 			"List" ) // List file
AccessorFunc( PANEL, "m_strFile", 			"File" ) // sounds listed in list files
AccessorFunc( PANEL, "m_bUnsaved", 			"Unsaved" ) // edited list file Saved?
AccessorFunc( PANEL, "m_strSelectedList", 	"SelectedList" ) // Selected list file

AccessorFunc( PANEL, "m_nListSpeed", 			"ListSpeed" ) // how many items to list an once
AccessorFunc( PANEL, "m_nMaxItems",				"MaxItems" ) // how may items at maximum

local max_char_count = 200 //File length limit

local invalid_filename_chars = {
	["*"] = "",
	["?"] = "",
	[">"] = "",
	["<"] = "",
	["|"] = "",
	["\\"] = "",
	['"'] = "",
	[" "] = "_",
}

local invalid_chars = {
	["*"] = "",
	["?"] = "",
	[">"] = "",
	["<"] = "",
	["\\"] = "",
	['"'] = "",
}

local function ConnectPathes(path1, path2)
	local path = ""

	if (isstring(path1) and path1 ~= "") then
		path = path1
		if (isstring(path2) and path2 ~= "") then
			path = path1.."/"..path2
		end
	else
		if (isstring(path2) and path2 ~= "") then
			path = path2
		end
	end

	return path
end

//Parse the lines from a given file object
local function ReadLine(filedata)
	if (!filedata) then return end

	local fileline = ""
	local comment = false
	local count = 0

	for i=1, 32 do // skip 32 lines at maximum
		local line = ""
		local fileend = false

		for i=1, max_char_count+56 do // maximum chars per line
			local byte = filedata:ReadByte()
			fileend = !byte

			if (fileend) then break end // file end
			local char = string.char(byte)

			if (invalid_chars[char]) then // replace invalid chars
				char = invalid_chars[char]
			end

			if (char == "\n") then break end // line end
			line = line .. char
		end
		line = string.Trim(line)

		if (!fileend and line == "") then continue end
		fileline = line

		break
	end

	local linetable = string.Explode("|", fileline) or {}

	if (#linetable == 0) then return end

	for k, v in ipairs(linetable) do // cleanup
		local line = linetable[k]

		if (k == 1) then
			line = string.Trim(line, "/")
		end
		line = string.Trim(line)

		linetable[k] = line
	end

	if (#linetable[1] == 0) then return end

	return linetable
end

local function fileName(filepath)
	return string.match(filepath, "[/\\]?([^/\\]*)$")
end

local function SaveTo(self, func, ...)
	if (!IsValid(self)) then return end
	local args = {...}

	local path = self.FileBrowser:GetFileName() or self.m_strList or ""

	Derma_StringRequestNoBlur(
		"Save to New File",
		"",
		string.sub(fileName(path), 0, -5), // remove .txt at the end

		function( strTextOut )
			if (!IsValid(self)) then return end

			strTextOut = string.gsub(strTextOut, ".", invalid_filename_chars)
			if (strTextOut == "") then return end

			local filepath = string.GetPathFromFilename(path)
			if (!filepath or filepath == "") then filepath = self.m_strRootPath.."/" end

			local saved = self:SaveList(filepath..strTextOut..".txt")
			if (saved and func) then
				func(self, unpack(args))
			end
		end
	)
	return true
end

//Ask for override: Opens a confirmation if the file name is different box.
local function AsForOverride(self, func, filename, ...)
	if (!IsValid(self)) then return end

	if (!func) then return end
	if (filename == self.m_strList) then func(self, filename, ...) return end
	if (!file.Exists(filename, "DATA")) then func(self, filename, ...) return end

	local args = {...}

	Derma_Query(
		"Overwrite this file?",
		"Save To",
		"Overwrite",

		function()
			if (!IsValid(self)) then return end

			func(self, filename, unpack(args))
		end,

		"Cancel"
	)
end

//Ask for save: Opens a confirmation box.
local function AsForSave(self, func, ...)
	if (!IsValid(self)) then return end

	if (!func) then return end
	if (!self.m_bUnsaved) then func(self, ...) return end

	local args = {...}

	Derma_Query( "Would you like to save the changes?",
		"Unsaved List!",

		"Yes", // Save and resume.
		function()
			if (!IsValid(self)) then return end

			if (!self.m_strList or self.m_strList == "") then
				SaveTo(self, func, unpack(args))
				return
			end

			local saved = self:SaveList(self.m_strList)
			if (saved) then
				func(self, unpack(args))
			end
		end,

		"No", // Don't save and resume.
		function()
			if (!IsValid(self)) then return end
			func(self, unpack(args))
		end,

		"Cancel" // Do nothing.
	)
end


function PANEL:Init()
	self.TimedpairsName = "wire_listeditor_items_" .. tostring({})

	self:SetDrawBackground(false)

	self:SetListSpeed(40)
	self:SetMaxItems(512)
	self:SetUnsaved(false)

	self.TabfileCount = 0
	self.Tabfile = {}

	self.ListsPanel = vgui.Create("DPanel")
	self.ListsPanel:SetDrawBackground(false)

	self.FilesPanel = vgui.Create("DPanel")
	self.FilesPanel:SetDrawBackground(false)

	self.FileBrowser = self.ListsPanel:Add("wire_expression2_browser")
	self.FileBrowser:Dock(FILL)
	self.FileBrowser.OnFileOpen = function(panel, listfile)
		self:OpenList(listfile)
	end
	self.FileBrowser:RemoveRightClick("Open in New Tab") // we don't need tabs.
	self.FileBrowser:AddRightClick(self.FileBrowser.filemenu,4,"Save To..", function()
		self:SaveList(self.FileBrowser:GetFileName())
	end)
	self.FileBrowser.Update:Remove() // it's replaced

	self.Files = self.FilesPanel:Add("DListView")
	self.Files:SetMultiSelect(false)
	self.Files:Dock(FILL)

	local Column = self.Files:AddColumn("No.")
	Column:SetFixedWidth(30)
	Column:SetWide(30)

	self.Files:AddColumn("Name")

	local Column = self.Files:AddColumn("Type")
	Column:SetFixedWidth(70)
	Column:SetWide(70)

	self.Files.OnRowSelected = function(parent, id, line)
		local name = line.m_strFilename
		local data = line.m_tabData
		self.m_strFile = name
		self.m_strSelectedList = self.m_strList

		self:DoClick(name, data, parent, line)
	end

	self.Files.DoDoubleClick = function(parent, id, line)
		local name = line.m_strFilename
		local data = line.m_tabData
		self.m_strFile = name
		self.m_strSelectedList = self.m_strList

		self:DoDoubleClick(name, data, parent, line)
	end

	self.Files.OnRowRightClick = function(parent, id, line)
		local name = line.m_strFilename
		local data = line.m_tabData
		self.m_strFile = name
		self.m_strSelectedList = self.m_strList

		self:DoRightClick(name, data, parent, line)
	end

	self.ListTopPanel = self.FilesPanel:Add("DPanel")
	self.ListTopPanel:SetDrawBackground(false)
	self.ListTopPanel:Dock(TOP)
	self.ListTopPanel:SetTall(20)
	self.ListTopPanel:DockMargin(0, 0, 0, 3)

	self.SaveIcon = self.ListTopPanel:Add("DImageButton")
	self.SaveIcon:SetImage("icon16/table_save.png")
	self.SaveIcon:SetWide(20)
	self.SaveIcon:Dock(LEFT)
	self.SaveIcon:SetToolTip("Save list")
	self.SaveIcon:SetStretchToFit(false)
	self.SaveIcon:DockMargin(0, 0, 0, 0)
	self.SaveIcon.DoClick = function()
		if (!self.m_strList or self.m_strList == "") then
			SaveTo(self)
			return
		end

		self:SaveList(self.m_strList)
	end

	self.SaveToIcon = self.ListTopPanel:Add("DImageButton")
	self.SaveToIcon:SetImage("icon16/disk.png")
	self.SaveToIcon:SetWide(20)
	self.SaveToIcon:Dock(LEFT)
	self.SaveToIcon:SetToolTip("Save To..")
	self.SaveToIcon:SetStretchToFit(false)
	self.SaveToIcon:DockMargin(0, 0, 0, 0)
	self.SaveToIcon.DoClick = function()
		SaveTo(self)
	end

	self.NewIcon = self.ListTopPanel:Add("DImageButton")
	self.NewIcon:SetImage("icon16/table_add.png")
	self.NewIcon:SetWide(20)
	self.NewIcon:Dock(LEFT)
	self.NewIcon:SetToolTip("New list")
	self.NewIcon:SetStretchToFit(false)
	self.NewIcon:DockMargin(10, 0, 0, 0)
	self.NewIcon.DoClick = function()
		self:ClearList()
	end

	self.RefreshIcon = self.ListTopPanel:Add("DImageButton")
	self.RefreshIcon:SetImage("icon16/arrow_refresh.png")
	self.RefreshIcon:SetWide(20)
	self.RefreshIcon:Dock(LEFT)
	self.RefreshIcon:SetToolTip("Refresh and Reload")
	self.RefreshIcon:SetStretchToFit(false)
	self.RefreshIcon:DockMargin(0, 0, 0, 0)
	self.RefreshIcon.DoClick = function()
		self:Refresh()
	end

	self.ListNameLabel = self.ListTopPanel:Add("DLabel")
	self.ListNameLabel:SetText("")
	self.ListNameLabel:SetWide(20)
	self.ListNameLabel:Dock(FILL)
	self.ListNameLabel:DockMargin(12, 0, 0, 0)
	self.ListNameLabel:SetDark(true)

	self.SplitPanel = self:Add( "DHorizontalDivider" )
	self.SplitPanel:Dock( FILL )
	self.SplitPanel:SetLeft(self.ListsPanel)
	self.SplitPanel:SetRight(self.FilesPanel)
	self.SplitPanel:SetLeftWidth(200)
	self.SplitPanel:SetLeftMin(150)
	self.SplitPanel:SetRightMin(300)
	self.SplitPanel:SetDividerWidth(3)

	self:SetRootPath("wirelists")
end

function PANEL:PerformLayout()
	local minw = self:GetWide() - self.SplitPanel:GetRightMin() - self.SplitPanel:GetDividerWidth()
	local oldminw = self.SplitPanel:GetLeftWidth(minw)

	if (oldminw > minw) then
		self.SplitPanel:SetLeftWidth(minw)
	end

	//Fixes scrollbar glitches on resize
	if (IsValid(self.FileBrowser.Folders)) then
		self.FileBrowser.Folders:OnMouseWheeled(0)
	end
	self.Files:OnMouseWheeled(0)
end

function PANEL:UpdateListNameLabel()
	if (!IsValid(self.ListNameLabel)) then return end

	self.ListNameLabel:SetText((self.m_bUnsaved and "*" or "")..(self.m_strList or ""))
end


function PANEL:ClearList()
	AsForSave(self, function(self)
		self:SetList(nil)
		self:SetUnsaved(false)
		self.TabfileCount = 0

		temp.TimedpairsStop(self.TimedpairsName)
		self.Files:Clear(true)
		self.Tabfile = {}
	end)
end

function PANEL:Setup()
	if (!self.m_strRootPath) then return false end
	self.m_strSelectedList = nil
	self.m_strFile = nil

	self:ClearList()

	self.FileBrowser:Setup(self.m_strRootPath)

	return true
end

function PANEL:Refresh()
	self.FileBrowser:Refresh()
	self:OpenList(self.m_strList)

	self:InvalidateLayout()
end

function PANEL:Think()
	if (self.SplitPanel:GetDragging()) then
		self:InvalidateLayout()
	end

	if ( !self.bSetup ) then
		self.bSetup = self:Setup()
	end
end

function PANEL:AddItem(...)
	local itemtable = {...}
	local item = itemtable[1]

	if (!isstring(item) or item == "") then return end
	if (self.TabfileCount > self.m_nMaxItems) then return end
	if (#item > max_char_count) then return end
	if (self.Tabfile[item]) then return end

	local itemargs = {}
	local i = 0

	for k, v in ipairs(itemtable) do
		if (k == 1) then continue end

		i = i + 1
		itemargs[i] = v
	end
	self.Tabfile[item] = itemargs

	local line = self.Files:AddLine(self.TabfileCount + 1, ...)
	line.m_strFilename = item
	line.m_tabData = itemargs

	//if (self.m_strFile == item) then
	if (self.m_strSelectedList == self.m_strList and self.m_strFile == item) then
		self.Files:SelectItem(line)
	end

	self.TabfileCount = self.TabfileCount + 1
	self:SetUnsaved(true)
	return line
end

function PANEL:ItemInList(item)
	if (!item) then return false end
	if (self.Tabfile[item]) then return true end

	return false
end

function PANEL:RemoveItem(item)
	if (!item) then return end
	if (!self.Tabfile[item]) then return end
	if (!self.Files.Lines) then return end

	for k, v in ipairs(self.Files.Lines) do
		if (v.m_strFilename == item) then
			self.Files:RemoveLine(v:GetID())
			self.Tabfile[item] = nil
			self:SetUnsaved(true)
			self.TabfileCount = self.TabfileCount - 1

			break
		end
	end
end

function PANEL:OpenList(strfile)
	if (!strfile) then return end
	if (strfile == "") then return end

	AsForSave(self, function(self, strfile)
		local filedata = file.Open(strfile, "rb", "DATA")
		if (!filedata) then return end

		temp.TimedpairsStop(self.TimedpairsName)
		self.Files:Clear(true)
		self.Tabfile = {}
		self.TabfileCount = 0

		local counttab={}
		for i=1, self.m_nMaxItems do
			counttab[i] = true
		end

		temp.Timedpairs(self.TimedpairsName, counttab, self.m_nListSpeed, function(index, _, self, filedata)
			if (!IsValid(self)) then
				filedata:Close()
				return false
			end

			if (!IsValid(self.Files)) then
				filedata:Close()
				return false
			end

			if (self.TabfileCount >= self.m_nMaxItems) then
				filedata:Close()
				self:SetUnsaved(false)

				return false
			end

			local linetable = ReadLine(filedata)
			if (!linetable) then // do not add to empty lines
				filedata:Close()
				self:SetUnsaved(false)

				return false
			end

			self:AddItem(unpack(linetable))
			self:SetUnsaved(false)
		end, function(index, _, self, filedata)
			filedata:Close()

			if (!IsValid(self)) then return end
			self:SetUnsaved(false)
		end, self, filedata)

		self:SetUnsaved(false)
		self:SetList(strfile)
	end, strfile)
end

function PANEL:SaveList(strfile)
	if (!self.Tabfile) then return end
	if (!strfile) then return end
	if (strfile == "") then return end

	AsForOverride(self, function(self, strfile)
		local filedata = file.Open(strfile, "w", "DATA")
		if (!filedata) then
			Derma_Query( "File could not be saved!",
				"Error!",
				"OK"
			)

			return
		end

		for key, itemtable in SortedPairs(self.Tabfile) do
			local item = key
			for k, supitem in ipairs(itemtable) do
				item = item.." | "..supitem
			end
			filedata:Write(item.."\n")
		end

		filedata:Close()

		self:SetUnsaved(false)
		self:SetList(strfile)

		self:Refresh()
	end, strfile)
end

function PANEL:SetRootPath(path)
	self.m_strRootPath = path

	self.bSetup = self:Setup()
end

function PANEL:SetUnsaved(bool)
	self.m_bUnsaved = bool

	self:UpdateListNameLabel()
end

function PANEL:SetList(listfile)
	self.m_strList = listfile

	self:UpdateListNameLabel()
end

function PANEL:DoClick(name, data, parent, line)
	-- Override
end
function PANEL:DoDoubleClick(name, data, parent, line)
	-- Override
end
function PANEL:DoRightClick(name, data, parent, line)
	-- Override
end

vgui.Register("wire_listeditor", PANEL, "DPanel")


local max_char_count = 200 //File length limit
local max_char_chat_count = 110 // chat has a ~128 char limit, varies depending on char wide.

local Disabled_Gray = Color(140, 140, 140, 255)

local SoundBrowserPanel = nil
local TabFileBrowser = nil
local TabSoundPropertyList = nil
local TabFavourites = nil
local SoundInfoTree = nil
local SoundInfoTreeRoot = nil

local SoundObj = nil
local SoundObjNoEffect = nil

local TranslateCHAN = {
	[CHAN_REPLACE] = "CHAN_REPLACE",
	[CHAN_AUTO] = "CHAN_AUTO",
	[CHAN_WEAPON] = "CHAN_WEAPON",
	[CHAN_VOICE] = "CHAN_VOICE",
	[CHAN_ITEM] = "CHAN_ITEM",
	[CHAN_BODY] = "CHAN_BODY",
	[CHAN_STREAM] = "CHAN_STREAM",
	[CHAN_STATIC] = "CHAN_STATIC",
	[CHAN_VOICE2] = "CHAN_VOICE2",
	[CHAN_VOICE_BASE] = "CHAN_VOICE_BASE",
	[CHAN_USER_BASE] = "CHAN_USER_BASE"
}

// Output the infos about the given sound.
local function GetFileInfos(strfile)
	if (!isstring(strfile) or strfile == "") then return end

	local nsize = tonumber(file.Size("sound/" .. strfile, "GAME") or "-1")
	local strformat = string.lower(string.GetExtensionFromFilename(strfile) or "n/a")

	return nsize, strformat
end

local function FormatSize(nsize)
	if (!nsize) then return end

	//Negative filessizes aren't Valid.
	if (nsize < 0) then return end

	return nsize, string.NiceSize(nsize)
end

local function FormatLength(nduration)
	if (!nduration) then return end

	//Negative durations aren't Valid.
	if (nduration < 0) then return end

	local nm = math.floor(nduration / 60)
	local ns = math.floor(nduration % 60)
	local nms = (nduration % 1) * 1000
	return nduration, (string.format("%01d", nm)..":"..string.format("%02d", ns).."."..string.format("%03d", nms))
end

local function GetInfoTable(strfile)
	local nsize, strformat, nduration = GetFileInfos(strfile)
	if (!nsize) then return end

	nduration = SoundDuration(strfile) //Get the duration for the info text only.
	if(nduration) then
		nduration = math.Round(nduration * 1000) / 1000
	end
	local nduration, strduration = FormatLength(nduration, nsize)
	local nsizeB, strsize = FormatSize(nsize)

	local T = {}
	local tabproperty = sound.GetProperties(strfile)

	if (tabproperty) then
		T = tabproperty
	else
		T.Path = strfile
		T.Duration = {strduration or "n/a", nduration and nduration.." sec"}
		T.Size = {strsize or "n/a", nsizeB and nsizeB.." Bytes"}
		T.Format = strformat
	end

	return T, !tabproperty
end


// Output the infos about the given sound.
local oldstrfile
local function GenerateInfoTree(strfile, backnode, count)
	if(oldstrfile == strfile and strfile) then return end
	oldstrfile = strfile

	local SoundData, IsFile = GetInfoTable(strfile)

	if (!IsValid(backnode)) then
		if (IsValid(SoundInfoTreeRoot)) then
			SoundInfoTreeRoot:Remove()
		end
	end
	if(!SoundData) then return end

	local strcount = ""
	if (count) then
		strcount = " ("..count..")"
	end

	if (IsFile) then
		local index = ""
		local node = nil
		local mainnode = nil
		local subnode = nil

		if (IsValid(backnode)) then
			mainnode = backnode:AddNode("Sound File"..strcount, "icon16/sound.png")
		else
			mainnode = SoundInfoTree:AddNode("Sound File", "icon16/sound.png")
			SoundInfoTreeRoot = mainnode
		end


		do
			index = "Path"
			node = mainnode:AddNode(index, "icon16/sound.png")
			subnode = node:AddNode(SoundData[index], "icon16/page.png")
			subnode.IsSoundNode = true
			subnode.IsDataNode = true
		end
		do
			index = "Duration"
			node = mainnode:AddNode(index, "icon16/time.png")
			for k, v in pairs(SoundData[index]) do
				subnode = node:AddNode(v, "icon16/page.png")
				subnode.IsDataNode = true
			end
		end
		do
			index = "Size"
			node = mainnode:AddNode(index, "icon16/disk.png")
			for k, v in pairs(SoundData[index]) do
				subnode = node:AddNode(v, "icon16/page.png")
				subnode.IsDataNode = true
			end
		end
		do
			index = "Format"
			node = mainnode:AddNode(index, "icon16/page_white_key.png")
			subnode = node:AddNode(SoundData[index], "icon16/page.png")
			subnode.IsDataNode = true
		end
	else
		local node = nil
		local mainnode = nil

		if (IsValid(backnode)) then
			mainnode = backnode:AddNode("Sound Property"..strcount, "icon16/table_gear.png")
		else
			mainnode = SoundInfoTree:AddNode("Sound Property", "icon16/table_gear.png")
			SoundInfoTreeRoot = mainnode
		end

		do
			node = mainnode:AddNode("Name", "icon16/sound.png")
			subnode = node:AddNode(SoundData["name"], "icon16/page.png")
			subnode.IsSoundNode = true
			subnode.IsDataNode = true
		end
		do
			local tabchannel = SoundData["channel"] or 0
			if (istable(tabchannel)) then
				node = mainnode:AddNode("Channel", "icon16/page_white_gear.png")
				for k, v in pairs(tabchannel) do
					subnode = node:AddNode(v, "icon16/page.png")
					subnode.IsDataNode = true
					subnode = node:AddNode(TranslateCHAN[v] or TranslateCHAN[CHAN_USER_BASE], "icon16/page.png")
					subnode.IsDataNode = true
				end
			else
				node = mainnode:AddNode("Channel", "icon16/page_white_gear.png")
				subnode = node:AddNode(tabchannel, "icon16/page.png")
				subnode.IsDataNode = true
				subnode = node:AddNode(TranslateCHAN[tabchannel] or TranslateCHAN[CHAN_USER_BASE], "icon16/page.png")
				subnode.IsDataNode = true
			end
		end
		do
			local tablevel = SoundData["level"] or 0
			if (istable(tablevel)) then
				node = mainnode:AddNode("Level", "icon16/page_white_gear.png")
				for k, v in pairs(tablevel) do
					subnode = node:AddNode(v, "icon16/page.png")
					subnode.IsDataNode = true
					subnode = node:AddNode(v, "icon16/page.png")
					subnode.IsDataNode = true
				end
			else
				node = mainnode:AddNode("Level", "icon16/page_white_gear.png")
				subnode = node:AddNode(tablevel, "icon16/page.png")
				subnode.IsDataNode = true
			end
		end
		do
			local tabpitch = SoundData["volume"] or 0
			if (istable(tabpitch)) then
				node = mainnode:AddNode("Volume", "icon16/page_white_gear.png")
				for k, v in pairs(tabpitch) do
					subnode = node:AddNode(v, "icon16/page.png")
					subnode.IsDataNode = true
				end
			else
				node = mainnode:AddNode("Volume", "icon16/page_white_gear.png")
				subnode = node:AddNode(tabpitch, "icon16/page.png")
				subnode.IsDataNode = true
			end
		end
		do
			local tabpitch = SoundData["pitch"] or 0
			if (istable(tabpitch)) then
				node = mainnode:AddNode("Pitch", "icon16/page_white_gear.png")
				for k, v in pairs(tabpitch) do
					subnode = node:AddNode(v, "icon16/page.png")
					subnode.IsDataNode = true
				end
			else
				node = mainnode:AddNode("Pitch", "icon16/page_white_gear.png")
				subnode = node:AddNode(tabpitch, "icon16/page.png")
				subnode.IsDataNode = true
			end
		end
		do
			local tabsound = SoundData["sound"] or ""
			if (istable(tabsound)) then
				node = mainnode:AddNode("Sounds", "icon16/table_multiple.png")
			else
				node = mainnode:AddNode("Sound", "icon16/table.png")
			end

			node.SubData = tabsound
			node.BackNode = mainnode
			node.Expander.DoClick = function(self)
				if (!IsValid(SoundInfoTree)) then return end
				if (!IsValid(node)) then return end

				node:SetExpanded(false)
				SoundInfoTree:SetSelectedItem(node)
			end
			node:AddNode("Dummy")
		end
	end

	if (IsValid(backnode)) then
		return
	end

	if (IsValid(SoundInfoTreeRoot)) then
		SoundInfoTreeRoot:SetExpanded(true)
	end
end

// Set the volume of the sound.
local function SetSoundVolume(volume)
	if(!SoundObj) then return end

	SoundObj:ChangeVolume(tonumber(volume) or 1, 0.1)
end

// Set the pitch of the sound.
local function SetSoundPitch(pitch)
	if(!SoundObj) then return end

	SoundObj:ChangePitch(tonumber(pitch) or 100, 0.1)
end

// Play the given sound, if no sound is given then mute a playing sound.
local function PlaySound(file, volume, pitch)
	if(SoundObj) then
		SoundObj:Stop()
		SoundObj = nil
	end

	if (!file or file == "") then return end

	local ply = LocalPlayer()
	if (!IsValid(ply)) then return end

	util.PrecacheSound(file)

	SoundObj = CreateSound(ply, file)
	if(SoundObj) then
		SoundObj:PlayEx(tonumber(volume) or 1, tonumber(pitch) or 100)
	end
end

// Play the given sound without effects, if no sound is given then mute a playing sound.
local function PlaySoundNoEffect(file)
	if(SoundObjNoEffect) then
		SoundObjNoEffect:Stop()
		SoundObjNoEffect = nil
	end

	if (!file or file == "") then return end

	local ply = LocalPlayer()
	if (!IsValid(ply)) then return end

	util.PrecacheSound(file)

	SoundObjNoEffect = CreateSound(ply, file)
	if(SoundObjNoEffect) then
		SoundObjNoEffect:PlayEx(1, 100)
	end
end

local function SetupSoundemitter(strSound)
	// Setup the Soundemitter stool with the soundpath.
	RunConsoleCommand("wire_soundemitter_sound", strSound)

	// Pull out the soundemitter stool after setup.
	spawnmenu.ActivateTool("wire_soundemitter")
end

local function SetupClipboard(strSound)
	// Copy the soundpath to Clipboard.
	SetClipboardText(strSound)
end

local function Sendmenu(strSound, SoundEmitter, nSoundVolume, nSoundPitch) // Open a sending and setup menu on right click on a sound file.
	if (!isstring(strSound)) then return end
	if (strSound == "") then return end

	local Menu = DermaMenu()
	local MenuItem = nil

	if (SoundEmitter) then

		//Setup soundemitter
			MenuItem = Menu:AddOption("Setup soundemitter", function()
				SetupSoundemitter(strSound)
			end)
			MenuItem:SetImage("icon16/sound.png")

		//Setup soundemitter and close
			MenuItem = Menu:AddOption("Setup soundemitter and close", function()
				SetupSoundemitter(strSound)
				SoundBrowserPanel:Close()
			end)
			MenuItem:SetImage("icon16/sound.png")

		//Copy to clipboard
			MenuItem = Menu:AddOption("Copy to clipboard", function()
				SetupClipboard(strSound)
			end)
			MenuItem:SetImage("icon16/page_paste.png")

		//Copy to clipboard and close
			MenuItem = Menu:AddOption("Copy to clipboard and close", function()
				SetupClipboard(strSound)
				SoundBrowserPanel:Close()
			end)
			MenuItem:SetImage("icon16/page_paste.png")

		else

		//Copy to clipboard
			MenuItem = Menu:AddOption("Copy to clipboard", function()
				SetupClipboard(strSound)
			end)
			MenuItem:SetImage("icon16/page_paste.png")

		//Copy to clipboard and close
			MenuItem = Menu:AddOption("Copy to clipboard and close", function()
				SetupClipboard(strSound)
				SoundBrowserPanel:Close()
			end)
			MenuItem:SetImage("icon16/page_paste.png")

		//Setup soundemitter
			MenuItem = Menu:AddOption("Setup soundemitter", function()
				SetupSoundemitter(strSound)
			end)
			MenuItem:SetImage("icon16/sound.png")

		//Setup soundemitter and close
			MenuItem = Menu:AddOption("Setup soundemitter and close", function()
				SetupSoundemitter(strSound)
				SoundBrowserPanel:Close()
			end)
			MenuItem:SetImage("icon16/sound.png")

	end

	Menu:AddSpacer()

	if (IsValid(TabFavourites)) then
		// Add the soundpath to the favourites.
		if (TabFavourites:ItemInList(strSound)) then

			//Remove from favourites
				MenuItem = Menu:AddOption("Remove from favourites", function()
					TabFavourites:RemoveItem(strSound)
				end)
				MenuItem:SetImage("icon16/bin_closed.png")

		else

			//Add to favourites
				MenuItem = Menu:AddOption("Add to favourites", function()
					TabFavourites:AddItem(strSound, sound.GetProperties(strSound) and "property" or "file")
				end)
				MenuItem:SetImage("icon16/star.png")
				local max_item_count = TabFavourites:GetMaxItems()
				local count = TabFavourites.TabfileCount
				if (count >= max_item_count) then
					MenuItem:SetTextColor(Disabled_Gray) // custom disabling
					MenuItem.DoClick = function() end

					MenuItem:SetToolTip("The favourites list is Full! It can't hold more than "..max_item_count.." items!")
				end

		end
	end

	Menu:AddSpacer()

	//Print to console
		MenuItem = Menu:AddOption("Print to console", function()
			// Print the soundpath in the Console/HUD.
			local ply = LocalPlayer()
			if (!IsValid(ply)) then return end

			ply:PrintMessage( HUD_PRINTTALK, strSound)
		end)
		MenuItem:SetImage("icon16/monitor_go.png")

	//Print to Chat
		MenuItem = Menu:AddOption("Print to Chat", function()
			// Say the the soundpath.
			RunConsoleCommand("say", strSound)
		end)
		MenuItem:SetImage("icon16/group_go.png")

		local len = #strSound
		if (len > max_char_chat_count) then
			MenuItem:SetTextColor(Disabled_Gray) // custom disabling
			MenuItem.DoClick = function() end

			MenuItem:SetToolTip("The filepath ("..len.." chars) is too long to print in chat. It should be shorter than "..max_char_chat_count.." chars!")
		end

	Menu:AddSpacer()

	//Play
		MenuItem = Menu:AddOption("Play", function()
			PlaySound(strSound, nSoundVolume, nSoundPitch, strtype)
			PlaySoundNoEffect()
		end)
		MenuItem:SetImage("icon16/control_play.png")

	//Play without effects
		MenuItem = Menu:AddOption("Play without effects", function()
			PlaySound()
			PlaySoundNoEffect(strSound, strtype)
		end)
		MenuItem:SetImage("icon16/control_play_blue.png")

	Menu:Open()
end

local function Infomenu(parent, node, SoundEmitter, nSoundVolume, nSoundPitch)
	if(!IsValid(node)) then return end
	if(!node.IsDataNode) then return end

	local strNodeName = node:GetText()
	local IsSoundNode = node.IsSoundNode

	if(IsSoundNode) then
		Sendmenu(strNodeName, SoundEmitter, nSoundVolume, nSoundPitch)
		return
	end

	local Menu = DermaMenu()

	//Copy to clipboard
		MenuItem = Menu:AddOption("Copy to clipboard", function()
			SetupClipboard(strNodeName)
		end)
		MenuItem:SetImage("icon16/page_paste.png")

	//Print to console
		MenuItem = Menu:AddOption("Print to console", function()
			// Print the soundpath in the Console/HUD.
			local ply = LocalPlayer()
			if (!IsValid(ply)) then return end

			ply:PrintMessage( HUD_PRINTTALK, strNodeName)
		end)
		MenuItem:SetImage("icon16/monitor_go.png")

	//Print to Chat
		MenuItem = Menu:AddOption("Print to Chat", function()
			// Say the the soundpath.
			RunConsoleCommand("say", strNodeName)
		end)
		MenuItem:SetImage("icon16/group_go.png")

		local len = #strNodeName
		if (len > max_char_chat_count) then
			MenuItem:SetTextColor(Disabled_Gray) // custom disabling
			MenuItem.DoClick = function() end

			MenuItem:SetToolTip("The filepath ("..len.." chars) is too long to print in chat. It should be shorter than "..max_char_chat_count.." chars!")
		end

	Menu:Open()
end

// Save the file path. It should be cross session.
// It's used when opening the browser in the e2 editor.
local function SaveFilePath(panel, file)
	if (!IsValid(panel)) then return end
	if (panel.Soundemitter) then return end

	panel:SetCookie("wire_soundfile", file)
end

// Open the Sound Browser.
local function CreateSoundBrowser(path, se)
	local soundemitter = false
	if (isstring(path) and path ~= "") then
		soundemitter = true

		if (tonumber(se) ~= 1) then
			soundemitter = false
		end
	end

	if (tonumber(se) == 1) then
		soundemitter = true
	end

	local strSound = ""
	local nSoundVolume = 1
	local nSoundPitch = 100

	if(IsValid(SoundBrowserPanel)) then SoundBrowserPanel:Remove() end
	if(IsValid(TabFileBrowser)) then TabFileBrowser:Remove() end
	if(IsValid(TabSoundPropertyList)) then TabSoundPropertyList:Remove() end
	if(IsValid(TabFavourites)) then TabFavourites:Remove() end
	if(IsValid(SoundInfoTree)) then SoundInfoTree:Remove() end
	if(IsValid(SoundInfoTreeRoot)) then SoundInfoTreeRoot:Remove() end

	SoundBrowserPanel = vgui.Create("DFrame") // The main frame.
	SoundBrowserPanel:SetPos(50,25)
	SoundBrowserPanel:SetSize(750, 500)

	SoundBrowserPanel:SetMinWidth(700)
	SoundBrowserPanel:SetMinHeight(400)

	SoundBrowserPanel:SetSizable(true)
	SoundBrowserPanel:SetDeleteOnClose( false )
	SoundBrowserPanel:SetTitle("Sound Browser")
	SoundBrowserPanel:SetVisible(false)
	SoundBrowserPanel:SetCookieName( "wire_sound_browser" )

	TabFileBrowser = vgui.Create("wire_filebrowser") // The file tree browser.
	TabSoundPropertyList = vgui.Create("wire_soundpropertylist") // The sound property browser.
	TabFavourites = vgui.Create("wire_listeditor") // The favourites manager.

	TabFileBrowser:SetListSpeed(6)
	TabFileBrowser:SetMaxItemsPerPage(200)

	TabSoundPropertyList:SetListSpeed(100)
	TabSoundPropertyList:SetMaxItems(400)

	TabFavourites:SetListSpeed(40)
	TabFavourites:SetMaxItems(512)

	local BrowserTabs = vgui.Create("DPropertySheet") // The tabs.
	BrowserTabs:DockMargin(5, 5, 5, 5)
	BrowserTabs:AddSheet("File Browser", TabFileBrowser, "icon16/folder.png", false, false, "Browse your sound folder.")
	BrowserTabs:AddSheet("Sound Property Browser", TabSoundPropertyList, "icon16/table_gear.png", false, false, "Browse the sound properties.")
	BrowserTabs:AddSheet("Favourites", TabFavourites, "icon16/star.png", false, false, "View your favourites.")

	SoundInfoTree = vgui.Create("DTree") // The info tree.
	SoundInfoTree:SetClickOnDragHover(false)
	local oldClicktime = CurTime()
	SoundInfoTree.DoClick = function( parent, node )
		if (!IsValid(parent)) then return end
		if (!IsValid(node)) then return end
		parent:SetSelectedItem(node)

		local Clicktime = CurTime()
		if ((Clicktime - oldClicktime) > 0.3) then oldClicktime = Clicktime return end
		oldClicktime = Clicktime

		if (!node.IsSoundNode) then return end

		local file = node:GetText()
		PlaySound(file, nSoundVolume, nSoundPitch)
		PlaySoundNoEffect()
	end
	SoundInfoTree.DoRightClick = function( parent, node )
		if (!IsValid(parent)) then return end
		if (!IsValid(node)) then return end

		parent:SetSelectedItem(node)
		Infomenu(parent, node, SoundEmitter, nSoundVolume, nSoundPitch)
	end

	SoundInfoTree.OnNodeSelected = function( parent, node )
		if (!IsValid(parent)) then return end
		if (!IsValid(node)) then return end

		local backnode = node.BackNode
		if (!IsValid(node.BackNode)) then
			node:SetExpanded(!node.m_bExpanded)
			return
		end

		local tabsound = node.SubData
		if (!tabsound) then
			node:SetExpanded(!node.m_bExpanded)
			return
		end

		node:SetExpanded(false)
		node:Remove()

		if (istable(tabsound)) then
			node = backnode:AddNode("Sounds", "icon16/table_multiple.png")
			for k, v in pairs(tabsound) do
				GenerateInfoTree(v, node, k)
			end
		else
			node = backnode:AddNode("Sound", "icon16/table.png")
			GenerateInfoTree(tabsound, node)
		end

		node:SetExpanded(false)
		parent:SetSelectedItem(node)
		node:SetExpanded(!node.m_bExpanded)
	end

	local SplitPanel = SoundBrowserPanel:Add( "DHorizontalDivider" )
	SplitPanel:Dock(FILL)
	SplitPanel:SetLeft(BrowserTabs)
	SplitPanel:SetRight(SoundInfoTree)
	SplitPanel:SetLeftWidth(570)
	SplitPanel:SetLeftMin(500)
	SplitPanel:SetRightMin(150)
	SplitPanel:SetDividerWidth(3)

	TabFileBrowser:SetRootName("sound")
	TabFileBrowser:SetRootPath("sound")
	TabFileBrowser:SetWildCard("GAME")
	TabFileBrowser:SetFileTyps({"*.mp3","*.wav"})

	//TabFileBrowser:AddColumns("Type", "Size", "Length") //getting the duration is very slow.
	local Columns = TabFileBrowser:AddColumns("Format", "Size")
	Columns[1]:SetFixedWidth(70)
	Columns[1]:SetWide(70)
	Columns[2]:SetFixedWidth(70)
	Columns[2]:SetWide(70)

	TabFileBrowser.LineData = function(self, id, strfile, ...)
		if (#strfile > max_char_count) then return nil, true end // skip and hide to long filenames.

		local nsize, strformat, nduration = GetFileInfos(strfile)
		if (!nsize) then return end

		local nsizeB, strsize = FormatSize(nsize, nduration)
		local nduration, strduration = FormatLength(nduration, nsize)

		//return {strformat, strsize or "n/a", strduration or "n/a"} //getting the duration is very slow.
		return {strformat, strsize or "n/a"}
	end

	TabFileBrowser.OnLineAdded = function(self, id, line, strfile, ...)

	end

	TabFileBrowser.DoClick = function(parent, file)
		SaveFilePath(SoundBrowserPanel, file)

		strSound = file
		GenerateInfoTree(file)
	end

	TabFileBrowser.DoDoubleClick = function(parent, file)
		PlaySound(file, nSoundVolume, nSoundPitch)
		PlaySoundNoEffect()
		SaveFilePath(SoundBrowserPanel, file)

		strSound = file
	end

	TabFileBrowser.DoRightClick = function(parent, file)
		Sendmenu(file, SoundBrowserPanel.Soundemitter, nSoundVolume, nSoundPitch)
		SaveFilePath(SoundBrowserPanel, file)

		strSound = file
		GenerateInfoTree(file)
	end


	TabSoundPropertyList.DoClick = function(parent, property)
		SaveFilePath(SoundBrowserPanel, property)

		strSound = property
		GenerateInfoTree(property)
	end

	TabSoundPropertyList.DoDoubleClick = function(parent, property)
		PlaySound(property, nSoundVolume, nSoundPitch)
		PlaySoundNoEffect()
		SaveFilePath(SoundBrowserPanel, property)

		strSound = property
	end

	TabSoundPropertyList.DoRightClick = function(parent, property)
		Sendmenu(property, SoundBrowserPanel.Soundemitter, nSoundVolume, nSoundPitch)
		SaveFilePath(SoundBrowserPanel, property)

		strSound = property
		GenerateInfoTree(property)
	end

	file.CreateDir("soundlists")
	TabFavourites:SetRootPath("soundlists")

	TabFavourites.DoClick = function(parent, item, data)
		if(file.Exists("sound/"..item, "GAME")) then
			TabFileBrowser:SetOpenFile(item)
		end

		strSound = item
		GenerateInfoTree(item)
	end

	TabFavourites.DoDoubleClick = function(parent, item, data)
		if(file.Exists("sound/"..item, "GAME")) then
			TabFileBrowser:SetOpenFile(item)
		end

		PlaySound(item, nSoundVolume, nSoundPitch)
		PlaySoundNoEffect()
		strSound = item
	end

	TabFavourites.DoRightClick = function(parent, item, data)
		if(file.Exists("sound/"..item, "GAME")) then
			TabFileBrowser:SetOpenFile(item)
		end

		Sendmenu(item, SoundBrowserPanel.Soundemitter, nSoundVolume, nSoundPitch)
		strSound = item
		GenerateInfoTree(item)
	end

	local ControlPanel = SoundBrowserPanel:Add("DPanel") // The bottom part of the frame.
	ControlPanel:DockMargin(0, 5, 0, 0)
	ControlPanel:Dock(BOTTOM)
	ControlPanel:SetTall(60)
	ControlPanel:SetDrawBackground(false)

	local ButtonsPanel = ControlPanel:Add("DPanel") // The buttons.
	ButtonsPanel:DockMargin(4, 0, 0, 0)
	ButtonsPanel:Dock(RIGHT)
	ButtonsPanel:SetWide(250)
	ButtonsPanel:SetDrawBackground(false)

	local TunePanel = ControlPanel:Add("DPanel") // The effect Sliders.
	TunePanel:DockMargin(0, 4, 0, 0)
	TunePanel:Dock(LEFT)
	TunePanel:SetWide(350)
	TunePanel:SetDrawBackground(false)

	local TuneVolumeSlider = TunePanel:Add("DNumSlider") // The volume slider.
	TuneVolumeSlider:DockMargin(2, 0, 0, 0)
	TuneVolumeSlider:Dock(TOP)
	TuneVolumeSlider:SetText("Volume")
	TuneVolumeSlider:SetDecimals(0)
	TuneVolumeSlider:SetMinMax(0, 100)
	TuneVolumeSlider:SetValue(100)
	TuneVolumeSlider.Label:SetWide(40)
	TuneVolumeSlider.OnValueChanged = function(self, val)
		nSoundVolume = val / 100
		SetSoundVolume(nSoundVolume)
	end

	local TunePitchSlider = TunePanel:Add("DNumSlider") // The pitch slider.
	TunePitchSlider:DockMargin(2, 0, 0, 0)
	TunePitchSlider:Dock(BOTTOM)
	TunePitchSlider:SetText("Pitch")
	TunePitchSlider:SetDecimals(0)
	TunePitchSlider:SetMinMax(0, 255)
	TunePitchSlider:SetValue(100)
	TunePitchSlider.Label:SetWide(40)
	TunePitchSlider.OnValueChanged = function(self, val)
		nSoundPitch = val
		SetSoundPitch(nSoundPitch)
	end

	local PlayStopPanel = ButtonsPanel:Add("DPanel") // Play and stop.
	PlayStopPanel:DockMargin(0, 0, 0, 2)
	PlayStopPanel:Dock(TOP)
	PlayStopPanel:SetDrawBackground(false)

	local PlayButton = PlayStopPanel:Add("DButton") // The play button.
	PlayButton:SetText("Play")
	PlayButton:Dock(LEFT)
	PlayButton:SetWide(PlayStopPanel:GetWide() / 2 - 2)
	PlayButton.DoClick = function()
		PlaySound(strSound, nSoundVolume, nSoundPitch)
		PlaySoundNoEffect()
	end

	local StopButton = PlayStopPanel:Add("DButton") // The stop button.
	StopButton:SetText("Stop")
	StopButton:Dock(RIGHT)
	StopButton:SetWide(PlayButton:GetWide())
	StopButton.DoClick = function()
		PlaySound() // Mute a playing sound by not giving a sound.
		PlaySoundNoEffect()
	end

	local SoundemitterButton = ButtonsPanel:Add("DButton") // The soundemitter button. Hidden in e2 mode.
	SoundemitterButton:SetText("Send to soundemitter")
	SoundemitterButton:DockMargin(0, 2, 0, 0)
	SoundemitterButton:Dock(FILL)
	SoundemitterButton:SetVisible(false)
	SoundemitterButton.DoClick = function(btn)
		SetupSoundemitter(strSound)
	end

	local ClipboardButton = ButtonsPanel:Add("DButton") // The soundemitter button. Hidden in soundemitter mode.
	ClipboardButton:SetText("Copy to clipboard")
	ClipboardButton:DockMargin(0, 2, 0, 0)
	ClipboardButton:Dock(FILL)
	ClipboardButton:SetVisible(false)
	ClipboardButton.DoClick = function(btn)
		SetupClipboard(strSound)
	end

	local oldw, oldh = SoundBrowserPanel:GetSize()
	SoundBrowserPanel.PerformLayout = function(self, ...)
		SoundemitterButton:SetVisible(self.Soundemitter)
		ClipboardButton:SetVisible(!self.Soundemitter)

		local w = self:GetWide()
		local rightw = SplitPanel:GetLeftWidth() + w - oldw

		if (rightw < SplitPanel:GetLeftMin()) then
			rightw = SplitPanel:GetLeftMin()
		end
		SplitPanel:SetLeftWidth(rightw)

		local minw = w - SplitPanel:GetRightMin() + SplitPanel:GetDividerWidth()
		if (SplitPanel:GetLeftWidth() > minw) then
			SplitPanel:SetLeftWidth(minw)
		end

		PlayStopPanel:SetTall(ControlPanel:GetTall() / 2 - 2)
		PlayButton:SetWide(PlayStopPanel:GetWide() / 2 - 2)
		StopButton:SetWide(PlayButton:GetWide())

		if (self.Soundemitter) then
			SoundemitterButton:SetTall(PlayStopPanel:GetTall() - 2)
		else
			ClipboardButton:SetTall(PlayStopPanel:GetTall() - 2)
		end

		oldw, oldh = self:GetSize()

		DFrame.PerformLayout(self, ...)
	end

	SoundBrowserPanel.OnClose = function() // Set effects back and mute when closing.
		nSoundVolume = 1
		nSoundPitch = 100
		TuneVolumeSlider:SetValue(nSoundVolume * 100)
		TunePitchSlider:SetValue(nSoundPitch)
		vgui.GetWorldPanel():SetWorldClicker(false) -- Not allow the breakage of other addons installed.
		PlaySound()
		PlaySoundNoEffect()
	end

	SoundBrowserPanel:InvalidateLayout(true)
end

// Open the Sound Browser.
local function OpenSoundBrowser(pl, cmd, args)
	local path = args[1] // nil or "" will put the browser in e2 mode else the soundemitter mode is applied.
	local se = args[2]

	if (!IsValid(SoundBrowserPanel)) then
		CreateSoundBrowser(path, se)
	end

	SoundBrowserPanel:SetVisible(true)
	SoundBrowserPanel:MakePopup()
	SoundBrowserPanel:InvalidateLayout(true)

	vgui.GetWorldPanel():SetWorldClicker(true)

	if (!IsValid(TabFileBrowser)) then return end

	//Replaces the timer, doesn't get paused in singleplayer.
	temp.Timedcall(function(SoundBrowserPanel, TabFileBrowser, path, se)
		if (!IsValid(SoundBrowserPanel)) then return end
		if (!IsValid(TabFileBrowser)) then return end

		local soundemitter = false
		if (isstring(path) and path ~= "") then
			soundemitter = true
		end

		local soundemitter = false
		if (isstring(path) and path ~= "") then
			soundemitter = true

			if (tonumber(se) ~= 1) then
				soundemitter = false
			end
		end

		if (tonumber(se) == 1) then
			soundemitter = true
		end

		SoundBrowserPanel.Soundemitter = soundemitter
		SoundBrowserPanel:InvalidateLayout(true)

		if (!soundemitter) then
			path = SoundBrowserPanel:GetCookie("wire_soundfile", "") // load last session
		end
		TabFileBrowser:SetOpenFile(path)
	end, SoundBrowserPanel, TabFileBrowser, path, se)
end

concommand.Add("wire_sound_browser_open", OpenSoundBrowser)