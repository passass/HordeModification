-- melee attack mults
local wep_bases = {
    ["arccw"] = function(wep) return wep.ArcCW end,
    ["tfa"] = function(wep) return wep.IsTFAWeapon end,
}

local arccw_melees_bases = {arccw_horde_base_melee = true, arccw_base_melee = true}
local tfa_melees_base = {horde_tfa_melee_base = true, tfa_melee_base = true}

function HORDE.IsMeleeWeapon(wep)
    return arccw_melees_bases[wep.Base] or tfa_melees_base[wep.Base]
end

local function Weapon_GetTable(wep, key)

    local istfa = wep_bases["tfa"](wep)

    local haspoint, _ = string.find( key, "." )
    local tbl = wep
    if haspoint then

        local splitted_modifiers = string.Split( key, "." )
            
        for i=1, #splitted_modifiers - 1 do
            local v = splitted_modifiers[i]

            if istfa and v == "Primary" then
                v = "Primary_TFA"
            end

            tbl = tbl[v]
        end

        key = splitted_modifiers[#splitted_modifiers]
    end

    return {tbl, key}
end

--[[local function Weapon_GetValue(wep, key)

    local istfa = wep_bases["tfa"](wep)

    local haspoint, _ = string.find( key, "." )
    local tbl = wep
    if haspoint then

        local splitted_modifiers = string.Split( key, "." )
            
        for i=1, #splitted_modifiers - 1 do
            local v = splitted_modifiers[i]

            if istfa and v == "Primary" then
                v = "Primary_TFA"
            end

            tbl = tbl[v]
        end

        key = splitted_modifiers[#splitted_modifiers]
    end

    return tbl[key]
end

local function Weapon_SetValue(wep)
    return arccw_melees_bases[wep.Base] or tfa_melees_base[wep.Base]
end]]

local plymeta = FindMetaTable("Player")

function plymeta:GetModifiers()
    if !self.Horde_ModifiersTable then self.Horde_ModifiersTable = {} end
    if !self.Horde_ModifiersTable.AllWeps then self.Horde_ModifiersTable.AllWeps = {} end

    return self.Horde_ModifiersTable.AllWeps
end

function plymeta:AddModifier(modifier, primarykey, mult)
    if !self.Horde_ModifiersTable then self.Horde_ModifiersTable = {} end
    if !self.Horde_ModifiersTable.AllWeps then self.Horde_ModifiersTable.AllWeps = {} end
    if !self.Horde_ModifiersTable.AllWeps[modifier] then self.Horde_ModifiersTable.AllWeps[modifier] = {} end

    self.Horde_ModifiersTable.AllWeps[modifier][primarykey] = mult
end

function plymeta:AddWeaponModifier(wepclass, modifier, primarykey, mult)
    if !self.Horde_ModifiersTable then self.Horde_ModifiersTable = {} end
    if !self.Horde_ModifiersTable.Weapons then self.Horde_ModifiersTable.Weapons = {} end
    if !self.Horde_ModifiersTable.Weapons[wepclass] then self.Horde_ModifiersTable.Weapons[wepclass] = {} end
    if !self.Horde_ModifiersTable.Weapons[wepclass][modifier] then self.Horde_ModifiersTable.Weapons[wepclass][modifier] = {} end

    self.Horde_ModifiersTable.Weapons[wepclass][modifier][primarykey] = mult
end

function plymeta:SetRoundedValue(wepclass, modifier, primarykey, mult)
    if !self.Horde_ModifiersTable then self.Horde_ModifiersTable = {} end
    if !self.Horde_ModifiersTable.Weapons then self.Horde_ModifiersTable.Weapons = {} end
    if !self.Horde_ModifiersTable.Weapons[wepclass] then self.Horde_ModifiersTable.Weapons[wepclass] = {} end
    if !self.Horde_ModifiersTable.Weapons[wepclass][modifier] then self.Horde_ModifiersTable.Weapons[wepclass][modifier] = {} end

    self.Horde_ModifiersTable.Weapons[wepclass][modifier][primarykey] = mult
end

function plymeta:GetWeaponModifiers(wepclass)
    if !self.Horde_ModifiersTable then self.Horde_ModifiersTable = {} end
    if !self.Horde_ModifiersTable.Weapons then self.Horde_ModifiersTable.Weapons = {} end

    return self.Horde_ModifiersTable.Weapons[wepclass] or {}
end

-- weapon bases

function HORDE:Modifier_GetSuitableModifier(wep, modifiers)
    if !istable(modifiers) then return modifiers end

    for wepbase, modifier in pairs(modifiers) do
        if wep_bases[wepbase] and wep_bases[wepbase](wep) then
            return modifier
        end
    end
end

-- melee attack mults

local special_conditions = {
    Mult_MeleeTime = {
        postinit =
            function(wep) if wep.ArcCW and arccw_melees_bases[wep.Base] then
                if wep.Animations.bash then
                    wep.Horde_Mult_MeleeTimeMults_bash = wep.Animations.bash.Mult or 1
                end
                
                if wep.Animations.bash2 then
                    wep.Horde_Mult_MeleeTimeMults_bash2 = wep.Animations.bash2.Mult or 1
                end
            elseif wep.IsTFAWeapon and tfa_melees_base[wep.Base] then
                if wep.Primary.Attacks then
                    if !wep.SequenceRateOverride then wep.SequenceRateOverride = {} end
                    if !wep.SequenceRateOverrideScaled then wep.SequenceRateOverrideScaled = {} end
                    for _, attacktable in pairs(wep.Primary.Attacks) do
                        if !attacktable.act then continue end
                        wep["Horde_Mult_MeleeTimeMults_" .. attacktable.act] = wep.SequenceRateOverride[attacktable.act] or 1
                    end
                end
            end
            return true
        end,
        calculate =
        function(wep, total_mult)
            if wep.ArcCW and arccw_melees_bases[wep.Base] then
                wep.ModifiedCache["Mult_MeleeTime"] = true
                wep.TickCache_Mults["Mult_MeleeTime"] = nil
                wep.Mult_MeleeTime = total_mult
        
                wep.ModifiedCache["Mult_MeleeTime"] = true
                if wep.ModifiedCache_Permanent then
                    wep.ModifiedCache_Permanent["Mult_MeleeTime"] = true
                end
                
                if wep.Animations.bash then
                    wep.Animations.bash.Mult = wep.Horde_Mult_MeleeTimeMults_bash * total_mult
                end
                
                if wep.Animations.bash2 then
                    wep.Animations.bash2.Mult = wep.Horde_Mult_MeleeTimeMults_bash2 * total_mult
                end
            elseif wep.IsTFAWeapon and tfa_melees_base[wep.Base] then
                if wep.Primary.Attacks then
                    if !wep.SequenceRateOverride then wep.SequenceRateOverride = {} end
                    if !wep.SequenceRateOverrideScaled then wep.SequenceRateOverrideScaled = {} end
                    for _, attacktable in pairs(wep.Primary.Attacks) do
                    if !attacktable.act then continue end
                        local mult = (wep["Horde_Mult_MeleeTimeMults_" .. attacktable.act] or 1) * (1 / total_mult)
                        if mult == 1 then
                            mult = nil
                        end
                        wep.SequenceRateOverride[attacktable.act] = mult
                        wep.SequenceRateOverrideScaled[attacktable.act] = mult
                        wep.StatCache2["SequenceRateOverrideScaled." .. attacktable.act] = nil
                        wep.StatCache2["SequenceRateOverride." .. attacktable.act] = nil
                    end
                    wep:ClearStatCache()
                end
            end
            return true
        end,
        add_modifier_if = HORDE.IsMeleeWeapon,
    },
    Horde_MaxMags = {
        preinit = function(wep)
            if !wep.Horde_MaxMags then
                wep.Horde_MaxMags = 20
            end
        end,
    },
    Horde_TotalMaxAmmoMult = {
        preinit = function(wep)
            if !wep.Horde_TotalMaxAmmoMult then
                wep.Horde_TotalMaxAmmoMult = 1
            end
        end
    },
    Mult_ReloadTime = {
        preinit = function(wep)
            if wep.IsTFAWeapon and wep.SequenceRateOverride and wep.SequenceRateOverride[ACT_VM_RELOAD] then
                wep.Horde_ModifiersTable["Mult_ReloadTime"] = {}
                wep.Horde_ModifiersTable["Mult_ReloadTime"]["init"] = wep.SequenceRateOverride[ACT_VM_RELOAD]
            elseif wep.ArcCW and wep.ChargeWeapon then
                if wep.Animations["charging"].Mult then
                    wep.Animations["charging"].oldMult = wep.Animations["charging"].Mult
                end

                if wep.Animations["fire"].Mult then
                    wep.Animations["fire"].oldMult = wep.Animations["fire"].Mult
                end

                if wep.Animations["fire_iron"] and wep.Animations["fire_iron"].Mult then
                    wep.Animations["fire_iron"].oldMult = wep.Animations["fire_iron"].Mult
                end
            end
        end,
        calculate = function(wep, total_mult)
            if wep.IsTFAWeapon then
                total_mult = 1 / total_mult
                
                if !wep.SequenceRateOverride then wep.SequenceRateOverride = {} end
                if !wep.SequenceRateOverrideScaled then wep.SequenceRateOverrideScaled = {} end

                if wep.ChargeRate then
                    wep.SequenceRateOverride[174] = total_mult
                    wep.SequenceRateOverrideScaled[174] = total_mult
                    wep.SequenceRateOverride[181] = 1 / total_mult
                    wep.SequenceRateOverrideScaled[181] = 1 / total_mult
                    wep.SequenceRateOverride[6] = total_mult
                    wep.SequenceRateOverrideScaled[6] = total_mult
                    wep.SequenceRateOverride[3] = total_mult ^ .5
                    wep.SequenceRateOverrideScaled[3] = total_mult ^ .5
                    wep.SequenceRateOverride[1] = total_mult
                    wep.SequenceRateOverrideScaled[1] = total_mult

                    wep.StatCache2["SequenceRateOverrideScaled." .. 174] = nil
                    wep.StatCache2["SequenceRateOverride." .. 174] = nil
                    wep.StatCache2["SequenceRateOverrideScaled." .. 181] = nil
                    wep.StatCache2["SequenceRateOverride." .. 181] = nil
                    wep.StatCache2["SequenceRateOverrideScaled." .. 6] = nil
                    wep.StatCache2["SequenceRateOverride." .. 6] = nil
                    wep.StatCache2["SequenceRateOverrideScaled." .. 3] = nil
                    wep.StatCache2["SequenceRateOverride." .. 3] = nil
                    wep.StatCache2["SequenceRateOverrideScaled." .. 1] = nil
                    wep.StatCache2["SequenceRateOverride." .. 1] = nil
                end

                wep.SequenceRateOverride[ACT_VM_RELOAD] = total_mult
                wep.SequenceRateOverrideScaled[ACT_VM_RELOAD] = total_mult
                wep.SequenceRateOverride[ACT_VM_RELOAD_EMPTY] = total_mult
                wep.SequenceRateOverrideScaled[ACT_VM_RELOAD_EMPTY] = total_mult

                wep.StatCache2["SequenceRateOverrideScaled." .. ACT_VM_RELOAD] = nil
                wep.StatCache2["SequenceRateOverride." .. ACT_VM_RELOAD] = nil
                wep.StatCache2["SequenceRateOverrideScaled." .. ACT_VM_RELOAD_EMPTY] = nil
                wep.StatCache2["SequenceRateOverride." .. ACT_VM_RELOAD_EMPTY] = nil
                wep:ClearStatCache()
                return true
            elseif wep.ArcCW and wep.ChargeWeapon then
                total_mult = 1 / total_mult
                wep.Animations["charging"].Mult = (wep.Animations["charging"].oldMult or 1) * (1 / total_mult)
                wep.Animations["fire"].Mult = (wep.Animations["fire"].oldMult or 1) * (1 / total_mult)
                if wep.Animations["fire_iron"] then
                    wep.Animations["fire_iron"].Mult = (wep.Animations["fire_iron"].oldMult or 1) * (1 / total_mult)
                end

                wep:ChangeVar("Mult_Charge_Speed", 1 / total_mult)
                wep:ChangeVar("Mult_Charge_ReloadAfter_Timer", 1 / total_mult)

                return true
            end
        end
    },
    Mult_RPM = {
        preinit = function(wep)
            if wep.IsTFAWeapon then
                if wep.ChargeRate then
                    wep.Horde_ModifiersTable["Mult_RPM"] = {}
                    wep.Horde_ModifiersTable["Mult_RPM"]["init"] = wep.ChargeRate
                elseif wep.Primary and wep.Primary.RPM then
                    wep.Horde_ModifiersTable["Mult_RPM"] = {}
                    wep.Horde_ModifiersTable["Mult_RPM"]["init"] = wep.Primary.RPM
                end
            end
        end,
        calculate = function(wep, total_mult)
            if wep.IsTFAWeapon then
                if wep.ChargeRate then
                    wep.ChargeRate = total_mult
                    wep.StatCache2["ChargeRate"] = nil
                    wep:ClearStatCache()
                elseif wep.Primary and wep.Primary.RPM then
                    wep.Primary_TFA.RPM = total_mult
                    wep:ClearStatCache()
                    return true
                end
            end
        end
    },
}

function HORDE:Modifier_AddSpecialCondition(cond, funcs)
    special_conditions[cond] = funcs
end

local function CanAddModifier(wep, modifier)
    return !special_conditions[modifier] or !special_conditions[modifier].add_modifier_if or special_conditions[modifier].add_modifier_if(wep)
end

local function CalculateTotalMult(wep, modifier)
    local total_mult = 1
    for _, mult in pairs(wep.Horde_ModifiersTable[modifier]) do
        total_mult = total_mult * mult
    end

    if special_conditions[modifier] and special_conditions[modifier].calculate then
        local res = special_conditions[modifier].calculate(wep, total_mult)
        if res then
            if res == true then
                return
            end
            total_mult = res
        end
    end

    if wep_bases["arccw"](wep) then
        if wep.ChangeVar then
            wep:ChangeVar(modifier, total_mult)
        end
    else
        local weptbl = Weapon_GetTable(wep, modifier)

        local modifier_wep = weptbl[2]
        local tbl = weptbl[1]

        tbl[modifier_wep] = total_mult
        if wep_bases["tfa"](wep) then
            wep:ClearStatCache()
        end
    end
end


local function InitModifierTable(wep, modifier, islocal)
    if !wep.Horde_ModifiersTable then
        wep.Horde_ModifiersTable = {}
    end

    if !wep.Horde_LocalModifiersTable then
        wep.Horde_LocalModifiersTable = {}
    end

    if special_conditions[modifier] and special_conditions[modifier].preinit and special_conditions[modifier].preinit(wep) then
        return
    end

    local weptbl = Weapon_GetTable(wep, modifier)

    local modifier_wep = weptbl[2]
    local tbl = weptbl[1]

    if islocal then
        wep.Horde_LocalModifiersTable[modifier] = {}
    end

    local init
    if wep.Horde_ModifiersTable[modifier] and wep.Horde_ModifiersTable[modifier]["init"] then
        init = wep.Horde_ModifiersTable[modifier]["init"]
    end

    wep.Horde_ModifiersTable[modifier] = {}
    if init then
        wep.Horde_ModifiersTable[modifier]["init"] = init
    elseif tbl[modifier_wep] then
        wep.Horde_ModifiersTable[modifier]["init"] = tbl[modifier_wep]
    end

    if special_conditions[modifier] and special_conditions[modifier].postinit then
        special_conditions[modifier].postinit(wep)
    end
end

function HORDE:Modifier_AddManyToWeapons(ply, modifiers, primarykey, mult)
    if mult then
        mult = math.Round( mult, 4 )
    end

    if !ply.Horde_ModifiersTable then
        ply.Horde_ModifiersTable = {}
    end
    
    for wepbase, modifier in pairs(modifiers) do
        if !ply.Horde_ModifiersTable[modifier] then
            ply.Horde_ModifiersTable[modifier] = {}
        end
    
        ply.Horde_ModifiersTable[modifier][primarykey] = mult
    
        if SERVER then
            net.Start("Horde_wepModifierApply")
            net.WriteBool(false)
            net.WriteString(modifier)
            net.WriteString(primarykey)
            if mult then
                net.WriteBool(false)
                net.WriteFloat(mult)
            else
                net.WriteBool(true)
            end
            
            net.Send(ply)
        end
    end
    
    for _, wep in pairs(ply:GetWeapons()) do
        local modifier = HORDE:Modifier_GetSuitableModifier(wep, modifiers)
        if !CanAddModifier(wep, modifier) then continue end
        if !wep.Horde_ModifiersTable or !wep.Horde_ModifiersTable[modifier] then
            InitModifierTable(wep, modifier)
        end
        wep.Horde_ModifiersTable[modifier][primarykey] = mult

        CalculateTotalMult(wep, modifier)
    end
end

function HORDE:Modifier_AddToWeapons(ply, modifier, primarykey, mult)
    if mult then
        mult = math.Round( mult, 4 )
    end

    ply:AddModifier(modifier, primarykey, mult)

    if table.IsEmpty(ply.Horde_ModifiersTable.AllWeps[modifier]) then
        ply.Horde_ModifiersTable.AllWeps[modifier] = nil
    end

    for _, wep in pairs(ply:GetWeapons()) do
        if !CanAddModifier(wep, modifier) then continue end
        if !wep.Horde_ModifiersTable or !wep.Horde_ModifiersTable[modifier] then
            InitModifierTable(wep, modifier)
        end
        wep.Horde_ModifiersTable[modifier][primarykey] = mult

        CalculateTotalMult(wep, modifier)
    end
    
    if SERVER then
        net.Start("Horde_plyModifierApply")
        net.WriteString(modifier)
        net.WriteString(primarykey)
        if mult then
            net.WriteBool(false)
            net.WriteFloat(mult)
        else
            net.WriteBool(true)
        end
        
        net.Send(ply)
    end
end

function HORDE:Modifier_AddToWeapon(ply, wep, modifier, primarykey, mult, otherdata)
    if mult then
        mult = math.Round( mult, 4 )
    end

    otherdata = otherdata or {}

    local only_to_this_weapon = !!otherdata.OnlyForThisWeapon

    local wpnclass

    if isentity(wep) then
        wpnclass = wep:GetClass()
    else
        wpnclass = wep
        
        wep = ply:GetWeapon(wpnclass)
    end

    if !only_to_this_weapon then
        ply:AddWeaponModifier(wpnclass, modifier, primarykey, mult)
    end

    if IsValid(wep) and CanAddModifier(wep, modifier) then
        if !wep.Horde_ModifiersTable or !wep.Horde_ModifiersTable[modifier] then
            InitModifierTable(wep, modifier, only_to_this_weapon)
        end

        if only_to_this_weapon then
            wep.Horde_LocalModifiersTable[modifier][primarykey] = mult
        end

        wep.Horde_ModifiersTable[modifier][primarykey] = mult

        CalculateTotalMult(wep, modifier)
    end
    if SERVER then
        net.Start("Horde_wepModifierApply")
        net.WriteBool(false)
        net.WriteString(wpnclass)
        net.WriteString(modifier)
        net.WriteString(primarykey)
        if mult then
            net.WriteBool(false)
            net.WriteFloat(mult)
        else
            net.WriteBool(true)
        end

        net.WriteTable(otherdata)
        
        net.Send(ply)
    end
end

function HORDE:Modifier_LoadToWeaponModifier(wep)
    local ply = SERVER and wep:GetOwner() or LocalPlayer()
    if !ply.Horde_ModifiersTable then
        ply.Horde_ModifiersTable = {}
        return
    end
    if !ply.Horde_ModifiersTable.AllWeps then
        ply.Horde_ModifiersTable.AllWeps = {}
        return
    end
    if !wep.Horde_LocalModifiersTable then
        wep.Horde_LocalModifiersTable = {}
    end


    if SERVER then
        net.Start("Horde_wepModifierApply")
        net.WriteBool(true)
        net.WriteEntity(wep)
        net.Send(ply)
    end

    local inits = {}

    if wep.Horde_ModifiersTable then

        for modifier, mults in pairs(wep.Horde_ModifiersTable) do

            local weptbl = Weapon_GetTable(wep, modifier)

            local modifier_wep = weptbl[2]
            local tbl = weptbl[1]

            if wep.Horde_ModifiersTable[modifier].init then
                inits[modifier] = wep.Horde_ModifiersTable[modifier].init
                if wep_bases["arccw"](wep) then
                    wep:ChangeVar(modifier, inits[modifier])
                else
                    tbl[modifier_wep] = inits[modifier]
                    if wep_bases["tfa"](wep) then
                        wep:ClearStatCache()
                    end
                end
                tbl[modifier_wep] = inits[modifier]
                continue
            end

            inits[modifier] = tbl[modifier_wep]
            for primarykey, mult in pairs(mults) do
                inits[modifier] = inits[modifier] / mult
            end
            
            if wep_bases["arccw"](wep) then
                wep:ChangeVar(modifier, inits[modifier])
            else
                tbl[modifier_wep] = inits[modifier]
                if wep_bases["tfa"](wep) then
                    wep:ClearStatCache()
                end
            end
        end
    end

    for modifier, multtable in pairs(ply.Horde_ModifiersTable.AllWeps) do
        if !CanAddModifier(wep, modifier) then continue end
        if !wep.Horde_ModifiersTable or !wep.Horde_ModifiersTable[modifier] then
            InitModifierTable(wep, modifier)
        end

        wep.Horde_ModifiersTable[modifier] = table.Copy(multtable) or {}
        wep.Horde_ModifiersTable[modifier]["init"] = inits[modifier]

        CalculateTotalMult(wep, modifier)
    end

    for modifier, multtable in pairs(ply:GetWeaponModifiers(wep:GetClass())) do
        if !CanAddModifier(wep, modifier) then continue end
        if !wep.Horde_ModifiersTable or !wep.Horde_ModifiersTable[modifier] then
            InitModifierTable(wep, modifier)
        end

        wep.Horde_ModifiersTable[modifier] = table.Merge(wep.Horde_ModifiersTable[modifier] or {}, multtable)
        wep.Horde_ModifiersTable[modifier]["init"] = inits[modifier]

        CalculateTotalMult(wep, modifier)
    end

    for modifier, multtable in pairs(wep.Horde_LocalModifiersTable) do
        if !CanAddModifier(wep, modifier) then continue end
        if !wep.Horde_ModifiersTable or !wep.Horde_ModifiersTable[modifier] then
            InitModifierTable(wep, modifier)
        end

        wep.Horde_ModifiersTable[modifier] = table.Merge(wep.Horde_ModifiersTable[modifier] or {}, multtable)
        wep.Horde_ModifiersTable[modifier]["init"] = inits[modifier]

        CalculateTotalMult(wep, modifier)
    end
end

if SERVER then
    hook.Add("WeaponEquip", "Horde_ModifiersLoad", function(wep)
        timer.Simple(engine.TickInterval(), function()
            if IsValid(wep) then
                HORDE:Modifier_LoadToWeaponModifier(wep)
            end
        end)
    end)
    util.AddNetworkString("Horde_wepModifierApply")
    util.AddNetworkString("Horde_plyModifierApply")
else
    net.Receive("Horde_wepModifierApply", function()
        local loadtowep = net.ReadBool()
        if loadtowep then
            local wep = net.ReadEntity()
            timer.Simple(0.01, function()
                if !IsValid(wep) then
                    return
                end
                HORDE:Modifier_LoadToWeaponModifier(wep)
            end)
        else
            local ply = LocalPlayer()
            local wep = net.ReadString()
            local modifier = net.ReadString()
            local primarykey = net.ReadString()
            local need_to_delete = net.ReadBool()
            local mult
            if !need_to_delete then
                mult = net.ReadFloat()
            end

            local otherdata = net.ReadTable()
            HORDE:Modifier_AddToWeapon(ply, wep, modifier, primarykey, mult, otherdata)
        end
    end)

    net.Receive("Horde_plyModifierApply", function()
        local ply = LocalPlayer()
        local modifier = net.ReadString()
        local primarykey = net.ReadString()
        local need_to_delete = net.ReadBool()
        local mult
        if !need_to_delete then
            mult = net.ReadFloat()
        end
        timer.Simple(engine.TickInterval(), function()
            HORDE:Modifier_AddToWeapons(ply, modifier, primarykey, mult)
        end)
        
    end)
end