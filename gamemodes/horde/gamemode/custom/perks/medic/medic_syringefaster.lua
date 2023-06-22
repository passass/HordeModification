PERK.PrintName = "Syringe Master"
PERK.Description = "Your syringe refill speed is faster by {1}."
PERK.Icon = "materials/perks/syringefaster.png"
PERK.Params = {
    [1] = {value = 0.30, percent = true},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnSetPerk = function(ply, healinfo)
    if SERVER then
        HORDE:Modifier_AddToWeapons(ply, "Mult_SyringeSpeed", "medic_syringefaster", 1.3)

        for _, wep in pairs(ply:GetWeapons()) do
            if wep.Horde_HealSyringeTimer then
                wep.Horde_HealSyringeTimer:SetDelay(.15 / wep:GetBuff_Mult("Mult_SyringeSpeed"))
                wep.Horde_HealSyringeTimer:UpdateTimer(true)
                wep.Horde_HealSyringeTimer:SyncDelay(ply)
            end
        end
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER then
        HORDE:Modifier_AddToWeapons(ply, "Mult_SyringeSpeed", "medic_syringefaster")

        for _, wep in pairs(ply:GetWeapons()) do
            if wep.Horde_HealSyringeTimer then
                wep.Horde_HealSyringeTimer:SetDelay(.15 / wep:GetBuff_Mult("Mult_SyringeSpeed"))
                wep.Horde_HealSyringeTimer:UpdateTimer(true)
                wep.Horde_HealSyringeTimer:SyncDelay(ply)
            end
        end
    end
end
