if engine.ActiveGamemode() != "horde" then att.Ignore = true return end
att.PrintName = "Surgical Shot (level - 3)"
att.Icon = Material("entities/acwatt_go_perk_headshot.png", "mips smooth")
att.Description = "1.3X headshot damage."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"bo1_perk", "perk", "go_perk",}

att.Hook_BulletHit = function(wep, data)
    if CLIENT then return end

    if data.tr.HitGroup == HITGROUP_HEAD then
        data.damage = data.damage * 1.3
    end
end