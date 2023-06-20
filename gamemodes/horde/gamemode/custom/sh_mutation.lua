local prefix = "horde/gamemode/custom/mutations/"
local function Horde_LoadMutations()
    local dev = GetConVar("developer"):GetBool()
    for _, f in ipairs(file.Find(prefix .. "*", "LUA")) do
        MUTATION = {}
        AddCSLuaFile(prefix .. f)
        include(prefix .. f)
        if MUTATION.Ignore then goto cont end
        MUTATION.ClassName = string.lower(MUTATION.PrintName or string.Explode(".", f)[1])
        MUTATION.SortOrder = MUTATION.SortOrder or 0

        hook.Run("Horde_OnLoadMutation", MUTATION)

        HORDE.mutations[MUTATION.ClassName] = MUTATION
        if not (MUTATION.NoRand) then
            HORDE.mutations_rand[MUTATION.ClassName] = MUTATION
        end

        for k, v in pairs(MUTATION.Hooks or {}) do
            hook.Add(k, "horde_mutation_" .. MUTATION.ClassName, v)
        end

        if dev then print("[Horde] Loaded mutation '" .. MUTATION.ClassName .. "'.") end
        ::cont::
    end
    MUTATION = nil
end
Horde_LoadMutations()