HORDE.BuyablePerks = {
    buyableperk_speedreload = {
        name = "Speed Reload",
        description = "Increase Reload speed by 6%",
        shop_icon = "entities/acwatt_perk_fastreload.png",
        category = "BuyablePerks",
        --[[OnSet = function(ply, lvl)
            print("SET")
        end,
        OnUnset = function(ply)
            print("UNSET")
        end,]]
        price = 400,
        weight = 0,
        price_incby = 200,
        --price_multby = .25,
        canupgrade = true,
        maxlevel = 5,

        --buffs_damage_mult_incby = .5,
        buffs_modifiers = {
            Mult_ReloadTime = {base = 1, mult = -.06},
        },
    },
    buyableperk_health = {
        name = "HealthUp",
        description = "Increase Your Max Health By 5",
        shop_icon = "items/weapon_medkit.png",
        category = "BuyablePerks",
        OnUnset = function(ply, lvl)
            if SERVER then
                ply:Horde_SetMaxHealth()
            end
        end,
        OnSet = function(ply, lvl)
            if SERVER then
                ply:Horde_SetMaxHealth()
            end
        end,
        OnLevelUp = function(ply, lvl)
            if SERVER then
                ply:Horde_SetMaxHealth()
            end
        end,
        price = 450,
        weight = 0,
        price_incby = 125,
        canupgrade = true,
        maxlevel = 10,
        Hooks = {
            Horde_OnSetMaxHealth = function(ply, bonus)
                if SERVER then
                    bonus.increase = bonus.increase + 0.05 * HORDE:GetBuyablePerkLevel(ply, "buyableperk_health")
                end
            end,
        },
    },
    buyableperk_moreammo = {
        name = "Increased ammunition",
        description = "Increase Your ammunition By 10%",
        shop_icon = "entities/att/arccw_uc_tp_overload.png",
        category = "BuyablePerks",
        price = 500,
        weight = 0,
        price_incby = 250,
        canupgrade = true,
        maxlevel = 5,
        wep_perkapply = function(wep, lvl)
            local mult = 1.1 ^ lvl
            if !wep.Horde_MaxMags then
                wep.Horde_MaxMags = HORDE.Ammo_DefaultMaxMags
            end

            HORDE:Modifier_AddToWeapon(
                wep:GetOwner(), wep, "Horde_TotalMaxAmmoMult", "buyableperk_moreammo",
                {
                    mult = mult,
                }
            )
            HORDE:Modifier_AddToWeapon(
                wep:GetOwner(), wep, "Horde_MaxMags", "buyableperk_moreammo",
                {
                    mult = mult,
                    rounded_value = true,
                }
            )
        end,
        wep_perkremove = function(wep, lvl)
            HORDE:Modifier_AddToWeapon(
                wep:GetOwner(), wep, "Horde_TotalMaxAmmoMult", "buyableperk_moreammo"
            )
            HORDE:Modifier_AddToWeapon(
                wep:GetOwner(), wep, "Horde_MaxMags", "buyableperk_moreammo"
            )
        end,
    },
    buyableperk_moreclip = {
        name = "Increased Clip Size",
        description = "Increase Clip Size By 20%",
        shop_icon = "entities/att/arccw_uc_tp_overload.png",
        category = "BuyablePerks",
        price = 750,
        weight = 0,
        price_incby = 250,
        canupgrade = true,
        maxlevel = 3,
        wep_perkapply = function(wep, lvl)
            if !wep.ArcCW then return end
            local mult = 1.2 ^ lvl
            
            HORDE:Modifier_AddToWeapon(
                wep:GetOwner(), wep, "Mult_ClipSize", "buyableperk_moreclip",
                {
                    mult = mult,
                }
            )
        end,
        wep_perkremove = function(wep, lvl)
            HORDE:Modifier_AddToWeapon(
                wep:GetOwner(), wep, "Mult_ClipSize", "buyableperk_moreclip"
            )
        end,
    },
    buyableperk_tacmove = {
        name = "Tactical Movement",
        description = "You move without penalty in aiming.\nDoesn't remove penalty from atts.",
        shop_icon = "materials/perks/sniper.png",
        category = "BuyablePerks",
        price = 1000,
        weight = 0,
        price_incby = 0,
        canupgrade = false,
        maxlevel = 1,
        wep_perkapply = function(wep, lvl)
            if wep.ArcCW and wep.SpeedMult and wep.SightedSpeedMult then
                HORDE:Modifier_AddToWeapon(
                    wep:GetOwner(), wep, "Override_SightedSpeedMult", "buyableperk_tacmove",
                    {
                        override = math.max(wep.SpeedMult, wep.SightedSpeedMult),
                        priority = 5
                    }
                )
            end
        end,
        wep_perkremove = function(wep, lvl)
            if wep.ArcCW and wep.SpeedMult and wep.SightedSpeedMult then
                HORDE:Modifier_AddToWeapon(
                    wep:GetOwner(), wep, "Override_SightedSpeedMult", "buyableperk_tacmove"
                )
            end
        end,
    },

    --"materials/perks/sniper.png"
    buyableperk_rpmup = {
        name = "Faster Shooter",
        description = "Increase Your RPM By 5%",
        shop_icon = "items/ammo_kit.png",
        price = 300,
        weight = 0,
        price_incby = 150,
        canupgrade = true,
        maxlevel = 4,
        buffs_modifiers = {
            Mult_RPM = {base = 1, mult = .05},
        },
        category = "BuyablePerks",
    },
    buyableperk_fastrun = {
        name = "Fast Run",
        description = "Increase Your Movement Speed By 4%",
        shop_icon = "entities/att/arccw_uc_tp_endurance.png",
        price = 500,
        weight = 0,
        price_incby = 250,
        canupgrade = true,
        maxlevel = 5,
        Hooks = {
            Horde_PlayerMoveBonus = function(ply, bonus_walk, bonus_run)
                local buff = 1 + .04 * HORDE:GetBuyablePerkLevel(ply, "buyableperk_fastrun")

                bonus_walk.more = bonus_walk.more * buff
                bonus_run.more = bonus_run.more * buff
            end,
        },
        category = "BuyablePerks",
    }
}


