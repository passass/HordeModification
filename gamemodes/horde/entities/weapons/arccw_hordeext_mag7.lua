if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_go_mag7")
    killicon.Add("arccw_hordeext_mag7", "arccw/weaponicons/arccw_go_mag7", Color(0, 0, 0, 255))
end

SWEP.PrintName = "MAG7"
SWEP.Base = "arccw_go_mag7"
SWEP.Category = "ArcCW - Horde"
SWEP.Damage = 18
SWEP.Recoil = 3
SWEP.RecoilSide = 1.35
SWEP.RecoilRise = 0.1
SWEP.RecoilPunch = 2.5
SWEP.Horde_MaxMags = 30
SWEP.ClipsPerAmmoBox = 3

local reload_mult = .85

SWEP.Animations = {
    ["idle"] = {
        Source = "idle"
    },
    ["draw"] = {
        Source = "draw",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.5,
    },
    ["ready"] = {
        Source = "ready",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.5,
    },
    ["fire"] = {
        Source = "shoot",
        Time = 0.5,
    },
    ["fire_iron"] = {
        Source = "shoot",
        Time = 0.5,
    },
    ["cycle"] = {
        Source = "cycle",
        ShellEjectAt = 0.25,
        Time = 0.5,
        TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
    },
    ["reload"] = {
        Source = "reload", Mult = reload_mult,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.5,
        LHIKEaseOut = 0.35
    },
    ["reload_empty"] = {
        Source = "reload_empty", Mult = reload_mult,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 1,
        LHIKEaseOut = 0.35
    },
    ["reload_longmag"] = {
        Source = "reload_longmag",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.5,
        LHIKEaseOut = 0.35
    },
    ["reload_longmag_empty"] = {
        Source = "reload_longmag_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 1,
        LHIKEaseOut = 0.35
    },
}
