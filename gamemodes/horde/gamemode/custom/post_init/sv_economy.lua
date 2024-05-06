local waves_type = GetConVar("horde_waves_type"):GetInt()

HORDE.class_withstartmoney = {
    [HORDE.Class_Heavy] = {
        Carcass = true
    }
}

function HORDE:GetStartMoney(default_startmoney)
    if default_startmoney then
        return math.max(0, math.floor(GetConVarNumber("horde_start_money") * HORDE.difficulty_start_money_multiplier[HORDE.difficulty] * HORDE.wavestype_startmoneybonus[waves_type]))
    end
    return 100
end

HORDE.wavestype_startmoneybonus = {
    [1] = 1,
    [2] = 1.15,
    [3] = 1.25,
}
HORDE.difficulty_start_money_multiplier = {1, 0.9, 0.8, 0.75, 0.6}
if waves_type != 1 then
    if waves_type == 2 then
        HORDE.kill_reward_base = math.floor(HORDE.kill_reward_base * 1.15)
        HORDE.total_enemies_per_wave = {24, 28, 30, 33, 38, 41, 45}
        HORDE.round_bonus_base = math.floor(HORDE.round_bonus_base * 1.4)

        HORDE.max_waves = 7

        HORDE.waves_for_perk = {
            1,3,4,5
        }
    elseif waves_type == 3 then
        HORDE.kill_reward_base = math.floor(HORDE.kill_reward_base * 1.6)
        HORDE.total_enemies_per_wave = {36, 38, 40, 45}
        HORDE.round_bonus_base = math.floor(HORDE.round_bonus_base * 2.5)

        HORDE.max_waves = 4

        HORDE.waves_for_perk = {
            1,2,3,3
        }
    end
    HORDE.start_money = math.floor(HORDE.start_money * HORDE.wavestype_startmoneybonus[waves_type])
    HORDE.kill_reward_base = math.floor(HORDE.kill_reward_base * HORDE.wavestype_startmoneybonus[waves_type])
    
    HORDE.max_max_waves = HORDE.max_waves
end

local plymeta = FindMetaTable("Player")

function plymeta:Horde_SetMaxArmor(base)
    timer.Simple(0, function ()
        if not self:IsValid() then return end
        base = self:Horde_GetArmorLimit() * ((base or 100) / 100)
        local bonus = {increase = 0, more = 1, add = 0}
        hook.Run("Horde_OnSetMaxArmor", self, bonus)
        self:SetMaxArmor(bonus.add + base * bonus.more * (1 + bonus.increase))
    end)
end

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

function plymeta:Horde_GetArmorLimit()
    local specialarmor = self.Horde_Special_Armor
    local maxarmor = self.RegularArmorLimit or 50

    if specialarmor then
        maxarmor = math.max(maxarmor, HORDE.items[specialarmor].entity_properties.armor)
    end
    return maxarmor
end

function plymeta:Horde_SetWeight(weight)
    self.Horde_weight = math.Clamp(weight, 0, self:Horde_GetMaxWeight())
end

function plymeta:Horde_SetClassModel(class)
    --[[if HORDE.classes[class.name].model and HORDE.classes[class.name].model ~= "" then
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
    end]]
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
        net.WriteEntity(self)
        net.WriteUInt(self.Horde_max_weight, 5)
    net.Broadcast()--(self)
end

function plymeta:Horde_RecalcWeight()
    local weight = 0
    for _, wpn in pairs(self:GetWeapons()) do
        if not HORDE.items[wpn:GetClass()] then goto cont end
        local wpn_weight = HORDE.items[wpn:GetClass()].weight
        if weight + wpn_weight > self:Horde_GetMaxWeight() then
            if IsValid(wpn) and !self:CanDropWeapon(wpn) then
                self:StripWeapon(wpn:GetClass())
            else
                self:DropWeapon(wpn)
            end
        else
            weight = weight + wpn_weight
        end
        ::cont::
    end
