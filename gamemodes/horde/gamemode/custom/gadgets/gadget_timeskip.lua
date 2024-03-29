GADGET.PrintName = "TimeSkip"
local skip_on = 2
GADGET.Description =
[[Skip healing, gadget cooldown and reloading for ]] .. skip_on .. [[ seconds.]]
GADGET.Icon = "items/gadgets/timestop.png"

--GADGET.Duration = skip_on
GADGET.Cooldown = 10
GADGET.Active = true
GADGET.Params = {}
GADGET.Hooks = {}

local function SkipReload(wep)
    if wep.Horde_TimeSkip then return end
    wep.Horde_TimeSkip = true
 
    if wep.ArcCW and wep:GetReloading() then

        wep.LastAnimStartTime = wep.LastAnimStartTime - skip_on
        wep.LastAnimFinishTime = wep.LastAnimFinishTime - skip_on
        wep.LHIKStartTime = wep.LHIKStartTime - skip_on
        --> is shotgun
        local shouldshotgunreload = wep:GetBuff_Override("Override_ShotgunReload") or wep.ShotgunReload
        local shouldhybridreload = wep:GetBuff_Override("Override_HybridReload") or wep.HybridReload
        if shouldhybridreload then
            shouldshotgunreload = wep:Clip1() != 0
        end
        --> is shotgun

        if !shouldshotgunreload then

            if SERVER then
                --MySelf:GetViewModel():SetAnimTime(wep.LastAnimStartTime)
                --MySelf:GetViewModel():SetAnimTime(wep.LastAnimStartTime)
                --print("pppppp", wep.REAL_VM:GetCycle())
                
                --print(wep.LastAnimStartTime, MySelf == LocalPlayer(), CurTime(), MySelf:GetViewModel():GetAnimTime())
            --else
                wep:SetReloadingREAL(wep:GetReloadingREAL() - skip_on)
                wep:SetNextPrimaryFire(wep:GetNextPrimaryFire() - skip_on)
                wep:SetMagUpIn(wep:GetMagUpIn() - skip_on)
                wep:SetNextIdle(wep:GetNextIdle() - skip_on)
            else
                wep.REAL_VM:SetCycle(wep:GetAnimationProgress() + skip_on / wep:GetAnimKeyTime(wep.LastAnimKey))
            end

            --print(wep:GetReloadingREAL(), wep:GetNextPrimaryFire(), wep:GetMagUpIn(), wep:GetNextIdle())
            local anim = wep.LastAnimKey
            for i, sounds in ipairs(wep.EventTable) do
                for time, key in pairs(sounds) do
                    if key.AnimKey == anim then
                        key.StartTime = key.StartTime - skip_on
                        time2 = time - skip_on
                        if !sounds[time2] then
                            sounds[time2] = table.Copy(key)
                            sounds[time] = nil
                        end
                    end
                end
            end
        end
    end

    timer.Simple(0, function()
        if IsValid(wep) then
            wep.Horde_TimeSkip = nil
        end
    end)
end

if CLIENT then

    net.Receive("Horde_TimeSkip", function()
        local start_time = CurTime()
        local end_on = start_time + .2

        hook.Add("RenderScreenspaceEffects", "TimeSkip_screeneffect", function()
            local ct = CurTime()
            if ct > end_on then
                hook.Remove("RenderScreenspaceEffects", "TimeSkip_screeneffect")
                return
            end

            local stage = Lerp((end_on - ct) / .2, 0, 1)

            DrawColorModify( {
                ["$pp_colour_addr"] = .8 * stage,
                ["$pp_colour_addg"] = 0,
                ["$pp_colour_addb"] = .8 * stage,
                ["$pp_colour_brightness"] = 0,
                ["$pp_colour_contrast"] = 1,
                ["$pp_colour_colour"] = 1,
                ["$pp_colour_mulr"] = 0,
                ["$pp_colour_mulg"] = 0,
                ["$pp_colour_mulb"] = 0
            } )
        end)
        
        SkipReload(MySelf:GetActiveWeapon())
        local cd = MySelf:Horde_GetGadgetInternalCooldown()
        if MySelf:Horde_GetGadget() != "gadget_timeskip" and cd > 0 then
            MySelf:Horde_SetGadgetInternalCooldown(math.max(0, cd - math.Round(skip_on)))
        end

        for _, ply in pairs(player.GetAll()) do
            ply:Horde_SetGadgetInternalCooldown(math.max(0, ply:Horde_GetGadgetInternalCooldown() - math.Round(skip_on)))
        end
    end)
	return
end

util.AddNetworkString("Horde_TimeSkip")

GADGET.Hooks.Horde_UseActiveGadget = function (activator)
    if CLIENT then return end
    if activator:Horde_GetGadget() != "gadget_timeskip" then return end
	
    activator:EmitSound("horde_timeskip.mp3")

    for _, ply in pairs(player.GetAll()) do
        if !ply:Alive() then return end

        local wep = ply:GetActiveWeapon()
    
        if !IsValid(wep) then return end

        net.Start("Horde_TimeSkip")
        net.Send(ply)
        
        SkipReload(wep)
        local cd = ply:Horde_GetGadgetInternalCooldown()
        if ply:Horde_GetGadget() != "gadget_timeskip" and cd > 0 then
            ply:Horde_SetGadgetInternalCooldown(math.max(0, cd - math.Round(skip_on)))
        end


        if ply.Horde_HealTimer and ply.Horde_HealHPRemain then
            local healdelay = ply.Horde_HealTimer.delay
           
            local totalhp = math.min(ply.Horde_HealHPRemain, math.Round(skip_on / healdelay))
            ply:SetHealth(ply:Health() + totalhp)
            ply.Horde_HealHPRemain = ply.Horde_HealHPRemain - totalhp
        end
    end
    
    
end