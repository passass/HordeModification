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
SWEP.Primary.Spread = 0.1
--options
--bow base shit
SWEP.ChargeRate = 30 / 75 --1 is fully charged
SWEP.BulletTracer = ""
SWEP.ImpactParticle = nil

SWEP.IronSightsReloadEnabled = false
SWEP.IronSightsReloadLock = false

SWEP.Primary.DamageType = DMG_DISSOLVE
SWEP.Primary.Sound = nil
SWEP.Primary.ChargeSound = nil
SWEP.Primary.ChargeDownSound = nil
SWEP.Primary.ReloadSound = nil

SWEP.OnlyBurstFire = false


--animation
SWEP.FusionAnimations = {
	["charge"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "charge",
		["enabled"] = true --Manually force a sequence to be enabled
	},
	["chargefire"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "chargefire",
		["enabled"] = true --Manually force a sequence to be enabled
	}
}

SWEP.StatCache_Blacklist = {
	["FusionAnimations"] = true,
}

local sp = game.SinglePlayer()
local ft = FrameTime()

function SWEP:SetupDataTables(...)
	BaseClass.SetupDataTables(self, ...)

	self:NetworkVarTFA("Bool", "CanFire")
	self:NetworkVarTFA("Float", "Charge")
end

function SWEP:GetChargeTime()
	return self:GetCharge() / self.ChargeRate
end

function SWEP:ShouldCancel()
	if !self:GetOwner():KeyDown(IN_ATTACK) and self:GetStatus() == TFA.Enum.STATUS_D2FR_CHARGE then return true end
	if self:GetSprinting() then return true end
	if self:Clip1() == 0 then return true end
	//if self:GetStatus() == TFA.Enum.STATUS_HOLSTER and self:GetLastSequenceString() == "chargefire" then return true end
end

function SWEP:CancelCharge()
	self:SetCharge(0)
	 
	if self:GetStatus() == TFA.Enum.STATUS_D2FR_CHARGE then
		if self:GetStatusProgress(true) > 0.25 and IsFirstTimePredicted() then
			self:EmitSound(self:GetStat("Primary.ChargeDownSound"))
		end
		self:SetStatus(TFA.Enum.STATUS_IDLE)
		self:ChooseIdleAnim()
	end

	self:SetCanFire(false)
	self:StopSound(self:GetStat("Primary.ChargeSound"))
	self:SetBurstCount(0)
end

function SWEP:Holster(...)
	if self:GetStatus() == TFA.Enum.STATUS_SHOOTING and self:GetBurstCount() != self:GetStat("BurstFireCount")  then
		self:TakePrimaryAmmo(1)
	end
	return BaseClass.Holster(self, ...)
end

function SWEP:Deploy(...)
	self:SetCharge(0)
	self:SetCanFire(false)
	return BaseClass.Deploy(self, ...)
end

function SWEP:Charge(t)
	if SERVER then
		self:SetCharge(self:GetCharge() + (self.ChargeRate*2.25) * t)
	end
end

function SWEP:CanCharge()
	//if self:GetNextPrimaryFire() > CurTime() - .2 then return false end
	if self:GetNextPrimaryFire() < CurTime() and self:GetStatus() != TFA.Enum.STATUS_SHOOTING and self:GetStatus() != TFA.Enum.STATUS_D2FR_CHARGE then return true end
end

