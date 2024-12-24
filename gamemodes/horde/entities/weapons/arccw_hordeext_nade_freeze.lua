if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_horde_nade_shrapnel")
    killicon.Add("arccw_horde_nade_shrapnel", "arccw/weaponicons/arccw_horde_nade_shrapnel", Color(0, 0, 0, 255))
    killicon.Add("arccw_thr_shrapnel", "arccw/weaponicons/arccw_horde_nade_shrapnel", Color(0, 0, 0, 255))
end
SWEP.Base = "arccw_hordeext_base_nade"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false
SWEP.Primary.Ammo = "Grenade"

SWEP.PrintName = "Freeze Grenade"

SWEP.Slot = 4

SWEP.NotForNPCs = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw_go/v_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/arccw_go/w_eq_fraggrenade_thrown.mdl"
SWEP.ViewModelFOV = 60

SWEP.WorldModelOffset = {
    pos = Vector(3, 2, -1),
    ang = Angle(-10, 0, 180)
}

SWEP.FuseTime = 2.5

SWEP.Throwing = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.MaxAmmo = 9
SWEP.ForceDefaultAmmo = 0
SWEP.MuzzleVelocity = 1000
SWEP.ShootEntity = "arccw_thr_hordeext_freeze"

SWEP.TTTWeaponType = "weapon_ttt_confgrenade"
SWEP.NPCWeaponType = "weapon_grenade"
SWEP.NPCWeight = 50

SWEP.PullPinTime = 0.25

SWEP.Animations = {
    ["draw"] = {
        Source = "deploy",
        Time = 0.25,
    },
    ["pre_throw"] = {
        Source = "pullpin",
        Time = 0.5,
    },
    ["throw"] = {
        Source = "throw",
        TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
        SoundTable = {
            {
                s = "arccw_go/hegrenade/grenade_throw.wav",
                t = 0
            }
        }
    }
}

SWEP.BodyMaterial	 	= "Horde/Freeze/freeze_slush"

SWEP.VMMaterial = SWEP.BodyMaterial