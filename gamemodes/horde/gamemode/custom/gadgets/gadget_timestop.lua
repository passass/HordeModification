GADGET.PrintName = "TimeStop"
GADGET.Description =
[[Stop Time for 5 seconds.]]
GADGET.Icon = "items/gadgets/timestop.png"
GADGET.Duration = 6
GADGET.Cooldown = 45
GADGET.Active = true
GADGET.Params = {}
GADGET.Hooks = {}

local TimeStopProceed = false

function HORDE.TimeStop_Proceed()
	return TimeStopProceed
end

local shooted_bullets = {}
local function Weapons_Stop_Beams()
    hook.Add("EntityFireBullets", "Horde_TimeStop", function(ent, data)
        table.insert(shooted_bullets, {wep = data.Weapon, data = data, dir = data.Dir, attacker = data.Attacker})
        return false
    end)
end
local function Weapons_Start_Beams()
    hook.Remove("EntityFireBullets", "Horde_TimeStop")
    for i, bul in pairs(shooted_bullets) do
        timer.Simple(math.min(.55, 0.04 * (i ^ .5)), function()
            bul.data.TracerName = "arccw_tracer_timestop"
            bul.data.Dir = bul.dir
            if IsValid(bul.wep) and bul.wep.ArcCW then
                bul.wep:DoPrimaryFire(false, bul.data)
            else
                bul.attacker:FireBullets(bul.data, true)
            end
        end)
    end
    table.Empty(shooted_bullets)
end

if CLIENT then
    local cur_tick = 0
    local timestop_start_time = 0

    net.Receive("Horde_TimeStop", function()
        local is_start = net.ReadBool()
        cur_tick = 0
        timestop_start_time = CurTime()

        TimeStopProceed = true

        if is_start then
            Weapons_Stop_Beams()
            timer.Simple(.5, function()

                timer.Stop("Horde_LocalGadgetCooldown")

                for _, wep in pairs(MySelf:GetWeapons()) do
                    if IsValid(wep) and wep.Horde_HealSyringeTimer then
                        wep.Horde_HealSyringeTimer:Stop()
                    end
                end

                timer.Simple(.1, function()
                    timestop_start_time = CurTime()
                    hook.Add("RenderScreenspaceEffects", "TimeStop_screeneffect", function()
                        local ct = CurTime()
                        if ct > timestop_start_time + 2.2 then
                            DrawColorModify( {
                                ["$pp_colour_addr"] = 0,
                                ["$pp_colour_addg"] = 0,
                                ["$pp_colour_addb"] = 0,
                                ["$pp_colour_brightness"] = 0,
                                ["$pp_colour_contrast"] = .8,
                                ["$pp_colour_colour"] = 0,
                                ["$pp_colour_mulr"] = 0,
                                ["$pp_colour_mulg"] = 0,
                                ["$pp_colour_mulb"] = 0
                            } )
                        elseif ct > timestop_start_time + 1 then
                            local stage = 1 - Lerp(math.ease.InQuad((ct - timestop_start_time - 1) / 1.2), 0, 1)
                            DrawColorModify( {
                                ["$pp_colour_addr"] = stage * .1,
                                ["$pp_colour_addg"] = stage * .1,
                                ["$pp_colour_addb"] = 0,
                                ["$pp_colour_brightness"] = 0,
                                ["$pp_colour_contrast"] = 1 - .2 * (1 - stage),
                                ["$pp_colour_colour"] = stage,
                                ["$pp_colour_mulr"] = stage * .8,
                                ["$pp_colour_mulg"] = stage * .8,
                                ["$pp_colour_mulb"] = 0
                            } )
                        else
                            local stage = Lerp(math.ease.OutCirc(ct - timestop_start_time), 0, 1)
                            DrawColorModify( {
                                ["$pp_colour_addr"] = stage * .1,
                                ["$pp_colour_addg"] = stage * .1,
                                ["$pp_colour_addb"] = 0,
                                ["$pp_colour_brightness"] = 0,
                                ["$pp_colour_contrast"] = 1,
                                ["$pp_colour_colour"] = 1,
                                ["$pp_colour_mulr"] = stage * .8,
                                ["$pp_colour_mulg"] = stage * .8,
                                ["$pp_colour_mulb"] = 0
                            } )
                        end
                    end)
    
                    timer.Create("TimerStopTicking", 1, 4, function()
                        cur_tick = cur_tick + 1
                        if cur_tick >= 5 then cur_tick = 1 end
                        surface.PlaySound("timestop_tick" .. cur_tick .. ".mp3")
                    end)
                end)
            end)
        else
            timer.Simple(1.2, function()
                Weapons_Start_Beams()
                TimeStopProceed = false
                timer.Start("Horde_LocalGadgetCooldown")

                for _, wep in pairs(MySelf:GetWeapons()) do
                    if IsValid(wep) and wep.Horde_HealSyringeTimer then
                        wep.Horde_HealSyringeTimer:Start()
                    end
                end
                --timer.Start("Horde_LocalGadgetCooldown")
            end)
            timer.Remove("TimerStopTicking")
            hook.Add("RenderScreenspaceEffects", "TimeStop_screeneffect", function()
                local ct = CurTime()
                if ct > timestop_start_time + 1.5 then
                    hook.Remove("RenderScreenspaceEffects", "TimeStop_screeneffect")
                    timestop_start_time = 0
                    return 
                end
                local stage = Lerp(math.ease.InQuint((ct - timestop_start_time) / 1.5), 0, 1)
                DrawColorModify( {
                    ["$pp_colour_addr"] = 0,
                    ["$pp_colour_addg"] = 0,
                    ["$pp_colour_addb"] = 0,
                    ["$pp_colour_brightness"] = 0,
                    ["$pp_colour_contrast"] = 1,
                    ["$pp_colour_colour"] = stage,
                    ["$pp_colour_mulr"] = 0,
                    ["$pp_colour_mulg"] = 0,
                    ["$pp_colour_mulb"] = 0
                } )
            end)
            surface.PlaySound("timestop_end.mp3")
        end
    end)
	return
