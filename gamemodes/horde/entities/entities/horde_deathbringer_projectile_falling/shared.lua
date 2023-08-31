AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Category 	= "Destiny Weapons"
ENT.Purpose 	= ""
ENT.PrintName   = "Deathbringer falling"

ENT.Spawnable = false

ENT.LightEmit		= true
ENT.LightColor		= "200 200 255 255"
ENT.LightSpotRadius	= 80
ENT.LightDistance	= 210
ENT.LightBrightness	= 1
ENT.Damage = 110
ENT.Prime = 0.05
ENT.Delay = 0
ENT.HideDelay = 0.0
ENT.effect = "deathbringer_orb_fx"

ENT.PickUpSound = Sound("TFA_LUMINA_ORB.1")

if SERVER then
	AddCSLuaFile()
	function ENT:SetupDataTables()
		self:NetworkVar("Bool", 1, "HasOrb")
		self:NetworkVar("Bool", 0, "HasTarget")
		self:NetworkVar("Angle", 0, "NewAngle")
	end

function ENT:Initialize()

	self:SetModel("models/hunter/misc/sphere025x025.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetColor(Color(255, 255, 255, 255))
	self.StartTime = CurTime()
	self:SetNoDraw(true)

	self:SetNewAngle(self:GetAngles())
	self:GetOwner()

	ParticleEffectAttach(self.effect, 1, self, 1)

	local phys = self:GetPhysicsObject()

	if(phys:IsValid()) then
		phys:Wake()
		phys:EnableDrag(true)
		phys:EnableGravity(false)
		phys:SetBuoyancyRatio(1)
		timer.Simple(0.2, function() if IsValid(self) then phys:SetVelocity( Vector( 0, 0, -500 ) ) end end)
	end

	local fx2 = ents.Create( "light_dynamic" )
	if ( !IsValid( fx2 ) ) then return end
	fx2:SetKeyValue( "_light", self.LightColor )
	fx2:SetKeyValue( "spotlight_radius", self.LightSpotRadius * 1.2 )
	fx2:SetKeyValue( "distance", self.LightDistance * 1.2 )
	fx2:SetKeyValue( "brightness", 1 )
	fx2:SetPos( self:GetPos() )
	fx2:SetAngles( self:GetAngles() )
	fx2:Spawn()
	fx2:Fire( "kill", "", 0.115 )

	timer.Create("notargettest", 0, 1, function() if self:GetOwner():IsFlagSet(FL_NOTARGET) then
		self.Owner:PrintMessage(HUD_PRINTTALK, "Error: notarget is set to true. Orb will not follow you!")
	end end)
end


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
	local proxy = ents.FindInSphere( self:GetPos(), 650 )
	
	for k, v in pairs( proxy ) do 
		if ( IsValid(v) and (v:IsNPC() or v:IsPlayer()) and v != self.Owner ) then
			self.Target = v
		end
	end
	if self.Target and IsValid(self.Target) and self.Target:Health() > 0 and self.Target:WaterLevel() < 2 and self:Visible(self.Target) then
		local targetangle = (self.Target:GetPos() - self:GetPos() + (self.Target:OBBMins() + self.Target:OBBMaxs()) *.5):Angle()
		self:SetAngles(targetangle)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(self:GetForward() * 300)
		end
		self:SetHasTarget(true)
		self:SetNewAngle(targetangle)
	else
		self:FindTarget()
	end
end

function ENT:Think()
	if ( SERVER ) then
		
		if ( !IsValid( self ) ) then self:Remove() end
		
		local proxy = ents.FindInSphere( self:GetPos(), 50 )
	
		for k, v in pairs( proxy ) do 
			if ( v:IsPlayer() or v:IsNPC() ) then
				self:Explode()
			end
		end

		if IsValid(phys) then phys:SetVelocity(self:GetAngles():Forward() * 7) end
		self:SpecialThink()

		timer.Simple(7, function()
		if IsValid(self) then
			self:Explode()
		end
	end)
		--print(self:GetOwner())
		
	end
end

function ENT:Explode()
	if not IsValid(self.Owner) then
		self:Remove()
		return
	end

	self:EmitSound("TFA_DEATHBRINGER_EXPLODE.1", 75, 100, 1)
	util.BlastDamage(self.Owner, self.Owner, self:GetPos(), 200, self.Damage)
	ParticleEffect("deathbringer_impact", self:GetPos(), Angle(-90, 0, 0), self)
	--self:EmitSound("TFA_INS2_RPG7.2")
	timer.Simple(0.1, function() if IsValid(self) then self:Remove() end end)
	//self:SpawnFalling()
	//self:ShootBullet3()
end

function ENT:PhysicsCollide(data, phys)
	if data.Speed > 60 and CurTime() > self.StartTime + self.Prime then
		timer.Simple(0,function()
			if IsValid(self) then
				self:Explode()
			end
		end)
	else
		//self.Prime = math.huge
		if self.HasIdle then
			self.HasIdle = false
			self:SetNWFloat("HideTime", -1 )
		end
	end
end

end

if CLIENT then

	function ENT:Draw()
		self:DrawModel()
		self:DestroyShadow()
	end

end



