if not ArcCWInstalled then return end
SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "HX-25"

SWEP.Slot = 1

SWEP.Spawnable = true


SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_kf2_hx25.mdl"
SWEP.WorldModel = "models/weapons/w_kf2_hx25.mdl"
SWEP.MirrorVMWM = true
--SWEP.WorldModelOffset = {
--    pos        =    Vector(-8, 5, -8),
--    ang        =    Angle(-6, 0, 180),
--    bone    =    "ValveBiped.Bip01_R_Hand",
--}
SWEP.WorldModelOffset = {
    pos        =    Vector(0, 5, -7),
    ang        =    Angle(-10, 2.5, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
}
SWEP.ViewModelFOV = 50

SWEP.Damage = 22
SWEP.DamageMin = 12 -- damage done at maximum range
SWEP.Range = 25 -- in METRES
SWEP.Penetration = 0
SWEP.DamageType = DMG_BULLET
-- IN M/S
SWEP.ClipsPerAmmoBox = 5
SWEP.CanFireUnderwater = false

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 1 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 1
SWEP.ReducedClipSize = 1

SWEP.Recoil = 1
SWEP.RecoilSide = 1
SWEP.VisualRecoilMult = 1
SWEP.RecoilRise = 2

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

sound.Add(
{
	name = "HX25.Fidget",
	channel = CHAN_ITEM,
	volume = 1.0,
	soundlevel = 80,
	sound = "weapons/hx25/fidget.wav"
})

sound.Add(
{
	name = "HX25.LatchOpen",
	channel = CHAN_ITEM,
	volume = 1.0,
	soundlevel = 80,
	sound = "weapons/hx25/latchopen.wav"
})

sound.Add(
{
	name = "HX25.ShellOut",
	channel = CHAN_ITEM,
	volume = 1.0,
	soundlevel = 80,
	sound = "weapons/hx25/shellout.wav"
})

sound.Add(
{
	name = "HX25.ShellIn",
	channel = CHAN_ITEM,
	volume = 1.0,
	soundlevel = 80,
	sound = "weapons/hx25/shellin.wav"
})

sound.Add(
{
	name = "HX25.ActionClosed",
	channel = CHAN_ITEM,
	volume = 1.0,
	soundlevel = 80,
	sound = "weapons/hx25/actionclosed.wav"
})

sound.Add(
{
	name = "HX25.Fidget",
	channel = CHAN_ITEM,
	volume = 1.0,
	soundlevel = 80,
	sound = "weapons/hx25/fidget.wav"
})

sound.Add(
{
	name = "HX25.Fidget",
	channel = CHAN_ITEM,
	volume = 1.0,
	soundlevel = 80,
	sound = "weapons/hx25/fidget.wav"
})

sound.Add(
{
	name = "HX25.Deploy",
	channel = CHAN_ITEM,
	volume = 1.0,
	soundlevel = 80,
	sound = "weapons/hx25/deploy.wav"
})

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 75

SWEP.AccuracyMOA = 150 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 200 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 50

SWEP.Primary.Ammo = "SMG1_Grenade" -- what ammo type the gun uses

SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = Sound("weapons/hx25/fire.wav")
SWEP.ShootSoundSilenced = nil
SWEP.DistantShootSound = nil

SWEP.MuzzleEffect = "muzzleflash_pistol"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellScale = 1

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SightTime = 0.175

SWEP.SpeedMult = 0.95
SWEP.SightedSpeedMult = 0.6

SWEP.BarrelLength = 18

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-5.7, -2.98, 1.11),
    Ang = Vector(0.115, -5.979, 0),
    Magnification = 1.3,
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"
SWEP.Horde_MaxMags = 80
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.ActivePos = Vector(0, 0, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(-2, -7.145, -11.561)
SWEP.HolsterAng = Angle(36.533, 0, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.CustomizePos = Vector(12, -8, -4.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)
--[[
SWEP.SprintPos = Vector(0, 0, -0.75)
SWEP.SprintAng = Vector(-14.261, 25.108, 0)]]

SWEP.AttachmentElements = {

}

SWEP.ExtraSightDist = 5

SWEP.Attachments = {
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
}

if (CLIENT) then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/hud/arccw_horde_flaregun")
	killicon.Add("arccw_horde_hx25", "vgui/hud/arccw_horde_flaregun", color_white)
end

SWEP.Animations = {
    ["idle"] = {
    Source = "idle",
    },
    ["draw"] = {
        Source = "deploy",
        --[[SoundTable = {
            {
            s = "weapons/arccw/draw_secondary.wav",
            t = 0
            }
        },]]
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
        MinProgress = .8,
    },
    ["fire"] = {
        Source = "fire",
        MinProgress = .5
    },
    ["fire_iron"] = {
        Source = "fire",
        MinProgress = .5
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.2,

        Mult = .9,

        MinProgress = 1.9, ForceEnd = true
    },
}