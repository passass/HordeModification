if not ArcCWInstalled then return end
SWEP.Base = "arccw_hordeext_base_nade"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Claymore"
SWEP.ForceDefaultAmmo = 0

SWEP.Slot = 4

SWEP.NotForNPCs = true

SWEP.UseHands = true
SWEP.ViewModel			= "models/weapons/tfa_mw2cr/claymore/c_claymore.mdl"
SWEP.ViewModelFOV = 70
SWEP.WorldModel			= "models/weapons/tfa_mw2cr/claymore/w_claymore.mdl"

SWEP.WorldModelOffset = {
    pos = Vector(3, 2, -1),
    ang = Angle(-10, 0, 180)
}

SWEP.Throwing = true

SWEP.Primary.ClipSize = 1


SWEP.MuzzleVelocity = 0
SWEP.Horde_MaxMags = 15

game.AddAmmoType( {
	name = "ammo_claymore",
} )

SWEP.Primary.Ammo = "ammo_claymore"
SWEP.ShootEntity 			= "horde_claymore_exp"	--NAME OF ENTITY GOES HERE

SWEP.TTTWeaponType = "weapon_zm_molotov"
SWEP.NPCWeaponType = "weapon_grenade"
SWEP.NPCWeight = 50

--SWEP.Override_ShootEntityDelay = 3
SWEP.PullPinTime = 0.001
SWEP.ShootEntityAngleCorrection = false
SWEP.ShootWhileSprint = false
SWEP.Animations = {
    ["draw"] = {
        Source = "draw",
        SoundTable = {
            {s = Sound("TFA_MW2R_MED.Draw"), t = 0}
        }
    },
    ["holster"] = {
        Source = "holster",
        
    },
    --[[["pre_throw"] = {
        Source = "pullpin",
        Time = 0.25,
    },]]
    ["throw"] = {
        Source = "fire",
        TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
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

function SWEP:SecondaryAttack()
end

function SWEP:Hook_PostFireRocket(ent)

    ent:SetPos(self:GetOwner():GetShootPos() + (self:GetOwner():GetForward() * 15))
	ent:SetAngles(self:GetOwner():GetForward():Angle() + Angle(0,-90,0))

    ent:SetModel("models/weapons/tfa_mw2cr/claymore/claymore_armed.mdl")

    local dir = (Vector(0,0,-90))
	dir:Mul(0)

	ent:SetVelocity(dir)
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocity(dir)
	end

	local ply = self:GetOwner()
	local bombs = {}
	for _, ent_ in pairs(ents.FindByClass("horde_claymore_exp")) do
		if IsValid(ent_) and ent_:GetOwner() == ply then
			table.insert(bombs, ent_)
		end
	end
	if #bombs > 5 then
		for i = 1, #bombs - 5 do
			bombs[1]:Remove()
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
