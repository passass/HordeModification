if engine.ActiveGamemode() != "horde" then att.Ignore = true return end
att.PrintName = "Rushed Reloading"
att.Icon = Material("entities/acwatt_perk_fastreload.png")
att.Description = "Improves reloading speed by 15% through improved magwell design."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"bo1_perk", "perk", "go_perk",}

att.Mult_ReloadTime = 0.85