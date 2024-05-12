local waves_type = GetConVar("horde_waves_type"):GetInt()

HORDE.wavestype_startmoneybonus = {
    [1] = 1,
    [2] = 1.15,
    [3] = 1.25,
}

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