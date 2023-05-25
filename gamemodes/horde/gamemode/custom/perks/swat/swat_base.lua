PERK.PrintName = "SWAT Base"
PERK.Description = [[
The SWAT is a high combat capability class.
Complexity: EASY

{1} Equip and holster weapon faster. ({2} per level, up to {3}).
{4} Faster reload speed. ({5} per level, up to {6}).
{slomo1} increased reload speed and firerate in slow motion. ({slomo2} per level, up to {slomo3}).
]]
PERK.Params = {
    [1] = {percent = true, level = 0.04, max = 1, classname = HORDE.Class_SWAT},
    [2] = {value = 0.04, percent = true},
    [3] = {value = 1, percent = true},

    [4] = {percent = true, level = 0.01, max = .25, classname = HORDE.Class_SWAT},
    [5] = {value = 0.01, percent = true},
    [6] = {value = .25, percent = true},

    slomo1 = {percent = true, level = .08, max = 2, classname = HORDE.Class_SWAT},
    slomo2 = {value = .08, percent = true},
    slomo3 = {value = 2, percent = true},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER then
        HORDE:Modifier_AddToWeapons(ply, "Mult_DrawTime", "swat_base")
        HORDE:Modifier_AddToWeapons(ply, "Mult_ReloadTime", "swat_base")
    end
end

PERK.Hooks.SlowMotion_RPMBonus_Allow = function(ply)
	return true
end

PERK.Hooks.SlowMotion_ReloadBonus_Allow = PERK.Hooks.SlowMotion_RPMBonus_Allow


PERK.Hooks.Horde_PrecomputePerkLevelBonus = function (ply)
    if SERVER then
        ply:Horde_SetPerkLevelBonus("swat_base", 1 + math.min(1, 0.04 * ply:Horde_GetLevel("SWAT")))
        ply:Horde_SetPerkLevelBonus("slomo_bonus", math.min(2, 0.08 * ply:Horde_GetLevel("SWAT")))
        HORDE:Modifier_AddToWeapons(ply, "Mult_DrawTime", "swat_base", 1 / ply:Horde_GetPerkLevelBonus("swat_base"))
        HORDE:Modifier_AddToWeapons(ply, "Mult_ReloadTime", "swat_base", 1 / ( 1 + math.min(25, ply:Horde_GetLevel("SWAT")) / 100 ))
    end
end