SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "TOZ-34"

SWEP.Slot = 2

SWEP.UseHands = true
if CLIENT then
    SWEP.WepSelectIcon = Material("items/hl2/weapon_shotgun.png")
    killicon.AddAlias("arccw_horde_toz34", "items/hl2/weapon_shotgun.png")
end

function SWEP:DrawWeaponSelection(x, y, w, h, a)
    surface.SetDrawColor(255, 255, 255, a)
    surface.SetMaterial(self.WepSelectIcon)

    surface.DrawTexturedRect(x, y, w, w / 2)
end

SWEP.WorldModel = "models/weapons/arccw/w_defender.mdl"
SWEP.ViewModelFOV = 70

SWEP.Damage = 17
SWEP.DamageMin = 10 -- damage done at maximum range
SWEP.RangeMin = 15
SWEP.Range = 25 -- in METRES
SWEP.Penetration = 10
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 690 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 0-- how many rounds can be chambered.
SWEP.Primary.ClipSize = 2 -- DefaultClip is automatically set.
SWEP.Horde_MaxMags = 60
SWEP.ClipsPerAmmoBox = 10

SWEP.Recoil = 5.25
SWEP.RecoilSide = .6
SWEP.MaxRecoilBlowback = 1.1

SWEP.Delay = 60 / 600 -- 60 / RPM.
SWEP.Num = 6 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = {
    "weapon_shotgun",
}
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 60 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 500 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 100

SWEP.Primary.Ammo = "buckshot" -- what ammo type the gun uses
SWEP.MagID = "toz34" -- the magazine pool this gun draws from

SWEP.ShootSound = Sound("CW_FAS2_TOZ34_SHOOT")

SWEP.MuzzleEffect = "muzzleflash_shotgun"
SWEP.ShellModel = "models/shells/shell_12gauge.mdl"
SWEP.ShellPitch = 100
SWEP.ShellSounds = ArcCW.ShotgunShellSoundsTable
SWEP.ShellScale = 1.5

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on
--[[SWEP.ProceduralViewBobAttachment = 1
SWEP.CamAttachment = 3]]

SWEP.SpeedMult = .95
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.4

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-3, -4.151, 2.76),
    Ang = Angle(0.55, 0, 0),
    Magnification = 1.1,
    CrosshairInSights = false,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN

SWEP.ActivePos = Vector(0, 0, 0)
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
    {
        PrintName = "Perk",
        Slot = "perk",
    },
}

local function addSound(name, snd, level)
	sound.Add({name = name, ["sound"] = snd, level = level})
end
addSound("CW_FAS2_TOZ34_SHOOT", "weapons/ks23/ks23_fire1.wav")
addSound("CW_FAS2_TOZ34_CLOSE", "weapons/toz34/toz34_close.wav")
addSound("CW_FAS2_TOZ34_OPENSTART", "weapons/toz34/toz34_open_start.wav")
addSound("CW_FAS2_TOZ34_OPENFINISH", "weapons/toz34/toz34_open_finish.wav")
addSound("CW_FAS2_TOZ34_INSERT", {"weapons/toz34/toz34_shell_in1.wav", "weapons/toz34/toz34_shell_in2.wav"})
SWEP.ViewModel			        = "models/weapons/view/shotguns/c_toz34.mdl"

local reload_mult1 = .35
local reload_mult2 = .5

SWEP.Animations = {
    ["draw"] = {
        Source = "draw",
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.2,
    },
    ["idle"] = {
        Source = "idle",
    },
    ["holster"] = {
        Source = "holster",
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.2,
    },
    ["fire"] = {
        Source = "fire01",
    },
    ["fire_iron"] = {
        Source = "fire_iron",
    },
    ["ready"] = {
        Source = "base_ready",
        Time = 1.5,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.2,
        --[[SoundTable = {
            {t = 10 / 30, s = Sound("TFA_AT_AS_VAL.Boltback")},
		    {t = 20 / 30, s = Sound("TFA_AT_AS_VAL.Boltrelease")},
        },]]
    },
    ["reload"] = {
        Source = "reload", --Mult = .64, MinProgress = 2.85, ForceEnd = true,
        --Time = 2,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        LHIK = true,
        LHIKIn = .4, LHIKEaseIn = .2,
        LHIKOut = .65, LHIKEaseOut = .5,
        MagUpIn = 1.5,
        MinProgress = 1.8 / reload_mult1,
        ForceEnd = true,
        Mult=reload_mult1,
        SoundTable = {
            {t = 0.65 * reload_mult1, s = "CW_FAS2_TOZ34_OPENSTART"},
            {t = 1.5 * reload_mult1, s = "CW_FAS2_TOZ34_OPENFINISH"},
            {t = 2.4 * reload_mult1, s = "CW_FOLEY_MEDIUM"},
            {t = 3.6 * reload_mult1, s = "CW_FAS2_TOZ34_INSERT"},
            {t = 4.7 * reload_mult1, s = "CW_FAS2_TOZ34_CLOSE"}
        },
    },
    ["reload_empty"] = {
        Source = "reload_empty", --Mult = .64, MinProgress = 3.75, ForceEnd = true,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        LHIK = true,
        LHIKIn = .4, LHIKEaseIn = .2,
        LHIKOut = .5, LHIKEaseOut = .5,
        MagUpIn = 1.5,
        MinProgress = 2.2 / reload_mult2, ForceEnd = true,
        Mult=reload_mult2,
        SoundTable = {
            {t = 0.65 * reload_mult2, s = "CW_FAS2_TOZ34_OPENSTART"},
            {t = 0.8 * reload_mult2, s = "CW_FAS2_TOZ34_OPENFINISH"},
            {t = 1.4 * reload_mult2, s = "CW_FOLEY_MEDIUM"},
            {t = 2.6 * reload_mult2, s = "CW_FAS2_TOZ34_INSERT"},
            {t = 2.65 * reload_mult2, s = "CW_FAS2_TOZ34_INSERT"},
            {t = 3.65 * reload_mult2, s = "CW_FAS2_TOZ34_CLOSE"}
        },
    },
}