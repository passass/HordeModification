local entmeta = FindMetaTable("Entity")

function entmeta:Horde_SetMostRecentFireAttacker(attacker, dmginfo)
	self.Horde_MostRecentFireAttacker = attacker
    local staticdamage = dmginfo:GetInflictor().Horde_BurnDamage
    if staticdamage then
        self.Horde_IgniteDamageTaken = staticdamage
    else
        self.Horde_IgniteDamageTaken = 4
    end
end

function entmeta:Horde_GetIgniteDamageTaken()
    return self.Horde_IgniteDamageTaken or 4
end