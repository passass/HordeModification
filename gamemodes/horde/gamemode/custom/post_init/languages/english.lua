-- Added

local shortcuts = {
    ["slomo_rpm&reload"] = "{slomo1} increased reload speed and firerate in slow motion. ({slomo2} per level, up to {slomo3}).",
    ["slomo_ms&atksp"] = "{slomo1} increased movement speed in slow motion and attack speed with melee weapons. ({slomo2} per level, up to {slomo3})."
}


translate.AddLanguage("en", "English")

LANGUAGE["Perk_survivor_base"] = [[
The Survivor class can be played into any class to fill in missing roles for the team.
Complexity: EASY

{slomo1} increased reload speed and movement speed in slow motion. ({slomo2} per level, up to {slomo3}).]]

LANGUAGE["Perk_assault_base"] = [[
The Assault class is an all-purpose fighter with high mobility and a focus on Adrenaline stacks.
Complexity: EASY

{1} more movement speed. ({2} per level, up to {3}).
{4} increased Ballistic damage. ({5} per level, up to {6}).
]] .. shortcuts["slomo_rpm&reload"] .. [[
5 slow motion stacks instead of 3.

Gain Adrenaline when you kill an enemy.
Adrenaline increases damage and speed by {7}.]]

LANGUAGE["Perk_berserker_base"] = [[
The Berserker class is a melee-centered class that can be played both offensively and defensively.
Complexity: HIGH

{1} increased Slashing and Blunt damage. ({2} per level, up to {3}).
{4} increased Global damage resistance. ({5} per level, up to {6}).
]] .. shortcuts["slomo_ms&atksp"] .. [[

Aerial Parry: Jump to reduce Physical damage taken by {10}.]]


LANGUAGE["Perk_heavy_base"] = [[
The Heavy class is a tank class that provides strong suppression firepower.
Complexity: EASY

{6} increased maximum armor. ({7} per level, up to {8}).

Regenerate {1} armor per second.
Regenerate up to {2} armor. ({3} + {4} per level, up to {5})
]] .. shortcuts["slomo_rpm&reload"]

LANGUAGE["Perk_ghost_base"] = [[
The Ghost class is focused on taking down boss enemies using Camoflague.
Complexity: HIGH

{1} more headshot damage. ({2} per level, up to {3}).
{slomo1} increased reload speed, firerate, decreased cycle time and zoom speed in slow motion. ({slomo2} per level, up to {slomo3}).

Crouch to activate Camoflague, granting {4} evasion.
Attacking or Running REMOVES Camoflague.]]
