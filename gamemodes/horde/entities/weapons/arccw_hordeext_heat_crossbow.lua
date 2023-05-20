if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = Material("items/hl2/weapon_crossbow.png")
    killicon.AddAlias("arccw_hordeext_heat_crossbow", "weapon_crossbow")
end

SWEP.Base = "arccw_horde_heat_crossbow"
SWEP.Horde_MaxMags = 60
