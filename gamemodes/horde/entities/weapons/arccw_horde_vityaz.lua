
SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "PP Vityaz-19"
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
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_bo3_stg44.vtf")
    killicon.Add("arccw_horde_stg44", "arccw/weaponicons/arccw_bo3_stg44", Color(0, 0, 0, 255))
end
--soap's smg
SWEP.ViewModel		= "models/weapons/ethereal/v_vityaz.mdl"
SWEP.WorldModel		= "models/weapons/ethereal/w_vityaz.mdl"
--SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {pos        =    Vector(
    7, 1, -2
    ),
    ang        =    Angle(0, 0, 180),--Angle(-5, -0.25, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
    scale   =   1.0
}
SWEP.ViewModelFOV = 60

SWEP.Damage = 48
SWEP.DamageMin = 38 -- damage done at maximum range
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

SWEP.ChamberSize = 0-- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 60
SWEP.ReducedClipSize = 20

SWEP.Recoil = 0.25
SWEP.RecoilSide = 0.08
SWEP.RecoilRise = 0.2
SWEP.VisualRecoilMult = .5

SWEP.Delay = 60 / 700 -- 60 / RPM.
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
SWEP.HipDispersion = 700 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150

SWEP.Primary.Ammo = "smg1" -- what ammo type the gun uses
SWEP.MagID = "vityaz" -- the magazine pool this gun draws from

SWEP.ShootSound			= Sound("CW_KK_INS2_MP5K_FIRE")
SWEP.ShootSoundSilenced			= Sound("CW_KK_INS2_MP5K_FIRE_SUPPRESSED")
SWEP.MuzzleEffect = "muzzleflash_m3"
SWEP.ShellModel = "models/shells/shell_12gauge.mdl"
SWEP.ShellPitch = 100
SWEP.ShellSounds = ArcCW.ShotgunShellSoundsTable
SWEP.ShellScale = 1.5
SWEP.ShellRotateAngle = Angle(0, 90, 0)

--[[SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on
SWEP.ProceduralViewBobAttachment = 1
SWEP.CamAttachment = 3]]

SWEP.SpeedMult = 0.95
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
    Pos = Vector(-2.998, -2, 1.5),
    Ang = Vector(0.02, 0, 0),
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

SWEP.Attachments = {
    { --1
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = {"optic", "optic_lp"}, -- what kind of attachments can fit here, can be string or table
        Bone = "A_Optic",
        Offset = {
            vpos = Vector(0, 0, -.7), -- offset that the attachment will be relative to the bone
            vang = Angle(-90, -180, -90),
            wpos = Vector(18.5, .5, -6.5),
            wang = Angle(0, 0, -180),
        },
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
            wpos = Vector(23.65, .55, -4.4),
            wang = Angle(0, 0, -180),
        },
    },
    { --7
        PrintName = "Tactical",
        Slot = {"tac"},
        Bone = "A_LaserFlashlight",
        Offset = {
            vpos = Vector(0, .5, -.5), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 0, -90),
            wpos = Vector(18, 2.55, -4.5),
            wang = Angle(-7.5, 0, 88)
        },
    },
    { --11
        PrintName = "Ammo Type",
        Slot = "ammo_bullet",
    },
    { --12
        PrintName = "Perk",
        Slot = "perk",
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
        ExcludeFlags = {"wolf_ee"},
    },
}

SWEP.Animations = {
    ["ready"] = {
        Source = "base_ready",
        SoundTable = {
            {t = 0, s = "CW_KK_INS2_UNIVERSAL_DRAW"},
		    {t = 12/30, s = "CW_KK_INS2_MP5K_BOLTLOCK"},
         }
        
	},
    ["draw"] = {
        Source = "base_draw",
    },
    ["reload"] = {
        Source = "base_reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
		Time = 2.7,
        LHIKIn = .6, LHIKEaseIn = .5,
        LHIKOut = .55, LHIKEaseOut = .3, SoundTable = {
        {t = 19/30, s = "CW_KK_INS2_MP5K_MAGRELEASE"},
		{t = 24/30, s = "CW_KK_INS2_MP5K_MAGOUT"},
		{t = 65/30, s = "CW_KK_INS2_MP5K_MAGIN"}, },
    },
    ["reload_empty"] = {
        Source = "base_reloadempty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
		Time = 3.5,
        LHIKIn = .6, LHIKEaseIn = .5,
        LHIKOut = .7, LHIKEaseOut = .5,
        SoundTable = {
            {t = 19/30, s = "CW_KK_INS2_MP5K_MAGRELEASE"},
            {t = 24/30, s = "CW_KK_INS2_MP5K_MAGOUT"},
            {t = 65/30, s = "CW_KK_INS2_MP5K_MAGIN"},
            {t = 98/30, s = "CW_KK_INS2_MP5K_BOLTLOCK"},
            {t = 102/30, s = "CW_KK_INS2_MP5K_BOLTRELEASE"},
        },
    },
    ["holster"] = {
		Source = "base_holster",
        SoundTable = {
           {t = 0, s = Sound("TFA_INS2.Holster")},
    	}
    },
}