if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/hud/arccw_horde_law")
    killicon.Add("arccw_hordeext_law", "vgui/hud/arccw_horde_law", color_white)
end
SWEP.Base = "arccw_horde_law"
SWEP.Horde_MaxMags = 65
SWEP.ClipsPerAmmoBox = 5
SWEP.ForceDefaultAmmo = 0