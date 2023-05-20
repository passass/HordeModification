PERK.PrintName = "OverClip"
PERK.Description = "Increase {1} maximum Clipsize."
PERK.Icon = "entities/att/arccw_uc_tp_overload.png"
PERK.Params = {
    [1] = {value = .33, percent = true},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "swat_extendedclipsize" then
        HORDE:Modifier_AddToWeapons(ply, "Mult_ClipSize", "swat_extendedclipsize", 1 + 1 / 3)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "swat_extendedclipsize" then
        HORDE:Modifier_AddToWeapons(ply, "Mult_ClipSize", "swat_extendedclipsize")
    end
end