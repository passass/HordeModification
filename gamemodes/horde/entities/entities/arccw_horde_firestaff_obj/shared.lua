AddCSLuaFile()
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.CollidePCF = "originstaff_fire_impact"
ENT.Damage = 100
ENT.MoveSpeed = 3500
function ENT:Initialize()
	self:SetModel( "models/props_junk/rock001a.mdl" )
	local mat = "models/weapons/originstaffs/fire_proj"
	self:SetMaterial(mat)
	--self:SetNoDraw(true)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:DrawShadow(false)
	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetSolidFlags(FSOLID_NOT_STANDABLE)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	
	if CLIENT then return end
	self:SetTrigger(true)
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass( 1 )
		phys:EnableGravity( false )
		phys:EnableDrag( false )
		phys:SetBuoyancyRatio(0)
		phys:Wake()
		phys:AddAngleVelocity(Vector(math.random(-256,256), math.random(-256,256), math.random(-256,256)))	
	else
		self:Remove()
	end
	self.LifeTime = CurTime() + math.Rand(3,4)
	
	self:EmitSound("weapons/originstaffs/fire/projectile/loop.wav", 70)
end
if SERVER then

	function ENT:Detonate()
		if self.DoRemove then return end
		self.DoRemove = true
		local pos = self:GetPos()
		local dmg = DamageInfo()
		dmg:SetDamage(self.Damage)
		dmg:SetAttacker(self.Owner)
		dmg:SetDamageForce(vector_origin)
		dmg:SetDamageType(DMG_BURN)
		dmg:SetDamagePosition( pos )
		dmg:SetInflictor( self )
		util.BlastDamageInfo(dmg, self:GetPos(), 105)
		SafeRemoveEntityDelayed(self,0)
		self:PhysicsDestroy()
		self:EmitSound("weapons/originstaffs/fire/projectile/explo/proj_explo_"..math.random(0,2)..".ogg", 360)
	    ParticleEffect( self.CollidePCF, pos, self:GetAngles() )
	end
	
	function ENT:StartTouch(ent)
		if ent:IsNPC() or ent:IsNextBot() then
			self:Detonate()
		end
	end
		
	function ENT:PhysicsCollide(data)
		self:Detonate()
	end
end

function ENT:OnRemove()
	self:StopSound("weapons/originstaffs/fire/projectile/loop.wav")
end

/*
function ENT:UltimateAbility(pos)
	
end
*/