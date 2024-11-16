-- melee attack mults
local wep_bases = {
    ["arccw"] = function(wep) return !!wep.ArcCW end,
    ["tfa"] = function(wep) return !!wep.IsTFAWeapon end,
    ["arc9"] = function(wep) return !!wep.ARC9 end,
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

    return {tbl or wep, key}
end

local function Weapon_SetVar(wep, key, var, priority, varbase)

    if wep_bases["arccw"](wep) then
        if !wep.ModifiedCache_Permanent then
            wep.ModifiedCache_Permanent = {}
        end
        wep.ModifiedCache_Permanent[key] = true
        wep.ModifiedCache[key] = true
        wep.TickCache_Overrides[key] = nil
        wep.TickCache_Mults[key] = nil
        wep.TickCache_Adds[key] = nil
        wep.AttCache_Hooks[key] = nil

        if priority then
            wep[key .. "_Priority"] = priority
        end
    elseif wep_bases["arc9"](wep) then
		wep:InvalidateCache()
		--[[local val = key
		if varbase then
			val = varbase
		else
			for _, valend in pairs({"Mult", "Add", "Override"}) do
				if string.EndsWith(val, valend) then
					val = string.sub(val, 1, #val - #valend)
					if !wep[val] then
						val = key
					end
					break
				end
			end
		end
		wep.StatCache["nil" .. val] = nil
		wep.StatCache[val] = nil
        wep.PV_CacheLong[val] = nil
        wep.PV_CacheLong[val .. "nil"] = nil
		wep.PV_Cache[val] = nil
		wep.PV_Cache[val .. "nil"] = nil
		wep.AffectorsCache = nil]]
        if priority then
            wep[key .. "_Priority"] = priority
        end
    end
    local weptbl = Weapon_GetTable(wep, key)

    local tbl = weptbl[1]
    local modifier_wep = weptbl[2]
    tbl[modifier_wep] = var

    if wep_bases["tfa"](wep) then
        wep:ClearStatCache(key)
    end
end

local function Weapon_GetVar(wep, key)
    local weptbl = Weapon_GetTable(wep, key)

    local tbl = weptbl[1]
    local modifier_wep = weptbl[2]

    return tbl[modifier_wep]
end

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

local function ApplyToWeaponModifier(wep, modifier, primarykey, mult)
    wep.Horde_ModifiersTable[modifier][primarykey] = mult
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


                Weapon_SetVar(wep, "Mult_Charge_Speed", 1 / total_mult)
                Weapon_SetVar(wep, "Mult_Charge_ReloadAfter_Timer", 1 / total_mult)

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
    local cur_override
    local priority = 0
    
    local rounded_value = false
	local varbase
    local total_mult = 1
    local total_add = 0
    for _, mult in pairs(wep.Horde_ModifiersTable[modifier]) do
        if istable(mult) then
            if mult.override and mult.priority > priority then
                priority = mult.priority
                cur_override = mult.override
            end
			if mult.varbase then
				varbase = mult.varbase
			end

            if mult.rounded_value then
                rounded_value = true
            end

            total_add = total_add + (mult.add or 0)
            total_mult = total_mult * (mult.mult or 1)
        elseif isnumber(mult) then
            total_mult = total_mult * mult
        end
    end

    if cur_override then
        total_mult = cur_override
    else
        total_mult = total_mult + total_add

        if rounded_value then
            total_mult = math.Round(total_mult)
        end
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

    Weapon_SetVar(wep, modifier, total_mult, priority > 0 and priority, varbase)
end


local function InitModifierTable(wep, modifier, islocal)
    if !wep.Horde_LocalModifiersTable then
        wep.Horde_LocalModifiersTable = {}
    end
    if islocal and !wep.Horde_LocalModifiersTable[modifier] then
        wep.Horde_LocalModifiersTable[modifier] = {}
    end

    if !wep.Horde_ModifiersTable then
        wep.Horde_ModifiersTable = {}
    elseif wep.Horde_ModifiersTable[modifier] then
        return
    end

    if special_conditions[modifier] and special_conditions[modifier].preinit and special_conditions[modifier].preinit(wep) then
        return
    end

    local modifier_var = Weapon_GetVar(wep, modifier)

    local init
    if wep.Horde_ModifiersTable[modifier] and wep.Horde_ModifiersTable[modifier]["init"] then
        init = wep.Horde_ModifiersTable[modifier]["init"]
    end

    wep.Horde_ModifiersTable[modifier] = {}
    if init then
        wep.Horde_ModifiersTable[modifier]["init"] = init
    elseif modifier_var then
        wep.Horde_ModifiersTable[modifier]["init"] = modifier_var
    end

    if special_conditions[modifier] and special_conditions[modifier].postinit then
        special_conditions[modifier].postinit(wep)
    end
end

--[[function HORDE:Modifier_AddManyToWeapons(ply, modifiers, primarykey, mult)
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
end]]

function HORDE:Modifier_AddToWeapons(ply, modifier, primarykey, mult, otherdata)
    otherdata = otherdata or {}
    if mult then
        if istable(mult) then
            mult.mult = math.Round( mult.mult, 4 )
            mult.add = math.Round( mult.add, 4 )
        else
            mult = math.Round( mult, 4 )
        end
    end

    ply:AddModifier(modifier, primarykey, mult)

    if table.IsEmpty(ply.Horde_ModifiersTable.AllWeps[modifier]) then
        ply.Horde_ModifiersTable.AllWeps[modifier] = nil
    end

    for _, wep in pairs(ply:GetWeapons()) do
        if !CanAddModifier(wep, modifier) then continue end
        InitModifierTable(wep, modifier)
        ApplyToWeaponModifier(wep, modifier, primarykey, mult)

        CalculateTotalMult(wep, modifier)
    end

    local nosync = !!otherdata.NoSync
    
    if SERVER and !nosync then
        net.Start("Horde_plyModifierApply")
        net.WriteString(modifier)
        net.WriteString(primarykey)
        if mult then
            local has_func = false
            for k, v in pairs(istable(mult) and mult or {}) do
                if isfunction(v) then
                    has_func = true
                    break
                end
            end
            net.WriteBool(false)
            net.WriteTable(has_func and
            {
                add = 0,
                mult = 1,
            }
            or
            istable(mult) and mult or
            {
                add = 0,
                mult = mult,
            }
            )
            --net.WriteFloat(mult)
        else
            net.WriteBool(true)
        end
        
        net.Send(ply)
    end
end

function HORDE:Modifier_AddToWeapon(ply, wep, modifier, primarykey, mult, otherdata)
    local wpnclass
    if isentity(wep) then
        wpnclass = wep:GetClass()
    else
        wpnclass = wep
        wep = ply:GetWeapon(wpnclass)
    end
    if !wep or !IsValid(wep) then return end
    otherdata = otherdata or {}

    if mult then
        if istable(mult) then
            if mult.mult then mult.mult = math.Round( mult.mult, 4 ) end
            if mult.add then mult.add = math.Round( mult.add, 4 ) end
        else
            mult = math.Round( mult, 4 )
        end
    end


    local only_to_this_weapon = !!otherdata.OnlyForThisWeapon
    local nosync = !!otherdata.NoSync

    if !only_to_this_weapon then
        ply:AddWeaponModifier(wpnclass, modifier, primarykey, mult)
    end

    if !CanAddModifier(wep, modifier) then return end

    InitModifierTable(wep, modifier, only_to_this_weapon)

    if only_to_this_weapon then
        wep.Horde_LocalModifiersTable[modifier][primarykey] = mult
    end

    ApplyToWeaponModifier(wep, modifier, primarykey, mult)

    CalculateTotalMult(wep, modifier)

    if SERVER and !nosync then
        net.Start("Horde_wepModifierApply")
        net.WriteBool(false)
        net.WriteString(wpnclass)
        net.WriteString(modifier)
        net.WriteString(primarykey)
        if mult then
            local has_func = false
            for k, v in pairs(istable(mult) and mult or {}) do
                if isfunction(v) then
                    has_func = true
                    break
                end
            end
            net.WriteBool(false)
            net.WriteTable(has_func and
            {
                add = 0,
                mult = 1,
            }
            or
            istable(mult) and mult or
            {
                add = 0,
                mult = mult,
            }
            )
            --net.WriteFloat(mult)
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
            if wep.Horde_ModifiersTable[modifier].init then
                inits[modifier] = wep.Horde_ModifiersTable[modifier].init
                Weapon_SetVar(wep, modifier, inits[modifier])
                continue
            end

            inits[modifier] = Weapon_GetVar(wep, modifier)
            if isnumber(inits[modifier]) then
                for primarykey, mult in pairs(mults) do
                    if !istable(mult) then
                        inits[modifier] = inits[modifier] / mult
                        continue
                    end

                    if (isnumber(mult.add) or isnumber(mult.mult)) and !mult.override then
                        inits[modifier] = (inits[modifier] / (mult.mult or 1)) - (mult.add or 0)
                    end
                end
            end
            
            Weapon_SetVar(wep, modifier, inits[modifier])
        end
    end

    for _, modif_tbl in pairs({
        ply.Horde_ModifiersTable.AllWeps, -- modifiers applies to all weapons
        ply:GetWeaponModifiers(wep:GetClass()), -- modifiers applies only to this weapon class
        wep.Horde_LocalModifiersTable -- modifiers applies only to this weapon (dissapier when this weapon also dissapiers)
    }) do
        for modifier, multtable in pairs(modif_tbl) do
            if !CanAddModifier(wep, modifier) then continue end
            if !wep.Horde_ModifiersTable or !wep.Horde_ModifiersTable[modifier] then
                InitModifierTable(wep, modifier)
            end
    
            wep.Horde_ModifiersTable[modifier] = table.Merge(wep.Horde_ModifiersTable[modifier] or {}, multtable)
            wep.Horde_ModifiersTable[modifier]["init"] = inits[modifier] or Weapon_GetVar(wep, modifier)
    
            CalculateTotalMult(wep, modifier)
        end
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
                mult = net.ReadTable()
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
            mult = net.ReadTable()
        end
        timer.Simple(engine.TickInterval() * 2, function()
            HORDE:Modifier_AddToWeapons(ply, modifier, primarykey, mult)
        end)
    end)
end