end

util.AddNetworkString("Horde_TimeStop")

local mutations = {
	"Fume",
	"Regenerator",
}

function HORDE:TimeStop_freeze_npc(ent)
	if ent.Horde_StartTimeStop and ent:Horde_StartTimeStop() then return end
    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:Sleep()
    end

    ent.IsFreezed = true
    
	ent.oldAnimationPlaybackRate = ent.AnimationPlaybackRate
	ent.oldPlaybackRate = ent:GetPlaybackRate()
    ent.AnimationPlaybackRate = 0
    ent:SetPlaybackRate(0)

    ent.oldHasIdleSounds = ent.HasIdleSounds
    ent.HasIdleSounds = false

    ent.oldFaceCertainEntity = ent.FaceCertainEntity
    ent.FaceCertainEntity = function() return false end
    ent.CurrentAttackAnimation = 0
    ent.CurrentAttackAnimationDuration = 0
    ent.PlayingAttackAnimation = false
    ent.LeapAttacking = false
    ent.IsAbleToLeapAttack = true
    ent.AlreadyDoneLeapAttackFirstHit = false
    ent.AlreadyDoneFirstLeapAttack = false
    ent.AlreadyDoneLeapAttackJump = false
    if ent.StopAllCommonSounds then ent:StopAllCommonSounds() end
    if ent.MeleeAttackCode_DoFinishTimers then ent:MeleeAttackCode_DoFinishTimers(true) end
	if ent.RangeAttackCode_DoFinishTimers then ent:RangeAttackCode_DoFinishTimers(true) end
	if ent.LeapAttackCode_DoFinishTimers then ent:LeapAttackCode_DoFinishTimers(true) end

    if ent.AllowMovementJumping then ent.oldAllowMovementJumping = ent.AllowMovementJumping ent.AllowMovementJumping = false end

    ent.MeleeAttacking = false
    ent.IsAbleToMeleeAttack = true
    ent.AlreadyDoneMeleeAttackFirstHit = false
    ent.AlreadyDoneFirstMeleeAttack = false
    ent.RangeAttacking = false
    ent.IsAbleToRangeAttack = true
    ent.oldHasLeapAttack = ent.HasLeapAttack
    ent.HasLeapAttack = false
    ent.oldHasMeleeAttack = ent.HasMeleeAttack
    ent.HasMeleeAttack = false
    ent.oldHasRangeAttack = ent.HasRangeAttack
    ent.HasRangeAttack = false

    local ent_wep = ent.GetActiveWeapon and ent:GetActiveWeapon()

    if ent_wep and IsValid(ent_wep) then
        if ent_wep.NPC_SecondaryFireNextT then
            ent_wep.NPC_SecondaryFireNextT = ent_wep.NPC_SecondaryFireNextT + HORDE.TimeStop_TimeEnough()
        end
    
        if ent_wep.NPC_NextPrimaryFireT then
            ent_wep.NPC_NextPrimaryFireT = ent_wep.NPC_NextPrimaryFireT + HORDE.TimeStop_TimeEnough()
        end
    end
	
	if ent.CustomOnThink then
		ent.oldCustomOnThink = ent.CustomOnThink
		ent.CustomOnThink = function() end
	end

    local is_kf_npc = not not ent.KFNPCStopAllTimers

    local timername = "Horde_TimeStop_FreezeNPC" .. ent:EntIndex()

    ent:SetSchedule(SCHED_NPC_FREEZE)
	ent:SetMoveVelocity(Vector(0,0,0))

    if is_kf_npc then
        ent:KFNPCClearAnimation()
        ent:KFNPCStopAllTimers()
        ent:SetNPCState(NPC_STATE_DEAD)
        ent:SetSchedule(SCHED_CHASE_ENEMY_FAILED)
        ent:KFNPCStopPreviousSound()
        ent:StopMoving()
        ent.DisableAI = true
        ent.MustNotMove = true
    end

    timer.Create(timername, 0.1, 0, function()
        if !IsValid(ent) then
            timer.Remove(timername)
            return
        end

        ent:SetSchedule(SCHED_NPC_FREEZE)
		ent:SetMoveVelocity(Vector(0,0,0))

        if is_kf_npc then
            ent:SetNPCState(NPC_STATE_DEAD)
		    ent:SetSchedule(SCHED_CHASE_ENEMY_FAILED)
            ent:KFNPCStopPreviousSound()
            ent:KFNPCClearAnimation()
            ent:StopMoving()
            
		    ent:SetCondition(67)
            ent:KFNPCStopAllTimers()

            ent:SetPlaybackRate(0)
            ent:SetVelocity(Vector(0, 0, 0))
            ent:SetLocalVelocity(Vector(0, 0, 0))
            ent:SetPlaybackRate(0)
            ent:KFNPCStun(ent.StunSequence)

            ent:ResetSequence(ent:LookupSequence(ent.IdleSequence))
        end
    end)
	
    if ent.StopAttacks then ent:StopAttacks(true) end
	
	for i, mutation in pairs(mutations) do
		local id = ent:GetCreationID()
		if timer.Exists("Horde_Mutation_" .. mutation .. id) then
			timer.Pause("Horde_Mutation_" .. mutation .. id)
		end
	end
