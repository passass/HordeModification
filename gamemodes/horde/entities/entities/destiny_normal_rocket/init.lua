
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

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.DefaultModel = Model("models/weapons/w_eq_fraggrenade.mdl")

ENT.Damage = 250
ENT.Delay = 3
ENT.FallDelay = .2
ENT.Radius = 5

ENT.MaxSpeed = 50000 -- maximum speed, works if AccelerationTime > 0

function ENT:CreateRocketTrail()
	if not SERVER then return end

	local rockettrail = ents.Create("env_rockettrail")
	rockettrail:DeleteOnRemove(self)

	rockettrail:SetPos(self:GetPos())
	rockettrail:SetAngles(self:GetAngles())
	rockettrail:SetParent(self)
	rockettrail:SetMoveType(MOVETYPE_NONE)
	rockettrail:AddSolidFlags(FSOLID_NOT_SOLID)

	rockettrail:SetSaveValue("m_Opacity", 0.2)
	rockettrail:SetSaveValue("m_SpawnRate", 100)
	rockettrail:SetSaveValue("m_ParticleLifetime", .85)
	rockettrail:SetSaveValue("m_StartColor", Vector(1, 0.65, 0.5))
	rockettrail:SetSaveValue("m_EndColor", Vector(0, 0, 0))
	rockettrail:SetSaveValue("m_StartSize", 5)
	rockettrail:SetSaveValue("m_EndSize", 0)
	rockettrail:SetSaveValue("m_SpawnRadius", 4)
	rockettrail:SetSaveValue("m_MinSpeed", 2)
	rockettrail:SetSaveValue("m_MaxSpeed", 16)
	rockettrail:SetSaveValue("m_nAttachment", 0)
	rockettrail:SetSaveValue("m_flDeathTime", CurTime() + 999)

	rockettrail:Activate()
	rockettrail:Spawn()
end

function ENT:Initialize()
	local mdl = self:GetModel()

	if not mdl or mdl == "" or mdl == "models/error.mdl" then
		self:SetModel(self.DefaultModel)
	end

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableGravity(false)
		//phys:AddVelocity( self:GetForward()*200 )
	end

	//self:SetFriction(self.Delay)
	self.killtime = CurTime() + self.Delay
	self.falloff = CurTime() + self.FallDelay
	self:DrawShadow(true)

	self:CreateRocketTrail()

	if not self.Inflictor and self:GetOwner():IsValid() and self:GetOwner():GetActiveWeapon():IsValid() then
		self.Inflictor = self:GetOwner():GetActiveWeapon()
	end

end

function ENT:Think()
	if self.killtime < CurTime() then
		self:Explode()

		return false
	end
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:AddVelocity(self:GetForward()*50)
	end
	self:NextThink(CurTime())

	return true
end

ENT.ExplosionSound = "BaseExplosionEffect.Sound"

function ENT:DoExplosionEffect()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())

	util.Effect("HelicopterMegaBomb", effectdata)
	util.Effect("Explosion", effectdata)

	self:EmitSoundNet(self.ExplosionSound)
end

function ENT:PhysicsCollide(data, phys)
	if data.Speed > 60 then
		self.killtime = -1
	end
end

function ENT:Explode()
	
	if not IsValid(self.Inflictor) then
		self.Inflictor = self
	end

	local dmg = DamageInfo()
	dmg:SetInflictor(self.Inflictor)
	dmg:SetAttacker(IsValid(self:GetOwner()) and self:GetOwner() or self)
	dmg:SetDamage(self.Damage)
	dmg:SetDamageType(bit.bor(DMG_BLAST, DMG_AIRBOAT))

	util.BlastDamageInfo(dmg, self:GetPos(), math.pow( self.Damage / 100, 0.75) * 175)

	util.ScreenShake(self:GetPos(), self.Damage * 20, 255, self.Damage / 200, math.pow(self.Damage / 100, 0.75) * 200)

	self:DoExplosionEffect()

	self:Remove()
end