if not ArcCWInstalled then return end
-- Referenced From GSO
ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Medic Grenade"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Model = "models/weapons/arccw_go/w_eq_smokegrenade_thrown.mdl"
ENT.FuseTime = 2
ENT.ArmTime = 0
ENT.TouchedEntities = {}

AddCSLuaFile()

function ENT:Initialize()
    if SERVER then
        self:SetModel(self.Model)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:DrawShadow(true)
        self:SetCollisionBounds(Vector(-150,-150,-100), Vector(150,150,100))
        self:SetTrigger(true)
        self:UseTriggerBounds(true, 24)

        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            phys:SetBuoyancyRatio(0)
        end

        self.Inflictor = self:GetOwner():GetActiveWeapon()
        self.SpawnTime = CurTime()

        timer.Simple(0, function()
            if !IsValid(self) then return end
            self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
        end)
    end
end

function ENT:PhysicsCollide(data, physobj)
    if SERVER then
        self:Detonate()
    end
end

function ENT:Think()
    if !self.SpawnTime then self.SpawnTime = CurTime() end

    if SERVER and CurTime() - self.SpawnTime >= 5 then
        self:Detonate()
    end
end

function ENT:Detonate()
    if !self:IsValid() then return end

    local ent = ents.Create("arccw_thr_medicgrenade")
    ent:SetPos(self:GetPos())
    ent:SetOwner(self.Owner)
    ent.Owner = self.Owner
    ent.Inflictor = self.Inflictor
    ent:Spawn()
    ent:Activate()
    timer.Simple(0, function()
        if ent:IsValid() then
            ent:Detonate() ent:SetArmed(true)
        end
    end)
    if ent:GetPhysicsObject():IsValid() then
        ent:GetPhysicsObject():EnableMotion(false)
    end

    timer.Simple(5, function()
        if !IsValid(self) then return end

        ent:Remove()
    end)
    self:Remove()
end

function ENT:DrawTranslucent()
    self:Draw()
end

function ENT:Draw()
    if CLIENT then
        self:DrawModel()
    end
end