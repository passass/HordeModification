PERK.PrintName = "Charge"
PERK.Description = "Adds {1} Speed Reload."
PERK.Icon = "entities/acwatt_perk_fastreload.png"
PERK.Params = {
    [1] = {value = 0.2, percent=true},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "assault_speedreload" then
        HORDE.Weapons_MultReloadSpeed_Add(ply, perk, 1.2)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "assault_speedreload" then
        HORDE.Weapons_MultReloadSpeed_Add(ply, perk)
    end
end