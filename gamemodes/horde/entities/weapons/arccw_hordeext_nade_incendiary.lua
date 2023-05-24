if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_go_nade_incendiary")
    killicon.Add("arccw_thr_horde_incendiary", "arccw/weaponicons/arccw_go_nade_incendiary", Color(0, 0, 0, 255))
end
SWEP.Base = "arccw_horde_nade_incendiary"
SWEP.ForceDefaultAmmo = 0
SWEP.ShootEntity = "arccw_thr_hordeext_incendiary"
SWEP.KeepIfEmpty = true