function EFFECT:Init(data)	
	local Startpos = data:GetStart()
	if data:GetEntity():IsValid() && Startpos then
		self.Emitter = ParticleEmitter(Startpos)
		for i = 1, 3 do
			local p = self.Emitter:Add("effects/strider_bulge_dudv", Startpos)	
			p:SetDieTime(0.1)
			p:SetStartAlpha(255)
			p:SetEndAlpha(0)
			p:SetStartSize(100)
			p:SetEndSize(25)
			p:SetRoll(math.random(-10, 10))
			p:SetRollDelta(math.random(-10, 10))
			p:SetCollide(true)
			//p:SetVelocity(Startpos:GetNormal() + data:GetAngles():Forward() * (3000) + data:GetAngles():Right() * (195) + data:GetAngles():Up() * (400))
			//p:SetGravity(Vector(0, 0, -50))
		end
		self.Emitter:Finish()
	end
end
		
function EFFECT:Think()
	return false
end

function EFFECT:Render()
end