att.PrintName = "Kebrinium"
att.Icon = Material("entities/acwatt_ammo_explosive.png")
att.Description = "These bullets have an explosive charge inside. The explosion is very effective against armor, but due to possible weapon issues, reduced magazines are issued."
att.Desc_Pros = {
    "Explosion on hit dealing additional 100% damage",
}
att.Desc_Cons = {
    --"-80% Magazine capacity",
}
att.Desc_Neutrals = {
    "Blast radius is 150 HU / 3.75m",
}
att.AutoStats = true
att.Slot = {"ammo_bullet", "go_bullet"}

--att.MagReducer = true

att.Mult_ShootPitch = 0.7
att.Mult_ShootVol = 1.5
att.Mult_Penetration = 0
--att.Mult_Damage = 0.5
--att.Mult_Range = 0.5

--att.Override_DamageType = DMG_BULLET
--att.ActivateElements = {"reducedmag"}
att.Override_ImpactEffect = "arccw_incendiaryround"
att.Override_ImpactDecal = "FadingScorch"

--[[att.Hook_Compatible = function(wep)
    if wep.Num ~= 1 or (wep.Primary.Ammo ~= "smg1" and wep.Primary.Ammo ~= "ar2") then return false end
end]]
--att.Hidden = true
att.Hook_BulletHit = function(wep, data)
    local ent = data.tr.Entity
    util.BlastDamage(wep, wep:GetOwner(), data.tr.HitPos, 150, wep:GetDamage(data.range) / wep:GetBuff("Num"))
    data.damage = 0
    if ent:IsValid() and ent:GetClass() == "npc_helicopter" then
        data.dmgtype = DMG_AIRBOAT
    end
end
