PERK.PrintName = "Overclock"
PERK.Description = "Adds {1} maximum Adrenaline stacks."
PERK.Icon = "materials/perks/overclock.png"
PERK.Params = {
    [1] = {value = 3},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER then
        ply:Horde_SetMaxAdrenalineStack(ply:Horde_GetMaxAdrenalineStack() + 3)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER then
        ply:Horde_SetMaxAdrenalineStack(ply:Horde_GetMaxAdrenalineStack() - 3)
    end
end