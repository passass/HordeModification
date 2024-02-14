att.PrintName = "Extended Pistol Magazine"

att.Icon = Material("entities/acwatt_go_tec9_mag_32.png", "mips smooth")
att.Description = "With a little well-placed grease and some physical force, most magazines can be made to accept an extra round."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
}
att.Slot = "horde_magazine"

att.AutoStats = true
att.SortOrder = 6

att.Mult_ClipSize = 1.25
att.Mult_ReloadTime = 1.1
att.Mult_SightTime = 1.15

att.Hook_Compatible = function(wep)
    if wep.RegularClipSize <= 2 or !HORDE:IsPistolItem(wep:GetClass()) then return false end
end