SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_horde_syringegun")
    killicon.Add("arccw_horde_syringegun", "arccw/weaponicons/arccw_horde_syringegun", Color(0, 0, 0, 255))
end
SWEP.PrintName = "Syringe Gun"

SWEP.Slot = 1

SWEP.UseHands = false

SWEP.ViewModel		= "models/weapons/red/medic/v_syringegun_red.mdl"
SWEP.WorldModel		= "models/weapons/c_models/c_syringegun/c_syringegun.mdl"
SWEP.ViewModelFOV = 60

SWEP.ActivePos = Vector(1, 6, -.5)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(4.8, 6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.Damage = 15
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = "horde_syringe_proj" -- entity to fire, if any
SWEP.MuzzleVelocity = 1000 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.CanFireUnderwater = true
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 40 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 30
SWEP.ReducedClipSize = 10

SWEP.Horde_MaxMags = 6

SWEP.Recoil = .1
SWEP.RecoilSide = .25
SWEP.RecoilRise = 1

SWEP.Delay = 0.13 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 180 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 350
game.AddAmmoType( {
	name = "ammo_syringe",
} )
SWEP.Primary.Ammo = "ammo_syringe" -- what ammo type the gun uses



SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootSound = "weapons/syringegun_shoot.wav"

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 1

SWEP.BarrelLength = 14

SWEP.BulletBones = {
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = false

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.ExtraSightDist = 7

SWEP.WorldModelOffset = {
    pos = Vector(13, 1, 2),
    ang = Angle( 0, 0, 180 ),
}

SWEP.Attachments = {
    {
        PrintName = "Perk",
        Slot = "go_perk"
    },
}

SWEP.Animations = {
    ["idle"] = {
        Source = "sg_idle",
    },
    ["ready"] = {
        Source = "sg_draw",
    },
    ["draw"] = {
        Source = "sg_draw",
    },
    ["fire"] = {
		Source = "sg_fire",
	},
    ["reload"] = {
        Source = "sg_reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    },
}