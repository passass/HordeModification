local prefix = "horde/gamemode/custom/post_init/gadgets/"
local function Horde_LoadGadgets()
    local dev = GetConVar("developer"):GetBool()
    for _, f in ipairs(file.Find(prefix .. "*", "LUA")) do
        GADGET = {}
        AddCSLuaFile(prefix .. f)
        include(prefix .. f)
        if GADGET.Ignore then goto cont end
        GADGET.ClassName = string.lower(GADGET.ClassName or string.Explode(".", f)[1])
        GADGET.SortOrder = GADGET.SortOrder or 0

        hook.Run("Horde_OnLoadGadget", GADGET)

        HORDE.gadgets[GADGET.ClassName] = GADGET

        for k, v in pairs(GADGET.Hooks or {}) do
            hook.Add(k, "horde_gadget_" .. GADGET.ClassName, v)
        end

        if dev then print("[Horde] Loaded gadget '" .. GADGET.ClassName .. "'.") end
        ::cont::
    end
    GADGET = nil
end

Horde_LoadGadgets()