AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Damage = 100
ENT.Prime = 0
ENT.Delay = 300
ENT.HideDelay = 0.0
ENT.effect          = "deathbringer_orb_fx"

local holding = 0
function ENT:Initialize()
	local mdl = self:GetModel()

	if not mdl or mdl == "" or mdl == "models/error.mdl" then
		self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	end
	self:SetNoDraw(true)
	
	self:PhysicsInit(SOLID_VPHYSICS)
	--self:PhysicsInitSphere((self:OBBMaxs() - self:OBBMins()):Length() / 4, "metal")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end

	//self:SetFriction(self.Delay)
	//self:DrawShadow(true)
	self.StartTime = CurTime()
	//self:EmitSound( "TFA_INS2_RPG7.Loop" )
	self:SetUseType(SIMPLE_USE)
	self.HasIdle = true
	timer.Simple(0.1, function()
		if IsValid(self) then
			self:SetOwner()
		end
	end)
	self:SetNWFloat("HideTime",CurTime() + self.HideDelay )
	self.HP = math.random(30, 60)
	holding = 0
	ParticleEffectAttach(self.effect, 1, self, 1)
	timer.Simple(0.3, function() if IsValid(self) and IsValid(self.Owner) and self.Owner:KeyDown(IN_ATTACK) then holding = 1 end end )
end

function ENT:Think()
	if self.Owner:KeyReleased(IN_ATTACK) and holding == 1 then
		self:Explode()
		timer.Simple(0.2, function() holding = 0 end)
	end
	//timer.Simple(7, function() if IsValid(self) then self:Explode() end end)
	self:NextThink(CurTime())

	return true
end

local effectdata, shake

function ENT:Explode()
	if not IsValid(self.Owner) then
		SafeRemoveEntity(self)

		return
	end

	self:EmitSound("TFA_DEATHBRINGER_EXPLODE.1", 140)
	holding = 0
	util.BlastDamage(self.Owner, self.Owner, self:GetPos(), 200, 450)
	ParticleEffect("deathbringer_impact", self:GetPos(), Angle(-90, 0, 0), self)
	--self:EmitSound("TFA_INS2_RPG7.2")
	for i=1,6 do 
		self:SpawnFalling()
	end
	SafeRemoveEntity(self)
end

function ENT:SpawnFalling()
	if SERVER then
		local aimcone = 0--self:CalculateConeRecoil()
		local ent = ents.Create("horde_deathbringer_projectile_falling")
		local ang = ent:GetAngles()
		ent:SetPos(self:GetPos())
		ent.Owner = self.Owner
		ent:SetAngles(self.Owner:EyeAngles())
		ent.damage = 150
		ent.mydamage = 150
		local trail = util.SpriteTrail(ent, 0, Color(162,0,255,200), true, 13, 2, .5, 1/(15+1)*0.5, "trails/smoke.vmt")

		ent:Spawn()
		ent:SetAngles(Angle(0, 0, 0))
		dir = ang:Up()
		local phys = ent:GetPhysicsObject()

		if IsValid(phys) then
			//phys:ApplyForceCenter( Vector( 0, 0, -500 ) )
			phys:SetVelocity( Vector( math.random(-50, 50), math.random(-50, 50), -10 ) )
			phys:EnableGravity( false )
			phys:EnableDrag(true)
		end

		if self.ProjectileModel then
			ent:SetModel("models/weapons/tfa_ins2/w_rpg7_projectile.mdl")
		end

		ent:SetOwner(self.Owner)
		ent.Owner = self.Owner
		ent.WeaponClass = self:GetClass()
	end
end


function ENT:PhysicsCollide(data, phys)
	if data.Speed > 60 and CurTime() > self.StartTime + self.Prime then
		if IsValid(self) then
			timer.Create("explode", 0, 1, function() self:Explode() end)
		end
	end
end


function ENT:OnRemove()
	if self.HasIdle then
		self.HasIdle = false
	end
end
