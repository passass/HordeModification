
SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Galil ARM/SAR Extended"
SWEP.Trivia_Class = "Assault Rifle"

SWEP.Slot = 2

SWEP.UseHands = true
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_galil556.vtf")
    killicon.Add("arccw_horde_machgungalil", "vgui/inventory/arccw_galil556", Color(0, 0, 0, 255))
end
--soap's smg
SWEP.ViewModel		= "models/weapons/v_galil.mdl"
SWEP.WorldModel		= "models/weapons/w_galil.mdl"
--SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {pos        =    Vector(
    4.919, 0.964, -1.055
    ),
    ang        =    Angle(-10, 0, 180),--Angle(-5, -0.25, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
    scale   =   1.0
}
SWEP.ViewModelFOV = 60
SWEP.Horde_MaxMags = 11
SWEP.Damage = 51
SWEP.DamageMin = 45 -- damage done at maximum range
SWEP.RangeMin = 5
SWEP.Range = 45 -- in METRES
SWEP.Penetration = 6
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 690 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 1-- how many rounds can be chambered.
SWEP.Primary.ClipSize = 60 -- DefaultClip is automatically set.

SWEP.Recoil = 0.6
SWEP.RecoilSide = 0.35
SWEP.RecoilRise = .9
SWEP.VisualRecoilMult = .45

SWEP.Delay = 60 / 600 -- 60 / RPM.
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

local function addSound(name, snd, level) 
	sound.Add({name = name, ["sound"] = snd, level = level})
end

local function addFireSound(name, snd, volume, soundLevel, channel, pitchStart, pitchEnd, noDirection)
	local tbl = {}
	volume = volume or 1
	soundLevel = soundLevel or 97
	channel = channel or CHAN_AUTO
	pitchStart = pitchStart or 92
	pitchEnd = pitchEnd or 112
	
	tbl.name = name
	tbl.sound = snd
	
	tbl.channel = channel
	tbl.volume = volume
	tbl.level = soundLevel
	tbl.pitchstart = pitchStart
	tbl.pitchend = pitchEnd
	
	sound.Add(tbl)
end

addFireSound("CW_KK_INS2_GALIL_FIRE", "weapons/galil/galil_fp.wav", 1, 100, CHAN_STATIC)
addFireSound("CW_KK_INS2_GALIL_FIRE_SUPPRESSED", "weapons/galil/galil_suppressed_fp.wav", 1, 70, CHAN_STATIC)

addSound("CW_KK_INS2_GALIL_BOLTBACK", "weapons/galil/handling/galil_boltback.wav")
addSound("CW_KK_INS2_GALIL_BOLTRELEASE", "weapons/galil/handling/galil_boltrelease.wav")
addSound("CW_KK_INS2_GALIL_DRUM_MAGFETCH", "weapons/galil/handling/galil_drum_mag_fetch.wav")
addSound("CW_KK_INS2_GALIL_DRUM_MAGHIT", "weapons/galil/handling/galil_drum_maghit.wav")
addSound("CW_KK_INS2_GALIL_DRUM_MAGIN", "weapons/galil/handling/galil_drum_magin.wav")
addSound("CW_KK_INS2_GALIL_DRUM_MAGOUT", "weapons/galil/handling/galil_drum_magout.wav")
addSound("CW_KK_INS2_GALIL_DRUM_MAGOUTRATTLE", "weapons/galil/handling/galil_drum_magout_rattle.wav")
addSound("CW_KK_INS2_GALIL_EMPTY", "weapons/galil/handling/galil_empty.wav")
addSound("CW_KK_INS2_GALIL_FIRESELECT", "weapons/galil/handling/galil_fireselect_1.wav")
addSound("CW_KK_INS2_GALIL_MAGIN", "weapons/galil/handling/galil_magin.wav")
addSound("CW_KK_INS2_GALIL_MAGOUT", "weapons/galil/handling/galil_magout.wav")
addSound("CW_KK_INS2_GALIL_MAGRELEASE", "weapons/galil/handling/galil_magrelease.wav")
addSound("CW_KK_INS2_GALIL_RATTLE", "weapons/galil/handling/galil_rattle.wav")

SWEP.AccuracyMOA = 2 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 700 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses
SWEP.MagID = "galil" -- the magazine pool this gun draws from

SWEP.ShootSound			= Sound("CW_KK_INS2_GALIL_FIRE")
SWEP.ShootSoundSilenced			= Sound("CW_KK_INS2_GALIL_FIRE_SUPPRESSED")
SWEP.MuzzleEffect = "muzzleflash_m3"
SWEP.MuzzleEffect = "muzzleflash_1"
SWEP.ShellModel = "models/shells/shell_762nato.mdl"
SWEP.ShellScale = 1.25
SWEP.ShellMaterial = "models/weapons/arcticcw/shell_556_steel"

--[[SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on
SWEP.ProceduralViewBobAttachment = 1
SWEP.CamAttachment = 3]]

SWEP.SpeedMult = 0.9
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.225

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-2.2259, -2, 0.6884),
    Ang = Vector(-0.0408, 0.039, 0),
    Magnification = 1.1,
    CrosshairInSights = false ,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2


