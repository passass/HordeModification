if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_go_nade_molotov")
    killicon.Add("arccw_hordeext_fire", "arccw/weaponicons/arccw_go_nade_molotov", Color(0, 0, 0, 255))
end
SWEP.Base = "arccw_horde_nade_molotov"
SWEP.Horde_MaxMags = 60
SWEP.ShootEntity = "arccw_thr_hordeext_molotov"
SWEP.ForceDefaultAmmo = 0
SWEP.KeepIfEmpty = true