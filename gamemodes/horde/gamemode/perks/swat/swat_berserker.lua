PERK.PrintName = "Berserker"
PERK.Description = "{1} increased maximum health."
PERK.Icon = "materials/perks/berserk.png"
PERK.Params = {
    [1] = {value = 0.25, percent = true},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnSetMaxHealth = function(ply, bonus)
    if SERVER and ply:Horde_GetPerk("berserker_savagery") then
        bonus.increase = bonus.increase + 0.25
    end
end
