concommand.Add("horde_drop_money", function (ply, cmd, args)
    ply:Horde_DropMoney()
end)

concommand.Add("horde_drop_weapon", function (ply, cmd, args)
    ply:DropWeapon()
end)

util.AddNetworkString("Horde_BuyItem")
util.AddNetworkString("Horde_BuyItemAmmoPrimary")
util.AddNetworkString("Horde_BuyItemAmmoSecondary")
util.AddNetworkString("Horde_BuyItemUpgrade")
util.AddNetworkString("Horde_SellItem")
util.AddNetworkString("Horde_SelectClass")
util.AddNetworkString("Horde_InitClass")
util.AddNetworkString("Horde_SyncEconomy")
util.AddNetworkString("Horde_SyncDifficulty")
util.AddNetworkString("Horde_RemoveReadyPanel")
util.AddNetworkString("Horde_SyncMaxWeight")

local plymeta = FindMetaTable("Player")

function plymeta:Horde_SetMaxHealth(base)
    timer.Simple(0, function ()
        if not self:IsValid() then return end
        if not base then base = 100 end
        local bonus = {increase = 0, more = 1, add = 0}
        hook.Run("Horde_OnSetMaxHealth", self, bonus)
        self:SetMaxHealth(bonus.add + base * bonus.more * (1 + bonus.increase))
        self:SetHealth(self:GetMaxHealth())
    end)
end

local ClassesWhichCanBuy200Armor = {Berserker = true, Heavy = true}

function plymeta:Horde_ResetArmorLimit(DeleteSpecArmor, DontResetRegularArmor)
    local specialarmor = self.Horde_Special_Armor
    local maxarmor = 50
    if DontResetRegularArmor then
        maxarmor = self.RegularArmorLimit or maxarmor
    else
        self.RegularArmorLimit = nil
    end
    if self.RegularArmorLimit and !ClassesWhichCanBuy200Armor[self:Horde_GetClass().name] then
        maxarmor = self.RegularArmorLimit > 150 and 50 or maxarmor
    end
    if not DeleteSpecArmor and specialarmor then
        self:SetMaxArmor(math.max(maxarmor, HORDE.items[specialarmor].entity_properties.armor))
    else
        self:SetMaxArmor(maxarmor)

        if (specialarmor) then
            if SERVER then
                net.Start("Horde_SyncSpecialArmor")
                    net.WriteString(specialarmor)
                    net.WriteUInt(0, 3)
                net.Send(self)
            end
            self.Horde_Special_Armor = nil
        end
    end
    self:SetArmor(math.min(self:GetMaxArmor(), self:Armor()))
end

function plymeta:Horde_SetWeight(weight)
    self.Horde_weight = math.Clamp(weight, 0, self:Horde_GetMaxWeight())
end

function plymeta:Horde_SetMaxWeight(weight)
    if self.Horde_max_weight then
        if self.Horde_max_weight > weight then
            local old_max_weight = self:Horde_GetMaxWeight()
            self.Horde_max_weight = weight
            self:Horde_RecalcWeight()
            self.Horde_weight = math.min(weight, self:Horde_GetWeight() - (old_max_weight - weight))
            self:Horde_SyncEconomy()
        else
            self.Horde_weight = math.min(weight, self:Horde_GetWeight() + weight - self:Horde_GetMaxWeight())
            self:Horde_SyncEconomy()
        end
    end
    self.Horde_max_weight = weight
    net.Start("Horde_SyncMaxWeight")
        net.WriteUInt(self.Horde_max_weight, 5)
    net.Send(self)
end

function plymeta:Horde_SetMoney(money)
    self.Horde_money = money
end

function plymeta:Horde_SetSkullTokens(tokens)
    self.Horde_skull_tokens = tokens
end

function plymeta:Horde_SetInBuyZone(can_buy)
    self.Horde_CanBuy = can_buy
    net.Start("Horde_SyncStatus")
        net.WriteUInt(HORDE.Status_CanBuy, 8)
        if can_buy then
            net.WriteUInt(1, 8)
        else
            net.WriteUInt(0, 8)
        end
    net.Send(self)
end

function plymeta:Horde_GetInBuyZone()
    return self.Horde_CanBuy
end

function plymeta:Horde_SetClassModel(class)
    if HORDE.classes[class.name].model and HORDE.classes[class.name].model ~= "" then
        local mdl = HORDE.classes[class.name].model
        local mdl_path = player_manager.TranslatePlayerModel(mdl)
        timer.Simple(0.1, function() self:SetModel(mdl_path) self:SetupHands() end)
        timer.Simple(0.2, function()
            local mdlhands = player_manager.TranslatePlayerHands(mdl)
            local hands_ent = self:GetHands()
            if hands_ent and mdlhands and istable(mdlhands) then
                if hands_ent:GetModel() ~= mdlhands.model then
                    if (IsValid(hands_ent)) then
                        hands_ent:SetModel( mdlhands.model )
                        hands_ent:SetSkin( mdlhands.skin )
                        hands_ent:SetBodyGroups( mdlhands.body )
                    end
                end
            end
        end)
    end
