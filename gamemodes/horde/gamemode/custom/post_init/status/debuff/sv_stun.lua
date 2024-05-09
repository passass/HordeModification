local entmeta = FindMetaTable("Entity")

function entmeta:Horde_AddStun(duration)
    if !IsValid(self) then return end
    if self.Horde_Stunned then return end
    if self:IsPlayer() then
        self.Horde_Stunned = true
        timer.Create("Horde_RemoveStun" .. self:GetCreationID(), 5, 1, function()
            if not self:IsValid() then return end
            self.Horde_Stunned = nil
        end)
        return
    end
    if self:Health() <= 0 then return end
    if not self.Base then
        self:NextThink(CurTime() + 5)
    elseif self:IsNPC() then--self.Base == "npc_vj_creature_base" or self.Base == "npc_vj_human_base" then
        --self:SetSchedule(SCHED_NPC_FREEZE)
        self.Horde_Stunned = true
        HORDE:TimeStop_freeze_npc(self)
        timer.Create("Horde_RemoveStun" .. self:GetCreationID(), 5, 1, function()
            if not self:IsValid() then return end
            HORDE:TimeStop_unfreeze_npc(self)
            self.Horde_Stunned = nil
        end)
    end
end