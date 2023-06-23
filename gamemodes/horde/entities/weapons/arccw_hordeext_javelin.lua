if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_horde_javelin")
    killicon.Add("arccw_hordeext_javelin", "arccw/weaponicons/arccw_horde_javelin", color_white)
end
SWEP.Base = "arccw_horde_javelin"
SWEP.Horde_MaxMags = 50
SWEP.ClipsPerAmmoBox = 5