end

function plymeta:Horde_SetDropEntities(entities)
    self.Horde_drop_entities = entities
end

function plymeta:Horde_AddDropEntity(class, entity)
    if not self:IsValid() then return end
    if not self.Horde_drop_entities then
        self.Horde_drop_entities = {}
    end
    if self.Horde_drop_entities[class] then
        self.Horde_drop_entities[class] = self.Horde_drop_entities[class] + 1
    else
        self.Horde_drop_entities[class] = 1
    end
    if not HORDE.player_drop_entities[self:SteamID()] then
        HORDE.player_drop_entities[self:SteamID()] = {}
    end
    HORDE.player_drop_entities[self:SteamID()][entity:GetCreationID()] = entity
end

function plymeta:Horde_RemoveDropEntity(class, entity_creation_id, weightless)
    if not self:IsValid() then return end
    if self.Horde_drop_entities and self.Horde_drop_entities[class] then
        self.Horde_drop_entities[class] = self.Horde_drop_entities[class] - 1
        if self.Horde_drop_entities[class] == 0 then
            self.Horde_drop_entities[class] = nil
        end
    end
    if HORDE.player_drop_entities[self:SteamID()] then
        HORDE.player_drop_entities[self:SteamID()][entity_creation_id] = nil
    end
    local item = HORDE.items[class]
    if item and (not weightless) then
        self:Horde_AddWeight(item.weight)
    end
end

function plymeta:Horde_SetMinionCount(count)
    self.Horde_MinionCount = math.max(0,count)
    net.Start("Horde_SyncStatus")
        net.WriteUInt(HORDE.Status_Minion, 8)
        net.WriteUInt(self.Horde_MinionCount, 8)
    net.Send(self)
end

function plymeta:Horde_GetMinionCount()
    return self.Horde_MinionCount or 0
end

function plymeta:Horde_AddMoney(money)
    if not self:IsValid() or not money then return end
    if not self.Horde_money then self.Horde_money = 0 end
    self.Horde_money = self.Horde_money + money
end

function plymeta:Horde_AddWeight(weight)
    if not self:IsValid() then return end
    self.Horde_weight = math.max(0, (self.Horde_weight or 0) + weight)
end

function plymeta:Horde_AddSkullTokens(tokens)
    if not self:IsValid() and not tokens and tokens <= 0 then return end
    if not self.Horde_skull_tokens then self.Horde_skull_tokens = 0 end
    self.Horde_skull_tokens = self.Horde_skull_tokens + tokens
    HORDE:SaveSkullTokens(self)
end

function plymeta:Horde_GetMoney()
    return self.Horde_money
end

function plymeta:Horde_GetSkullTokens()
    return self.Horde_skull_tokens or 0
end

function plymeta:Horde_GetDropEntities()
    return self.Horde_drop_entities
end

function plymeta:Horde_DropMoney()
    if self:Horde_GetMoney() >= 50 and self:Alive() then
        self:Horde_AddMoney(-50)
        local money = ents.Create("horde_money")
        local pos = self:GetPos()
        local dir = (self:GetEyeTrace().HitPos - pos)
        dir:Normalize()
        local drop_pos = pos + dir * 50
        drop_pos.z = pos.z + 15
        money:SetPos(drop_pos)
        money:DropToFloor()
        money:Spawn()
        self:Horde_SyncEconomy()
    end
end

function plymeta:Horde_GetMaxWeight()
    return self.Horde_max_weight
end

function plymeta:Horde_GetWeight()
    return self.Horde_weight or 0
end

function plymeta:Horde_SyncEconomy()
    if not self:IsValid() then return end
    if not self.Horde_money or not self.Horde_weight or not self.Horde_class then return end
    net.Start("Horde_SyncEconomy")
        net.WriteEntity(self)
        net.WriteInt(self.Horde_money, 32)
        net.WriteInt(self.Horde_skull_tokens, 32)
        net.WriteInt(self.Horde_weight, 32)
        net.WriteString(self:Horde_GetSubclass(self.Horde_class.name))
        net.WriteTable(self.Horde_drop_entities)
    net.Broadcast()
end

