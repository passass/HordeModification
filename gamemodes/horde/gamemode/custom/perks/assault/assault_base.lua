PERK.PrintName = "Assault Base"
PERK.Description = [[
The Assault class is an all-purpose fighter with high mobility and a focus on Adrenaline stacks.
Complexity: EASY

{1} more movement speed. ({2} per level, up to {3}).
{4} increased Ballistic damage. ({5} per level, up to {6}).
{7} increased reload speed and firerate in slow motion. ({8} per level, up to {9}).
5 slow motion stacks instead of 3.

Gain Adrenaline when you kill an enemy.
Adrenaline increases damage and speed by {10}.]]
PERK.Params = {
    [1] = {percent = true, level = 0.008, max = 0.20, classname = HORDE.Class_Assault},
    [2] = {value = 0.008, percent = true},
    [3] = {value = 0.20, percent = true},
    [4] = {percent = true, level = 0.004, max = 0.1, classname = HORDE.Class_Assault},
    [5] = {value = 0.004, percent = true},
    [6] = {value = 0.1, percent = true},
    [7] = {percent = true, level = .08, max = 2, classname = HORDE.Class_Assault},
    [8] = {value = .08, percent = true},
    [9] = {value = 2, percent = true},
    [10] = {value = 0.06, percent = true},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "assault_base" then
        ply:Horde_SetMaxAdrenalineStack(ply:Horde_GetMaxAdrenalineStack() + 1)
    end
end

--[[PERK.Hooks.Horde_SlowMotion_start_Bonus = HORDE.SlowMotion_Template_RPMandReloadBonus
PERK.Hooks.Horde_SlowMotion_end_Bonus = PERK.Hooks.Horde_SlowMotion_start_Bonus]]

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "assault_base" then
        ply:Horde_SetMaxAdrenalineStack(ply:Horde_GetMaxAdrenalineStack() - 1)
    end
end

PERK.Hooks.Horde_PlayerMoveBonus = function(ply, bonus_walk, bonus_run)
    if not ply:Horde_GetPerk("assault_base") then return end
    bonus_walk.more = bonus_walk.more * ply:Horde_GetPerkLevelBonus("assault_base")
    bonus_run.more = bonus_run.more * ply:Horde_GetPerkLevelBonus("assault_base")
end

PERK.Hooks.SlowMotion_RPMBonus_Allow = function(ply) 
	return ply:Horde_GetPerk("assault_base")
end

PERK.Hooks.SlowMotion_ReloadBonus_Allow = PERK.Hooks.SlowMotion_RPMBonus_Allow



PERK.Hooks.Horde_PrecomputePerkLevelBonus = function (ply)
    if SERVER then
        ply:Horde_SetPerkLevelBonus("assault_base", 1 + math.min(0.20, 0.008 * ply:Horde_GetLevel(HORDE.Class_Assault)))
        ply:Horde_SetPerkLevelBonus("slomo_bonus", math.min(2, 0.08 * ply:Horde_GetLevel(HORDE.Class_Assault)))
    end
end