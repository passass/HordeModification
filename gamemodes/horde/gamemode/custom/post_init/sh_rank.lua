local plymeta = FindMetaTable("Player")

function plymeta:Horde_SetLevel(class_name, level)
    if not self:IsValid() then return end
    if not self.Horde_Levels then self.Horde_Levels = {} end
    if not class_name then return end
    self.Horde_Levels[class_name] = level
    local rank, rank_level = HORDE:LevelToRank(level)
    self:Horde_SetRankLevel(class_name, rank_level)
    self:Horde_SetRank(class_name, rank)

    if SERVER then
        self:Horde_CallClassHook("Horde_PrecomputePerkLevelBonus", self)
    end
end