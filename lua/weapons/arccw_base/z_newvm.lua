local function qerp(delta, a, b)
    local qdelta = -(delta ^ 2) + (delta * 2)

    qdelta = math.Clamp(qdelta, 0, 1)

    return Lerp(qdelta, a, b)
end

if CLIENT then
    local lastproceed = 0
    hook.Add("PreDrawViewModel", "ArcCW_NewVM", function(vm, ply,wep)
        --if true then return end
        if IsValid(wep.REAL_VM) and !wep.REAL_VM.Not_Stated then

            if wep:GetState() == ArcCW.STATE_CUSTOMIZE then
                wep:BlurNotWeapon()
            end
        
            if GetConVar("arccw_cheapscopesautoconfig"):GetBool() then
                local fps = 1 / (SysTime() - lst2)
                lst2 = SysTime()
                local lowfps = fps <= 45
                GetConVar("arccw_cheapscopes"):SetBool(lowfps)
                GetConVar("arccw_cheapscopesautoconfig"):SetBool(false)
            end
        
            local asight = wep:GetActiveSights()
        
            if asight and ((GetConVar("arccw_cheapscopes"):GetBool() and wep:GetSightDelta() < 1 and asight.MagnifiedOptic)
                    or (wep:GetSightDelta() < 1 and asight.ScopeTexture)) then
                -- Necessary to call here since physbullets are not drawn until PreDrawEffects; cheap scope implementation will not allow them to be visible
                -- Introduces a bug when we try to call GetAttachment on the viewmodel in DrawPhysBullets here, so set a workaround variable to not call it
                ArcCW:DrawPhysBullets(true)
                wep:FormCheapScope()
            end

            local ct = CurTime()

            local coolFOV = --120 or 
            wep.CurrentViewModelFOV or wep.ViewModelFOV
        
            if ArcCW.VMInRT then
                local mag = asight.ScopeMagnification
                coolFOV = wep.ViewModelFOV - mag * 4 - (GetConVar("arccw_vm_add_ads"):GetFloat() * 3 or 0)
                ArcCW.VMInRT = false
            end
        
            cam.Start3D(EyePos(), EyeAngles(), wep:QuickFOVix(coolFOV), nil, nil, nil, nil, 0.5, 1000)
            cam.IgnoreZ(true)
            wep:DrawCustomModel(false)
            wep:DoLHIK()
        
            if !ArcCW.Overdraw then
                wep:DoLaser(false, true)
            end

            local vm_real = wep.REAL_VM
            if !IsValid(vm_real) then
                wep:createCustomVM(wep.ViewModel)
                vm_real = wep.REAL_VM
            end
            local frmtime = FrameTime()
            if ct - lastproceed > frmtime * 2 then
                vm_real.EndOn = 0
            end
            if (vm_real.EndOn or 0) <= 35 then
                local pos, ang = wep:GetViewModelPosition(ply:EyePos(), ply:EyeAngles())
                vm_real:SetPos(pos)
                vm_real:SetAngles( ang )
                vm_real:SetParent( ply:GetViewModel() )
                vm_real.EndOn = (vm_real.EndOn or 0) + 1
            end
            
            vm_real:SetRenderMode( RENDERMODE_TRANSALPHA )
            vm_real:SetColor( Color( wep:GetColor().r, wep:GetColor().b, wep:GetColor().g, 255 ) )

            local playbackrate = vm_real:GetPlaybackRate()
            wep:SetAnimationProgress( math.min(
                wep:GetAnimationProgress() + frmtime * playbackrate / vm_real:SequenceDuration(),
                1
                )
            )
            --print(math.Round(wep:GetAnimationProgress(), 5), math.Round(vm_real:SequenceDuration(), 5), vm_real:GetPlaybackRate(), wep.LastAnimKey)
            if wep.UseHands then
                local hands = ply:GetHands()
                
                if IsValid(hands) then
                    hands:AddEffects(EF_BONEMERGE)
                    hands:SetParent(vm_real)
                end
            end
            hook.Run("PreDrawPlayerHands", ply:GetHands(), wep.REAL_VM, ply, wep)

            if vm_real:LookupBone("R ForeTwist") and not vm_real:LookupBone("ValveBiped.Bip01_R_Hand") then
                local HandsEnt = vm_real.Hands
                if not IsValid(HandsEnt) then
                    vm_real.Hands = ClientsideModel("models/weapons/tfa_ins2/c_ins2_pmhands.mdl")
                    vm_real.Hands:SetNoDraw(true)
        
                    HandsEnt = vm_real.Hands
                end
        
                HandsEnt:SetParent(vm_real)
                HandsEnt:SetPos(vm_real:GetPos())
                HandsEnt:SetAngles(vm_real:GetAngles())
        
                if not HandsEnt:IsEffectActive(EF_BONEMERGE) then
                    HandsEnt:AddEffects(EF_BONEMERGE)
                    HandsEnt:AddEffects(EF_BONEMERGE_FASTCULL)
                end
        
                ply:GetHands():SetParent(HandsEnt)
            end

            ply:GetHands():DrawModel()
            vm_real:DrawModel()
            render.SetBlend(1)
            cam.End3D()
            cam.Start3D(EyePos(), EyeAngles(), wep:QuickFOVix(wep.CurrentViewModelFOV or wep.ViewModelFOV), nil, nil, nil, nil, 0.5, 1000)
            cam.IgnoreZ(true)

            if ArcCW.Overdraw then
                ArcCW.Overdraw = false
            else
                --self:DoLaser()
                wep:DoHolosight()
            end

            cam.End3D()
            lastproceed = ct
            return true
        end
    end)

    function SWEP:GetAnimationProgress()
        return self.REAL_VM:GetCycle()
    end

    function SWEP:SetAnimationProgress(cycle)
        return self.REAL_VM:SetCycle(cycle)
    end

    net.Receive("arccw_sync_anim", function(len, ply)
        local wep    = LocalPlayer():GetActiveWeapon()
        local key    = net.ReadString()
        local mul    = net.ReadFloat()
        local start  = net.ReadFloat()
        local time   = net.ReadBool()
        --local skip   = net.ReadBool() Unused
        local ignore = net.ReadBool()
    
        if !IsValid(wep) or !wep.ArcCW then return end

        --[[local vm_real = wep.REAL_VM

        if vm_real.EndOn >= 35 then
            vm_real.EndOn = 0
        end]]

        wep:PlayAnimation(key, mul, false, start, time, false, ignore)

        timer.Create("arccw_sync_anim" .. wep:EntIndex(), 0, 8, function()
            wep = LocalPlayer():GetActiveWeapon()
            if IsValid(wep) and wep.LastAnimKey != key then
                wep:PlayAnimation(key, mul, false, start, time, false, ignore)
            end
        end)
    end)

    --[[local old = SWEP.DrawHUD
    function SWEP:DrawHUD()
        surface.SetTextPos(300, 500)
        surface.SetFont("ArcCW_26")
        surface.SetTextColor(255, 255, 255, 255)
        surface.SetDrawColor(0, 0, 0, 63)
        surface.DrawText( tostring(wep:GetAnimationProgress()) )
        return old(self)
    end]]
else
    --- SERVER
    util.AddNetworkString("arccw_sync_anim")

    local getcycle_on = 0
    local getcycle_progress = 0

    SWEP.Cycle_Progress = 0
    SWEP.Cycle_Progress_SaveOn = 0
    SWEP.Cycle_AnimDur = 0
    SWEP.Cycle_LastAnimRate = 0

    function SWEP:SaveCycleProgress()
        self.Cycle_Progress = self:GetAnimationProgress()
        self.Cycle_Progress_SaveOn = CurTime()
    end

    function SWEP:CalculateCycle()
        local vm = self.REAL_VM
        --local animstart = self.LastAnimStartTime

        local animrate = vm:GetPlaybackRate()
        self.Cycle_LastAnimRate = animrate

        local dur = self:GetNextIdle() - self.LastAnimStartTime
        self.Cycle_AnimDur = dur / animrate
        self:SaveCycleProgress()
    end

    function SWEP:GetAnimationProgress()
        local ct = CurTime()
        if getcycle_on != ct then
            getcycle_on = ct

            local cycleprogress = self.Cycle_Progress
            local anim_dur = self.Cycle_AnimDur

            getcycle_progress = cycleprogress + (ct - (self.Cycle_Progress_SaveOn or self.LastAnimStartTime)) / anim_dur
        end
        return getcycle_progress
    end

    function SWEP:ChangeAnimSpeed(speed)
        local vm = self.REAL_VM

        vm:SetPlaybackRate(speed)
        self:CalculateCycle()
    end
end

--local idleon = 0
function SWEP:PlayIdleAnimation(pred)
    local ianim = self:SelectAnimation("idle")
    if self:GetGrenadePrimed() then
        ianim = self:GetGrenadeAlt() and self:SelectAnimation("pre_throw_hold_alt") or self:SelectAnimation("pre_throw_hold")
    end

    -- (key, mult, pred, startfrom, tt, skipholster, ignorereload)
    if self:GetBuff_Override("UBGL_BaseAnims") and self:GetInUBGL()
            and self.Animations.idle_ubgl_empty and self:Clip2() <= 0 then
        ianim = "idle_ubgl_empty"
    elseif self:GetBuff_Override("UBGL_BaseAnims") and self:GetInUBGL() and self.Animations.idle_ubgl then
        ianim = "idle_ubgl"
    end

    if self.LastAnimKey != ianim then
        ianim = self:GetBuff_Hook("Hook_IdleReset", ianim) or ianim
    end
    
    --if CLIENT and CurTime() > idleon then print("idle", CurTime(), self:GetNextIdle(), self.LastAnimKey) idleon = CurTime() + .1 end

    self:PlayAnimation(ianim, 1, pred, nil, nil, nil, true)
end

local ang0 = Angle(0, 0, 0)
local dev_alwaysready = GetConVar("arccw_dev_alwaysready")
function SWEP:Deploy()
    if !IsValid(self:GetOwner()) or self:GetOwner():IsNPC() then
        return
    end

    if !IsFirstTimePredicted() then
        return
    end
    if CLIENT and IsValid(self.REAL_VM) then
        local vm_real = self.REAL_VM
        vm_real.EndOn = 0
    end

    if self.UnReady then
        local sp = game.SinglePlayer()

        if sp then
            if SERVER then
                self:CallOnClient("LoadPreset", "autosave")
            else
                self:LoadPreset("autosave")
            end
        else
            if SERVER then
                -- the server... can't get the client's attachments in time.
                -- can make it so client has to do a thing and tell the server it's ready,
                -- and that's probably what i'll do later.
            else
                self:LoadPreset("autosave")
            end
        end
    end

    self:InitTimers()

    self:SetShouldHoldType()

    self:SetReloading(false)
    self:SetPriorityAnim(false)
    self:SetInUBGL(false)
    self:SetMagUpCount(0)
    self:SetMagUpIn(0)
    self:SetShotgunReloading(0)
    self:SetHolster_Time(0)
    self:SetHolster_Entity(NULL)

    self:SetFreeAimAngle(ang0)
    self:SetLastAimAngle(ang0)

    self.LHIKAnimation = nil
    self.CrosshairDelta = 0

    self:SetBurstCount(0)

    self:WepSwitchCleanup()
    if game.SinglePlayer() then self:CallOnClient("WepSwitchCleanup") end

    if !self:GetOwner():InVehicle() then -- Don't play anim if in vehicle. This can be caused by HL2 level changes
        local prd = false

        local r_anim = self:SelectAnimation("ready")
        local d_anim = self:SelectAnimation("draw")

        if self.Animations[r_anim] and ( dev_alwaysready:GetBool() or self.UnReady ) then
            self:PlayAnimation(r_anim, 1, true, 0, false, nil, true, nil, {SyncWithClient = true})
            prd = self.Animations[r_anim].ProcDraw

            self:SetPriorityAnim(CurTime() + self:GetAnimKeyTime(r_anim, true) )
        elseif self.Animations[d_anim] then
            self:PlayAnimation(d_anim, self:GetBuff_Mult("Mult_DrawTime"), true, 0, false, nil, nil, nil, {SyncWithClient = true})
            prd = self.Animations[d_anim].ProcDraw

            self:SetPriorityAnim(CurTime() + self:GetAnimKeyTime(d_anim, true) * self:GetBuff_Mult("Mult_DrawTime"))
        end

        if prd or (!self.Animations[r_anim] and !self.Animations[d_anim]) then
            self:ProceduralDraw()
        end
    end

    self:SetState(ArcCW.STATE_DISABLE)

    if self.UnReady then
        if SERVER then
            self:InitialDefaultClip()
        end
        self.UnReady = false
    end

    if self:GetBuff_Override("Override_AutoReload", self.AutoReload) then
        self:RestoreAmmo()
    end

    timer.Simple(0, function()
        if IsValid(self) then self:SetupModel(false) end
    end)

    if SERVER then
        self:SetupShields()
        -- Networking the weapon at this time is too early - entity is not yet valid on client
        -- Instead, make client send a request when it is valid there
        --self:NetworkWeapon()
    elseif CLIENT and !self.CertainAboutAtts then
        net.Start("arccw_rqwpnnet")
            net.WriteEntity(self)
        net.SendToServer()
    end

    -- self:RefreshBGs()

    self:GetBuff_Hook("Hook_OnDeploy")

    return true
