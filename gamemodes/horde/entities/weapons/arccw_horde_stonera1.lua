SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_horde_stonera1.vtf")
    killicon.Add("arccw_horde_stonera1", "arccw/weaponicons/arccw_horde_stonera1", Color(0, 0, 0, 255))
end
SWEP.PrintName = "Stoner LMG A1"

SWEP.Slot = 4

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/tfa_ins2/c_wf_mg25.mdl"
SWEP.WorldModel = "models/weapons/tfa_ins2/w_wf_mg25.mdl"
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

SWEP.Damage = 55
SWEP.DamageMin = 45 -- damage done at maximum range
SWEP.RangeMin = 25
SWEP.Range = 50 -- in METRES

SWEP.Penetration = 10
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 550 -- projectile or phys bullet muzzle velocity
-- IN M/S

--[[SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(34, 88, 250)
SWEP.TracerWidth = 3
SWEP.Tracer = "cel_muzzleflash"]]
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 160 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 200
SWEP.ReducedClipSize = 80

SWEP.Recoil = .45
SWEP.RecoilSide = .2
SWEP.RecoilRise = .5
SWEP.VisualRecoilMult = 0.11

SWEP.Delay = 60 / 630 -- 60 / RPM.
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

SWEP.NPCWeaponType = {"weapon_ar2"}
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 1.5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 400 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 200

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses
SWEP.MagID = "mg25" -- the magazine pool this gun draws from

SWEP.ShootVol = 115 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

--SWEP.FirstShootSound = "ArcCW_BO1.M14_Fire"
SWEP.ShootSound = Sound("TFA_INS2.WF_MG25.1")
SWEP.ShootSoundSilenced = Sound("AK117.FireS")

SWEP.MuzzleEffect = "muzzleflash_ak47"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 90
SWEP.ShellScale = 1.5

--[[SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on
SWEP.ProceduralViewBobAttachment = 1]]
--SWEP.CamAttachment = 5

