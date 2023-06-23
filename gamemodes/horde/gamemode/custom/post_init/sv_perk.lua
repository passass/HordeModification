local plymeta = FindMetaTable("Player")

function plymeta:Horde_ApplyPerksForClass()
    if GetConVar("horde_enable_perk"):GetInt() ~= 1 then return end
    local class = HORDE.Class_Survivor
    if self:Horde_GetClass() then
        class = self:Horde_GetClass().name
    end

    local subclass = HORDE.subclasses[self:Horde_GetSubclass(class)]
    local perks = HORDE.classes[class].perks
    if subclass and subclass.ParentClass then
        class = subclass.PrintName
        perks = subclass.Perks
    end

    self:Horde_ClearPerks()

    if subclass and subclass.ParentClass then
        self:Horde_SetPerk(subclass.BasePerk)
    else
        self:Horde_SetPerk(self:Horde_GetClass().base_perk)
    end

    self.Horde_PerkChoices = self.Horde_PerkChoices or {}
    self.Horde_PerkChoices[class] = self.Horde_PerkChoices[class] or {}
    
    for perk_level, v in pairs(perks) do
        if HORDE.current_wave < HORDE:Horde_GetWaveForPerk(perk_level) then goto cont end
        local c = math.min(table.Count(v.choices), math.max(1, self.Horde_PerkChoices[class][perk_level] or 1))
        local choice = v.choices[c]
        if not choice then error("Invalid choice in perk level " .. perk_level .. " for " .. class .. "!") return end
        if self:Horde_GetPerk(choice) then goto cont end
        self:Horde_SetPerk(choice)
        ::cont::
    end

    self:Horde_SetMaxHealth()
    self:Horde_SetMaxArmor()
    if self:Horde_GetSpellWeapon() then
        self:Horde_RecalcAndSetMaxMind()
    else
        self:Horde_SetMaxMind(0)
        self:Horde_SetMind(0)
    end

    net.Start("Horde_SyncPerk")
        net.WriteEntity(self)
        net.WriteTable(self.Horde_PerkChoices[class])
    net.Broadcast()
end