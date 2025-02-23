SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Killing Floor 2" -- edit this if you like
SWEP.AdminOnly = false
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_go_ar15")
    killicon.Add("arccw_kf2_ar15", "arccw/weaponicons/arccw_go_ar15", Color(0, 0, 0, 255))
end
SWEP.PrintName = "Colt M635"
--[[SWEP.Trivia_Class = "Pistol"
SWEP.Trivia_Desc = ".40 Caliber semi automatic pistol. Commonly used among police and popular with civilians for its reliability."
SWEP.Trivia_Manufacturer = "Auschen Waffenfabrik"
SWEP.Trivia_Calibre = ".40 S&W"
SWEP.Trivia_Mechanism = "Short Recoil"
SWEP.Trivia_Country = "Austria"
SWEP.Trivia_Year = 1993]]

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel			= "models/weapons/kf2/tfa_c_ar15.mdl"--"models/weapons/kf2/arccw_v_ar15.mdl"
SWEP.WorldModel			= "models/weapons/kf2/tfa_w_ar15.mdl"
SWEP.Horde_MaxMags = 30
SWEP.ClipsPerAmmoBox = 2
SWEP.ActiveAng = Angle(0, 0, 0)
SWEP.ActivePos 							= Vector(3.3, 6.5, -1)
SWEP.HolsterPos = Vector(4.8, 6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.Damage = 25
SWEP.DamageMin = 14 -- damage done at maximum range
SWEP.RangeMin = 15
SWEP.Range = 45
SWEP.Penetration = 3
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 300 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.CanFireUnderwater = true
SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 20 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 30
SWEP.ReducedClipSize = 10

SWEP.Recoil = 0.8
SWEP.RecoilSide = 0.35
SWEP.RecoilRise = 3

SWEP.Delay = 60 / 690 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = -3,
		RunawayBurst = true,
        PostBurstDelay = 0.15,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 10 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 250 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 250

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses

SWEP.ShootVol = 115 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "weapons/kf2/ar15/shoot.wav"
SWEP.ShootSoundSilenced = "arccw_go/m4a1/m4a1_silencer_01.wav"

SWEP.MuzzleEffect = "muzzleflash_pistol"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellScale = 1.5

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SightTime = 0.175

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.75

SWEP.BarrelLength = 18

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(0,1.5,0),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = Fire

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.ExtraSightDist = 7

SWEP.WorldModelOffset = {
    pos = Vector(3.75, 1, -3.0),
    ang = Angle( 0, 90, 180 ),
}

SWEP.Attachments = {
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = {"optic_lp", "optic"}, -- what kind of attachments can fit here, can be string or table
        Bone = "RW_Rear_Sight", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(1, 0, 1.1), -- offset that the attachment will be relative to the bone
            vang = Angle(-1.5, 0, 0),
            wpos = Vector(8, 1, -8.3),
            wang = Angle(0, -360, 180)
        },
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "RW_Muzzle",
        Offset = {
            vpos = Vector(-.4, 0, 0),
            vang = Angle(0, 0, 0),
            wpos = Vector(24, .9, -5.85),
            wang = Angle(0, 0, 0)
        },
    },
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip", "ubgl"},
        Bone = "RW_Barrel",
        Offset = {
            vpos = Vector(3, 0, -1.575),
            vang = Angle(0, 0, 0),
            wpos = Vector(3, 0, -5.575),
            wang = Angle(0, 0, 0)
        },
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "RW_Barrel",
        Offset = {
            vpos = Vector(5, 0, -1),
            vang = Angle(0, 0, 0),
            wpos = Vector(17, 0, -3.5),
            wang = Angle(0, 0, 0)
        },
        InstalledEles = {"sidemount"},
    },
    {
        PrintName = "Grip",
        Slot = "grip",
        DefaultAttName = "Standard Grip"
    },
    {
        PrintName = "Fire Group",
        Slot = "fcg",
        DefaultAttName = "Standard FCG"
    },
    {
        PrintName = "Ammo Type",
        Slot = "go_ammo",
        DefaultAttName = "Standard Ammo"
    },
    {
        PrintName = "Perk",
        Slot = "go_perk"
    },
    {
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "v_weapon.USP_Slide", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(-0.5, 0.1, -4), -- offset that the attachment will be relative to the bone
            vang = Angle(-90, 0, -90),
            wpos = Vector(8, 2.3, -3.5),
            wang = Angle(-2.829, -4.902, 180)
        },
    },
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    ["ready"] = {
        Source = "draw",
    },
    ["draw_empty"] = {
        Source = "idle_empty",
    },
    ["draw"] = {
        Source = "draw",
    },
    ["fire"] = {
		Source = {"shoot_standard"},
	},
    ["fire_iron"] = {
        Source = {"shoot_iron", "shoot_iron2", "shoot_iron3"},
    },
    ["reload"] = {
        Source = "reload", EndReloadOn = 3 * .8, ForceEnd = true,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Mult= .8,
        LHIK = true,
        LHIKIn = .8,
        LHIKOut = 1.3,
        LHIKEaseIn = 1,
        LHIKEaseOut = .3,
        MagUpIn = 1.75,
    },
    ["reload_empty"] = {
        Source = "reload_empty", EndReloadOn = 3.1 * .8, ForceEnd = true,
        Mult= .8,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        LHIK = true,
        LHIKIn = .8,
        LHIKOut = 1.3,
        LHIKEaseIn = 1,
        LHIKEaseOut = .5,
        MagUpIn = 1.3,
    },
    ["holster"] = {
		Source = "holster",
	},
}