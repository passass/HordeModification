if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("entities/horde_chaingrenade.vtf")
    killicon.Add("arccw_hordeext_nade_chain", "entities/horde_chaingrenade", Color(0, 0, 0, 255))
end
SWEP.Base = "arccw_hordeext_base_nade"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Chain Grenade"
SWEP.ForceDefaultAmmo = 0

SWEP.Slot = 4

SWEP.NotForNPCs = true

SWEP.UseHands = true
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/tfa_cso/c_chain_grenade.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/tfa_cso/w_chain_grenade.mdl"	-- Weapon world model
SWEP.ViewModelFOV = 80

SWEP.WorldModelOffset = {
    pos = Vector(3, 2, -1),
    ang = Angle(-10, 0, 180)
}

SWEP.FuseTime = 5

SWEP.Throwing = true

SWEP.Primary.ClipSize = 1


SWEP.MuzzleVelocity = 600
SWEP.Horde_MaxMags = 40
SWEP.ClipsPerAmmoBox = 4
SWEP.ShootEntity 			= "horde_chaingrenade_exp"	--NAME OF ENTITY GOES HERE

SWEP.TTTWeaponType = "weapon_zm_molotov"
SWEP.NPCWeaponType = "weapon_grenade"
SWEP.NPCWeight = 50

SWEP.PullPinTime = 0.5
SWEP.Override_ShootEntityDelay = 3
SWEP.PullPinTime = .9

SWEP.Animations = {
    ["draw"] = {
        Source = "deploy",
    },
    ["pre_throw"] = {
        Source = "pullpin",
        Time = 1,
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