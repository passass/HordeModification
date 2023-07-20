if !HORDE.Syringe then return end
if not ArcCWInstalled then return end

HORDE:Sound_AddWeaponSound("TFA_MW2R_C4.Plant", {"weapons/tfa_mw2r/c4/wpn_h1_c4_bounce_01.wav", "weapons/tfa_mw2r/c4/wpn_h1_c4_bounce_02.wav"})
HORDE:Sound_AddWeaponSound("TFA_MW2R_C4.Trigger", "weapons/tfa_mw2r/c4/wpn_h1_c4_trigger_plr.wav")
HORDE:Sound_AddWeaponSound("TFA_MW2R_C4.Draw", "weapons/tfa_mw2r/c4/wpn_h1_c4_safetyoff_plr.wav")
HORDE:Sound_AddWeaponSound("TFA_MW2R_C4.Holster", "weapons/tfa_mw2r/c4/wpn_h1_c4_safety_plr.wav")
HORDE:Sound_AddWeaponSound("TFA_MW2R_C4.Toss", "weapons/tfa_mw2r/c4/toss.wav")
HORDE:Sound_AddWeaponSound("TFA_MW2R_CLYMR.Plant", {"weapons/tfa_mw2r/claymore/wpn_h1_claymore_plant_01.wav", "weapons/tfa_mw2r/claymore/wpn_h1_claymore_plant_02.wav"})
HORDE:Sound_AddWeaponSound("TFA_MW2R_CLYMR.Activate", "weapons/tfa_mw2r/claymore/wpn_h1_claymore_activate.wav")
HORDE:Sound_AddWeaponSound("TFA_MW2R_CLYMR.Pin", "weapons/tfa_mw2r/claymore/wpn_h1_claymore_pin.wav")
HORDE:Sound_AddWeaponSound("TFA_MW2R_CLYMR.Look1", "weapons/tfa_mw2r/claymore/wpn_h1_claymore_ins_look_01.wav")
HORDE:Sound_AddWeaponSound("TFA_MW2R_CLYMR.Look2", "weapons/tfa_mw2r/claymore/wpn_h1_claymore_ins_look_02.wav")
HORDE:Sound_AddWeaponSound("TFA_MW2R_CLYMR.Rest", "weapons/tfa_mw2r/claymore/wpn_h1_claymore_ins_rest.wav")

SWEP.Base = "arccw_hordeext_base_nade"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "C4"
SWEP.ForceDefaultAmmo = 0

SWEP.Slot = 4

SWEP.NotForNPCs = true

SWEP.UseHands = true
SWEP.ViewModel				= "models/weapons/tfa_mw2cr/c4/c_c4.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/tfa_mw2cr/c4/w_detonator.mdl"	-- Weapon world model
SWEP.ViewModelFOV = 70

SWEP.WorldModelOffset = {
    pos = Vector(3, 2, -1),
    ang = Angle(-10, 0, 180)
}

SWEP.Throwing = true

SWEP.Primary.ClipSize = 1


SWEP.MuzzleVelocity = 600
SWEP.Horde_MaxMags = 12

game.AddAmmoType( {
	name = "ammo_c4",
	dmgtype = DMG_BLAST,
} )

SWEP.Primary.Ammo = "ammo_c4"
SWEP.ShootEntity 			= "horde_c4_exp"	--NAME OF ENTITY GOES HERE

SWEP.TTTWeaponType = "weapon_zm_molotov"
SWEP.NPCWeaponType = "weapon_grenade"
SWEP.NPCWeight = 50

--SWEP.Override_ShootEntityDelay = 3
SWEP.PullPinTime = 0.001

function SWEP:Throw()
    if self:GetNextPrimaryFire() > CurTime() then return end

    local isCooked = self.isCooked
    self:SetGrenadePrimed(false)
    self.isCooked = nil

    local alt = self:GetGrenadeAlt()

    local anim = alt and self:SelectAnimation("throw_alt") or self:SelectAnimation("throw")
    self:PlayAnimation(anim, self:GetBuff_Mult("Mult_ThrowTime"), false, 0, true, nil, nil, nil, {SyncWithClient = true})

    local animevent = alt and self:GetBuff_Override("Override_AnimShootAlt", self.AnimShootAlt) or self:GetBuff_Override("Override_AnimShoot", self.AnimShoot)
    self:GetOwner():DoAnimationEvent(animevent)

    local heldtime = CurTime() - self.GrenadePrimeTime

    local mv = 0

    if alt then
        mv = self:GetBuff("MuzzleVelocityAlt", true) or self:GetBuff("MuzzleVelocity")
    else
        mv = self:GetBuff("MuzzleVelocity")
        --local chg = self:GetBuff("WindupTime")
        --if chg > 0 then
        --    mv = Lerp(math.Clamp(heldtime / chg, 0, 1), mv * self:GetBuff("WindupMinimum"), mv)
        --end
    end

    local force = mv * ArcCW.HUToM

    self:SetTimer(self:GetBuff("ShootEntityDelay"), function()

        local ft = self:GetBuff("FuseTime", true)
        local data = {
            dodefault = true,
            force = force,
            shootentity = self:GetBuff_Override("Override_ShootEntity", self.ShootEntity),
            fusetime = ft and (ft - (isCooked and heldtime or 0)),
        }
        local ovr = self:GetBuff_Hook("Hook_Throw", data)
        if !ovr or ovr.dodefault then
            local rocket
            if self.SecondaryThrow then
                rocket = self:FireRocket(self:GetBuff_Override("Override_ShootEntity", self.ShootEntity), 200)
            else
                rocket = self:FireRocket(self:GetBuff_Override("Override_ShootEntity", self.ShootEntity), force / ArcCW.HUToM)
            end
            
            if !rocket then return end

            if ft then
                if isCooked then
                    rocket.FuseTime = ft - heldtime
                else
                    rocket.FuseTime = ft
                end
            else
                rocket.FuseTime = math.huge
            end

            local phys = rocket:GetPhysicsObject()

            local inertia = self:GetBuff_Override("Override_ThrowInertia", self.ThrowInertia)
            if inertia == nil then inertia = GetConVar("arccw_throwinertia"):GetBool() end
            if inertia and mv > 100 then
                phys:AddVelocity(self:GetOwner():GetVelocity())
            end

            phys:AddAngleVelocity( Vector(0, 750, 0) )
        end
        if !self:HasInfiniteAmmo() then
            local aps = self:GetBuff("AmmoPerShot")
            local a1 = self:Ammo1()
            if self:HasBottomlessClip() or a1 >= aps then
                self:TakePrimaryAmmo(aps)
            elseif a1 < aps then
                self:SetClip1(math.min(self:GetCapacity() + self:GetChamberSize(), self:Clip1() + a1))
                self:TakePrimaryAmmo(a1)
            end

            if (self.Singleton or self:Ammo1() == 0) then
                local clip = self:Clip1()
                if !self:GetBuff_Override("Override_KeepIfEmpty", self.KeepIfEmpty) then
                    self:GetOwner():StripWeapon(self:GetClass())
                    return
                elseif aps >= clip then
                    self:SetClip1(0)
                end
            end
        end

    end)
    local t = self:GetAnimKeyTime(anim) * self:GetBuff_Mult("Mult_ThrowTime")
    self:SetPriorityAnim(CurTime() + t)

    self:SetNextPrimaryFire(CurTime() + self:GetFiringDelay())

    self:SetGrenadeAlt(false)

    self:SetShouldHoldType()

    self:GetBuff_Hook("Hook_PostThrow")
