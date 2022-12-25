if engine.ActiveGamemode() != "horde" then return end

function SWEP:InitialDefaultClip()
    if !self.Primary.Ammo then return end

    local ply = self:GetOwner()
    if ply and ply:IsPlayer() then
        if self:HasBottomlessClip() then
            self:SetClip1(0)
        end
        local ammotype = self.Primary.Ammo

        local total_ammo
        if self.ForceDefaultAmmo then
            total_ammo = self.ForceDefaultAmmo
        else 
            total_ammo = self:GetCapacity() * GetConVar("arccw_mult_defaultammo"):GetInt()
        end
        local max_ammo = HORDE:Ammo_GetMaxAmmo(self)
        for k, v in pairs(ply:GetWeapons()) do
            if v != self and v.Primary and v.Primary.Ammo == ammotype then
                local max_ammo_2 = HORDE:Ammo_GetMaxAmmo(v)
                if max_ammo < max_ammo_2 then
                    max_ammo = max_ammo_2
                end
            end
        end

        local diff_ammo = max_ammo - ply:GetAmmoCount(ammotype)
        if diff_ammo > 0 then
            self:GetOwner():GiveAmmo(diff_ammo > total_ammo and total_ammo or diff_ammo, ammotype)
        end
    end
end

SWEP.ModifiedCache_Permanent = {}

function SWEP:AdjustAtts()
    local old_inf = self:HasInfiniteAmmo()

    self:RecalcAllBuffs()

    -- Recalculate active elements so dependencies aren't fucked
    self.ActiveElementCache = nil
    self:GetActiveElements(true)
    self.ModifiedCache = table.Copy(self.ModifiedCache_Permanent)

    for i, k in pairs(self.Attachments) do
        if !k.Installed then continue end
        local ok = true

        if !ArcCW:SlotAcceptsAtt(k.Slot, self, k.Installed) then ok = false end
        if ok and !self:CheckFlags(k.ExcludeFlags, k.RequireFlags) then ok = false end

        local atttbl = ArcCW.AttachmentTable[k.Installed]

        if !atttbl then continue end
        if ok and !self:CheckFlags(atttbl.ExcludeFlags, atttbl.RequireFlags) then ok = false end

        if !ok then
            self:Detach(i, true)
            continue
        end

        -- Cache all possible value modifiers
        for var, v in pairs(atttbl) do
            self.ModifiedCache[var] = true
            if var == "ToggleStats" or var == "Override_Firemodes" then
                for _, v2 in pairs(v) do
                    for var2, _ in pairs(v2) do
                        self.ModifiedCache[var2] = true
                    end
                end
            end
        end
    end

    for _, e in pairs(self.AttachmentElements) do
        for var, v in pairs(e) do
            self.ModifiedCache[var] = true
        end
    end

    for _, e in pairs(self.Firemodes) do
        for var, v in pairs(e) do
            self.ModifiedCache[var] = true
        end
    end

    if SERVER then
        local cs = self:GetCapacity() + self:GetChamberSize()

        if self:Clip1() > cs and self:Clip1() != ArcCW.BottomlessMagicNumber then
            local diff = self:Clip1() - cs
            self:SetClip1(cs)

            if self:GetOwner():IsValid() and !self:GetOwner():IsNPC() then
                self:GetOwner():GiveAmmo(diff, self.Primary.Ammo, true)
            end
        end
    else
        local se = self:GetBuff_Override("Override_ShootEntity") or self.ShootEntity
        if se then
            local path = "arccw/weaponicons/" .. self:GetClass()
            local mat = Material(path)

            if !mat:IsError() then
                local tex = mat:GetTexture("$basetexture")
                local texpath = tex:GetName()

                killicon.Add(se, texpath, Color(255, 255, 255))
            end
        end
    end

    if self:GetBuff_Override("UBGL_Capacity") then
        self.Secondary.ClipSize = self:GetBuff_Override("UBGL_Capacity")
        if GetConVar("arccw_atts_ubglautoload"):GetBool() then
            self:SetClip2(self:GetBuff_Override("UBGL_Capacity"))
        end
    else
        self.Secondary.ClipSize = -1
    end

    if self:GetBuff_Override("UBGL_Ammo") then
        self.Secondary.Ammo = self:GetBuff_Override("UBGL_Ammo")
    else
        self.Secondary.Ammo = "none"
    end

    self:RebuildSubSlots()

    local fmt = self:GetBuff_Override("Override_Firemodes", self.Firemodes)
    fmt["BaseClass"] = nil

    local fmi = self:GetFireMode()
    if !fmt[fmi] then self:SetFireMode(1) end

    self:AdjustAmmo(old_inf)
