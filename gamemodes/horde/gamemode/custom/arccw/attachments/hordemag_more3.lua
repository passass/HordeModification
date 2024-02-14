att.PrintName = "Drum Magazine"

att.Icon = Material("entities/acwatt_go_ak_mag_40_steel.png", "mips smooth")
att.Description = "With a little well-placed grease and some physical force, most magazines can be made to accept an extra round."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
}
att.Slot = "horde_magazine"

att.AutoStats = true
att.SortOrder = 4

att.Mult_ClipSize = 2
att.Mult_ReloadTime = 1.5
att.Mult_MoveSpeed = .8
att.Mult_SightTime = 1.7
att.Mult_SightedSpeedMult = att.Mult_MoveSpeed
att.Mult_Recoil = 1.1
att.Mult_DrawTime = 1.5

att.Hook_Compatible = function(wep)
    local wep_mag = wep.RegularClipSize
    if wep_mag <= 10 or wep_mag >= 60 or HORDE:IsPistolItem(wep:GetClass())  then return false end
end