end

function SWEP:Holster(wep)
    if !IsFirstTimePredicted() then return end
    if self:GetOwner():IsNPC() then return end
    
    if CLIENT and self:GetOwner() == LocalPlayer() and ArcCW.InvHUD then ArcCW.InvHUD:Remove() end

    if self:GetBurstCount() > 0 and self:Clip1() > self:GetBuff("AmmoPerShot") then return false end
    if CLIENT and LocalPlayer() != self:GetOwner() then
        return
    end

    if self:GetGrenadePrimed() then
        self:GrenadeDrop(true)
    end

    self:WepSwitchCleanup()
    if game.SinglePlayer() then self:CallOnClient("WepSwitchCleanup") end

    if wep == self then self:Deploy() return false end
    if self:GetHolster_Time() > CurTime() then return false end

    -- Props deploy to NULL, finish holster on NULL too
    if (self:GetHolster_Time() != 0 and self:GetHolster_Time() <= CurTime()) or !IsValid(wep) then
        self:SetHolster_Time(0)
        self:SetHolster_Entity(NULL)
        self:FinishHolster()
        self:GetBuff_Hook("Hook_OnHolsterEnd")
        return true
    else
        self:SetHolster_Entity(wep)

        if self:GetGrenadePrimed() then
            self:Throw()
        end

        self.Sighted = false
        self.Sprinted = false
        self:SetShotgunReloading(0)
        self:SetMagUpCount(0)
        self:SetMagUpIn(0)

        local time = 0.25
        local anim = self:SelectAnimation("holster")
        if anim then
            local prd = self.Animations[anim].ProcHolster
            time = self:GetAnimKeyTime(anim)
            if prd then
                self:ProceduralHolster()
                time = 0.25
            end
            self:PlayAnimation(anim, self:GetBuff_Mult("Mult_DrawTime"), true, nil, nil, nil, true, nil, {SyncWithClient = true})
            self:SetHolster_Time(CurTime() + time * self:GetBuff_Mult("Mult_DrawTime"))
        else
            self:ProceduralHolster()
            self:SetHolster_Time(CurTime() + time * self:GetBuff_Mult("Mult_DrawTime"))
        end
        self:SetPriorityAnim(CurTime() + time * self:GetBuff_Mult("Mult_DrawTime"))
        self:SetWeaponOpDelay(CurTime() + time * self:GetBuff_Mult("Mult_DrawTime"))

        self:GetBuff_Hook("Hook_OnHolster")
    end
end

function SWEP:createCustomVM(mdl)
    local ply = self:GetOwner()
    if SERVER then
        self.REAL_VM = ply:GetViewModel()
        return
    end
    local vm = ply:GetViewModel()
    --self.REAL_VM = vm
    --self.REAL_VM.Not_Stated = true

    if self.REAL_VM then
        return
    end
    
    self.REAL_VM = ClientsideModel(mdl, RENDERGROUP_BOTH)
    self.REAL_VM:SetNoDraw(true)
    self.REAL_VM:SetupBones()
    self.REAL_VM:SetParent(vm)
    self.REAL_VM.CreateTime = CurTime()
    self.REAL_VM.EndOn = 0
    self.REAL_VM:SetCycle(0)

    local pos, ang = self:GetViewModelPosition(ply:EyePos(), ply:EyeAngles())
    if pos and ang then
        self.REAL_VM:SetPos(pos)
        self.REAL_VM:SetAngles( ang )
    end
    
    if self.ViewModelFlip then
        local mtr = Matrix()
        mtr:Scale(Vector(1, -1, 1))
        
        self.REAL_VM:EnableMatrix("RenderMultiply", mtr)
    end
end

function SWEP:DrawCustomModel(wm, origin, angle)
    if ArcCW.VM_OverDraw then return end
    local owner = self:GetOwner()
    local disttoeye = self:GetPos():DistToSqr(EyePos())
    local visibility = math.pow(GetConVar("arccw_visibility"):GetInt(), 2)
    local always = false
    if GetConVar("arccw_visibility"):GetInt() < 0 or self:GetOwner() == LocalPlayer() then
        always = true
    end
    local models = self.VM
    local vm

    if origin and !angle then
        angle = Angle()
    end
    local custompos = origin and angle
    if custompos then
        wm = true --VM drawing borked
    end

    -- self:KillModel(self.VM)
    -- self:KillModel(self.WM)
    -- self.VM = nil
    -- self.WM = nil

    local vscale = 1

    if wm then
        if !always and disttoeye >= visibility * 2 then return end

        if !self.WM then
            self:SetupModel(wm)
        end

        models = self.WM

        vm = owner

        if self.MirrorVMWM or !IsValid(owner) then
            vm = self.WMModel or self
        end

        if self.WorldModelOffset then
            vscale = self.WorldModelOffset.scale or 1
        end

        if !vm or !IsValid(vm) then return end
    else
        if !self.VM then
            self:SetupModel(wm)
        end

        vm = self.REAL_VM

        if !vm or !IsValid(vm) then return end

        models = self.VM

        -- if self.HSPElement then
        --     self.HSPElement.Model:DrawModel()
        -- end
    end

    for i, k in pairs(models) do
        if !IsValid(k.Model) then
            self:SetupModel(wm)
            return
        end

        -- local asight = self:GetActiveSights()

        -- if asight then
        --     local activeslot = asight.Slot
        --     if k.Slot == activeslot and ArcCW.Overdraw then
        --         continue
        --     end
        -- end

        if k.IsBaseVM and !custompos then
            k.Model:SetParent(self.REAL_VM)
            vm = self
            selfmode = true
            basewm = true
        elseif k.IsBaseWM then
            if IsValid(owner) and !custompos then
                local wmo = self.WorldModelOffset
                if !wmo then
                    wmo = {pos = Vector(0, 0, 0), ang = Angle(0, 0, 0)}
                end
                k.Model:SetParent(owner)
                vm = owner
                k.OffsetAng = wmo.ang
                k.OffsetPos = wmo.pos
            else
                k.Model:SetParent(self)
                vm = self
                selfmode = true
                basewm = true
                k.OffsetAng = Angle(0, 0, 0)
                k.OffsetPos = Vector(0, 0, 0)
            end
        elseif wm and self:ShouldCheapWorldModel() then
            continue
        else
            if wm and self.MirrorVMWM then
                vm = self.WMModel or self
                -- vm = self
            end

            if wm and !always and disttoeye >= visibility then
                continue
            end
        end

        if k.BoneMerge and !k.NoDraw then
            k.Model:DrawModel()
            continue
        end

        local bonename = k.Bone

        if wm then
            bonename = k.WMBone or "ValveBiped.Bip01_R_Hand"
        end

        local bpos, bang
        local offset = k.OffsetPos

        if k.IsBaseWM and !IsValid(self:GetOwner()) then
            bpos = self:GetPos()
            bang = self:GetAngles()
        elseif bonename then
            local boneindex = vm:LookupBone(bonename)

            if !boneindex then continue end

            if wm then
                bpos, bang = vm:GetBonePosition(boneindex)
            else
                local bonemat = vm:GetBoneMatrix(boneindex)

                if bonemat then
                    bpos = bonemat:GetTranslation()
                    bang = bonemat:GetAngles()
                end
            end

            if custompos and (!self.MirrorVMWM or (self.MirrorVMWM and k.Model:GetModel() == self.ViewModel) ) then
                bpos = origin
                bang = angle
            end

            if k.Slot then

                local attslot = self.Attachments[k.Slot]

                local delta = attslot.SlidePos or 0.5

                local vmelemod = nil
                local wmelemod = nil
                local slidemod = nil

                for _, e in pairs(self:GetActiveElements(true)) do
                    local ele = self.AttachmentElements[e]

                    if !ele then continue end

                    if ((ele.AttPosMods or {})[k.Slot] or {}).vpos then
                        vmelemod = ele.AttPosMods[k.Slot].vpos
                        if self.MirrorVMWM then
                            wmelemod = ele.AttPosMods[k.Slot].vpos
                        end
                    end

                    if !self.MirrorVMWM then
                        if ((ele.AttPosMods or {})[k.Slot] or {}).wpos then
                            wmelemod = ele.AttPosMods[k.Slot].wpos
                        end
                    end

                    if ((ele.AttPosMods or {})[k.Slot] or {}).slide then
                        slidemod = ele.AttPosMods[k.Slot].slide
                    end

                    -- Why the fuck is it called 'slide'. Call it fucking SlideAmount like it is
                    -- in the fucking attachment slot you fucking cockfuck shitdick
                    if ((ele.AttPosMods or {})[k.Slot] or {}).SlideAmount then
                        slidemod = ele.AttPosMods[k.Slot].SlideAmount
                    end
                end

                if wm and !self.MirrorVMWM then
                    offset = wmelemod or (attslot.Offset or {}).wpos or Vector(0, 0, 0)

                    if attslot.SlideAmount then
                        offset = LerpVector(delta, (slidemod or attslot.SlideAmount).wmin or Vector(0, 0, 0), (slidemod or attslot.SlideAmount).wmax or Vector(0, 0, 0))
                    end
                else
                    offset = vmelemod or (attslot.Offset or {}).vpos or Vector(0, 0, 0)

                    if attslot.SlideAmount then
                        offset = LerpVector(delta, (slidemod or attslot.SlideAmount).vmin or Vector(0, 0, 0), (slidemod or attslot.SlideAmount).vmax or Vector(0, 0, 0))
                    end

                    attslot.VMOffsetPos = offset
                end

            end

        end

        local apos, aang

        if k.CharmParent and IsValid(k.CharmParent.Model) then
            local cm = k.CharmParent.Model
            local boneindex = cm:LookupAttachment(k.CharmAtt)
            local angpos = cm:GetAttachment(boneindex)
            if angpos then
                apos, aang = angpos.Pos, angpos.Ang

                local pos = k.CharmOffset
                local ang = k.CharmAngle
                local scale = k.CharmScale or Vector(1, 1, 1)

                apos = apos + aang:Forward() * pos.x * scale.x
                apos = apos + aang:Right() * pos.y * scale.y
                apos = apos + aang:Up() * pos.z * scale.z

                aang:RotateAroundAxis(aang:Right(), ang.p)
                aang:RotateAroundAxis(aang:Up(), ang.y)
                aang:RotateAroundAxis(aang:Forward(), ang.r)
            end
        elseif bang and bpos then

            local pos = offset or Vector(0, 0, 0)
            local ang = k.OffsetAng or Angle(0, 0, 0)

            pos = pos * vscale

            local moffset = (k.ModelOffset or Vector(0, 0, 0))

            apos = bpos + bang:Forward() * pos.x
            apos = apos + bang:Right() * pos.y
            apos = apos + bang:Up() * pos.z

            aang = Angle()
            aang:Set(bang)

            aang:RotateAroundAxis(aang:Right(), ang.p)
            aang:RotateAroundAxis(aang:Up(), ang.y)
            aang:RotateAroundAxis(aang:Forward(), ang.r)

            apos = apos + aang:Forward() * moffset.x
            apos = apos + aang:Right() * moffset.y
            apos = apos + aang:Up() * moffset.z
        else
            continue
        end

        if !apos or !aang then return end

        k.Model:SetPos(apos)
        k.Model:SetAngles(aang)
        k.Model:SetRenderOrigin(apos)
        k.Model:SetRenderAngles(aang)

        if k.Bodygroups then
            k.Model:SetBodyGroups(k.Bodygroups)
        end

        if k.DrawFunc then
            k.DrawFunc(self, k, wm)
        end

        if !k.NoDraw then
            k.Model:DrawModel()
        end

        -- FIXME: activeslot is nil?
        if i != activeslot and ArcCW.Overdraw then
            k.Model:SetBodygroup(1, 0)
        end
    end

    if wm then
        self:DrawFlashlightsWM()
        -- self:KillFlashlightsVM()
    else
        self:DrawFlashlightsVM()
    end

    -- self:RefreshBGs()
end