function plymeta:Horde_RecalcWeight()
    local weight = 0
    for _, wpn in pairs(self:GetWeapons()) do
        if not HORDE.items[wpn:GetClass()] then goto cont end
        local wpn_weight = HORDE.items[wpn:GetClass()].weight
        if weight + wpn_weight > self:Horde_GetMaxWeight() then
            self:DropWeapon(wpn)
        else
            weight = weight + wpn_weight
        end
        ::cont::
    end
end

hook.Add("PlayerSpawn", "Horde_Economy_Sync", function (ply)
    hook.Run("Horde_ResetStatus", ply)
    net.Start("Horde_ClearStatus")
    net.Send(ply)
    ply:SetCustomCollisionCheck(true)
    HORDE.refresh_living_players = true

    
	
	if HORDE.start_game and HORDE.current_break_time <= 0 then
        if ply:IsValid() then
            ply:KillSilent()
            net.Start("Horde_LegacyNotification")
            net.WriteString("You will respawn next wave.")
            net.Send(ply)
        end
    end
	
    if not ply:IsValid() then return end
    if not ply:Horde_GetCurrentSubclass() then return end
    ply:Horde_SetMaxWeight(HORDE.max_weight)
    ply:Horde_ApplyPerksForClass()
    ply:Horde_SetWeight(ply:Horde_GetMaxWeight())
    if ply.Horde_Special_Armor then
        net.Start("Horde_SyncSpecialArmor")
            net.WriteString(ply.Horde_Special_Armor)
            net.WriteUInt(1, 3)
        net.Send(ply)
    end
    timer.Simple(0, function()
        ply:Horde_ResetArmorLimit()
    end)
    if ply:Horde_GetGadget() then
        local item = HORDE.items[ply:Horde_GetGadget()]
        if item then
            ply:Horde_AddWeight(-item.weight)
        end
    end
    if HORDE.player_drop_entities[ply:SteamID()] then
        for _, ent in pairs(HORDE.player_drop_entities[ply:SteamID()]) do
            if ent:IsValid() then
                local item = HORDE.items[ent:GetClass()]
                if item then
                    ply:Horde_AddWeight(-item.weight)
                end
            end
        end
    end
    ply:Horde_SyncEconomy()
    HORDE:GiveStarterWeapons(ply)
    if GetConVar("horde_enable_sandbox"):GetInt() == 1 then
        net.Start("Horde_SyncStatus")
            net.WriteUInt(HORDE.Status_ExpDisabled, 8)
            net.WriteUInt(1, 8)
        net.Send(ply)
    end
    
    if not HORDE.has_buy_zone then
        net.Start("Horde_SyncStatus")
        net.WriteUInt(HORDE.Status_CanBuy, 8)
        if HORDE.current_break_time > 0 then
            net.WriteUInt(1, 8)
        else
            net.WriteUInt(0, 8)
        end
        net.Send(ply)
    end
end)

hook.Add("PlayerDroppedWeapon", "Horde_Economy_Drop", function (ply, wpn)
    if not ply:IsValid() then return end
    if ply:IsNPC() then return end
    local class = wpn:GetClass()
    if HORDE.items[class] then
        local item = HORDE.items[class]
        ply:Horde_AddWeight(item.weight)
        ply:Horde_SyncEconomy()

        if item.starter_classes then
            if (class == "horde_void_projector" and ply:Horde_GetCurrentSubclass() == "Necromancer") or
               (class == "horde_solar_seal" and ply:Horde_GetCurrentSubclass() == "Artificer") or
               (class == "horde_astral_relic" and ply:Horde_GetCurrentSubclass() == "Warlock") or
               (class == "horde_carcass" and ply:Horde_GetCurrentSubclass() == "Carcass") then
                -- Cannot drop as arti
                wpn:Remove()
                local c = wpn:GetClass()
                timer.Simple(0, function()
                    if ply:Alive() then
                        ply:Give(c)
                    end
                end)
            end
        end

    end
    if ply:Horde_GetClass().name == HORDE.Class_Demolition and class == "weapon_frag" then
        wpn:Remove()
    end
end)

hook.Add("PlayerCanPickupWeapon", "Horde_Economy_Pickup", function (ply, wpn)
    if not ply:IsValid() then return false end
    if ply:IsNPC() then return true end
    if HORDE.items[wpn:GetClass()] then
        local item = HORDE.items[wpn:GetClass()]
        if (ply:Horde_GetWeight() - item.weight < 0) or (item.whitelist and (not item.whitelist[ply:Horde_GetClass().name])) then
            return false
        end
        if item.starter_classes then
            if (item.class == "horde_void_projector" and ply:Horde_GetCurrentSubclass() ~= "Necromancer") or
               (item.class == "horde_solar_seal" and ply:Horde_GetCurrentSubclass() ~= "Artificer") or
               (item.class == "horde_astral_relic" and ply:Horde_GetCurrentSubclass() ~= "Warlock") or
               (item.class == "horde_carcass" and ply:Horde_GetCurrentSubclass() ~= "Carcass") then
                return false
            end
        end
        if ply:Horde_GetCurrentSubclass() == "Carcass" and (item.class ~= "horde_carcass" and item.class ~= "weapon_horde_medkit") then
            print(item.class, 'Carcass weapon dont picked up')
            return false
        end
    end

    return true
end)

