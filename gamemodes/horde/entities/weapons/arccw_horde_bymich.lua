SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - CS+" -- edit this if you like
SWEP.AdminOnly = false
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_db.vtf")
    killicon.Add("arccw_horde_bymich", "arccw/weaponicons/arccw_db", Color(0, 0, 0, 255))
end
SWEP.PrintName = "BooMer"
SWEP.TrueName = "DB"
SWEP.Trivia_Class = "Shotgun"
SWEP.Trivia_Desc = "Basic double-barrel shotgun manufactured as an entry-level hunting weapon. Long barrel makes for great spread and extra range, at the cost of poor hip fire characteristics. Switch to BOTH firemode to fire both barrels in quick succession."
SWEP.Trivia_Manufacturer = "Gryphon Arms"
SWEP.Trivia_Calibre = "12 Gauge"
SWEP.Trivia_Mechanism = "Break-Action"
SWEP.Trivia_Country = "USA"
SWEP.Trivia_Year = 1972

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/c_db.mdl"
SWEP.WorldModel = "models/weapons/arccw/w_db.mdl"
SWEP.ViewModelFOV = 60

SWEP.Damage = 32
SWEP.DamageMin = 18 -- damage done at maximum range
SWEP.Range = 35 -- in METRES
SWEP.Penetration = 2
SWEP.DamageType = DMG_BUCKSHOT
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 150 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 2 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 2
SWEP.ReducedClipSize = 2
SWEP.Horde_MaxMags = 36
SWEP.Recoil = 6
SWEP.RecoilSide = 1.5
SWEP.MaxRecoilBlowback = 2.45
SWEP.ForceDefaultAmmo = 20
SWEP.Delay = 60 / 1000 -- 60 / RPM.
SWEP.Num = 8 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        PrintName = "SNGL",
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = {"weapon_annabelle", "weapon_shotgun"}
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 60 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 650 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 200

SWEP.Primary.Ammo = "buckshot" -- what ammo type the gun uses

SWEP.ShootVol = 120 -- volume of shoot sound
SWEP.ShootPitch = 90 -- pitch of shoot sound

SWEP.ShootSound = "weapons/arccw/nova/nova-1.wav"
SWEP.ShootSoundSilenced = "weapons/arccw/m590_suppressed_tp.wav"
SWEP.DistantShootSound = "weapons/arccw/nova/nova-1-distant.wav"

SWEP.MuzzleEffect = "muzzleflash_shotgun"
SWEP.ShellModel = "models/shells/shell_12gauge.mdl"
SWEP.ShellPitch = 100
SWEP.ShellSounds = ArcCW.ShotgunShellSoundsTable
SWEP.ShellScale = 1.5

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.94
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.30

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-2.422, 0, 1.452),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.RevolverReload = true

SWEP.BulletBones = {
    [1] = "Weapon_Mag_Fresh_2",
    [2] = "Weapon_Mag_Fresh"
}

SWEP.CaseBones = {
    [1] = "Weapon_Mag_2",
    [2] = "Weapon_Mag"
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "shotgun"
SWEP.HoldtypeSights = "ar2"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN

SWEP.ActivePos = Vector(1, 12, -2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(3.5, 2, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.AttachmentElements = {
    --[[["reducedmag"] = {
        VMBodygroups = {{ind = 1, bg = 1}},
        WMBodygroups = {},
    },]]
    ["mount"] = {
        VMElements = {
            {
                Model = "models/weapons/arccw/atts/mount_rail.mdl",
                Bone = "Weapon_Thing",
                Scale = Vector(1, 1, 1),
                Offset = {
                    pos = Vector(0, -2.5, -1),
                    ang = Angle(90, 0, -90)
                }
            }
        },
    }
}

SWEP.ExtraSightDist = 5

SWEP.Attachments = {
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = {"optic_lp", "optic"}, -- what kind of attachments can fit here, can be string or table
        Bone = "Weapon_Thing", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0, -2.5, -1), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -90),
            wpos = Vector(13.762, 0.832, -6.102),
            wang = Angle(-10.393, 0, 180)
        },
        InstalledEles = {"mount"}
    },
    {
        PrintName = "Choke",
        DefaultAttName = "Standard Choke",
        Slot = "choke",
    },
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip"},
        Bone = "Weapon_Thing",
        Offset = {
            vpos = Vector(0, -1.25, 2),
            vang = Angle(90, 0, -90),
            wpos = Vector(14.329, 0.602, -4.453),
            wang = Angle(-10.216, 0, 180)
        },
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "Weapon_Thing",
        Offset = {
            vpos = Vector(-0.8, -2, 5), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, 180),
            wpos = Vector(19.625, 0.053, -6.298),
            wang = Angle(-8.829, -0.556, 90)
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
        PrintName = "Ammo Type",
        Slot = {"ammo_bullet"},
        Installed = "arccw_horde_explosive",
        Integral = true,
    },
    {
        PrintName = "Perk",
        Slot = "go_perk"
    },
    {
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "Weapon_Main", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0.75, -0.75, 4), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -90),
            wpos = Vector(6, 1.5, -3),
            wang = Angle(-10, 0, 180)
        },
    },
}

SWEP.BarrelLength = 37

-- draw
-- holster
-- reload
-- fire
-- cycle (for bolt actions)
-- append _empty for empty variation

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 1
    },
    ["draw"] = {
        Source = "draw",
        Time = 0.5,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
        SoundTable = {{s = "weapons/arccw/nova/nova_draw.wav", t = 0}},
    },
    ["ready"] = {
        Source = "ready",
        Time = 1.5,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
        SoundTable = {{s = "weapons/arccw/nova/nova_draw.wav", t = 0}},
    },
    ["fire"] = {
        Source = "shoot",
        Time = 0.4,
    },
    ["fire_iron"] = {
        Source = "shoot_iron",
        Time = 0.4,
    },
    ["reload"] = {
        Source = "reload_part",
        Time = 2.5,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        Checkpoints = {28, 64, 102},
        FrameRate = 30,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.5,
        LastClip1OutTime = 1,
    },
    ["reload_empty"] = {
        Source = "reload",
        Time = 3,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        Checkpoints = {28, 64, 102},
        FrameRate = 30,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.5,
        LastClip1OutTime = 1,
    },
}