function SWEP:Think2(...)

	if SERVER then
		//PrintMessage(HUD_PRINTTALK, tostring(self:GetNextPrimaryFire()))
	end

	if self:GetIronSights() then
		self.FusionAnimations["charge"].value = "chargeads"
	else
		self.FusionAnimations["charge"].value = "charge"
	end

	if TFA.Enum.ShootReadyStatus[self:GetStatus()] and self:CanCharge() then
		if self:GetOwner():KeyDown(IN_ATTACK) and not self:ShouldCancel() then
			if self:GetOwner():IsPlayer() then
				self:SetCharge(0)
				if IsFirstTimePredicted() then
					self:EmitSound(self:GetStat("Primary.ChargeSound"))
					if self:GetStat("ChargeEffect") then
						ParticleEffectAttach( self:GetStat("ChargeEffect"), 4, self:GetOwner():GetViewModel(), self:GetOwner():GetViewModel():LookupAttachment("muzzle"))
					end
				end
				self:PlayAnimation(self.FusionAnimations.charge)
				self:ScheduleStatus(TFA.Enum.STATUS_D2FR_CHARGE, self:GetActivityLength())
			end
		else
			self:SetCanFire(false)
		end
	end
	
	if self:GetStatus() == TFA.Enum.STATUS_D2FR_CHARGE then
		self:Charge(ft)
		if self:GetCharge() >= 0.05 then
			if IsFirstTimePredicted() and sp then
				local time = self:GetStatusEnd(TFA.Enum.STATUS_D2FR_CHARGE) - self:GetStatusStart(TFA.Enum.STATUS_D2FR_CHARGE)
				util.ScreenShake( self:GetOwner():GetPos() + Vector(0,0,10), time*0.3, 0.1, .1, 40 )
			end
		end
	end

	if self:ShouldCancel() then
		self:CleanParticles()
		self:CancelCharge()
	end

	if self:GetStatus() == TFA.Enum.STATUS_D2FR_CHARGE and self:GetStatusEnd() < CurTime() then
		if self:GetOwner():KeyDown(IN_ATTACK) then
			if not self:ShouldCancel() then
				self:SetCanFire(true)
			end
		end
	end

	return BaseClass.Think2(self, ...)
end

function SWEP:CanPrimaryAttack(...)
	if self:GetBurstCount() > self:GetStat("BurstFireCount") - 1 then
		return false
	end
	if self:GetStatus() == TFA.Enum.STATUS_D2FR_CHARGEFIRE then
		return true
	end
	if self:ShouldCancel() then
		//self:CancelCharge()
		return false
	end
	if self:GetCanFire() == false then
		return false
	end
	return BaseClass.CanPrimaryAttack(self, ...)
end

function SWEP:PostPrimaryAttack()
	
	if self.OnlyBurstFire == false then
		self:SetCanFire(false)
		self:ScheduleStatus(TFA.Enum.STATUS_SHOOTING, self:GetActivityLength()*1.2)
	end
end

function SWEP:TriggerAttack(...)
	if self:GetBurstCount() == 0 then
		if self:GetStat("Primary.FireSound") and IsFirstTimePredicted() and not (game.SinglePlayer() and CLIENT) then
			local tgtSound = self:GetStat("Primary.FireSound")
			if (not sp and SERVER) or not self:IsFirstPerson() then
				tgtSound = self:GetSilenced() and self:GetStat("Primary.SilencedSound_World", tgtSound) or self:GetStat("Primary.Sound_World", tgtSound)
			end
	
			self:EmitGunfireSound(tgtSound)
		end
	end

	if self:GetBurstCount() == self:GetStat("BurstFireCount") - 1 then
		self:TakePrimaryAmmo(1)
		//self:SetCanFire(false)
		//self:ScheduleStatus(TFA.Enum.STATUS_SHOOTING, self:GetActivityLength()*2)
	end
	return BaseClass.TriggerAttack(self, ...)
end

function SWEP:DoChargeEffect()
	if CLIENT then
		local tr =  self:GetOwner():GetEyeTrace()
		local pos = tr.HitPos + tr.HitNormal * 100 -- The origin position of the effect

		local emitter = ParticleEmitter( pos ) -- Particle emitter in this position

		for i = 1, 100 do -- Do 100 particles
			local part = emitter:Add( "effects/spark", pos ) -- Create a new particle at pos
			if ( part ) then
				part:SetDieTime( 1 ) -- How long the particle should "live"

				part:SetStartAlpha( 255 ) -- Starting alpha of the particle
				part:SetEndAlpha( 0 ) -- Particle size at the end if its lifetime

				part:SetStartSize( 5 ) -- Starting size
				part:SetEndSize( 0 ) -- Size when removed

				part:SetGravity( Vector( 0, 0, -250 ) ) -- Gravity of the particle
				part:SetVelocity( VectorRand() * 50 ) -- Initial velocity of the particle
			end
		end

		emitter:Finish()
	end
end


TFA.FillMissingMetaValues(SWEP)