end

function HORDE:TimeStop_unfreeze_npc(ent)
	if ent.Horde_EndTimeStop and ent:Horde_EndTimeStop() then return end
    ent.AnimationPlaybackRate = 1
    ent:SetPlaybackRate(1)
    ent:SetCondition(68)
    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end

    ent.IsFreezed = false
    ent.HasIdleSounds = ent.oldHasIdleSounds
    ent.oldHasIdleSounds = nil

    ent.FaceCertainEntity = ent.oldFaceCertainEntity
    ent.oldFaceCertainEntity = nil

    ent.CurrentAttackAnimation = 0
    ent.CurrentAttackAnimationDuration = 0
    ent.PlayingAttackAnimation = false

    ent.LeapAttacking = false
    ent.IsAbleToLeapAttack = true
    ent.AlreadyDoneLeapAttackFirstHit = false
    ent.AlreadyDoneFirstLeapAttack = false
    ent.AlreadyDoneLeapAttackJump = false

    ent.HasLeapAttack = ent.oldHasLeapAttack
    ent.oldHasLeapAttack = nil
    ent.HasMeleeAttack = ent.oldHasMeleeAttack
    ent.oldHasMeleeAttack = nil
    ent.HasRangeAttack = ent.oldHasRangeAttack
    ent.oldHasRangeAttack = nil
	
	if ent.CustomOnThink then
		ent.CustomOnThink = ent.oldCustomOnThink
		ent.oldCustomOnThink = nil
	end

    if !ent.CustomOnThink then
        ent.CustomOnThink = function() end
    end

    if ent.AllowMovementJumping then ent.AllowMovementJumping = ent.oldAllowMovementJumping ent.oldAllowMovementJumping = nil end

    local is_kf_npc = not not ent.KFNPCStopAllTimers

    if is_kf_npc then
        ent:SetNPCState( NPC_STATE_NONE )
        ent:KFNPCClearAnimation()
        ent.DisableAI = false
        ent.MustNotMove = false
    end

    local timername = "Horde_TimeStop_FreezeNPC" .. ent:EntIndex()

    timer.Remove(timername)
	
	for i, mutation in pairs(mutations) do
		local id = ent:GetCreationID()
		if timer.Exists("Horde_Mutation_" .. mutation .. id) then
			timer.UnPause("Horde_Mutation_" .. mutation .. id)
		end
	end
