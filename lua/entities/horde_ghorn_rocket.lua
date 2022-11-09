
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

ENT.Base = "tfa_exp_base"
ENT.PrintName = "Gjallarhorn Rocket"

-- EDITABLE PARAMETERS -- START

ENT.LaunchSound = "" -- none, replace to enable
ENT.PropelSound = Sound("Missile.Accelerate") -- looped propel sound

ENT.BaseSpeed = 2000 -- base rocket speed, in units

ENT.AccelerationTime = .01 -- time in seconds to accelerate to max speed
ENT.AccelerationTime2 = 0.3
ENT.MaxSpeed = 2500 -- maximum speed, works if AccelerationTime > 0

ENT.HasTrail = true -- create trail

-- EDITABLE PARAMETERS -- END

ENT.AccelProgress = 0
ENT.Ratio = 0

ENT.DefaultModel = Model("models/weapons/w_missile.mdl")
ENT.Delay = 10

DEFINE_BASECLASS(ENT.Base)

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "HasTarget")
	self:NetworkVar("Angle", 0, "NewAngle")
	self:NetworkVar("Angle", 0, "OldAngle")
end

-- Creates HL2 rocket trail by default, feel free to copy and edit to your needs
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
	rockettrail:SetSaveValue("m_ParticleLifetime", 0.4)
	rockettrail:SetSaveValue("m_StartColor", Vector(.8, .8, .8))
	rockettrail:SetSaveValue("m_EndColor", Vector(0, 0, 0))
	rockettrail:SetSaveValue("m_StartSize", 10)
	rockettrail:SetSaveValue("m_EndSize", 5)
	rockettrail:SetSaveValue("m_SpawnRadius", 4)
	rockettrail:SetSaveValue("m_MinSpeed", 2)
	rockettrail:SetSaveValue("m_MaxSpeed", 16)
	rockettrail:SetSaveValue("m_nAttachment", 0)
	rockettrail:SetSaveValue("m_flDeathTime", CurTime() + 999)

	rockettrail:Activate()
	rockettrail:Spawn()
end

function ENT:Initialize(...)
	BaseClass.Initialize(self, ...)

	self:EmitSoundNet(self.PropelSound)

	if self.LaunchSound and self.LaunchSound ~= "" then
		self:EmitSoundNet(self.LaunchSound)
	end

	self:SetOwner(self:GetOwner())

	self:SetFriction(0)
	//self:SetLocalAngularVelocity(angle_zero)

	self:SetMoveType(MOVETYPE_FLY)
	self:SetLocalVelocity(self:GetForward() * self.BaseSpeed)

	self.StartTime = CurTime()
	self:SetNewAngle(self:GetAngles())
	self:SetOldAngle(self:GetAngles())

	if self.HasTrail then
		self:CreateRocketTrail()
	end
	if SERVER then
		//PrintMessage(HUD_PRINTTALK, tostring(self:GetOwner():GetNWEntity("destiny_ghorn_target")))
	end
	self.killtime = CurTime() + self.Delay
end

function ENT:Think(...)

	if self.AccelerationTime > 0 and self.AccelProgress < 1 then
		self.LastAccelThink = self.LastAccelThink or CurTime()
		self.AccelProgress = Lerp((CurTime() - self.LastAccelThink) / self.AccelerationTime, self.AccelProgress, 1)
	end

	self:SetLocalVelocity(self:GetForward() * Lerp(self.AccelProgress, self.BaseSpeed, self.MaxSpeed))

	if ( SERVER ) then
		self:SpecialThink()
		if self.killtime < CurTime() then
			self:Explode()
			return false
		end

		
		local proxy = ents.FindInSphere( self:GetPos(), 10 )
		
		for k, v in pairs( proxy ) do 
			if ( IsValid(v) and (v:IsNPC() or v:IsPlayer()) and v != self.Owner ) then
				//self:Explode()
			end
		end
		
	end


	self:NextThink(CurTime()+0.025)

	return true
end

function ENT:Explode()
	if not IsValid(self.Inflictor) then
		self.Inflictor = self
	end

	self:StopSound(self.PropelSound)
	self:SpawnFalling()
	self.Ratio = 0

	self.Damage = self.mydamage or self.Damage

	local dmg = DamageInfo()
	dmg:SetInflictor(self.Inflictor)
	dmg:SetAttacker(IsValid(self:GetOwner()) and self:GetOwner() or self)
	dmg:SetDamage(self.Damage)
	dmg:SetDamageType(bit.band(DMG_BLAST, DMG_AIRBOAT))

	util.BlastDamageInfo(dmg, self:GetPos(), 300)

	util.ScreenShake(self:GetPos(), self.Damage * 20, 255, self.Damage / 200, math.pow(self.Damage / 100, 0.75) * 400)

	HORDE:MakeExplosionEffect(self:GetPos())

	self:Remove()