hook.Add("WeaponEquip", "Horde_Economy_Equip", function (wpn, ply)
    if not ply:IsValid() then return end
    if HORDE.items[wpn:GetClass()] then
        local item = HORDE.items[wpn:GetClass()]
        if (ply:Horde_GetWeight() - item.weight < 0) or (item.whitelist and (not item.whitelist[ply:Horde_GetClass().name])) then
            timer.Simple(0, function ()
                ply:DropWeapon(wpn)
            end)
            return
        end
        ply:Horde_AddWeight(-item.weight)
        ply:Horde_SyncEconomy()
        return
    end
end)

local function buy_weapon(ply, class, price, skull_tokens)
    local wpns = list.Get("Weapon")
    if not wpns[class] then return end
    local wpn = weapons.Get(class)
    if wpn and wpn.Primary then
        local this_ammo = wpn.Primary.Ammo
        local clear_ammo = true
        for k, v in pairs(ply:GetWeapons()) do
            if v.Primary and v.Primary.Ammo == this_ammo then
                clear_ammo = false
                break
            end
        end
        if clear_ammo then
            ply:RemoveAmmo(ply:GetAmmoCount(this_ammo), this_ammo)
        end
    end
    ply:Horde_AddMoney(-price)
    ply:Horde_AddSkullTokens(-skull_tokens)
    ply:Give(class)
    ply:SelectWeapon(class)
end

