hook.Add("PlayerTick", "Horde_HealthRegen", function(ply, mv)
    if ply.Horde_HealthRegenPercentage <= 0 or (ply.Horde_Debuff_Active and ply.Horde_Debuff_Active[HORDE.Status_Decay]) then return end
    if not ply:Alive() then return end
    if ply:Health() >= ply:GetMaxHealth() then
        ply:Horde_RemoveHealthRegen()
        return
    else
        ply:Horde_AddHealthRegen()
    end
    
    if ply:Horde_GetHealthRegen() == 1 and CurTime() >= ply.Horde_HealthRegenCurTime + 1 then
        HORDE:Horde_HealBy(ply, ply:GetMaxHealth() * ply:Horde_GetHealthRegenPercentage(), true)
        ply.Horde_HealthRegenCurTime = CurTime()
    end
end)