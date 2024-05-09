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

function HORDE:ApplyTemporaryDamage(ply, wep, npc, dmginfo, data)
    --[[if npc.Horde_TemporaryDamage_TakenThisTick then
        npc.Horde_TemporaryDamage_TakenThisTick = nil
        return
    end]]
    if !npc.Horde_TemporaryDamage_Table then
        npc.Horde_TemporaryDamage_Table = {}
    end
    data = data or wep.Horde_AfterHitEffects

    local damage_type = data.Damage_Type
    local damage = data.Damage
    local delay = data.Delay
    local damage_times = data.Damage_Times

    local dmginfo_temp = DamageInfo()
    dmginfo_temp:SetDamage(damage)
    dmginfo_temp:SetDamageType(damage_type)
    dmginfo_temp:SetAttacker(ply)
    dmginfo_temp:SetInflictor(wep)

    local pos_relative = data.Fixed_Pos_Relative or dmginfo:GetDamagePosition() - npc:GetPos()
    local TEMP_KEYS = table.GetKeys(npc.Horde_TemporaryDamage_Table)
    local temp_damage_id = (TEMP_KEYS[table.Count(TEMP_KEYS)] or 0) + 1
    local timername
    local timer_obj

    if data.OnlyOneDamageFromWeapon then
        timername = "Horde_TempDamage_" .. npc:EntIndex() .. "_" .. wep:EntIndex()
        timer_obj = HORDE.Timers:Find(timername)
        if timer_obj then
            timer_obj:SetRepetitionsEnough(damage_times + 1)
            timer_obj:UpdateTimer()
            return
        end
    else
        timername = "Horde_TempDamage_" .. npc:EntIndex() .. "_" .. temp_damage_id
    end

    timer_obj = HORDE.Timers:New({
        linkwithent = npc,
        timername = timername,
        repetitions = damage_times,
        OnTimerRepetitionsFinish = function()
            table.RemoveByValue(npc.Horde_TemporaryDamage_Table, timer_obj)
        end,
        OnRemove = function()
            table.RemoveByValue(npc.Horde_TemporaryDamage_Table, timer_obj)
        end,
        func = function(timerobj)
            if npc:Health() > 0 then
                dmginfo_temp:SetDamagePosition(npc:GetPos() + pos_relative)
                npc:TakeDamageInfo(dmginfo_temp)
                return
            end
            timerobj:Remove()
        end,
        delay = delay
    }, true)

    table.insert(npc.Horde_TemporaryDamage_Table, timer_obj)
end

hook.Add("ScaleNPCDamage", "Horde_ApplyDamage", function (npc, hitgroup, dmginfo)
    if (not HORDE:IsPlayerMinion(npc)) then
        if hitgroup == HITGROUP_KFHEAD then hitgroup = HITGROUP_HEAD end
        HORDE:ApplyDamage(npc, hitgroup, dmginfo)
    end
end)

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
    local entity_Owner = dmginfo:GetInflictor():GetNWEntity("HordeOwner")
    if IsValid(entity_Owner) and entity_Owner:IsPlayer() then
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