function SWEP:PlayAnimation(key, mult, pred, startfrom, tt, skipholster, priority, absolute, otherdata)
    mult = mult or 1
    pred = pred or false
    startfrom = startfrom or 0
    tt = tt or false
    
    --if key != "idle" then print("-----------------------") print(key) end
    --skipholster = skipholster or false Unused
    priority = priority or false
    absolute = absolute or false
    otherdata = otherdata or {}

    if !key then return end
 
    local ct = CurTime()

    if self:GetPriorityAnim() and !priority then return end
    
    if SERVER and (game.SinglePlayer() and pred or otherdata.SyncWithClient) then
    --if SERVER and pred then
        net.Start("arccw_sync_anim")
        net.WriteString(key)
        net.WriteFloat(mult)
        net.WriteFloat(startfrom)
        net.WriteBool(tt)
        --net.WriteBool(skipholster) Unused
        net.WriteBool(otherdata.SyncWithClient or !otherdata.SyncWithClient and priority)
        net.Send(self:GetOwner())
    end

    local anim = self.Animations[key]
    if !anim then return end
    local tranim = self:GetBuff_Hook("Hook_TranslateAnimation", key)
    if self.Animations[tranim] then
        key = tranim
        anim = self.Animations[tranim]
    --[[elseif self.Animations[key] then -- Can't do due to backwards compatibility... unless you have a better idea?
        anim = self.Animations[key]
    else
        return]]
    end

    if anim.ViewPunchTable and CLIENT then
        for k, v in pairs(anim.ViewPunchTable) do

            if !v.t then continue end

            local st = (v.t * mult) - startfrom

            if isnumber(v.t) and st >= 0 and self:GetOwner():IsPlayer() and (game.SinglePlayer() or IsFirstTimePredicted()) then
                self:SetTimer(st, function() self:OurViewPunch(v.p or Vector(0, 0, 0)) end, id)
            end
        end
    end

    if isnumber(anim.ShellEjectAt) then
        self:SetTimer(anim.ShellEjectAt * mult, function()
            local num = 1
            if self.RevolverReload then
                num = self.Primary.ClipSize - self:Clip1()
            end
            for i = 1,num do
                self:DoShellEject()
            end
        end)
    end

    if !self:GetOwner() then return end
    if !self:GetOwner().GetViewModel then return end

    local vm = self.REAL_VM

    if !vm then return end
    if !IsValid(vm) then return end

    local seq = anim.Source
    if anim.RareSource and util.SharedRandom("raresource", 0, 1, CurTime()) < (1 / (anim.RareSourceChance or 100)) then
        seq = anim.RareSource
    end
    seq = self:GetBuff_Hook("Hook_TranslateSequence", seq)

    if istable(seq) then
        seq["BaseClass"] = nil
        seq = seq[math.Round(util.SharedRandom("randomseq" .. CurTime(), 1, #seq))]
    end

    if isstring(seq) then
        seq = vm:LookupSequence(seq)
    end

    local time = absolute and 1 or self:GetAnimKeyTime(key)
    --if time == 0 then return end

    local ttime = (time * mult) - startfrom
    if startfrom > (time * mult) then return end

    if tt then
        self:SetNextPrimaryFire(ct + ((anim.MinProgress or time) * mult) - startfrom)
    end

    if anim.LHIK then
        self.LHIKStartTime = ct
        self.LHIKEndTime = ct + ttime

        if anim.LHIKTimeline then
            self.LHIKTimeline = {}

            for i, k in pairs(anim.LHIKTimeline) do
                table.Add(self.LHIKTimeline, {t = (k.t or 0) * mult, lhik = k.lhik or 1})
            end
        else
            self.LHIKTimeline = {
                {t = -math.huge, lhik = 1},
                {t = ((anim.LHIKIn or 0.1) - (anim.LHIKEaseIn or anim.LHIKIn or 0.1)) * mult, lhik = 1},
                {t = (anim.LHIKIn or 0.1) * mult, lhik = 0},
                {t = ttime - ((anim.LHIKOut or 0.1) * mult), lhik = 0},
                {t = ttime - (((anim.LHIKOut or 0.1) - (anim.LHIKEaseOut or anim.LHIKOut or 0.1)) * mult), lhik = 1},
                {t = math.huge, lhik = 1}
            }

            if anim.LHIKIn == 0 then
                self.LHIKTimeline[1].lhik = -math.huge
                self.LHIKTimeline[2].lhik = -math.huge
            end

            if anim.LHIKOut == 0 then
                self.LHIKTimeline[#self.LHIKTimeline - 1].lhik = math.huge
                self.LHIKTimeline[#self.LHIKTimeline].lhik = math.huge
            end
        end
    else
        self.LHIKTimeline = nil
    end

    if anim.LastClip1OutTime then
        self.LastClipOutTime = ct + ((anim.LastClip1OutTime * mult) - startfrom)
    end

    if anim.TPAnim then
        local aseq = self:GetOwner():SelectWeightedSequence(anim.TPAnim)
        if aseq then
            self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, aseq, anim.TPAnimStartTime or 0, true )
            if !game.SinglePlayer() and SERVER then
                net.Start("arccw_networktpanim")
                    net.WriteEntity(self:GetOwner())
                    net.WriteUInt(aseq, 16)
                    net.WriteFloat(anim.TPAnimStartTime or 0)
                net.SendPVS(self:GetOwner():GetPos())
            end
        end
    end

    if anim.SoundTable and !(game.SinglePlayer() and CLIENT) then
        -- self.EventTable = {}
        if game.SinglePlayer() or (!game.SinglePlayer() and (ct != self.LastAnimStartTime or self.LastAnimKey != key)) then
            self:PlaySoundTable(anim.SoundTable or {}, 1 / mult, startfrom, key)
        end
    end

    if CLIENT then
        self:SetAnimationProgress(0)
    end

    if seq then
        vm:ResetSequence( seq )
        local dur = vm:SequenceDuration()
        local rate = math.Clamp(dur / (ttime + startfrom), -4, 12)
        vm:SetPlaybackRate(rate)
        self.LastAnimStartTime = ct
        self.LastAnimFinishTime = ct + dur-- / rate
        self.LastAnimKey = key
    end

    

    local att = self:GetBuff_Override("Override_CamAttachment") or self.CamAttachment -- why is this here if we just... do cool stuff elsewhere?
    if att and vm:GetAttachment(att) then
        local ang = vm:GetAttachment(att).Ang
        ang = vm:WorldToLocalAngles(ang)
        self.Cam_Offset_Ang = Angle(ang)
    end

    self:SetNextIdle(CurTime() + ttime)

    if SERVER then
        self:CalculateCycle()
    end

    return true
end


function SWEP:EnterSprint()
    if engine.ActiveGamemode() == "terrortown" and !(TTT2 and self:GetOwner().isSprinting) then return end
    if self:GetState() == ArcCW.STATE_SPRINT then return end
    if self:GetState() == ArcCW.STATE_CUSTOMIZE then return end
    if self:GetTriggerDelta() > 0 then return end
    if self:GetGrenadePrimed() and !self:CanShootWhileSprint() then return end
    self:SetState(ArcCW.STATE_SPRINT)
    self.Sighted = false
    self.Sprinted = true

    local ct = CurTime()

    -- self.SwayScale = 1
    -- self.BobScale = 5

    self:SetShouldHoldType()

    local s = self:CanShootWhileSprint()

    if !s and self:GetNextPrimaryFire() <= ct then
        self:SetNextPrimaryFire(ct)
    end

    local anim = self:SelectAnimation("enter_sprint")
    if anim and !s and self:GetNextSecondaryFire() <= ct then
        self:PlayAnimation(anim, self:GetBuff("SightTime") / self:GetAnimKeyTime(anim, true), true, nil, false, nil, false, false, {SyncWithClient = true})
    end
end

function SWEP:GetAnimKeyTime(key, min)
    if !self:GetOwner() then return 1 end

    local anim = self.Animations[key]

    if !anim then return 1 end

    if self:GetOwner():IsNPC() then return anim.Time or 1 end

    local vm = self.REAL_VM

    if !vm or !IsValid(vm) then return 1 end

    local t = anim.Time
    if !t then
        local tseq = anim.Source

        if istable(tseq) then
            tseq["BaseClass"] = nil -- god I hate Lua inheritance
            tseq = tseq[1]
        end

        if !tseq then return 1 end
        tseq = vm:LookupSequence(tseq)

        -- to hell with it, just spits wrong on draw sometimes
        t = vm:SequenceDuration(tseq) or 1
    end

    if min and anim.MinProgress then
        t = anim.MinProgress
    end

    if anim.Mult then
        t = t * anim.Mult
    end

    

    return t
end

function SWEP:SetupActiveSights()
    if !self.IronSightStruct then return end
    if self:GetBuff_Hook("Hook_ShouldNotSight") then return false end

    if !self:GetOwner():IsPlayer() then return end

    local sighttable = {}
    local vm = CLIENT and self.REAL_VM or self:GetOwner():GetViewModel()

    if !vm or !vm:IsValid() then return end

    local kbi = self.KeepBaseIrons or true
    local bif = self.BaseIronsFirst or true

    for i, k in pairs(self.Attachments) do
        if !k.Installed then continue end

        local atttbl = ArcCW.AttachmentTable[k.Installed]

        local addsights = self:GetBuff_Stat("AdditionalSights", i)
        if !addsights then continue end

        if !k.KeepBaseIrons and !atttbl.KeepBaseIrons then kbi = false end
        if !k.BaseIronsFirst and !atttbl.BaseIronsFirst then bif = false end

        for _, s in pairs(addsights) do
            local stab = table.Copy(s)

            stab.Slot = i

            if stab.HolosightData then atttbl = stab.HolosightData end

            stab.HolosightData = atttbl

            if atttbl.HolosightMagnification then
                stab.MagnifiedOptic = true
                stab.ScopeMagnification = atttbl.HolosightMagnification or 1

                if atttbl.HolosightMagnificationMin then
                    stab.ScopeMagnificationMin = atttbl.HolosightMagnificationMin
                    stab.ScopeMagnificationMax = atttbl.HolosightMagnificationMax

                    stab.ScopeMagnification = math.max(stab.ScopeMagnificationMax, stab.ScopeMagnificationMin)

                    if !i and self.SightMagnifications[0] then
                        stab.ScopeMagnification = self.SightMagnifications[0]
                    elseif self.SightMagnifications[i] then
                        stab.ScopeMagnification = self.SightMagnifications[i]
                    end
                else
                    stab.ScopeMagnification = atttbl.HolosightMagnification
                end
            end

            if atttbl.Holosight then
                stab.Holosight = true
            end

            if !k.Bone then return end

            local boneid = vm:LookupBone(k.Bone)

            if !boneid then return end

            if CLIENT then

                if atttbl.HolosightPiece then
                    stab.HolosightPiece = (k.HSPElement or {}).Model
                end

                if atttbl.Holosight then
                    stab.HolosightModel = (k.VElement or {}).Model
                end

                local bpos, bang = self:GetFromReference(boneid)

                local offset
                local offset_ang

                local vmang = Angle()

                offset = k.Offset.vpos or Vector(0, 0, 0)

                local attslot = k

                local delta = attslot.SlidePos or 0.5

                local vmelemod = nil
                local slidemod = nil

                for _, e in pairs(self:GetActiveElements()) do
                    local ele = self.AttachmentElements[e]

                    if !ele then continue end

                    if ((ele.AttPosMods or {})[i] or {}).vpos then
                        vmelemod = ele.AttPosMods[i].vpos
                    end

                    if ((ele.AttPosMods or {})[i] or {}).slide then
                        slidemod = ele.AttPosMods[i].slide
                    end

                    -- Refer to sh_model Line 837
                    if ((ele.AttPosMods or {})[i] or {}).SlideAmount then
                        slidemod = ele.AttPosMods[i].SlideAmount
                    end
                end

                offset = vmelemod or attslot.Offset.vpos or Vector()

                if slidemod or attslot.SlideAmount then
                    offset = LerpVector(delta, (slidemod or attslot.SlideAmount).vmin, (slidemod or attslot.SlideAmount).vmax)
                end

                offset_ang = k.Offset.vang or Angle(0, 0, 0)
                offset_ang = offset_ang + (atttbl.OffsetAng or Angle(0, 0, 0))

                offset_ang = k.VMOffsetAng or offset_ang

                bpos, bang = WorldToLocal(Vector(0, 0, 0), Angle(0, 0, 0), bpos, bang)

                bpos = bpos + bang:Forward() * offset.x
                bpos = bpos + bang:Right() * offset.y
                bpos = bpos + bang:Up() * offset.z

                bang:RotateAroundAxis(bang:Right(), offset_ang.p)
                bang:RotateAroundAxis(bang:Up(), -offset_ang.y)
                bang:RotateAroundAxis(bang:Forward(), offset_ang.r)

                local vpos = Vector()

                vpos.y = -bpos.x
                vpos.x = bpos.y
                vpos.z = -bpos.z

                local corpos = (k.CorrectivePos or Vector(0, 0, 0))

                vpos = vpos + bang:Forward() * corpos.x
                vpos = vpos + bang:Right() * corpos.y
                vpos = vpos + bang:Up() * corpos.z

                -- vpos = vpos + (bang:Forward() * s.Pos.x)
                -- vpos = vpos - (bang:Right() * s.Pos.y)
                -- vpos = vpos + (bang:Up() * s.Pos.z)

                vmang:Set(-bang)

                bang.r = -bang.r
                bang.p = -bang.p
                bang.y = -bang.y

                corang = k.CorrectiveAng or Angle(0, 0, 0)

                bang:RotateAroundAxis(bang:Right(), corang.p)
                bang:RotateAroundAxis(bang:Up(), corang.y)
                bang:RotateAroundAxis(bang:Forward(), corang.r)

                -- vpos = LocalToWorld(s.Pos + Vector(0, self.ExtraSightDist or 0, 0), Angle(0, 0, 0), vpos, bang)

                -- local vmf = (vmang):Forward():GetNormalized()
                -- local vmr = (vmang):Right():GetNormalized()
                -- local vmu = (vmang):Up():GetNormalized()

                -- print(" ----- vmf, vmr, vmu")
                -- print(vmf)
                -- print(vmr)
                -- print(vmu)

                -- vmf = -vmf
                -- vmf.x = -vmf.x

                -- local r = vmf.y
                -- vmf.y = vmf.z
                -- vmf.z = r

                -- vmr = -vmr
                -- vmr.y = -vmr.y

                -- -- local r = vmr.y
                -- -- vmr.y = vmr.z
                -- -- vmr.z = r

                -- vmu = -vmu
                -- vmu.z = vmu.z

                -- local evpos = Vector(0, 0, 0)

                -- evpos = evpos + (vmf * (s.Pos.x + k.CorrectivePos.x))
                -- evpos = evpos - (vmr * (s.Pos.y + (self.ExtraSightDist or 0) + k.CorrectivePos.y))
                -- evpos = evpos + (vmu * (s.Pos.z + k.CorrectivePos.z))

                -- print(vmang:Forward())

                local evpos = s.Pos

                evpos = evpos * (k.VMScale or Vector(1, 1, 1))

                if atttbl.Holosight and !atttbl.HolosightMagnification then
                    evpos = evpos + Vector(0, k.ExtraSightDist or self.ExtraSightDist or 0, 0)
                end

                evpos = evpos + (k.CorrectivePos or Vector(0, 0, 0))

                stab.Pos, stab.Ang = vpos, bang

                stab.EVPos = evpos
                stab.EVAng = s.Ang

                if s.GlobalPos then
                    stab.EVPos = Vector(0, 0, 0)
                    stab.Pos = s.Pos
                end

                if s.GlobalAng then
                    stab.Ang = Angle(0, 0, 0)
                end

            end

            table.insert(sighttable, stab)
        end
    end

    if kbi then
        local extra = self.ExtraIrons
        if extra then
            for _, ot in pairs(extra) do
                local t = table.Copy(ot)
                t.IronSight = true
                if bif then
                    table.insert(sighttable, 1, t)
                else
                    table.insert(sighttable, t)
                end
            end
        end

        local t = table.Copy(self:GetBuff_Override("Override_IronSightStruct") or self.IronSightStruct)
        t.IronSight = true
        if bif then
            table.insert(sighttable, 1, t)
        else
            table.insert(sighttable, t)
        end
    end

    self.SightTable = sighttable
end

function SWEP:PlayEvent(v)
    if !v or !istable(v) then error("no event to play") end
    v = self:GetBuff_Hook("Hook_PrePlayEvent", v) or v
    if v.e and IsFirstTimePredicted() then
        DoShell(self, v)
    end

    if v.s then
        if v.s_km then
            self:StopSound(v.s)
        end
        self:MyEmitSound(v.s, v.l, v.p, v.v, v.c or CHAN_AUTO)
    end

    if v.bg then
        self:SetBodygroupTr(v.ind or 0, v.bg)
    end

    if v.pp then
        local vm = self:GetOwner():GetViewModel()

        vm:SetPoseParameter(pp, ppv)
    end

    v = self:GetBuff_Hook("Hook_PostPlayEvent", v) or v
end

function SWEP:Initialize()
    if (!IsValid(self:GetOwner()) or self:GetOwner():IsNPC()) and self:IsValid() and self.NPC_Initialize and SERVER then
        self:NPC_Initialize()
    end
    if self:GetOwner():IsValid() then
        self:createCustomVM(self.ViewModel)
        if game.SinglePlayer() and SERVER then
            self:CallOnClient("Initialize")
        end
    else
        timer.Simple(0, function()
            if IsValid(self) then self:createCustomVM(self.ViewModel) end
        end)
    end
    
    if CLIENT then
        local class = self:GetClass()

        if self.KillIconAlias then
            killicon.AddAlias(class, self.KillIconAlias)
            class = self.KillIconAlias
        end

        local path = "arccw/weaponicons/" .. class
        local mat = Material(path)

        if !mat:IsError() then

            local tex = mat:GetTexture("$basetexture")
            if tex then
                local texpath = tex:GetName()
                killicon.Add(class, texpath, Color(255, 255, 255))
                self.WepSelectIcon = surface.GetTextureID(texpath)

                if self.ShootEntity then
                killicon.Add(self.ShootEntity, texpath, Color(255, 255, 255))
                end
            end
        end

        -- Check for incompatibile addons once 
        if LocalPlayer().ArcCW_IncompatibilityCheck != true and game.SinglePlayer() then
            LocalPlayer().ArcCW_IncompatibilityCheck = true

            local incompatList = {}
            local addons = engine.GetAddons()
            for _, addon in pairs(addons) do
                if ArcCW.IncompatibleAddons[tostring(addon.wsid)] and addon.mounted then
                    incompatList[tostring(addon.wsid)] = addon
                end
            end

            local predrawvmhooks = hook.GetTable().PreDrawViewModel
            if predrawvmhooks and (predrawvmhooks.DisplayDistancePlaneLS or predrawvmhooks.DisplayDistancePlane) then -- vtools lua breaks arccw with stupid return in vm hook, ya dont need it if you going to play with guns
                hook.Remove("PreDrawViewModel", "DisplayDistancePlane")
                hook.Remove("PreDrawViewModel", "DisplayDistancePlaneLS")
                incompatList["DisplayDistancePlane"] = {
                    title = "Light Sprayer / Scenic Dispenser tool",
                    wsid = "DisplayDistancePlane",
                    nourl = true,
                }
            end
            local shouldDo = true
            -- If never show again is on, verify we have no new addons
            if file.Exists("arccw_incompatible.txt", "DATA") then
                shouldDo = false
                local oldTbl = util.JSONToTable(file.Read("arccw_incompatible.txt"))
                for id, addon in pairs(incompatList) do
                    if !oldTbl[id] then shouldDo = true break end
                end
                if shouldDo then file.Delete("arccw_incompatible.txt") end
            end
            if shouldDo and !table.IsEmpty(incompatList) then
                ArcCW.MakeIncompatibleWindow(incompatList)
            elseif !table.IsEmpty(incompatList) then
                print("ArcCW ignored " .. table.Count(incompatList) .. " incompatible addons. If things break, it's your fault.")
            end
        end
    end

    if GetConVar("arccw_equipmentsingleton"):GetBool() and self.Throwing then
        self.Singleton = true
        self.Primary.ClipSize = -1
        self.Primary.Ammo = ""
    end

    self:SetState(0)
    self:SetClip2(0)
    self:SetLastLoad(self:Clip1())

    self.Attachments["BaseClass"] = nil

    if !self:GetOwner():IsNPC() then
        self:SetHoldType(self.HoldtypeActive)
    end

    local og = weapons.Get(self:GetClass())

    self.RegularClipSize = og.Primary.ClipSize

    self.OldPrintName = self.PrintName

    self:InitTimers()

    if engine.ActiveGamemode() == "terrortown" then
        self:TTT_Init()
    end

    hook.Run("ArcCW_WeaponInit", self)

    self:AdjustAtts()
end

function SWEP:GetMuzzleDevice(wm)
    local model = self.WM
    local muzz = self.WMModel or self

    if !wm then
        model = self.VM
        muzz = self.REAL_VM
    end

    if model then
        for _, ele in pairs(model) do
            if ele.IsMuzzleDevice then
                muzz = ele.Model or muzz
            end
        end
    end

    if self:GetInUBGL() then
        local _, slot = self:GetBuff_Override("UBGL")

        if wm then
            muzz = (self.Attachments[slot].WMuzzleDeviceElement or {}).Model or muzz
        else
            muzz = (self.Attachments[slot].VMuzzleDeviceElement or {}).Model or muzz
        end
    end

    return muzz
end

function SWEP:GetTracerOrigin()
    local ow = self:GetOwner()
    local wm = !self.REAL_VM:IsValid() or ow:ShouldDrawLocalPlayer()
    local muzz = self:GetMuzzleDevice(wm)

    if muzz and muzz:IsValid() then
        local posang = muzz:GetAttachment(self:GetBuff_Override("Override_MuzzleEffectAttachment", self.MuzzleEffectAttachment) or 1)
        if !posang then return muzz:GetPos() end
        local pos = posang.Pos

        return pos
    end
end

function SWEP:RefreshBGs()
    local vm

    local vmm = self:GetBuff_Override("Override_VMMaterial") or self.VMMaterial or ""
    local wmm = self:GetBuff_Override("Override_WMMaterial") or self.WMMaterial or  ""

    local vmc = self:GetBuff_Override("Override_VMColor") or self.VMColor or Color(255, 255, 255)
    local wmc = self:GetBuff_Override("Override_WMColor") or self.WMColor or Color(255, 255, 255)

    local vms = self:GetBuff_Override("Override_VMSkin") or self.DefaultSkin
    local wms = self:GetBuff_Override("Override_WMSkin") or self.DefaultWMSkin

    local vmp = self.DefaultPoseParams
    local wmp = self.DefaultWMPoseParams

    if self.MirrorVMWM then
        wmm = vmm
        wmc = vmc
        wms = vms
        wmp = vmp
    end

    if self:GetOwner():IsPlayer() then
        vm = CLIENT and self.REAL_VM or self:GetOwner():GetViewModel()
    end

    if vm and vm:IsValid() then
        ArcCW.SetBodyGroups(vm, self.DefaultBodygroups)
        vm:SetMaterial(vmm)
        vm:SetColor(vmc)
        vm:SetSkin(vms)

        vmp["BaseClass"] = nil

        for i, k in pairs(vmp) do
            vm:SetPoseParameter(i, k)
        end
    end

    self:SetMaterial(wmm)
    self:SetColor(wmc)
    self:SetSkin(wms)

    if self.WMModel and self.WMModel:IsValid() then
        ArcCW.SetBodyGroups(self.WMModel, self.MirrorVMWM and self.DefaultBodygroups or self.DefaultWMBodygroups)

        self.WMModel:SetMaterial(wmm)
        self.WMModel:SetColor(wmc)
        self.WMModel:SetSkin(wms)

        wmp["BaseClass"] = nil

        for i, k in pairs(wmp) do
            self.WMModel:SetPoseParameter(i, k)
        end
    end

    local ae = self:GetActiveElements()

    for _, e in pairs(ae) do
        local ele = self.AttachmentElements[e]

        if !ele then continue end

        if ele.VMPoseParams and vm and IsValid(vm) then
            ele.VMPoseParams["BaseClass"] = nil
            for i, k in pairs(ele.VMPoseParams) do
                vm:SetPoseParameter(i, k)
            end
        end

        if self.WMModel and self.WMModel:IsValid() then
            if self.MirrorVMWM and ele.VMPoseParams then
                ele.VMPoseParams["BaseClass"] = nil
                for i, k in pairs(ele.VMPoseParams) do
                    self.WMModel:SetPoseParameter(i, k)
                end
            end
            if ele.WMPoseParams then
                ele.WMPoseParams["BaseClass"] = nil
                for i, k in pairs(ele.WMPoseParams) do
                    self.WMModel:SetPoseParameter(i, k)
                end
            end
        end

        if ele.VMSkin and vm and IsValid(vm) then
            vm:SetSkin(ele.VMSkin)
        end

        if self.WMModel and self.WMModel:IsValid() then
            if self.MirrorVMWM and ele.VMSkin then
                self.WMModel:SetSkin(ele.VMSkin)
                self:SetSkin(ele.VMSkin)
            end
            if ele.WMSkin then
                self.WMModel:SetSkin(ele.WMSkin)
                self:SetSkin(ele.WMSkin)
            end
        end

        if ele.VMColor and vm and IsValid(vm) then
            vm:SetColor(ele.VMColor)
        end

        if self.WMModel and self.WMModel:IsValid() then
            if self.MirrorVMWM and ele.VMSkin then
                self.WMModel:SetColor(ele.VMColor or color_white)
                self:SetColor(ele.VMColor or color_white)
            end
            if ele.WMSkin then
                self.WMModel:SetColor(ele.WMColor or color_white)
                self:SetColor(ele.WMColor or color_white)
            end
        end

        if ele.VMMaterial and vm and IsValid(vm) then
            vm:SetMaterial(ele.VMMaterial)
        end

        if self.WMModel and self.WMModel:IsValid() then
            if self.MirrorVMWM and ele.VMMaterial then
                self.WMModel:SetMaterial(ele.VMMaterial)
                self:SetMaterial(ele.VMMaterial)
            end
            if ele.WMMaterial then
                self.WMModel:SetMaterial(ele.WMMaterial)
                self:SetMaterial(ele.WMMaterial)
            end
        end

        if ele.VMBodygroups then
            for _, i in pairs(ele.VMBodygroups) do
                if !i.ind or !i.bg then continue end

                if vm and IsValid(vm) and vm:GetBodygroup(i.ind) != i.bg then
                    vm:SetBodygroup(i.ind, i.bg)
                end
            end

            if self.MirrorVMWM then
                for _, i in pairs(ele.VMBodygroups) do
                    if !i.ind or !i.bg then continue end

                    if self.WMModel and IsValid(self.WMModel) and self.WMModel:GetBodygroup(i.ind) != i.bg then
                        self.WMModel:SetBodygroup(i.ind, i.bg)
                    end

                    if self:GetBodygroup(i.ind) != i.bg then
                        self:SetBodygroup(i.ind, i.bg)
                    end
                end
            end
        end

        if ele.WMBodygroups then
            for _, i in pairs(ele.WMBodygroups) do
                if !i.ind or !i.bg then continue end

                if self.WMModel and IsValid(self.WMModel) and self.WMModel:GetBodygroup(i.ind) != i.bg then
                    self.WMModel:SetBodygroup(i.ind, i.bg)
                end

                if self:GetBodygroup(i.ind) != i.bg then
                    self:SetBodygroup(i.ind, i.bg)
                end
            end
        end

        if ele.VMBoneMods then
            for bone, i in pairs(ele.VMBoneMods) do
                local boneind = vm:LookupBone(bone)

                if !boneind then continue end

                vm:ManipulateBonePosition(boneind, i)
            end

            if self.MirrorVMWM then
                for bone, i in pairs(ele.VMBoneMods) do
                    if !(self.WMModel and self.WMModel:IsValid()) then break end
                    local boneind = self:LookupBone(bone)

                    if !boneind then continue end

                    self:ManipulateBonePosition(boneind, i)
                end
            end
        end

        if ele.WMBoneMods then
            for bone, i in pairs(ele.WMBoneMods) do
                if !(self.WMModel and self.WMModel:IsValid()) then break end
                local boneind = self:LookupBone(bone)

                if !boneind then continue end

                self:ManipulateBonePosition(boneind, i)
            end
        end



        if SERVER then
            self:SetupShields()
        end
    end

    if IsValid(vm) then
        for i = 0, (vm:GetNumBodyGroups()) do
            if self.Bodygroups[i] then
                vm:SetBodygroup(i, self.Bodygroups[i])
            end
        end

        self:GetBuff_Hook("Hook_ModifyBodygroups", {vm = vm, eles = ae, wm = false})
        self:GetBuff_Hook("Hook_ModifyBodygroups", {vm = self.WMModel or self, eles = ae, wm = true})

        for slot, v in pairs(self.Attachments) do
            if !v.Installed then continue end

            local func = self:GetBuff_Stat("Hook_ModifyAttBodygroups", slot)
            if func and v.VElement and IsValid(v.VElement.Model) then
                func(self, {vm = vm, element = v.VElement, slottbl = v, wm = false})
            end
            if func and v.WElement and IsValid(v.WElement.Model)  then
                func(self, {vm = self.WMModel, element = v.WElement, slottbl = v, wm = true})
            end
        end
    end
end

function SWEP:DoLHIK()
    if !IsValid(self:GetOwner()) then return end

    local justhide = false
    local lhik_model = nil
    local lhik_anim_model = nil
    local hide_component = false
    local delta = 1

    local vm = wep.REAL_VM and (wep.REAL_VM.Hands or wep.REAL_VM) or self:GetOwner():GetViewModel()

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

function SWEP:DoLHIKAnimation(key, time, spbitch)
    if game.SinglePlayer() and !spbitch then
        timer.Simple(0, function() if IsValid(self) then self:DoLHIKAnimation(key, time, true) end end)
        return
    end
    local owner = self:GetOwner()
    local vm =  self.REAL_VM and (self.REAL_VM.Hands or self.REAL_VM) or self:GetOwner():GetViewModel()
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

function SWEP:Bash(melee2)
    melee2 = melee2 or false
    if self:GetState() == ArcCW.STATE_SIGHTS
            or (self:GetState() == ArcCW.STATE_SPRINT and !self:CanShootWhileSprint())
            or self:GetState() == ArcCW.STATE_CUSTOMIZE then
        return
    end
    if self:GetNextPrimaryFire() > CurTime() or self:GetGrenadePrimed() or self:GetPriorityAnim() then return end

    if !self.CanBash and !self:GetBuff_Override("Override_CanBash") then return end

    self:GetBuff_Hook("Hook_PreBash")

    self.Primary.Automatic = true

    local mult = self:GetBuff_Mult("Mult_MeleeTime")
    local mt = self.MeleeTime * mult

    if melee2 then
        mt = self.Melee2Time * mult
    end

    mt = mt * self:GetBuff_Mult("Mult_MeleeWaitTime")

    local bashanim = "bash"
    local canbackstab = self:CanBackstab(melee2)

    if melee2 then
        bashanim = canbackstab and self:SelectAnimation("bash2_backstab") or self:SelectAnimation("bash2") or bashanim
    else
        bashanim = canbackstab and self:SelectAnimation("bash_backstab") or self:SelectAnimation("bash") or bashanim
    end

    bashanim = self:GetBuff_Hook("Hook_SelectBashAnim", bashanim) or bashanim

    if bashanim and self.Animations[bashanim] then
        if SERVER then self:PlayAnimation(bashanim, mult, true, 0, true, nil, nil, nil, {SyncWithClient = true}) end
    else
        self:ProceduralBash()

        self:MyEmitSound(self.MeleeSwingSound, 75, 100, 1, CHAN_USER_BASE + 1)
    end

    if CLIENT then
        self:OurViewPunch(-self.BashPrepareAng * 0.05)
    end
    self:SetNextPrimaryFire(CurTime() + mt )

    if melee2 then
        if self.HoldtypeActive == "pistol" or self.HoldtypeActive == "revolver" then
            self:GetOwner():DoAnimationEvent(self.Melee2Gesture or ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE)
        else
            self:GetOwner():DoAnimationEvent(self.Melee2Gesture or ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND)
        end
    else
        if self.HoldtypeActive == "pistol" or self.HoldtypeActive == "revolver" then
            self:GetOwner():DoAnimationEvent(self.MeleeGesture or ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE)
        else
            self:GetOwner():DoAnimationEvent(self.MeleeGesture or ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND)
        end
    end

    local mat = self.MeleeAttackTime

    if melee2 then
        mat = self.Melee2AttackTime
    end

    mat = mat * self:GetBuff_Mult("Mult_MeleeAttackTime") * math.pow(mult, 1.5)

    self:SetTimer(mat or (0.125 * mt), function()
        if !IsValid(self) then return end
        if !IsValid(self:GetOwner()) then return end
        if self:GetOwner():GetActiveWeapon() != self then return end

        if CLIENT then
            self:OurViewPunch(-self.BashAng * 0.05)
        end

        self:MeleeAttack(melee2)
    end)

    self:DoLunge()
end

function SWEP:BlurWeapon()
    if !GetConVar("arccw_blur"):GetBool() then return end
    local delta = self:GetSightDelta()
    if delta >= 1 then return end
    local vm = self.REAL_VM
    render.UpdateScreenEffectTexture()
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilPassOperation(STENCIL_REPLACE)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_REPLACE)
    render.SetStencilWriteMask(0xFF)
    render.SetStencilTestMask(0xFF)
    render.SetBlend(1)
    render.SetStencilReferenceValue(55)
    ArcCW.Overdraw = true
    vm:DrawModel()
    ArcCW.Overdraw = false
    render.SetBlend(0)
    render.SetStencilPassOperation(STENCIL_REPLACE)
    render.SetStencilCompareFunction(STENCIL_EQUAL)
    -- render.SetColorMaterial()
    dofmat:SetFloat("bluramount", 0.1 * (1 - delta))
    render.SetMaterial(dofmat)
    render.DrawScreenQuad()
    render.SetStencilEnable(false)
end

function SWEP:SetupActiveSights()
    if !self.IronSightStruct then return end
    if self:GetBuff_Hook("Hook_ShouldNotSight") then return false end

    if !self:GetOwner():IsPlayer() then return end

    local sighttable = {}
    local vm = self.REAL_VM

    if !vm or !vm:IsValid() then return end

    local kbi = self.KeepBaseIrons or true
    local bif = self.BaseIronsFirst or true

    for i, k in pairs(self.Attachments) do
        if !k.Installed then continue end

        local atttbl = ArcCW.AttachmentTable[k.Installed]

        local addsights = self:GetBuff_Stat("AdditionalSights", i)
        if !addsights then continue end

        if !k.KeepBaseIrons and !atttbl.KeepBaseIrons then kbi = false end
        if !k.BaseIronsFirst and !atttbl.BaseIronsFirst then bif = false end

        for _, s in pairs(addsights) do
            local stab = table.Copy(s)

            stab.Slot = i

            if stab.HolosightData then atttbl = stab.HolosightData end

            stab.HolosightData = atttbl

            if atttbl.HolosightMagnification then
                stab.MagnifiedOptic = true
                stab.ScopeMagnification = atttbl.HolosightMagnification or 1

                if atttbl.HolosightMagnificationMin then
                    stab.ScopeMagnificationMin = atttbl.HolosightMagnificationMin
                    stab.ScopeMagnificationMax = atttbl.HolosightMagnificationMax

                    stab.ScopeMagnification = math.max(stab.ScopeMagnificationMax, stab.ScopeMagnificationMin)

                    if !i and self.SightMagnifications[0] then
                        stab.ScopeMagnification = self.SightMagnifications[0]
                    elseif self.SightMagnifications[i] then
                        stab.ScopeMagnification = self.SightMagnifications[i]
                    end
                else
                    stab.ScopeMagnification = atttbl.HolosightMagnification
                end
            end

            if atttbl.Holosight then
                stab.Holosight = true
            end

            if !k.Bone then return end

            local boneid = vm:LookupBone(k.Bone)

            if !boneid then return end

            if CLIENT then

                if atttbl.HolosightPiece then
                    stab.HolosightPiece = (k.HSPElement or {}).Model
                end

                if atttbl.Holosight then
                    stab.HolosightModel = (k.VElement or {}).Model
                end

                local bpos, bang = self:GetFromReference(boneid)

                local offset
                local offset_ang

                local vmang = Angle()

                offset = k.Offset.vpos or Vector(0, 0, 0)

                local attslot = k

                local delta = attslot.SlidePos or 0.5

                local vmelemod = nil
                local slidemod = nil

                for _, e in pairs(self:GetActiveElements()) do
                    local ele = self.AttachmentElements[e]

                    if !ele then continue end

                    if ((ele.AttPosMods or {})[i] or {}).vpos then
                        vmelemod = ele.AttPosMods[i].vpos
                    end

                    if ((ele.AttPosMods or {})[i] or {}).slide then
                        slidemod = ele.AttPosMods[i].slide
                    end

                    -- Refer to sh_model Line 837
                    if ((ele.AttPosMods or {})[i] or {}).SlideAmount then
                        slidemod = ele.AttPosMods[i].SlideAmount
                    end
                end

                offset = vmelemod or attslot.Offset.vpos or Vector()

                if slidemod or attslot.SlideAmount then
                    offset = LerpVector(delta, (slidemod or attslot.SlideAmount).vmin, (slidemod or attslot.SlideAmount).vmax)
                end

                offset_ang = k.Offset.vang or Angle(0, 0, 0)
                offset_ang = offset_ang + (atttbl.OffsetAng or Angle(0, 0, 0))

                offset_ang = k.VMOffsetAng or offset_ang

                bpos, bang = WorldToLocal(Vector(0, 0, 0), Angle(0, 0, 0), bpos, bang)

                bpos = bpos + bang:Forward() * offset.x
                bpos = bpos + bang:Right() * offset.y
                bpos = bpos + bang:Up() * offset.z

                bang:RotateAroundAxis(bang:Right(), offset_ang.p)
                bang:RotateAroundAxis(bang:Up(), -offset_ang.y)
                bang:RotateAroundAxis(bang:Forward(), offset_ang.r)

                local vpos = Vector()

                vpos.y = -bpos.x
                vpos.x = bpos.y
                vpos.z = -bpos.z

                local corpos = (k.CorrectivePos or Vector(0, 0, 0))

                vpos = vpos + bang:Forward() * corpos.x
                vpos = vpos + bang:Right() * corpos.y
                vpos = vpos + bang:Up() * corpos.z

                -- vpos = vpos + (bang:Forward() * s.Pos.x)
                -- vpos = vpos - (bang:Right() * s.Pos.y)
                -- vpos = vpos + (bang:Up() * s.Pos.z)

                vmang:Set(-bang)

                bang.r = -bang.r
                bang.p = -bang.p
                bang.y = -bang.y

                corang = k.CorrectiveAng or Angle(0, 0, 0)

                bang:RotateAroundAxis(bang:Right(), corang.p)
                bang:RotateAroundAxis(bang:Up(), corang.y)
                bang:RotateAroundAxis(bang:Forward(), corang.r)

                -- vpos = LocalToWorld(s.Pos + Vector(0, self.ExtraSightDist or 0, 0), Angle(0, 0, 0), vpos, bang)

                -- local vmf = (vmang):Forward():GetNormalized()
                -- local vmr = (vmang):Right():GetNormalized()
                -- local vmu = (vmang):Up():GetNormalized()

                -- print(" ----- vmf, vmr, vmu")
                -- print(vmf)
                -- print(vmr)
                -- print(vmu)

                -- vmf = -vmf
                -- vmf.x = -vmf.x

                -- local r = vmf.y
                -- vmf.y = vmf.z
                -- vmf.z = r

                -- vmr = -vmr
                -- vmr.y = -vmr.y

                -- -- local r = vmr.y
                -- -- vmr.y = vmr.z
                -- -- vmr.z = r

                -- vmu = -vmu
                -- vmu.z = vmu.z

                -- local evpos = Vector(0, 0, 0)

                -- evpos = evpos + (vmf * (s.Pos.x + k.CorrectivePos.x))
                -- evpos = evpos - (vmr * (s.Pos.y + (self.ExtraSightDist or 0) + k.CorrectivePos.y))
                -- evpos = evpos + (vmu * (s.Pos.z + k.CorrectivePos.z))

                -- print(vmang:Forward())

                local evpos = s.Pos

                evpos = evpos * (k.VMScale or Vector(1, 1, 1))

                if atttbl.Holosight and !atttbl.HolosightMagnification then
                    evpos = evpos + Vector(0, k.ExtraSightDist or self.ExtraSightDist or 0, 0)
                end

                evpos = evpos + (k.CorrectivePos or Vector(0, 0, 0))

                stab.Pos, stab.Ang = vpos, bang

                stab.EVPos = evpos
                stab.EVAng = s.Ang

                if s.GlobalPos then
                    stab.EVPos = Vector(0, 0, 0)
                    stab.Pos = s.Pos
                end

                if s.GlobalAng then
                    stab.Ang = Angle(0, 0, 0)
                end

            end

            table.insert(sighttable, stab)
        end
    end

    if kbi then
        local extra = self.ExtraIrons
        if extra then
            for _, ot in pairs(extra) do
                local t = table.Copy(ot)
                t.IronSight = true
                if bif then
                    table.insert(sighttable, 1, t)
                else
                    table.insert(sighttable, t)
                end
            end
        end

        local t = table.Copy(self:GetBuff_Override("Override_IronSightStruct") or self.IronSightStruct)
        t.IronSight = true
        if bif then
            table.insert(sighttable, 1, t)
        else
            table.insert(sighttable, t)
        end
    end

    self.SightTable = sighttable
end

function SWEP:FinishHolster()
    self:KillTimers()

    if CLIENT then
        self:KillFlashlights()
    else
        if self:GetBuff_Override("UBGL_UnloadOnDequip") then
            local clip = self:Clip2()

            local ammo = self:GetBuff_Override("UBGL_Ammo") or "smg1_grenade"

            if IsValid(self:GetOwner()) then
                self:GetOwner():GiveAmmo(clip, ammo, true)
            end

            self:SetClip2(0)
        end

        self:KillShields()

        local vm = self.REAL_VM
        if IsValid(vm) then
            for i = 0, vm:GetNumBodyGroups() do
                vm:SetBodygroup(i, 0)
            end
            vm:SetSkin(0)
            vm:SetPlaybackRate(1)
        end

        if self.Disposable and self:Clip1() == 0 and self:Ammo1() == 0 then
            self:GetOwner():StripWeapon(self:GetClass())
        end
    end
end

function SWEP:GetMuzzleDevice(wm)
    local model = self.WM
    local muzz = self.WMModel or self

    if !wm then
        model = self.VM
        muzz = self.REAL_VM
    end

    if model then
        for _, ele in pairs(model) do
            if ele.IsMuzzleDevice then
                muzz = ele.Model or muzz
            end
        end
    end

    if self:GetInUBGL() then
        local _, slot = self:GetBuff_Override("UBGL")

        if wm then
            muzz = (self.Attachments[slot].WMuzzleDeviceElement or {}).Model or muzz
        else
            muzz = (self.Attachments[slot].VMuzzleDeviceElement or {}).Model or muzz
        end
    end

    return muzz
end

function SWEP:SetupDataTables()
    self:NetworkVar("Int", 0, "NWState")
    self:NetworkVar("Int", 1, "FireMode")
    self:NetworkVar("Int", 2, "BurstCountUM")
    self:NetworkVar("Int", 3, "LastLoad")
    self:NetworkVar("Int", 4, "NthReload")
    self:NetworkVar("Int", 5, "NthShot")

    -- 2 = insert
    -- 3 = cancelling
    -- 4 = insert empty
    -- 5 = cancelling empty
    self:NetworkVar("Int", 6, "ShotgunReloading")
    self:NetworkVar("Int", 7, "MagUpCount")

    self:NetworkVar("Bool", 0, "HeatLocked")
    self:NetworkVar("Bool", 1, "NeedCycle")
    self:NetworkVar("Bool", 2, "InBipod")
    self:NetworkVar("Bool", 3, "InUBGL")
    self:NetworkVar("Bool", 4, "InCustomize")
    self:NetworkVar("Bool", 5, "GrenadePrimed")
    self:NetworkVar("Bool", 6, "NWMalfunctionJam")
    self:NetworkVar("Bool", 7, "UBGLDebounce")

    self:NetworkVar("Float", 0, "Heat")
    self:NetworkVar("Float", 1, "WeaponOpDelay")
    self:NetworkVar("Float", 2, "ReloadingREAL")
    self:NetworkVar("Float", 3, "MagUpIn")
    self:NetworkVar("Float", 4, "NextPrimaryFireSlowdown")
    self:NetworkVar("Float", 5, "NextIdle")
    self:NetworkVar("Float", 6, "Holster_Time")
    self:NetworkVar("Float", 7, "NWSightDelta")
    self:NetworkVar("Float", 8, "NWSprintDelta")
    self:NetworkVar("Float", 9, "NWPriorityAnim")

    self:NetworkVar("Vector", 0, "BipodPos")

    self:NetworkVar("Angle", 0, "BipodAngle")
    self:NetworkVar("Angle", 1, "FreeAimAngle")
    self:NetworkVar("Angle", 2, "LastAimAngle")

    self:NetworkVar("Entity", 0, "Holster_Entity")

    self:SetNWSightDelta(1)
end

function SWEP:Reload()
    if IsValid(self:GetHolster_Entity()) then return end
    if self:GetHolster_Time() > 0 then return end

    if !IsFirstTimePredicted() then return end

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
        self:PlayAnimation(anim, mult, true, 0, true, nil, true, nil, {SyncWithClient = true})

        self:SetReloading(CurTime() + time * mult)

        self:SetShotgunReloading(empty and 4 or 2)
    else
        local anim = self:SelectReloadAnimation()

        if !self.Animations[anim] then print("Invalid animation \"" .. anim .. "\"") return end
        self:PlayAnimation(anim, mult, true, self.Animations[anim].StartFrom, false, nil, true, nil, {SyncWithClient = true })
        --print("reload", self:GetAnimationProgress(), CurTime(), self:GetNextIdle(), !!self:PlayAnimation(anim, mult, true, self.Animations[anim].StartFrom, false, nil, true, nil, {SyncWithClient = true }), self.LastAnimKey)
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

function SWEP:DoPrimaryAnim()
    local anim = "fire"

    local inbipod = self:InBipod()
    local iron    = self:GetState() == ArcCW.STATE_SIGHTS

    -- Needs testing
    if inbipod then
        anim = self:SelectAnimation("fire_bipod") or self:SelectAnimation("fire") or anim
    else
        anim = self:SelectAnimation("fire") or anim
    end

    if (self.ProceduralIronFire and iron) or (self.ProceduralRegularFire and !iron) then anim = nil end

    anim = self:GetBuff_Hook("Hook_SelectFireAnimation", anim) or anim

    local time = self:GetBuff_Mult("Mult_FireAnimTime", anim) or 1

    if anim then self:PlayAnimation(anim, time, true, 0, false) end
end

local vec1 = Vector(1, 1, 1)
local vec0 = vec1 * 0
function SWEP:PrimaryAttack()
    local owner = self:GetOwner()

    self.Primary.Automatic = true

    if !self:CanPrimaryAttack() then return end

    local clip = self:Clip1()
    local aps = self:GetBuff("AmmoPerShot")

    if self:HasBottomlessClip() then
        clip = self:Ammo1()
        if self:HasInfiniteAmmo() then
            clip = math.huge
        end
    end

    if clip < aps then
        self:SetBurstCount(0)
        self:DryFire()

        self.Primary.Automatic = false

        return
    end

    local dir = (owner:EyeAngles() + self:GetFreeAimOffset()):Forward() --owner:GetAimVector()
    local src = self:GetShootSrc()

    if bit.band(util.PointContents(src), CONTENTS_WATER) == CONTENTS_WATER and !(self.CanFireUnderwater or self:GetBuff_Override("Override_CanFireUnderwater")) then
        self:DryFire()
        return
    end

    if self:GetMalfunctionJam() then
        self:DryFire()
        return
    end

    -- Try malfunctioning
    local mal = self:DoMalfunction(false)
    if mal == true then
        local anim = "fire_jammed"
        self:PlayAnimation(anim, 1, true, 0, true)
        return
    end

    self:GetBuff_Hook("Hook_PreFireBullets")

    local desync = GetConVar("arccw_desync"):GetBool()
    local desyncnum = (desync and math.random()) or 0
    math.randomseed(math.Round(util.SharedRandom(self:GetBurstCount(), -1337, 1337, !game.SinglePlayer() and self:GetOwner():GetCurrentCommand():CommandNumber() or CurTime()) * (self:EntIndex() % 30241)) + desyncnum)

    self.Primary.Automatic = true

    local spread = ArcCW.MOAToAcc * self:GetBuff("AccuracyMOA")
    local disp = self:GetDispersion() * ArcCW.MOAToAcc / 10

    --dir:Rotate(Angle(0, ArcCW.StrafeTilt(self), 0))
    --dir = dir + VectorRand() * disp

    self:ApplyRandomSpread(dir, disp)

    if (CLIENT or game.SinglePlayer()) and GetConVar("arccw_dev_shootinfo"):GetInt() >= 3 and disp > 0 then
        local dev_tr = util.TraceLine({
            start = src,
            endpos = src + owner:GetAimVector() * 33000,
            mask = MASK_SHOT,
            filter = {self, self:GetOwner()}
        })
        local dist = (dev_tr.HitPos - src):Length()
        local r = dist / (1 / math.tan(disp)) -- had to google "trig cheat sheet to figure this one out"
        local a = owner:GetAimVector():Angle()
        local r_sqrt = r / math.sqrt(2)
        debugoverlay.Line(dev_tr.HitPos - a:Up() * r, dev_tr.HitPos + a:Up() * r, 5, color_white, true)
        debugoverlay.Line(dev_tr.HitPos - a:Right() * r, dev_tr.HitPos + a:Right() * r, 5, color_white, true)
        debugoverlay.Line(dev_tr.HitPos - a:Right() * r_sqrt - a:Up() * r_sqrt, dev_tr.HitPos + a:Right() * r_sqrt + a:Up() * r_sqrt, 5, color_white, true)
        debugoverlay.Line(dev_tr.HitPos - a:Right() * r_sqrt + a:Up() * r_sqrt, dev_tr.HitPos + a:Right() * r_sqrt - a:Up() * r_sqrt, 5, color_white, true)
        debugoverlay.Text(dev_tr.HitPos, math.Round(self:GetDispersion(), 1) .. "MOA (" .. math.Round(disp, 3) .. "°)", 5)
    end

    local delay = self:GetFiringDelay()

    local curtime = CurTime()
    local curatt = self:GetNextPrimaryFire()
    local diff = curtime - curatt

    if diff > engine.TickInterval() or diff < 0 then
        curatt = curtime
    end

    self:SetNextPrimaryFire(curatt + delay)
    self:SetNextPrimaryFireSlowdown(curatt + delay) -- shadow for ONLY fire time

    local num = self:GetBuff("Num")

    num = num + self:GetBuff_Add("Add_Num")

    local tracer = self:GetBuff_Override("Override_Tracer", self.Tracer)
    local tracernum = self:GetBuff_Override("Override_TracerNum", self.TracerNum)
    local lastout = self:GetBuff_Override("Override_TracerFinalMag", self.TracerFinalMag)
    if lastout >= clip then
        tracernum = 1
        tracer = self:GetBuff_Override("Override_TracerFinal", self.TracerFinal) or self:GetBuff_Override("Override_Tracer", self.Tracer)
    end
    local dmgtable = self.BodyDamageMults
    dmgtable = self:GetBuff_Override("Override_BodyDamageMults") or dmgtable

    -- drive by is cool
    src = ArcCW:GetVehicleFireTrace(self:GetOwner(), src, dir) or src

    local bullet      = {}
    bullet.Attacker   = owner
    bullet.Dir        = dir
    bullet.Src        = src
    bullet.Spread     = Vector(0, 0, 0) --Vector(spread, spread, spread)
    bullet.Damage     = 0
    bullet.Num        = num

    local sglove = math.ceil(num / 3)
    bullet.Force      = self:GetBuff("Force", true) or math.Clamp( ( (50 / sglove) / ( (self:GetBuff("Damage") + self:GetBuff("DamageMin")) / (self:GetBuff("Num") * 2) ) ) * sglove, 1, 3 )
                        -- Overperforming weapons get the jerf, underperforming gets boost
    bullet.Distance   = self:GetBuff("Distance", true) or 33300
    -- Setting AmmoType makes the engine look for the tracer effect on the ammo instead of TracerName!
    --bullet.AmmoType   = self.Primary.Ammo
    bullet.HullSize   = self:GetBuff("HullSize")
    bullet.Tracer     = tracernum or 0
    bullet.TracerName = tracer
    bullet.Weapon     = self
    bullet.Callback = function(att, tr, dmg)
        ArcCW:BulletCallback(att, tr, dmg, self)
    end

    local shootent = self:GetBuff("ShootEntity", true) --self:GetBuff_Override("Override_ShootEntity", self.ShootEntity)
    local shpatt   = self:GetBuff_Override("Override_ShotgunSpreadPattern", self.ShotgunSpreadPattern)
    local shpattov = self:GetBuff_Override("Override_ShotgunSpreadPatternOverrun", self.ShotgunSpreadPatternOverrun)

    local extraspread = AngleRand() * self:GetDispersion() * ArcCW.MOAToAcc / 10

    local projectiledata = {}

    if shpatt or shpattov or shootent then
        if shootent then
            projectiledata.ent = shootent
            projectiledata.vel = self:GetBuff("MuzzleVelocity")
        end

        bullet = self:GetBuff_Hook("Hook_FireBullets", bullet)

        if !bullet then return end

        local doent = shootent and num or bullet.Num
        local minnum = shootent and 1 or 0

        if doent > minnum then
            for n = 1, bullet.Num do
                bullet.Num = 1

                local dispers = self:GetBuff_Override("Override_ShotgunSpreadDispersion", self.ShotgunSpreadDispersion)
                local offset  = self:GetShotgunSpreadOffset(n)
                local calcoff = dispers and (offset * self:GetDispersion() * ArcCW.MOAToAcc / 10) or offset

                local ang = owner:EyeAngles() + self:GetFreeAimOffset()
                local ang2 = Angle(ang)
                ang2:RotateAroundAxis(ang:Right(), -1 * calcoff.p)
                ang2:RotateAroundAxis(ang:Up(), calcoff.y)
                ang2:RotateAroundAxis(ang:Forward(), calcoff.r)

                if !self:GetBuff_Override("Override_NoRandSpread", self.NoRandSpread) then -- Needs testing
                    ang2 = ang2 + AngleRand() * spread / 5
                end

                if shootent then
                    projectiledata.ang = ang2

                    self:DoPrimaryFire(true, projectiledata)
                else
                    bullet.Dir = ang2:Forward()

                    self:DoPrimaryFire(false, bullet)
                end
            end
        elseif shootent then
            local ang = owner:EyeAngles() + self:GetFreeAimOffset()

            if !self:GetBuff_Override("Override_NoRandSpread", self.NoRandSpread) then
               -- ang = (dir + VectorRand() * spread / 5):Angle()

                local newdir = Vector(dir)
                self:ApplyRandomSpread(newdir, spread / 5)
                ang = newdir:Angle()
            end

            projectiledata.ang = ang

            self:DoPrimaryFire(true, projectiledata)
        end
    else
        if !bullet then return end

        for n = 1, bullet.Num do
            bullet.Num = 1
            local dirry = Vector(dir.x, dir.y, dir.z)
            math.randomseed(math.Round(util.SharedRandom(n, -1337, 1337, !game.SinglePlayer() and self:GetOwner():GetCurrentCommand():CommandNumber() or CurTime()) * (self:EntIndex() % 30241)) + desyncnum)
            if !self:GetBuff_Override("Override_NoRandSpread", self.NoRandSpread) then
                self:ApplyRandomSpread(dirry, spread)
                bullet.Dir = dirry
            end
            bullet = self:GetBuff_Hook("Hook_FireBullets", bullet) or bullet

            self:DoPrimaryFire(false, bullet)
        end
    end

    self:DoRecoil()

    self:SetNthShot(self:GetNthShot() + 1)

    owner:DoAnimationEvent(self:GetBuff_Override("Override_AnimShoot") or self.AnimShoot)

    local shouldsupp = SERVER and !game.SinglePlayer()

    if shouldsupp then SuppressHostEvents(owner) end

    self:DoEffects()

    self:SetBurstCount(self:GetBurstCount() + 1)

    self:TakePrimaryAmmo(aps)

    self:DoShootSound()
    self:DoPrimaryAnim()

    if self:GetCurrentFiremode().Mode < 0 and self:GetBurstCount() == self:GetBurstLength() then
        local postburst = (self:GetCurrentFiremode().PostBurstDelay or 0)
        self:SetWeaponOpDelay(CurTime() + postburst * self:GetBuff_Mult("Mult_PostBurstDelay") + self:GetBuff_Add("Add_PostBurstDelay"))
    end

    if (self:GetIsManualAction()) and !(self.NoLastCycle and self:Clip1() == 0) then
        local fireanim = self:GetBuff_Hook("Hook_SelectFireAnimation") or self:SelectAnimation("fire")
        local firedelay = self.Animations[fireanim].MinProgress or 0
        self:SetNeedCycle(true)
        self:SetWeaponOpDelay(CurTime() + (firedelay * self:GetBuff_Mult("Mult_CycleTime")))
        self:SetNextPrimaryFire(CurTime() + 0.1)
    end

    self:ApplyAttachmentShootDamage()

    self:AddHeat(self:GetBuff("HeatGain"))

    mal = self:DoMalfunction(true)
    if mal == true then
        local anim = "fire_jammed"
        self:PlayAnimation(anim, 1, true, 0, true)
    end

    if self:GetCurrentFiremode().Mode == 1 then
        self.LastTriggerTime = -1 -- Cannot fire again until trigger released
        self.LastTriggerDuration = 0
    end

    self:GetBuff_Hook("Hook_PostFireBullets")

    if shouldsupp then SuppressHostEvents(nil) end
end

local think_ct = 0
local count = 0
function SWEP:Think()
    if IsValid(self:GetOwner()) and self:GetClass() == "arccw_base" then
        self:Remove()
        return
    end

    local owner = self:GetOwner()

    if !IsValid(owner) or owner:IsNPC() then return end

    if CurTime() == think_ct then
        count = count + 1
        return
    else
        --if count > 1 then print(count) end
        count = 1
    end
    think_ct = CurTime()

    if self:GetState() == ArcCW.STATE_DISABLE and !self:GetPriorityAnim() then
        self:SetState(ArcCW.STATE_IDLE)
    end
    --[[-----> new sound table
    print(self:GetAnimationProgress())
    for i, v in ipairs(self.EventTable) do
        for emiton, bz in pairs(v) do
            if bz.EmitOnProgress then
                if self:GetAnimationProgress() < bz.EmitOnProgress then
                    continue
                end
            elseif emiton >= CurTime() then
                continue
            end

            if bz.AnimKey and (bz.AnimKey != self.LastAnimKey or bz.StartTime != self.LastAnimStartTime) then
                continue
            end

            self:PlayEvent(bz)
            self.EventTable[i][emiton] = nil
            --print(CurTime(), "Event completed at " .. i, emiton)
            if table.IsEmpty(v) and i != 1 then
                self.EventTable[i] = nil]] --[[print(CurTime(), "No more events at " .. i .. ", killing")]] 
            --[[end
        end
    end
    -----> new sound table]]

    for i, v in ipairs(self.EventTable) do
        for ed, bz in pairs(v) do
            if ed <= CurTime() then
                if bz.AnimKey and (bz.AnimKey != self.LastAnimKey or bz.StartTime != self.LastAnimStartTime) then
                    continue
                end
                self:PlayEvent(bz)
                self.EventTable[i][ed] = nil
                --print(CurTime(), "Event completed at " .. i, ed, bz.s)
                if table.IsEmpty(v) and i != 1 then self.EventTable[i] = nil --[[print(CurTime(), "No more events at " .. i .. ", killing")]] end
            end
        end
    end

    local vm = self.REAL_VM

    if CLIENT and (!game.SinglePlayer() and IsFirstTimePredicted() or true)
            and self:GetOwner() == LocalPlayer() and ArcCW.InvHUD
            and !ArcCW.Inv_Hidden and ArcCW.Inv_Fade == 0 then
        ArcCW.InvHUD:Remove()
        ArcCW.Inv_Fade = 0.01
    end

    

    self.BurstCount = self:GetBurstCount()

    local sg = self:GetShotgunReloading()
    if (sg == 2 or sg == 4) and owner:KeyPressed(IN_ATTACK) then
        self:SetShotgunReloading(sg + 1)
    elseif (sg >= 2) and self:GetReloadingREAL() <= CurTime() then
        self:ReloadInsert((sg >= 4) and true or false)
    end

    self:InBipod()
    if self:GetNeedCycle() and !self.Throwing and !self:GetReloading() and self:GetWeaponOpDelay() < CurTime() and self:GetNextPrimaryFire() < CurTime() and -- Adding this delays bolting if the RPM is too low, but removing it may reintroduce the double pump bug. Increasing the RPM allows you to shoot twice on many multiplayer servers. Sure would be convenient if everything just worked nicely
            (!GetConVar("arccw_clicktocycle"):GetBool() and (self:GetCurrentFiremode().Mode == 2 or !owner:KeyDown(IN_ATTACK))
            or GetConVar("arccw_clicktocycle"):GetBool() and (self:GetCurrentFiremode().Mode == 2 or owner:KeyPressed(IN_ATTACK))) then
        local anim = self:SelectAnimation("cycle")
        anim = self:GetBuff_Hook("Hook_SelectCycleAnimation", anim) or anim
        local mult = self:GetBuff_Mult("Mult_CycleTime")
        local p = self:PlayAnimation(anim, mult, true, 0, true, nil, true, nil, {SyncWithClient = true})
        if p then
            self:SetNeedCycle(false)
            self:SetPriorityAnim(CurTime() + self:GetAnimKeyTime(anim, true) * mult)
        end
    end

    if self:GetGrenadePrimed() and !(owner:KeyDown(IN_ATTACK) or owner:KeyDown(IN_ATTACK2)) and (!game.SinglePlayer() or SERVER) then
        self:Throw()
    end

    if self:GetGrenadePrimed() and self.GrenadePrimeTime > 0 and self.isCooked then
        local heldtime = (CurTime() - self.GrenadePrimeTime)

        local ft = self:GetBuff_Override("Override_FuseTime") or self.FuseTime

        if ft and (heldtime >= ft) and (!game.SinglePlayer() or SERVER) then
            self:Throw()
        end
    end

    if IsFirstTimePredicted() and self:GetNextPrimaryFire() < CurTime() and owner:KeyReleased(IN_USE) then
        if self:InBipod() then
            self:ExitBipod()
        else
            self:EnterBipod()
        end
    end

    if ((game.SinglePlayer() and SERVER) or (!game.SinglePlayer() and true)) and self:GetBuff_Override("Override_TriggerDelay", self.TriggerDelay) then
        if owner:KeyReleased(IN_ATTACK) and self:GetBuff_Override("Override_TriggerCharge", self.TriggerCharge) and self:GetTriggerDelta(true) >= 1 then
            self:PrimaryAttack()
        else
            self:DoTriggerDelay()
        end
    end

    if self:GetCurrentFiremode().RunawayBurst then

        if self:GetBurstCount() > 0 and ((game.SinglePlayer() and SERVER) or (!game.SinglePlayer() and true)) then
            self:PrimaryAttack()
        end

        if self:Clip1() < self:GetBuff("AmmoPerShot") or self:GetBurstCount() == self:GetBurstLength() then
            self:SetBurstCount(0)
            if !self:GetCurrentFiremode().AutoBurst then
                self.Primary.Automatic = false
            end
        end
    end

    if owner:KeyReleased(IN_ATTACK) then

        if !self:GetCurrentFiremode().RunawayBurst then
            self:SetBurstCount(0)
            self.LastTriggerTime = -1 -- Cannot fire again until trigger released
            self.LastTriggerDuration = 0
        end

        if self:GetCurrentFiremode().Mode < 0 and !self:GetCurrentFiremode().RunawayBurst then
            local postburst = self:GetCurrentFiremode().PostBurstDelay or 0

            if (CurTime() + postburst) > self:GetWeaponOpDelay() then
                --self:SetNextPrimaryFire(CurTime() + postburst)
                self:SetWeaponOpDelay(CurTime() + postburst * self:GetBuff_Mult("Mult_PostBurstDelay") + self:GetBuff_Add("Add_PostBurstDelay"))
            end
        end
    end

    if owner and owner:GetInfoNum("arccw_automaticreload", 0) == 1 and self:Clip1() == 0 and !self:GetReloading() and CurTime() > self:GetNextPrimaryFire() + 0.2 then
        self:Reload()
    end

    if (!(self:GetBuff_Override("Override_ReloadInSights") or self.ReloadInSights) and (self:GetReloading() or owner:KeyDown(IN_RELOAD))) then
        if !(self:GetBuff_Override("Override_ReloadInSights") or self.ReloadInSights) and self:GetReloading() then
            self:ExitSights()
        end
    end


    if self:GetBuff_Hook("Hook_ShouldNotSight") and (self.Sighted or self:GetState() == ArcCW.STATE_SIGHTS) then
        self:ExitSights()
    elseif self:GetHolster_Time() > 0 then
        self:ExitSights()
    else

        -- no it really doesn't, past me
        local sighted = self:GetState() == ArcCW.STATE_SIGHTS
        local toggle = owner:GetInfoNum("arccw_toggleads", 0) >= 1
        local suitzoom = owner:KeyDown(IN_ZOOM)
        local sp_cl = game.SinglePlayer() and CLIENT

        -- if in singleplayer, client realm should be completely ignored
        if toggle and !sp_cl then
            if owner:KeyPressed(IN_ATTACK2) then
                if sighted then
                    self:ExitSights()
                elseif !suitzoom then
                    self:EnterSights()
                end
            elseif suitzoom and sighted then
                self:ExitSights()
            end
        elseif !toggle then
            if (owner:KeyDown(IN_ATTACK2) and !suitzoom) and !sighted then
                self:EnterSights()
            elseif (!owner:KeyDown(IN_ATTACK2) or suitzoom) and sighted then
                self:ExitSights()
            end
        end

    end

    if (!game.SinglePlayer() and IsFirstTimePredicted()) or (game.SinglePlayer() and true) then
        if self:InSprint() and (self:GetState() != ArcCW.STATE_SPRINT) then
            self:EnterSprint()
        elseif !self:InSprint() and (self:GetState() == ArcCW.STATE_SPRINT) then
            self:ExitSprint()
        end
    end

    if game.SinglePlayer() or IsFirstTimePredicted() then
        self:SetSightDelta(math.Approach(self:GetSightDelta(), self:GetState() == ArcCW.STATE_SIGHTS and 0 or 1, FrameTime() / self:GetSightTime()))
        self:SetSprintDelta(math.Approach(self:GetSprintDelta(), self:GetState() == ArcCW.STATE_SPRINT and 1 or 0, FrameTime() / self:GetSprintTime()))
    end

    if CLIENT and (game.SinglePlayer() or IsFirstTimePredicted()) then
        self:ProcessRecoil()
    end

    if CLIENT and IsValid(vm) then

        for i = 1, vm:GetBoneCount() do
            vm:ManipulateBoneScale(i, vec1)
        end

        for i, k in pairs(self:GetBuff_Override("Override_CaseBones", self.CaseBones) or {}) do
            if !isnumber(i) then continue end
            for _, b in pairs(istable(k) and k or {k}) do
                local bone = vm:LookupBone(b)

                if !bone then continue end

                if self:GetVisualClip() >= i then
                    vm:ManipulateBoneScale(bone, vec1)
                else
                    vm:ManipulateBoneScale(bone, vec0)
                end
            end
        end

        for i, k in pairs(self:GetBuff_Override("Override_BulletBones", self.BulletBones) or {}) do
            if !isnumber(i) then continue end
            for _, b in pairs(istable(k) and k or {k}) do
                local bone = vm:LookupBone(b)

                if !bone then continue end

                if self:GetVisualBullets() >= i then
                    vm:ManipulateBoneScale(bone, vec1)
                else
                    vm:ManipulateBoneScale(bone, vec0)
                end
            end
        end

        for i, k in pairs(self:GetBuff_Override("Override_StripperClipBones", self.StripperClipBones) or {}) do
            if !isnumber(i) then continue end
            for _, b in pairs(istable(k) and k or {k}) do
                local bone = vm:LookupBone(b)

                if !bone then continue end

                if self:GetVisualLoadAmount() >= i then
                    vm:ManipulateBoneScale(bone, vec1)
                else
                    vm:ManipulateBoneScale(bone, vec0)
                end
            end
        end
    end

    self:DoHeat()

    self:ThinkFreeAim()

    -- if CLIENT then
        -- if !IsValid(ArcCW.InvHUD) then
        --     gui.EnableScreenClicker(false)
        -- end

        -- if self:GetState() != ArcCW.STATE_CUSTOMIZE then
        --     self:CloseCustomizeHUD()
        -- else
        --     self:OpenCustomizeHUD()
        -- end
    -- end

    for i, k in pairs(self.Attachments) do
        if !k.Installed then continue end
        local atttbl = ArcCW.AttachmentTable[k.Installed]

        if atttbl.DamagePerSecond then
            local dmg = atttbl.DamagePerSecond * FrameTime()

            self:DamageAttachment(i, dmg)
        end
    end

    if CLIENT then
        self:DoOurViewPunch()
    end

    if self.Throwing and self:Clip1() == 0 and self:Ammo1() > 0 then
        self:SetClip1(1)
        owner:SetAmmo(self:Ammo1() - 1, self.Primary.Ammo)
    end

    -- self:RefreshBGs()

    if self:GetMagUpIn() != 0 and CurTime() > self:GetMagUpIn() then
        self:ReloadTimed()
        self:SetMagUpIn( 0 )
    end

    if self:HasBottomlessClip() and self:Clip1() != ArcCW.BottomlessMagicNumber then
        self:Unload()
        self:SetClip1(ArcCW.BottomlessMagicNumber)
    elseif !self:HasBottomlessClip() and self:Clip1() == ArcCW.BottomlessMagicNumber then
        self:SetClip1(0)
    end

    -- Performing traces in rendering contexts seem to cause flickering with c_hands that have QC attachments(?)
    -- Since we need to run the trace every tick anyways, do it here instead
    if CLIENT then
        self:BarrelHitWall()
    end

    self:GetBuff_Hook("Hook_Think")

    -- Running this only serverside in SP breaks animation processing and causes CheckpointAnimation to !reset.
    --if SERVER or !game.SinglePlayer() then
        self:ProcessTimers()
    --end

    -- Only reset to idle if we don't need cycle. empty idle animation usually doesn't play nice
    if !self:GetPriorityAnim() and self:GetNextIdle() != 0 and self:GetNextIdle() <= CurTime() and !self:GetNeedCycle()
            and self:GetHolster_Time() == 0 and self:GetShotgunReloading() == 0 then
        self:SetNextIdle(0)
        self:PlayIdleAnimation(true)
    end

    if self:GetUBGLDebounce() and !self:GetOwner():KeyDown(IN_RELOAD) then
        self:SetUBGLDebounce( false )
    end
end

function SWEP:AddElement(elementname, wm)
    local e = self.AttachmentElements[elementname]

    if !e then return end
    if !wm and self:GetOwner():IsNPC() then return end

    if !self:CheckFlags(e.ExcludeFlags, e.RequireFlags) then return end

    if GetConVar("arccw_truenames"):GetBool() and e.TrueNameChange then
        self.PrintName = e.TrueNameChange
    elseif GetConVar("arccw_truenames"):GetBool() and e.NameChange then
        self.PrintName = e.NameChange
    end

    if !GetConVar("arccw_truenames"):GetBool() and e.NameChange then
        self.PrintName = e.NameChange
    elseif !GetConVar("arccw_truenames"):GetBool() and e.TrueNameChange then
        self.PrintName = e.TrueNameChange
    end

    if e.AddPrefix then
        self.PrintName = e.AddPrefix .. self.PrintName
    end

    if e.AddSuffix then
        self.PrintName = self.PrintName .. e.AddSuffix
    end

    local og_weapon = weapons.GetStored(self:GetClass())

    local og_vm = og_weapon.ViewModel
    local og_wm = og_weapon.WorldModel

    self.ViewModel = og_vm
    self.WorldModel = og_wm

    local parent = self
    local elements = self.WM

    if !wm then
        parent = CLIENT and self.REAL_VM or self:GetOwner():GetViewModel()
        elements = self.VM
    end

    local eles = e.VMElements

    if wm then
        eles = e.WMElements

        if self.MirrorVMWM then
            self.WorldModel = e.VMOverride or self.WorldModel
            self:SetSkin(e.VMSkin or self.DefaultSkin)
            eles = e.VMElements
        else
            self.WorldModel = e.WMOverride or self.WorldModel
            self:SetSkin(e.WMSkin or self.DefaultWMSkin)
        end
    else
        self.ViewModel = e.VMOverride or self.ViewModel
        self.REAL_VM:SetSkin(e.VMSkin or self.DefaultSkin)
    end

    if SERVER then return end

    for _, i in pairs(eles or {}) do
        local model = ClientsideModel(i.Model)

        if !model or !IsValid(model) or !IsValid(self) then continue end

        if i.BoneMerge then
            model:SetParent(parent)
            model:AddEffects(EF_BONEMERGE)
        else
            model:SetParent(self)
        end

        local element = {}

        local scale = Matrix()
        scale:Scale(i.Scale or Vector(1, 1, 1))

        model:SetNoDraw(ArcCW.NoDraw)
        model:DrawShadow(false)
        model.Weapon = self
        model:SetSkin(i.ModelSkin or 0)
        if i.Material then
            model:SetMaterial(i.Material)
        end
        if i.Color then
            model:SetRenderMode( RENDERMODE_TRANSCOLOR )
            model:SetColor(i.Color)
        end
        --model:SetBodyGroups(i.ModelBodygroups or "")
        ArcCW.SetBodyGroups(model, i.ModelBodygroups or "")
        model:EnableMatrix("RenderMultiply", scale)
        model:SetupBones()
        element.Model = model
        element.DrawFunc = i.DrawFunc
        element.WM = wm or false
        element.Bone = i.Bone
        element.NoDraw = i.NoDraw or false
        element.BoneMerge = i.BoneMerge or false
        element.Bodygroups = i.ModelBodygroups
        element.DrawFunc = i.DrawFunc
        element.OffsetAng = Angle()
        element.OffsetAng:Set(i.Offset.ang or Angle(0, 0, 0))
        element.OffsetPos = Vector()
        element.OffsetPos:Set(i.Offset.pos or Vector(), 0, 0)
        element.IsMuzzleDevice = i.IsMuzzleDevice

        if self.MirrorVMWM then
            element.WMBone = i.Bone
        else
            element.WMBone = i.WMBone
        end

        table.insert(elements, element)
    end

end

function SWEP:PlayEvent(v)
    if !v or !istable(v) then error("no event to play") end
    v = self:GetBuff_Hook("Hook_PrePlayEvent", v) or v
    if v.e and IsFirstTimePredicted() then
        DoShell(self, v)
    end

    if v.s then
        if v.s_km then
            self:StopSound(v.s)
        end
        self:MyEmitSound(v.s, v.l, v.p, v.v, v.c or CHAN_AUTO)
    end

    if v.bg then
        self:SetBodygroupTr(v.ind or 0, v.bg)
    end

    if v.pp then
        local vm = self.REAL_VM

        vm:SetPoseParameter(pp, ppv)
    end

    v = self:GetBuff_Hook("Hook_PostPlayEvent", v) or v
end