end


function SWEP:Reload()
    if IsValid(self:GetHolster_Entity()) then return end
    if self:GetHolster_Time() > 0 then return end

    if self:GetOwner():IsNPC() then
        return
    end

    if self:GetState() == ArcCW.STATE_CUSTOMIZE then
        return
    end

    -- Switch to UBGL
    if self:GetBuff_Override("UBGL") and self:GetOwner():KeyDown(IN_USE) then
        if self:GetInUBGL() then
            --net.Start("arccw_ubgl")
            --net.WriteBool(false)
            --net.SendToServer()

            self:DeselectUBGL()
        else
            --net.Start("arccw_ubgl")
            --net.WriteBool(true)
            --net.SendToServer()

            self:SelectUBGL()
        end

        return
    end

    if self:GetInUBGL() then
        if self:GetNextSecondaryFire() > CurTime() then return end
            self:ReloadUBGL()
        return
    end

    if self:GetNextPrimaryFire() >= CurTime() then return end
    -- if !game.SinglePlayer() and !IsFirstTimePredicted() then return end


    if self.Throwing then return end
    if self.PrimaryBash then return end

    -- with the lite 3D HUD, you may want to check your ammo without reloading
    local Lite3DHUD = self:GetOwner():GetInfo("arccw_hud_3dfun") == "1"
    if self:GetOwner():KeyDown(IN_WALK) and Lite3DHUD then
        return
    end

    if self:GetMalfunctionJam() then
        local r = self:MalfunctionClear()
        if r then return end
    end

    if !self:GetMalfunctionJam() and self:Ammo1() <= 0 and !self:HasInfiniteAmmo() then return end

    if self:HasBottomlessClip() then return end

    if self:GetBuff_Hook("Hook_PreReload") then return end

    -- if we must dump our clip when reloading, our reserve ammo should be more than our clip
    local dumpclip = self:GetBuff_Hook("Hook_ReloadDumpClip")
    if dumpclip and !self:HasInfiniteAmmo() and self:Clip1() >= self:Ammo1() then
        return
    end

    self.LastClip1 = self:Clip1()

    local reserve = self:Ammo1()

    reserve = reserve + self:Clip1()
    if self:HasInfiniteAmmo() then reserve = self:GetCapacity() + self:Clip1() end

    local clip = self:GetCapacity()

    local chamber = math.Clamp(self:Clip1(), 0, self:GetChamberSize())
    if self:GetNeedCycle() then chamber = 0 end

    local load = math.Clamp(clip + chamber, 0, reserve)

    if !self:GetMalfunctionJam() and load <= self:Clip1() then return end

    self:SetBurstCount(0)

    local shouldshotgunreload = self:GetBuff_Override("Override_ShotgunReload")
    local shouldhybridreload = self:GetBuff_Override("Override_HybridReload")

    if shouldshotgunreload == nil then shouldshotgunreload = self.ShotgunReload end
    if shouldhybridreload == nil then shouldhybridreload = self.HybridReload end

    if shouldhybridreload then
        shouldshotgunreload = self:Clip1() != 0
    end

    if shouldshotgunreload and self:GetShotgunReloading() > 0 then return end

    local mult = self:GetBuff_Mult("Mult_ReloadTime")
    if shouldshotgunreload then
        local anim = "sgreload_start"
        local insertcount = 0

        local empty = self:Clip1() == 0 --or self:GetNeedCycle()

        if self.Animations.sgreload_start_empty and empty then
            anim = "sgreload_start_empty"
            empty = false
            if (self.Animations.sgreload_start_empty or {}).ForceEmpty == true then
                empty = true
            end

            insertcount = (self.Animations.sgreload_start_empty or {}).RestoreAmmo or 1
        else
            insertcount = (self.Animations.sgreload_start or {}).RestoreAmmo or 0
        end

        anim = self:GetBuff_Hook("Hook_SelectReloadAnimation", anim) or anim

        local time = self:GetAnimKeyTime(anim)
        local time2 = self:GetAnimKeyTime(anim, true)

        if time2 >= time then
            time2 = 0
        end

        if insertcount > 0 then
            self:SetMagUpCount(insertcount)
            self:SetMagUpIn(CurTime() + time2 * mult)
        end
        self:PlayAnimation(anim, mult, true, 0, true, nil, true)

        self:SetReloading(CurTime() + time * mult)

        self:SetShotgunReloading(empty and 4 or 2)
    else
        local anim = self:SelectReloadAnimation()

        if !self.Animations[anim] then print("Invalid animation \"" .. anim .. "\"") return end

        self:PlayAnimation(anim, mult, true, 0, false, nil, true)

        local reloadtime = self:GetAnimKeyTime(anim, true) * mult
        local reloadtime2
        if !self.Animations[anim].ForceEnd then
            reloadtime2 = self:GetAnimKeyTime(anim, false) * mult
        else
            reloadtime2 = reloadtime
        end

        self:SetNextPrimaryFire(CurTime() + reloadtime2)
        self:SetReloading(CurTime() + reloadtime2)

        self:SetMagUpCount(0)
        self:SetMagUpIn(CurTime() + reloadtime)
    end

    self:SetClipInfo(load)
    if game.SinglePlayer() then
        self:CallOnClient("SetClipInfo", tostring(load))
    end

    for i, k in pairs(self.Attachments) do
        if !k.Installed then continue end
        local atttbl = ArcCW.AttachmentTable[k.Installed]

        if atttbl.DamageOnReload then
            self:DamageAttachment(i, atttbl.DamageOnReload)
        end
    end

    if !self.ReloadInSights then
        self:ExitSights()
        self.Sighted = false
    end

    self:GetBuff_Hook("Hook_PostReload")
