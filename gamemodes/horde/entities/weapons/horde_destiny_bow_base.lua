--just a slightly modified version of the default tfa bow base

-- Copyright (c) 2018-2020 TFA Base Devs

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

if SERVER then
	AddCSLuaFile()
end

DEFINE_BASECLASS("destiny_bow_base")

function SWEP:DoDrawCrosshair() end
function SWEP:DrawHUDAmmo()
end
function SWEP:GenerateInspectionDerma() end

local AttachArrowModel = function(a, b, c, wep)
	c:SetDamageType(bit.bor(DMG_NEVERGIB, DMG_CLUB))
	if CLIENT then return end
	if not IsValid(wep) then return end

	local arrowstuck

	if b.HitWorld and not (IsValid(b.Entity) and not b.Entity:IsWorld()) then
		arrowstuck = ents.Create("tfbow_arrow_stuck")
		arrowstuck:SetModel(wep:GetStatL("BulletModel"))
		arrowstuck.gun = wep:GetClass()
		arrowstuck:SetPos(b.HitPos)
		arrowstuck:SetAngles(b.Normal:Angle())
		arrowstuck:Spawn()
	else
		arrowstuck = ents.Create("tfbow_arrow_stuck_clientside")
		arrowstuck:SetModel(wep:GetStatL("BulletModel"))
		arrowstuck:SetModel(wep:GetStatL("BulletModel"))
		arrowstuck.gun = wep:GetClass()
		arrowstuck:SetPos(b.HitPos)
		arrowstuck:SetAngles(b.Normal:Angle())
		arrowstuck.targent = b.Entity
		arrowstuck.targphysbone = b.PhysicsBone or -1
		arrowstuck:Spawn()
	end
	
	c:SetDamageType(wep.Primary.DamageType)

	if c:IsDamageType(DMG_BLAST) and wep.Primary.DamageTypeHandled and b.Hit and not b.HitSky then
		
		local tmpdmg = c:GetDamage()
		c:SetDamageForce(c:GetDamageForce() / 2)
		util.BlastDamageInfo(c, b.HitPos, wep:GetStatL("Primary.BlastRadius") or (tmpdmg / 2)  )
		--util.BlastDamage(weapon, weapon:GetOwner(), traceres.HitPos, tmpdmg / 2, tmpdmg)
		local fx = EffectData()
		fx:SetOrigin(b.HitPos)
		fx:SetNormal(b.HitNormal)

		if wep:GetStatL("Primary.ImpactEffect") then
			TFA.Effects.Create(wep:GetStatL("Primary.ImpactEffect"), fx)
		elseif tmpdmg > 200 then
			TFA.Effects.Create("HelicopterMegaBomb", fx)
			TFA.Effects.Create("Explosion", fx)
		elseif tmpdmg > 45 then
			TFA.Effects.Create("cball_explode", fx)
		else
			TFA.Effects.Create("MuzzleEffect", fx)
		end

		c:ScaleDamage(0.15)
	end

	wep.LastArrow = arrowstuck
end

local ballistics_distcv = GetConVar("sv_tfa_ballistics_mindist")

local function BallisticFirebullet(ply, bul, ovr)
	local wep = ply:GetActiveWeapon()

	if TFA.Ballistics and TFA.Ballistics:ShouldUse(wep) then
		if ballistics_distcv:GetInt() == -1 or ply:GetEyeTrace().HitPos:Distance(ply:GetShootPos()) > (ballistics_distcv:GetFloat() * TFA.Ballistics.UnitScale) then
			bul.SmokeParticle = bul.SmokeParticle or wep.BulletTracer or wep.TracerBallistic or wep.BallisticTracer or wep.BallisticsTracer

			if ovr then
				TFA.Ballistics:FireBullets(wep, bul, angle_zero, true)
			else
				TFA.Ballistics:FireBullets(wep, bul)
			end
		else
			ply:FireBullets(bul)
		end
	else
		ply:FireBullets(bul)
	end
