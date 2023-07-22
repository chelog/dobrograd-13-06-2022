ENT.Type 		= 'anim'
ENT.Base 		= 'base_gmodentity'
ENT.PrintName	= 'Радио'
ENT.Category	= L.dobrograd
ENT.Author		= 'Wani4ka'
ENT.Contact		= '4wk@wani4ka.ru'
ENT.Spawnable	= true

ENT.Model		= 'models/props/cs_office/radio.mdl'

function ENT:GetVolume()
	return self:GetNetVar('volume', 0.2)
end

function ENT:GetDistance()
	return self:GetNetVar('dist', 600)
end

function ENT:GetStreamURL()
	return self:GetNetVar('stream')
end
