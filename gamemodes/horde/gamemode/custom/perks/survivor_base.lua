PERK.PrintName = "Survivor Base"
PERK.Description = [[The Survivor class can be played into any class to fill in missing roles for the team.\nComplexity: EASY.

{damageincrease1} increased damage. ({damageincrease2} per level, up to {damageincrease3}).
{movement1} more movement speed. ({movement2} per level, up to {movement3}).
{slomo1} increased reload speed and movement speed in slow motion. ({slomo2} per level, up to {slomo3}).
]]

PERK.Params = {

    movement1 = {percent = true, level = .004, max = .1, classname = HORDE.Class_Survivor},
    movement2 = {value = .004, percent = true},
    movement3 = {value = .1, percent = true},

    damageincrease1 = {percent = true, level = .0024, max = .06, classname = HORDE.Class_Survivor},
    damageincrease2 = {value = .0024, percent = true},
    damageincrease3 = {value = .06, percent = true},

    slomo1 = {percent = true, level = .08, max = 2, classname = HORDE.Class_Survivor},
    slomo2 = {value = .08, percent = true},
    slomo3 = {value = 2, percent = true},
}

PERK.Hooks = {}
--[[PERK.Hooks.Horde_SlowMotion_start_Bonus = HORDE.SlowMotion_Template_ReloadBonus
PERK.Hooks.Horde_SlowMotion_end_Bonus = PERK.Hooks.Horde_SlowMotion_start_Bonus
PERK.Hooks.Horde_PlayerMoveBonus = HORDE.SlowMotion_Template_SpeedBonus]]

PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER then

    end
end

PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmginfo)
    if not ply:Horde_GetPerk("survivor_base") then return end
    if HORDE:IsBlastDamage(dmginfo) then
        bonus.increase = bonus.increase + ply:Horde_GetPerkLevelBonus("survivor_damagebonus")
    end
end

PERK.Hooks.Horde_PlayerMoveBonus = function(ply, bonus_walk, bonus_run)
    if not ply:Horde_GetPerk("survivor_base") then return end
    bonus_walk.more = bonus_walk.more * ply:Horde_GetPerkLevelBonus("survivor_movementbonus")
    bonus_run.more = bonus_run.more * ply:Horde_GetPerkLevelBonus("survivor_movementbonus")
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER then

    end
end

PERK.Hooks.SlowMotion_ReloadBonus_Allow = function(ply)
	return true
end

PERK.Hooks.SlowMotion_MovementSpeedBonus_Allow = PERK.Hooks.SlowMotion_ReloadBonus_Allow

PERK.Hooks.Horde_PrecomputePerkLevelBonus = function (ply)
    if SERVER then
        ply:Horde_SetPerkLevelBonus("slomo_bonus", math.min(2, 0.08 * ply:Horde_GetLevel(HORDE.Class_Survivor)))
        ply:Horde_SetPerkLevelBonus("survivor_damagebonus", math.min(.06, 0.0024 * ply:Horde_GetLevel(HORDE.Class_Survivor)))
        ply:Horde_SetPerkLevelBonus("survivor_movementbonus", math.min(1.1, 1 + 0.004 * ply:Horde_GetLevel(HORDE.Class_Survivor)))
    end
end