end

SWEP.ShootWhileSprint = false
SWEP.Animations = {
    ["draw"] = {
        Source = "draw",
    },
    ["holster"] = {
        Source = "holster",
    },
    --[[["pre_throw"] = {
        Source = "pullpin",
        Time = 0.25,
    },]]
    ["throw"] = {
        Source = "throw",
        TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
    },
    ["throw_cook"] = {
        Source = "fire",
        SoundTable = {
            {s = Sound("TFA_MW2R_C4.Trigger"), t = 0}
        }
    },

    ["enter_sprint"] = {
        Source = "sprint_in",
        Time = 10 / 30
    },
    ["idle_sprint"] = {
        Source = "sprint_loop",
        Time = 30 / 40
    },
    ["exit_sprint"] = {
        Source = "sprint_out",
        Time = 10 / 30
    },
}

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end

	self:Throw()
end

function SWEP:DetonateC4()
	if not SERVER then return end
	local ply = self:GetOwner()
	if IsValid(ply) and ply:IsPlayer() then
		for k, v in pairs(self:GetBombs()) do
			timer.Simple(.05 * k, function()
				if IsValid(v) then
					v:Explode()
				end
			end)
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
        --rocket:SetCollisionGroup(rocket.CollisionGroup or COLLISION_GROUP_DEBRIS)
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

function SWEP:SecondaryAttack()
	--local owner = self:GetOwner()

    -- Should we not fire? But first.
    if self:GetBuff_Hook("Hook_ShouldNotFireFirst") then return end

    -- We're holstering
    if IsValid(self:GetHolster_Entity()) then return end
    if self:GetHolster_Time() > 0 then return end

    -- Disabled (currently used only by deploy)
    if self:GetState() == ArcCW.STATE_DISABLE then return end

    -- Coostimzing
    if self:GetState() == ArcCW.STATE_CUSTOMIZE then
        if CLIENT and ArcCW.Inv_Hidden then
            ArcCW.Inv_Hidden = false
            gui.EnableScreenClicker(true)
        elseif game.SinglePlayer() then
            -- Kind of ugly hack: in SP this is only called serverside so we ask client to do the same check
            self:CallOnClient("CanPrimaryAttack")
        end
        return
    end

    -- A priority animation is playing (reloading, cycling, firemode etc)
    if self:GetPriorityAnim() then return end

    -- Inoperable, but internally (burst resetting for example)
    if self:GetWeaponOpDelay() > CurTime() then return end

	self:DetonateC4()
    self:PlayAnimationWithSync("throw_cook", nil, false, 0, true)
    self:SetPriorityAnim(CurTime() + self:GetAnimKeyTime("throw_cook"))
end

function SWEP:GetBombs()
	local bombs = {}
	local ply = self:GetOwner()
	for _, ent in pairs(ents.FindByClass("horde_c4_exp")) do
		if IsValid(ent) and ent:GetOwner() == ply then
			table.insert(bombs, ent)
		end
	end
	return bombs
end

function SWEP:Hook_PostFireRocket(ent)
    ent.Cooked = math.huge
    
    local angvel = Vector(0,math.random(-2000,-1500),math.random(-1500,-2000)) //The positive z coordinate emulates the spin from a right-handed overhand throw
	angvel:Rotate(-1 * ent:EyeAngles())
	angvel:Rotate(Angle(0, self:GetOwner():EyeAngles().y,0))
	
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:AddAngleVelocity(angvel)
	end

	local bombs = self:GetBombs()
	local totalcount = 5--self.Horde_MaxMags + 1
	if #bombs > totalcount then
		for i = 1, #bombs - totalcount do
			bombs[1]:Remove()
		end
	end
end