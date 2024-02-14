att.PrintName = ".50 Cal"

att.Icon = Material("entities/acwatt_go_ammo_sub.png", "mips smooth")
att.Description = "Change Caliber."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
}
att.Slot = "horde_caliber"

att.AutoStats = true
att.SortOrder = 25

att.Mult_ClipSize = .6
att.Mult_Recoil = 2.5
att.Mult_Damage = 1.8
att.Mult_DamageMin = 1.35
att.Mult_RPM = .7
att.Mult_Range = 2.5
att.Mult_ShootPitch = 0.85

att.Hook_Compatible = function(wep)
    if wep.RegularClipSize <= 10 or !HORDE:IsRifleItem(wep:GetClass()) or wep.ShootEntity or wep:GetBuff("Damage") > 500 then return false end
end