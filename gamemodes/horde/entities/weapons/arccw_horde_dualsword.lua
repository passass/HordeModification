if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("entities/horde_dualsword.vtf")
    killicon.Add("arccw_horde_dualsword", "entities/horde_dualsword", Color(0, 0, 0, 255))
end
SWEP.Base = "arccw_horde_base_melee"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Dualsword"

SWEP.Slot = 0

SWEP.NotForNPCs = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/tfa_cso/c_dualphantomslayer.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_dualsword_thunder.mdl"
SWEP.ViewModelFOV = 80
SWEP.WorldModelOffset = {
    pos        =    Vector(3.5, 0, -8),
    ang        =    Angle(0, 0, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
}

SWEP.DefaultSkin = 0
SWEP.DefaultWMSkin = 0

SWEP.MeleeDamage = 33
SWEP.Melee2Damage = 180

SWEP.PrimaryBash = true
SWEP.CanBash = true
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeRange = 50
SWEP.MeleeAttackTime = 0
SWEP.MeleeTime = .135
SWEP.MeleeGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE

SWEP.Melee2 = true
SWEP.Melee2Range = 85
SWEP.Melee2AttackTime = 0
SWEP.Melee2Time = .5
SWEP.Melee2Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE

SWEP.MeleeSwingSound = {
    "weapons/tfa_cso/dual_sword/swing_1.wav", "weapons/tfa_cso/dual_sword/swing_2.wav", "weapons/tfa_cso/dual_sword/swing_3.wav", "weapons/tfa_cso/dual_sword/swing_4.wav", "weapons/tfa_cso/dual_sword/swing_5.wav"
}
SWEP.MeleeMissSound = {
    "weapons/tfa_cso/dual_sword/swing_1.wav", "weapons/tfa_cso/dual_sword/swing_2.wav", "weapons/tfa_cso/dual_sword/swing_3.wav", "weapons/tfa_cso/dual_sword/swing_4.wav", "weapons/tfa_cso/dual_sword/swing_5.wav"
}
SWEP.MeleeHitSound = {
    "weapons/tfa_cso/dual_sword/hit_wall.wav"
}
SWEP.MeleeHitNPCSound = {
    "weapons/tfa_cso/dual_sword/hit_1.wav", "weapons/tfa_cso/dual_sword/hit_2.wav", "weapons/tfa_cso/dual_sword/hit_3.wav"
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
        Source = "idle_a",
    },
    ["draw"] = {
        Source = "draw_a",
    },
    ["bash"] = {
        Source = {"slash_1", "slash_2", "slash_3", "slash_4"},
    },
    ["bash2"] = {
        Source = {"stab1", "stab2"},
    },
}

SWEP.ChargeLoopCooldown = 0

function SWEP:Hook_Think()
    if self.ChargeLoopCooldown <= CurTime() then
        self:EmitSound("weapons/tfa_cso/dual_sword/idle.wav")
        self.ChargeLoopCooldown = CurTime() + 3
    end
end

SWEP.Hit_A = 0
SWEP.Hit_B = 0

function SWEP:Hook_TranslateSequence(seq) 
    if seq == "idle_a" then 
        self.Hit_A = 0
        self.Hit_B = 0
        return
    end
    if istable(seq) then
        local new_seq
        if seq[1] == "slash_1" then
            self.Hit_A = self.Hit_A + 1
            new_seq = "slash_" .. tostring(self.Hit_A)
            if self.Hit_A >= 4 then
                self.Hit_A = 0
            end
        elseif seq[1] == "stab1" then
            self.Hit_B = self.Hit_B + 1
            new_seq = "stab" .. tostring(self.Hit_B)
            if self.Hit_B >= 2 then
                self.Hit_B = 0
            end
        end
        return new_seq
    end
end

SWEP.IronSightStruct = false

SWEP.ActivePos = Vector(0, 0, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.BashPreparePos = Vector(0, 0, 0)
SWEP.BashPrepareAng = Angle(0, 0, 0)

SWEP.BashPos = Vector(0, 0, 0)
SWEP.BashAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(0,0, 0)
SWEP.HolsterAng = Angle(0, 0, 0)