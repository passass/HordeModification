att.PrintName = "Large Magazine"

att.Icon = Material("entities/acwatt_go_ak_mag_40.png", "mips smooth")
att.Description = "With a little well-placed grease and some physical force, most magazines can be made to accept an extra round."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
}
att.Slot = "horde_magazine"

att.AutoStats = true
att.SortOrder = 5

att.Mult_ClipSize = 1.5
att.Mult_ReloadTime = 1.3
att.Mult_MoveSpeed = .9
att.Mult_SightTime = 1.4
att.Mult_SightedSpeedMult = att.Mult_MoveSpeed
att.Mult_Recoil = 1.05
att.Mult_DrawTime = 1.2

att.Hook_Compatible = function(wep)
    if wep.RegularClipSize <= 10 or HORDE:IsPistolItem(wep:GetClass())  then return false end
end