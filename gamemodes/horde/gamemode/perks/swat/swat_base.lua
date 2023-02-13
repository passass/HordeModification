PERK.PrintName = "Assault Base"
PERK.Description = [[
The SWAT is a high combat capability class.
Complexity: EASY

{1} Equip weapon faster. ({2} per level, up to {3}).
{4} increased reload speed and firerate in slow motion. ({5} per level, up to {6}).
]]
PERK.Params = {
    [1] = {percent = true, level = 0.02, max = 0.5, classname = HORDE.Class_SWAT},
    [2] = {value = 0.02, percent = true},
    [3] = {value = 0.5, percent = true},
    [4] = {percent = true, level = .08, max = 2, classname = HORDE.Class_SWAT},
    [5] = {value = .08, percent = true},
    [6] = {value = 2, percent = true},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "swat_base" then
        HORDE:Modifier_AddToWeapons(ply, "Mult_DrawTime", "assault_base")
    end
end

PERK.Hooks.SlowMotion_RPMBonus_Allow = function(ply)
	return ply:Horde_GetPerk("swat_base")
end

PERK.Hooks.SlowMotion_ReloadBonus_Allow = PERK.Hooks.SlowMotion_RPMBonus_Allow


PERK.Hooks.Horde_PrecomputePerkLevelBonus = function (ply)
    if SERVER then
        ply:Horde_SetPerkLevelBonus("swat_base", 1 + math.min(0.5, 0.02 * ply:Horde_GetLevel(HORDE.Class_Assault)))
        ply:Horde_SetPerkLevelBonus("slomo_bonus", math.min(2, 0.08 * ply:Horde_GetLevel(HORDE.Class_Assault)))
        HORDE:Modifier_AddToWeapons(ply, "Mult_DrawTime", "assault_base", ply:Horde_GetPerkLevelBonus("swat_base"))
    end
end