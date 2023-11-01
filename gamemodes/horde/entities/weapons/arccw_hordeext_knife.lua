if not ArcCWInstalled then return end
if CLIENT then
    killicon.Add("arccw_hordeext_knife", "arccw/weaponicons/arccw_go_melee_knife", Color(0, 0, 0, 255))
end
SWEP.Base = "arccw_horde_knife"

SWEP.CantDropWep = true
SWEP.MeleeDamage = 20
SWEP.Melee2Damage = 40