SWEP.SpeedMult = 0.85
SWEP.SightedSpeedMult = 0.5
SWEP.Sightt = 0.35

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-3.975, -4, 0.52),
    Ang = Vector(0.1, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

--[[SWEP.ActivePos = Vector(0, -1, -1)
SWEP.ActiveAng = Angle(0, 0, 0)]]

SWEP.SprintPos = Vector(4.8, 6, 0)
SWEP.SprintAng = Angle(-7.036, 30.016, 0)

SWEP.CustomizePos = Vector(15, 4, -2)
SWEP.CustomizeAng = Angle(15, 40, 20)

SWEP.HolsterPos = Vector(4.8, 6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 22

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
            wpos = Vector(10, 1.476, -7),
            wang = Angle(0, 0, 180)
        },
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "A_LaserFlashlight",
        Offset = {
            vpos = Vector(-0.29, 0, 0),
            vang = Angle(0, 0, 0),
            wpos = Vector(17, 1, -3.5),
            wang = Angle(0, 0, 0)
        },
        InstalledEles = {"sidemount"},
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "A_LaserFlashlight",
        Offset = {
            vpos = Vector(2, 0, 0),
            vang = Angle(0, 0, 0),
            wpos = Vector(26.648, 0.782, -5.5),
            wang = Angle(0, 0,  0)
        },
    },
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip"},
        Bone = "A_LaserFlashlight",
        VMScale = Vector(1.2, 1, 1),
        WMScale = Vector(1.2, 1, 1),
        Offset = {
            vpos = Vector(-13, -2.9, 0), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 0, 90),
            wpos = Vector(9.5, 1.15, -3.5),
            wang = Angle(172, -181, -1.5),
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
    --[[["idle"] = {
        Source = "idle",
    },]]
    ["ready"] = {
        Source = "base_ready",
        t = .25,
        SoundTable = {
            {t = 0, s = Sound("TFA_INS2.Draw")},
            {t = 23 / 30, s = Sound("TFA_INS2.WF_MG25.Boltback")},
            {t = 33 / 30, s = Sound("TFA_INS2.WF_MG25.Boltrelease")},
            {t = 56 / 30, s = Sound("TFA_INS2.WF_MG25.Shoulder")},
        },
    },
    ["draw"] = {
        Source = "base_draw",
        t = 1,
        SoundTable = {
            {t = 0, s = Sound("TFA_INS2.Draw")},
        }
    },
    ["reload"] = {
        Source = "base_reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,-- Time= 5.5,
        LHIKIn = .6, LHIKEaseIn = .5,
        LHIKOut = 1.2, LHIKEaseOut = .3,
		SoundTable = {
			{t = 2 / 31.5, s = Sound("TFA_INS2.LeanIn")},
			{t = 31 / 31.5, s = Sound("TFA_INS2.WF_MG25.CoverOpen")},
			{t = 80 / 31.5, s = Sound("TFA_INS2.WF_MG25.MagoutFull")},
			{t = 100 / 31.5, s = Sound("TFA_INS2.WF_MG25.ArmMovement_01")},
			{t = 120 / 31.5, s = Sound("TFA_INS2.WF_MG25.FetchMag")},
			{t = 141 / 31.5, s = Sound("TFA_INS2.WF_MG25.MagHit")},
			{t = 146 / 31.5, s = Sound("TFA_INS2.WF_MG25.Magin")},
			{t = 176 / 31.5, s = Sound("TFA_INS2.WF_MG25.BeltJingle")},
			{t = 186 / 31.5, s = Sound("TFA_INS2.WF_MG25.BeltAlign")},
			{t = 205 / 31.5, s = Sound("TFA_INS2.WF_MG25.ArmMovement_01")},
			{t = 215 / 31.5, s = Sound("TFA_INS2.WF_MG25.CoverClose")},
			{t = 233 / 31.5, s = Sound("TFA_INS2.WF_MG25.Boltrelease")},
			{t = 263 / 31.5, s = Sound("TFA_INS2.WF_MG25.Shoulder")},
        }
    },
    ["reload_empty"] = {
        Source = "base_reload_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,-- Time= 6.5,
        LHIKIn = 2.5, LHIKEaseIn = .5,
        LHIKOut = 1.2, LHIKEaseOut = .28,
        SoundTable = {
            {t = 2 / 31.5, s = Sound("TFA_INS2.LeanIn")},
            {t = 23 / 31.5, s = Sound("TFA_INS2.WF_MG25.Boltback")},
            {t = 33 / 31.5, s = Sound("TFA_INS2.WF_MG25.Boltrelease")},
            {t = 60 / 31.5, s = Sound("TFA_INS2.WF_MG25.ArmMovement_01")},
            {t = 95 / 31.5, s = Sound("TFA_INS2.WF_MG25.CoverOpen")},
            {t = 145 / 31.5, s = Sound("TFA_INS2.WF_MG25.Magout")},
            {t = 165 / 31.5, s = Sound("TFA_INS2.WF_MG25.ArmMovement_01")},
            {t = 183 / 31.5, s = Sound("TFA_INS2.WF_MG25.FetchMag")},
            {t = 205 / 31.5, s = Sound("TFA_INS2.WF_MG25.MagHit")},
            {t = 210 / 31.5, s = Sound("TFA_INS2.WF_MG25.Magin")},
            {t = 236 / 31.5, s = Sound("TFA_INS2.WF_MG25.BeltAlign")},
            {t = 253 / 31.5, s = Sound("TFA_INS2.WF_MG25.BeltJingle")},
            {t = 268 / 31.5, s = Sound("TFA_INS2.WF_MG25.ArmMovement_01")},
            {t = 279 / 31.5, s = Sound("TFA_INS2.WF_MG25.CoverClose")},
            {t = 296 / 31.5, s = Sound("TFA_INS2.WF_MG25.Boltrelease")},
            {t = 327 / 31.5, s = Sound("TFA_INS2.WF_MG25.Shoulder")},
        }
    },
    ["holster"] = {
		Source = "base_holster",
        SoundTable = {
           {t = 0, s = Sound("TFA_INS2.Holster")},
    	}
    },
}

SWEP.Hook_ModifyBodygroups = function(wep, data)
    local vm = data.vm

    if wep:GetReloading() then
        local reload_start = wep.LastAnimStartTime
        local reload_end = wep.LastAnimFinishTime
        local is_empty_reload = wep.LastAnimKey == "reload_empty"
        if CurTime() - reload_start > (is_empty_reload and 5.8 or 3.8) then
            vm:SetBodygroup(3, 7)
            return
        end
    end

    local clip = wep:Clip1()
    vm:SetBodygroup(3, clip > 7 and 7 or clip)
end
