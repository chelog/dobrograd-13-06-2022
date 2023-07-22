ENT.Type = "anim"
ENT.Base = "durgz_base"
ENT.PrintName = "Aspirin"
ENT.Nicknames = {"too many pills", "too many painkillers", "too much aspirin"}
ENT.OverdosePhrase = {"took", "consumed", "gulped down"}
ENT.Author = "The Man"
ENT.Spawnable = true
ENT.AdminSpawnable = true 
ENT.Information	 = "Gets rid of headaches" 
ENT.Category = "Drugs"
if( CLIENT )then

	killicon.Add("durgz_aspirin","killicons/durgz_aspirin_killicon",Color( 255, 80, 0, 255 ))

end
