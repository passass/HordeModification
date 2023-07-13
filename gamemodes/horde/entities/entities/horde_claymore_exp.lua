
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
ENT.PrintName = "Placed Explosive"

--[Sounds]--
ENT.BounceSound = Sound("TFA_MW2R_CLYMR.Plant")
ENT.TriggerSound = Sound("TFA_MW2R_CLYMR.Activate")

--[Parameters]--
ENT.Exploded = false
ENT.Impacted = false
ENT.Triggered = false
ENT.HP = 100

DEFINE_BASECLASS(ENT.Base)

function ENT:Draw()
	self:DrawModel()
	
	hook.Add("HUDPaint","MW2R_HUDTEXT",function() --credit to Hoff
		local ent = LocalPlayer():GetEyeTrace().Entity
		if ent:IsValid() then		 
			local dist = LocalPlayer():GetPos():Distance(ent:GetPos())
			if (ent:GetClass()  == 'mw2cr_claymore_exp') and dist <= 65 and LocalPlayer() == self.myowner then
				draw.DrawText("Press ["..string.upper(input.LookupBinding("+USE")).."] to Pickup", "CloseCaption_Bold", ScrW()/2, ScrH()/2+100, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
			end
		end
	end)--

	local vec1 = self:GetPos() + self:GetForward() * 2 + Vector(0,0,10)
	local vec2 = self:GetPos() + self:GetRight() * -25 + self:GetForward() * 10 + Vector(0,0,10)
	render.SetMaterial(Material("cable/redlaser"))
	render.DrawBeam(vec1, vec2, 1, 1, 1, Color(255, 255, 255, 255))
	 
	local vec3 = self:GetPos() + self:GetForward() * -2 + Vector(0,0,10)
	local vec4 = self:GetPos() + self:GetRight() * -25 + self:GetForward() * -10 + Vector(0,0,10)
	render.SetMaterial(Material("cable/redlaser"))
	render.DrawBeam(vec3, vec4, 1, 1, 1, Color(255, 255, 255, 255))
end

function ENT:PhysicsCollide(data, phys)
	local ent = data.HitEntity
	if !ent:IsWorld() and !ent:IsPlayer() and !ent:IsNPC() and ent:IsSolid() then
		self:SetParent(ent)
	end
	self:EmitSound(self.BounceSound)
	phys:EnableMotion(false)
	phys:Sleep()
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self.Impacted = true

	local angl = self:GetAngles()
	self:SetAngles(Angle(0, angl[2], 0))
end

function ENT:Initialize(...)
	BaseClass.Initialize(self, ...)
	
	self.myowner = self:GetOwner()
	if not IsValid(self.myowner) then
		self.myowner = self
	end
	self.myclass = self:GetClass()
end

function ENT:Think()
	if SERVER and self.Impacted and !self.Triggered then
		local tr1 = util.TraceHull({
		start =  self:GetPos() + Vector(0,0,10),
		endpos = self:GetPos() + self:GetRight() * -50 + self:GetForward() * -15 + Vector(0,0,10),
		maxs = Vector(5,5,5),
		mins = Vector(-5,-5,-5),
		filter = {self.myowner, self:GetOwner(), self},
		})

		local tr2 = util.TraceHull({
		start =  self:GetPos() + Vector(0,0,10),
		endpos = self:GetPos() + self:GetRight() * -50 + self:GetForward() * 15 + Vector(0,0,10),
		maxs = Vector(5,5,5),
		mins = Vector(-5,-5,-5),
		filter = {self.myowner, self:GetOwner(), self},
		})

		if tr1.HitNonWorld or tr2.HitNonWorld then
			if tr1.Entity:IsValid() then
				if self:FriendCheck(tr1.Entity) then return end
			end
			if tr2.Entity:IsValid() then
				if self:FriendCheck(tr2.Entity) then return end
			end
			self.Triggered = true
			self:EmitSound(self.TriggerSound)
			timer.Simple(0.5, function() --im stupid so im using a timer
				if not self:IsValid() then return end
				self:Explode()
			end)
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:FriendCheck(ent)
	local entclass = ent:GetClass()
	return entclass == "horde_claymore_exp" or ent:IsPlayer() or !ent:IsNPC()
end

function ENT:Use(activator, caller)
	if CLIENT then return end
	if IsValid(activator) and activator == self:GetOwner() then
		local wpn = self:GetOwner():GetWeapon("arccw_hordeext_claymore")
		if !IsValid(wpn) then
			activator:Give("arccw_hordeext_claymore", true)
			wpn = self:GetOwner():GetWeapon("arccw_hordeext_claymore")
		end
		HORDE:GiveAmmo(activator, wpn, 1)
		self:Remove()
	end
end

function ENT:OnTakeDamage(dmg)
	if dmg:GetInflictor() == self or dmg:GetAttacker() == self then return end
	if self.Exploded then return end
	if self.HP > 0 and self.HP - dmg:GetDamage() <= 0 then
		self.Exploded = true
		self:Explode()
	end
	self.HP = self.HP - dmg:GetDamage()
	dmg:SetAttacker(self)
	dmg:SetInflictor(self)
end

function ENT:Explode(...)
	local qtr = util.QuickTrace(self:GetPos(),Vector(0,0,-15),self)
	util.Decal("Scorch", qtr.HitPos - qtr.HitNormal, qtr.HitPos + qtr.HitNormal)
	local owent = self:GetOwner() and self:GetOwner() or self
	local dmg = DamageInfo()
    dmg:SetAttacker(owent)
    dmg:SetInflictor(self)
    dmg:SetDamageType(DMG_BLAST)
    dmg:SetDamage(600)
    dmg:SetDamageCustom(HORDE.DMG_PLAYER_FRIENDLY)
	util.BlastDamageInfo(dmg, self:GetPos(), 200)

	if table.HasValue(ents.FindInSphere( self:GetPos(), 175 ), owent) then
		owent:ViewPunch(Angle(-4, 5, 0))
		HORDE:TakeDamage(owent, 25, DMG_BLAST, owent, self)
	end
	HORDE:MakeExplosionEffect(self:GetPos(), self)
	self:Remove()
end