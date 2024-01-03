function HORDE:IsPlayerOrMinion(ent)
    return ent:IsPlayer() or IsValid(ent:GetNWEntity("HordeOwner"))
end

function HORDE:IsPlayerMinion(ent)
    return IsValid(ent:GetNWEntity("HordeOwner"))
end

function HORDE:IsEnemy(ent)
    return ent:IsNPC() and (not ent:IsPlayer()) and (not IsValid(ent:GetNWEntity("HordeOwner")))
end