end

local TimeStopStart = 0
local TimeStopActivator = NULL

function HORDE.TimeStop_TimeEnough()
	return TimeStopStart + 6.2 - CurTime()
end

function HORDE.TimeStop_StartTime()
	return TimeStopStart
end

function HORDE.TimeStop_Activator()
	return TimeStopActivator
end

local function freeze_entity(ent)
	timer.Simple(0, function() 
		if ent.Horde_StartTimeStop and ent:Horde_StartTimeStop() then return end
		local vel = ent:GetVelocity()
		local velocity = (vel != Vector(0, 0, 0) or IsValid(ent:GetParent()) or ent.SpawnTime and CurTime() > ent.SpawnTime + .1) and vel or ent.CurVel or Vector(0, 0, 0)
		if velocity == Vector(0, 0, 0) then 
			return
		end
		local phys = ent:GetPhysicsObject()
		
		if phys:IsValid() then
			if !phys:IsMotionEnabled() then return end
			phys:EnableMotion( false )
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			phys:Sleep()
		end

		ent.OldVelocity = velocity
		ent.oldThink = ent.Think
		ent.Think = function(ent2) end
		if ent.Think2 then 
			ent.oldThink2 = ent.Think2
			ent.Think2 = function(ent2) end
		end
		if ent.FuseTime then
			ent.FuseTime = ent.FuseTime + HORDE.TimeStop_TimeEnough()
		end
    end)
end

local function unfreeze_entity(ent)
	if ent.Horde_EndTimeStop and ent:Horde_EndTimeStop() then return end
	local velocity = ent.OldVelocity
	if velocity == Vector(0, 0, 0) then return end
    local phys = ent:GetPhysicsObject()
    if phys:IsValid() then
        phys:EnableMotion( true )
        phys:ClearGameFlag( FVPHYSICS_NO_IMPACT_DMG )
        phys:Wake()
    end

    ent.Initialize = ent.oldInitialize
    ent.oldInitialize = nil
    ent.Think = ent.oldThink
    ent.oldThink = nil
    if ent.oldThink2 then
        ent.Think2 = ent.oldThink2
        ent.oldThink2 = nil
    end
    if velocity and velocity != Vector(0, 0, 0) and !IsValid(ent:GetParent()) then	
		ent:SetVelocity(velocity)
		phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetVelocity(velocity) --SetVelocityInstantaneous
		end
    end
end

local freezed_mutations = {} -- example. {"nemesis", ent_pos}



local function freeze_mutations()
	for id, _ in pairs(HORDE:Mutations_Nemesis_GetAll()) do
		timer.Pause("Horde_Mutation_Nemesis" .. id)
	end
	
	hook.Add("Horde_Mutations_Nemesis_Create", "Horde_TimeStop", function(ent_pos)
		table.insert(freezed_mutations, {"nemesis", ent_pos})
        return true
    end)
end

local function unfreeze_mutations()
	for id, _ in pairs(HORDE:Mutations_Nemesis_GetAll()) do
		timer.UnPause("Horde_Mutation_Nemesis" .. id)
	end

	hook.Remove("Horde_Mutations_Nemesis_Create", "Horde_TimeStop")
	for _, data in pairs(freezed_mutations) do 
		local mutation = data[1]
		if mutation == "nemesis" then 
			HORDE:Mutations_Nemesis_Create(data[2])
		end
	end
	freezed_mutations = {}
end

