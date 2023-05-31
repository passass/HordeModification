PERK.PrintName = "Rapid Fire"
PERK.Description = [[Increase {1} FireRate.
Deacrease {2} Recoil.]]
PERK.Icon = "perks/rapidfire.png"
PERK.Params = {
    [1] = {value = .2, percent = true},
    [2] = {value = .1, percent = true},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER then
        HORDE:Modifier_AddToWeapons(ply, "Mult_RPM", "swat_rapidfire", 1.2)
        HORDE:Modifier_AddToWeapons(ply, "Mult_Recoil", "swat_rapidfire", 0.9)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER then
        HORDE:Modifier_AddToWeapons(ply, "Mult_RPM", "swat_rapidfire")
        HORDE:Modifier_AddToWeapons(ply, "Mult_Recoil", "swat_rapidfire")
    end
end
