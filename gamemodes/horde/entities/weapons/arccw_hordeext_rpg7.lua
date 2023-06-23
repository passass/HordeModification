if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/hud/arccw_horde_rpg7")
    killicon.Add("arccw_hordeext_rpg7", "vgui/hud/arccw_horde_rpg7", color_white)
end
SWEP.Base = "arccw_horde_rpg7"
SWEP.Horde_MaxMags = 60
SWEP.ClipsPerAmmoBox = 5