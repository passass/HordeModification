ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Hemo Grenade"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false

game.AddParticles("particles/freeze_geo_trail.pcf")
PrecacheParticleSystem("freeze_geo_trail")
PrecacheParticleSystem("frost_char_cloud")
PrecacheParticleSystem("frost_break_cloud")

game.AddParticles("particles/origins_staves.pcf")
PrecacheParticleSystem("originstaff_ice_impact")

ENT.Model = "models/weapons/arccw_go/w_eq_fraggrenade_thrown.mdl"
ENT.FuseTime = 3
ENT.ArmTime = 0
ENT.ImpactFuse = false
ENT.Armed = true
ENT.CollisionGroup = COLLISION_GROUP_PROJECTILE

AddCSLuaFile()

function ENT:Initialize()
    if SERVER then
        self:SetModel( self.Model )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:DrawShadow( true )

        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            phys:SetBuoyancyRatio(0)
        end

        self.SpawnTime = CurTime()
        self:SetColor(Color(0, 0, 0))

        if self.FuseTime <= 0 then
            self:Detonate()
        end
    end

    self:SetMaterial("Horde/Freeze/freeze_slush")
end

function ENT:PhysicsCollide(data, physobj)
    if SERVER then
        --[[self:GetPhysicsObject():SetDamping(2, 2)
        if data.Speed > 75 then
            self:EmitSound(Sound("physics/metal/metal_grenade_impact_hard" .. math.random(1,3) .. ".wav"))
        elseif data.Speed > 25 then
            self:EmitSound(Sound("physics/metal/metal_grenade_impact_soft" .. math.random(1,3) .. ".wav"))
        end

        if (CurTime() - self.SpawnTime >= self.ArmTime) and self.ImpactFuse then
            self:Detonate()
        end]]
        self:Detonate()
    end
end

function ENT:Think()
    if SERVER and CurTime() - self.SpawnTime >= self.FuseTime then
        self:Detonate()
    end
end

function ENT:Explode()
    if !self:IsValid() then return end
    --self:EmitSound("ambient/explosions/explode_1.wav", 100, 100, 1, CHAN_ITEM)

    local attacker = self

    if self:GetOwner():IsValid() then
        attacker = self:GetOwner()
    end

    local duration_elite = {4, 6}
    local duration = {7, 8}

    for _, ent in pairs(ents.FindInSphere(self:GetPos(), 225)) do
        if !IsValid(ent) or ent:Health() <= 0 or !ent:IsNPC() or HORDE:IsPlayerOrMinion(ent) then continue end
        local crea_id = ent:GetCreationID()
        if ent:GetVar("is_elite") then
            local cur_dur = math.Rand(duration_elite[1], duration_elite[2])
            --ent:Horde_AddFreezeEffect(cur_dur)
            ent:Horde_AddDebuffBuildup(HORDE.Status_Freeze, 150, self:GetOwner())

            local timername = "Horde_Remove_" .. tostring(HORDE.Status_Freeze) .. "_" .. crea_id
            timer.Create(timername, cur_dur, 1, function ()
                ent:Horde_RemoveDebuff(HORDE.Status_Freeze)
            end)
            continue
        end
        local cur_dur = math.Rand(duration[1], duration[2])
        ent.old_Freeze_Material = ent:GetMaterial()
        ent:SetMaterial("Horde/Freeze/freeze_slush")
        HORDE:TimeStop_freeze_npc(ent)
        
        local hookname = "Horde_ZombieFreeze_IncreaseDamage_" .. crea_id
        timer.Simple(cur_dur, function()
            if IsValid(ent) then
                ParticleEffectAttach( "frost_break_cloud", PATTACH_ABSORIGIN_FOLLOW, ent, 0 )
                ent:SetMaterial(ent.old_Freeze_Material)
                ent.old_Freeze_Material = nil
                ent:StopParticles()
                if !HORDE.TimeStop_Proceed() then
                    HORDE:TimeStop_unfreeze_npc(ent)
                end
            end
            hook.Remove("Horde_OnPlayerDamage", hookname)
        end)

        ParticleEffectAttach( "frost_char_cloud", PATTACH_POINT_FOLLOW, ent, ent:LookupAttachment("chest") )

        hook.Add("Horde_OnPlayerDamage", hookname, function(ply, npc, bonus, hitgroup, dmginfo)
            if npc == ent then
                bonus.more = bonus.more * 1.15
            end
        end)
    end

    local dmginfo = DamageInfo()
    dmginfo:SetDamage(50)
    dmginfo:SetDamageType(DMG_BULLET)
    dmginfo:SetAttacker(attacker)
    dmginfo:SetInflictor(self)
    dmginfo:SetDamageCustom(HORDE.DMG_PLAYER_FRIENDLY)
    util.BlastDamageInfo(dmginfo, self:GetPos(), 250)

    self:EmitSound("Horde/freeze_0" .. math.random(0, 2) .. ".ogg", 100, 100, 1, CHAN_ITEM)
    ParticleEffect("originstaff_ice_impact", self:GetPos(), self:GetAngles())
    --local ed = EffectData()
    --ed:SetOrigin(self:GetPos())
    --util.Effect("horde_shrapnel_grenade_explosion", ed, true, true)
end

function ENT:Detonate()
    if !self:IsValid() or self:WaterLevel() > 2 then return end
    if !self.Armed then return end

    self.Armed = false

    self:Explode()

    self:Remove()
end

function ENT:DrawTranslucent()
    self:Draw()
end

function ENT:Draw()
    self:DrawModel()
end