end

if CLIENT then

	local function qerp(delta, a, b)
		local qdelta = -(delta ^ 2) + (delta * 2)

		qdelta = math.Clamp(qdelta, 0, 1)

		return Lerp(qdelta, a, b)
	end

	function SWEP:DoLHIKAnimation(key, time, spbitch)
		if game.SinglePlayer() and !spbitch then
			timer.Simple(0, function() if IsValid(self) then self:DoLHIKAnimation(key, time, true) end end)
			return
		end

		local vm = TFA and TFA.INS2 and IsValid(TFA.INS2.HandsEnt) and TFA.INS2.HandsEnt or self:GetOwner():GetViewModel()
		if !IsValid(vm) then return end

		local lhik_model
		local lhik_anim_model
		local LHIK_GunDriver
		local LHIK_CamDriver
		local offsetang

		local tranim = self:GetBuff_Hook("Hook_LHIK_TranslateAnimation", key)

		key = tranim or key

		for i, k in pairs(self.Attachments) do
			if !k.Installed then continue end
			if !k.VElement then continue end

			if self:GetBuff_Stat("LHIK", i) then
				lhik_model = k.VElement.Model
				lhik_anim_model = k.GodDriver and k.GodDriver.Model or false
				offsetang = k.VElement.OffsetAng

				if self:GetBuff_Stat("LHIK_GunDriver", i) then
					LHIK_GunDriver = self:GetBuff_Stat("LHIK_GunDriver", i)
				end

				if self:GetBuff_Stat("LHIK_CamDriver", i) then
					LHIK_CamDriver = self:GetBuff_Stat("LHIK_CamDriver", i)
				end
			end
		end

		if !IsValid(lhik_model) then return false end

		local seq = lhik_model:LookupSequence(key)

		if !seq then return false end
		if seq == -1 then return false end

		lhik_model:ResetSequence(seq)
		if IsValid(lhik_anim_model) then
			lhik_anim_model:ResetSequence(seq)
		end

		if !time or time < 0 then time = lhik_model:SequenceDuration(seq) end

		self.LHIKAnimation = seq
		self.LHIKAnimationStart = UnPredictedCurTime()
		self.LHIKAnimationTime = time

		self.LHIKAnimation_IsIdle = false

		if IsValid(lhik_anim_model) and LHIK_GunDriver then
			local att = lhik_anim_model:LookupAttachment(LHIK_GunDriver)
			local ang = lhik_anim_model:GetAttachment(att).Ang
			local pos = lhik_anim_model:GetAttachment(att).Pos

			self.LHIKGunAng = lhik_anim_model:WorldToLocalAngles(ang) - Angle(0, 90, 90)
			self.LHIKGunPos = lhik_anim_model:WorldToLocal(pos)

			self.LHIKGunAngVM = vm:WorldToLocalAngles(ang) - Angle(0, 90, 90)
			self.LHIKGunPosVM = vm:WorldToLocal(pos)
		end

		if IsValid(lhik_anim_model) and LHIK_CamDriver then
			local att = lhik_anim_model:LookupAttachment(LHIK_CamDriver)
			local ang = lhik_anim_model:GetAttachment(att).Ang

			self.LHIKCamOffsetAng = offsetang
			self.LHIKCamAng = lhik_anim_model:WorldToLocalAngles(ang)
		end

		-- lhik_model:SetCycle(0)
		-- lhik_model:SetPlaybackRate(dur / time)

		return true
	end


	function SWEP:DoLHIK()
		local justhide = false
		local lhik_model = nil
		local lhik_anim_model = nil
		local hide_component = false
		local delta = 1

		local vm = TFA and TFA.INS2 and IsValid(TFA.INS2.HandsEnt) and TFA.INS2.HandsEnt or self:GetOwner():GetViewModel()

		if !GetConVar("arccw_reloadincust"):GetBool() and !self.NoHideLeftHandInCustomization and !self:GetBuff_Override("Override_NoHideLeftHandInCustomization") then
			if self:GetState() == ArcCW.STATE_CUSTOMIZE then
				self.Customize_Hide = math.Approach(self.Customize_Hide, 1, FrameTime() / 0.25)
			else
				self.Customize_Hide = math.Approach(self.Customize_Hide, 0, FrameTime() / 0.25)
			end
		end

		for i, k in pairs(self.Attachments) do
			if !k.Installed then continue end
			-- local atttbl = ArcCW.AttachmentTable[k.Installed]

			-- if atttbl.LHIKHide then
			if self:GetBuff_Stat("LHIKHide", i) then
				justhide = true
			end

			if !k.VElement then continue end

			-- if atttbl.LHIK then
			if self:GetBuff_Stat("LHIK", i) then
				lhik_model = k.VElement.Model
				if k.GodDriver then
					lhik_anim_model = k.GodDriver.Model
				end
			end
		end

		if self.LHIKTimeline then
			local tl = self.LHIKTimeline

			local stage, next_stage, next_stage_index

			for i, k in pairs(tl) do
				if !k or !k.t then continue end
				if k.t + self.LHIKStartTime > UnPredictedCurTime() then
					next_stage_index = i
					break
				end
			end

			if next_stage_index then
				if next_stage_index == 1 then
					-- we are on the first stage.
					stage = {t = 0, lhik = 0}
					next_stage = self.LHIKTimeline[next_stage_index]
				else
					stage = self.LHIKTimeline[next_stage_index - 1]
					next_stage = self.LHIKTimeline[next_stage_index]
				end
			else
				stage = self.LHIKTimeline[#self.LHIKTimeline]
				next_stage = {t = self.LHIKEndTime, lhik = self.LHIKTimeline[#self.LHIKTimeline].lhik}
			end

			local local_time = UnPredictedCurTime() - self.LHIKStartTime

			local delta_time = next_stage.t - stage.t
			delta_time = (local_time - stage.t) / delta_time

			delta = qerp(delta_time, stage.lhik, next_stage.lhik)

			if lhik_model and IsValid(lhik_model) then
				local key

				if stage.lhik > next_stage.lhik then
					key = "in"
				elseif next_stage.lhik > stage.lhik then
					key = "out"
				end

				if key then
					local tranim = self:GetBuff_Hook("Hook_LHIK_TranslateAnimation", key)

					key = tranim or key

					local seq = lhik_model:LookupSequence(key)

					if seq and seq > 0 then
						lhik_model:SetSequence(seq)
						lhik_model:SetCycle(delta)
						if lhik_anim_model then
							lhik_anim_model:SetSequence(seq)
							lhik_anim_model:SetCycle(delta)
						end
					end
				end
			end

			-- if tl[4] <= UnPredictedCurTime() then
			--     -- it's over
			--     delta = 1
			-- elseif tl[3] <= UnPredictedCurTime() then
			--     -- transition back to 1
			--     delta = (UnPredictedCurTime() - tl[3]) / (tl[4] - tl[3])
			--     delta = qerp(delta, 0, 1)

			--     if lhik_model and IsValid(lhik_model) then
			--         local key = "out"

			--         local tranim = self:GetBuff_Hook("Hook_LHIK_TranslateAnimation", key)

			--         key = tranim or key

			--         local seq = lhik_model:LookupSequence(key)

			--         if seq and seq > 0 then
			--             lhik_model:SetSequence(seq)
			--             lhik_model:SetCycle(delta)
			--         end
			--     end
			-- elseif tl[2] <= UnPredictedCurTime() then
			--     -- hold 0
			--     delta = 0
			-- elseif tl[1] <= UnPredictedCurTime() then
			--     -- transition to 0
			--     delta = (UnPredictedCurTime() - tl[1]) / (tl[2] - tl[1])
			--     delta = qerp(delta, 1, 0)

			--     if lhik_model and IsValid(lhik_model) then
			--         local key = "in"

			--         local tranim = self:GetBuff_Hook("Hook_LHIK_TranslateAnimation", key)

			--         key = tranim or key

			--         local seq = lhik_model:LookupSequence(key)

			--         if seq and seq > 0 then
			--             lhik_model:SetSequence(seq)
			--             lhik_model:SetCycle(delta)
			--         end
			--     end
		else
			-- hasn't started yet
			delta = 1
		end

		if delta == 1 and self.Customize_Hide > 0 then
			if !lhik_model or !IsValid(lhik_model) then
				justhide = true
				delta = math.min(self.Customize_Hide, delta)
			else
				hide_component = true
			end
		end

		if justhide then
			for _, bone in pairs(ArcCW.LHIKBones) do
				local vmbone = vm:LookupBone(bone)

				if !vmbone then continue end -- Happens when spectating someone prolly

				local vmtransform = vm:GetBoneMatrix(vmbone)

				if !vmtransform then continue end -- something very bad has happened

				local vm_pos = vmtransform:GetTranslation()
				local vm_ang = vmtransform:GetAngles()

				local newtransform = Matrix()

				newtransform:SetTranslation(LerpVector(delta, vm_pos, vm_pos - (EyeAngles():Up() * 12) - (EyeAngles():Forward() * 12) - (EyeAngles():Right() * 4)))
				newtransform:SetAngles(vm_ang)

				vm:SetBoneMatrix(vmbone, newtransform)
			end
		end

		if !lhik_model or !IsValid(lhik_model) then return end

		lhik_model:SetupBones()

		if justhide then return end

		local cyc = (UnPredictedCurTime() - self.LHIKAnimationStart) / self.LHIKAnimationTime

		if self.LHIKAnimation and cyc < 1 then
			lhik_model:SetSequence(self.LHIKAnimation)
			lhik_model:SetCycle(cyc)
			if IsValid(lhik_anim_model) then
				lhik_anim_model:SetSequence(self.LHIKAnimation)
				lhik_anim_model:SetCycle(cyc)
			end
		else
			local key = "idle"

			local tranim = self:GetBuff_Hook("Hook_LHIK_TranslateAnimation", key)

			key = tranim or key

			if key and key != "DoNotPlayIdle" then
				self:DoLHIKAnimation(key, -1)
			end

			self.LHIKAnimation_IsIdle = true
		end

		local cf_deltapos = Vector(0, 0, 0)
		local cf = 0


		for _, bone in pairs(ArcCW.LHIKBones) do
			local vmbone = vm:LookupBone(bone)
			local lhikbone = lhik_model:LookupBone(bone)

			if !vmbone then continue end
			if !lhikbone then continue end

			local vmtransform = vm:GetBoneMatrix(vmbone)
			local lhiktransform = lhik_model:GetBoneMatrix(lhikbone)

			if !vmtransform then continue end
			if !lhiktransform then continue end

			local vm_pos = vmtransform:GetTranslation()
			local vm_ang = vmtransform:GetAngles()
			local lhik_pos = lhiktransform:GetTranslation()
			local lhik_ang = lhiktransform:GetAngles()

			local newtransform = Matrix()

			newtransform:SetTranslation(LerpVector(delta, vm_pos, lhik_pos))
			newtransform:SetAngles(LerpAngle(delta, vm_ang, lhik_ang))

			if !self:GetBuff_Override("LHIK_GunDriver") and self.LHIKDelta[lhikbone] and self.LHIKAnimation and cyc < 1 then
				local deltapos = lhik_model:WorldToLocal(lhik_pos) - self.LHIKDelta[lhikbone]

				if !deltapos:IsZero() then
					cf_deltapos = cf_deltapos + deltapos
					cf = cf + 1
				end
			end

			self.LHIKDelta[lhikbone] = lhik_model:WorldToLocal(lhik_pos)

			if hide_component then
				local new_pos = newtransform:GetTranslation()
				newtransform:SetTranslation(LerpVector(self.Customize_Hide, new_pos, new_pos - (EyeAngles():Up() * 12) - (EyeAngles():Forward() * 12) - (EyeAngles():Right() * 4)))
			end

			local matrix = Matrix(newtransform)

			vm:SetBoneMatrix(vmbone, matrix)

			-- local vm_pos, vm_ang = vm:GetBonePosition(vmbone)
			-- local lhik_pos, lhik_ang = lhik_model:GetBonePosition(lhikbone)

			-- local pos = LerpVector(delta, vm_pos, lhik_pos)
			-- local ang = LerpAngle(delta, vm_ang, lhik_ang)

			-- vm:SetBonePosition(vmbone, pos, ang)
		end

		if !cf_deltapos:IsZero() and cf > 0 and self:GetBuff_Override("LHIK_Animation") then
			local new = Vector(0, 0, 0)
			local viewmult = self:GetBuff_Override("LHIK_MovementMult") or 1

			new[1] = cf_deltapos[2] * viewmult
			new[2] = cf_deltapos[1] * viewmult
			new[3] = cf_deltapos[3] * viewmult

			self.ViewModel_Hit = LerpVector(0.25, self.ViewModel_Hit, new / cf):GetNormalized()
		end
	end
end

function SWEP:FireRocket(ent, vel, ang, dontinheritvel)
    if CLIENT then return end

    local rocket = ents.Create(ent)

    ang = ang or (self:GetOwner():EyeAngles() + self:GetFreeAimOffset())

    local src = self:GetShootSrc()

    if !rocket:IsValid() then print("!!! INVALID ROUND " .. ent) return end

    local rocketAng = Angle(ang.p, ang.y, ang.r)
    if ang and self.ShootEntityAngleCorrection then
        local up = ang:Up()
        local right = ang:Right()
        local forward = ang:Forward()
        rocketAng:RotateAroundAxis(up, self.ShootEntityAngleCorrection.y)
        rocketAng:RotateAroundAxis(right, self.ShootEntityAngleCorrection.p)
        rocketAng:RotateAroundAxis(forward, self.ShootEntityAngleCorrection.r)
    end

    rocket:SetAngles(rocketAng)
    rocket:SetPos(src)

    rocket:SetOwner(self:GetOwner())

    rocket.Inflictor = self
	rocket.SpawnTime = CurTime()

    local randfactor = self:GetBuff("DamageRand")
    local mul = 1
    if randfactor > 0 then
        mul = mul * math.Rand(1 - randfactor, 1 + randfactor)
    end
    rocket.Damage = self:GetBuff("Damage") * mul

    if self.BlastRadius then
        local r_randfactor = self:GetBuff("DamageRand")
        local r_mul = 1
        if r_randfactor > 0 then
            r_mul = r_mul * math.Rand(1 - r_randfactor, 1 + r_randfactor)
        end
        rocket.BlastRadius = self:GetBuff("BlastRadius") * r_mul
    end

    local RealVelocity = (!dontinheritvel and self:GetOwner():GetAbsVelocity() or Vector(0, 0, 0)) + ang:Forward() * vel
    rocket.CurVel = RealVelocity -- for non-physical projectiles that move themselves

    rocket:Spawn()
    rocket:Activate()
    if !rocket.NoPhys and rocket:GetPhysicsObject():IsValid() then
        rocket:SetCollisionGroup(rocket.CollisionGroup or COLLISION_GROUP_DEBRIS)
        rocket:GetPhysicsObject():SetVelocityInstantaneous(RealVelocity)
    end

    if rocket.Launch and rocket.SetState then
        rocket:SetState(1)
        rocket:Launch()
    end

    if rocket.ArcCW_Killable == nil then
        rocket.ArcCW_Killable = true
    end

    rocket.ArcCWProjectile = true

    self:GetBuff_Hook("Hook_PostFireRocket", rocket)

    return rocket
end
