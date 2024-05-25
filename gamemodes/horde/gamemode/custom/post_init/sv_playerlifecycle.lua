
-- Player Spawn Initialize
function HORDE:PlayerInit(ply)
    HORDE.current_players = player.GetAll()
    HORDE:LoadRank(ply)

    net.Start("Horde_SyncItems")
    local str = HORDE.GetCachedHordeItems()
    net.WriteUInt(string.len(str), 32)
        net.WriteData(str, string.len(str))
    net.Send(ply)

    net.Start("Horde_SyncClasses")
        net.WriteTable(HORDE.classes)
    net.Send(ply)

    net.Start("Horde_SyncDifficulty")
        net.WriteUInt(HORDE.difficulty,3)
    net.Send(ply)

    net.Start("Horde_SyncGameInfo")
        net.WriteUInt(HORDE.current_wave, 16)
    net.Send(ply)

    if HORDE.disable_levels_restrictions == 1 then
        net.Start("Horde_Disable_Levels")
        net.Send(ply)
    end
    if not HORDE.start_game then
        HORDE.player_ready[ply] = 0
        net.Start("Horde_PlayerReadySync")
            net.WriteTable(HORDE.player_ready)
        net.Broadcast()
    end

    ply:Horde_SetMaxWeight(HORDE.max_weight)
    ply:Horde_SetWeight(ply:Horde_GetMaxWeight())
    if ply:Alive() and not (HORDE.start_game and HORDE.current_break_time <= 0) then
        HORDE:GiveStarterWeapons(ply)
    end

    if HORDE.start_game then
        net.Start("Horde_RemoveReadyPanel")
        net.Send(ply)
        if HORDE.player_money_wave[ply:SteamID()] and HORDE.player_money[ply:SteamID()] and HORDE.player_money_wave[ply:SteamID()] == HORDE.current_wave then
            -- Already provided social welfare.
            ply:Horde_SetMoney(HORDE.player_money[ply:SteamID()])
        else
            ply:Horde_SetMoney(HORDE:GetStartMoney() + math.max(0, HORDE.current_wave - 1) * 150)
        end
        HORDE:LoadSkullTokens(ply)
        if HORDE.horde_boss and HORDE.horde_boss:IsValid() and HORDE.horde_boss_name then
            net.Start("Horde_SyncBossSpawned")
                net.WriteString(HORDE.horde_boss_name)
                net.WriteInt(HORDE.horde_boss:GetMaxHealth(),32)
                net.WriteInt(HORDE.horde_boss:Health(),32)
            net.Send(ply)
        end

        local tip = HORDE:GetTip()
        if tip and (not HORDE.horde_boss) then
            net.Start("Horde_SyncTip")
                net.WriteString(HORDE:GetTip())
            net.Send(ply)
        end

        if HORDE.horde_active_holdzones then
            for id, zone in pairs(HORDE.horde_active_holdzones) do
                net.Start("Horde_SyncHoldLocation")
                net.WriteUInt(zone.Horde_Zone_Id, 4)
                net.WriteVector(zone:GetPos())
                net.WriteVector(zone:OBBMins())
                net.WriteVector(zone:OBBMaxs())
                net.Send(ply)
            end

            net.Start("Horde_RenderObjectives")
            net.WriteUInt(HORDE.finished_objs, 4)
            net.WriteUInt(HORDE.max_objs, 4)
            net.Send(ply)
        end

        if HORDE.horde_active_escapezones then
            for id, zone in pairs(HORDE.horde_active_escapezones) do
                net.Start("Horde_SyncEscapeLocation")
                net.WriteUInt(zone.Horde_Zone_Id, 4)
                net.WriteVector(zone:GetPos())
                net.WriteVector(zone:OBBMins())
                net.WriteVector(zone:OBBMaxs())
                net.Send(ply)
            end
            net.Start("Horde_RenderObjectives")
            net.WriteUInt(HORDE.finished_objs, 4)
            net.WriteUInt(HORDE.max_objs, 4)
            net.Send(ply)
        end

        if HORDE.horde_active_payload_spawns then
            for id, spawn in pairs(HORDE.horde_active_payload_spawns) do
                net.Start("Horde_SyncPayloadLocation")
                net.WriteUInt(spawn.Horde_Payload_Spawn_Id, 4)
                net.WriteVector(spawn:GetPos())
                net.Send(ply)

                net.Start("Horde_SyncPayloadIcon")
                net.WriteUInt(spawn.Horde_Payload_Spawn_Id, 4)
                net.WriteUInt(spawn.Horde_Payload_Icon, 4)
                net.Send(ply)
            end
            net.Start("Horde_SyncEscapeStart")
            net.Send(ply)
        end

        if HORDE.horde_active_payload_destinations then
            for id, dest in pairs(HORDE.horde_active_payload_destinations) do
                net.Start("Horde_SyncPayloadDestinationLocation")
                net.WriteUInt(dest.Horde_Payload_Destination_Id, 4)
                net.WriteVector(dest:GetPos())
                net.WriteVector(dest:OBBMins())
                net.WriteVector(dest:OBBMaxs())
                net.Send(ply)
            end
        end
    else
        if HORDE.player_money[ply:SteamID()] then
            ply:Horde_SetMoney(HORDE.player_money[ply:SteamID()])
        else
            local class_name = ply:Horde_GetClass().name
            local subclass_name = ply:Horde_GetSubclass(ply:Horde_GetClass().name)
            ply:Horde_SetMoney(HORDE:GetStartMoney(ply:Horde_GetSpellWeapon() or HORDE.class_withstartmoney[class_name] and HORDE.class_withstartmoney[class_name][subclass_name]))
        end
        HORDE:LoadSkullTokens(ply)
    end
    ply:Horde_SetDropEntities({})
    if not ply:Horde_GetClass() then
        ply:Horde_SetClass(HORDE.classes[HORDE.Class_Survivor])
    end

    timer.Simple(0.1, function()
        ply:Horde_SetMaxArmor()
    end)

    hook.Run("Horde_ResetStatus", ply)
    -- Misc stuff
    ply.Horde_Spectre_Max_Count = 1
    ply:Horde_ApplyPerksForClass()
    HORDE.player_class_changed[ply:SteamID()] = false
    ply:Horde_SyncEconomy()

    ply.Horde_Status = {}
    ply:PrintMessage(HUD_PRINTTALK, "Use '!help' to see special commands!")

    ply:Horde_SyncExp()
    for _, other_ply in pairs(player.GetAll()) do
        if other_ply == ply then goto cont end
        local subclass = other_ply:Horde_GetCurrentSubclass()
        if not subclass then goto cont end
        net.Start("Horde_SyncExp")
            net.WriteEntity(other_ply)
            net.WriteString(subclass)
            net.WriteUInt(other_ply:Horde_GetExp(subclass), 32)
            net.WriteUInt(other_ply:Horde_GetLevel(subclass), 8)
        net.Send(ply)

        net.Start("Horde_SyncPerk")
            net.WriteEntity(other_ply)
            net.WriteTable(other_ply.Horde_PerkChoices[subclass])
        net.Send(ply)
        ::cont::
    end
    net.Start("Horde_SyncClientExps")
    net.Send(ply)

    if GetConVar("horde_enable_sandbox"):GetInt() == 1 then
        net.Start("Horde_SyncStatus")
            net.WriteUInt(HORDE.Status_ExpDisabled, 8)
            net.WriteUInt(1, 8)
        net.Send(ply)
    end

    ply.Horde_Init_Complete = true
    local added = HORDE:TryAddTopTen(ply)
    if not added then
        net.Start("Horde_SyncTopTen")
            net.WriteString(util.TableToJSON(HORDE.top_tens))
        net.Broadcast()
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

    for _, ply2 in pairs(player.GetAll()) do
        if not IsValid(ply2) or ply2 == ply then continue end
        if not ply2.Horde_money or not ply2.Horde_weight or not ply2.Horde_class then continue end
        net.Start("Horde_SyncEconomy")
            net.WriteEntity(ply2)
            net.WriteInt(ply2.Horde_money, 32)
            net.WriteInt(ply2.Horde_skull_tokens, 32)
            net.WriteInt(ply2.Horde_weight, 32)
            net.WriteString(ply2:Horde_GetSubclass(ply2.Horde_class.name))
            net.WriteTable(ply2.Horde_drop_entities)
        net.Send(ply)
    end

    if HORDE.start_game then return end

    local ready_count = 0
    local total_player = 0
    for _, other_ply in pairs(player.GetAll()) do
        if HORDE.player_ready[other_ply] == 1 then
            ready_count = ready_count + 1
        end
        total_player = total_player + 1
    end
    
    if total_player > 0 and total_player == ready_count then
        HORDE.start_game = true
    end

    HORDE:BroadcastPlayersReadyMessage(tostring(ready_count) .. "/" .. tostring(total_player))
