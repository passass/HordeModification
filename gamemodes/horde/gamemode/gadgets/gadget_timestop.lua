GADGET.PrintName = "TimeStop"
GADGET.Description =
[[Stop Time for 5 seconds.]]
GADGET.Icon = "items/gadgets/timestop.png"
GADGET.Duration = 6
GADGET.Cooldown = 90--85
GADGET.Active = true
GADGET.Params = {}
GADGET.Hooks = {}

if CLIENT then
    local cur_tick = 0
    local timestop_start_time = 0

    net.Receive("Horde_TimeStop", function()
        local is_start = net.ReadBool()
        cur_tick = 0
        timestop_start_time = CurTime()

        if is_start then
            timer.Simple(.6, function()
                timestop_start_time = CurTime()
                hook.Add("RenderScreenspaceEffects", "TimeStop_screeneffect", function()
                    local ct = CurTime()
                    if ct > timestop_start_time + 2.2 then
                        DrawColorModify( {
                            ["$pp_colour_addr"] = 0,
                            ["$pp_colour_addg"] = 0,
                            ["$pp_colour_addb"] = 0,
                            ["$pp_colour_brightness"] = 0,
                            ["$pp_colour_contrast"] = 1,
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
                            ["$pp_colour_contrast"] = 1,
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
        else
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

local function freeze_npc(ent)
	if ent.Horde_StartTimeStop and ent:Horde_StartTimeStop() then return end 
    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:Sleep()
    end
    
    ent:SetSchedule(SCHED_NPC_FREEZE)
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
	
	if ent.CustomOnThink then 
		ent.oldCustomOnThink = ent.CustomOnThink
		ent.CustomOnThink = function() end
	end
	
    if ent.StopAttacks then ent:StopAttacks(true) end
    --[[ent.oldConstantlyFaceEnemyVisible = ent.CurrentSchedule.ConstantlyFaceEnemyVisible
    ent.CurrentSchedule.ConstantlyFaceEnemyVisible = false]]
end

local function unfreeze_npc(ent)
	if ent.Horde_EndTimeStop and ent:Horde_EndTimeStop() then return end
    ent.AnimationPlaybackRate = 1
    ent:SetPlaybackRate(1)
    ent:SetCondition(68)
    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end
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
    --[[ent.CurrentSchedule.ConstantlyFaceEnemyVisible = ent.oldConstantlyFaceEnemyVisible
    ent.oldConstantlyFaceEnemyVisible = nil]]
end

local TimeStopStart = 0

function HORDE.TimeStop_TimeEnough() 
	return TimeStopStart + 6.2 - CurTime()
end

function HORDE.TimeStop_StartTime() 
	return TimeStopStart
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

local function start_timestop(ply)
    hook.Add("Horde_CanSlowTime", "Horde_TimeStop", function()
        return true
    end)
    if HORDE.SlowMotion_isprocessing() then HORDE.SlowMotion_end() end
    net.Start("Horde_TimeStop")
    net.WriteBool(true)
    net.Broadcast()
    timer.Simple(.5, function()
	
		TimeStopStart = CurTime()

        for _, ply2 in pairs(player.GetAll()) do
            if ply2:Alive() and ply2 != ply then
                ply2:Freeze(true)
            end
        end

        local npc_slowed = {}
        local frozed_entities = {}
        local shotted_bullets = {}

        for _, ent in pairs(ents.FindByClass("npc_*")) do
            if !ent:IsNPC() then continue end
            table.insert(npc_slowed, ent)
            freeze_npc(ent)
        end

        for i, ent in pairs(ents.GetAll()) do
            if i == 1 or !IsEntity(ent) or ent:IsNPC() or ent:IsWeapon() then continue end
            table.insert(frozed_entities, ent)
            freeze_entity(ent)
        end

        hook.Add( "OnEntityCreated", "Horde_TimeStop", function( ent )
            if ent:IsNPC() then
                freeze_npc(ent)
                
                table.insert(npc_slowed, ent)

                timer.Simple(0.2, function()
                    if !ent:IsValid() then return end
                    ent:SetSchedule(SCHED_NPC_FREEZE)
                end)
            elseif IsEntity(ent) and !ent:IsWeapon() then
                freeze_entity(ent)
                table.insert(frozed_entities, ent)
            end
        end )

        for _, wep in pairs(ply:GetWeapons()) do

            wep.oldDoPrimaryFire = wep.DoPrimaryFire

            wep.DoPrimaryFire = function(self, isent, data)
                if isent then
                    self:oldDoPrimaryFire(isent, data)
                else
                    table.insert(shotted_bullets, {wep = self, data = data, dir = data.Dir})
                end
            end
        end

        hook.Add("WeaponEquip", "Horde_TimeStop", function(wep)
            timer.Simple(0, function()
                if !IsValid(wep) then return end
                wep.oldDoPrimaryFire = wep.DoPrimaryFire

                wep.DoPrimaryFire = function(self, isent, data)
                    if isent then
                        self:oldDoPrimaryFire(isent, data)
                    else
                        table.insert(shotted_bullets, {wep = self, data = data, dir = data.Dir})
                    end
                end
            end)
        end)
		
		--[[hook.Add("Think", "TimeStopNPCMove", function()
            for _, ent in pairs(npc_slowed) do
                if !IsValid(ent) then continue end
                ent:SetSchedule(SCHED_IDLE_STAND)
                ent:SetMoveVelocity(Vector(0, 0, 0))
                ent:SetVelocity(Vector(0, 0, 0))
            end
        end)]]
        timer.Simple(0.2, function()
			for _, ent in pairs(npc_slowed) do
				if not ent:IsValid() then continue end
				ent:SetSchedule(SCHED_NPC_FREEZE)
			end
		end)

        timer.Simple(5, function()
            --hook.Remove("Think", "TimeStopNPCMove")
            
            net.Start("Horde_TimeStop")
            net.WriteBool(false)
            net.Broadcast()

            timer.Simple(1.2, function()
				TimeStopStart = 0
                hook.Remove("Horde_CanSlowTime", "Horde_TimeStop")
				hook.Remove("WeaponEquip", "Horde_TimeStop")
				hook.Remove( "OnEntityCreated", "Horde_TimeStop")

                if IsValid(ply) then
                    for _, wep in pairs(ply:GetWeapons()) do
                        if wep.oldDoPrimaryFire then
                            wep.DoPrimaryFire = wep.oldDoPrimaryFire
                            wep.oldDoPrimaryFire = nil
                        end
                    end
        
                    
                end
                
                for _, bul in pairs(shotted_bullets) do
                    bul.data.TracerName = "arccw_tracer_timestop"
                    bul.data.Dir = bul.dir
                    if IsValid(bul.wep) and bul.wep.ArcCW then
                        bul.wep:DoPrimaryFire(false, bul.data)
                    else
                        ply:FireBullets(bul.data, true)
                    end
                end

                for _, ent in pairs(npc_slowed) do
                    if !IsValid(ent) then continue end
                    unfreeze_npc(ent)
                end
                for _, ent in pairs(frozed_entities) do
                    if !IsValid(ent) then continue end
                    unfreeze_entity(ent)
                end
                for _, ply2 in pairs(player.GetAll()) do
                    
                    if ply2:Alive() and ply2 != ply then
                        ply2:Freeze(false)
                    end
    
                end
            end)
        end)
    end)
end

GADGET.Hooks.Horde_UseActiveGadget = function (ply)
    if CLIENT then return end
    if ply:Horde_GetGadget() ~= "gadget_timestop" then return end

    ply:EmitSound("timestop_start.mp3")

    start_timestop(ply)
end