end

local cv_forcemult = GetConVar("sv_tfa_force_multiplier")

function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone, disablericochet, bulletoverride)
	if not IsFirstTimePredicted() and not game.SinglePlayer() then return end
	local chargeTable = self:GetStatL("Primary.Damage_Charge")
	local mult = Lerp(math.Clamp(self:GetCharge() - self.ChargeThreshold, 0, 1 - self.ChargeThreshold) / (1 - self.ChargeThreshold), chargeTable[1], chargeTable[2])
	local unitScale = TFA.Ballistics.UnitScale or TFA.UnitScale or 40
	num_bullets = num_bullets or 1
	aimcone = aimcone or 0
	self.MainBullet.Attacker = self:GetOwner()
	self.MainBullet.Inflictor = self
	self.MainBullet.Num = num_bullets
	self.MainBullet.Src = self:GetOwner():GetShootPos()
	self.MainBullet.Dir = self:GetOwner():EyeAngles():Forward()
	self.MainBullet.HullSize = 2
	self.MainBullet.Spread.x = aimcone
	self.MainBullet.Spread.y = aimcone

	if self.TracerPCF then
		self.MainBullet.Tracer = 0
	else
		self.MainBullet.Tracer = self:GetStatL("TracerCount") or 3
	end

	self.MainBullet.PenetrationCount = 1
	self.MainBullet.AmmoType = self:GetPrimaryAmmoType()
	self.MainBullet.Force = self:GetStatL("Primary.Force") * cv_forcemult:GetFloat() * self:GetAmmoForceMultiplier() * mult
	self.MainBullet.Damage = damage * mult
	self.MainBullet.HasAppliedRange = true
	self.MainBullet.Velocity = self:GetStatL("Primary.Velocity") * mult * unitScale

	self.MainBullet.Callback = function(a, b, c)
		if IsValid(self) then
			c:SetInflictor(self)
			c:SetDamageType(DMG_BLAST)
		end

		if self.MainBullet.Callback2 then
			self.MainBullet.Callback2(a, b, c)
		end

		if self.CustomBulletCallback then
			self.MainBullet.Callback2 = self.CustomBulletCallback
		else
			self.MainBullet.Callback2 = nil
		end
	

		self:CallAttFunc("CustomBulletCallback", a, b, c)

		if SERVER and IsValid(a) and a:IsPlayer() and IsValid(b.Entity) and (b.Entity:IsPlayer() or b.Entity:IsNPC() or type(b.Entity) == "NextBot") then
			self:SendHitMarker(a, b, c)
		end
		--if !self.DontThrowArrow then
			AttachArrowModel(a, b, c, self)
		--end
	end

	BallisticFirebullet(self:GetOwner(), self.MainBullet)
end

function SWEP:Shoot()
	self:StopSound(self:GetStatL("Primary.DrawSound"))
	if self:GetStatL("Primary.ChargedSound") and IsFirstTimePredicted()  and not ( sp and CLIENT ) then
		if self:GetCharge() >= 0.9 then
			self:EmitSound(self:GetStatL("Primary.ChargedSound"))
		else
			self:EmitSound(self:GetStatL("Primary.UnchargedSound"))
		end
	end

	self:TakePrimaryAmmo(self:GetStatL("Primary.AmmoConsumption"))
	self:PlayAnimation(self.BowAnimations.shoot)
	self:ShootBulletInformation()
	self:SetCharge(0)
	self:SetShaking(false)
	local rate = 1 / self:GetAnimationRate(self:GetLastSequence()) ^ 2
	self:ScheduleStatus(TFA.Enum.STATUS_BOW_SHOOT, 0.1 * rate)
	local length = self:GetActivityLength() * rate
	self:ScheduleStatus(TFA.Enum.STATUS_RELOADING, length - (length * 0.25))
	self:SetDrawing(false)
end
