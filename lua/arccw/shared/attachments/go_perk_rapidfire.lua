if engine.ActiveGamemode() != "horde" then att.Ignore = true return end
att.PrintName = "Frantic Firing Frenzy"
att.Icon = Material("entities/acwatt_go_perk_rapidfire.png", "mips smooth")
att.Description = "Slightly improves rate of fire."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"bo1_perk", "perk", "go_perk",}


att.Mult_RPM = 1.05

att.Hook_Compatible = function(wep)
    if wep.ManualAction then return false end
end