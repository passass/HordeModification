AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "horde_watchtower_base"
ENT.Horde_ThinkInterval = 30

ENT.Horde_WatchTowerLight_Enable = true
    ENT.Horde_WatchTowerLight_Color_Red = 50
    ENT.Horde_WatchTowerLight_Color_Green = 255
    ENT.Horde_WatchTowerLight_Color_Blue = 50
    ENT.Horde_WatchTowerLight_Brightness = 6
    ENT.Horde_WatchTowerLight_Size = 160

function ENT:HORDE_WatchTowerThink()
    if self.Horde_HealthKit and self.Horde_HealthKit:IsValid() then
        self.Horde_HealthKit:Remove()
    end
    self.Horde_HealthKit = ents.Create("item_healthkit")
	self.Horde_HealthKit:AddEFlags(EFL_NO_DAMAGE_FORCES)
    self.Horde_HealthKit:SetPos(self:GetPos() - self:GetAngles():Forward() * 30)
    self.Horde_HealthKit:Spawn()
end