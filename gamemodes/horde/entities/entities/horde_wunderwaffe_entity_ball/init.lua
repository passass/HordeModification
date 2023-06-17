AddCSLuaFile("shared.lua")
include('shared.lua')

--ENT.CollidePCF = "tesla_impact"
ENT.MaxChain = 10
ENT.ZAPRANGE = 256
ENT.HasCollided = false
ENT.CollisionGroup = COLLISION_GROUP_PROJECTILE

function ENT:Initialize()
 
	self:SetModel( "models/dav0r/hoverball.mdl" )
    self:SetNoDraw(true)
    self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    --self:SetSolid( SOLID_VPHYSICS )
    self:SetSolidFlags(FSOLID_NOT_STANDABLE)
    --self:SetTrigger(true)
    self:DrawShadow(false)
	
	self:EmitSound("weapons/tesla_gun/projectile/proj_loop.wav")
	
	self.dmginfo = DamageInfo()
	self.dmginfo:SetDamageType(DMG_SHOCK)
	self.dmginfo:SetAttacker(self.Owner)
	self.dmginfo:SetInflictor(self)
	self.dmginfo:SetInflictor(self)
	self.dmginfo:SetDamageForce(Vector(2,2,8))
	self.dmginfo:SetDamage(50)
end

function ENT:StartTouch(ent)
	print(ent)
	if !(ent:IsNPC() || ent:IsNextBot()) then return end
	self:OnCollide(ent, self:GetPos())
	self.HasCollided = true
end

function ENT:PhysicsCollide(data)
	local hitent = data.HitEntity
	print(hitent)
	if hitent:IsPlayer() then return end
	self:OnCollide(hitent, data.HitPos)
	self.HasCollided = true
end

function ENT:OnCollide(ent, pos)
	if self.HasCollided then return end
	self.HasCollided = true
	
	self:StopSound("weapons/tesla_gun/projectile/proj_loop.wav")
	if self:WaterLevel() > 1 then
		self:EmitSound("weapons/tesla_gun/projectile/proj_impact_water.mp3")
	else
		self:EmitSound("weapons/tesla_gun/projectile/proj_impact.mp3")
	end
	--ParticleEffect( self.CollidePCF, pos, self:GetAngles() )
	self:StopParticles()
	
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	if self.Owner:GetPos():DistToSqr(self:GetPos()) < 5184 then
		self.dmginfo:SetDamage(50)
		self.Owner:TakeDamageInfo(self.dmginfo)
	end
	
	if !ent:IsNPC() and !ent:IsNextBot() then
		self.dmginfo:SetDamage(50)
		ent:TakeDamageInfo(self.dmginfo)
	end
	
	self.lastTargetPos = self:GetPos()
	local target = self:FindNearestEntity(self.lastTargetPos)
	
	if !IsValid(target) then
		SafeRemoveEntity(self)
		return
	end
	
	self:Zap(self.lastTargetPos, target)
	self:EmitSound("weapons/tesla_gun/wpn_tesla_flux.mp3", 80)
	
	local killcount = 1
	
	local timername = self:EntIndex().."wunderwaffetimer"
	
	timer.Create(timername, 0.25, self.MaxChain - 1, function()
		target = self:FindNearestEntityCheap(self.lastTargetPos)
		if !IsValid(target) then
			timer.Stop(timername)
			timer.Remove(timername)
			SafeRemoveEntity(self)
			return
		end
		
		self.ZAPRANGE = self.ZAPRANGE - 20
		self:Zap(self.lastTargetPos, target)
		
		if self:WaterLevel() > 1 then
			self:EmitSound("weapons/tesla_gun/projectile/proj_impact_water.mp3")
		else
			self:EmitSound("weapons/tesla_gun/projectile/proj_impact.mp3")
		end
		killcount = killcount + 1
		if killcount == 5 then
			self.Owner:EmitSound("weapons/tesla_gun/happy/happy_0"..math.random(0,3)..".ogg", 75, 100, 1, CHAN_WEAPON )
			killcount = 0
		end
	end)
end

function ENT:Zap(lastTargetPos, target)
	self.dmginfo:SetDamage(35)
	
	local att
	if target:GetAttachment(2) then
		att = target:GetAttachment(2).Pos
	else
		att = target:GetPos() + target:OBBCenter()
	end
	util.ParticleTracerEx( "tesla_jump", lastTargetPos, att, true, 1, 1 )
	ParticleEffectAttach( "tesla_electrocute", PATTACH_POINT_FOLLOW, target, 2)
	if target:OnGround() then
		ParticleEffectAttach( "tesla_electrocute1", PATTACH_ABSORIGIN_FOLLOW, target, 0)
	end
	
	target:EmitSound("weapons/tesla_gun/bounce/bounce_0"..math.random(0,1)..".mp3")
	target:EmitSound("sfx/levels/zombie/maps/asylum/traps/zom_arc/zom_arc_0"..math.random(0,1)..".ogg", 75, 100, 1, CHAN_ITEM)
	
	self.lastTargetPos = att
	self.dmginfo:SetDamagePosition( att )
	target:TakeDamageInfo(self.dmginfo)
end

function ENT:FindNearestEntity(pos)
	local nearbyents = {}
	for k, v in pairs(ents.FindInSphere(pos, 128)) do
		if (v:IsNPC() or v:IsNextBot()) and v:Health() > 0 then
			table.insert(nearbyents, v)
		end
	end
	table.sort(nearbyents, function(a, b) return a:GetPos():DistToSqr(pos) < b:GetPos():DistToSqr(pos) end)
	return nearbyents[1]
end

function ENT:FindNearestEntityCheap(pos)
	local nearestent
	for k, v in pairs(ents.FindInSphere(pos, self.ZAPRANGE)) do
		if (v:IsNPC() or v:IsNextBot()) and v:Health() > 0 then
			nearestent = v
			break
		end
	end
	return nearestent
end