if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_bo1_python.vtf")
    killicon.Add("arccw_hordeext_357", "arccw/weaponicons/arccw_bo1_python", Color(255, 255, 255, 255))
end
SWEP.Base = "arccw_base"
SWEP.Spawnable = true
SWEP.Category = "ArcCW - Horde"
SWEP.AdminOnly = false

SWEP.PrintName = "Snub Nose"
SWEP.Trivia_Class = "Revolver"
SWEP.Trivia_Desc = "American revolver regarded as one of the finest of its kind. The bore gets tighter towards the end, aiding in accuracy."
SWEP.Trivia_Manufacturer = "Colt"
SWEP.Trivia_Calibre = ".357 Magnum"
SWEP.Trivia_Mechanism = "Single/Double Action"
SWEP.Trivia_Country = "USA"
SWEP.Trivia_Year = 1955

SWEP.Slot = 1

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/c_bo1_python.mdl"
SWEP.WorldModel = "models/weapons/arccw/w_bo1_python.mdl"
SWEP.MirrorWorldModel = "models/weapons/arccw/w_bo1_python.mdl"
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos        =    Vector(-8.5, 4, -4),
    ang        =    Angle(-10, 0, 180),
    bone       =    "ValveBiped.Bip01_R_Hand",
    scale      = 1
}
SWEP.ViewModelFOV = 60

SWEP.Damage = 25
SWEP.DamageMin = 20
SWEP.RangeMin = 500 * 0.025  -- GAME UNITS * 0.025 = METRES
SWEP.Range = 1250 * 0.025  -- GAME UNITS * 0.025 = METRES
SWEP.Penetration = 4
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any


SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 6 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 6
SWEP.ReducedClipSize = 6

SWEP.Recoil = 1.5
SWEP.RecoilSide = 1.25
SWEP.RecoilRise = 0.1
SWEP.RecoilPunch = 1

SWEP.Delay = 120 / 450 -- 30 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0,
    }
}

SWEP.NPCWeaponType = "weapon_357"
SWEP.NPCWeight = 150

SWEP.AccuracyMOA = 5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 250 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 50

SWEP.Primary.Ammo = "357" -- what ammo type the gun uses

SWEP.ShootVol = 120 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound =			"weapons/357_shootsound.wav"
--SWEP.DistantShootSound =	"weapons/fesiugmw2/fire_distant/anaconda.wav"
SWEP.DistantShootSound = "arccw_go/revolver/revolver-1_distant.wav"

SWEP.MuzzleEffect = "muzzleflash_pistol"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellScale = 1.5
SWEP.ShellPitch = 90

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = nil -- which attachment to put the case effect on
SWEP.ProceduralViewBobAttachment = 1
SWEP.CamAttachment = 2

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.8
SWEP.SightTime = 0.125

