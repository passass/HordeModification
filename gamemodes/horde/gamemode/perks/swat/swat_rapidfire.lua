PERK.PrintName = "Rapid Fire"
PERK.Description = "Increase {1} FireRate."
PERK.Icon = "perks/rapidfire.png"
PERK.Params = {
    [1] = {value = .2, percent = true},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "swat_rapidfire" then
        HORDE:Modifier_AddToWeapons(ply, "Mult_RPM", "swat_rapidfire", 1.2)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "swat_rapidfire" then
        HORDE:Modifier_AddToWeapons(ply, "Mult_RPM", "swat_rapidfire")
    end
end
