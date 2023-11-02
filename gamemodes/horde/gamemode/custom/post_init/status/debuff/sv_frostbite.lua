local entmeta = FindMetaTable("Entity")

local speeds_array = {
	[.5] = .96,
} -- ADD VARIANTS OF SPEED MULT HERE

function entmeta:Horde_ChangeMovementSpeed()
	local hookid = "Horde_MovementSpeedControl_" .. self:EntIndex()
	if hook.GetTable()["Think"][hookid] then return end
	local speed = self:Horde_MovementSpeedModifierGet()
	local is_npc = self:IsNPC()
	if speed == 1 or !is_npc then return end
	hook.Add("Think", hookid, function()
		if !IsValid(self) then
			hook.Remove("Think", hookid)
			return
		end
		speed = self:Horde_MovementSpeedModifierGet()
		if speed == 1 then
			hook.Remove("Think", hookid)
			return
		end
		local speed_is_lower = speed < 1 and speeds_array[speed]
		-- I HAVE NO IDEA HOW IT WORKS
		-- I'VE TESTED MULT WITH THE HULK AND CHECK THAT HE SPEED IS NOT SUPER LOWER
		-- WITH MULTIPLIER 0.96 HE HAS SPEED 62 WHEN HIS MAX WAS 124
		-- WITH MULTIPLIER 0.9 HE HAS SPEED 30 SOMETIMES DROPS TO 25
		-- SO YOU MUST TEST IT
		--print(self:GetMoveVelocity(), speed)
		self:SetMoveVelocity(self:GetMoveVelocity() * (speed_is_lower or speed < 1 and !speed_is_lower and 1 or speed))
		--print(self:GetMoveVelocity(), speed)
	end)
end

function entmeta:Horde_MovementSpeedModifierAdd(name, modifier)  -- THIS FUNCTION ISN'T WORK WHEN SPEED MULT LOWER THAN 1 EXCLUDE 0.5!!!!!!!!!!!!!
	if !self.Horde_MovementSpeedModifiers then self.Horde_MovementSpeedModifiers = {} end
	local is_npc = self:IsNPC()
	if is_npc then
		if self.FootStepTimeRun then
			local mult = self.Horde_MovementSpeedModifiers[name]
			if mult then
				self.FootStepTimeRun = self.FootStepTimeRun * mult
				self.FootStepTimeWalk = self.FootStepTimeWalk * mult
			end
			self.FootStepTimeRun = self.FootStepTimeRun / modifier
			self.FootStepTimeWalk = self.FootStepTimeWalk / modifier
		end
		self.Horde_MovementSpeedModifiers[name] = modifier
		self:Horde_ChangeMovementSpeed()
	end
end

function entmeta:Horde_MovementSpeedModifierDelete(name)
	if !self.Horde_MovementSpeedModifiers then
		self.Horde_MovementSpeedModifiers = {}
		return
	end
	local modif = self.Horde_MovementSpeedModifiers[name]
	if modif then
		self.Horde_MovementSpeedModifiers[name] = nil
		if self:IsNPC() and self.FootStepTimeRun then
			self.FootStepTimeRun = self.FootStepTimeRun * modif
			self.FootStepTimeWalk = self.FootStepTimeWalk * modif
		end
	end
end

function entmeta:Horde_MovementSpeedModifierGet(name)
	if !IsValid(self) then return 0 end
	if name then
		if !self.Horde_MovementSpeedModifiers then
			self.Horde_MovementSpeedModifiers = {}
			return
		end
		
		return self.Horde_MovementSpeedModifiers[name]
	end
	
	local sum = 1
	for _, modif in pairs(self.Horde_MovementSpeedModifiers) do
		sum = sum * modif
	end
	
	return sum
end

function entmeta:Horde_AddFrostbiteEffect(duration)
    if self:IsPlayer() then
    else
        timer.Remove("Horde_RemoveFrostbite" .. self:GetCreationID())
        timer.Create("Horde_RemoveFrostbite" .. self:GetCreationID(), 4, 1, function ()
            self:Horde_RemoveFrostbite()
        end)

        self.Horde_Frostbite = 1

        -- VJ
        if self:IsNPC() then
			self:Horde_MovementSpeedModifierAdd("Horde_FrostbiteDebuff", .5)  -- THIS FUNCTION ISN'T WORK WHEN SPEED MULT LOWER THAN 1 EXCLUDE 0.5!!!!!!!!!!!!!
            self:SetSchedule(SCHED_IDLE_STAND)
            timer.Simple(0, function ()
                if not self:IsValid() then return end
                if not self.Horde_StoredAnimationPlaybackRateFrostbite then
                    if self.AnimationPlaybackRate then
                        self.Horde_StoredAnimationPlaybackRateFrostbite = self.AnimationPlaybackRate
                        self.AnimationPlaybackRate = 0.6
                    else
                        self.Horde_StoredAnimationPlaybackRateFrostbite = self:GetPlaybackRate()
                        self:SetPlaybackRate(0.6)
                    end
                end
            end)
        end
    end

    local id = self:EntIndex()
    local bones = self:GetBoneCount()
    timer.Create("FrostbiteEffect" .. id, 0.5, 0, function ()
        if !self:IsValid() or (self:IsPlayer() and !self:Alive()) or not self.Horde_Debuff_Active or not self.Horde_Debuff_Active[HORDE.Status_Frostbite] then timer.Remove("FrostbiteEffect" .. id) return end
        for bone = 1, bones-1 do
            local pos, angle = self:GetBonePosition(bone)
            local effectdata = EffectData()
            effectdata:SetOrigin(pos)
            effectdata:SetScale( 1 )
            effectdata:SetMagnitude( 1 )
            effectdata:SetRadius( 18 )
            util.Effect( "GlassImpact", effectdata, true, true )
            util.Effect("horde_status_frostbite", effectdata, true, true)
        end
    end)
end

hook.Add("Horde_PlayerMoveBonus", "Horde_FrostbiteMovespeed", function(ply, bonus_walk, bonus_run)
    if ply.Horde_Debuff_Active and ply.Horde_Debuff_Active[HORDE.Status_Frostbite] then
        bonus_walk.more = bonus_walk.more * HORDE.difficulty_frostbite_slow[HORDE.difficulty]
        bonus_run.more = bonus_run.more * 0.5 * HORDE.difficulty_frostbite_slow[HORDE.difficulty]
    end
end)

function entmeta:Horde_RemoveFrostbite()
    if not self:IsValid() then return end
    local id = self:EntIndex()
    timer.Remove("FrostbiteEffect" .. id)
    if self:IsNPC() then
		self:Horde_MovementSpeedModifierDelete("Horde_FrostbiteDebuff")
        if self.Horde_StoredAnimationPlaybackRateFrostbite then
            self.AnimationPlaybackRate = self.Horde_StoredAnimationPlaybackRateFrostbite
        else
            self:SetPlaybackRate(self.Horde_StoredAnimationPlaybackRateFrostbite)
        end
        self.Horde_StoredAnimationPlaybackRateFrostbite = nil
    end
end