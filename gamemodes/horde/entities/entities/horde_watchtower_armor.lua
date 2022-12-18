AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "horde_watchtower_base"
ENT.Horde_ThinkInterval = 30

ENT.Horde_WatchTowerLight_Enable = true
    ENT.Horde_WatchTowerLight_Color_Red = 0
    ENT.Horde_WatchTowerLight_Color_Green = 35
    ENT.Horde_WatchTowerLight_Color_Blue = 255
    ENT.Horde_WatchTowerLight_Brightness = 5
    ENT.Horde_WatchTowerLight_Size = 115

function ENT:HORDE_WatchTowerThink()
    if self.Horde_ArmorBattery and self.Horde_ArmorBattery:IsValid() then
        self.Horde_ArmorBattery:Remove()
    end
    self.Horde_ArmorBattery = ents.Create("item_battery")
	self.Horde_ArmorBattery:AddEFlags(EFL_NO_DAMAGE_FORCES)
    self.Horde_ArmorBattery:SetPos(self:GetPos() - self:GetAngles():Forward() * 30)
    self.Horde_ArmorBattery:Spawn()
end