PERK.PrintName = "Berserker Base"
PERK.Description = [[
The Berserker class is a melee-centered class that can be played both offensively and defensively.
Complexity: HIGH

{1} increased Slashing and Blunt damage. ({2} per level, up to {3}).
{4} increased Global damage resistance. ({5} per level, up to {6}).
{slomo1} increased movement speed in slow motion and attack speed with melee weapons. ({slomo2} per level, up to {slomo3}).

Aerial Parry: Jump to reduce Physical damage taken by {10}.]]
PERK.Params = {
    [1] = {percent = true, level = 0.008, max = 0.20, classname = HORDE.Class_Berserker},
    [2] = {value = 0.008, percent = true},
    [3] = {value = 0.20, percent = true},
    [4] = {percent = true, level = 0.008, max = 0.20, classname = HORDE.Class_Berserker},
    [5] = {value = 0.008, percent = true},
    [6] = {value = 0.20, percent = true},
    [10] = {value = 0.65, percent = true},

    slomo1 = {percent = true, level = .08, max = 2, classname = HORDE.Class_Berserker},
    slomo2 = {value = .08, percent = true},
    slomo3 = {value = 2, percent = true},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER then
        ply:Horde_SetAerialGuardEnabled(1)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER then
        ply:Horde_SetAerialGuardEnabled(0)
    end
end

PERK.Hooks.SlowMotion_MovementSpeedBonus_Allow = function(ply)
	return true
end

PERK.Hooks.SlowMotion_MeleeAttackSpeedBonus_Allow = PERK.Hooks.SlowMotion_MovementSpeedBonus_Allow

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