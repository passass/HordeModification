HORDE.Ammo_Max = 1000

function HORDE:Ammo_RefillCost(ply, item)
    local wep = ply:GetWeapon(item.class)
    local have_ammo = ply:GetAmmoCount(wep:GetPrimaryAmmoType())
    local maxammo = HORDE:Ammo_GetMaxAmmo(wep)
    if have_ammo >= maxammo then return 0 end
    local onemag_price = item.ammo_price or HORDE.default_ammo_price
    local clip = wep.RegularClipSize or (wep.Primary and wep.Primary.ClipSize) or 1
    return math.ceil((maxammo - have_ammo) / clip * onemag_price)
end

function HORDE:Ammo_RefillOneMagCost(ply, item)
    local total_price = HORDE:Ammo_RefillCost(ply, item)
    local onemag_price = item.ammo_price or HORDE.default_ammo_price
    if total_price > onemag_price then
        return onemag_price
    end
    return total_price
end

function HORDE:Ammo_GetMaxAmmo(wep)
    local total = (wep.RegularClipSize or (wep.Primary and wep.Primary.ClipSize) or 1) * (wep.Horde_MaxMags or 20)
    return total > HORDE.Ammo_Max and HORDE.Ammo_Max or total
end

--[[function HORDE:Ammo_CanAfford(ply, item)
    return ply:Horde_GetMoney() < HORDE:Ammo_RefillCost(ply, item)
end]]