end

hook.Add("PlayerSpawn", "Horde_Economy_Sync", function (ply)
    if ply.Horde_Fake_Respawn == true then return end
    hook.Run("Horde_ResetStatus", ply)
    net.Start("Horde_ClearStatus")
    net.Send(ply)
    ply:SetCustomCollisionCheck(true)
    HORDE.refresh_living_players = true

	if HORDE.start_game and HORDE.current_break_time <= 0 then
        if !ply.MarkedForRespawn then
            local ret = hook.Run("Horde_OnPlayerShouldRespawnDuringWave")
            if not ret then
                ply:KillSilent()
                HORDE:SendNotification("You will respawn next wave.", 0, ply)
            end
        else
            ply.MarkedForRespawn = nil
        end
    end

    if not ply:IsValid() or not ply.Horde_Init_Complete then return end
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
        ply.Horde_Special_Armor = nil
        ply.RegularArmorLimit = nil
        ply:Horde_SetMaxArmor()
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




hook.Add("WeaponEquip", "Horde_Economy_Equip", function (wpn, ply)
    if not ply:IsValid() then return end
    if HORDE.items[wpn:GetClass()] then
        local item = HORDE.items[wpn:GetClass()]
        if ply:Horde_GetCurrentSubclass() == "Gunslinger" and item.category == "Pistol" then
            ply:Horde_AddWeight(-item.weight)
            ply:Horde_SyncEconomy()
            return
        end
        if (ply:Horde_GetWeight() - item.weight < 0) or (item.whitelist and (not item.whitelist[ply:Horde_GetClass().name])) then
            timer.Simple(0, function ()
                if IsValid(wpn) and !ply:CanDropWeapon(wpn) then
                    ply:StripWeapon(wpn:GetClass())
                else
                    ply:DropWeapon(wpn)
                end
            end)
            return
        end
        if item.entity_properties.weapons_group then
            local class_1 = wpn:GetClass()
            for _, wpn_2 in pairs(ply:GetWeapons()) do
                local class_2 = wpn_2:GetClass()
                if class_2 == class_1 then continue end
                local item_2 = HORDE.items[class_2]
                if item_2 and item_2.entity_properties.weapons_group == item.entity_properties.weapons_group then
                    ply:StripWeapon(class_2)
                end
            end
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
    if hook.Run("CanBuyItem", ply, class) == false then return end

    local price = HORDE.items[class].price
    local weight = HORDE.items[class].weight
    local levels = HORDE.items[class].levels
    local skull_tokens = HORDE.items[class].skull_tokens or 0
    if ply:Horde_GetMoney() >= price and ply:Horde_GetWeight() >= weight and ply:Horde_GetSkullTokens() >= skull_tokens and HORDE:WeaponLevelLessThanYour(ply, levels) then
        local item = HORDE.items[class]
        if item.entity_properties then
            if item.entity_properties.type == HORDE.ENTITY_PROPERTY_WPN then
                -- Weapon entity

                if not HORDE:CanPickUpWeapon(ply, class) then return end
                
                local drop_entities
                local limit = item.entity_properties.limit
                if limit then
                    drop_entities = ply:Horde_GetDropEntities()
                    if drop_entities[item.class] and drop_entities[item.class] >= limit then
                        return
                    end
                end
                buy_weapon(ply, class, price, skull_tokens)
                
                if limit then
                    timer.Simple(0, function()
                        ply:Horde_AddDropEntity(class, ply:GetWeapon(class))
                        --ply:Horde_RemoveDropEntity(class, entity_creation_id, weightless)
                    end)
                end
                HORDE:Ammo_CheckForValidWorking(ply)
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
                        ent:AddRelationship("npc_vj_horde_shadow_hulk D_LI 99")
						ent:AddRelationship("npc_vj_horde_headcrab D_LI 99")
                        ent:AddRelationship("npc_vj_horde_antlion D_LI 99")
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
                        ent:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
                        timer.Simple(0.1, function ()
                            if not ent:IsValid() then return end
                            ent:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
                        end)
                        HORDE:DropTurret(ent)
                    else
                        ent:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
                        ent:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
                        timer.Simple(0.1, function ()
                            if not ent:IsValid() then return end
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
                if item.class == "armorrefill" then
                    local curarmor = ply:Armor()
                    local recovered_armor = math.min(math.floor(ply:Horde_GetMoney() / 10), maxarmor - curarmor)
                    price = recovered_armor * 10
                    ply:SetArmor(recovered_armor + curarmor)
                elseif string.sub(item.class, 1, 6) ~= "armor_" then
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
                ply:EmitSound("items/battery_pickup.wav")

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

        HORDE:SendNotification("You bought " .. item.name .. ".", 0, ply)
        ply:Horde_SyncEconomy()
    end
end)

net.Receive("Horde_SellItem", function (len, ply)
    if not ply:IsValid() then return end
    local class = net.ReadString()
    local canSell, why = hook.Call("CanSell", HORDE, ply, class)
    if canSell == false then
        HORDE:SendNotification(why or "You can't sell this.", 1, ply)
        return
    end
    local item = HORDE.items[class]
    if item and item.entity_properties and item.entity_properties.sell_forbidden then
        HORDE:SendNotification("it is forbidden to sell this.", 1, ply)
        return
    end
    if ply:HasWeapon(class) then
        local wep = ply:GetWeapon(class)
        if wep.Horde_OnSell and wep:Horde_OnSell() then return end
        local item = HORDE.items[class]
        ply:Horde_AddMoney(math.floor(item.price * 0.25))
		if wep.ArcCW and wep.Attachments then
            for k, v in pairs(wep.Attachments) do
                if v.Installed and !v.FreeSlot and !v.Hidden and !v.Integral then
                    ArcCW:PlayerGiveAtt(ply, v.Installed)
                end
            end
            ArcCW:PlayerSendAttInv(ply)
        end
        ply:StripWeapon(class)
        ply:Horde_SyncEconomy()
    else
        if item.entity_properties.type == HORDE.ENTITY_PROPERTY_DROP or item.entity_properties.wep_that_place then
            local drop_entities = ply:Horde_GetDropEntities()
            if drop_entities and drop_entities[class] then
                ply:Horde_AddMoney(math.floor(0.25 * item.price * drop_entities[class]))
                -- Remove all the drop entiies of this player
                for _, ent in pairs(HORDE.player_drop_entities[ply:SteamID()]) do
                    if ent:IsValid() and (ent:GetClass() == class or ent.Horde_ItemID == class) then
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

local bugfix_spellers = {
    Artificer = true,
    Warlock = true,
    Necromancer = true,
}

net.Receive("Horde_SelectClass", function (len, ply)
    if not ply:IsValid() then return end
    if ply:Alive() then
        if HORDE.start_game and HORDE.current_break_time <= 0 then
            HORDE:SendNotification("You cannot change class after a wave has started.", 1, ply)
            return
        end
        if GetConVar("horde_testing_unlimited_class_change"):GetInt() == 0 and HORDE.player_class_changed[ply:SteamID()] then
            HORDE:SendNotification("You cannot change class more than once per wave.", 1, ply)
            return
        end
    end
    local name = net.ReadString()
    local subclass_name = net.ReadString()

    if ply:Horde_GetSubclassUnlocked(subclass_name) == false then
        --HORDE:SendNotification("You don't have this spell!")
        HORDE:SendNotification("Subclass " .. subclass_name .. " is not unlocked on this server.", 1, ply)
        --[[net.Start("Horde_LegacyNotification")
        net.WriteString()
        net.WriteInt(1,2)
        net.Send(ply)]]
        return
    end
    local class = HORDE.classes[name]
    if not class then return end

    -- Clear status
    net.Start("Horde_ClearStatus")
    net.Send(ply)
    local game_is_not_start = not (HORDE.start_game and HORDE.current_break_time <= 0) and HORDE.current_wave == 0
    -- ply.Horde_PlayerSpells
    -- Drop all weapons
    local occupied_weight = 0
    ply:Horde_SetClass(class)
    ply:Horde_SetSubclass(name, subclass_name)
    if GetConVar("horde_enable_starter"):GetInt() == 1 and game_is_not_start then
        ply:StripAmmo()
        --ply:StripWeapons()

        for _, wpn in pairs(ply:GetWeapons()) do
            ply:StripWeapon(wpn:GetClass())
        end

        if ply.Horde_PlayerSpells then
            --PrintTable(ply.Horde_PlayerSpells)
            for i, spell_data in pairs(ply.Horde_PlayerSpells) do
                ply:Horde_SetSpellUpgrade(spell_data.ClassName, 0)
                ply:Horde_UnsetSpell(spell_data.ClassName)
            end
        end

        if ply.Horde_Upgrades then
            for wpnclass, data in pairs(ply.Horde_Upgrades) do
                ply:Horde_SetUpgrade(wpnclass, 0)
            end
        end
        ply:Horde_UnsetSpellWeapon()

        if !bugfix_spellers[subclass_name] then
            ply:Horde_SetGivenStarterWeapons(false)
            HORDE:GiveStarterWeapons(ply)
        else
            timer.Simple(0, function()
                ply:Give("hordeext_syringe")
                local wep = ply:GetWeapon("hordeext_syringe")
                if IsValid(wep) then
                    ply:SetAmmo(wep.StartAmmo or math.Round(HORDE:Ammo_GetMaxAmmo(wep) / 4 * 3), wep:GetPrimaryAmmoType())
                end
            end)
        end

        for _, wpn in pairs(ply:GetWeapons()) do
            occupied_weight = occupied_weight + HORDE.items[wpn:GetClass()].weight
        end

        if ply:Horde_GetSpellWeapon() or HORDE.class_withstartmoney[name] and HORDE.class_withstartmoney[name][subclass_name] or bugfix_spellers[subclass_name] then
            ply:Horde_SetMoney(HORDE:GetStartMoney(true))
        else
            ply:Horde_SetMoney(HORDE:GetStartMoney())
        end

        ply:SetArmor(0)
    else
		for _, wpn in pairs(ply:GetWeapons()) do
            local wpnclass = wpn:GetClass()
            if HORDE.items[wpnclass] and hook.Run("PlayerCanPickupWeapon", ply, wpn) == true then
                occupied_weight = occupied_weight + HORDE.items[wpnclass].weight
                continue
            end
            if IsValid(wpn) and !ply:CanDropWeapon(wpn) then
                ply:StripWeapon(wpnclass)
            else
                if wpn.ArcCW and wpn.Attachments then
                    for slot, v in pairs(wpn.Attachments) do
                        if v.Installed and !v.FreeSlot and !v.Hidden and !v.Integral then
                            wpn:Detach(slot, true)
                        end
                    end
                    ArcCW:PlayerSendAttInv(ply)
                end
                ply:DropWeapon(wpn)
            end
        end

        HORDE:GiveClassGrenades(ply)
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
        ply.RegularArmorLimit = nil
        ply.Horde_Special_Armor = nil
        ply:Horde_SetMaxArmor()
    end)
    
    
    if ply.Horde_Gadget and HORDE.items[ply.Horde_Gadget] and HORDE.items[ply.Horde_Gadget].whitelist and
    !HORDE.items[ply.Horde_Gadget].whitelist[name] then
        ply:Horde_AddMoney(math.floor(HORDE.items[ply.Horde_Gadget].price * .25))
        ply:Horde_UnsetGadget()
    end
    ply:SetMaxHealth(class.max_hp)
    net.Start("Horde_ToggleShop")
    net.Send(ply)

    HORDE:SendNotification("You changed class to " .. class.name, 0, ply)
    if GetConVar("horde_testing_unlimited_class_change"):GetInt() == 0 then
        HORDE.player_class_changed[ply:SteamID()] = true
    end

    ply:Horde_SyncEconomy()

    HORDE:TryAddTopTen(ply)
end)

net.Receive("Horde_BuyItemAmmoPrimary", function (len, ply)
    if not ply:IsValid() or not ply:Alive() then return end
    local class = net.ReadString()
    if hook.Run("CanBuyAmmoPrimary", ply, class) == false then return end
    if not ply:HasWeapon(class) then
        HORDE:SendNotification("You don't have this weapon!", 0, ply)
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
        if HORDE:GiveAmmo(ply, wpn, is_maxammo and HORDE:Ammo_GetTotalLimit(wpn) or 1) then
			ply:Horde_AddMoney(-price)
			ply:Horde_SyncEconomy()
            HORDE:Ammo_CheckForValidWorking(ply)
		end
    end
end)

net.Receive("Horde_BuyItemAmmoSecondary", function (len, ply)
    if not ply:IsValid() or not ply:Alive() then return end
    local class = net.ReadString()
    if hook.Run("CanBuyAmmoSecondary", ply, class) == false then return end
    if not ply:HasWeapon(class) then
        HORDE:SendNotification("You don't have this weapon!", 0, ply)
        return
    end

    local price = HORDE.items[class].secondary_ammo_price
    if ply:Horde_GetMoney() >= price then
        ply:Horde_AddMoney(-price)
        local wpn = ply:GetWeapon(class)
        local ammo_id = wpn:GetSecondaryAmmoType()
        local remain = HORDE:Ammo_RemainToFillAmmo_Secondary(wpn)
        if ammo_id >= 0 and remain > 0 then
            ply:GiveAmmo(math.min(remain, wpn.ArcCW and wpn:GetBuff_Override("UBGL_Capacity") or wpn.Secondary.ClipSize), ammo_id, false)
            ply:Horde_SyncEconomy()
        end
    end
end)

net.Receive("Horde_BuyItemUpgrade", function (len, ply)
    if not ply:IsValid() or not ply:Alive() then return end
    local class = net.ReadString()
    if hook.Run("CanBuyItemUpgrade", ply, class) == false then return end
    if not ply:HasWeapon(class) then
        HORDE:SendNotification("You don't have this weapon!")
        return
    end

    if ply:Horde_GetUpgrade(class) >= 10 then return end

    local price = HORDE:GetUpgradePrice(class, ply)
    if ply:Horde_GetMoney() >= price then
        ply:Horde_AddMoney(-price)
        local level = ply:Horde_GetUpgrade(class) + 1
        ply:Horde_SetUpgrade(class, level)
        ply:Horde_SyncEconomy()
        sound.Play("items/battery_pickup.wav", ply:GetPos())
        if class == "horde_pheropod" then
            ply:GetWeapon("horde_pheropod"):UpgradeReset()
        end
        local item = HORDE.items[class]
        if item and item.entity_properties.upgrade_modifiers then
            for modifier, mult in pairs(item.entity_properties.upgrade_modifiers) do
                HORDE:Modifier_AddToWeapon(ply, class, modifier, "ItemUpgrade", mult.base + mult.mult * level)
            end
        end
    end
end)

-------------------------> Cant buy anything before start game

--[[hook.Add("CanBuyItemUpgrade", "Horde_PrepareBuy", function(ply, class)
    HORDE:SendNotification("You Can't upgrade before start game!", 1, ply)
    return false
end)

hook.Add("CanBuyAmmoSecondary", "Horde_PrepareBuy", function(ply, class)
    HORDE:SendNotification("You Can't buy ammo before start game!", 1, ply)
    return false
end)

hook.Add("CanBuyAmmoPrimary", "Horde_PrepareBuy", function(ply, class)
    HORDE:SendNotification("You Can't buy ammo before start game!", 1, ply)
    return false
end)

hook.Add("CanBuyItem", "Horde_PrepareBuy", function(ply, class)
    HORDE:SendNotification("You Can't buy before start game!", 1, ply)
    return false
end)

hook.Add("CanSell", "Horde_PrepareBuy", function(ply, class)
    return false, "You Can't sell before start game!"
end)

hook.Add("Horde_PlayerDropMoney", "Horde_PrepareBuy", function(ply)
    HORDE:SendNotification("You Can't drop money before start game!", 1, ply)
    return true
end)


hook.Add("HordeWaveStart", "Horde_PrepareBuy", function(wave)
    hook.Remove("CanSell", "Horde_PrepareBuy")
    hook.Remove("CanBuyItem", "Horde_PrepareBuy")
    hook.Remove("CanBuyAmmoPrimary", "Horde_PrepareBuy")
    hook.Remove("CanBuyAmmoSecondary", "Horde_PrepareBuy")
    hook.Remove("CanBuyItemUpgrade", "Horde_PrepareBuy")
    hook.Remove("Horde_PlayerDropMoney", "Horde_PrepareBuy")
    hook.Remove("HordeWaveStart", "Horde_PrepareBuy")
end)]]

HORDE.start_money = 0

function HORDE:CanPickUpWeapon(ply, wpn)
    local wpn_class
    if isstring(wpn) then
        wpn_class = wpn
    else
        wpn_class = wpn:GetClass()
    end


    if not ply:IsValid() then return false end
    if ply:IsNPC() then return true end
    if HORDE.items[wpn_class] then
        local item = HORDE.items[wpn_class]
        if (ply:Horde_GetWeight() - item.weight < 0) then
            return false
        end
        if ply:Horde_GetCurrentSubclass() == "Gunslinger" and item.category == "Pistol" then return true end
        if (item.whitelist and (not item.whitelist[ply:Horde_GetClass().name])) then
            return false
        end
        
        if item.starter_classes then
            if (item.class == "horde_void_projector" and ply:Horde_GetCurrentSubclass() ~= "Necromancer") or
               (item.class == "horde_solar_seal" and ply:Horde_GetCurrentSubclass() ~= "Artificer") or
               (item.class == "horde_astral_relic" and ply:Horde_GetCurrentSubclass() ~= "Warlock") or
               (item.class == "horde_carcass" and ply:Horde_GetCurrentSubclass() ~= "Carcass") or
               (item.class == "horde_pheropod" and ply:Horde_GetCurrentSubclass() ~= "Hatcher") then
                return false
            end
        end

        if item.class ~= "weapon_hordeext_medkit" and item.class ~= "hordeext_syringe" and
           (ply:Horde_GetCurrentSubclass() == "Carcass" and item.class ~= "horde_carcass" or ply:Horde_GetSpellWeapon())
        then
            return false
        end
    end

    return true
end

-------------------------> Cant buy anything before start game

hook.Add("PlayerCanPickupWeapon", "Horde_Economy_Pickup", function (ply, wpn)
    return HORDE:CanPickUpWeapon(ply, wpn)
end)

local old_dropweapon = plymeta.DropWeapon

function plymeta:CanDropWeapon(wep)
    if wep.CantDropWep then return false end
    local wpn_class = wep:GetClass()
    local item = HORDE.items[wpn_class]
    if item and item.entity_properties.cantdropwep then
        return false
    end
    return true
end

function plymeta:DropWeapon(wep)
    wep = wep or self:GetActiveWeapon()
    if !IsValid(wep) or !self:CanDropWeapon(wep) then return end
    old_dropweapon(self, wep)
end
