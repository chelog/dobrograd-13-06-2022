local function randn(x)
	return math.Rand(-x, x);
end
function EFFECT:Init(data)
	local e = ParticleEmitter( data:GetOrigin() );
		for i=1, 10 do
			--declare variablez
			local smokesize = 1;
			local pos = Vector(randn(1), randn(1), randn(smokesize) + 60);
			local p = e:Add( "particle/particle_smokegrenade", data:GetOrigin() + pos );
			if (p) then
				local gravsideways = randn(0.1);
				local shade = math.random(220,240);
				--set the stuff
				p:SetVelocity(VectorRand() * math.Rand(2000,2300));
				
				p:SetLifeTime(0);
				p:SetDieTime(math.Rand(3,4));
				
				p:SetColor(shade,shade,shade);
				p:SetStartAlpha(math.Rand(160,180));
				p:SetEndAlpha(0);
				
				p:SetStartSize(math.Rand(20,25));
				p:SetEndSize(math.Rand(10, 15));
				
				p:SetRoll(math.Rand(-180, 180));
				p:SetRollDelta(math.Rand(-0.2,0.2));
				
				p:SetAirResistance(math.Rand(520,620));
				p:SetGravity(   Vector( gravsideways, gravsideways, math.Rand(-60, -80) )	);

				p:SetCollide( true );
				p:SetBounce( 0.42 );

				p:SetLighting(1);
			end
		end
		
	e:Finish()
	
end

function EFFECT:Think( )
	return false
end
function EFFECT:Render()
end

