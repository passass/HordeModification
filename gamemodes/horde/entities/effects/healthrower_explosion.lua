function EFFECT:Init(data)
    local owner = data:GetEntity()
    local light = DynamicLight(0);
    if(light) then
        light.R = 32
        light.G = 30
        light.B = 139
        light.Pos = data:GetOrigin()
        light.Size = 128
        light.Decay = 64
        light.Brightness = 3
        light.DieTime = CurTime()+1
    end

    local DrawFlame = 1

    if DrawFlame == 1 then

        local FlameEmitter = ParticleEmitter(data:GetOrigin())

        for i=0, 16 do
            if !FlameEmitter then return end
            local FlameParticle = FlameEmitter:Add("particles/healthrowerlet" .. math.random(1, 5), data:GetOrigin() )

            if (FlameParticle) then

                FlameParticle:SetColor( 32, 30, 139 )

                FlameParticle:SetVelocity( VectorRand() * 172 )

                FlameParticle:SetLifeTime(0)
                FlameParticle:SetDieTime(0.72)

                FlameParticle:SetStartAlpha(210)
                FlameParticle:SetEndAlpha(0)

                FlameParticle:SetStartSize(0)
                FlameParticle:SetEndSize(64 * (data:GetScale() or 1))

                FlameParticle:SetRoll(math.Rand(-210, 210))
                FlameParticle:SetRollDelta(math.Rand(-3.2, 3.2))

                FlameParticle:SetAirResistance(350)

                FlameParticle:SetGravity(Vector(0, 0, 64))

            end
        end

        FlameEmitter:Finish()
    end
end

function EFFECT:Think()
return false
end

function EFFECT:Render()
end