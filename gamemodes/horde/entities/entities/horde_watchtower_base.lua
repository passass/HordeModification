AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
    
    ENT.Horde_WatchTowerLight_Enable = false
    ENT.Horde_WatchTowerLight_Color_Red = 0
    ENT.Horde_WatchTowerLight_Color_Green = 0
    ENT.Horde_WatchTowerLight_Color_Blue = 0
    ENT.Horde_WatchTowerLight_Brightness = 5
    ENT.Horde_WatchTowerLight_Size = 150
    function ENT:Think()
        if !self.Horde_WatchTowerLight_Enable then return end
        if not self.dlight then
            self.dlight = DynamicLight(0)
            self.dlight.Pos = self:GetPos()
            self.dlight.r = self.Horde_WatchTowerLight_Color_Red
            self.dlight.g = self.Horde_WatchTowerLight_Color_Green
            self.dlight.b = self.Horde_WatchTowerLight_Color_Blue
            self.dlight.Brightness = self.Horde_WatchTowerLight_Brightness
            self.dlight.Size = self.Horde_WatchTowerLight_Size
            self.dlight.DieTime = CurTime() + 1
        end
        if self.dlight then
            self.dlight.Pos = self:GetPos()
            self.dlight.DieTime = CurTime() + 1
        end
    end

    return
end
ENT.CleanupPriority = 2
ENT.Horde_ThinkInterval = 10
ENT.Horde_ShockwaveInterval = 2
ENT.Horde_WatchTower = true

function ENT:Initialize()
    self:SetModel("models/props_combine/combine_light001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
        phys:EnableGravity(true)
        phys:SetMass(10)
    end

    self.Horde_Owner = self:GetNWEntity("HordeOwner")
    
    self.Horde_EnableShockwave = nil
    self.Horde_NextShockWave = CurTime()

    if self.Horde_Owner:Horde_GetPerk("warden_restock") then
        self.Horde_ThinkInterval = self.Horde_ThinkInterval / 2
    end
    
    if self.Horde_Owner:Horde_GetPerk("warden_ex_machina") then
        self:Horde_AddWardenAura()
        self.Horde_EnableShockwave = true
    end

    self.Horde_NextThink = CurTime() + self.Horde_ThinkInterval
end

function ENT:HORDE_WatchTowerThink()

end

function ENT:Think()
    if CurTime() >= self.Horde_NextThink then
        if self:HORDE_WatchTowerThink() != false then self.Horde_NextThink = CurTime() + self.Horde_ThinkInterval end
        if SERVER then
            if self.Horde_Owner:IsPlayer() then
                hook.Run("Horde_WardenWatchtower", self.Horde_Owner, self)
            end
        end
    end

    if self.Horde_EnableShockwave then
        if CurTime() >= self.Horde_NextShockWave then
            local dmg = DamageInfo()
            dmg:SetAttacker(self.Horde_Owner)
            dmg:SetInflictor(self)
            dmg:SetDamageType(DMG_SHOCK)
            dmg:SetDamage(50)
            local e = EffectData()
            e:SetOrigin(self:GetPos())
            util.Effect("explosion_shock", e, true, true)
            util.BlastDamageInfo(dmg, self:GetPos(), 160)
            self.Horde_NextShockWave = CurTime() + self.Horde_ShockwaveInterval
        end
    end
end

hook.Add("PlayerUse", "PickUpWatchtower", function(ply, ent)
	if HORDE:IsWatchTower(ent) and ent:GetNWEntity("HordeOwner"):IsValid() and ent:GetNWEntity("HordeOwner") == ply then
        local p = ent:GetPos()
		p.z = ply:GetPos().z + 12
        ent:SetPos(p)
        ply:PickupObject(ent)
        local a = ply:GetAngles()
        ent:SetAngles(Angle(0, a.y, 0))
    end
end )