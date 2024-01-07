function HORDE:IsPlayerOrMinion(ent)
    return ent:IsPlayer() or IsValid(ent:GetNWEntity("HordeOwner"))
end

function HORDE:IsPlayerMinion(ent)
    return IsValid(ent:GetNWEntity("HordeOwner"))
end

function HORDE:IsEnemy(ent)
    return ent:IsNPC() and (not ent:IsPlayer()) and (not IsValid(ent:GetNWEntity("HordeOwner")))
end

hook.Add("EntityTakeDamage", "ManhackContactDamage", function (target, dmginfo)
    local inflictor = dmginfo:GetInflictor()
    if !IsValid(inflictor) then return end
    local ply = inflictor:GetNWEntity("HordeOwner")
    if ply:IsPlayer() and inflictor:GetClass() == "npc_manhack" then
        dmginfo:SetDamage(math.max(dmginfo:GetDamage(), inflictor:GetMaxHealth()))
        timer.Simple(0, function() if inflictor:IsValid() then
            if inflictor.Horde_Has_Antimatter_Shield then
                local effectdata = EffectData()
                effectdata:SetOrigin(inflictor:GetPos())
                util.Effect("antimatter_explosion", effectdata)
                if target:GetNWEntity("HordeOwner"):IsValid() then
                    local dd = DamageInfo()
                        dd:SetAttacker(inflictor:GetNWEntity("HordeOwner"))
                        dd:SetInflictor(inflictor:GetNWEntity("HordeOwner"))
                        dd:SetDamageType(DMG_CRUSH)
                        dd:SetDamage(inflictor.Horde_Has_Antimatter_Shield)
                    util.BlastDamageInfo(dd, inflictor:GetPos(), 200)
                end
            end
            if inflictor.Horde_Has_Void_Shield then
                local effectdata = EffectData()
                effectdata:SetOrigin(inflictor:GetPos())
                util.Effect("antimatter_explosion", effectdata)
                if target:GetNWEntity("HordeOwner"):IsValid() then
                    local dd = DamageInfo()
                        dd:SetAttacker(inflictor:GetNWEntity("HordeOwner"))
                        dd:SetInflictor(inflictor:GetNWEntity("HordeOwner"))
                        dd:SetDamageType(DMG_CRUSH)
                        dd:SetDamage(inflictor.Horde_Has_Void_Shield)
                    util.BlastDamageInfo(dd, inflictor:GetPos(), 200)
                end
            end
            inflictor:Remove() end
        end)
    end
end)