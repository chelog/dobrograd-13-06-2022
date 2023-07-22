util.AddNetworkString("PropsHistory")

local function AddPropHistory(ply, model, ent)
	net.Start("PropsHistory")
	net.WriteString(model)
	net.WriteUInt(ent:GetSkin(), 8)

	for i = 0, 8 do
		net.WriteUInt(ent:GetBodygroup(i) or 0, 4)
	end

	net.Send(ply)
end

hook.Add("PlayerSpawnedProp", "PropsHistory", AddPropHistory)
hook.Add("PlayerSpawnedRagdoll", "PropsHistory", AddPropHistory)