end

function HORDE:GiveStarterWeapons(ply)
    if GetConVar("horde_enable_starter"):GetInt() == 0 then return end
    local weapons_gotted = {}
    if ply:Alive() and (not ply:Horde_GetGivenStarterWeapons()) then
        if HORDE.starter_weapons[ply:Horde_GetCurrentSubclass()] then
            for _, wpn_class in pairs(HORDE.starter_weapons[ply:Horde_GetCurrentSubclass()]) do
                ply:Give(wpn_class)
                table.insert(weapons_gotted, wpn_class)
            end
        end

        ply:Horde_SetGivenStarterWeapons(true)
    end

    local yourclass = ply:Horde_GetClass().name
    if yourclass == HORDE.Class_Survivor then
        local wpns_class = table.Copy(HORDE.starter_weapons)
        wpns_class["All"] = nil
        wpns_class = table.ClearKeys(wpns_class)
        local isgived = false

        while !isgived and !table.IsEmpty(wpns_class) do
            local dropped = math.random(#wpns_class)

            local weps = wpns_class[dropped]
            if weps then
                for _, wpn_class in pairs(weps) do
                    local item = HORDE.items[wpn_class]
                    if item and item.whitelist[yourclass] then
                        ply:Give(wpn_class)
                        table.insert(weapons_gotted, wpn_class)
                        isgived = true
                    end
                end

                if !isgived then
                    wpns_class[dropped] = nil
                end
            end
        end
    end

    if HORDE.starter_weapons["All"] then
        for _, wpn_class in pairs(HORDE.starter_weapons["All"]) do
            ply:Give(wpn_class)
        end
    end

    HORDE:GiveClassGrenades(ply)

    ply:SetAmmo(75, "ammo_starterweapon")

    if !table.IsEmpty(weapons_gotted) then
        timer.Simple(0, function()
            for _, wpn_class in pairs(weapons_gotted) do
                local wep = ply:GetWeapon(wpn_class)
                if IsValid(wep) then
                    ply:SetAmmo(wep.StartAmmo or math.Round(HORDE:Ammo_GetMaxAmmo(wep) / 4 * 3), wep:GetPrimaryAmmoType())
                end
            end
        end)
    end
end

hook.Add("Move", "Horde_PlayerMove", function (ply, mv)
    if ply:Horde_GetClass() then
        ply:SetJumpPower(150)
        local bonus_walk = {more = 1, increase = 0}
        local bonus_run = {more = 1, increase = 0}
        hook.Run("Horde_PlayerMoveBonus", ply, bonus_walk, bonus_run)
        ply:SetWalkSpeed(140 * bonus_walk.more * (1 + bonus_walk.increase)) -- default - 140
        ply:SetRunSpeed(175 * bonus_run.more * (1 + bonus_run.increase)) -- default - 220
    end
end)

hook.Add("DoPlayerDeath", "Horde_DoPlayerDeath", function(victim)
    net.Start("Horde_ClearStatus")
    net.Send(victim)
    for _, wpn in pairs(victim:GetWeapons()) do
        if IsValid(wpn) and !victim:CanDropWeapon(wpn) then
            victim:StripWeapon(wpn:GetClass())
        else
            victim:DropWeapon(wpn)
        end
    end
    if (not HORDE.start_game) or (HORDE.current_break_time > 0) then
        timer.Simple(1, function() if victim:IsValid() then
            victim:Spawn()
        end end)
        return
    end
    HORDE:SendNotification("You are dead. You will respawn next wave.", 1, victim)
    HORDE:CheckAlivePlayers()

    local tip = HORDE:GetTip()
    if tip and (not HORDE.horde_boss) then
        net.Start("Horde_SyncTip")
            net.WriteString(HORDE:GetTip())
        net.Send(victim)
    end
end)
