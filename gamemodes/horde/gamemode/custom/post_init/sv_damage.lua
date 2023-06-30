function HORDE:ApplyDamageUpgradewpnDamage(ply, bonus, dmginfo)
    local wpn = HORDE:GetCurrentWeapon(dmginfo:GetInflictor())
    if IsValid(wpn) then
        local level = ply:Horde_GetUpgrade(wpn:GetClass())
        if level and level > 0 then
            local item = HORDE.items[wpn:GetClass()]

            local damage_mult
            if item.entity_properties.upgrade_damage_mult_incby then
                damage_mult = item.entity_properties.upgrade_damage_mult_incby
            elseif item.starter_classes then
                -- Bonus damage to starter weapons
                damage_mult = 0.1
            else
                damage_mult = 0.03
            end

            bonus.more = bonus.more * (1 + damage_mult * level)
        end
    end
end

function HORDE:ApplyDamage(npc, hitgroup, dmginfo)
    if dmginfo:GetDamageCustom() > 0 then return end
    if dmginfo:GetDamage() <= 0 then return end
    if not npc:IsValid() then return end
    if GetConVar("horde_corpse_cleanup"):GetInt() == 1 and npc:Health() <= 0 then npc:Remove() return end

    local attacker = dmginfo:GetAttacker()
    if not IsValid(attacker) then return end

    if attacker:GetNWEntity("HordeOwner"):IsPlayer() then
        dmginfo:SetInflictor(attacker)
        dmginfo:SetAttacker(attacker:GetNWEntity("HordeOwner"))
    end

    if IsValid(attacker:GetOwner()) and attacker:GetOwner():IsPlayer() then
        dmginfo:SetAttacker(attacker:GetOwner())
    end

    local ply = dmginfo:GetAttacker()
    if not ply:IsPlayer() then return end

    local increase = 0
    local more = 1
    local base_add = 0
    local post_add = 0
    --dmginfo:SetDamage(1000)
    --npc:Horde_AddDebuffBuildup(HORDE.Status_Stun, dmginfo:GetDamage() * 10, ply, dmginfo:GetDamagePosition())

    -- Apply bonus
    local bonus = {increase=increase, more=more, base_add=base_add, post_add=post_add}
    HORDE:ApplyDamageUpgradewpnDamage(ply, bonus, dmginfo)
    local res = hook.Run("Horde_OnPlayerDamagePre", ply, npc, bonus, hitgroup, dmginfo)
    if res then
        dmginfo:AddDamage(bonus.base_add)
        dmginfo:ScaleDamage(bonus.more * (1 + bonus.increase))
        dmginfo:AddDamage(bonus.post_add)
        dmginfo:SetDamageCustom(HORDE.DMG_CALCULATED)
        if hitgroup == HITGROUP_HEAD then
            sound.Play("horde/player/headshot.ogg", npc:GetPos())
        end
        return
    end
    hook.Run("Horde_OnPlayerDamage", ply, npc, bonus, hitgroup, dmginfo)
    if dmginfo:GetInflictor():GetNWEntity("HordeOwner"):IsPlayer() then
        hook.Run("Horde_OnPlayerMinionDamage", ply, npc, bonus, dmginfo)
    end

    -- DMG_BURN for some reason does not apply, convert this to something else
    if dmginfo:GetInflictor():GetClass() == "entityflame" then
        dmginfo:SetDamagePosition(npc:GetPos())
        dmginfo:SetDamage(npc:Horde_GetIgniteDamageTaken())
    else
        if dmginfo:GetDamageType() == DMG_BURN then
            dmginfo:SetDamageType(DMG_SLOWBURN)
            if ply:Horde_GetGadget() ~= "gadget_hydrogen_burner" then
                npc:Horde_SetMostRecentFireAttacker(ply, dmginfo)
                npc:Ignite(ply:Horde_GetApplyIgniteDuration())
            end
        elseif ply:Horde_GetApplyIgniteChance() > 0 then
            local ignite = math.random()
            if ignite <= ply:Horde_GetApplyIgniteChance() then
                if ply:Horde_GetGadget() ~= "gadget_hydrogen_burner" then
                    npc:Horde_SetMostRecentFireAttacker(ply, dmginfo)
                    npc:Ignite(ply:Horde_GetApplyIgniteDuration())
                end
            end
        end
    end

    dmginfo:AddDamage(bonus.base_add)
    dmginfo:ScaleDamage(bonus.more * (1 + bonus.increase))
    dmginfo:AddDamage(bonus.post_add)
    dmginfo:SetDamageCustom(HORDE.DMG_CALCULATED)

    -- Vortigaunt damage
    if HORDE:IsLightningDamage(dmginfo) and dmginfo:GetInflictor():GetClass() == "npc_vortigaunt" then
        -- Splash damaage
        local dmg = DamageInfo()
        dmg:SetAttacker(dmginfo:GetAttacker())
        dmg:SetInflictor(dmginfo:GetInflictor())
        dmg:SetDamageType(DMG_PLASMA)
        dmg:SetDamage(dmginfo:GetDamage())
        dmg:SetDamageCustom(HORDE.DMG_SPLASH)
        util.BlastDamageInfo(dmg, dmginfo:GetDamagePosition(), 250)
    end

    -- Play sound
    if hitgroup == HITGROUP_HEAD then
        sound.Play("horde/player/headshot.ogg", npc:GetPos())
    end

    hook.Run("Horde_OnPlayerDamagePost", ply, npc, bonus, hitgroup, dmginfo)
    
    if not npc.Horde_Assist then
        npc.Horde_Assist = ply
    elseif ply ~= npc.Horde_Hit then
        npc.Horde_Assist = npc.Horde_Hit
    end

    npc.Horde_Hit = ply
end

