att.PrintName = "12 Gauge"

att.Icon = Material("entities/acwatt_go_ammo_sg_slug.png", "mips smooth")
att.Description = "Change Caliber."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
}
att.Slot = "horde_caliber"

att.AutoStats = true
att.SortOrder = 26

att.Mult_ClipSize = .5
att.Mult_Recoil = 3
att.Mult_Damage = 1.5
att.Mult_DamageMin = 1.1
att.Mult_RPM = .6
att.Mult_Range = 0.2
att.Mult_ShootPitch = 0.9

att.Override_HipDispersion = 150
att.Override_MoveDispersion = 125
att.Override_AccuracyMOA = 125

att.Add_Num = 7

att.Hook_Compatible = function(wep)
    if wep.RegularClipSize <= 10 or wep:GetIsShotgun() or wep.ShootEntity or wep.Num >= 2 then return false end
end