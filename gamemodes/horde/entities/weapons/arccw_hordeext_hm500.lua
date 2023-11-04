SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

local path = "weapons/yurie_customs/hm500/"
local pref = "YURIE_CUSTOMS.HM500"

TFA.AddFireSound(pref .. ".1", {path .. "magnum-1.wav", path .. "magnum-2.wav", path .. "magnum-3.wav"}, false, ")")

TFA.AddWeaponSound(pref .. ".Draw", path .. "handling/draw.wav")
TFA.AddWeaponSound(pref .. ".Holster", path .. "handling/holster.wav")

TFA.AddWeaponSound(pref .. ".CockHammer", path .. "handling/revolver_cock_hammer.wav")
TFA.AddWeaponSound(pref .. ".CylinderOpen", path .. "handling/revolver_open_chamber.wav")
TFA.AddWeaponSound(pref .. ".CylinderClose", path .. "handling/revolver_close_chamber.wav")
TFA.AddWeaponSound(pref .. ".DumpRounds", path .. "handling/revolver_dump_rounds.wav")
TFA.AddWeaponSound(pref .. ".SpeedLoaderInsert", path .. "handling/revolver_speed_loader_insert.wav")

TFA.AddWeaponSound(pref .. ".MagTransition", path .. "handling/cloth_magtransition01.wav")
TFA.AddWeaponSound(pref .. ".StartReload", path .. "handling/cloth_startreload01.wav")
TFA.AddWeaponSound(pref .. ".ReturnToIdle", path .. "handling/cloth_returntoidle01.wav")

TFA.AddWeaponSound(pref .. ".InspectionSpin", path .. "csgo/deagle_special_lookat_f133.wav")
TFA.AddWeaponSound(pref .. ".InspectionSpinStop", path .. "csgo/deagle_special_lookat_f111.wav")




SWEP.PrintName = "H-M500"
--[[SWEP.Trivia_Class = "Pistol"
SWEP.Trivia_Desc = ".40 Caliber semi automatic pistol. Commonly used among police and popular with civilians for its reliability."
SWEP.Trivia_Manufacturer = "Auschen Waffenfabrik"
SWEP.Trivia_Calibre = ".40 S&W"
SWEP.Trivia_Mechanism = "Short Recoil"
SWEP.Trivia_Country = "Austria"
SWEP.Trivia_Year = 1993]]

SWEP.Slot = 1

SWEP.UseHands = true

SWEP.Damage = 95
SWEP.DamageMin = 75 -- damage done at maximum range
SWEP.RangeMin = 25
SWEP.Range = 50
SWEP.Penetration = 3
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 300 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.CanFireUnderwater = true
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 6 -- DefaultClip is automatically set.

SWEP.Recoil = 1.75
SWEP.RecoilSide = 0.8
SWEP.RecoilRise = 2

SWEP.Delay = 60 / 240 -- 60 / RPM.
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

SWEP.AccuracyMOA = 2.5
SWEP.HipDispersion = 200
SWEP.MoveDispersion = 100

SWEP.Horde_MaxMags = 15
SWEP.Primary.Ammo = "ammo_starterweapon" -- what ammo type the gun uses

SWEP.ShootVol = 115 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.CantDropWep = true
SWEP.ForceDefaultAmmo = 0

SWEP.ShootSound = Sound("YURIE_CUSTOMS.HM500.1")
SWEP.ShootSoundSilenced = "weapons/arccw/usp/usp_01.wav"
SWEP.DistantShootSound = "weapons/arccw/hkp2000/hkp2000-1-distant.wav"

SWEP.MuzzleEffect = "muzzleflash_pistol"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellScale = 1.5

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.Sightt = 0.15

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.8

SWEP.BarrelLength = 8

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false
SWEP.ClipsPerAmmoBox = 3
SWEP.CaseBones = {}
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/killicons/arccw_hordeext_hm500.vtf")
	killicon.Add("arccw_hordeext_hm500", "vgui/killicons/arccw_hordeext_hm500")
end

SWEP.IronSightStruct = {
    Pos = Vector(-1.685, 4, 0.725),
    Ang = Angle(0.401, -0.015, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "revolver"
SWEP.HoldtypeSights = "revolver"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.ExtraSightDist = 7

SWEP.WorldModelOffset = {
    pos = Vector(6.5, 1, -1),
    ang = Angle( 0, 00, 180 ),
    scale = 1.1
}

SWEP.ViewModel          = "models/weapons/yurie_customs/c_hm500.mdl"
SWEP.WorldModel         = "models/weapons/yurie_customs/w_hm500.mdl"
SWEP.ViewModelFOV = 70

SWEP.ActivePos = Vector(0,0,0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(4.8, 6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.MirrorVMWM = false

SWEP.Attachments = {
    {
        PrintName = "Optic",
        DefaultAttName = "Iron Sights",
        Slot = "optic_lp",
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(4, 0, 4),
            vang = Angle(0, 0, 0),
            wpos = Angle(6, 0, -3.75),
            wang = Angle(0, 0, 180)
        },
    },
    {
        PrintName = "Tactical",
        Slot = "tac_pistol",
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(8, 0, 3),
            vang = Angle(0, 0, 90),
            wpos = Vector(8.5, 0, -3),
            wang = Angle(0, 0, 180)
        },
    },
    {
        PrintName = "Ammo Type",
        Slot = "go_ammo",
        DefaultAttName = "Standard Ammo"
    },
    {
        PrintName = "Perk",
        Slot = "perk"
    },
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    ["ready"] = {
        Source = "pullout",
        MinProgress = .5,
    },
    ["draw"] = {
        Source = "pullout",
        MinProgress = .5,
    },
    ["fire"] = {
		Source = "fire",
	},
    ["fire_iron"] = {
        Source = "fire",
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
        SoundTable = {
            {t = 0 / 30, s = Sound("YURIE_CUSTOMS.HM500.StartReload")},
            {t = 20 / 30, s = Sound("YURIE_CUSTOMS.HM500.CylinderOpen")},
            {t = 22 / 30, s = Sound("YURIE_CUSTOMS.HM500.DumpRounds")},
            {t = 38 / 30, s = Sound("YURIE_CUSTOMS.HM500.MagTransition")},
            {t = 48 / 30, s = Sound("YURIE_CUSTOMS.HM500.SpeedLoaderInsert")},
            {t = 63 / 30, s = Sound("YURIE_CUSTOMS.HM500.CylinderClose")},
		    {t = 72 / 30, s = Sound("YURIE_CUSTOMS.HM500.ReturnToIdle")},
        },
        
    },
    ["holster"] = {
		Source = "putaway",
	},
}