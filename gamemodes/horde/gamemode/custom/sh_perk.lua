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

if CLIENT then
    function HORDE:SendSavedPerkChoices(class)
        local tbl = MySelf.Horde_PerkChoices
        if not tbl or tbl == {} then
            local f = file.Read("horde/horde_ext/perk_choices.txt", "DATA")
            if !f then
                f = file.Read("horde/perk_choices.txt", "DATA")
            end
            if f then
                MySelf.Horde_PerkChoices = util.JSONToTable(f)
                tbl = MySelf.Horde_PerkChoices
            end
        end

        net.Start("Horde_PerkChoice")
            net.WriteString(class)
            net.WriteUInt(0, 4)
            for perk_level = 1,4 do
                if not tbl or not tbl[class] then
                    net.WriteUInt(1, 4)
                else
                    net.WriteUInt(tbl[class][perk_level] or 1, 4)
                end
            end
        net.SendToServer()
    end
end

Horde_LoadPerks()

function plymeta:Horde_CallClassHook(hookname, ...)
    if self.Horde_Perks then
        for perkname, _ in pairs(self.Horde_Perks) do
            local perk = HORDE.perks[perkname]
            if perk and perk.Hooks and perk.Hooks[hookname] then
                local res = perk.Hooks[hookname](...)
                if res then return res end
            end
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
    local startwave, perkscaling = GetConVar("horde_perk_start_wave"):GetInt(), GetConVar("horde_perk_scaling"):GetFloat()

    if startwave == 0 and perkscaling == 0 then return 0 end

    if HORDE.waves_for_perk then
        return HORDE.waves_for_perk[perk_level] or 1
    end

    return startwave + math.Round((perk_level - 1) * perkscaling)
end

function plymeta:Horde_UnsetPerk(perk, shared)
    self.Horde_Perks = self.Horde_Perks or {}
	local perk_data = HORDE.perks[perk]
	if perk_data.Hooks and perk_data.Hooks.Horde_OnUnsetPerk then
		perk_data.Hooks.Horde_OnUnsetPerk(self, perk)
	end
    --self:Horde_CallClassHook("Horde_OnUnsetPerk", self, perk)

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
		local perk_data = HORDE.perks[perk]
		if perk_data.Hooks and perk_data.Hooks.Horde_OnSetPerk then
			perk_data.Hooks.Horde_OnSetPerk(self, perk)
		end
        --self:Horde_CallClassHook("Horde_OnSetPerk", self, perk)
    end

    if SERVER and not shared then
        net.Start("Horde_Perk")
            net.WriteUInt(HORDE.NET_PERK_SET, HORDE.NET_PERK_BITS)
            net.WriteEntity(self)
            net.WriteString(perk)
        net.Broadcast()
    end
end