end

function ENT:StartTouch()
	self.killtime = -1
end

function ENT:PhysicsCollide(data, phys)
	if data.Speed > 60 and CurTime() > self.AccelerationTime then
		timer.Simple(0,function()
			if IsValid(self) then
				self:Explode()
			end
		end)
	end
end

function ENT:SpawnFalling()
	for _ = 1, 4 do
		if SERVER then
			local aimcone = 0--self:CalculateConeRecoil()
			local ent = ents.Create("horde_ghorn_wolfpack")
			local ang = ent:GetAngles()
			ent:SetPos(self:GetPos())
			ent:SetOwner(self:GetOwner())
			ent:SetAngles(self.Owner:EyeAngles())
	
			local trail = util.SpriteTrail(ent, 0, Color(255,255,255,200), true, 13, 2, .5, 1/(15+1)*0.5, "trails/smoke.vmt")

			ent:Spawn()
			ent:SetAngles(Angle(0, 0, 0))
			dir = ang:Up()
			local phys = ent:GetPhysicsObject()

			if IsValid(phys) then
				//phys:ApplyForceCenter( Vector( 0, 0, -500 ) )
				phys:SetVelocity( Vector( math.random(-200, 200), math.random(-200, 200), 500 ) )
				//timer.Simple(0.5, function() if IsValid(phys) then phys:EnableGravity( true ) end end)
				phys:EnableGravity( true )
				phys:EnableDrag(true)
			end

			ent:SetOwner(self.Owner)
			ent.Owner = self.Owner
			ent.WeaponClass = self:GetClass()
		end
	end
end

////////

function ENT:DoTrace(pos1, pos2)
	local tr = util.TraceHull({
		start = pos1,
		endpos = pos2,
		filter = self
	})
	
	return tr.HitPos, tr.HitNormal
end

local targets = {}

function ENT:FindTarget()

	table.Empty(targets)
	local ents = ents.FindInSphere(self:GetPos(), 650)


	for k,v in pairs(ents) do
		if IsValid(v) and (v:IsNPC() || v:IsPlayer()) then
			local tr = util.TraceHull({
				start = self:GetPos(),
				endpos = v:GetPos(),
				filter = {self, self.Owner}
			})
			local target = tr.Entity
			if IsValid(target) and (target:IsNPC() or target:IsPlayer()) and target != self.Owner then
				table.insert(targets, {ent = target, pos = self:GetPos():Distance(target:GetPos())})
				//target:SetSchedule(SCHED_RUN_FROM_ENEMY)
			end
		end
	end


	if targets then
		table.SortByMember(targets, "pos", true)
		if targets[1] then
			self.Target = targets[1].ent
		end
	end
end

function ENT:SpecialThink()

	if self:GetOwner():GetNWEntity("destiny_ghorn_target") then
		--[[
		local proxy = ents.FindInSphere( self:GetPos(), 650 )
		
		for k, v in pairs( proxy ) do 
			if ( IsValid(v) and (v:IsNPC() or v:IsPlayer()) and v != self.Owner ) then
				self.Target = v
			end
		end]]

		self.Target = self:GetOwner():GetNWEntity("destiny_ghorn_target")

		if self.Target and IsValid(self.Target) and self:Visible(self.Target) then
			
			local targetangle = (self.Target:GetPos() - self:GetPos() + (self.Target:OBBMins() + self.Target:OBBMaxs()) *.2):Angle()
		
			//self:SetAngles(targetangle)

			
			//PrintMessage(HUD_PRINTTALK, tostring(self.Ratio))
			//local test = math.Clamp(self.Target:GetPos():GetNormalized():Distance(self:GetPos():GetNormalized()), 0, 1) 
			self.Ratio = self.Ratio + .005
		//	PrintMessage(HUD_PRINTTALK,  self.Ratio)
			self:SetAngles(LerpAngle(self.Ratio, self:GetAngles(), targetangle))

			local phys = self:GetPhysicsObject()

			if IsValid(phys) then
				phys:SetVelocity(self:GetForward() * Lerp(self.Ratio, 2000, 3000))
			end

		

			self:SetHasTarget(true)
			self:SetNewAngle(targetangle)

			//if self.AccelerationTime2 > 0 and self.AccelProgress < 1 then
			//	self.LastAccelThink = self.LastAccelThink or CurTime()
			//	self.AccelProgress = Lerp((CurTime() - self.LastAccelThink) / self.AccelerationTime2, self.AccelProgress, 1)
			//end
			//self:SetMoveType(bit.bor(MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE))
			//self:SetLocalVelocity(self:GetForward() * Lerp(self.AccelProgress, self.BaseSpeed, self.MaxSpeed))


		//else
			//self:FindTarget()
		end
	end
end