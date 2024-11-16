function HORDE:CreateFloorFire(wep, hitpos, floordistance)
    local owner = wep:GetOwner()
    if !owner or !IsValid(owner) then
        owner = wep.Owner
    end

    if !owner then
        return
    end


    local filter = {wep, owner}

    floordistance = floordistance or 25

    for i = 1, 3 do
        local tr = util.TraceHull({
            start = hitpos,
            endpos = hitpos - Vector(0, 0, floordistance),
            filter = filter
        })

        if tr.Hit then

            if tr.Entity and IsValid(tr.Entity) and tr.Entity:IsNPC() then
                table.insert(filter, tr.Entity)
                continue
            end

            local another_fire_around = NULL
            
            --ents.FindInSphere(tr.HitPos, 40)

            for _, ent2 in pairs(ents.FindInBox(Vector(tr.HitPos - Vector(40, 40, 10)), Vector(tr.HitPos + Vector(40, 40, 10)))) do
                if ent2:GetClass() == "arccw_hordeext_firebug_fire" then
                    another_fire_around = ent2
                    break
                end
            end

            if IsValid(another_fire_around) then
                another_fire_around:FillFireTimer()
                break
            end

            local ent = ents.Create("arccw_hordeext_firebug_fire")
            ent:SetOwner(owner)
            ent:SetPos(tr.HitPos)
            ent:Spawn()
        else
            break
        end
    end
end