PERK.PrintName = "Bandolier"
PERK.Description = "Increase {1} maximum Ammos."
PERK.Icon = "entities/att/arccw_uc_tp_overload.png"
PERK.Params = {
    [1] = {value = .5, percent = true},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER then
        HORDE:Modifier_AddToWeapons(ply, "Horde_MaxMags", "swat_bandolier", 1.5)
        HORDE:Modifier_AddToWeapons(ply, "Horde_TotalMaxAmmoMult", "swat_bandolier", 1.5)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER then
        HORDE:Modifier_AddToWeapons(ply, "Horde_MaxMags", "swat_bandolier")
        HORDE:Modifier_AddToWeapons(ply, "Horde_TotalMaxAmmoMult", "swat_bandolier")
        HORDE:Ammo_CheckForValidWorking(ply)
    end
end