local function freeze_mutations_progress(exclude_ply)
	hook.Add("Horde_OnPlayerDebuffApplyPost", "Horde_TimeStop", function(ent, debuff, bonus, inflictor)
		if ent == exclude_ply then return end
		local timername = "Horde_RemoveBuildup_" .. tostring(debuff) .. "_" .. ent:SteamID()
		timer.Pause(timername)
	end)
	hook.Add("Horde_PostPlayerDebuffApply", "Horde_TimeStop", function(ent, debuff) 
		if ent == exclude_ply then return end
		local timername = "Horde_Remove_" .. tostring(debuff) .. "_" .. ent:SteamID()
		timer.Pause(timername)
	end)
	for _, ply in pairs(player.GetAll()) do
		if !ply:Alive() or exclude_ply == ply then return end
		local steamid = ply:SteamID()
		if ply.Horde_Debuff_Buildup then
			for debuff, _ in pairs(ply.Horde_Debuff_Buildup) do
				local timername = "Horde_RemoveBuildup_" .. tostring(debuff) .. "_" .. steamid
				local timername2 = "Horde_Remove_" .. tostring(debuff) .. "_" .. steamid
				timer.Pause(timername)
				timer.Pause(timername2)
			end
		end
		if timer.Exists("Horde_BleedingEffect" .. steamid) then 
			timer.Pause("Horde_BleedingEffect" .. steamid)
		end
	end
	
	for _, ent in pairs(ents.GetAll()) do
		if ent:IsPlayer() then return end
		local id = ent:GetCreationID()
		if ent.Horde_Debuff_Buildup then
			for _, debuff in pairs(ent.Horde_Debuff_Buildup) do 
				local timername = "Horde_Remove_" .. tostring(debuff) .. "_" .. id
				timer.Pause(timername)
			end
		end
		if timer.Exists("Horde_BleedingEffect" .. id) then 
			timer.Pause("Horde_BleedingEffect" .. id)
		end
	end
end

local function unfreeze_mutations_progress(exclude_ply)
	hook.Remove("Horde_OnPlayerDebuffApplyPost", "Horde_TimeStop")
	hook.Remove("Horde_PostPlayerDebuffApply", "Horde_TimeStop")
	for _, ply in pairs(player.GetAll()) do
		if !ply:Alive() or exclude_ply == ply then return end
		local steamid = ply:SteamID()
		if ply.Horde_Debuff_Buildup then
			for debuff, _ in pairs(ply.Horde_Debuff_Buildup) do 
				local timername = "Horde_RemoveBuildup_" .. tostring(debuff) .. "_" .. steamid
				local timername2 = "Horde_Remove_" .. tostring(debuff) .. "_" .. steamid
				timer.UnPause(timername)
				timer.UnPause(timername2)
			end
		end
		if timer.Exists("Horde_BleedingEffect" .. steamid) then 
			timer.UnPause("Horde_BleedingEffect" .. steamid)
		end
	end
	
	for _, ent in pairs(ents.GetAll()) do 
		if ent:IsPlayer() then return end
		local id = ent:GetCreationID()
		if ent.Horde_Debuff_Buildup then
			for _, debuff in pairs(ent.Horde_Debuff_Buildup) do 
				local timername = "Horde_Remove_" .. tostring(debuff) .. "_" .. id
				timer.UnPause(timername)
			end
		end
		if timer.Exists("Horde_BleedingEffect" .. id) then 
			timer.UnPause("Horde_BleedingEffect" .. id)
		end
	end
end

