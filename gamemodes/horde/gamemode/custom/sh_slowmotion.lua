if GetConVar("horde_enable_slomo"):GetInt() == 0 then return end

function HORDE.SlowMotion_GetCompletenessSlomo(slow_motion_stage)
    return (1 - slow_motion_stage) * 1.5
end

local formulas = {
    static = function(slow_motion_stage, slomo_bonus) return slomo_bonus + 1 end,
    static_inverted = function(slow_motion_stage, slomo_bonus) return 1 / (slomo_bonus + 1) end,
    completeness = function(slow_motion_stage, slomo_bonus) return 1 + HORDE.SlowMotion_GetCompletenessSlomo(slow_motion_stage) * slomo_bonus end,
    completeness_inverted = function(slow_motion_stage, slomo_bonus) return 1 / (1 + HORDE.SlowMotion_GetCompletenessSlomo(slow_motion_stage) * slomo_bonus) end,
}

hook.Add("PlayerSay", "TEST", function(ply, input, public)
    if not ply:IsValid() then return end
    local text = {}

    for str in string.gmatch(string.lower(input), "([^".."%s".."]+)") do -- splits and lowercases the input string
       table.insert(text, str)
    end

    if text[1] == "!slomo" then
        HORDE.SlowMotion_Start()
    end
end)

--[[hook.Add("Think", "Test23231", function()
    local ply = player.GetAll()[1]
    if !IsValid(ply) then return end
    local wep = ply:GetActiveWeapon()
    if !IsValid(wep) then return end
    print(ply:GetViewModel():GetCycle())
end)]]

