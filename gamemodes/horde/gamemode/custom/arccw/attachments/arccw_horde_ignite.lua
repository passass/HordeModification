att.PrintName = "Dragon's Breath"
att.Icon = Material("entities/acwatt_ammo_dragon.png")
att.Description = "Incendiary load shotgun shells deal extra damage at both close and long range, as well as igniting targets within its effective range. However, a reduced magazine is equipped."
att.Desc_Pros = {
    "pro.ignite"
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"ammo_bullet", "go_bullet"}

--att.Mult_PrecisionMOA = 2
--att.Mult_ShootPitch = 0.85

att.Override_DamageType = DMG_BURN
att.Override_DamageTypeHandled = DMG_BURN
--att.MagReducer = true

att.ActivateElements = {}--{"reducedmag"}
att.Override_ImpactEffect = "arccw_incendiaryround"
att.Override_ImpactDecal = "FadingScorch"


att.Hook_BulletHit = function(wep, hit)
	local _, maxrng = wep:GetMinMaxRange()
	if hit.range <= maxrng then
		local ply = wep.Owner
		if ply:Horde_GetGadget() != "gadget_hydrogen_burner" then
			local ent = hit.tr.Entity
			ent:Horde_SetMostRecentFireAttacker(ply, hit.dmg)
			ent:Ignite(ply:Horde_GetApplyIgniteDuration())
		end
    end
end

--[[att.Hook_PostBulletHit = function(wep, data)
end]]
