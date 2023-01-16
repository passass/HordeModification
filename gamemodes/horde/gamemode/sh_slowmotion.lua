if GetConVar("horde_enable_slomo"):GetInt() == 0 then return end

HORDE.SlowMotion_MovementSpeedBonus = function(ply, bonus_walk, bonus_run)
	local stage = HORDE:SlowMotion_GetStage()
    if stage == 1 then return end

	if !hook.Run("SlowMotion_MovementSpeedBonus_Allow", ply) then return end
	
	local slomo_bonus = ply:Horde_GetPerkLevelBonus("slomo_bonus")
    if not slomo_bonus or slomo_bonus <= 0 then return end
	
    local bonus_speed = 1 + slomo_bonus * (1 / stage / 3)
    bonus_walk.more = bonus_walk.more * bonus_speed
    bonus_run.more = bonus_run.more * bonus_speed
end

hook.Add("Horde_PlayerMoveBonus", "Horde_SlowMotion_SpeedBonus", HORDE.SlowMotion_MovementSpeedBonus)

HORDE.SlowMotion_RPMBonus = function(ply, slow_motion_stage, slomo_bonus)
	if !hook.Run("SlowMotion_RPMBonus_Allow", ply) then return end

    if not slomo_bonus or slomo_bonus <= 0 then return end
	
	if slow_motion_stage == 1.0 then
		HORDE:Modifier_AddToWeapons(ply, "Mult_RPM", "slomotion")
		return
	end
	
	local mult_rpm = 1 + (1 / slow_motion_stage / 3) * slomo_bonus
    HORDE:Modifier_AddToWeapons(ply, "Mult_RPM", "slomotion", mult_rpm)
end

HORDE.SlowMotion_ReloadBonus = function(ply, slow_motion_stage, slomo_bonus)
	if !hook.Run("SlowMotion_ReloadBonus_Allow", ply) then return end

	if not slomo_bonus or slomo_bonus <= 0 then return end

	if slow_motion_stage == 1.0 then
		HORDE:Modifier_AddToWeapons(ply, "Mult_ReloadTime", "slomotion")
		return
	end
    HORDE:Modifier_AddToWeapons(ply, "Mult_ReloadTime", "slomotion", 1 / (slomo_bonus + 1))
end

HORDE.SlowMotion_MeleeAttackSpeedBonus = function(ply, slow_motion_stage, slomo_bonus)
	if !hook.Run("SlowMotion_MeleeAttackSpeedBonus_Allow", ply) then return end
	
	if not slomo_bonus or slomo_bonus <= 0 then return end
	
	if slow_motion_stage == 1.0 then
		HORDE:Modifier_AddToWeapons(ply, "Mult_MeleeTime", "slomotion")
		return
	end
	HORDE:Modifier_AddToWeapons(ply, "Mult_MeleeTime", "slomotion", 1 / Lerp((slomo_bonus / 2) * (1 / slow_motion_stage / 3), 1, 3))
end

local function call_all_bonus_hooks(ply, slow_motion_stage, slomo_bonus)
	HORDE.SlowMotion_MeleeAttackSpeedBonus(ply, slow_motion_stage, slomo_bonus)
	HORDE.SlowMotion_ReloadBonus(ply, slow_motion_stage, slomo_bonus)
	HORDE.SlowMotion_RPMBonus(ply, slow_motion_stage, slomo_bonus)
end

hook.Add("Horde_SlowMotion_start_Bonus", "Horde_SlowMotion_CalculateBonuses", call_all_bonus_hooks)
hook.Add("Horde_SlowMotion_end_Bonus", "Horde_SlowMotion_CalculateBonuses", call_all_bonus_hooks)


--                 TEMPLATES

if CLIENT then
    local start_time, end_time = 0, 0
    local is_end = false
    local stage = 1.0
    net.Receive("Horde_SyncSlowmotionChange", function()
        stage = net.ReadFloat()
        local bonus = net.ReadFloat()
		local lp = LocalPlayer()
		--Horde_SlowMotion_start_Bonus
        --hook.Run("Horde_SlowMotion_" .. (is_end and "end" or "start"), lp, stage, bonus)
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
local slow_motion_duration = 4 * max_slow_time
local slow_motion_happened = 0
local slow_motion_end_happened = 0

function HORDE:SlowMotion_GetStage()
    return cur_slowmotion
end

local function PlaySlowMotionSound(is_end)
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
        local bonus = ply:Horde_GetPerkLevelBonus("slomo_bonus")
		if !bonus or bonus <= 0 then continue end
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

hook.Add("Horde_OnNPCKilled", "StartSlowMotion", function(victim, killer, inflictor)
    if inflictor:IsNPC() or CurTime() == last_slowmotion_called_timing then return end
    if last_player_called_slowmotion == NULL and
	math.random() > 0.08 or last_player_called_slowmotion != NULL and
	(killer != last_player_called_slowmotion or last_player_called_count >= (killer:Horde_GetPerk("assault_base") and 5 or 3)) and
        !hook.Run("Horde_CanSlowTime")
    then return end
    last_player_called_slowmotion = killer
    last_player_called_count = last_player_called_count + 1
	last_slowmotion_called_timing = CurTime()
    HORDE.SlowMotion_Start()
end)