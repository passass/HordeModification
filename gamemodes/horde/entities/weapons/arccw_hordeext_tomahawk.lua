if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/killicons/arccw_hordeext_tomahawk.vtf")
    killicon.Add("arccw_horde_tomahawk", "vgui/killicons/arccw_hordeext_tomahawk", Color(0, 0, 0, 255))
end
SWEP.Base = "arccw_horde_base_melee"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Tomahawk"

SWEP.Slot = 0

SWEP.NotForNPCs = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/tfa_cso/c_tomahawk.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_tomahawk.mdl"
SWEP.ViewModelFOV = 80
SWEP.WorldModelOffset = {
    pos        =    Vector(3.5, 2, -8),
    ang        =    Angle(0, 180, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
}

SWEP.DefaultSkin = 0
SWEP.DefaultWMSkin = 0

SWEP.MeleeDamage = 70
SWEP.Melee2Damage = 160

SWEP.PrimaryBash = true
SWEP.CanBash = true
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeRange = 50
SWEP.MeleeAttackTime = 0
SWEP.MeleeTime = .6
SWEP.MeleeGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE

SWEP.Melee2 = true
SWEP.Melee2Range = 85
SWEP.Melee2AttackTime = 0
SWEP.Melee2Time = 1.2
SWEP.Melee2Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE


SWEP.MeleeSwingSound = {
    "weapons/tfa_cso/tomahawk/slash1.wav", "weapons/tfa_cso/tomahawk/slash2.wav"
}
SWEP.MeleeMissSound = {
    "weapons/tfa_cso/tomahawk/slash1.wav", "weapons/tfa_cso/tomahawk/slash2.wav"
}
SWEP.MeleeHitSound = {
    "weapons/tfa_cso/tomahawk/wall.wav"
}
SWEP.MeleeHitNPCSound = {
    "weapons/tfa_cso/tomahawk/hit1.wav", "weapons/tfa_cso/tomahawk/hit2.wav"
}

SWEP.NotForNPCs = true

SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "MELEE"
    },
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "melee"

SWEP.Primary.ClipSize = -1

SWEP.AttachmentElements = {
}

SWEP.Attachments = {
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    ["draw"] = {
        Source = "draw",
    },
    ["bash"] = {
        Source = {"slash1", "slash2"},
    },
    ["bash2"] = {
        Source = "stab",
    },
}

SWEP.IronSightStruct = false

SWEP.ActivePos = Vector(0, 0, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.BashPreparePos = Vector(0, 0, 0)
SWEP.BashPrepareAng = Angle(0, 0, 0)

SWEP.BashPos = Vector(0, 0, 0)
SWEP.BashAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(0,0, 0)
SWEP.HolsterAng = Angle(0, 0, 0)