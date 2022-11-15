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

DEFINE_BASECLASS("tfa_gun_base")
--primary stats
SWEP.Primary.Spread = 0.001
SWEP.Primary.SpreadShake = 0.05 --when shaking
SWEP.Primary.Velocity = 300 --velocity in m/s
SWEP.Primary.Damage_Charge = {0.2, 1} --velocity/damage multiplier between min and max charge
SWEP.Primary.Shake = true --enable shaking
SWEP.Primary.ShakeIntensity = 1 --intensity of shaking
--options
SWEP.Secondary.Cancel = false --enable cancelling
--bow base shit
SWEP.ChargeRate = 30 / 75 --1 is fully charged
SWEP.ChargeThreshold = 0.75 --minimum charge percent to fire
SWEP.ShakeTime = 5 --minimum time to start shaking
SWEP.Secondary.IronSightsEnabled = true
--tfa ballistics integration
SWEP.UseBallistics = true
SWEP.BulletModel = "models/weapons/w_tfa_arrow.mdl"
SWEP.BulletTracer = ""
SWEP.ImpactParticle = nil

SWEP.IronSightsReloadEnabled = true
SWEP.IronSightsReloadLock = true

SWEP.Primary.DamageType = bit.bor(DMG_NEVERGIB, DMG_CLUB)
SWEP.Primary.DrawSound = nil
SWEP.Primary.ChargedSound = nil
SWEP.Primary.UnchargedSound = nil

--animation
SWEP.BowAnimations = {
	["shake"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "tiredloop",
		["enabled"] = true --Manually force a sequence to be enabled
	},
	["shoot"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "fire_1",
		["enabled"] = true --Manually force a sequence to be enabled
	},
	["cancel"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "cancelarrow",
		["enabled"] = true --Manually force a sequence to be enabled
	},
	["draw"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "drawarrow",
		["enabled"] = true --Manually force a sequence to be enabled
	},
	["idle_charged"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, 
		["value"] = "idle_charged_ads", 
		["enabled"] = true 
	}
}

SWEP.StatCache_Blacklist = {
	["BowAnimations"] = true,
	["SwayScale"] = true
}

--["idle_charged"] = {["type"] = TFA.Enum.ANIMATION_SEQ, ["value"] = "idle_charged", ["enabled"] = true }
function SWEP:SetupDataTables(...)
	BaseClass.SetupDataTables(self, ...)

	self:NetworkVarTFA("Bool", "Shaking")
	self:NetworkVarTFA("Bool", "Drawing")
	self:NetworkVarTFA("Float", "Charge")
end

function SWEP:GetChargeTime()
	return self:GetCharge() / self.ChargeRate
end

function SWEP:ShouldShake()
	return self:GetChargeTime() >= self.ShakeTime
end

function SWEP:Deploy(...)
	self:SetCharge(0)
	self:SetShaking(false)
	self:SetDrawing(false)

	return BaseClass.Deploy(self, ...)
end

function SWEP:Charge(t)
	self:SetCharge(self:GetCharge() + (self.ChargeRate*2.25) * t)
end

local sp = game.SinglePlayer()
local ft

function SWEP:Think2(...)
	ft = FrameTime()

	if self:GetIronSights() then
		//self:GetTable().SwayScale = -1
		self.BowAnimations["shoot"].value = "fire_1_iron"
		self.BowAnimations["draw"].value = "drawarrowiron"
		self.BowAnimations["idle_charged"].value = "idle_charged_ads"
	else
		self.BowAnimations["shoot"].value = "fire_1"
		self.BowAnimations["draw"].value = "drawarrow"
		self.BowAnimations["idle_charged"].value = "idle_charged"
	end

	if self:GetStatus() == TFA.Enum.STATUS_BOW_CANCEL and self:GetStatusEnd() > CurTime() then
		self:SetCharge(0)
		self:SetShaking(false)
		self:SetDrawing(false)
	end


	if TFA.Enum.ReadyStatus[self:GetStatus()] and self:CanPrimaryAttack() then
		if self:GetOwner():KeyDown(IN_ATTACK2) and self:GetCharge() > self.ChargeThreshold and self.Secondary.Cancel then
			self:PlayAnimation(self.BowAnimations.cancel)
			self:ScheduleStatus(TFA.Enum.STATUS_BOW_CANCEL, self:GetActivityLength())
		elseif self:GetOwner():KeyDown(IN_ATTACK) then
			if self:GetCharge() <= 0 then
				self:PlayAnimation(self.BowAnimations.draw)
				self:SetCharge(0.01)
				self:SetDrawing(true)

				if self:GetStatL("Primary.DrawSound") and IsFirstTimePredicted() then
					self:EmitSound(self:GetStatL("Primary.DrawSound"))
				end
			end

			self:Charge(ft)

			if self:GetCharge() >= 0.05 then
				if IsFirstTimePredicted() or game.SinglePlayer() then
					//cam.ApplyShake( Vector(0,500,0), Angle(0,0,0), 500 )
					util.ScreenShake( self:GetOwner():GetPos(), (self:GetCharge()/50)*self.Primary.ShakeIntensity, 0.1, .1, 40 )
				end
			end

			if self:GetIronSights() and self:GetCharge() >= 1 then
				self:PlayAnimation("idle_charged_iron")
			end

			if self:ShouldShake() and not self:GetShaking() then
				self:SetShaking(true)
				self:PlayAnimation(self.BowAnimations.shake)
				self:Shoot()
			end
		else
			local c = self:GetCharge()

			if c > self.ChargeThreshold then
				self:Shoot()
			elseif c > 0 then
				self:Charge(ft)
			end
		end
	elseif self:GetCharge() > 0 then
		if TFA.Enum.ReadyStatus[self:GetStatus()] then
			if self:GetCharge() > self.ChargeThreshold then
				self:ScheduleStatus(TFA.Enum.STATUS_BOW_CANCEL, self:GetActivityLength())
			else
				self.Idle_ModeOld = self.Idle_Mode
				self:ClearStatCache("Idle_Mode")
				self.Idle_Mode = TFA.Enum.IDLE_BOTH
				self:ChooseIdleAnim()
				self.Idle_Mode = self.Idle_ModeOld
			end
		end
		self:SetCharge(0)
		self:SetShaking(false)
		self:SetDrawing(false)
	end

	if IsFirstTimePredicted() or game.SinglePlayer() then
		self.Primary_TFA.SpreadBase = self.Primary_TFA.SpreadBase or self:GetStatL("Primary.Spread")
		local targ = self:GetDrawing() and self.Primary_TFA.SpreadShake or self:GetStatL("Primary.SpreadBase")
		self.Primary_TFA.Spread = math.Approach(self.Primary_TFA.Spread, targ, (targ - self.Primary_TFA.Spread) * FrameTime() * 5)
		self:ClearStatCache("Primary.Spread")
	end

	BaseClass.Think2(self, ...)
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
	self:ScheduleStatus(TFA.Enum.STATUS_BOW_SHOOT, 0.1)
	self:ScheduleStatus(TFA.Enum.STATUS_RELOADING, self:GetActivityLength()-(self:GetActivityLength()*0.25))
	self:SetDrawing(false)