HORDE.ENTITY_PROPERTY_BUYABLEPERK = 9

local function init_buyableperk(ply)
    if !ply.HORDE_BuyablePerk then
        ply.HORDE_BuyablePerk = {}
    end
end

local function applybuffs(ply, name, lvl)
    for modif_name, value in pairs(HORDE.items[name].buffs_modifiers or {}) do
        local multtable = {
            override = value.override,
            priority = value.priority,
        }
        if value.base or value.mult then
            multtable.mult = (value.base or 1) * ((1 + (value.mult or 0)) ^ lvl) + (value.incby or 0) * lvl
        end
        HORDE:Modifier_AddToWeapons(ply, modif_name, "Horde_BuyablePerk_" .. name, multtable)
    end

    if HORDE.BuyablePerks[name] and HORDE.BuyablePerks[name].wep_perkapply then
        for _, wep in pairs(ply:GetWeapons()) do
            HORDE.BuyablePerks[name].wep_perkapply(wep, lvl)
        end
    end
end

local function levelup_buyableperk(ply, name)
    local lvl = ply.HORDE_BuyablePerk[name].lvl
    if !lvl then return end

    applybuffs(ply, name, lvl)

    if HORDE.BuyablePerks[name] and HORDE.BuyablePerks[name].OnLevelUp then
        HORDE.BuyablePerks[name].OnLevelUp(ply, lvl)
    end
end

local function equip_buyableperk(ply, name)
    local lvl = ply.HORDE_BuyablePerk[name].lvl
    if !lvl then return end

    applybuffs(ply, name, lvl)

    if HORDE.BuyablePerks[name] then
        for hookname, hookfunc in pairs(HORDE.BuyablePerks[name].Hooks or {}) do
            local hookname_rel = "Horde_BuyablePerk_" .. tostring(ply:EntIndex()) .. "_" .. name .. "_" .. hookname
            hook.Add(hookname, hookname_rel,
            function(...)
                if !IsValid(ply) then hook.Remove(hookname, hookname_rel) return end
                for _, arg in pairs({...}) do
                    if IsValid(arg) and isentity(arg) and arg:IsPlayer() and ply:EntIndex() == arg:EntIndex() then
                        hookfunc(...)
                        break
                    end
                end
            end
            )
        end
        if HORDE.BuyablePerks[name].OnSet then
            HORDE.BuyablePerks[name].OnSet(ply, lvl)
        end
    end
end

local function unequip_buyableperk(ply, name)
    for modif_name, value in pairs(HORDE.items[name].buffs_modifiers or {}) do
        HORDE:Modifier_AddToWeapons(ply, modif_name, "Horde_BuyablePerk_" .. name)
    end
    if HORDE.BuyablePerks[name] and HORDE.BuyablePerks[name].wep_perkremove then
        for _, wep in pairs(ply:GetWeapons()) do
            HORDE.BuyablePerks[name].wep_perkremove(wep)
        end
    end

    if HORDE.BuyablePerks[name] then
        for hookname, hookfunc in pairs(HORDE.BuyablePerks[name].Hooks or {}) do
            hook.Remove(hookname, "Horde_BuyablePerk_" .. tostring(ply:EntIndex()) .. "_" .. name .. "_" .. hookname)
        end
        if HORDE.BuyablePerks[name].OnUnset then
            HORDE.BuyablePerks[name].OnUnset(ply)
        end
    end
