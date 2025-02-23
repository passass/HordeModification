HORDE.Ammo_Max = 1000
HORDE.Ammo_DefaultMaxMags = 20

function HORDE:Ammo_CheckForValidWorking(ply) -- CALL FOR CHECK FOR AMMO LIMIT
    local ammos_type = {}
    
    for _, wep in pairs(ply:GetWeapons()) do
        local ammotype = wep:GetPrimaryAmmoType() or wep.Primary and wep.Primary.Ammo
        if !ammotype then continue end
        if !ammos_type[ammotype] then
            ammos_type[ammotype] = {}
        end

        local clipsize = (wep.RegularClipSize or (wep.Primary and wep.Primary.ClipSize) or 1)

        table.insert(ammos_type[ammotype], HORDE:Ammo_GetMaxAmmo(wep) + math.max(0, clipsize - wep:Clip1()))
    end

    for ammotype, maxammos in pairs(ammos_type) do
        local MaxAmmoForTypeOfAmmo = 0
        for _, maxammo in pairs(maxammos) do
            MaxAmmoForTypeOfAmmo = math.max(maxammo, MaxAmmoForTypeOfAmmo)
        end
        ply:SetAmmo(math.min(ply:GetAmmoCount(ammotype), MaxAmmoForTypeOfAmmo), ammotype)
    end
end

function HORDE:Ammo_RemainToFillAmmo(wep) -- AMMO ENOUGH TO FULL REFILL
    local clipsize = wep.RegularClipSize or (wep.Primary and wep.Primary.ClipSize) or 1
    return math.max(0, HORDE:Ammo_GetMaxAmmo(wep) +
        math.max(0, clipsize - wep:Clip1()) - wep:GetOwner():GetAmmoCount(wep:GetPrimaryAmmoType()))
end

function HORDE:Ammo_RemainToFillAmmo_Secondary(wep) -- AMMO ENOUGH TO FULL REFILL
    local clipsize
    local clip2 = wep:Clip2()
    local ammo_type
    if wep.ArcCW then
        ammo_type = wep:GetBuff_Override("UBGL_Ammo")
        clipsize = wep:GetBuff_Override("UBGL_Capacity")
    else
        clipsize = wep.RegularClipSize or (wep.Secondary and wep.Secondary.ClipSize) or 1
        ammo_type = wep:GetSecondaryAmmoType()
    end
    return math.max(0, HORDE:Ammo_GetMaxAmmo_Secondary(wep) +
        math.max(0, clipsize - clip2) - wep:GetOwner():GetAmmoCount(ammo_type))
end

function HORDE:Ammo_RefillCost(ply, item) -- REFILL ALL
    local wep = ply:GetWeapon(item.class)
    local tofillammo = HORDE:Ammo_RemainToFillAmmo(wep)
    if tofillammo <= 0 then return 0 end
    local onemag_price = item.ammo_price or HORDE.default_ammo_price
    local clip = wep.RegularClipSize or (wep.Primary and wep.Primary.ClipSize) or 1
    if clip == -1 then clip = 1 end
    return math.ceil(tofillammo / clip * onemag_price)
end

function HORDE:Ammo_RefillOneMagCost(ply, item) -- REFILL ONE MAG
    local total_price = HORDE:Ammo_RefillCost(ply, item)
    local onemag_price = item.ammo_price or HORDE.default_ammo_price
    if total_price > onemag_price then
        return onemag_price
    end
    return total_price
end

function HORDE:Ammo_GetMaxAmmo(wep) -- MAX AMMO ON WEAPON
    local total
    if wep.Primary and wep.Primary.MaxAmmo then
        total = wep.Primary.MaxAmmo
    else
        local clipsize = wep.RegularClipSize or (wep.Primary and wep.Primary.ClipSize) or 1
        if clipsize == -1 then
            return 50
        end
        total = clipsize * (wep.Horde_MaxMags or HORDE.Ammo_DefaultMaxMags)
    end
    return math.min(HORDE:Ammo_GetTotalLimit(wep), total)
end

function HORDE:Ammo_GetMaxAmmo_Secondary(wep) -- MAX AMMO ON WEAPON
    local max_mags = wep.Horde_MaxMags_Secondary
    local clipsize
    local total
    if wep.Secondary and wep.Secondary.MaxAmmo then
        total = wep.Secondary.MaxAmmo
    else
        if wep.ArcCW then
            clipsize = wep:GetBuff_Override("UBGL_Capacity")
        else
            clipsize = (wep.Secondary and wep.Secondary.ClipSize) or 1
            if clipsize == -1 then
                clipsize = 1
            end
        end

        if !max_mags then
            return clipsize * HORDE.Ammo_DefaultMaxMags--HORDE:Ammo_GetTotalLimit(wep)
        end

        total = clipsize * max_mags
    end
    
    return math.min(HORDE:Ammo_GetTotalLimit(wep), total)
end

function HORDE:Ammo_GetTotalLimit(wep) -- TOTAL LIMIT
    return math.Round(HORDE.Ammo_Max * (wep.ArcCW and wep:GetBuff_Mult("Horde_TotalMaxAmmoMult") or wep.Horde_TotalMaxAmmoMult or 1))
end

--[[function HORDE:Ammo_CanAfford(ply, item)
    return ply:Horde_GetMoney() < HORDE:Ammo_RefillCost(ply, item)
end]]