end

function SWEP:ChooseIdleAnim(...)
	if self:GetShaking() then
		return self:PlayAnimation(self.BowAnimations.shake)
	elseif self:GetCharge() > 0 and self.BowAnimations["idle_charged"] then
		return self:PlayAnimation(self.BowAnimations.idle_charged)
	end

	return BaseClass.ChooseIdleAnim(self, ...)
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

SWEP.MainBullet = {}
SWEP.MainBullet.Spread = Vector()
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

--[[
Function Name:  ShootBulletInformation
Syntax: self:ShootBulletInformation().
Returns:   Nothing.
Notes:  Used to generate a self.MainBullet table which is then sent to self:ShootBullet, and also to call shooteffects.
Purpose:  Bullet
]]
--
local cv_dmg_mult = GetConVar("sv_tfa_damage_multiplier")
local cv_dmg_mult_min = GetConVar("sv_tfa_damage_mult_min")
local cv_dmg_mult_max = GetConVar("sv_tfa_damage_mult_max")
local dmg, con, rec

function SWEP:ShootBulletInformation()
	self:UpdateConDamage()
	self.lastbul = nil
	self.lastbulnoric = false
	self.ConDamageMultiplier = cv_dmg_mult:GetFloat()
	if not IsFirstTimePredicted() then return end
	con, rec = self:CalculateConeRecoil()
	local tmpranddamage = math.Rand(cv_dmg_mult_min:GetFloat(), cv_dmg_mult_max:GetFloat())
	local basedamage = self.ConDamageMultiplier * self:GetStatL("Primary.Damage")
	dmg = basedamage * tmpranddamage
	local ns = self:GetStatL("Primary.NumShots")
	local clip = (self:GetStatL("Primary.ClipSize") == -1) and self:Ammo1() or self:Clip1()
	ns = math.Round(ns, math.min(clip / self:GetStatL("Primary.NumShots"), 1))
	self:ShootBullet(dmg, rec, ns, con)
	local _, CurrentRecoil = self:CalculateConeRecoil()
	self:Recoil(CurrentRecoil, IsFirstTimePredicted())
end

--[[
Function Name:  ShootBullet
Syntax: self:ShootBullet(damage, recoil, number of bullets, spray cone, disable ricochet, override the generated self.MainBullet table with this value if you send it).
Returns:   Nothing.
Notes:  Used to shoot a self.MainBullet.
Purpose:  Bullet
]]
--
local cv_forcemult = GetConVar("sv_tfa_force_multiplier")

local AttachArrowModel = function(a, b, c, wep)
	c:SetDamageType(bit.bor(DMG_NEVERGIB, DMG_CLUB))
	if CLIENT then return end
	if not IsValid(wep) then return end

	if b.HitWorld and not (IsValid(b.Entity) and not b.Entity:IsWorld()) then
		local arrowstuck = ents.Create("tfbow_arrow_stuck")
		arrowstuck:SetModel(wep:GetStatL("BulletModel"))
		arrowstuck.gun = wep:GetClass()
		arrowstuck:SetPos(b.HitPos)
		arrowstuck:SetAngles(b.Normal:Angle())
		arrowstuck:Spawn()
	else
		local arrowstuck = ents.Create("tfbow_arrow_stuck_clientside")
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
end

function SWEP:AutoDetectForce()
	if self:GetStatRawL("Primary.Force") == -1 or not self:GetStatRawL("Primary.Force") then
		self:SetStatRawL("Primary.Force", self:GetStatRawL("Force") or self:GetStatRawL("Primary.Damage") / 6 * math.sqrt(self:GetStatRawL("Primary.KickUp") + self:GetStatRawL("Primary.KickDown") + self:GetStatRawL("Primary.KickHorizontal")))
	end
end

function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone, disablericochet, bulletoverride)
	print("gswa")
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

		AttachArrowModel(a, b, c, self)
	end

	BallisticFirebullet(self:GetOwner(), self.MainBullet)
end

function SWEP:DoImpactEffect( tr, nDamageType )

	if ( tr.HitSky ) then return end
	//if ( SERVER ) then return true end
	if self.ImpactParticle != nil then
		ParticleEffect( self.ImpactParticle, tr.HitPos + tr.HitNormal, self:GetOwner():EyeAngles() )
	end

	return true
end

TFA.FillMissingMetaValues(SWEP)
