local plymeta = FindMetaTable("Player")
local entmeta = FindMetaTable("Entity")

function plymeta:Horde_SetApplyIgniteDuration(duration)
    self.Horde_ApplyIgniteDuration = duration
end

function plymeta:Horde_GetApplyIgniteDuration()
    return self.Horde_ApplyIgniteDuration or 4
end

function plymeta:Horde_SetApplyIgniteChance(chance)
    self.Horde_ApplyIgniteChance = chance
end

function plymeta:Horde_GetApplyIgniteChance()
    return self.Horde_ApplyIgniteChance or 0
end

function entmeta:Horde_SetMostRecentFireAttacker(attacker, dmginfo)
	self.Horde_MostRecentFireAttacker = attacker
    local staticdamage = dmginfo:GetInflictor().Horde_BurnDamage
    if staticdamage then
        self.Horde_IgniteDamageTaken = staticdamage
    else
        self.Horde_IgniteDamageTaken = 4
    end
end

function entmeta:Horde_SetIgniteDamage(dmg)
    self.Horde_IgniteDamageTaken = dmg
end

function entmeta:Horde_GetMostRecentFireAttacker()
	return self.Horde_MostRecentFireAttacker
end

function entmeta:Horde_GetIgniteDamageTaken()
    return self.Horde_IgniteDamageTaken or 4
end

function entmeta:Horde_AddIgniteEffect(duration)
    if self:IsPlayer() then
        self:Ignite(duration)
        timer.Remove("Horde_RemoveIgnite" .. self:SteamID())
        timer.Create("Horde_RemoveIgnite" .. self:SteamID(), duration, 1, function ()
            self:Horde_RemoveIgnite()
        end)
    end
end

function entmeta:Horde_RemoveIgnite()
    if not self:IsValid() then return end
    if self:IsPlayer() then
        self:Extinguish()
    end
end