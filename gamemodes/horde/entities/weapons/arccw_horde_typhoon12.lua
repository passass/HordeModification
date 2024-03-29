SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/hud/tfa_ins2_typhoon12.vtf")
    killicon.Add("arccw_horde_typhoon12", "vgui/hud/tfa_ins2_typhoon12", Color(255, 255, 255, 255))
end
SWEP.PrintName = "Typhoon F12 Custom"

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/tfa_ins2/c_typhoon12.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/tfa_ins2/w_typhoon12.mdl"
--SWEP.MirrorVMWM = false
SWEP.WorldModelOffset = {
    pos        =    Vector(
    5, 1, -2
    ),--Vector(-2.5, 4.25, -5.65),
    ang        =    Angle(0, 0, 180),--Angle(-5, -0.25, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
    scale   =   1.0
}
SWEP.ViewModelFOV = 60

SWEP.Damage = 46
SWEP.DamageMin = 30 -- damage done at maximum range
SWEP.Range = 35 -- in METRES

SWEP.Penetration = 10
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 400 -- projectile or phys bullet muzzle velocity
-- IN M/S

--[[SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(34, 88, 250)
SWEP.TracerWidth = 3
SWEP.Tracer = "cel_muzzleflash"]]
SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 20 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 40
SWEP.ReducedClipSize = 10

SWEP.Horde_MaxMags = 10

SWEP.Recoil = 2.15
SWEP.RecoilSide = 2
SWEP.RecoilRise = .9
SWEP.VisualRecoilMult = 0.14

SWEP.Delay = 60 / 220
SWEP.Num = 8 -- number of shots per trigger pull.
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

SWEP.NPCWeaponType = "weapon_shotgun"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 125 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 300 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 275

SWEP.Primary.Ammo = "buckshot" -- what ammo type the gun uses
SWEP.MagID = "t12" -- the magazine pool this gun draws from

SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

--SWEP.FirstShootSound = "ArcCW_BO1.M14_Fire"
SWEP.ShootSound = Sound("TFA_INS2.WF_SHG53.1")
SWEP.ShootSoundSilenced = Sound("TFA_INS2.WF_SHG53.2")

SWEP.MuzzleEffect = "muzzleflash_m3"
SWEP.ShellModel = "models/shells/shell_12gauge.mdl"
SWEP.ShellPitch = 100
SWEP.ShellSounds = ArcCW.ShotgunShellSoundsTable
SWEP.ShellScale = 1.5
SWEP.ShellRotateAngle = Angle(0, 90, 0)

--[[SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on
SWEP.ProceduralViewBobAttachment = 1]]
--SWEP.CamAttachment = 5

SWEP.SpeedMult = 0.9
SWEP.SightedSpeedMult = 0.4
SWEP.SightTime = 0.3

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-2.998, -4, -0.12),
    Ang = Vector(0.335, 0, 5),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "shotgun"
SWEP.HoldtypeSights = "ar2"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN

SWEP.ActivePos = Vector(0, -2, .5)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(4.8, 6, 0)
SWEP.SprintAng = Angle(-7.036, 30.016, 0)

SWEP.CustomizePos = Vector(15, 4, -2)
SWEP.CustomizeAng = Angle(15, 40, 20)

