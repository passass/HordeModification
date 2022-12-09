AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "horde_watchtower_base"
ENT.Horde_ThinkInterval = 4.5

ENT.Horde_WatchTowerLight_Enable = true
    ENT.Horde_WatchTowerLight_Color_Red = 0
    ENT.Horde_WatchTowerLight_Color_Green = 110
    ENT.Horde_WatchTowerLight_Color_Blue = 255
    ENT.Horde_WatchTowerLight_Brightness = 6
    ENT.Horde_WatchTowerLight_Size = 155

function ENT:HORDE_WatchTowerThink()
    local dmg = DamageInfo()
    dmg:SetAttacker(self.Horde_Owner)
    dmg:SetInflictor(self)
    dmg:SetDamageType(DMG_SHOCK)
    dmg:SetDamage(350)
    for _, ent in pairs(ents.FindInSphere(self:GetPos(), 200)) do
        if ent:IsValid() and ent:IsNPC() and ent:Health() > 0 and not HORDE:IsPlayerMinion(ent) then
            dmg:SetDamagePosition(ent:GetPos() + ent:OBBCenter())
            self:EmitSound("npc/vort/attack_shoot.wav")
            util.BlastDamageInfo(dmg, ent:GetPos(), 70)
            util.ParticleTracerEx("vortigaunt_beam", self:GetPos(), ent:GetPos() + ent:OBBCenter(), true, self:EntIndex(), -1)
            util.ParticleTracerEx("vortigaunt_beam_b", self:GetPos(), ent:GetPos() + ent:OBBCenter(), true, self:EntIndex(), -1)
            break
        end
    end
end