end

function HORDE:GetBuyablePerkName(ply, name)
    local perkname = HORDE.items[name].name

    local lvl = HORDE:GetBuyablePerkLevel(ply, name)
    if lvl > 0 then
        perkname = perkname .. " (" .. tostring(lvl) .. ")"
    end

    return perkname
end

function HORDE:GetBuyablePerkPrice(ply, name, lvl)
    lvl = lvl or HORDE:GetBuyablePerkLevel(ply, name)
    local price = HORDE.items[name].price
    local price_incby = HORDE.items[name].price_incby or 0
    local price_mult = HORDE.items[name].price_multby or 0

    return math.Round(price * (1 + (price_mult or 0) * lvl) + (price_incby or 0) * lvl, -1)
end

function HORDE:GetBuyablePerkLevel(ply, name)
    return ply.HORDE_BuyablePerk and ply.HORDE_BuyablePerk[name] and ply.HORDE_BuyablePerk[name].lvl or 0
end

function HORDE:SetBuyablePerkLevel(ply, name, lvl)
    init_buyableperk(ply)

    if !ply.HORDE_BuyablePerk[name] then
        ply.HORDE_BuyablePerk[name] = {}
        ply.HORDE_BuyablePerk[name].lvl = lvl
        equip_buyableperk(ply, name)
    else
        ply.HORDE_BuyablePerk[name].lvl = lvl
        levelup_buyableperk(ply, name)
    end


    if SERVER then
        HORDE:SyncBuyablePerk(ply, name)
    end
end

function HORDE:AddBuyablePerkLevel(ply, name)
    init_buyableperk(ply)
    if ply.HORDE_BuyablePerk[name] and ply.HORDE_BuyablePerk[name].lvl then
        ply.HORDE_BuyablePerk[name].lvl = ply.HORDE_BuyablePerk[name].lvl + 1
        levelup_buyableperk(ply, name)
    else
        ply.HORDE_BuyablePerk[name] = {}
        ply.HORDE_BuyablePerk[name].lvl = 1
        equip_buyableperk(ply, name)
    end

    if SERVER then
        HORDE:SyncBuyablePerk(ply, name)
    end
end

function HORDE:StripBuyablePerk(ply, name)
    init_buyableperk(ply)
    if ply.HORDE_BuyablePerk[name] then
        unequip_buyableperk(ply, name)
        ply.HORDE_BuyablePerk[name].lvl = nil

        if SERVER then
            HORDE:SyncBuyablePerk(ply, name)
        end
    end
end

function HORDE:CreateBuyablePerk(data)
    new_data = table.Copy(data)
    for varname, value in pairs(new_data) do
        if isfunction(value) then
            new_data[varname] = nil
        end
    end
    new_data.is_buyable_perk = true
    new_data.category = "BuyablePerks"
    new_data.ammo_price = 0
    new_data.secondary_ammo_price = 0
    new_data.entity_properties = {type=HORDE.ENTITY_PROPERTY_BUYABLEPERK}
    HORDE.items[new_data.class] = new_data
end

if SERVER then
    util.AddNetworkString("Horde_SyncBuyablePerk")

    function HORDE:SyncBuyablePerk(ply, name)
        net.Start("Horde_SyncBuyablePerk")
        net.WriteString(name)
        net.WriteInt(HORDE:GetBuyablePerkLevel(ply, name), 8)
        net.Send(ply)
    end

    hook.Add("WeaponEquip", "Horde_Buyableperk_apply", function(wep)
        timer.Simple(engine.TickInterval(), function()
            local ply = wep:GetOwner()
            if !IsValid(ply) or !ply.HORDE_BuyablePerk or !IsValid(wep) then return end

            for name, buyableperktable in pairs(ply.HORDE_BuyablePerk) do
                if HORDE.BuyablePerks[name] and HORDE.BuyablePerks[name].wep_perkapply then
                    HORDE.BuyablePerks[name].wep_perkapply(wep, buyableperktable.lvl)
                end
            end
        end)
    end)
else
    net.Receive("Horde_SyncBuyablePerk", function()
        local name = net.ReadString()
        local lvl = net.ReadInt(8)
        if lvl == 0 then
            HORDE:StripBuyablePerk(MySelf, name)
        else
            HORDE:SetBuyablePerkLevel(MySelf, name, lvl)
        end
    end)
end

--[[for class, data in pairs(HORDE.BuyablePerks) do
    data.class = class
    HORDE:CreateBuyablePerk(data)
end]]