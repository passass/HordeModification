net.Receive("Horde_SlowHeal_Proceed", function()
    local ply = net.ReadEntity()
    ply.Horde_HealHPRemain_Max = net.ReadInt(10)
end)


--[[net.Receive("Horde_SlowHeal_Proceed", function()
    local timer_obj
    local ply = net.ReadEntity()
    local remainhp, health
    local maxhealth = net.ReadInt(9)
    local lastmaxhealth = ply.Horde_HealLastMaxHealth
    ply.Horde_HealHPRemain = net.ReadInt(8)
    local delay = net.ReadFloat()
    if !ply.Horde_HealTimer or !ply.Horde_HealTimer:IsValid() then
        timer_obj = HORDE.Timers:New({
            linkwithent = ply,
            ResetStats = function()
                timer_obj.delay = timer_obj.vars_on_init.delay
                ply.Horde_HealLastMaxHealth = nil
                ply.Horde_HealHPRemain = 0
            end,
            timername = "Horde_" .. ply:EntIndex() .. "SlowlyHeal",
            func = function(timerobj)
                remainhp = ply.Horde_HealHPRemain
                if IsValid(ply) and remainhp and remainhp >= 1 then
                    health = ply:Health()
                    if health < ply.Horde_HealLastMaxHealth then
                        ply.Horde_HealHPRemain = remainhp - 1
                        return
                    end
                end
                timerobj:Stop()
                timerobj.ResetStats()
            end,
            callfunconstart = true,
            delay = .11
        })
        ply.Horde_HealTimer = timer_obj
    else
        timer_obj = ply.Horde_HealTimer
    end

    local is_update_timer = false

    if !lastmaxhealth or lastmaxhealth < maxhealth then
        ply.Horde_HealLastMaxHealth = maxhealth
        is_update_timer = true
    end

    if delay < timer_obj.delay then
        timer_obj:SetDelay(delay)
        is_update_timer = true
    end

    if is_update_timer or !timer_obj:TimerExists() or timer_obj:IsStopped() then
        timer_obj:UpdateTimer()
    end
end)

net.Receive("Horde_SlowHeal_Stop", function()

    local ply = net.ReadEntity()
    if ply.Horde_HealTimer then
        ply.Horde_HealTimer:Stop()
    end
end)
]]