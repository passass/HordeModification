PERK.PrintName = "Fast Welder"
PERK.Description = [[makes welder faster in slomo like and increase movement speed in real time.]]
PERK.Icon = "perks/welderslomo.png"


function SWEP:SlowMotion_MovementSpeedBonus_Allow(ply)
    local activewep = ply:GetActiveWeapon()
    return IsValid(activewep) and activewep:GetClass() == "hordeext_welder"
end

function SWEP:SlowMotion_MovementSpeedBonus_Bonus(ply)
    return 2
end