SWEP.ActivePos = Vector(0, 0, 1.2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(0, -1, -1)
SWEP.SprintAng = Angle(0, 15, 0)

SWEP.CustomizePos = Vector(16, -3, -2)
SWEP.CustomizeAng = Angle(15, 40, 30)

SWEP.HolsterPos = Vector(8, -3, -1)
SWEP.HolsterAng = Angle(-7.036, 40.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 27

SWEP.ExtraSightDist = 5

SWEP.AttachmentElements = {
	["mag"] = {
        VMElements = {
            {
                Model = "models/weapons/upgrades/a_magazine_galil_75.mdl",
                Bone = "Magazine",
                Scale = Vector(1, 1, 1),
                Offset = {
                    pos = Vector(-2.3, 11, 6),
                    ang = Angle(0, 90, 0)
                }
            }
        },
		WMElements = {
            {
                Model = "models/weapons/upgrades/a_magazine_galil_75.mdl",
                Bone = "W_MAGAZINE",
                Scale = Vector(1.3, 1.3, 1.3),
                Offset = {
                    pos = Vector(-4, 4, -5.7),
                    ang = Angle(170, 180, 0)
                }
            }
        },
    },
	["mount"] = {
        VMElements = {
            {
                Model = "models/weapons/upgrades/a_mount_galil.mdl",
                Bone = "A_Optic",
                Scale = Vector(1, 1, 1),
                Offset = {
                    pos = Vector(0, -.6, 1),
                    ang = Angle(90, 0, 90)
                }
            }
        },
    },
}


SWEP.Attachments = {
    {
	DefaultEles = {"mag"},
	Hidden=true,
    },
    { --1
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = {"optic", "optic_lp"}, -- what kind of attachments can fit here, can be string or table
        Bone = "A_Optic",
        Offset = {
            vpos = Vector(0, .1, 0), -- offset that the attachment will be relative to the bone
            vang = Angle(-90, -180, -90),
            wpos = Vector(18.5, .5, -8),
            wang = Angle(-10, 0, -180),
        },
		InstalledEles =	{"mount"},
    },
    { --2
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        VMScale = Vector(1.25, 1.25, 1.25),
        Bone = "A_Muzzle",
        Offset = {
            vpos = Vector(0, 0, 0),
            vang = Angle(0, 0, 0),
            wpos = Vector(31, 1, -8.3),
            wang = Angle(-10, 0, -180),
        },
    },
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip"},
        Bone = "A_UnderBarrel",
        Offset = {
            vpos = Vector(-5, 0, 0), -- offset that the attachment will be relative to the bone
            vang = Angle(180, 180, 0),
            wpos = Vector(15, 1.15, -4.5),
            wang = Angle(170, -180, 0),
        },
    }, --3
    { --7
        PrintName = "Tactical",
        Slot = {"tac"},
        Bone = "A_LaserFlashlight",
        Offset = {
            vpos = Vector(-3, .65, 1), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 0, -90),
            wpos = Vector(18, 3.2, -5.5),
            wang = Angle(-10, 0, 88)
        },
    },
    { --11
        PrintName = "Ammo Type",
        Slot = "go_ammo",
        DefaultAttName = "Standard Ammo",
    },
    { --12
        PrintName = "Perk",
        Slot = "go_perk",
    },
}

local reloadmult = .9

SWEP.Animations = {
    ["ready"] = {
        Source = "base_ready",
        SoundTable = {
            {t = 0, s = "CW_KK_INS2_UNIVERSAL_DRAW"},
            {t = 20/30, s = "CW_KK_INS2_GALIL_FIRESELECT"},
            {t = 39/30, s = "CW_KK_INS2_GALIL_BOLTBACK"},
            {t = 48/30, s = "CW_KK_INS2_GALIL_BOLTRELEASE"},
            {t = 60/30, s = "CW_KK_INS2_UNIVERSAL_LEANIN"},
        }
    },
    ["draw"] = {
        Source = "base_draw",
        SoundTable = {
            {t = 0, s = "CW_KK_INS2_UNIVERSAL_DRAW"},
        }
    },
    ["reload"] = {
        Source = "base_reload_drum",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true, Mult = .9,
        LHIKIn = .6, LHIKEaseIn = .5,
        LHIKOut = .55, LHIKEaseOut = .3, 
	SoundTable = {
		{t = 19/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_MAGRELEASE"},
		{t = 22/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_DRUM_MAGOUT"},
		{t = 28/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_DRUM_MAGOUTRATTLE"},
		{t = 30/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_DRUM_MAGFETCH"},
		{t = 105/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_DRUM_MAGIN"},
		{t = 142/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_DRUM_MAGHIT"},
		{t = 161/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_RATTLE"},
	},
    },
    ["reload_empty"] = {
        Source = "base_reloadempty_drum",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true, Mult = .9,
	--t = 3.5,
        LHIKIn = .6, LHIKEaseIn = .5,
        LHIKOut = .7, LHIKEaseOut = .5,
        SoundTable = {
			{t = 19/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_MAGRELEASE"},
			{t = 22/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_DRUM_MAGOUT"},
			{t = 28/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_DRUM_MAGOUTRATTLE"},
			{t = 30/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_DRUM_MAGFETCH"},
			{t = 105/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_DRUM_MAGIN"},
			{t = 142/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_DRUM_MAGHIT"},
			{t = 161/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_RATTLE"},
			{t = 190/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_BOLTBACK"},
			{t = 201/31.8 * reloadmult, s = "CW_KK_INS2_GALIL_BOLTRELEASE"},
			{t = 223/31.8 * reloadmult, s = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		},
    },
    ["holster"] = {
		Source = "base_holster",
        SoundTable = {
           {t = 0, s = Sound("TFA_INS2.Holster")},
    	}
    },
}