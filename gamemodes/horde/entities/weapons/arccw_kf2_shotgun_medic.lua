SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Killing Floor 2" -- edit this if you like
SWEP.AdminOnly = false
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_kf2_medic_shotgun")
    killicon.Add("arccw_kf2_shotgun_medic", "arccw/weaponicons/arccw_kf2_medic_shotgun", Color(0, 0, 0, 255))
end
SWEP.PrintName = "HMTech-301 Shotgun"
--[[SWEP.Trivia_Class = "Pistol"
SWEP.Trivia_Desc = ".40 Caliber semi automatic pistol. Commonly used among police and popular with civilians for its reliability."
SWEP.Trivia_Manufacturer = "Auschen Waffenfabrik"
SWEP.Trivia_Calibre = ".40 S&W"
SWEP.Trivia_Mechanism = "Short Recoil"
SWEP.Trivia_Country = "Austria"
SWEP.Trivia_Year = 1993]]

SWEP.Slot = 1

SWEP.UseHands = true
if HORDE then HORDE.Syringe:ApplyMedicSkills(SWEP, 15) end
SWEP.ViewModel						= "models/weapons/kf2/tfa_c_medicshotgun.mdl"
SWEP.WorldModel						= "models/weapons/kf2/tfa_w_medicshotgun.mdl"
SWEP.ViewModelFOV = 60

SWEP.ActivePos = Vector(4, 7, -.5)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(4.8, 6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.Damage = 18
SWEP.DamageMin = 12 -- damage done at maximum range
SWEP.Range = 19 -- in METRES
SWEP.Penetration = 1
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
-- IN M/S

SWEP.CanFireUnderwater = true
SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 10 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 20
SWEP.ReducedClipSize = 5

SWEP.Recoil = 2.55
SWEP.RecoilSide = 1
SWEP.RecoilRise = 1.8

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

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 30 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 350 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 450

SWEP.Primary.Ammo = "buckshot" -- what ammo type the gun uses

SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootSound = Sound( "weapons/kf2/medicsg/fire1.wav" )
SWEP.ShootSoundSilenced = "arccw_go/m4a1/m4a1_silencer_01.wav"

SWEP.MuzzleEffect = "muzzleflash_m3"
SWEP.ShellModel = "models/shells/shell_12gauge.mdl"
SWEP.ShellPitch = 100
SWEP.ShellSounds = ArcCW.ShotgunShellSoundsTable
SWEP.ShellScale = 1.5
SWEP.ShellRotateAngle = Angle(0, 90, 0)

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SightTime = 0.3

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.75

SWEP.BarrelLength = 20

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(0, 3, 0),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.ExtraSightDist = 7

SWEP.WorldModelOffset = {
    pos = Vector(3, .8, 0),
    ang = Angle( 0, 90, 190 ),
}

SWEP.Attachments = {
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "RW_Weapon",
        Offset = {
            vpos = Vector(15, 0, .5 ),
            vang = Angle(0, 0, 0),
            wpos = Vector(15, .9, -1.6),
            wang = Angle(-10, 0, 0)
        },
        InstalledEles = {"sidemount"},
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "RW_Weapon",
        Offset = {
            vpos = Vector(18, 0, 3),
            vang = Angle(0, 0, 0),
            wpos = Vector(20, .9, -6.2),
            wang = Angle(-10, 0, 0)
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
        Time = .25
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
        MinProgress = 3, ForceEnd = true,
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
    },
    ["reload_empty"] = {
        MinProgress = 3.25,
        Source = "reload_empty", ForceEnd = true,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
    },
    ["holster"] = {
		Source = "holster",
	},
}