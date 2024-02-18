if not ArcCWInstalled then return end
SWEP.Base = "arccw_horde_doublebarrel"
SWEP.Category = "ArcCW - Horde" -- edit this if you like

SWEP.PrintName = "Double Barrel"
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_horde_doublebarrel")
    killicon.Add("arccw_hordeext_doublebarrel", "arccw/weaponicons/arccw_horde_doublebarrel", Color(0, 0, 0, 255))
end

SWEP.Horde_MaxMags = 75
SWEP.ClipsPerAmmoBox = 5