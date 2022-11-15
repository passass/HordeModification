if engine.ActiveGamemode() != "horde" then att.Ignore = true return end
att.PrintName = "Overload"

att.Icon = Material("entities/att/arccw_uc_tp_overload.png", "smooth mips")
att.Description = "With a little well-placed grease and some physical force, most magazines can be made to accept an extra round."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
}
att.Slot = {"bo1_perk", "perk", "go_perk",}

att.AutoStats = true
att.SortOrder = 8

att.Add_ClipSize = 5

att.Hook_Compatible = function(wep)
    if wep:GetCapacity() <= 10 then return false end
end