SWEP.HolsterPos = Vector(4.8, 6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 22
SWEP.AttachmentElements = { 
	["mount"] = {
        VMElements = {
            {
                Model = "models/weapons/tfa_ins2/upgrades/a_typhoon12_sights_up.mdl",
                Bone = "A_Optic",
                Scale = Vector(1, 1, 1),
                Offset = {
                    pos = Vector(-3.44, 1.6, -17),
                    ang = Angle(90, 0, 90),
                }
            }
        },
    },
}


--SWEP.ExtraSightDist = 5
SWEP.Attachments = {
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = {"optic_lp", "optic"}, -- what kind of attachments can fit here, can be string or table
        Bone = "A_Optic", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0, 0, 0), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, 90),
            wpos = Vector(10, .8, -6.6),
            wang = Angle(0, 0, 180)
        },
		DefaultEles = {"mount"},
        --[[CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0),]]
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "A_Suppressor",
        Offset = {
            vpos = Vector(0, 8, -1.35), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 90, 0),
            wpos = Vector(25, 1, -3.25),
            wang = Angle(0, 0, 0)
        },
        InstalledEles = {"sidemount"},
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "A_Suppressor",
        Offset = {
            vpos = Vector(0, -4, 0),
            vang = Angle(0, 90, 0),
            wpos = Vector(30, 0.782, -5.5),
            wang = Angle(0, 0,  0)
        },
    },
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip"},
        Bone = "A_Suppressor",
        VMScale = Vector(1.2, 1, 1),
        WMScale = Vector(1.2, 1, 1),
        Offset = {
            vpos = Vector(0, 12, -1.35), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 90, 0),
            wpos = Vector(9.5, 1.15, -4.2),
            wang = Angle(180, -180, 0),
        },
    },
    {
        PrintName = "Grip",
        Slot = "grip",
        DefaultAttName = "Standard Grip"
    },
    {
        PrintName = "Stock",
        Slot = "stock",
        DefaultAttName = "Standard Stock"
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
        Bone = "A_Optic", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(-1, -2.5, -1), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, 90),
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
        Source = "base_ready",
        LHIK = true,
        LHIKIn = 0, LHIKEaseIn = 0,
        LHIKOut = .8, LHIKEaseOut = .5,
        SoundTable = {
            {t = 0, s = Sound("TFA_INS2.Draw")},
            {t = 32 / 30, s = Sound("TFA_INS2.WF_SHG53.BoltBack")},
            {t = 27 / 30, s = Sound("TFA_INS2.LeanIn")},
            {t = 46 / 30, s = Sound("TFA_INS2.WF_SHG53.BoltForward")},
            {t = 47 / 30, s = Sound("TFA_INS2.LeanIn")},
            {t = 63 / 30, s = Sound("TFA_INS2.LeanIn")},
        },
	},
    ["draw"] = {
        Source = "base_draw",
        SoundTable = {
            {t = 0, s = Sound("TFA_INS2.Draw")},
        }
    },
    ["reload"] = {
        Source = "base_reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true, Mult = .7,
        LHIKIn = .7, LHIKEaseIn = .5,
        LHIKOut = .8, LHIKEaseOut = .5,
        SoundTable = {
            {t = 9 * .7 / 30, s = Sound("TFA_INS2.LeanIn")},
            {t = 38 * .7 / 30, s = Sound("TFA_INS2.WF_SHG53.WpnUp")},
            {t = 40 * .7 / 30, s = Sound("TFA_INS2.LeanIn")},
            {t = 41 * .7 / 30, s = Sound("TFA_INS2.WF_SHG53.ClipOut")},
            {t = 66 * .7 / 30, s = Sound("TFA_INS2.Holster")},
            {t = 81 * .7 / 30, s = Sound("TFA_INS2.LeanIn")},
            {t = 114 * .7 / 30, s = Sound("TFA_INS2.WF_SHG53.ClipMove")},
            {t = 118 * .7 / 30, s = Sound("TFA_INS2.WF_SHG53.ClipIn")},
            {t = 119 * .7 / 30, s = Sound("TFA_INS2.LeanIn")},
            {t = 141 * .7 / 30, s = Sound("TFA_INS2.LeanIn")},
        }
    },
    ["reload_empty"] = {
        Source = "base_reloadempty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true, Mult = .75,
        LHIKIn = .7, LHIKEaseIn = .5,
        LHIKOut = .65, LHIKEaseOut = .5,
        SoundTable = {
            {t = 7 * .7 / 30, s = Sound("TFA_INS2.LeanIn")},
            {t = 37 * .7 / 30, s = Sound("TFA_INS2.WF_SHG53.WpnUp2")},
            {t = 51 * .7 / 30, s = Sound("TFA_INS2.WF_SHG53.ClipOut2")},
            {t = 52 * .7 / 30, s = Sound("TFA_INS2.LeanIn")},
            {t = 64 * .7 / 30, s = Sound("TFA_INS2.Holster")},
            {t = 98 * .7 / 30, s = Sound("TFA_INS2.LeanIn")},
            {t = 110 * .7 / 30, s = Sound("TFA_INS2.WF_SHG53.ClipMove")},
            {t = 114 * .7 / 30, s = Sound("TFA_INS2.LeanIn")},
            {t = 115 * .7 / 30, s = Sound("TFA_INS2.WF_SHG53.ClipIn2")},
            {t = 128 * .7 / 30, s = Sound("TFA_INS2.LeanIn")},
            {t = 144 * .7 / 30, s = Sound("TFA_INS2.LeanIn")},
            {t = 145 * .7 / 30, s = Sound("TFA_INS2.WF_SHG53.BoltBack2")},
            {t = 154 * .7 / 30, s = Sound("TFA_INS2.WF_SHG53.BoltForward2")},
            {t = 155 * .7 / 30, s = Sound("TFA_INS2.LeanIn")},
            {t = 175 * .7 / 30, s = Sound("TFA_INS2.LeanIn")},
        }
    },
    ["holster"] = {
		Source = "base_holster",
        SoundTable = {
            {t = 0, s = Sound("TFA_INS2.Holster")},
        }
    },
}
