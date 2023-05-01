if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("entities/horde_stormgiant.vtf")
    killicon.Add("arccw_horde_stormgiant", "entities/horde_stormgiant", Color(0, 0, 0, 255))
end
SWEP.Base = "arccw_horde_base_melee"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Warhammer Storm Giant"

SWEP.Slot = 0

SWEP.NotForNPCs = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/tfa_cso/c_stormgiant.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_storm_giant.mdl"
SWEP.ViewModelFOV = 80
SWEP.WorldModelOffset = {
    pos        =    Vector(3.5, 0, -8),
    ang        =    Angle(0, 0, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
}

SWEP.DefaultSkin = 0
SWEP.DefaultWMSkin = 0

SWEP.MeleeDamage = 320
SWEP.Melee2Damage = 520

SWEP.PrimaryBash = true
SWEP.CanBash = true
SWEP.MeleeDamageType = DMG_CLUB
SWEP.MeleeRange = 70
SWEP.MeleeAttackTime = .8
SWEP.MeleeTime = 1.2
SWEP.MeleeGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2

SWEP.Melee2 = true
SWEP.Melee2Range = 85
SWEP.Melee2AttackTime = 1
SWEP.Melee2Time = 1.3
SWEP.Melee2Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2

SWEP.MeleeSwingSound = {
    --"weapons/tfa_cso/dual_sword/swing_1.wav", "weapons/tfa_cso/dual_sword/swing_2.wav", "weapons/tfa_cso/dual_sword/swing_3.wav", "weapons/tfa_cso/dual_sword/swing_4.wav", "weapons/tfa_cso/dual_sword/swing_5.wav"
}
SWEP.MeleeMissSound = {
    --"weapons/tfa_cso/dual_sword/swing_1.wav", "weapons/tfa_cso/dual_sword/swing_2.wav", "weapons/tfa_cso/dual_sword/swing_3.wav", "weapons/tfa_cso/dual_sword/swing_4.wav", "weapons/tfa_cso/dual_sword/swing_5.wav"
}
SWEP.MeleeHitSound = {
    "weapons/tfa_cso/stormgiant/hit_world1.wav", "weapons/tfa_cso/stormgiant/hit_world2.wav", "weapons/tfa_cso/stormgiant/hit_world3.wav"
}
SWEP.MeleeHitNPCSound = {
    "weapons/tfa_cso/stormgiant/hit_flesh1.wav", "weapons/tfa_cso/stormgiant/hit_flesh2.wav"
}

SWEP.NotForNPCs = true

SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "MELEE"
    },
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "melee2"

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
        Source = "midslash1",
        Mult = .8,
    },
    ["bash2"] = {
        Source = "midslash2",
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