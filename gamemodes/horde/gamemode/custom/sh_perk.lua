local plymeta = FindMetaTable("Player")

local prefix = "horde/gamemode/custom/perks/"
local function Horde_LoadPerks()
    local dev = GetConVar("developer"):GetBool()
    for _, f in ipairs(file.Find(prefix .. "*", "LUA")) do
        PERK = {}
        AddCSLuaFile(prefix .. f)
        include(prefix .. f)
        if PERK.Ignore then goto cont end
        PERK.ClassName = string.lower(PERK.ClassName or string.Explode(".", f)[1])
        PERK.SortOrder = PERK.SortOrder or 0

        hook.Run("Horde_OnLoadPerk", PERK)

        HORDE.perks[PERK.ClassName] = PERK

        for k, v in pairs(PERK.Hooks or {}) do
            hook.Add(k, "horde_perk_" .. PERK.ClassName, v)
        end

        if dev then print("[Horde] Loaded perk '" .. PERK.ClassName .. "'.") end
        ::cont::
    end

    for subclass_name, subclass in pairs(HORDE.subclasses) do
        prefix = "horde/gamemode/custom/perks/" .. subclass_name .. "/"
        for _, f in ipairs(file.Find(prefix .. "*", "LUA")) do
            PERK = {}
            AddCSLuaFile(prefix .. f)
            include(prefix .. f)
            if PERK.Ignore then goto cont end
            PERK.ClassName = string.lower(PERK.ClassName or string.Explode(".", f)[1])
            PERK.SortOrder = PERK.SortOrder or 0
    
            hook.Run("Horde_OnLoadPerk", PERK)
    
            HORDE.perks[PERK.ClassName] = PERK
    
            for k, v in pairs(PERK.Hooks or {}) do
                hook.Add(k, "horde_perk_" .. PERK.ClassName, v)
            end
    
            if dev then print("[Horde] Loaded perk '" .. PERK.ClassName .. "'.") end
            ::cont::
        end
    end
    PERK = nil
end

Horde_LoadPerks()

function plymeta:Horde_CallClassHook(hookname, ...)
    for perkname, _ in pairs(self.Horde_Perks) do
        local perk = HORDE.perks[perkname]
        if perk and perk.Hooks and perk.Hooks[hookname] then
            local res = perk.Hooks[hookname](...)
            if res then return res end
        end
    end
    local cur_gadget = self:Horde_GetGadget()
    if cur_gadget then
        local plygadget = HORDE.gadgets[cur_gadget]
        if plygadget and plygadget.Hooks and plygadget.Hooks[hookname] then
            local res = plygadget.Hooks[hookname](...)
            if res then return res end
        end
    end
end

function HORDE:Horde_GetWaveForPerk(perk_level)
    if HORDE.waves_for_perk then
        return HORDE.waves_for_perk[perk_level] or 1
    end

    return GetConVar("horde_perk_start_wave"):GetInt() + math.Round((perk_level - 1) * GetConVar("horde_perk_scaling"):GetFloat())
end

function plymeta:Horde_UnsetPerk(perk, shared)
    self.Horde_Perks = self.Horde_Perks or {}

    self:Horde_CallClassHook("Horde_OnUnsetPerk", self, perk)

    self.Horde_Perks[perk] = nil

    if SERVER and not shared then
        net.Start("Horde_Perk")
            net.WriteUInt(HORDE.NET_PERK_UNSET, HORDE.NET_PERK_BITS)
            net.WriteEntity(self)
            net.WriteString(perk)
        net.Broadcast()
    end
end

function plymeta:Horde_SetPerk(perk, shared)
    if not HORDE.perks[perk] then error("Tried to use nonexistent perk '" .. perk .. "' in Horde_SetPerk!") return end
    self.Horde_Perks = self.Horde_Perks or {}
    self.Horde_Perks[perk] = true
    if SERVER then
        self:Horde_CallClassHook("Horde_PrecomputePerkLevelBonus", self)
    end

    if self:Alive() then
        -- No need to set perks when dead
        self:Horde_CallClassHook("Horde_OnSetPerk", self, perk)
    end

    if SERVER and not shared then
        net.Start("Horde_Perk")
            net.WriteUInt(HORDE.NET_PERK_SET, HORDE.NET_PERK_BITS)
            net.WriteEntity(self)
            net.WriteString(perk)
        net.Broadcast()
    end
end