AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "drug_ent"

ENT.PrintName = L.volatile -- dont change anything here except for this name
ENT.Author = "LegendofRobbo"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Drugmod"

ENT.Spawnable = true


---------------- EDIT THIS STUFF FOR CUSTOM DRUGS ----------------
ENT.DrugModel = "models/cocn.mdl"
ENT.DrugModelColor = Color(255,255,255)
ENT.DrugSound = "player/suit_sprint.wav" -- the sound the drug makes when you use it
ENT.DrugEffect = "Volatile" -- what effect it gives you
ENT.DrugTime = 120 -- how much effect duration it gives you, effect duration can stack with multiple doses
-- clientside only
ENT.DrugColor = Color(255,75,55) -- the colour of the title text
ENT.DrugDescription = L.description_volatile -- its description, remember to use newline (/n) to make multiple lines
ENT.DrugLegal = false -- is this a counterfeit drug or an over-the-counter pharmacy drug
------------------------------------------------------------------




---------------- DONT MESS WITH THIS UNLESS YOU KNOW HOW TO CODE ----------------
if SERVER then

function ENT:Initialize()
	self:SetModel( self.DrugModel )
 	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
 	self:SetColor( self.DrugModelColor )
	self:SetUseType( SIMPLE_USE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local PhysAwake = self:GetPhysicsObject()
	if ( PhysAwake:IsValid() ) then
		PhysAwake:Wake()
	end 
	self.HP = 30
	self.ded = false
end

function ENT:Use( activator, caller )
if activator:HasBuff( "Overdose" ) then return end
if self:IsOnFire() then return end
activator:AddBuff( self.DrugEffect, self.DrugTime )
activator:EmitSound(self.DrugSound, 75, 100)
self:Remove()
end

function ENT:OnTakeDamage( dmg )
	local dm = dmg:GetDamage()
	local atk = dmg:GetAttacker()
	self:TakePhysicsDamage( dmg )

	if self:WaterLevel() > 1 then return end
	
	self.HP = self.HP - dm
	if self.HP < 1 and !self.ded then
	if atk:IsValid() and atk:IsPlayer() then self.Killer = atk end
	self:Ignite( 4 )
	self.ded = true
	timer.Simple( math.Rand( 2.7, 3.3 ) , function() 
		if self:IsValid() then
				if self:WaterLevel() > 1 then self:Extinguish() self.ded = false self.HP = 15 return end
				util.BlastDamage( self, self.Killer, self:GetPos(), 350, 125 )

				local effectdata = EffectData()
					effectdata:SetOrigin(self:GetPos())
				util.Effect("Explosion", effectdata)
		 	self:Remove() 
		end 
		end)
	end
end


end