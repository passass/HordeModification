HORDE.Timers = {}
HORDE.Timers.alltimers = {}
HORDE.Timers.__index = HORDE.Timers

function HORDE.Timers:Find(timername)
    return HORDE.Timers.alltimers[timername]
end

function HORDE.Timers:New(o, start_enabled)
    -- o include timername, delay, repetitions, func
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.vars_on_init = table.Copy(o)
    o.bypasses = 0
    --self.isproceed = false -- not implemented
    o.stopped = false
    o.removed = false

    if !o.repetitions then
        o.repetitions = 0
    end
    o.repetitions_enough = o.repetitions

    if o.linkwithent then
        o.linkwithent:CallOnRemove( "Horde_timer_" .. o.timername, function() o:Remove() end)
    end

    if start_enabled then
        o:StartTimer()
    end

    HORDE.Timers.alltimers[o.timername] = o
    return o
end

function HORDE.Timers:CallFunc()
    self:func()
    self.bypasses = self.bypasses + 1
    if self.repetitions != 0 then
        self.repetitions_enough = self.repetitions_enough - 1
    end
end

function HORDE.Timers:StartTimer(NoCallFuncAndChangeReps)
    if !NoCallFuncAndChangeReps then
        if self.callfunconstart then
            self:CallFunc()
        end
        self.repetitions_enough = self.repetitions
    end
    if self.repetitions != 0 and self.repetitions_enough == 0 then
        if self.OnTimerRepetitionsFinish then
            self:OnTimerRepetitionsFinish()
        end
        return
    end
    local delay = self.delay

    if self:IsValid() then
        timer.Create(self.timername, delay, self.repetitions_enough, function()
            self:CallFunc()
            if self.repetitions != 0 and self.repetitions_enough == 0 then
                if self.OnTimerRepetitionsFinish then
                    self:OnTimerRepetitionsFinish()
                end
            elseif self.alwayscheckfordelay and delay != self.delay then
                self:StartTimer(true)
            end
        end)
    end
end

function HORDE.Timers:UpdateTimer(updateonlydata)

    if self:IsPaused() then self:UnPause() end

    if self:IsProceed() then

        timer.Create(self.timername, timer.TimeLeft( self.timername ), 1, function()
            self:CallFunc()
            self:StartTimer(true)
        end)

        return

    elseif updateonlydata then

        if self:TimerExists() then
            timer.Create(self.timername, self.delay, self.repetitions_enough, function()
                self:CallFunc()
            end)

            timer.Stop(self.timername)
        end

        return

    end

    self:StartTimer()
end

-------------------------> Change Params

function HORDE.Timers:SetFunc(func)
    self.func = func
end

function HORDE.Timers:SetDelay(delay)
    self.delay = delay
end

function HORDE.Timers:SetRepetitions(repetitions) -- you have to take into account that you need to set one number less
    self.repetitions = repetitions
end

function HORDE.Timers:SetRepetitionsEnough(repetitions_enough)
    self.repetitions_enough = repetitions_enough
end

------------------------->

function HORDE.Timers:Stop()
    if self.OnStop then
        self.OnStop()
    end
    timer.Stop(self.timername)
    self.stopped = true
end

function HORDE.Timers:IsStopped()
    return self.stopped
end

function HORDE.Timers:IsPaused()
    return self.paused
end

function HORDE.Timers:Pause()
    timer.Pause(self.timername)
    self.paused = true
end

function HORDE.Timers:UnPause()
    timer.UnPause(self.timername)
    self.paused = false
end

function HORDE.Timers:Start()
    self.stopped = false
    self.paused = false
    self:StartTimer()
end

--[[function HORDE.Timers:IsProceed()
    return self.isproceed
end -- not implemented]]

function HORDE.Timers:IsProceed()
    return !!timer.TimeLeft( self.timername )
end

function HORDE.Timers:Remove()
    if self.OnRemove then
        self:OnRemove()
    end
    timer.Remove(self.timername)
    HORDE.Timers.alltimers[self.timername] = nil
    self.removed = true
    if IsValid(self.linkwithent) then
        self.linkwithent:RemoveCallOnRemove( "Horde_timer_" .. self.timername )
    end
end

function HORDE.Timers:TimerExists()
    return timer.Exists(self.timername)
end

function HORDE.Timers:IsValid()
    return self.removed == false
end

if SERVER then
    function HORDE.Timers:SyncDelay(ply) -- only sync delay
        net.Start("Horde_Timers_SyncDelay")
        net.WriteString(self.timername)
        net.WriteFloat(self.delay)
        if ply then net.Send(ply) else net.Broadcast() end
    end
    util.AddNetworkString("Horde_Timers_SyncDelay")
else
    net.Receive("Horde_Timers_SyncDelay", function()
        local timer_obj = HORDE.Timers:Find(net.ReadString())
        local delay = net.ReadFloat()
        if IsValid(timer_obj) then
            timer_obj:SetDelay(delay)
            timer_obj:UpdateTimer(true)
        end
    end)
end