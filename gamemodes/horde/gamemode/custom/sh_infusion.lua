function HORDE:GetCurrentWeapon(inflictor)
    local curr_weapon = inflictor
    if inflictor:IsPlayer() then
        curr_weapon = inflictor:GetActiveWeapon()
    elseif IsValid(inflictor.Inflictor) and inflictor.Inflictor:IsWeapon() then
        curr_weapon = inflictor.Inflictor
    end
    return curr_weapon
end
