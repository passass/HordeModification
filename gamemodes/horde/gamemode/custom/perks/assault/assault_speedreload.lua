PERK.PrintName = "Charge"
PERK.Description = "Adds {1} Speed Reload."
PERK.Icon = "entities/acwatt_perk_fastreload.png"
PERK.Params = {
    [1] = {value = 0.2, percent=true},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "assault_speedreload" then
        HORDE:Modifier_AddToWeapons(ply, "Mult_ReloadTime", "assault_speedreload", 0.8)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "assault_speedreload" then
        HORDE:Modifier_AddToWeapons(ply, "Mult_ReloadTime", "assault_speedreload")
    end
end