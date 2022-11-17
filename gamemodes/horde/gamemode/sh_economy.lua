function HORDE:CanAffordAmmo(item) 
    local wep = weapons.Get(item.class)
    if IsValid(wep) then 
        local wep_max_mags = wep.Horde_MaxMags
    end
end

function HORDE:IsItemPlacable(item)
    return item.entity_properties.type == HORDE.ENTITY_PROPERTY_WPN and item.entity_properties.wep_that_place or item.entity_properties.type == HORDE.ENTITY_PROPERTY_DROP
end