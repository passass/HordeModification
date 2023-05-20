local reloadspeed = 10
local total_reloadspeed = 1 - reloadspeed / 100
local level = "1"

att.PrintName = "Rushed Reloading" .. " (level - " .. level .. ")"
att.Icon = Material("entities/acwatt_perk_fastreload.png")
att.Description = "Improves reloading speed by " .. tostring(reloadspeed) .. "% through improved magwell design."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"bo1_perk", "perk", "go_perk",}

att.Mult_ReloadTime = total_reloadspeed