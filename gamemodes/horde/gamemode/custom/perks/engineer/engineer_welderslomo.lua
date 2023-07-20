PERK.PrintName = "Fast Welder"
PERK.Description = [[makes welder faster in slomo like and increase movement speed while you hold welder in real time.]]
PERK.Icon = "perks/welderslomo.png"

PERK.Hooks = {}

PERK.Hooks.SlowMotion_MovementSpeedBonus_Allow = function(ply)
	local activewep = ply:GetActiveWeapon()
    return IsValid(activewep) and activewep:GetClass() == "hordeext_welder"
end

PERK.Hooks.SlowMotion_MovementSpeedBonus_Bonus = function(ply)
	return 2
end