net.Receive("Horde_BuyItem", function (len, ply)
    if not ply:IsValid() or not ply:Alive() then return end
    local class = net.ReadString()
    local price = HORDE.items[class].price
    local weight = HORDE.items[class].weight
    local levels = HORDE.items[class].levels
    local skull_tokens = HORDE.items[class].skull_tokens or 0
    local level_satisfy = true
    if levels and (HORDE.disable_levels_restrictions == 0) then
        for c, level in pairs(levels) do
            if ply:Horde_GetLevel(c) < level then
                level_satisfy = false
                break
            end
        end
    end level_satisfy = true
    if ply:Horde_GetMoney() >= price and ply:Horde_GetWeight() >= weight and ply:Horde_GetSkullTokens() >= skull_tokens and level_satisfy then
        local item = HORDE.items[class]
        if item.entity_properties then
            if item.entity_properties.type == HORDE.ENTITY_PROPERTY_WPN then
                -- Weapon entity
                buy_weapon(ply, class, price, skull_tokens)
            elseif item.entity_properties.type == HORDE.ENTITY_PROPERTY_GIVE then
                -- Give entity
                if GetConVar("horde_default_item_config"):GetInt() == 1 and class == "item_battery" then
                    -- Prevent distribution of batteries.
                    if ply:Armor() >= ply:GetMaxArmor() then return end
                end
                ply:Horde_AddMoney(-price)
                ply:Horde_AddSkullTokens(-skull_tokens)
                if item.entity_properties.is_arccw_attachment and item.entity_properties.is_arccw_attachment == true then
                    -- ArcCW support
                    ArcCW:PlayerGiveAtt(ply, class, 1)
                    ArcCW:PlayerSendAttInv(ply)
                else
                    ply:Give(class)
                end
            elseif item.entity_properties.type == HORDE.ENTITY_PROPERTY_DROP then
                -- Drop entity
                local drop_entities = ply:Horde_GetDropEntities()
                if drop_entities[item.class] then
                    if drop_entities[item.class] > item.entity_properties.limit then
                        return
                    end
                end

                -- Prevent players from purchasing turrets if they have the manhack skill.
                if item.class == "npc_turret_floor" and ply:Horde_GetPerk("engineer_manhack") then return end
                
                ply:Horde_AddMoney(-price)
                ply:Horde_AddSkullTokens(-skull_tokens)
                ply:Horde_AddWeight(-item.weight)
                local ent = ents.Create(class)
                local pos = ply:GetPos()
                local dir = (ply:GetEyeTrace().HitPos - pos)
                dir:Normalize()
                local drop_pos = pos + dir * item.entity_properties.x
                drop_pos.z = pos.z + item.entity_properties.z
                ent:SetPos(drop_pos)
                ent:SetAngles(Angle(0, ply:GetAngles().y + item.entity_properties.yaw, 0))
                ply:Horde_AddDropEntity(ent:GetClass(), ent)
                ent:SetNWEntity("HordeOwner", ply)
                ent:Spawn()

                if ent:IsNPC() then
                    -- Minions have no player collsion
                    timer.Simple(0.1, function ()
                        ent:AddRelationship("player D_LI 99")
                        ent:AddRelationship("ally D_LI 99")
                        if HORDE.items["npc_vj_horde_vortigaunt"] then
                            ent:AddRelationship("npc_vj_horde_vortigaunt D_LI 99")
                        end
                        if HORDE.items["npc_vj_horde_combat_bot"] then
                            ent:AddRelationship("npc_vj_horde_combat_bot D_LI 99")
                        end
                        if HORDE.items["npc_turret_floor"] then
                            ent:AddRelationship("npc_turret_floor D_LI 99")
                        end
                        if HORDE.items["npc_manhack"] then
                            ent:AddRelationship("npc_manhack D_LI 99")
                        end
                        ent:AddRelationship("npc_vj_horde_spectre D_LI 99")
						ent:AddRelationship("npc_vj_horde_headcrab D_LI 99")
                        ent.VJFriendly = false
                    end)
                    local npc_info = list.Get("NPC")[ent:GetClass()]
                    if not npc_info then
                        print("[HORDE] NPC does not exist in ", list.Get("NPC"))
                    end
                    
                    local wpns = npc_info["Weapons"]
                    if wpns then
                        local wpn = wpns[math.random(#wpns)]
                        ent:Give(wpn)
                    end

                    -- Special case for turrets
                    local id = ent:GetCreationID()
                    if ent:GetClass() == "npc_turret_floor" then
                        ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
                        timer.Create("Horde_MinionCollision" .. id, 1, 0, function ()
                            if not ent:IsValid() then timer.Remove("Horde_MinionCollision" .. id) return end
                            ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
                        end)
                        HORDE:DropTurret(ent)
                    else
                        ent:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
                        timer.Create("Horde_MinionCollision" .. id, 1, 0, function ()
                            if not ent:IsValid() then timer.Remove("Horde_MinionCollision" .. id) return end
                            ent:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
                        end)
                    end

                    -- Count Minions
                    ply:Horde_SetMinionCount(ply:Horde_GetMinionCount() + 1)

                    if ent:GetClass() == "npc_manhack" then
                        ent:SetMaxHealth(100)
                        ent.Horde_Minion_Respawn = true
                        ent:CallOnRemove("Horde_EntityRemoved", function()
                            timer.Remove("Horde_ManhackRepos" .. id)
                            timer.Remove("Horde_MinionCollision" .. id)
                            if ent:IsValid() and ply:IsValid() then
                                ply:Horde_RemoveDropEntity(ent:GetClass(), ent:GetCreationID())
                                ply:Horde_SyncEconomy()
                                ply:Horde_SetMinionCount(ply:Horde_GetMinionCount() - 1)
                            end
                            if ent.Horde_Minion_Respawn then
                                timer.Remove("Horde_ManhackRespawn" .. id)
                                local drop_ents = ply:Horde_GetDropEntities()
                                local count = drop_ents[class]
                                if (!count) or (count and count <= item.entity_properties.limit) then
                                    timer.Create("Horde_ManhackRespawn" .. id, 4, 1, function ()
                                        if ply:IsValid() then
                                            HORDE:SpawnManhack(ply, id)
                                        end
                                    end)
                                end
                            end
                        end)
                        timer.Create("Horde_ManhackRepos" .. id, 30, 0, function ()
                            if ent:IsValid() and ply:Alive() then
                                ent:SetPos(ply:GetPos() + VectorRand())
                            else
                                timer.Remove("Horde_ManhackRepos" .. id)
                                if ent:IsValid() then ent:Remove() end
                            end
                        end)
                    else
                        ent:CallOnRemove("Horde_EntityRemoved", function()
                            if ent:IsValid() and ply:IsValid() then
                                timer.Remove("Horde_MinionCollision" .. ent:GetCreationID())
                                ply:Horde_RemoveDropEntity(ent:GetClass(), ent:GetCreationID())
                                ply:Horde_SyncEconomy()
                                ply:Horde_SetMinionCount(ply:Horde_GetMinionCount() - 1)
                            end
                        end)
                    end
                end
            elseif item.entity_properties.type == HORDE.ENTITY_PROPERTY_ARMOR then
                local armorcount = item.entity_properties.armor
                local maxarmor = ply:GetMaxArmor()
                if string.sub(item.class, 1, 6) ~= "armor_" and string.sub(item.class, 1, 5) == "armor" then
                    if item.entity_properties.override_maxarmor then
                        if armorcount > maxarmor then
                            ply:SetMaxArmor(armorcount)
                            ply.RegularArmorLimit = armorcount
                        end
                    else
                        armorcount = math.min(armorcount, maxarmor)
                    end
                    if armorcount > ply:Armor() then
                        ply:SetArmor(armorcount)
                    end
                else
                    if armorcount > maxarmor then
                        ply:SetMaxArmor(armorcount)
                        ply:SetArmor(armorcount)
                    elseif armorcount > ply:Armor() then
                        ply:SetArmor(armorcount)
                    end
                    ply.Horde_Special_Armor = item.class
                    net.Start("Horde_SyncSpecialArmor")
                        net.WriteString(ply.Horde_Special_Armor)
                        net.WriteUInt(1, 3)
                    net.Send(ply)
                end
                ply:Horde_AddMoney(-price)
                ply:Horde_AddSkullTokens(-skull_tokens)
                ply:Horde_SyncEconomy()
            elseif item.entity_properties.type == HORDE.ENTITY_PROPERTY_GADGET then
                ply:Horde_UnsetGadget()
                ply:Horde_SetGadget(item.class)
                ply:Horde_AddMoney(-price)
                ply:Horde_AddSkullTokens(-skull_tokens)
                ply:Horde_SyncEconomy()
            end
        else
            buy_weapon(ply, class, price, skull_tokens)
        end

        net.Start("Horde_LegacyNotification")
        net.WriteString("You bought " .. item.name .. ".")
        net.WriteInt(0,2)
        net.Send(ply)
        ply:Horde_SyncEconomy()
    end
end)

function GM:PlayerUse(other_ply, target)    -- This will make it to be default behaviour, that can be overridden by other addons hooks. Let's hope they won't return true >.>
    local owner = target:GetNWEntity("HordeOwner")
    if IsValid(owner) and other_ply ~= owner then return false end   -- If owner disconnected/not valid, why would we care about ownership?

    if target:GetClass() == "npc_turret_floor" then
        target:GetPhysicsObject():EnableMotion(true)
    end

    return true
end

function HORDE:DropTurret(ent)
    local turret_pos = ent:GetPos()
    local tr = util.TraceLine({
        start = turret_pos,
        endpos = turret_pos + Vector(0,0,-1) * 10000,
        filter = ent,
        collisiongroup =  COLLISION_GROUP_WORLD
    })
    
    if IsValid(tr.Entity) or tr.HitWorld then
        local dist_sqr = turret_pos:DistToSqr(tr.HitPos)
        -- If you drop turrets from somewhere too high, they will just fall over.
        if dist_sqr >= 40000 then return end
        ent:SetPos(Vector(turret_pos.x, turret_pos.y, tr.HitPos.z + 15))
        ent:DropToFloor()
        timer.Simple(0.5, function()
            if not ent:IsValid() then return end
            ent:GetPhysicsObject():EnableMotion(false)
        end)
    end
end

hook.Add("OnPlayerPhysicsDrop", "Horde_TurretDrop", function (ply, ent, thrown)
    if ent:GetNWEntity("HordeOwner") and (ent:GetClass() == "npc_turret_floor" or (ent:GetClass() == "npc_vj_horde_rocket_turret" and (not ent.Horde_Pickedup))) then
        -- Turrets should always stay straight.
        local a = ent:GetAngles()
        ent:SetAngles(Angle(0, a.y, 0))
        HORDE:DropTurret(ent)

        if ent:GetClass() == "npc_vj_horde_rocket_turret" then
            ent:SetAngles(Angle(0,0,0))
            ent:PhysicsInit(SOLID_OBB)
        end
    end
end)

net.Receive("Horde_SellItem", function (len, ply)
    if not ply:IsValid() then return end
    local class = net.ReadString()
    local canSell, why = hook.Call("CanSell", HORDE, ply, class)
    if canSell == false then
        net.Start("Horde_LegacyNotification")
        net.WriteString(why or "You can't sell this.")
        net.WriteInt(1,2)
        net.Send(ply)
        return
    end
    if ply:HasWeapon(class) then
        local item = HORDE.items[class]
        ply:Horde_AddMoney(math.floor(item.price * 0.25))
        local wep = ply:GetWeapon(class)
        if wep.ArcCW and wep.Attachments then 
            for k, v in pairs(wep.Attachments) do
                if v.Installed and !v.FreeSlot and !v.Integral then
                    ArcCW:PlayerGiveAtt(ply, v.Installed)
                end
            end
            ArcCW:PlayerSendAttInv(ply)
        end
        ply:StripWeapon(class)
        ply:Horde_SyncEconomy()
    else
        local item = HORDE.items[class]
        if item.entity_properties.type == HORDE.ENTITY_PROPERTY_DROP then
            local drop_entities = ply:Horde_GetDropEntities()
            if drop_entities and drop_entities[class] then
                ply:Horde_AddMoney(math.floor(0.25 * item.price * drop_entities[class]))
                -- Remove all the drop entiies of this player
                for _, ent in pairs(HORDE.player_drop_entities[ply:SteamID()]) do
                    if ent:IsValid() and ent:GetClass() == class then
                        ent.Horde_Minion_Respawn = nil
                        timer.Remove("Horde_ManhackRespawn" .. ent:GetCreationID())
                        ent:Remove()
                        if not ent:IsNPC() then
                            if ply.Horde_drop_entities and ply.Horde_drop_entities[class] then
                                ply.Horde_drop_entities[class] = ply.Horde_drop_entities[class] - 1
                                if ply.Horde_drop_entities[class] == 0 then
                                    ply.Horde_drop_entities[class] = nil
                                end
                            end
                            if not ent.Horde_Is_Mini_Sentry then
                                ply:Horde_AddWeight(item.weight)
                            end
                        end
                    end
                end
                ply:Horde_SyncEconomy()
            end
        elseif item.entity_properties.type == HORDE.ENTITY_PROPERTY_GADGET then
            if ply:Horde_GetGadget() == nil then return end
            ply:Horde_UnsetGadget()
            ply:Horde_AddMoney(math.floor(0.25 * item.price))
            ply:Horde_SyncEconomy()
        end
    end
end)

net.Receive("Horde_InitClass", function (len, ply)
    HORDE:LoadSubclassUnlocks(ply)
    local subclass_name = net.ReadString()
    local subclass = HORDE.subclasses[subclass_name]
    local class
    if subclass.ParentClass then
        class = HORDE.classes[subclass.ParentClass]
    else
        class = HORDE.classes[subclass.PrintName]
    end
    if not class then return end
    if ply:Horde_GetSubclassUnlocked(subclass_name) == false then
        subclass_name = class.name
    end
    ply:Horde_SetClass(class)
    ply:Horde_SetSubclass(class.name, subclass_name)
    ply:Horde_SetMaxWeight(HORDE.max_weight)
    ply:Horde_ApplyPerksForClass()
    ply:Horde_SetWeight(ply:Horde_GetMaxWeight())
    ply:SetMaxHealth(class.max_hp)
    ply:Horde_SyncEconomy()
end)

net.Receive("Horde_SelectClass", function (len, ply)
    if not ply:IsValid() then return end
    if ply:Alive() then
        if HORDE.start_game and HORDE.current_break_time <= 0 then
            net.Start("Horde_LegacyNotification")
            net.WriteString("You cannot change class after a wave has started.")
            net.WriteInt(1,2)
            net.Send(ply)
            return
        end
        if GetConVar("horde_testing_unlimited_class_change"):GetInt() == 0 and HORDE.player_class_changed[ply:SteamID()] then
            net.Start("Horde_LegacyNotification")
            net.WriteString("You cannot change class more than once per wave.")
            net.WriteInt(1,2)
            net.Send(ply)
            return
        end
    end
    local name = net.ReadString()
    local subclass_name = net.ReadString()

    if ply:Horde_GetSubclassUnlocked(subclass_name) == false then
        net.Start("Horde_LegacyNotification")
        net.WriteString("Subclass " .. subclass_name .. " is not unlocked on this server.")
        net.WriteInt(1,2)
        net.Send(ply)
        return
    end
    local class = HORDE.classes[name]
    if not class then return end

    -- Clear status
    net.Start("Horde_ClearStatus")
    net.Send(ply)

    -- Drop all weapons
    local occupied_weight = 0
    local not_regive_starter_weapons = GetConVar("horde_enable_starter"):GetInt() == 0 or HORDE.start_game
	if !not_regive_starter_weapons then
		not_regive_starter_weapons = HORDE.start_money != ply:Horde_GetMoney()
	end
    ply:Horde_SetClass(class)
    ply:Horde_SetSubclass(name, subclass_name)
    if not_regive_starter_weapons then
        for _, wpn in pairs(ply:GetWeapons()) do
            if hook.Run("PlayerCanPickupWeapon", ply, wpn) == true then 
                occupied_weight = occupied_weight + HORDE.items[wpn:GetClass()].weight
                print(wpn:GetClass())
                continue
            end
            ply:DropWeapon(wpn)
        end
    else
		ply:StripAmmo()
        ply:StripWeapons()
		ply:Horde_SetGivenStarterWeapons(false)
        HORDE:GiveStarterWeapons(ply)
        for _, wpn in pairs(ply:GetWeapons()) do
            occupied_weight = occupied_weight + HORDE.items[wpn:GetClass()].weight
        end
    end

    -- Remove all entities
    if HORDE.player_drop_entities[ply:SteamID()] then
        for _, ent in pairs(HORDE.player_drop_entities[ply:SteamID()]) do
            if ent:IsValid() then
                ent:Remove()
            end
        end
    end
    HORDE.player_drop_entities[ply:SteamID()] = {}
    ply:Horde_SetMinionCount(0)

    ply:Horde_SetMaxWeight(HORDE.max_weight)
    ply:Horde_ApplyPerksForClass()
    ply:Horde_SetWeight(ply:Horde_GetMaxWeight() - occupied_weight)
    
    timer.Simple(0, function()
        ply:Horde_ResetArmorLimit(true, true)
    end)
    
    ply:Horde_UnsetGadget()
    ply:SetMaxHealth(class.max_hp)
    net.Start("Horde_ToggleShop")
    net.Send(ply)

    net.Start("Horde_LegacyNotification")
    net.WriteString("You changed class to " .. class.name)
    net.WriteInt(0,2)
    net.Send(ply)
    if GetConVar("horde_testing_unlimited_class_change"):GetInt() == 0 then
        HORDE.player_class_changed[ply:SteamID()] = true
    end

    ply:Horde_SyncEconomy()
end)

net.Receive("Horde_BuyItemAmmoPrimary", function (len, ply)
    if not ply:IsValid() or not ply:Alive() then return end
    local class = net.ReadString()
    if not ply:HasWeapon(class) then
        net.Start("Horde_LegacyNotification")
        net.WriteString("You don't have this weapon!")
        net.WriteInt(0,2)
        net.Send(ply)
        return
    end

    local is_maxammo = net.ReadBool()
    
    local price
    if is_maxammo then
        price = HORDE:Ammo_RefillCost(ply, HORDE.items[class])
    else
        price = HORDE:Ammo_RefillOneMagCost(ply, HORDE.items[class])
    end
    
    if ply:Horde_GetMoney() >= price then
        local wpn = ply:GetWeapon(class)
        if HORDE:GiveAmmo(ply, wpn, is_maxammo and HORDE.Ammo_Max or 1) then 
			ply:Horde_AddMoney(-price)
			ply:Horde_SyncEconomy()
		end
    end
end)

net.Receive("Horde_BuyItemAmmoSecondary", function (len, ply)
    if not ply:IsValid() or not ply:Alive() then return end
    local class = net.ReadString()
    if not ply:HasWeapon(class) then
        net.Start("Horde_LegacyNotification")
        net.WriteString("You don't have this weapon!")
        net.WriteInt(0,2)
        net.Send(ply)
        return
    end
    
    local price = HORDE.items[class].secondary_ammo_price
    if ply:Horde_GetMoney() >= price then
        ply:Horde_AddMoney(-price)
        local wpn = ply:GetWeapon(class)
        local ammo_id = wpn:GetSecondaryAmmoType()
        if ammo_id >= 0 then
            ply:GiveAmmo(1, ammo_id, false)
            ply:Horde_SyncEconomy()
        end
    end
end)

net.Receive("Horde_BuyItemUpgrade", function (len, ply)
    if not ply:IsValid() or not ply:Alive() then return end
    local class = net.ReadString()
    if not ply:HasWeapon(class) then
        net.Start("Horde_LegacyNotification")
        net.WriteString("You don't have this weapon!")
        net.WriteInt(0,2)
        net.Send(ply)
        return
    end

    if ply:Horde_GetUpgrade(class) >= 10 then return end

    local price = 800 + 25 * ply:Horde_GetUpgrade(class)
    if ply:Horde_GetMoney() >= price then
        ply:Horde_AddMoney(-price)
        ply:Horde_SetUpgrade(class, ply:Horde_GetUpgrade(class) + 1)
        ply:Horde_SyncEconomy()
    end
end)

function HORDE:CanSell(ply, class)
    if ply:Horde_GetClass().name == HORDE.Class_Demolition and class == "weapon_frag" then
        return false, "You can't sell grenades as Demolition class!"
    end

    if ply:Horde_GetSubclass(ply:Horde_GetClass().name) == "Necromancer" and class == "horde_void_projector" then
        return false, "You can't sell Void Projector as Necromancer subclass!"
    end

    if ply:Horde_GetSubclass(ply:Horde_GetClass().name) == "Artificer" and class == "horde_solar_seal" then
        return false, "You can't sell Solar Seal as Artificer subclass!"
    end

    return true
end
