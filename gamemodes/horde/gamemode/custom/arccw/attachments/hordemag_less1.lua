att.PrintName = "Short Magazine"

att.Icon = Material("entities/acwatt_go_m4_mag_21_9mm.png", "mips smooth")
att.Description = "With a little well-placed grease and some physical force, most magazines can be made to accept an extra round."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
}
att.Slot = "horde_magazine"

att.AutoStats = true
att.SortOrder = 7

att.Mult_ClipSize = .8
att.Mult_ReloadTime = .8
att.Mult_MoveSpeed = 1.05
att.Mult_SightTime = .8
att.Mult_SightedSpeedMult = att.Mult_MoveSpeed

att.Hook_Compatible = function(wep)
    if wep.RegularClipSize <= 10 or HORDE:IsPistolItem(wep:GetClass())  then return false end
end