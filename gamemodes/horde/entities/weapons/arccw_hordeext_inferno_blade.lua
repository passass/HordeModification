if not ArcCWInstalled then return end

if CLIENT then
    killicon.Add("arccw_hordeext_inferno_blade", "vgui/hud/arccw_horde_inferno_blade", Color(0, 0, 0, 255))
end

SWEP.Base = "arccw_horde_inferno_blade"

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize()
    BaseClass.Initialize( self )

    if SERVER then
        if self.Charged then
            net.Start("Horde_DemonicEdgeCharge")
                net.WriteBool(true)
            net.Send(self.Owner)
        else
            net.Start("Horde_DemonicEdgeCharge")
                net.WriteBool(false)
            net.Send(self.Owner)
        end
    else
        self:createCustomVM(self.ViewModel)
    end
end

function SWEP:SecondaryAttack()
    if self:GetNextSecondaryFire() > CurTime() then return end
    if self.Charged then
        self.Charged = nil
        self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
        self.Weapon:SetSubMaterial(3, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_blade_s")
        self.Weapon:SetSubMaterial(4, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_blade_s")
        self:StopSound(self.ChargeLoopSound)
        if SERVER then
            net.Start("Horde_DemonicEdgeCharge")
                net.WriteBool(false)
            net.Send(self.Owner)
        end
    else
        self:EmitSound(self.ChargeSound)
        self.Charged = true
        self.ChargeLoopCooldown = CurTime() + 1.25
        self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
        self.Weapon:SetSubMaterial(4, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_blade_s_fire")
        if SERVER then
            net.Start("Horde_DemonicEdgeCharge")
                net.WriteBool(true)
            net.Send(self.Owner)
        end
    end
end
if CLIENT then
    net.Receive("Horde_DemonicEdgeCharge", function()
        local charged = net.ReadBool()
        local self = LocalPlayer()
        local wep = self:GetWeapon("arccw_hordeext_inferno_blade")
        if !IsValid(wep) then return end
        if charged then
            wep:SetSubMaterial(4, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_blade_s_fire")
            wep.REAL_VM:SetSubMaterial(0, "")
            wep.REAL_VM:SetSubMaterial(1, "")
            wep.REAL_VM:SetSubMaterial(2, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_blade_s_fire")
            wep.REAL_VM:SetSubMaterial(3, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_blade_s_fire")
            self.Client_Charged = truew
        else
            wep:SetSubMaterial(3, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_blade_s")
            wep:SetSubMaterial(4, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_blade_s")
            wep.REAL_VM:SetSubMaterial(0, "")
            wep.REAL_VM:SetSubMaterial(1, "")
            wep.REAL_VM:SetSubMaterial(2, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_sword_s")
            wep.REAL_VM:SetSubMaterial(3, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_blade_s")
            self.Client_Charged = nil
        end
    end)
end

function SWEP:Hook_PostBash(info)
    if not self.Charged or not info.tr.Hit then return end
    if SERVER then
        for _, ent in pairs(ents.FindInSphere(info.tr.HitPos, 75)) do
            if (HORDE:IsPlayerOrMinion(ent) == true) then
            elseif ent:IsNPC() then
                local dmg = DamageInfo()
                dmg:SetDamage(50)
                dmg:SetDamageType(DMG_BURN)
                dmg:SetAttacker(self.Owner)
                dmg:SetInflictor(self)
                dmg:SetDamagePosition(info.tr.HitPos)
                ent:TakeDamageInfo(dmg)
            end
        end
        self:LSS(info.tr.HitPos)
    end
end

function SWEP:Hook_Think()
    --if self.Charged then
    --    ParticleEffectAttach("eml_generic_shock_ligtning", PATTACH_POINT_FOLLOW, self.Weapon, 0)
    --end
    if self.Charged then
        if self.ChargeLoopCooldown <= CurTime() then
            self.Weapon:EmitSound(self.ChargeLoopSound)
            self.ChargeLoopCooldown = CurTime() + 10
        end
        if SERVER and self.Immolate_Last <= CurTime() and self.Owner and self.Owner:IsValid() then
            local dmg = DamageInfo()
            dmg:SetDamage(1)
            dmg:SetDamageType(DMG_BURN)
            dmg:SetAttacker(self.Owner)
            dmg:SetInflictor(self)
            dmg:SetDamagePosition(self:GetPos())
            self.Owner:TakeDamageInfo(dmg)
            self.Immolate_Last = CurTime() + 1
        end
    end

    if CLIENT then
        if self.Charged and not self.Client_Charged then
            self.Weapon:SetSubMaterial(4, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_blade_s_fire")
            self.REAL_VM:SetSubMaterial(0, "")
            self.REAL_VM:SetSubMaterial(1, "")
            self.REAL_VM:SetSubMaterial(2, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_blade_s_fire")
            self.REAL_VM:SetSubMaterial(3, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_blade_s_fire")
            self.Client_Charged = true
        elseif not self.Charged and self.Client_Charged then
            self.Weapon:SetSubMaterial(3, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_blade_s")
            self.Weapon:SetSubMaterial(4, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_blade_s")
            self.REAL_VM:SetSubMaterial(0, "")
            self.REAL_VM:SetSubMaterial(1, "")
            self.REAL_VM:SetSubMaterial(2, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_sword_s")
            self.REAL_VM:SetSubMaterial(3, "models/weapons/inferno_blade/mtl_t6_wpn_pulwar_blade_s")
            self.Client_Charged = nil
        end

        if self.Owner.Client_Charged then
            self.dlight = DynamicLight(0)
            self.dlight.Pos = self:GetPos()
            self.dlight.r = 200
            self.dlight.g = 100
            self.dlight.b = 0
            self.dlight.Brightness = 4
            self.dlight.Size = 100
            self.dlight.Decay = 1000
            self.dlight.DieTime = CurTime() + 0.2
        end
    end
end