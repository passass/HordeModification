function plymeta:Horde_AddWardenAuraEffects(provider)
    if not IsValid(provider) or not provider:Alive() then return end
    if HORDE:IsWatchTower(provider) then
        self.Horde_WardenAuraProvider = provider:GetNWEntity("HordeOwner")
    else
        self.Horde_WardenAuraProvider = provider
    end
    self.Horde_WardenAuraDamageBlock = true
    if self.Horde_WardenAuraProvider:Horde_GetEnableWardenAuraHealthRegen() then
        self.Horde_WardenAuraHealthRegen = true
    end
    if self.Horde_WardenAuraProvider:Horde_GetEnableWardenAuraDamageBonus() then
        self.Horde_WardenAuraDamageBonus = true
    end
    if self.Horde_WardenAuraProvider:Horde_GetEnableWardenAuraInoculation() then
        self.Horde_WardenAuraInoculation = true
    end
    net.Start("Horde_SyncStatus")
        net.WriteUInt(HORDE.Status_WardenAura, 8)
        net.WriteUInt(1, 8)
    net.Send(self)
end