local bonus_hooks = {
    SlowMotion_ZoomSpeedBonus = {"Mult_SightTime", formulas.completeness_inverted},
    SlowMotion_MeleeAttackSpeedBonus = {"Mult_MeleeTime", formulas.completeness_inverted},
    SlowMotion_ReloadBonus = {"Mult_ReloadTime", formulas.completeness_inverted, function(ply, slomo_stage, slomo_bonus)
        local hookname = "Horde_SlowMotion_ReloadBonus_" .. ply:EntIndex()
        if !hook.GetTable()["Think"][hookname] then
            hook.Add("Think", hookname, function()
                local wep = ply:GetActiveWeapon()
                if !IsValid(wep) or !wep.ArcCW then return end
                if wep:GetReloading() then
            
                    local mult = 1 / wep:GetBuff_Mult("Mult_ReloadTime") --> 0
            
                    if wep.LastRes != mult then
            
                        local shouldshotgunreload = wep:GetBuff_Override("Override_ShotgunReload")
                        local shouldhybridreload = wep:GetBuff_Override("Override_HybridReload")
            
                        if shouldshotgunreload == nil then shouldshotgunreload = wep.ShotgunReload end
                        if shouldhybridreload == nil then shouldhybridreload = wep.HybridReload end
            
                        if shouldhybridreload then
                            shouldshotgunreload = wep:Clip1() != 0
                        end
            
                        if shouldshotgunreload then
                            if wep:GetShotgunReloading() > 0 then return end
                        else
                            local ct = CurTime()
                            local start_reload = wep.LastAnimStartTime
                            local anim = wep.LastAnimKey
                            local vm = wep.REAL_VM--ply:GetViewModel()
                            local vm_animdur = vm:SequenceDuration()


                            if !wep.LastRes then
                                wep.LastRes = mult
                            end
                            if !wep.LastAnimPrcd then
                                wep.LastAnimPrcd = start_reload
                            end

                            local dur = wep:GetAnimKeyTime(anim)
                            local dur_minprg = wep:GetAnimKeyTime(anim, true)
            
                            local anim_progress = math.Clamp((wep.LastAnimPrg or 0) + (ct - wep.LastAnimPrcd) * wep.LastRes / dur, 0, 1)
                            wep.LastAnimPrg = anim_progress

                            --if game.SinglePlayer() then
                            local anim_rate = mult * (vm_animdur / dur)
                            vm:SetPlaybackRate(anim_rate)
                            

                            --wep.LastAnimStartTime = wep.LastAnimStartTime - skip_on
                            --wep.LastAnimFinishTime = ct + vm_animdur / anim_rate * (1 - anim_progress)
                                
                            --if CLIENT then
                                --vm:SetAnimTime(ct - vm_animdur / anim_rate * anim_progress)
                                --wep:SetAnimTime(ct - vm_animdur / anim_rate * anim_progress)
                                --ply:SetAnimTime(ct - vm_animdur / anim_rate * anim_progress)
                                --vm:SetAnimTime(ct)
                            --end
                            --end
                            local anim_timetoend = dur / mult * (1 - anim_progress)
        
                            local reloadtime = dur_minprg / mult * (1 - anim_progress * (dur / dur_minprg))
                            local reloadtime2
                            if !wep.Animations[anim].ForceEnd then
                                reloadtime2 = anim_timetoend
                            else
                                reloadtime2 = reloadtime
                            end
                            wep:SetReloadingREAL(ct + reloadtime2)
                            wep:SetNextPrimaryFire(ct + reloadtime2)
                            wep:SetMagUpIn(ct + reloadtime)
                            wep:SetNextIdle(ct + anim_timetoend)

            
                            for i, sounds in ipairs(wep.EventTable) do
                                for time, key in pairs(sounds) do
                                    if key.AnimKey == anim then
                                        local sound_delay = (time - key.StartTime) / mult * (key.StartTimeLastMult or wep.LastRes)
                
                                        time2 = key.StartTime + sound_delay
                                        if !wep.EventTable[i][time2] then
                                            wep.EventTable[i][time2] = table.Copy(key)
                                            wep.EventTable[i][time] = nil
                                        end
                                        key.StartTimeLastMult = mult
                                    end
                                end
                            end

                            wep.LastRes = mult
                            wep.LastAnimPrcd = ct
                        end
                    end
                else
                    wep.LastRes = nil
                    wep.LastAnimPrg = nil
                    wep.LastAnimPrcd = nil
                end
            end)
        end

        if slomo_stage == 1.0 then
            hook.Remove("Think", hookname)
            

            for _, wep in pairs(ply:GetWeapons()) do
                wep.LastRes = nil
                wep.LastAnimPrg = nil
                wep.LastAnimPrcd = nil
            end

            local wep = ply:GetActiveWeapon()
            if IsValid(wep) and wep.ArcCW  then
                local mult = 1 / wep:GetBuff_Mult("Mult_ReloadTime")

                for i, sounds in ipairs(wep.EventTable) do
                    for time, key in pairs(sounds) do
                        if key.AnimKey == anim then
                            local sound_delay = (time - key.StartTime) / mult * (key.StartTimeLastMult or wep.LastRes)
    
                            time2 = key.StartTime + sound_delay
                            if !wep.EventTable[i][time2] then
                                wep.EventTable[i][time2] = table.Copy(key)
                                wep.EventTable[i][time] = nil
                            end
                            key.StartTimeLastMult = mult
                        end
                    end
                end
            end

            
        end
    end},
    SlowMotion_RPMBonus = {"Mult_RPM", formulas.completeness},
    SlowMotion_CycleTimeMult = {"Mult_CycleTime", formulas.static_inverted},
}

hook.Add("Horde_PlayerMoveBonus", "Horde_SlowMotion_SpeedBonus", function(ply, bonus_walk, bonus_run)
	local stage = HORDE:SlowMotion_GetStage()
    if stage == 1 then return end

	if !ply:Horde_CallClassHook("SlowMotion_MovementSpeedBonus_Allow", ply) then return end
	
	local slomo_bonus = ply:Horde_GetPerkLevelBonus("slomo_bonus")
    if not slomo_bonus or slomo_bonus <= 0 then return end
	
    local bonus_speed = formulas.completeness(stage, slomo_bonus)
    bonus_walk.more = bonus_walk.more * bonus_speed
    bonus_run.more = bonus_run.more * bonus_speed
end)

--[[local vm = self:GetOwner():GetViewModel()
    vm:SetPlaybackRate(math.Clamp(dur / (ttime + startfrom), -4, 12))]]

