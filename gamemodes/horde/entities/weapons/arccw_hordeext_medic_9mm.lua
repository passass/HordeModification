if !HORDE.Syringe then return end
SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Killing Floor 2" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "9mm Pistol"
--[[SWEP.Trivia_Class = "Pistol"
SWEP.Trivia_Desc = ".40 Caliber semi automatic pistol. Commonly used among police and popular with civilians for its reliability."
SWEP.Trivia_Manufacturer = "Auschen Waffenfabrik"
SWEP.Trivia_Calibre = ".40 S&W"
SWEP.Trivia_Mechanism = "Short Recoil"
SWEP.Trivia_Country = "Austria"
SWEP.Trivia_Year = 1993]]

SWEP.Slot = 1

SWEP.UseHands = true

SWEP.Damage = 14
SWEP.DamageMin = 10 -- damage done at maximum range
SWEP.RangeMin = 15
SWEP.Range = 45
SWEP.Penetration = 3
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 300 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.CanFireUnderwater = true
SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 15 -- DefaultClip is automatically set.

SWEP.Recoil = 0.8
SWEP.RecoilSide = 0.2
SWEP.RecoilRise = 2

SWEP.Delay = 60 / 600 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
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

SWEP.Primary.Ammo = "pistol" -- what ammo type the gun uses

SWEP.ShootVol = 115 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

local snd1 = Sound("TFA_KF2_9MM.1")
local snd2 = Sound("TFA_KF2_9MM.2")
local snd3 = Sound("TFA_KF2_9MM.3")
SWEP.ShootSound = {snd1, snd2, snd3}
SWEP.ShootSoundSilenced = "weapons/arccw/usp/usp_01.wav"
SWEP.DistantShootSound = "weapons/arccw/hkp2000/hkp2000-1-distant.wav"

SWEP.MuzzleEffect = "muzzleflash_pistol"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellScale = 1.5

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SightTime = 0.175

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.75

SWEP.BarrelLength = 8

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false
SWEP.ClipsPerAmmoBox = 2
SWEP.CaseBones = {}
if CLIENT then
    SWEP.WepSelectIcon = Material("items/hl2/weapon_pistol.png")
    killicon.AddAlias("arccw_kf2_9mm", "weapon_9mm")
end

function SWEP:DrawWeaponSelection(x, y, w, h, a)
    surface.SetDrawColor(255, 255, 255, a)
    surface.SetMaterial(self.WepSelectIcon)

    surface.DrawTexturedRect(x, y, w, w / 2)
end

SWEP.IronSightStruct = {
    Pos = Vector(0,10,0),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.ExtraSightDist = 7

SWEP.WorldModelOffset = {
    pos = Vector(3.75, 1, -3.0),
    ang = Angle( 0, 90, 180 ),
}

SWEP.ViewModel			= "models/weapons/kf2/tfa_c_9mm.mdl"
SWEP.WorldModel			= "models/weapons/kf2/tfa_w_9mm.mdl"
SWEP.ViewModelFOV = 60

SWEP.ActivePos = Vector(3,5,-1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(4.8, 6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.MirrorVMWM = false

SWEP.Attachments = {
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = "optic_lp", -- what kind of attachments can fit here, can be string or table
        Bone = "RW_Barrel", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(1, 0, 0.5), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 0, 0),
            wpos = Vector(6, 1, -5),
            wang = Angle(-2.829, -4.902, 180)
        },
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "RW_Bolt",
        Offset = {
            vpos = Vector(4.25, 0, 0),
            vang = Angle(0, 0, 0),
            wpos = Vector(10, 1, -4.61),
            wang = Angle(0, 0, 0)
        },
    },
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip_pistol", "style_pistol", "tac_pistol"},
        Bone = "RW_Flashlight_Switch",
        Offset = {
            vpos = Vector(0, 0, 0),
            vang = Angle(0, 0, 0),
            wpos = Vector(7.238, 1, -1),
            wang = Angle(0, -4.211, 0)
        },
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
        Bone = "RW_Flashlight_Switch", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(1.5, -.7, .3), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 0, 0),
            wpos = Vector(8, 1.5, -3.5),
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
        Time = 1
    },
    ["draw_empty"] = {
        Source = "idle_empty",
    },
    ["draw"] = {
        Source = "draw",
        Time = 1
    },
    ["fire"] = {
		Source = "shoot",
	},
    ["fire_iron"] = {
        Source = {"shoot_iron", "shoot_iron2", "shoot_iron3"},
    },
    ["reload"] = {
        Source = "reload", MinProgress = 2.35, ForceEnd = true,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Checkpoints = {20, 26, 40},
        LHIK = true,
        LHIKIn = .4,
        LHIKOut = 1.8,
        LHIKEaseIn = 1,
        LHIKEaseOut = .6,
    },
    ["reload_empty"] = {
        Source = "reload_empty", MinProgress = 2.5, ForceEnd = true,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Checkpoints = {20, 26, 40, 60, 80},
        LHIK = true,
        LHIKIn = .4,
        LHIKOut = 2.1,
        LHIKEaseIn = 1,
        LHIKEaseOut = .4,
    },
    ["holster"] = {
		Source = "holster",
	},
}

if HORDE then HORDE.Syringe:ApplyMedicSkills(SWEP, 15, 50) end