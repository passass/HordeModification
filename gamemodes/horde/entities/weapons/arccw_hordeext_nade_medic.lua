if not ArcCWInstalled then return end
-- Referenced From GSO
SWEP.Base = "arccw_nade_medic"
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_nade_medic")
end
SWEP.Horde_MaxMags = 30
SWEP.ClipsPerAmmoBox = 3
SWEP.ShootEntity = "arccw_thr_hordeext_medicgrenade"
SWEP.ForceDefaultAmmo = 0
SWEP.Primary.MaxAmmo = nil