PERK.PrintName = "Survivor Base"
PERK.Description = [[The Survivor class can be played into any class to fill in missing roles for the team.\nComplexity: EASY.

{1} increased reload speed and movement speed in slow motion. ({2} per level, up to {3})
]]

PERK.Params = {
    [1] = {percent = true, level = .08, max = 2, classname = HORDE.Class_Survivor},
    [2] = {value = .08, percent = true},
    [3] = {value = 2, percent = true},
}

PERK.Hooks = {}
--[[PERK.Hooks.Horde_SlowMotion_start_Bonus = HORDE.SlowMotion_Template_ReloadBonus
PERK.Hooks.Horde_SlowMotion_end_Bonus = PERK.Hooks.Horde_SlowMotion_start_Bonus
PERK.Hooks.Horde_PlayerMoveBonus = HORDE.SlowMotion_Template_SpeedBonus]]

PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "survivor_base" then
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "survivor_base" then
    end
end

PERK.Hooks.SlowMotion_ReloadBonus_Allow = function(ply)
	return ply:Horde_GetPerk("survivor_base")
end

PERK.Hooks.SlowMotion_MovementSpeedBonus_Allow = PERK.Hooks.SlowMotion_ReloadBonus_Allow

PERK.Hooks.Horde_PrecomputePerkLevelBonus = function (ply)
    if SERVER then
        ply:Horde_SetPerkLevelBonus("slomo_bonus", math.min(2, 0.08 * ply:Horde_GetLevel(HORDE.Class_Survivor)))
    end
end