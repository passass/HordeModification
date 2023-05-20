if not ArcCWInstalled then return end

SWEP.Base = "arccw_horde_m32"
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_horde_m32")
    killicon.Add("arccw_hordeext_m32", "arccw/weaponicons/arccw_horde_m32", Color(0, 0, 0, 255))
end
SWEP.Horde_MaxMags = 40