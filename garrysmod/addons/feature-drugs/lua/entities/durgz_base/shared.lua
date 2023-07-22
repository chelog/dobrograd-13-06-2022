DURGZ_HUD_FONT = "Trebuchet24"




ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Drugz"
ENT.Nicknames = {"Drugz"}
ENT.OverdosePhrase = {"took"}
ENT.Author = "God"
ENT.Category = "Drugs"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Information	 = "" 



ENT.TRANSITION_TIME = 0

if(CLIENT)then
	DURGZ_LOST_VIRGINITY = false;
	
	usermessage.Hook("durgz_lose_virginity", function(um)
		DURGZ_LOST_VIRGINITY = true;
	end)
	function ENT:Initialize()
	end


	function ENT:Draw()
		self:DrawModel()
	end

 	 
	usermessage.Hook( "PlayerKilledByDrug", function( message )

		local victim 	= message:ReadEntity(); 
		local inflictor	= message:ReadString();
		
		GAMEMODE:AddDeathNotice( "", -1, inflictor, victim:Name(), victim:Team() ) 

	end) 

end
