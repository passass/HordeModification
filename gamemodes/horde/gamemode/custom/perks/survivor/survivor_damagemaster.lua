PERK.PrintName = "Damage Master"
PERK.Description = "{1} increased damage."
PERK.Icon = "materials/perks/fragmentation.png"
PERK.Params = {
    [1] = {value = 0.12, percent = true},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmginfo)
    if not ply:Horde_GetPerk("demolition_fragmentation") then return end
    bonus.increase = bonus.increase + 0.12
end