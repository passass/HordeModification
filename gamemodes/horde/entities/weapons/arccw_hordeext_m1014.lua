if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_go_m1014")
    killicon.Add("arccw_hordeext_m1014", "arccw/weaponicons/arccw_go_m1014", Color(0, 0, 0, 255))
end
SWEP.PrintName = "XM1014"
SWEP.Base = "arccw_horde_m1014"
SWEP.Category = "ArcCW - Horde"
SWEP.Horde_MaxMags = 30
SWEP.ClipsPerAmmoBox = 2
SWEP.Damage = 18
SWEP.DamageMin = 13 -- damage done at maximum range

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
    ["fire"] = {
        Source = "shoot",
        Time = 0.5,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "idle",
        Time = 0.5,
        ShellEjectAt = 0,
    },
    ["sgreload_start"] = {
        Source = "start_reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0,
        Mult = .8,
    },
    ["sgreload_insert"] = {
        Source = "insert",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        TPAnimStartTime = 0.3,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0,
        Mult = .8,
    },
    ["sgreload_finish"] = {
        Source = "end_reload",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.2,
        Mult = .8,
    },
    ["sgreload_finish_empty"] = {
        Source = "end_reload_empty",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.2,
        Mult = .8,
    },
}

sound.Add({
    name = "ARCCW_GO_M1014.Draw",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/xm1014/xm1014_draw.wav"
})

sound.Add({
    name = "ARCCW_GO_M1014.Insertshell",
    channel = 16,
    volume = 1.0,
    sound = {
        "arccw_go/xm1014/xm1014_insertshell_01.wav",
        "arccw_go/xm1014/xm1014_insertshell_02.wav",
        "arccw_go/xm1014/xm1014_insertshell_03.wav"}
})

sound.Add({
    name = "ARCCW_GO_M1014.Boltback",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/galilar/galil_boltback.wav"
})

sound.Add({
    name = "ARCCW_GO_M1014.Boltforward",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/galilar/galil_boltforward.wav"
})
