if not ArcCWInstalled then return end

if (CLIENT) then
	killicon.Add("arccw_hordeext_flaregun", "vgui/hud/arccw_horde_flaregun", color_white)
	SWEP.DrawWeaponInfoBox	= true
    SWEP.BounceWeaponIcon = true
end

SWEP.Base = "arccw_horde_flaregun"
SWEP.Horde_MaxMags = 80
SWEP.ShootEntity = "projectile_hordeext_flaregun_flare"