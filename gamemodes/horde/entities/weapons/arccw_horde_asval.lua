SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "AS Val"
SWEP.Trivia_Class = "Assault Rifle"
SWEP.Trivia_Desc = [[
    The first modern assault rifle, created with the intent to arm tank crewmen with better weapons than an SMG or a rifle. Hitler eventually dubbed the weapon the 'Sturmgewehr' as means for propaganda.

    Model from Black Ops 3.
]]
SWEP.Trivia_Manufacturer = "C.G. Haenel"
SWEP.Trivia_Calibre = "7.92x33mm Kurz"
SWEP.Trivia_Mechanism = "Gas-Operated"
SWEP.Trivia_Country = "Nazi Germany"
SWEP.Trivia_Year = 1942

SWEP.Slot = 2

SWEP.UseHands = true
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/hud/tfa_at_as_val.vtf")
    killicon.Add("arccw_horde_asval", "vgui/hud/tfa_at_as_val", Color(255, 255, 255, 255))
end

SWEP.ViewModel			        = "models/weapons/as_val_ins/v_mp5kpdw.mdl"
SWEP.WorldModel			        = "models/weapons/as_val_ins/w_mp5k.mdl"
SWEP.MirrorVMWM = false
SWEP.WorldModelOffset = {
    pos        =    Vector(5, 0.964, -2),--Vector(-2.5, 4.25, -5.65),
    ang        =    Angle(-10, 0, 180),--Angle(-5, -0.25, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
    scale   =   1.0
}
SWEP.ViewModelFOV = 60

SWEP.Damage = 65
SWEP.DamageMin = 50 -- damage done at maximum range
SWEP.RangeMin = 150
SWEP.Range = 250 -- in METRES
SWEP.Penetration = 10
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 690 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 1-- how many rounds can be chambered.
SWEP.Primary.ClipSize = 20 -- DefaultClip is automatically set.

SWEP.Recoil = 0.4
SWEP.RecoilSide = 0.3
SWEP.RecoilRise = 0.55
SWEP.VisualRecoilMult = 1

SWEP.Delay = 60 / 950 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = {
    "weapon_smg1",
    "weapon_ar2",
}
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 2 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 350 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses
SWEP.MagID = "asval" -- the magazine pool this gun draws from

SWEP.ShootSound = Sound("TFA_AT_AS_VAL.1")

SWEP.MuzzleEffect = "muzzleflash_4"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 90
SWEP.ShellScale = 1.5
SWEP.Horde_MaxMags = 30

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on
--[[SWEP.ProceduralViewBobAttachment = 1
SWEP.CamAttachment = 3]]

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.3

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-2.45, -1, 0.95),
    Ang = Angle(0.5, 0, 0),
    Magnification = 1.1,
    CrosshairInSights = false,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, -2, -1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(3, 3, 0)
SWEP.SprintAng = Angle(-7.036, 30.016, 0)

SWEP.CustomizePos = Vector(16, -3, -2)
SWEP.CustomizeAng = Angle(15, 40, 30)

SWEP.HolsterPos = Vector(8, -3, -1)
SWEP.HolsterAng = Angle(-7.036, 40.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 27

SWEP.ExtraSightDist = 5

SWEP.Attachments = {
    { --1
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = {"optic", "optic_lp"}, -- what kind of attachments can fit here, can be string or table
        Bone = "A_Optic",
        
        VMScale = Vector(1.25, 1.25, 1.25),
        Offset = {
            vpos = Vector(0, 0, 3.6), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, 90),
            wpos = Vector(6, 0, -5),
            wang = Angle(-10, 180, 180),
        },
    },
    { --4
        PrintName = "Underbarrel",
        Slot = {"foregrip"},
        Bone = "A_LaserFlashlight",
        Offset = {
            vpos = Vector(.5, 0, 0),
            vang = Angle(0, 0, 180),
            wpos = Vector(13, 0, -5),
            wang = Angle(170, 180, 0)
        },
    },
    { --7
        PrintName = "Tactical",
        Slot = {"tac"},
        Bone = "A_LaserFlashlight",
        Offset = {
            vpos = Vector(4.6, 0, 0), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 0, 90),
            wpos = Vector(23, 1.42, -7.5),
            wang = Angle(-10, 0, 90)
        },
    },
    { --12
        PrintName = "Perk",
        Slot = {"bo1_perk", "bo1_perk_wolfmg"},
    },
    { --13
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(2, -0.75, 2), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 0, 0),
            wpos = Vector(6.25, 1.9, -3),
            wang = Angle(-7.5, 0, 180)
        },
    },
}

SWEP.Animations = {
    ["draw"] = {
        Source = "base_draw",
        Time = 0.7,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.2,
    },
    ["holster"] = {
        Source = "base_holster",
        Time = 0.7,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.2,
    },
    ["ready"] = {
        Source = "base_ready",
        Time = 1.5,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.2,
        SoundTable = {
            {t = 10 / 30, s = Sound("TFA_AT_AS_VAL.Boltback")},
		    {t = 20 / 30, s = Sound("TFA_AT_AS_VAL.Boltrelease")},
        },
    },
    ["reload"] = {
        Source = "base_reload", Mult = .64, EndReloadOn = 2.85, ForceEnd = true,
        --Time = 2,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Framerate = 30,
        LHIK = true,
        LHIKIn = .4, LHIKEaseIn = .2,
        LHIKOut = .65, LHIKEaseOut = .5,
        SoundTable = {
            {t = 14 * .64 / 30, s = Sound("TFA_AT_AS_VAL.Magout")},
            {t = 21 * .64 / 30, s = Sound("TFA_AT_AS_VAL.Slideforward")},
            {t = 54 * .64 / 30, s = Sound("TFA_AT_AS_VAL.Magin")},
        },
    },
    ["reload_empty"] = {
        Source = "base_reloadempty", Mult = .64, EndReloadOn = 3.75, ForceEnd = true,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = .4, LHIKEaseIn = .2,
        LHIKOut = .5, LHIKEaseOut = .5,
        SoundTable = {
            {t = 1 * .64 / 30, s = Sound("TFA_AT_AS_VAL.Slideforward")},
            {t = 28 * .64 / 30, s = Sound("TFA_AT_AS_VAL.Magout")},
            {t = 56 * .64 / 30, s = Sound("TFA_AT_AS_VAL.Magin")},
            {t = 90 * .64 / 30, s = Sound("TFA_AT_AS_VAL.Boltback")},
            {t = 100 * .64 / 30, s = Sound("TFA_AT_AS_VAL.Boltrelease")},
        },
    },
}