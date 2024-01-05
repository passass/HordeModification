function EFFECT:Init(data)
    --local radius = data:GetRadius()

    local emitter = ParticleEmitter(data:GetOrigin())
    local smoke
    local radius = 7
    for i = 1,5 do
        smoke = emitter:Add("particles/smokey", data:GetOrigin())
        smoke:SetGravity(Vector(0,0,-50))
        smoke:SetDieTime(50/225 * math.random(0.9,1.1))
        smoke:SetStartAlpha(150)
        smoke:SetEndAlpha(0)
        smoke:SetStartSize(10)
        smoke:SetEndSize(radius)
        smoke:SetRoll( math.Rand(-180, 180) )
        smoke:SetRollDelta( math.Rand(-1,1) )
        smoke:SetColor(50, 200, 50)
        local p = VectorRand() * radius / 5
        p.z = 0
        smoke:SetPos( data:GetOrigin() + p)
        smoke:SetLighting( false )
        smoke:SetCollide(true)
        smoke:SetBounce(0)
    end
    emitter:Finish()
end

function EFFECT:Think()
return false
end

function EFFECT:Render()
end