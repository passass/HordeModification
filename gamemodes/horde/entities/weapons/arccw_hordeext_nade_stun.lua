SWEP.Base = "arccw_horde_nade_stun"
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_horde_nade_stun")
    killicon.Add("arccw_hordeext_nade_stun", "arccw/weaponicons/arccw_horde_nade_stun", Color(0, 0, 0, 255))
end
SWEP.Horde_MaxMags = 35
SWEP.ClipsPerAmmoBox = 3
SWEP.ForceDefaultAmmo = 0