if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/horde_barricadekit")
end

SWEP.PrintName = "Barricade Kit"
SWEP.Category = "Horde"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_nothing.mdl"
SWEP.WorldModel = "models/weapons/w_nothing.mdl"
SWEP.ViewModelFlip = false
SWEP.BobScale = 1
SWEP.SwayScale = 0

--[[SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false]]
SWEP.Weight = 3
SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.UseHands = true
SWEP.FiresUnderwater = true
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = true
SWEP.CSMuzzleFlashes = 1
SWEP.Base = "weapon_base"

SWEP.WalkSpeed = 186
SWEP.RunSpeed = 372

SWEP.Reloading = 0
SWEP.ReloadingTimer = CurTime()
SWEP.Idle = 0
SWEP.IdleTimer = CurTime()
SWEP.Recoil = 0
SWEP.RecoilTimer = CurTime()

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.ActivePos = Vector(0, -4, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.StickyOwner = nil
SWEP.Stickies = {}
SWEP.LastSticky = nil
local barricade_offset = 50
if CLIENT then
    local can_place_color = Color(0, 200, 0, 100)
    local cant_place_color = Color(150, 0, 0, 100)
    
    function SWEP:ControlBarricadePosition()
        local AimVector = self.Owner:GetAimVector()

        self.BarricadeModel:SetPos( self.Owner:GetPos() + Vector(barricade_offset, barricade_offset, 0) * AimVector )
        self.BarricadeModel:SetAngles( Angle(0, self.Owner:EyeAngles()[2], 0) )
    end

    function SWEP:InitBarricadeModel()
        if CLIENT and !IsValid(self.BarricadeModel) then
            self.BarricadeModel = ClientsideModel("models/props_c17/concrete_barrier001a.mdl")
            self:ControlBarricadePosition()
            self.BarricadeModel:SetRenderMode( RENDERMODE_TRANSCOLOR )
            self.BarricadeModel:Spawn()
        end
    end

    function SWEP:Think()
        if !IsValid(self.BarricadeModel) then 
            self:InitBarricadeModel()
        else
            self:ControlBarricadePosition()
        end
        
        self.BarricadeModel:SetColor(self:CanPlaceBarricade() and can_place_color or cant_place_color)
    end
end

function SWEP:Initialize()
    self:SetWeaponHoldType( "normal" )
end

function SWEP:Deploy()
    if CLIENT then
        self:InitBarricadeModel()
    else
        self:CallOnClient("Deploy")
    end
    return true
end

function SWEP:Holster()
    if CLIENT then
        self.BarricadeModel:Remove()
    end
    return true
end

function SWEP:OnRemove()
    if CLIENT then
        self.BarricadeModel:Remove()
    else
        self:CallOnClient("OnRemove")
    end
end
SWEP.CantDropWep = true

function SWEP:CanPlaceBarricade()
    --[[if SERVER then
        
    end
    local obbmax = self.BarricadeModel:OBBMaxs()
    local obbmin = self.BarricadeModel:OBBMins()
    local scale = self.BarricadeModel:GetModelScale()
    
    print(Vector(obbmax.X / scale, obbmax.Y / scale, obbmax.Z / scale))]]
    --print(Vector(obbmax.X / scale, obbmax.Y / scale, obbmax.Z / scale))
    local pos
    if SERVER then
        local AimVector = self.Owner:GetAimVector()
        pos = self.Owner:GetPos() + Vector(barricade_offset, barricade_offset, 0) * AimVector
    else
        pos = self.BarricadeModel:GetPos()
    end
    return !util.TraceHull({
        start = pos,
        endpos = pos,
        --maxs = Vector(obbmax.X / scale, obbmax.Y / scale, obbmax.Z / scale),--Vector(obbmax, obbmax, obbmax),
        --mins = Vector(obbmin.X / scale, obbmin.Y / scale, obbmin.Z / scale),--Vector(obbmin, obbmin, obbmin),
        collisiongroup = COLLISION_GROUP_PLAYER, -- Collides with stuff that players collide with
        mask = MASK_PLAYERSOLID, -- Detects things like map clips
        filter = function(ent) -- Slow but necessary
            --if not donttouchplayer and ent:IsPlayer() or not dontignorepowerups and string.sub(ent:GetClass(), 1, 5) == "drop_" or filters and table.HasValue(filters, ent:GetClass()) then return end -- The ent is a different player (AutoUnstuck_IgnorePlayers ConVar)
            --if ent:IsValidZombie() then return true end
            return true
        end
    }).Hit
end

if SERVER then
    function SWEP:Horde_OnSell()
        local ply = self.Owner
        local dropables = ply.Horde_drop_entities
        if !dropables then return end
        dropables["horde_barricadekit"] = nil
    end
end

function SWEP:PrimaryAttack()
    if SERVER and self:CanPlaceBarricade() then
        local ply = self.Owner
        local ent = ents.Create("horde_barricade")
        local AimVector = ply:GetAimVector()
        ent:SetPos( ply:GetPos() + Vector(barricade_offset, barricade_offset, 0) * AimVector )
        ent:SetAngles( Angle(0, ply:EyeAngles()[2], 0) )
        ent:SetNWEntity("HordeOwner", ply)--ent:SetOwner(ply)
        ent:Spawn()
        ent:Activate()
        ply:Horde_RemoveDropEntity("horde_barricadekit", self:GetCreationID())
        timer.Simple(0, function()
            self:Remove()
            ply:Horde_AddDropEntity("horde_barricadekit", ent)
            ply:Horde_SyncEconomy()
        end)
    end
end

function SWEP:SecondaryAttack()
end

