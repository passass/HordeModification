
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

	local tracer = Material("effects/smoke_trail")
	local smoke = Material("trails/smoke")

	function ENT:Draw()
		self.Entity:DrawModel()
	end
else
end

ENT.Model = "models/weapons/w_models/w_syringe_proj.mdl"
ENT.Ticks = 0
ENT.FuseTime = 10
ENT.CollisionGroup = COLLISION_GROUP_PROJECTILE
--ENT.CollisionGroupType = COLLISION_GROUP_PROJECTILE
ENT.Removing = nil
ENT.Drag = true
ENT.Gravity = true
ENT.DragCoefficient = 0.25

function ENT:Initialize()
	local pb_vert = 0.5
	local pb_hor = 0.5
	self:SetModel(self.Model)
	self:PhysicsInitBox( Vector(-pb_vert,-pb_hor,-pb_hor), Vector(pb_vert,pb_hor,pb_hor) )

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableDrag(false)
		phys:SetDragCoefficient(self.DragCoefficient)
		phys:EnableGravity(self.Gravity)
		phys:SetMass(0)
		phys:SetBuoyancyRatio(0)

		local ply = self:GetOwner()
		local wep = ply:GetActiveWeapon()

		if IsValid(wep) then

			local ang = ply:EyeAngles() + wep:GetFreeAimOffset()
			local RealVelocity = ply:GetAbsVelocity() + ang:Forward() * 7000

			phys:SetVelocityInstantaneous(RealVelocity)
		end

		--self:SetCollisionGroup(self.CollisionGroup or COLLISION_GROUP_DEBRIS)
		
	end

	self.SpawnTime = CurTime()
	self.StartPos = self:GetPos()
end

function ENT:PhysicsCollide( data, physobj )
	if self.HitObject then return end

	local owner = self:GetOwner()

	if IsValid(data.HitEntity) and !self.MarkForDeleted then
		if data.HitEntity == owner then return end
		if data.HitEntity:IsNPC() then
			HORDE:ApplyTemporaryDamage(owner, self.Inflictor, data.HitEntity, nil, {
				Damage_Type = DMG_NERVEGAS,
				Damage = 10,
				Delay = .5,
				Damage_Times = 5,
				Fixed_Pos_Relative = data.HitPos - data.HitEntity:GetPos(),
			})
			local effectdata = EffectData()
            effectdata:SetOrigin(data.HitPos)
            util.Effect("hordeext_heal_mist_syringe", effectdata)
		elseif data.HitEntity:IsPlayer() then
			if IsValid(owner) then
				local healinfo = HealInfo:New({amount = self.Syringe_Heal, healer = owner, immediately = false})
				HORDE:OnPlayerHeal(data.HitEntity, healinfo)
			end
			local effectdata = EffectData()
            effectdata:SetOrigin(data.HitPos)
            util.Effect("hordeext_heal_mist_syringe", effectdata)
		end
		--self.MarkForDeleted = true
		--self:Remove()
		--return true
		self:SetParent(data.HitEntity)

		self:SetSolid( SOLID_NONE )
		self:SetMoveType( MOVETYPE_NONE )
		self:PhysicsInit( SOLID_NONE )
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:SetMoveCollide(0)
		self.HitObject = true
		self:SetPos(data.HitPos + data.HitNormal)
		if self.particle and IsValid(self.particle) then
			self.particle:Remove()
			self.particle = nil
		end
		self.EndPos = data.HitPos
		--util.ParticleTracer( "arccw_tracer", self.StartPos, self:GetPos() )
		timer.Simple(5, function()
			if IsValid(self) then
				self.MarkForDeleted = true
				self:Remove()
			end
		end)
	else
		self.MarkForDeleted = true
		self:Remove()
	end

	--if IsValid(owner) then
		
		return true
	--end
end

function ENT:OnRemove()
	if self.particle and IsValid(self.particle) then self.particle:Remove() end
end

function ENT:Think()
end



