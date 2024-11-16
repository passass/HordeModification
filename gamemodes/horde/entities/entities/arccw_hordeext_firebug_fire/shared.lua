ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Fire Particle"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Model = "models/Items/AR2_Grenade.mdl"

ENT.FireTime = 5

ENT.Armed = false

ENT.NextDamageTick = 0

ENT.Ticks = 0

ENT.ArcCW_Killable = false

AddCSLuaFile()

function ENT:Horde_StartTimeStop()
	if !self.Horde_TimeStoped then
		self.Horde_TimeStoped = true
		timer.Pause("Horde_DeleteSelf" .. self:GetCreationID())
		self.FireTime = self.FireTime + HORDE.TimeStop_TimeEnough()
	end
end

function ENT:Horde_EndTimeStop()
	if self.Horde_TimeStoped then
		self.Horde_TimeStoped = nil
		timer.UnPause("Horde_DeleteSelf" .. self:GetCreationID())
	end
end

function ENT:Initialize()
    if SERVER then
        self:SetModel( self.Model )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit(SOLID_VPHYSICS)
        self:DrawShadow( false )
        --self:SetCollisionBounds(Vector(-150,-150,-100), Vector(150,150,100))
        --self:SetTrigger(true)
        --self:UseTriggerBounds(true, 24)

        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:EnableMotion( false )
            phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
            phys:Wake()
        end

        self.SpawnTime = CurTime()
        self:Detonate()
        self:FillFireTimer()

        timer.Simple(0.1, function()
            if !IsValid(self) then return end
            self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
        end)
    end

    local owner = self:GetOwner()
    self.has_burner = nil
    self.Owner = owner
    if owner and owner:Horde_GetGadget() == "gadget_hydrogen_burner" then
        self.has_burner = true
    end
end

local fired = {
    "sprites/flamelet1",
    "sprites/flamelet2",
    "sprites/flamelet3",
    "sprites/flamelet4",
    "sprites/flamelet5",
}
local function GetFireParticle()
    return fired[math.random(#fired)]
end

function ENT:FillFireTimer()
    self.FireTime = math.Rand(2.5, 3)

    local timername = "Horde_DeleteSelf" .. self:GetCreationID()

    --local is_timer_stopped = timer.Exists(timername) and timer.Exists(timername)

    timer.Create(timername, self.FireTime, 1, function()
        if !IsValid(self) then return end

        self:Remove()
    end)
end

function ENT:Think()
    local ct = CurTime()
    if !self.SpawnTime then self.SpawnTime = ct end

    if CLIENT then
        local emitter = ParticleEmitter(self:GetPos())

        if !self:IsValid() or self:WaterLevel() > 2 then return end
        if !IsValid(emitter) then return end

        for i = 1,5 do
            local fire = emitter:Add(GetFireParticle(), self:GetPos() + (VectorRand() * 30))
            fire:SetVelocity( VectorRand() * 100 * VectorRand() )
            fire:SetGravity( Vector(0, 0, 200) )
            fire:SetDieTime( math.Rand(0.2, 0.5) )
            fire:SetStartAlpha( 255 )
            fire:SetEndAlpha( 0 )
            fire:SetStartSize( 0 )
            fire:SetEndSize( 25 )
            fire:SetRoll( math.Rand(-180, 180) )
            fire:SetRollDelta( math.Rand(-0.2,0.2) )
            if self.has_burner then
                fire:SetColor( 0, 135, 255 )
            else
                fire:SetColor( 255, 255, 255 )
            end 
            fire:SetAirResistance( 150 )
            local pos = VectorRand() * math.random(10,40)
            pos.z = 0
            fire:SetPos( self:GetPos() + pos )
            fire:SetLighting( false )
            fire:SetCollide(true)
            fire:SetBounce(0.75)
            fire:SetNextThink( CurTime() + FrameTime() )
            fire:SetThinkFunction( function(pa)
                if !pa then return end
                local col1 = Color(255, 135, 0)
                if self.has_burner then
                    col1 = Color(0, 135, 255)
                end
                local col2 = Color(0, 0, 0)

                local col3 = col1
                local d = pa:GetLifeTime() / pa:GetDieTime()
                col3.r = Lerp(d, col1.r, col2.r)
                col3.g = Lerp(d, col1.g, col2.g)
                col3.b = Lerp(d, col1.b, col2.b)

                pa:SetColor(col3.r, col3.g, col3.b)
                pa:SetNextThink( CurTime() + FrameTime() )
            end )
        end

        emitter:Finish()

        self.Ticks = self.Ticks + 1
    else

        if self:GetVelocity():LengthSqr() <= 32 then
            self:SetMoveType( MOVETYPE_NONE )
        end

        if self.NextDamageTick > ct then return end

        if self:WaterLevel() > 2 then self:Remove() return end

        self.NextDamageTick = ct + 0.25

        for _, ent in pairs(ents.FindInSphere(self:GetPos(), 70)) do
            if ent.Health and ent:Health() > 0 and (ent:IsPlayer() or ent:IsNPC() or ent.KFNPCStopAllTimers) then
                local damaged_lasttime = ent.Horde_Firebug_fire_damagelasttime

                if damaged_lasttime and damaged_lasttime + .25 >= ct then
                    continue
                end

                ent.Horde_Firebug_fire_damagelasttime = ct

                local d = DamageInfo()
                d:SetDamage(ent:IsPlayer() and 2 or 10)
                if ent:Horde_GetIgniteDamageTaken() < 2 then
                    ent:Horde_SetIgniteDamage(2)
                end
                d:SetAttacker(self.Owner)
                d:SetInflictor(self)
                d:SetDamageType(DMG_BURN)
                d:SetDamagePosition(self:GetPos())
                ent:TakeDamageInfo(d)
            end
        end
    end
end

function ENT:OnRemove()
    if !self.FireSound then return end
    self.FireSound:Stop()
end

function ENT:Detonate()
    if !self:IsValid() then return end

    self.Armed = true

    if self.Order and self.Order != 1 then return end

    --[[self.FireSound = CreateSound(self, "arccw_go/molotov/fire_loop_1.wav")
    self.FireSound:Play()

    self.FireSound:ChangePitch(80, self.FireTime)

    timer.Simple(self.FireTime - 1, function()
        if !IsValid(self) then return end

        self.FireSound:ChangeVolume(0, 1)
    end)]]
end

function ENT:Draw()
    -- cam.Start3D() -- Start the 3D function so we can draw onto the screen.
    --     render.SetMaterial( GetFireParticle() ) -- Tell render what material we want, in this case the flash from the gravgun
    --     render.DrawSprite( self:GetPos(), math.random(200, 250), math.random(200, 250), Color(255, 255, 255) ) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
    -- cam.End3D()
end