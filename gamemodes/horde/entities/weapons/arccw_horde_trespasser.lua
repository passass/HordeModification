SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - GSO (Pistols)" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Trespasser"

SWEP.Slot = 1

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/trespasser/c_trespasser.mdl"
SWEP.WorldModel = "models/weapons/trespasser/c_trespasser.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "000000000000"

SWEP.Damage = 23
SWEP.DamageMin = 16
SWEP.Primary.ClipSize = 12

SWEP.Range = 40 -- in METRES
SWEP.Penetration = 6
SWEP.DamageType = DMG_SHOCK
SWEP.ShootEntity = nil -- entity to fire, if any
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.

SWEP.PhysBulletMuzzleVelocity = 300

SWEP.Recoil = 0.400
SWEP.RecoilSide = 0.250
SWEP.RecoilRise = 0.1
SWEP.RecoilPunch = 2.5

SWEP.Delay = 60 / 400 -- 60 / RPM.
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

SWEP.AccuracyMOA = 15 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 150 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 35

SWEP.Primary.Ammo = "pistol" -- what ammo type the gun uses
SWEP.MagID = "tres" -- the magazine pool this gun draws from

SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
local path1 = "weapons/trespasser/"
SWEP.ShootSound = { path1 .. "trespasserfire1.wav", path1 .. "trespasserfire2.wav", path1 .. "trespasserfire3.wav", path1 .. "trespasserfire4.wav" }

--[[SWEP.MuzzleEffect = "muzzleflash_pistol"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellPitch = 100
SWEP.ShellScale = 1.25
SWEP.ShellRotateAngle = Angle(0, 180, 0)]]

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.99
SWEP.SightedSpeedMult = 0.75
SWEP.SightTime = 0.200

SWEP.IronSightStruct = {
    Pos = Vector(-4.41, -4, .97),
    Ang = Angle(0.25, 0.025, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = false
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.ActivePos = Vector(-1, 2, -1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-4, 0, -1)
SWEP.CrouchAng = Angle(0, 0, -10)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)
SWEP.BarrelOffsetCrouch = Vector(0, 0, -2)

SWEP.CustomizePos = Vector(8, 0, 1)
SWEP.CustomizeAng = Angle(5, 30, 30)

SWEP.BarrelLength = 24

SWEP.TracerNum = 1 -- tracer every X
SWEP.Tracer = "D2ArcTracer"

SWEP.AttachmentElements = {
    ["rail1"] = {
        VMElements = {
            {
                
                Model = "models/hunter/plates/plate1x1.mdl",
                Bone = "Thigh.L",
                Offset = {
                    pos = Vector(0, -9, -.68),
                    ang = Angle(90, 0, 90),
                },
                Scale = Vector(0.007, 0.007, 0),
                Material = "reticle/destiny2_reddot",
                Color = Color(255, 200, 200, 255),
                DrawFunc = function(wep, el, wm)
                    local sight_progress = wep:GetSightDelta()

                    local fadein = 1 - sight_progress
                    if fadein > .5 then
                        wep.Reticle:SetVector("$color2", Vector(fadein, fadein, fadein))
                        el.NoDraw = false
                    else
                        wep.Reticle:SetVector("$color2", Vector(fadein, fadein, fadein))
                        el.NoDraw = true
                    end
                end
            },
        },
    },
}
if CLIENT then

    SWEP.Reticle = Material("models/trespasser/trespasserReticle")

end

SWEP.ExtraSightDist = 10
SWEP.GuaranteeLaser = true

SWEP.WorldModelOffset = {
    pos = Vector(-15.3, 5.5, -2.5),
    ang = Angle(-12.5, 1, 180),
    scale = .92
}

--SWEP.MirrorVMWM = true

SWEP.Attachments = {
    {
        DefaultEles = {"rail1"},
        Hidden=true,
    },
    {
        PrintName = "Perk",
        Slot = {"go_perk", "go_perk_pistol"}
    },
    {
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "v_weapon.cz_slide", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0.5, 3.5, -0.25), -- offset that the attachment will be relative to the bone
            vang = Angle(90, -90, -90),
        },
        VMScale = Vector(0.5, 0.5, 0.5)
    },
}


SWEP.Animations = {
    ["idle"] = {
        Source = "idle"
    },
    ["draw"] = {
        Source = "draw",
    },
    ["holster"] = {
        Source = "holster",
    },
    --[[["ready"] = {
        Source = "ready",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.5,
    },]]
    ["fire"] = {
        Source = "shoot1",
        --Time = 0.4,
        --ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "shoot1",
        --Time = 0.4,
        --ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        SoundTable = {
            {s = "weapons/trespasser/trespasserreload.wav", t = 0},
        }, Mult = 1 / .95
    },
    ["reload_empty"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        SoundTable = {
            {s = "weapons/trespasser/trespasserreload.wav", t = 0},
        }, Mult = 1 / .95
    },
}