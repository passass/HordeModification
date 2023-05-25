SWEP.Base = "arccw_base"

DEFINE_BASECLASS(SWEP.Base)

SWEP.ChargeWeapon = true -- useful for bows
SWEP.Charge_Speed = 1 -- Time for Full Charge
SWEP.Charge_ReloadAfter_Enabled = true -- useful for bows
SWEP.Charge_ReloadAfter_Timer = 1 -- useful for bows

SWEP.Charge_ToShootMustHasFullCharge = false -- useful for bows

function SWEP:Charge_StartAt()
    return self:GetNWFloat("Charge_Start") or 0
    -- 0 - means that it don't even start
end

function SWEP:Charge_GetSpeed()
    local ChargeProgressFilingSpeed = self:GetNWFloat("Charge_ProgressFilingSpeed")
    if ChargeProgressFilingSpeed != 0 then
        return ChargeProgressFilingSpeed
    end
    return self:GetBuff("Charge_Speed")
end

function SWEP:Charge_ReloadAfter_Start()
    local isreloadafter = self:GetBuff_Override("Charge_ReloadAfter_Enabled", self.Charge_ReloadAfter_Enabled)
    if isreloadafter then

        local time = CurTime() + self:GetBuff("Charge_ReloadAfter_Timer")

        self:SetReloading(time)

        self:SetMagUpCount(0)
        self:SetMagUpIn(time)
    end
end

function SWEP:Charge_Finish()
    self:SetNWFloat("Charge_Start", 0)
    self:SetNWFloat("Charge_ProgressFilingSpeed", 0)
end

function SWEP:Charge_Progress()
    local startat = self:Charge_StartAt()
    if startat == 0 then return 0 end
    return math.min((
        CurTime() -
        startat) /
        self:Charge_GetSpeed(),
        1)
end

SWEP.Charge_Sounds_HasUnchargedSound = false
SWEP.Charge_Sounds_UnchargedSound = ""

function SWEP:Charge_Sounds_StopCharging()
    local key = self:SelectAnimation("charging")
    local anim = self.Animations[key]

    for _, v in pairs(anim.SoundTable) do
        self:StopSound(v.s)
    end
end

function SWEP:PrimaryAttack()
end

function SWEP:Hook_OnHolsterEnd()
    self:SetNWFloat("Charge_Start", 0)
    self:SetNWFloat("Charge_End", 0)
end

function SWEP:Hook_OnDeploy()
    self:SetNWFloat("Charge_Start", 0)
    self:SetNWFloat("Charge_End", 0)
end

function SWEP:Hook_Think()
    local owner = self:GetOwner()

    local res = self:GetBuff_Hook("Hook_Charge_Think")
    if res then return end

    if self:GetHolster_Time() != 0 or self:CanPrimaryAttack() == false or !IsValid(owner) or self:Clip1() == 0 or self:GetNextPrimaryFire() > CurTime() then return end

    local chargestart = self:GetNWFloat("Charge_Start")
    if owner:KeyDown(IN_ATTACK) then
        if chargestart == 0 then
            self:SetNWFloat("Charge_Start", CurTime())
            self:SetNWFloat("Charge_ProgressFilingSpeed", self:GetBuff("Charge_Speed"))

            local anim = self:SelectAnimation("charging")

            self:PlayAnimation(anim, nil, true, 0, false)
        end
    else
        if chargestart != 0 and (!self:GetBuff_Override("Charge_ToShootMustHasFullCharge", self.Charge_ToShootMustHasFullCharge) or self:Charge_Progress() == 1) then
            self:Charge_Sounds_StopCharging()

            local charge_progress = self:Charge_Progress()
            self:SetNWFloat("Charge_End", charge_progress)
            self:Charge_Finish()

            local fm = self:GetCurrentFiremode()

            local mode = fm.Mode

            if mode == 0 then return end

            self:DoRecoil()

            owner:DoAnimationEvent(self:GetBuff_Override("Override_AnimShoot") or self.AnimShoot)

            local shouldsupp = SERVER and !game.SinglePlayer()

            if shouldsupp then SuppressHostEvents(owner) end

            self:DoEffects()

            self:TakePrimaryAmmo(self:GetBuff("AmmoPerShot"))

            if SERVER then self:DoShootSound() end
            self:DoPrimaryAnim()
            self:Charge_ReloadAfter_Start()

            local delay = self:GetFiringDelay()

            if self:GetBuff_Override("Charge_ReloadAfter_Enabled", self.Charge_ReloadAfter_Enabled) then

                local chargereloadaftertimer = self:GetBuff("Charge_ReloadAfter_Timer")
                if chargereloadaftertimer > delay then
                    delay = chargereloadaftertimer
                end

            end

            local curtime = CurTime()
            local curatt = self:GetNextPrimaryFire()
            local diff = curtime - curatt

            if diff > engine.TickInterval() or diff < 0 then
                curatt = curtime
            end

            self:SetNextPrimaryFire(curatt + delay)
            self:SetNextPrimaryFireSlowdown(curatt + delay)

            local tracer = self:GetBuff_Override("Override_Tracer", self.Tracer)
            local tracernum = self:GetBuff_Override("Override_TracerNum", self.TracerNum)

            local num = 1
            local src = self:GetShootSrc()
            local dir = (owner:EyeAngles() + self:GetFreeAimOffset()):Forward()
            local sglove = math.ceil(num / 3)

            src = ArcCW:GetVehicleFireTrace(self:GetOwner(), src, dir) or src

            owner:FireBullets({
                Src = src,
                Force      = self:GetBuff("Force", true) or math.Clamp( ( (50 / sglove) / ( (self:GetBuff("Damage") + self:GetBuff("DamageMin")) / (self:GetBuff("Num") * 2) ) ) * sglove, 1, 3 ),
                Distance   = self:GetBuff("Distance", true) or 33300,
                HullSize   = self:GetBuff("HullSize"),
                Num = 1,
                Damage = 0,
                Attacker = owner,
                Dir = dir,
                Spread = Vector(0, 0, 0),--Vector(fixedcone, fixedcone, 0),
                Weapon = self,
                TracerName = tracer,
                Tracer = tracernum or 0,
                Callback = function(att, tr, dmg)
                    ArcCW:BulletCallback(att, tr, dmg, self)
                    dmg:ScaleDamage(charge_progress)
                end
            })
        end
    end
end

function SWEP:Hook_FireBullets()
    return false
end

function SWEP:Hook_GetShootSound(sound)
    if self:GetBuff_Override("Charge_Sounds_HasUnchargedSound", self.Charge_Sounds_HasUnchargedSound) and self:GetNWFloat("Charge_End") < 0.9 then
        return self:GetBuff_Override("Charge_Sounds_UnchargedSound", self.Charge_Sounds_UnchargedSound)
    end
end

function SWEP:Initialize()
    BaseClass.Initialize(self)
    self:SetNWFloat("Charge_Start", 0)
    self:SetNWFloat("Charge_ProgressFilingSpeed", 0)
    self:SetNWFloat("Charge_End", 0)
end