SWEP.IronSightStruct = {
    Pos = Vector(-2.15, 4, 0.95),
    Ang = Angle(-0.5, 0, 0),
    Magnification = 1.1,
    CrosshairInSights = false,
    SwitchToSound = "", -- sound that plays when switching to this sight
}
SWEP.Horde_MaxMags = 25
SWEP.ClipsPerAmmoBox = 2
SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.ActivePos = Vector(0, 2.5, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(0, 2.5, 0)
SWEP.SprintAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(15, 1, -1.25)
SWEP.CustomizeAng = Angle(15, 40, 20)

SWEP.HolsterPos = Vector(0, -4, -5)
SWEP.HolsterAng = Angle(37.5, 0, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 12

SWEP.ExtraSightDist = 5

SWEP.AttachmentElements = {
    ["ammo_papunch"] = {
        NamePriority = 10,
        NameChange = "Cobra",
    },
    ["python_snub"] = {
        VMBodygroups = {
            {ind = 1, bg = 1}
        },
        AttPosMods = {
            [4] = {
                vpos = Vector(3.25, 0, 0.15),
            }
        },
    },
    ["bo1_speedloader"] = {
        VMBodygroups = {
            {ind = 3, bg = 1}
        }
    },
}

SWEP.ExtraSightDist = 10

SWEP.RejectAttachments = {
}

SWEP.Attachments = {
    {
        PrintName = "Barrel",
        Slot = "bo1_python_barrel",
        Installed = "bo1_python_snub",
        Integral = true
    },
    {
        Hidden = true,
        PrintName = "Underbarrel",
        Slot = {"foregrip"},
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(6, 0, 1.5),
            vang = Angle(0, 0, 0),
        },
        ExcludeFlags = {"python_snub"},
    },
    {
        PrintName = "Cylinder",
        Slot = "bo1_cylinder",
        Integral = true,
        Installed = "bo1_cylinder_speedloader",
    },
    {
        PrintName = "Ammo Type",
        Slot = "go_ammo"
    },
    {
        PrintName = "Perk",
        Slot = "perk"
    },
    {
        PrintName = "Charm",
        Slot = "charm",
        Bone = "j_gun",
        Offset = {
            vpos = Vector(-3.5, -0.5, -1.25),
            vang = Angle(0, 0, 0),
        },
    },
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 1 / 30,
    },
    ["draw"] = {
        Source = "draw",
        Time = 30 / 30,
        LHIK = true,
        LHIKIn = 0.15,
        LHIKOut = 0.5,
    },
    ["holster"] = {
        Source = "holster",
        Time = 24 / 30,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKOut = 0.1,
    },
    ["ready"] = {
        Source = "first_draw",
        Time = 60 / 30,
        SoundTable = {
            {s = "ArcCW_BO1.Python_Spin", t = 16 / 30},
            {s = "ArcCW_BO1.Python_Close", t = 40 / 30}, -- im keeping this because i think it looks cool
        }
    },
    ["fire"] = {
        Source = {"fire"},
        Time = 12 / 35,
    },
    ["fire_iron"] = {
        Source = "fire_ads",
        Time = 12 / 35,
    },
    ["sgreload_start"] = {
        Source = "reload_in",
        Time = 52 / 30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.2,
        RestoreAmmo = 1, -- loads a shell since the first reload has a shell in animation
        MinProgress = 1.2,
        SoundTable = {
            {s = "ArcCW_BO1.Python_Open", t = 20 / 35},
            {s = "ArcCW_BO1.Python_Empty", t = 26 / 35},
        },
    },
    ["sgreload_insert"] = {
        Source = "reload_loop",
        Time = 16 / 30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
        TPAnimStartTime = 0.3,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.2,
        MinProgress = 16 / 30,
        SoundTable = {
            {s = "ArcCW_BO1.Python_Bullet", t = 13 / 30},
        },
    },
    ["sgreload_finish"] = {
        Source = "reload_out_snap",
        Time = 33 / 30,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.6,
        SoundTable = {
            {s = "ArcCW_BO1.Python_Close", t = 8 / 30},
        },
    },
    ["sgreload_finish_empty"] = {
        Source = "reload_out_snap",
        Time = 33 / 30,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.6,
        SoundTable = {
            {s = "ArcCW_BO1.Python_Close", t = 8 / 30},
        },
    },
    ["reload"] = {
        Source = "reload",
        Time = 100 / 35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.2,
        SoundTable = {
            {s = "ArcCW_BO1.Python_Open", t = 17 / 35},
            {s = "ArcCW_BO1.Python_Empty", t = 38 / 35},
            {s = "ArcCW_BO1.Python_Load", t = 68 / 35},
            {s = "ArcCW_BO1.Python_Close", t = 83 / 35},
        },
    },
    ["reload_empty"] = {
        Source = "reload",
        Time = 100 / 35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.2,
        SoundTable = {
            {s = "ArcCW_BO1.Python_Open", t = 17 / 35},
            {s = "ArcCW_BO1.Python_Empty", t = 38 / 35},
            {s = "ArcCW_BO1.Python_Load", t = 68 / 35},
            {s = "ArcCW_BO1.Python_Close", t = 83 / 35},
        },
    },
    ["enter_sprint"] = {
        Source = "idle",
        Time = 3 / 30,
        LHIK = true,
        LHIKIn = 0.85,
        LHIKOut = 0.25,
    },
    ["idle_sprint"] = {
        Source = "sprint_loop",
        Time = 30 / 30,
        LHIK = true,
        LHIKIn = 1,
        LHIKOut = 0.4,
    },
    ["exit_sprint"] = {
        Source = "idle",
        Time = 3 / 30
    },
}