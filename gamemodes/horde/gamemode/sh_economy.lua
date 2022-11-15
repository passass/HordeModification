function HORDE:CanAffordAmmo(item) 
    local wep = weapons.Get(item.class)
    if IsValid(wep) then 
        local wep_max_mags = wep.Horde_MaxMags
    end
end