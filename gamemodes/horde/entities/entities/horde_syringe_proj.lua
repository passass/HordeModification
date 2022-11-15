
if SERVER then
	AddCSLuaFile( )
end
ENT.Type 				= "anim"
ENT.Base 				= "base_entity"
ENT.PrintName 			= "Syringe"
ENT.Author 				= ""
ENT.Information 		= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

if CLIENT then 
	language.Add("projectile_syringe", "Syringe")
	killicon.Add("projectile_syringe","sprites/bucket_syrgun_red",Color ( 255, 255, 255, 255 ) )

	function ENT:Initialize()
	end

	function ENT:Draw()
		self.Entity:DrawModel()
	end
else

	ENT.Model = "models/weapons/w_models/w_syringe_proj.mdl"
	ENT.Ticks = 0
	ENT.FuseTime = 10
	ENT.CollisionGroup = COLLISION_GROUP_PROJECTILE
	ENT.CollisionGroupType = COLLISION_GROUP_PROJECTILE
	ENT.Removing = nil

	if SERVER then

	function ENT:Initialize()
		local pb_vert = 0.5
		local pb_hor = 0.5
		self:SetModel(self.Model)
		self:PhysicsInitBox( Vector(-pb_vert,-pb_hor,-pb_hor), Vector(pb_vert,pb_hor,pb_hor) )

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end

		self.SpawnTime = CurTime()

		timer.Simple(0.1, function()
			if !IsValid(self) then return end
			self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		end)
		
		self.particle = ents.Create("info_particle_system")
		self.particle:SetPos(self:GetPos())
		self.particle:SetAngles(self:GetAngles())
		self.particle:SetKeyValue( "effect_name", "nailtrails_medic_red" )
		self.particle:SetKeyValue( "start_active", "1" )
		self.particle:SetParent(self)
		self.particle:Spawn()
		self.particle:Activate()
		
		self.Syringe_Damage = self.Inflictor.Syringe_Damage or 10
		self.Syringe_Heal = self.Inflictor.Syringe_Heal or 10
	end
	
	end

	--[[ENT.Model = "models/weapons/w_models/w_syringe_proj.mdl"
	function ENT:Initialize()
		if self.CrossbowFestive then
		self:SetModel( "models/weapons/c_models/c_crusaders_crossbow/c_crusaders_crossbow_xmas_proj.mdl" )
		elseif self.Blutsauger then
		self:SetModel( "models/weapons/c_models/c_leechgun/c_leech_proj.mdl" )
		else
		--self:SetModel( "models/weapons/c_models/c_leechgun/c_leech_proj.mdl")--"models/weapons/w_models/w_syringe_proj.mdl" )
		--end]]
		--[[self:SetModel(self.Model)
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_CUSTOM )
		self:SetHealth(1)
		self:PhysicsInitSphere( 0.1 )
		self:SetMoveCollide( 3 )
		if self.Blue then
			self:SetSkin(1)
		end]]
		--[[local pb_vert = 0.5
		local pb_hor = 0.5
		local phys = self.Entity:GetPhysicsObject()
		self:PhysicsInitBox( Vector(-pb_vert,-pb_hor,-pb_hor), Vector(pb_vert,pb_hor,pb_hor) )
		if (phys:IsValid()) then
			phys:Wake()
			phys:SetMass( 0.1 )
			phys:EnableDrag(false)
			if self.CrossbowFestive then
				phys:EnableGravity(false)
			elseif self.Crossbow then
				phys:EnableGravity(false)
			else	
				phys:EnableGravity(true)
				phys:SetBuoyancyRatio( 0.1 )
			end	
		end
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self.particle = ents.Create("info_particle_system")
		self.particle:SetPos(self:GetPos())
		self.particle:SetAngles(self:GetAngles())
		self.particle:SetKeyValue( "effect_name", "nailtrails_medic_red" )
		self.particle:SetKeyValue( "start_active", "1" )
		self.particle:SetParent(self)
		self.particle:Spawn()
		self.particle:Activate()
		
		--[[if self:GetNWBool("Blutsauger") then
			for k,v in pairs( ents.FindInSphere( self:GetPos(), self.Range ) ) do
				if (v:IsPlayer() or v:IsNPC()) then
					if v ~= self.Owner then
						self.Owner:SetHealth(self.Owner:Health() + 20)
					end
				end
			end
		end]]
	--end
end

function ENT:OnRemove()
	if self.particle and IsValid(self.particle) then self.particle:Remove() end
end

function ENT:Think()
end

function ENT:PhysicsCollide( data, physobj )

	if self.HitObject then return end
	if IsValid(data.HitEntity) then 
		local owner = self:GetOwner()
		if data.HitEntity == self:GetOwner() then return end
		if data.HitEntity:IsNPC() then
			--[[if self.Crossbow or self.CrossbowFestive then
				local damage = 38
			elseif self.Proto then
				local damage = 9
			else
				local damage = 10
			end]]
			--data.HitEntity:TakeDamage(self.Syringe_Damage, IsValid(owner) and owner or self, self)
			local bullet = {}
			bullet.Num=1
			bullet.Src=self:GetPos()
			bullet.Dir=self:GetAngles():Forward()
			bullet.Spread=Vector(0,0,0)
			bullet.Tracer=0	
			bullet.Force=0
			bullet.Damage=self.Syringe_Damage
			self:FireBullets(bullet)
		elseif data.HitEntity:IsPlayer() then
			if IsValid(owner) then
				local healinfo = HealInfo:New({amount = self.Syringe_Heal, healer = owner, immediately = true})
                HORDE:OnPlayerHeal(data.HitEntity, healinfo)
			end
		end
		
		self:Remove()
		return true
	end
--[[if IsValid(self.Owner) thens
			if !data.HitEntity:IsWorld() and !data.HitEntity:IsRagdoll() then
				self.Owner:SetHealth(self.Owner:Health() + 3)
			end
		end]]
	

	--[[bullet = {}
	bullet.Num=1
	bullet.Src=self:GetPos()
	bullet.Dir=self:GetAngles():Forward()
	bullet.Spread=Vector(0,0,0)
	bullet.Tracer=0	
	bullet.Force=0
	bullet.Damage=0]]

	if IsValid(self.Owner) then
		--if !data.HitEntity:IsWorld() then
		--self:FireBullets(bullet)
		--end
		self:SetSolid( SOLID_NONE )
		self:SetMoveType( MOVETYPE_NONE )
		self:PhysicsInit( SOLID_NONE )
		self:SetMoveCollide(0)
		self.HitObject = true
		self:SetPos(data.HitPos +data.HitNormal /1.2)
		if self.particle and IsValid(self.particle) then
			self.particle:Remove()
			self.particle = nil
		end
		timer.Simple(20, function() if self and IsValid(self) then self:Remove() end end)
		return true
	end	
end

