local firerate = 5

att.PrintName = "Frantic Firing Frenzy (level - 1)"
att.Icon = Material("entities/acwatt_go_perk_rapidfire.png", "mips smooth")
att.Description = "Slightly improves rate of fire."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"bo1_perk", "perk", "go_perk",}


att.Mult_RPM = 1 + firerate / 100

att.Hook_Compatible = function(wep)
    if wep.ManualAction then return false end
end