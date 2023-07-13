AddCSLuaFile()

ENT.Type = "anim"
ENT.Base 				= "base_entity"
ENT.PrintName = "Base Explosive"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true
ENT.DefaultModel = Model("models/weapons/w_eq_fraggrenade.mdl")

ENT.Damage = 100
ENT.Delay = 3


function ENT:Initialize()
    local mdl = self:GetModel()

    if not mdl or mdl == "" or mdl == "models/error.mdl" then
        self:SetModel(self.DefaultModel)
    end

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end

    self:SetFriction(self.Delay)
    self.killtime = CurTime() + self.Delay
    self:DrawShadow(true)

    if not self.Inflictor and self:GetOwner():IsValid() and self:GetOwner():GetActiveWeapon():IsValid() then
        self.Inflictor = self:GetOwner():GetActiveWeapon()
    end
end

function ENT:Think()
    if self.killtime < CurTime() then
        self:Explode()

        return false
    end

    self:NextThink(CurTime())

    return true
end