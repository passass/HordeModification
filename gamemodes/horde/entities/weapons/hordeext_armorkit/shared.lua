if SERVER then
	AddCSLuaFile("shared.lua")
	AddCSLuaFile("cl_init.lua")
	AddCSLuaFile("animations.lua")
end

SWEP.PrintName = "Armorkit"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/c_medkit.mdl"--"models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/items/battery.mdl" --"models/weapons/w_medkit.mdl"

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.MaxAmmo = 100
SWEP.ArmorAmount = 25

SWEP.TimerName = "armorkit_ammo"

function SWEP:StartRegenPoints(time)

	local timer_obj = self.Medkit_Ammo_Timer
	if !timer_obj then
		timer_obj = HORDE.Timers:New({
			linkwithent = self,
			timername = self.TimerName .. self:EntIndex(),
			func = function(timerobj)
				if ( self:Clip1() < self.MaxAmmo ) then
					self:SetClip1( math.min( self:Clip1() + 4, self.MaxAmmo ) )
				else
					timerobj:Stop()
				end
			end,
			callfunconstart = true,
			delay = time / 25
		})
		self.Medkit_Ammo_Timer = timer_obj
		timer_obj:UpdateTimer()
	else
		timer_obj:SetDelay(time / 25)
		timer_obj:UpdateTimer()
	end
end

local OwnerMaxArmor
local OtherPLayerMaxArmor

function SWEP:Initialize()
	self:SetHoldType("slam")

	if CLIENT then
		self:Anim_Initialize()
	end

	if not SERVER then return end
end

function SWEP:Deploy()
	--self:SendWeaponAnim(ACT_VM_DRAW)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	self:SetHoldType("slam")

	return true
end

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
end

function SWEP:Reload()
	return false
end

function SWEP:CanAttack()
	if self:Clip1() <= 0 then
		self.Owner:EmitSound("items/suitchargeno1.wav")
		self:SetNextFire(CurTime() + 2)
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:GetHitTrace()
	local shoot = self.Owner:GetShootPos()
	return util.TraceLine({
		start = shoot,
		endpos = shoot + self.Owner:GetAimVector() * 150,
		filter = self.Owner,
	})
end

function SWEP:SetNextFire(time)
	self:SetNextPrimaryFire(time)
	self:SetNextSecondaryFire(time)
end

function SWEP:PrimaryAttack()
	if not self:CanAttack() then return end

	self:SetNextFire(CurTime() + .5)

	local tr = self:GetHitTrace()

	if tr.Entity.IsPlayer() then
		OtherPLayerMaxArmor = tr.Entity:GetMaxArmor()
		if OtherPLayerMaxArmor == nil then OtherPLayerMaxArmor = 0 end
	end

	local need = (IsValid(tr.Entity) and tr.Entity:IsPlayer()) and math.min(OtherPLayerMaxArmor-tr.Entity:Armor(),self.ArmorAmount) or self.ArmorAmount
	if self:Clip1() >= self.MaxAmmo and tr.Hit and IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity:Armor() < OtherPLayerMaxArmor then
		self:UseEffect(tr.Entity, need, 10)
	elseif SERVER then
		self.Owner:EmitSound("items/suitchargeno1.wav")
	end
end

function SWEP:UseEffect(target, need, time)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1) --DoAttackEvent()
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	if SERVER then
		self:TakePrimaryAmmo(self.MaxAmmo)
		self:StartRegenPoints(time or 15)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		target:SetArmor(math.min(target:GetMaxArmor(), target:Armor() + need))
		target:EmitSound("items/battery_pickup.wav")
	end
end

function SWEP:SecondaryAttack()
	if not self:CanAttack() then return end

	self:SetNextFire(CurTime() + .5)

	OwnerMaxArmor = self.Owner:GetMaxArmor()

	local need = math.min(OwnerMaxArmor - self.Owner:Armor(),self.ArmorAmount)
	if self.Owner:Armor() < OwnerMaxArmor and self:Clip1() >= self.MaxAmmo then
		self:UseEffect(self.Owner, need, 15)
	elseif SERVER then
		self.Owner:EmitSound("items/suitchargeno1.wav")
	end
end

function SWEP:Holster()
	if CLIENT then
		self:Anim_Holster()
	end
	return true
end

function SWEP:OnRemove()
	if not SERVER then return end
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = true
	self.AmmoDisplay.PrimaryClip = self:Clip1()

	return self.AmmoDisplay
end
