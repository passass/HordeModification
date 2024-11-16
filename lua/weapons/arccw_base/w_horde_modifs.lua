if engine.ActiveGamemode() != "horde" or GetConVar("horde_external_lua_config"):GetString() ~= "horde_ext" then return end

function SWEP:ChangeVar(varname, value, priority)
    self.ModifiedCache_Permanent[varname] = true
    self.ModifiedCache[varname] = true
    self.TickCache_Overrides[varname] = nil
    self.TickCache_Mults[varname] = nil
    self.TickCache_Adds[varname] = nil

    if priority then
        self[varname .. "_Priority"] = priority
    end

    local haspoint, _ = string.find( varname, "." )
    local tbl = self
    if haspoint then

        local splitted_modifiers = string.Split( varname, "." )
        
        for i=1, #splitted_modifiers - 1 do
            local v = splitted_modifiers[i]
            tbl = tbl[v]
        end

        varname = splitted_modifiers[#splitted_modifiers]
    end

    tbl[varname] = value
end

--[[function SWEP:AddElement(elementname, wm)
    local e = self.AttachmentElements[elementname]

    if !e then return end
    if !wm and self:GetOwner():IsNPC() then return end

    if !self:CheckFlags(e.ExcludeFlags, e.RequireFlags) then return end

    if GetConVar("arccw_truenames"):GetBool() and e.TrueNameChange then
        self.PrintName = e.TrueNameChange
    elseif GetConVar("arccw_truenames"):GetBool() and e.NameChange then
        self.PrintName = e.NameChange
    end

    if !GetConVar("arccw_truenames"):GetBool() and e.NameChange then
        self.PrintName = e.NameChange
    elseif !GetConVar("arccw_truenames"):GetBool() and e.TrueNameChange then
        self.PrintName = e.TrueNameChange
    end

    if e.AddPrefix then
        self.PrintName = e.AddPrefix .. self.PrintName
    end

    if e.AddSuffix then
        self.PrintName = self.PrintName .. e.AddSuffix
    end

    local og_weapon = weapons.GetStored(self:GetClass())

    local og_vm = og_weapon.ViewModel
    local og_wm = og_weapon.WorldModel

    self.ViewModel = og_vm
    self.WorldModel = og_wm

    local parent = self
    local elements = self.WM

    if !wm then
        parent = self.REAL_VM
        elements = self.VM
    end

    local eles = e.VMElements

    if wm then
        eles = e.WMElements

        if self.MirrorVMWM then
            self.WorldModel = e.VMOverride or self.WorldModel
            self:SetSkin(e.VMSkin or self.DefaultSkin)
            eles = e.VMElements
        else
            self.WorldModel = e.WMOverride or self.WorldModel
            self:SetSkin(e.WMSkin or self.DefaultWMSkin)
        end
    else
        self.ViewModel = e.VMOverride or self.ViewModel
        local vm = self.REAL_VM or self:GetOwner():GetViewModel()
        vm:SetSkin(e.VMSkin or self.DefaultSkin)
    end

    if SERVER then return end

    for _, i in pairs(eles or {}) do
        local model = ClientsideModel(i.Model)

        if !model or !IsValid(model) or !IsValid(self) then continue end

        if i.BoneMerge then
            model:SetParent(parent)
            model:AddEffects(EF_BONEMERGE)
        else
            model:SetParent(self)
        end

        local element = {}

        local scale = Matrix()
        scale:Scale(i.Scale or Vector(1, 1, 1))

        model:SetNoDraw(ArcCW.NoDraw)
        model:DrawShadow(false)
        model.Weapon = self
        model:SetSkin(i.ModelSkin or 0)
        if i.Material then
            model:SetMaterial(i.Material)
        end
        if i.Color then
            model:SetRenderMode( RENDERMODE_TRANSCOLOR )
            model:SetColor(i.Color)
        end
        --i.mdl = model
        --model:SetBodyGroups(i.ModelBodygroups or "")
        ArcCW.SetBodyGroups(model, i.ModelBodygroups or "")
        model:EnableMatrix("RenderMultiply", scale)
        model:SetupBones()
        element.Model = model
        element.DrawFunc = i.DrawFunc
        element.WM = wm or false
        element.Bone = i.Bone
        element.NoDraw = i.NoDraw or false
        element.BoneMerge = i.BoneMerge or false
        element.Bodygroups = i.ModelBodygroups
        element.DrawFunc = i.DrawFunc
        element.OffsetAng = Angle()
        element.OffsetAng:Set(i.Offset.ang or Angle(0, 0, 0))
        element.OffsetPos = Vector()
        element.OffsetPos:Set(i.Offset.pos or Vector(), 0, 0)
        element.IsMuzzleDevice = i.IsMuzzleDevice

        if self.MirrorVMWM then
            element.WMBone = i.Bone
        else
            element.WMBone = i.WMBone
        end

        table.insert(elements, element)
    end

end]]

function SWEP:InitialDefaultClip()
    if !self.Primary.Ammo then return end

    local ply = self:GetOwner()
    if ply and ply:IsPlayer() then
        if self:HasBottomlessClip() then
            self:SetClip1(0)
        end
        local ammotype = self.Primary.Ammo

        local total_ammo
        if self.ForceDefaultAmmo then
            total_ammo = self.ForceDefaultAmmo
        else 
            total_ammo = self:GetCapacity() * GetConVar("arccw_mult_defaultammo"):GetInt()
        end
        local max_ammo = HORDE:Ammo_GetMaxAmmo(self)
        for k, v in pairs(ply:GetWeapons()) do
            if v != self and v.Primary and v.Primary.Ammo == ammotype then
                local max_ammo_2 = HORDE:Ammo_GetMaxAmmo(v)
                if max_ammo < max_ammo_2 then
                    max_ammo = max_ammo_2
                end
            end
        end

        local diff_ammo = max_ammo - ply:GetAmmoCount(ammotype)
        if diff_ammo > 0 then
            self:GetOwner():GiveAmmo(diff_ammo > total_ammo and total_ammo or diff_ammo, ammotype)
        end
    end
end

SWEP.ModifiedCache_Permanent = {}

local old_AdjustAtts = SWEP.AdjustAtts
function SWEP:AdjustAtts()
    old_AdjustAtts(self)

    self.ModifiedCache = table.Merge(self.ModifiedCache_Permanent, self.ModifiedCache)
end

local old_FireRocket = SWEP.FireRocket
function SWEP:FireRocket(ent, vel, ang, dontinheritvel)
    local rocket = old_FireRocket(self, ent, vel, ang, dontinheritvel)

    if rocket then
        rocket.SpawnTime = CurTime()
    end
end

SWEP.ReloadInSights = true

function SWEP:IsVeryAccurateShoot()
    return self:GetBuff("Num") <= 1
end
if CLIENT then
    local mth        = math
    local m_log10    = mth.log10
    local m_rand     = mth.Rand
    local rnd        = render
    local SetMat     = rnd.SetMaterial
    local DrawBeam   = rnd.DrawBeam
    local DrawSprite = rnd.DrawSprite
    local lasermat = Material("arccw/laser")
    local flaremat = Material("effects/whiteflare")

    local delta    = 1
    function SWEP:DrawLaser(laser, model, color, world)
        local owner = self:GetOwner()
        local behav = ArcCW.LaserBehavior

        if !owner then return end

        if !IsValid(owner) then return end

        if !model then return end

        if !IsValid(model) then return end

        local att = model:LookupAttachment(laser.LaserBone or "laser")

        att = att == 0 and model:LookupAttachment("muzzle") or att

        local pos, ang, dir

        if att == 0 then
            pos = model:GetPos()
            ang = owner:EyeAngles() + self:GetFreeAimOffset()
            dir = ang:Forward()
        else
            local attdata  = model:GetAttachment(att)
            pos, ang = attdata.Pos, attdata.Ang
            dir      = -ang:Right()
        end

        if world then
            dir = owner:IsNPC() and (-ang:Right()) or dir
        else
            ang:RotateAroundAxis(ang:Up(), 90)

            if self.LaserOffsetAngle then
                ang:RotateAroundAxis(ang:Right(), self.LaserOffsetAngle[1])
                ang:RotateAroundAxis(ang:Up(), self.LaserOffsetAngle[2])
                ang:RotateAroundAxis(ang:Forward(), self.LaserOffsetAngle[3])
            end
            if self.LaserIronsAngle and self:GetActiveSights().IronSight then
                local d = 1 - self:GetSightDelta()
                ang:RotateAroundAxis(ang:Right(), d * self.LaserIronsAngle[1])
                ang:RotateAroundAxis(ang:Up(), d * self.LaserIronsAngle[2])
                ang:RotateAroundAxis(ang:Forward(), d * self.LaserIronsAngle[3])
            end

            dir = ang:Forward()

            local eyeang   = EyeAngles() - self:GetOurViewPunchAngles() + self:GetFreeAimOffset()
            local canlaser = self:GetCurrentFiremode().Mode != 0 and !self:GetReloading() and self:BarrelHitWall() <= 0

            delta = Lerp(0, delta, canlaser and self:GetSightDelta() or 1)

            --if self.GuaranteeLaser then
                delta = 1
            --else
            --    delta = self:GetSightDelta()
            --end

            dir = Lerp(delta, eyeang:Forward(), dir)
        end

        local beamdir, tracepos = dir, pos

        beamdir = world and (-ang:Right()) or beamdir

        if behav and !world then
            -- local cheap = GetConVar("arccw_cheapscopes"):GetBool()
            local punch = self:GetOurViewPunchAngles()

            ang = EyeAngles() - punch + self:GetFreeAimOffset()

            tracepos = EyePos() - Vector(0, 0, 1)
            pos, dir = tracepos, ang:Forward()
            beamdir  = dir
        end

        local dist = 128

        local tl = {}
        tl.start  = tracepos
        tl.endpos = tracepos + (dir * 33000)
        tl.filter = owner

        local tr = util.TraceLine(tl)

        tl.endpos = tracepos + (beamdir * dist)

        local btr = util.TraceLine(tl)

        local hit    = tr.Hit
        local hitpos = tr.HitPos
        local solid  = tr.StartSolid

        local strength = laser.LaserStrength or 1
        local laserpos = solid and tr.StartPos or hitpos

        laserpos = laserpos - ((EyeAngles() + self:GetFreeAimOffset()):Forward())

        if solid then return end

        local width = m_rand(0.05, 0.1) * strength * 1

        if (!behav or world) and hit then
            SetMat(lasermat)
            local a = 200
            DrawBeam(pos, btr.HitPos, width * 0.3, 1, 0, Color(a, a, a, a))
            DrawBeam(pos, btr.HitPos, width, 1, 0, color)
        end

        if hit and !tr.HitSky then
            local mul = 1 * strength
            mul = m_log10((hitpos - EyePos()):Length()) * strength
            local rad = m_rand(4, 6) * mul
            local glr = rad * m_rand(0.2, 0.3)

            SetMat(flaremat)

            -- if !world then
            --     cam.IgnoreZ(true)
            -- end
            DrawSprite(laserpos, rad, rad, color)
            DrawSprite(laserpos, glr, glr, color_white)

            -- if !world then
            --     cam.IgnoreZ(false)
            -- end
        end
    end
end

function SWEP:GetDispersion()
    local owner = self:GetOwner()

    if vrmod and vrmod.IsPlayerInVR(owner) then return 0 end

    local very_high_Accuracy = self:IsVeryAccurateShoot()

    local hipdisp = self:GetBuff("HipDispersion")
    local sights  = self:GetState() == ArcCW.STATE_SIGHTS
    local sightdisp = self:GetBuff("SightsDispersion")

    local hip = very_high_Accuracy and math.min(sightdisp * 3, hipdisp) or hipdisp

    if sights then hip = Lerp(self:GetNWSightDelta(), sightdisp, hip) end

    local speed = owner:GetAbsVelocity():Length()
    local maxspeed = owner:GetWalkSpeed() * self:GetBuff("SpeedMult")
    if sights then maxspeed = maxspeed * self:GetBuff("SightedSpeedMult") end
    speed = math.Clamp(speed / maxspeed, 0, 2)

    local move_dispersion = very_high_Accuracy and math.min(30, self:GetBuff("MoveDispersion")) or self:GetBuff("MoveDispersion")

    local jump_dispersion = very_high_Accuracy and math.min(90, self:GetBuff("JumpDispersion")) or self:GetBuff("JumpDispersion")

    if owner:OnGround() or owner:WaterLevel() > 0 and owner:GetMoveType() != MOVETYPE_NOCLIP then
        hip = hip + speed * move_dispersion
    elseif owner:GetMoveType() != MOVETYPE_NOCLIP then
        hip = hip + math.max(speed * move_dispersion, jump_dispersion)
    end

    if self:InBipod() then hip = hip * (self.BipodDispersion * self:GetBuff_Mult("Mult_BipodDispersion")) end

    if GetConVar("arccw_mult_crouchdisp"):GetFloat() != 1 and owner:OnGround() and owner:Crouching() then
        hip = hip * GetConVar("arccw_mult_crouchdisp"):GetFloat()
    end

    if GetConVar("arccw_freeaim"):GetInt() == 1 and !sights then
        hip = hip ^ 0.9
    end

    --local t = hook.Run("ArcCW_ModDispersion", self, {dispersion = hip})
    --hip = t and t.dispersion or hip
    hip = self:GetBuff_Hook("Hook_ModDispersion", hip) or hip
    return hip
end

function SWEP:ShouldDrawCrosshair()
    return false
end