local function call_all_bonus_hooks(ply, slow_motion_stage, slomo_bonus)
    for hookname, bonushook in pairs(bonus_hooks) do
        if !ply:Horde_CallClassHook(hookname .. "_Allow", ply) then continue end

        if bonushook[3] and bonushook[3](ply, slow_motion_stage, slomo_bonus) then continue end

        if slow_motion_stage == 1.0 then
            HORDE:Modifier_AddToWeapons(ply, bonushook[1], "slomotion")
            continue
        end
        HORDE:Modifier_AddToWeapons(ply, bonushook[1], "slomotion", bonushook[2](slow_motion_stage, slomo_bonus))
    end

    ply:Horde_CallClassHook("SlowMotion_Hook", ply, slow_motion_stage, slomo_bonus)

    for _, wep in pairs(ply:GetWeapons()) do
        if wep.SlowMotion_Hook then
            wep:SlowMotion_Hook(slow_motion_stage, slomo_bonus)
        end
    end
end

hook.Add("Horde_SlowMotion_start_Bonus", "Horde_SlowMotion_CalculateBonuses", call_all_bonus_hooks)
hook.Add("Horde_SlowMotion_end_Bonus", "Horde_SlowMotion_CalculateBonuses", call_all_bonus_hooks)


--                 TEMPLATES

if CLIENT then
    local start_time, end_time = 0, 0
    local is_end = false
    local stage = 1.0

    function HORDE:SlowMotion_GetStage()
        return stage
    end

    function HORDE:SlowMotion_IsEnding()
        return is_end
    end
    
    net.Receive("Horde_SyncSlowmotionChange", function()
        stage = net.ReadFloat()
        local bonus = net.ReadFloat()
		local lp = LocalPlayer()
        hook.Run("Horde_SlowMotion_" .. (is_end and "end" or "start") .. "_Bonus", lp, stage, bonus)
    end)

    net.Receive("Horde_SlowMotion", function()
		if end_time != 0 then 
			start_time = 0
		end
        end_time = 0
		is_end = net.ReadBool()
        if !is_end then
            if start_time == 0 then
				start_time = CurTime()
			end
        else
            end_time = CurTime() + .65
        end
        surface.PlaySound("horde/slomo_" .. (is_end and "out" or "in") .. ".wav")
        hook.Add("RenderScreenspaceEffects", "Horde_Draw_SlowMotion", function()
            if end_time != 0 and end_time < CurTime() then
                start_time, end_time, is_end = 0, 0, false
                hook.Remove("RenderScreenspaceEffects", "Horde_Draw_SlowMotion")
                return
            end
            local stage = Lerp(end_time == 0 and ((CurTime() - start_time) / 1.3) or ((end_time - CurTime()) / .75), 0, 1)
            DrawColorModify( {
                ["$pp_colour_addr"] = 0,
                ["$pp_colour_addg"] = 0,
                ["$pp_colour_addb"] = 0,
                ["$pp_colour_brightness"] = 0,
                ["$pp_colour_contrast"] = 1,
                ["$pp_colour_colour"] = 1 - 1 * stage,
                ["$pp_colour_mulr"] = stage * 3,
                ["$pp_colour_mulg"] = 0,
                ["$pp_colour_mulb"] = 0
            } )
            --DrawSobel( 0 ) --Draws Sobel effect
        end )
    end)
    function HORDE:SlowMotion_GetStage()
        return stage
    end
    return
end
util.AddNetworkString("Horde_SyncSlowmotionChange")
util.AddNetworkString("Horde_Slowmotion")

local max_slow_time = 1 / 3
local timers_delay = .05
local times_to_end = 6 / (timers_delay * 10)
local cur_slowmotion = 1.0
local one_time = (1 - max_slow_time) / (6 / (timers_delay * 10))
local slow_motion_duration = 3.3 * max_slow_time
local slow_motion_happened = 0
local slow_motion_end_happened = 0

local is_ending = false

function HORDE:SlowMotion_GetStage()
    return cur_slowmotion
end

function HORDE:SlowMotion_IsEnding()
    return is_ending
end

local function PlaySlowMotionSound(is_end)
    is_ending = is_end
    net.Start("Horde_Slowmotion")
    net.WriteBool(is_end)
    net.Broadcast()
end

function HORDE:SlowMotion_IsProcessing()
    return cur_slowmotion != 1
end

local funcs = {}
local last_player_called_slowmotion = NULL
local last_player_called_count = 0
local last_slowmotion_called_timing = 0

