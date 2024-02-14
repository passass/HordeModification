att.PrintName = "9mm Cal"

att.Icon = Material("entities/acwatt_go_perk_burst.png", "mips smooth")
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

att.Mult_ReloadTime = .8
att.Mult_Recoil = .8
att.Mult_Damage = .9
att.Mult_DamageMin = .9
att.Mult_RPM = 1.25
att.Mult_Range = .9
att.Mult_ShootPitch = 1.05

att.Hook_Compatible = function(wep)
    if !HORDE:IsRifleItem(wep:GetClass()) or wep.ShootEntity then return false end
end