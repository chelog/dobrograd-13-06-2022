-- START HACKHACKHACK :(
do return end
local CHECK_ALL_PLAYERS_FOR_EDIT_LOCK = true

local function CHECK_PLAYER(ply)
	if not ply then return end
	
	if not (ply and (ply ~= NULL) and ply.IsValid and ply:IsValid() and ply:Alive() and ply:GetActiveWeapon() and ply:GetActiveWeapon():IsValid() and (ply:GetActiveWeapon():GetClass() == "gmod_tool")) then
		if ply.LockedOnEntity then
			ply.LockedOnEntity.IsLocked = false
			
			ply.LockedOnEntity = nil
		end
	else
		local trace = ply:GetEyeTrace()
		
		if trace.StartPos:Distance(trace.HitPos) > 512 then
			if ply.CatmullRomCams_LockedOnEntity then
				ply.CatmullRomCams_LockedOnEntity.IsLocked = false
				print("too far")
				ply.CatmullRomCams_LockedOnEntity = nil
			end
		elseif not CatmullRomCams.SToolMethods.ValidTrace(trace) then
			if ply.CatmullRomCams_LockedOnEntity then
				ply.CatmullRomCams_LockedOnEntity.IsLocked = false
				print("invalid")
				ply.CatmullRomCams_LockedOnEntity = nil
			end
		elseif ply.CatmullRomCams_LockedOnEntity then--if ply.CatmullRomCams_LockedOnEntity ~= trace.Entity then -- lazyness to handle the case where more then one player is looking at a node and one looks away <_<
			ply.CatmullRomCams_LockedOnEntity.IsLocked = false
			
			ply.CatmullRomCams_LockedOnEntity = trace.Entity
			print("locked")
			ply.CatmullRomCams_LockedOnEntity.IsLocked = true
		else
			ply.CatmullRomCams_LockedOnEntity = trace.Entity
			print("locked")
			ply.CatmullRomCams_LockedOnEntity.IsLocked = true
		end
	end
end

function CatmullRomCams.SToolMethods.LockOnEditingDisplayThink()
	if not CHECK_ALL_PLAYERS_FOR_EDIT_LOCK then return CHECK_PLAYER(LocalPlayer()) end
	
	for k, v in pairs(player.GetAll()) do
		CHECK_PLAYER(v)
	end
end

hook.Add("Think", "CatmullRomCams.SToolMethods.LockOnEditingDisplayThink", CatmullRomCams.SToolMethods.LockOnEditingDisplayThink)

-- END HACKHACKHACK