function funcs.CreateTimedFunc(name, func)
    if cur_slowmotion <= max_slow_time then
        cur_slowmotion = max_slow_time
    end
    timer.Create(name, timers_delay * cur_slowmotion, 1, func)
end

local function SyncSlowMotionStage(bonus)
    net.Start("Horde_SyncSlowmotionChange")
    net.WriteFloat(cur_slowmotion)
    net.WriteFloat(bonus)
    net.Broadcast()
end

local function setup_bonuses(slomo_stage)
    for _, ply in pairs(player.GetAll()) do
        local bonus = ply:Horde_GetPerkLevelBonus("slomo_bonus") or 0
		--if !bonus or bonus <= 0 then continue end
        SyncSlowMotionStage(bonus)
        hook.Run("Horde_SlowMotion_" .. (is_end and "end" or "start") .. "_Bonus", ply, cur_slowmotion, bonus)
    end
end

hook.Add("Horde_SlowMotion_start", "setup_bonuses", setup_bonuses)

hook.Add("Horde_SlowMotion_end", "setup_bonuses", setup_bonuses)

function funcs.Make_Slowing()
    slow_motion_happened = slow_motion_happened + 1
    game.SetTimeScale(cur_slowmotion)
    if slow_motion_happened == times_to_end then
        slow_motion_happened = times_to_end
        cur_slowmotion = max_slow_time
        game.SetTimeScale(max_slow_time)
    else
        cur_slowmotion = cur_slowmotion - one_time
        funcs.CreateTimedFunc("Horde_SlowMotion_start", funcs.Make_Slowing)
    end
    hook.Call("Horde_SlowMotion_start", nil, cur_slowmotion)
end

function funcs.Make_Faster()
    slow_motion_end_happened = slow_motion_end_happened + 1
    if slow_motion_end_happened == times_to_end then
        last_player_called_slowmotion = NULL
        last_player_called_count = 0
        slow_motion_end_happened = 0
        slow_motion_happened = 0
        cur_slowmotion = 1.0
    else
        cur_slowmotion = cur_slowmotion + one_time
        funcs.CreateTimedFunc("Horde_SlowMotion_end_2", funcs.Make_Faster)
    end
    hook.Call("Horde_SlowMotion_end", nil, cur_slowmotion)
    game.SetTimeScale(cur_slowmotion)
end

function HORDE.SlowMotion_isprocessing()
    return last_player_called_slowmotion != NULL or cur_slowmotion != 1
end

function HORDE.SlowMotion_end()
    PlaySlowMotionSound(true)
    funcs.CreateTimedFunc("Horde_SlowMotion_end_2", funcs.Make_Faster)
end

function HORDE.SlowMotion_Start()
    if slow_motion_end_happened != 0 then
        slow_motion_happened = times_to_end - slow_motion_end_happened
        cur_slowmotion = 1 - one_time * slow_motion_happened
        slow_motion_end_happened = 0
    end
    PlaySlowMotionSound(false)
    if !timer.Exists("Horde_SlowMotion_start") and slow_motion_happened != times_to_end then
        funcs.CreateTimedFunc("Horde_SlowMotion_start", funcs.Make_Slowing)
    end
    timer.Remove("Horde_SlowMotion_end_2")
    timer.Create("Horde_SlowMotion_end", slow_motion_duration, 1, function()
        PlaySlowMotionSound(true)
        funcs.CreateTimedFunc("Horde_SlowMotion_end_2", funcs.Make_Faster)
    end)
end

hook.Add("Horde_OnEnemyKilled", "StartSlowMotion", function(victim, killer, inflictor)
    if IsValid(inflictor) and inflictor:IsNPC() or CurTime() == last_slowmotion_called_timing then return end
    if last_player_called_slowmotion == NULL and
	math.random() > .05 or
    last_player_called_slowmotion != NULL and
	(killer != last_player_called_slowmotion or last_player_called_count >= (killer:Horde_GetPerk("assault_base") and 5 or 3)) or
        hook.Run("Horde_CanSlowTime")
    then return end
    last_player_called_slowmotion = killer
    last_player_called_count = last_player_called_count + 1
	last_slowmotion_called_timing = CurTime()
    HORDE.SlowMotion_Start()
end)