local function start_timestop(activator)
    hook.Add("Horde_CanSlowTime", "Horde_TimeStop", function()
        return true
    end)
	TimeStopProceed = true
    if HORDE.SlowMotion_isprocessing() then HORDE.SlowMotion_end() end
    net.Start("Horde_TimeStop")
    net.WriteBool(true)
    net.Broadcast()
    timer.Simple(.5, function()

        local npc_slowed = {}
        local frozed_entities = {}
	
		TimeStopStart = CurTime()
		
		local players_healed = {}

        for _, ply2 in pairs(player.GetAll()) do
            if ply2:Alive() then
                if ply2 != activator then

                    -- Freeze player movement
                    ply2:Freeze(true)
                    ply2:Lock()
                    
                    -- Stop Healing
                    local timer_obj = ply2.Horde_HealTimer
                    if timer_obj then
                        timer_obj:Stop()
                    end

                    -- Stop reloading
                    local wep = ply2:GetActiveWeapon()
                    if IsValid(wep) then
                        if wep.Horde_StartTimeStop then wep:Horde_StartTimeStop() end
                        if wep.ArcCW then
                            wep:SetNextPrimaryFire(wep:GetNextPrimaryFire() + 6.2)
                            wep:SetReloading(wep:GetReloadingREAL() + 6.2)
                            wep.LastAnimStartTime = wep.LastAnimStartTime + 6.2
                            wep.LastAnimFinishTime = wep.LastAnimFinishTime + 6.2
                            wep:SetNextIdle(wep:GetNextIdle() + 6.2)
                            wep:SetMagUpIn(wep:GetMagUpIn() + 6.2)
                            local vm = wep.REAL_VM or ply2:GetViewModel()
                            if vm and IsValid(vm) then
                                wep.oldPlaybackRate = vm:GetPlaybackRate()
                                vm:SetPlaybackRate(0)
                            end
                        end

                        if wep.Horde_HealSyringeTimer then
                            wep.Horde_HealSyringeTimer:Stop()
                        end
                    end
                end

                -- Stop gadget charging
                if ply2:Horde_GetGadget() and ply2:Horde_GetGadgetNextThink() > 0 then
                    ply2:Horde_SetGadgetNextThink(ply2:Horde_GetGadgetNextThink() + 6.2)
                end
            end
        end

        for _, ent in pairs(ents.FindByClass("npc_*")) do
            if !ent:IsNPC() then continue end
            table.insert(npc_slowed, ent)
            HORDE:TimeStop_freeze_npc(ent)
        end

        for i, ent in pairs(ents.GetAll()) do
            if i == 1 or !IsEntity(ent) or ent:IsNPC() or ent:IsWeapon() or ent:IsPlayer() then continue end
            table.insert(frozed_entities, ent)
            freeze_entity(ent)
        end

        hook.Add( "OnEntityCreated", "Horde_TimeStop", function( ent )
            if ent:IsNPC() then
                HORDE:TimeStop_freeze_npc(ent)
                
                table.insert(npc_slowed, ent)
            elseif IsEntity(ent) and !ent:IsWeapon() then
                freeze_entity(ent)
                table.insert(frozed_entities, ent)
            end
        end )
		
		hook.Add("Horde_SlowHeal_Post", "Horde_TimeStop", function(ply2, amount, overhealmult)
			if activator == ply2 then return end
			local timer_obj = ply2.Horde_HealTimer
            if timer_obj then
                timer_obj:Stop()
            end
		end)
	
		freeze_mutations()
		freeze_mutations_progress(activator)
        Weapons_Stop_Beams()
		
        timer.Simple(5, function()
            net.Start("Horde_TimeStop")
            net.WriteBool(false)
            net.Broadcast()

            timer.Simple(1.2, function()
                hook.Remove("Horde_CanSlowTime", "Horde_TimeStop")
                hook.Remove("Horde_SlowHeal_Post", "Horde_TimeStop")
				hook.Remove("WeaponEquip", "Horde_TimeStop")
				hook.Remove("OnEntityCreated", "Horde_TimeStop")
                hook.Remove("Horde_SlowHeal_NotAllow", "Horde_TimeStop")
				unfreeze_mutations()
				unfreeze_mutations_progress(activator)

                if IsValid(activator) then
                    for _, wep in pairs(activator:GetWeapons()) do
                        if wep.oldDoPrimaryFire then
                            wep.DoPrimaryFire = wep.oldDoPrimaryFire
                            wep.oldDoPrimaryFire = nil
                        end
                    end
                end
                
                Weapons_Start_Beams()

                for _, ent in pairs(npc_slowed) do
                    if !IsValid(ent) then continue end
                    HORDE:TimeStop_unfreeze_npc(ent)
                end
                for _, ent in pairs(frozed_entities) do
                    if !IsValid(ent) then continue end
                    unfreeze_entity(ent)
                end
                for _, ply2 in pairs(player.GetAll()) do
                    if ply2:Alive() and ply2 != activator then
                        ply2:Freeze(false)
                        ply2:UnLock()
                        ply2:StopSound("player/pl_drown1.wav")
                        ply2:StopSound("player/pl_drown2.wav")
                        ply2:StopSound("player/pl_drown3.wav")
						local timer_obj = ply2.Horde_HealTimer
                        if timer_obj then
                            timer_obj:Start()
                        end
                        local wep = ply2:GetActiveWeapon()
                        if IsValid(wep) then
                            if wep.Horde_EndTimeStop then wep:Horde_EndTimeStop() end
                            if wep.oldPlaybackRate then
                                local vm = wep.REAL_VM or ply2:GetViewModel()
                                if IsValid(vm) then
                                    vm:SetPlaybackRate(wep.oldPlaybackRate)
                                end
                                wep.oldPlaybackRate = nil
                            end
                        end

                        if wep.Horde_HealSyringeTimer then
                            wep.Horde_HealSyringeTimer:Start()
                        end
                    end
                end

                TimeStopActivator = NULL
				TimeStopStart = 0
				TimeStopProceed = false
            end)
        end)
    end)
end

GADGET.Hooks.Horde_UseActiveGadget = function (ply)
    if CLIENT then return end
    if ply:Horde_GetGadget() ~= "gadget_timestop" then return end
	if TimeStopProceed then return true end
	
    ply:EmitSound("timestop_start.mp3")

    start_timestop(ply)
    TimeStopActivator = ply
end