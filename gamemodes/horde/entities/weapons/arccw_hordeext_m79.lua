if not ArcCWInstalled then return end
SWEP.Base = "arccw_horde_m79"
SWEP.Horde_MaxMags = 60

if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_horde_m79")
    killicon.Add("arccw_hordeext_m79", "arccw/weaponicons/arccw_horde_m79", Color(0, 0, 0, 255))
end
