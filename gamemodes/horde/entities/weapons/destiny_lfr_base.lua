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

--animation
SWEP.LinearAnimations = {
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
	["LinearAnimations"] = true,
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
	if !self:GetOwner():KeyDown(IN_ATTACK) and self:GetStatus() == TFA.Enum.STATUS_D2LFR_CHARGE then return true end
	if self:GetSprinting() then return true end
	if self:Clip1() == 0 then return true end
	//if self:GetStatus() == TFA.Enum.STATUS_HOLSTER and self:GetLastSequenceString() == "chargefire" then return true end
end

function SWEP:CancelCharge()
	self:SetCharge(0)
	 
	if self:GetStatus() == TFA.Enum.STATUS_D2LFR_CHARGE then
		self:SetStatus(TFA.Enum.STATUS_IDLE)
		self:ChooseIdleAnim()
	end

	self:SetCanFire(false)
	self:StopSound(self:GetStat("Primary.ChargeSound"))

	if SERVER then
		//PrintMessage(HUD_PRINTTALK, "Cancelled charge.")
	end
end

function SWEP:Deploy(...)
	self:SetCharge(0)
	self:SetCanFire(false)
	return BaseClass.Deploy(self, ...)
end

function SWEP:Charge(t)
	self:SetCharge(self:GetCharge() + (self.ChargeRate*2.25) * t)
end

function SWEP:CanCharge()
	//if self:GetNextPrimaryFire() > CurTime() - .2 then return false end
	if self:GetNextPrimaryFire() < CurTime() and self:GetStatus() != TFA.Enum.STATUS_SHOOTING and self:GetStatus() != TFA.Enum.STATUS_D2LFR_CHARGE then return true end
end

function SWEP:Think2(...)

	if SERVER then
		//PrintMessage(HUD_PRINTTALK, tostring(self:GetNextPrimaryFire()))
	end

	if self:GetIronSights() then
		self.LinearAnimations["charge"].value = "chargeads"
	else
		self.LinearAnimations["charge"].value = "charge"
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
				self:PlayAnimation(self.LinearAnimations.charge)
				self:ScheduleStatus(TFA.Enum.STATUS_D2LFR_CHARGE, self:GetActivityLength())
			end
		else
			self:SetCanFire(false)
		end
	end
	
	if self:GetStatus() == TFA.Enum.STATUS_D2LFR_CHARGE then
		self:Charge(ft)
		if self:GetCharge() >= 0.05 then
			if IsFirstTimePredicted() and sp then
				local time = self:GetStatusEnd(TFA.Enum.STATUS_D2LFR_CHARGE) - self:GetStatusStart(TFA.Enum.STATUS_D2LFR_CHARGE)
				util.ScreenShake( self:GetOwner():GetPos() + Vector(0,0,10), time*0.3, 0.1, .1, 40 )
			end
		end
	end

	if self:ShouldCancel() then
		self:CleanParticles()
		self:CancelCharge()
	end

	if self:GetStatus() == TFA.Enum.STATUS_D2LFR_CHARGE and self:GetStatusEnd() < CurTime() then
		if self:GetOwner():KeyDown(IN_ATTACK) then
			if not self:ShouldCancel() then
				self:SetCanFire(true)
			end
		end
	end

	return BaseClass.Think2(self, ...)
end

function SWEP:CanPrimaryAttack(...)
	if self:GetStatus() == TFA.Enum.STATUS_D2LFR_CHARGEFIRE then
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

-- function SWEP:DoImpactEffect( tr, nDamageType )

-- 	if ( tr.HitSky ) then return end
-- 	//if ( SERVER ) then return true end
-- 	if self.ImpactParticle != nil then
-- 		ParticleEffect( self.ImpactParticle, tr.HitPos + tr.HitNormal, self:GetOwner():EyeAngles() )
-- 	else
-- 		self:DoImpactEffectBase( tr, nDamageType )
-- 	end

-- 	return true
-- end

-- function SWEP:DoImpactEffectBase(tr, dmgtype)
-- 	if tr.HitSky then return true end
-- 	local ib = self.BashBase and IsValid(self) and self:GetBashing()
-- 	local dmginfo = DamageInfo()
-- 	dmginfo:SetDamageType(dmgtype)

-- 	if dmginfo:IsDamageType(DMG_SLASH) or (ib and self.Secondary_TFA.BashDamageType == DMG_SLASH and tr.MatType ~= MAT_FLESH and tr.MatType ~= MAT_ALIENFLESH) or (self and self.DamageType and self.DamageType == DMG_SLASH) then
-- 		util.Decal("ManhackCut", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)

-- 		return true
-- 	end

-- 	if ib and self.Secondary_TFA.BashDamageType == DMG_GENERIC then return true end
-- 	if ib then return end

-- 	if IsValid(self) then
-- 		self:ImpactEffectFunc(tr.HitPos, tr.HitNormal, tr.MatType)
-- 	end

-- 	if self.ImpactDecal and self.ImpactDecal ~= "" then
-- 		util.Decal(self.ImpactDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)

-- 		return true
-- 	end
-- end


TFA.FillMissingMetaValues(SWEP)
