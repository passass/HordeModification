PERK.PrintName = "Berserker Base"
PERK.Description = [[
The Berserker class is a melee-centered class that can be played both offensively and defensively.
Complexity: HIGH

{1} increased Slashing and Blunt damage. ({2} per level, up to {3}).
{4} increased Global damage resistance. ({5} per level, up to {6}).
{7} increased movement speed in slow motion and attack speed with melee weapons. ({8} per level, up to {9}).

Aerial Parry: Jump to reduce Physical damage taken by {10}.]]
PERK.Params = {
    [1] = {percent = true, level = 0.008, max = 0.20, classname = HORDE.Class_Berserker},
    [2] = {value = 0.008, percent = true},
    [3] = {value = 0.20, percent = true},
    [4] = {percent = true, level = 0.008, max = 0.20, classname = HORDE.Class_Berserker},
    [5] = {value = 0.008, percent = true},
    [6] = {value = 0.20, percent = true},
    [7] = {percent = true, level = .08, max = 2, classname = HORDE.Class_Berserker},
    [8] = {value = .08, percent = true},
    [9] = {value = 2, percent = true},
    [10] = {value = 0.65, percent = true},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "berserker_base" then
        ply:Horde_SetAerialGuardEnabled(1)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "berserker_base" then
        ply:Horde_SetAerialGuardEnabled(0)
    end
end

PERK.Hooks.Horde_SlowMotion_start_Bonus = function(ply, slow_motion_stage, slomo_bonus)
    if not ply:Horde_GetPerk("berserker_base") then return end
    local mult = slow_motion_stage == 1 and 1 or 1 / Lerp((slomo_bonus / 2) * (1 / slow_motion_stage / 3), 1, 3)
    local is_end = slow_motion_stage == 1
    for _, wep in pairs(ply:GetWeapons()) do
        if wep.Base == "arccw_base_melee" then
            wep.Mult_MeleeTime = mult
            wep.TickCache_Mults["Mult_MeleeTime"] = mult
            wep.ModifiedCache["Mult_MeleeTime"] = true
            if !wep.Animations.bash.oldMult  then
                wep.Animations.bash.oldMult = wep.Animations.bash.Mult or 1
            end
            local bash2_is_valid = not not wep.Animations.bash2
            if bash2_is_valid and !wep.Animations.bash2.oldMult then
                wep.Animations.bash2.oldMult = wep.Animations.bash2.Mult or 1
            end
            if !is_end then
                wep.Animations.bash.Mult = wep.Animations.bash.oldMult * mult
                if bash2_is_valid then
                    wep.Animations.bash2.Mult = wep.Animations.bash2.oldMult * mult
                end
            else
                wep.Animations.bash.Mult = wep.Animations.bash.oldMult
                wep.Animations.bash.oldMult = nil
                if bash2_is_valid then
                    wep.Animations.bash2.Mult = wep.Animations.bash2.oldMult
                    wep.Animations.bash2.oldMult = nil
                end
            end
        end
    end
end
--[[PERK.Hooks.Horde_SlowMotion_end_Bonus = PERK.Hooks.Horde_SlowMotion_start_Bonus

PERK.Hooks.Horde_PlayerMoveBonus = HORDE.SlowMotion_Template_SpeedBonus]]

PERK.Hooks.Horde_OnPlayerDamageTaken = function(ply, dmginfo, bonus)
    if not ply:Horde_GetPerk("berserker_base")  then return end
    bonus.resistance = bonus.resistance + ply:Horde_GetPerkLevelBonus("berserker_base")
end

PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmginfo)
    if not ply:Horde_GetPerk("berserker_base") then return end
    if HORDE:IsSlashDamage(dmginfo) or HORDE:IsBluntDamage(dmginfo) then
        bonus.increase = bonus.increase + ply:Horde_GetPerkLevelBonus("berserker_base")
    end
end

PERK.Hooks.Horde_PrecomputePerkLevelBonus = function (ply)
    if SERVER then
        ply:Horde_SetPerkLevelBonus("berserker_base", math.min(0.20, 0.008 * ply:Horde_GetLevel(HORDE.Class_Berserker)))
        ply:Horde_SetPerkLevelBonus("slomo_bonus", math.min(2, 0.08 * ply:Horde_GetLevel(HORDE.Class_Berserker)))
    end
end