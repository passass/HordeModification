att.PrintName = "Endurance (level - 2)"

att.Icon = Material("entities/att/arccw_uc_tp_endurance.png", "smooth mips")
att.Description = "Long courses of physical training allow you to bear more weight, reducing the influence of your weapon's bulk on your walking and running speed."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
}
att.Slot = {"bo1_perk", "perk", "go_perk",}

att.AutoStats = true
att.SortOrder = 17

local movementspeedmult = 15
att.Mult_MoveSpeed = 1 + movementspeedmult / 100