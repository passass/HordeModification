
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

AddCSLuaFile()

--[Info]--
ENT.Base = "tfa_exp_base"
ENT.PrintName = "Player Triggered Explosive"
ENT.Model = "models/weapons/tfa_mw2cr/c4/c4_projectile.mdl"
--[Sounds]--
ENT.BounceSound = Sound("TFA_MW2R_C4.Plant")

--[Parameters]--
ENT.Impacted = false
ENT.CanEMP = true

DEFINE_BASECLASS(ENT.Base)

function ENT:Draw()
	self:DrawModel()
	
	render.SetMaterial(Material("sprites/c4_glow.vmt"))
	render.DrawSprite(self:GetAttachment(1).Pos, 1.75, 1.75, Color(255,0,0,0))
end

function ENT:Horde_EndTimeStop()
	return self.Armed
end

function ENT:PhysicsCollide(data, phys)
	local ent = data.HitEntity
	if !ent:IsWorld() and ent:IsSolid() then
		self:SetParent(ent)
	else
		timer.Simple(0, function()
		if not self:IsValid() then return end
			self:SetPos(data.HitPos + ((data.HitNormal / 5) * -5))
		end)
		self:SetAngles(data.HitNormal:Angle() + Angle(-90,0,0))
	end
	
	self.Armed = true

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	phys:EnableMotion(false)
	phys:Sleep()
	self:EmitSound(self.BounceSound)
end

function ENT:Initialize(...)
	BaseClass.Initialize(self, ...)

	self:SetModel(self.Model)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
	end
end

function ENT:Think()
	if SERVER and self.Cooked <= CurTime() then
		self:Explode()
	end

	self:NextThink(CurTime())
	return true
end

function ENT:Explode()
	if self:GetNW2Bool("EMP") then return end
	local owent = self:GetOwner()
	local dmg = DamageInfo()
    dmg:SetAttacker(owent)
    dmg:SetInflictor(self)
    dmg:SetDamageType(DMG_BLAST)
    dmg:SetDamage(450)
    dmg:SetDamageCustom(HORDE.DMG_PLAYER_FRIENDLY)
	util.BlastDamageInfo(dmg, self:GetPos(), 200)

	if table.HasValue(ents.FindInSphere( self:GetPos(), 175 ), owent) then
		owent:ViewPunch(Angle(-4, 5, 0))
		HORDE:TakeDamage(owent, 25, DMG_BLAST, owent, self)
	end
	HORDE:MakeExplosionEffect(self:GetPos(), self)
	self:Remove()
end